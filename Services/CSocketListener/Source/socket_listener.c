#undef UNICODE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <uv.h>

#include "WolframLibrary.h"
#include "WolframIOLibraryFunctions.h"
#include "WolframNumericArrayLibrary.h"

uv_loop_t *loop;

int uv_loop_running = -1;

struct srv
{
    uv_stream_t* stream;
    int id;
    struct sockaddr_in addr;
    mint asyncObjID;
};

typedef struct srv server;
server* servers;
int nservers = 0;

struct cli
{
    uv_stream_t* stream;
    uv_stream_t* parent;
    int id;
    int state;
};

typedef struct cli client;
client* clients;
int nclients = 0;

typedef struct {
    uv_write_t req;
    uv_buf_t buf;
} write_req_t;

void free_write_req(uv_write_t *req) {
    //write_req_t *wr = (write_req_t*) req;
    //Here it fucks up
    //free(wr->buf.base);
    //free(wr);
}

void alloc_buffer(uv_handle_t *handle, size_t suggested_size, uv_buf_t *buf) {
    buf->base = (char*) malloc(suggested_size);
    buf->len = suggested_size;
}

int fetchClientId(uv_stream_t *client) {
    for (int i=0; i<nclients; ++i)
        if (clients[i].stream == client) return i;
    
    fprintf(stderr, "FUCK. Client was not found. Terminating...\n");
    return -1;
}

int fetchStreamId(uv_stream_t *s) {
    for (int i=0; i<nservers; ++i)
        if (servers[i].stream == s) return i;
    
    fprintf(stderr, "FUCK. Server was not found. Terminating...\n");
    return -1;
}

WolframIOLibrary_Functions ioLibrary;
WolframNumericArrayLibrary_Functions numericLibrary;
mint asyncObjID;

typedef struct SocketTaskArgs_st {
    WolframNumericArrayLibrary_Functions numericLibrary;
    WolframIOLibrary_Functions ioLibrary;
    mint garbage; 
}* SocketTaskArgs; 

DLLEXPORT mint WolframLibrary_getVersion( ) {
    return WolframLibraryVersion;
}

DLLEXPORT int WolframLibrary_initialize(WolframLibraryData libData) {
    servers = (server*)malloc(sizeof(server)*10);
    nservers = 0;

    clients = (client*)malloc(sizeof(client)*2048*8);
    nclients = 0;

    loop = uv_default_loop();
    

    ioLibrary = libData->ioLibraryFunctions;
    numericLibrary = libData->numericarrayLibraryFunctions;

    return 0;
}

DLLEXPORT void WolframLibrary_uninitialize(WolframLibraryData libData) {
    return;
}

void pipeBufData (uv_buf_t buf, uv_stream_t *client) {
    int clientId = fetchClientId(client);
    int streamId = fetchStreamId(clients[clientId].parent);

    mint dims[1]; 
    MNumericArray data;

	DataStore ds;

    printf("CURRENT ID OF CLIENT: %d\n", clientId);

    printf("RECEIVED %d BYTES\n", buf.len);
    
    dims[0] = buf.len; 
    numericLibrary->MNumericArray_new(MNumericArray_Type_UBit8, 1, dims, &data); 
    memcpy(numericLibrary->MNumericArray_getData(data), buf.base, buf.len);
                
    ds = ioLibrary->createDataStore();
    ioLibrary->DataStore_addInteger(ds, streamId);
    ioLibrary->DataStore_addInteger(ds, clientId);
    ioLibrary->DataStore_addMNumericArray(ds, data);

    printf("raise async event %d for server %d and client %d\n", asyncObjID, streamId, clientId);
    ioLibrary->raiseAsyncEvent(asyncObjID, "RECEIVED_BYTES", ds);
}



void echo_read(uv_stream_t *client, ssize_t nread, const uv_buf_t *buf) {
    printf("echo read\n");
    if (nread > 0) {
        uv_buf_t b = uv_buf_init(buf->base, nread);
        pipeBufData(b, client);
        free(b.base);   
        return;
    }

    if (nread < 0) {
        if (nread != UV_EOF)
            fprintf(stderr, "Read error %s\n", uv_err_name(nread));

        //uv_close((uv_handle_t*) client, NULL);
        int uid = fetchClientId(client);
        printf("writeerror !\n");
        printf("making %d closed manually!\n", uid);
        uv_close((uv_handle_t*) clients[uid].stream, NULL);
        clients[uid].state = -1;   
        //printf("we closed socket: %d ;)))\n", fetchClientId(client));
        //clients[fetchClientId(client)].state = 2;
        //mb one can notify mathematica about it
    }

    free(buf->base);
}

void on_new_connection(uv_stream_t *server, int status) {
    if (status < 0) {
        fprintf(stderr, "New connection error %s\n", uv_strerror(status));
        // error!
        return;
    }

    printf("New connection for %d\n", nclients);

    uv_tcp_t *c = (uv_tcp_t*) malloc(sizeof(uv_tcp_t));
    clients[nclients].stream = (uv_stream_t*)c;
    clients[nclients].parent = (uv_stream_t*)server;
    clients[nclients].id = nclients;
    clients[nclients].state = 0;

    nclients++;

    uv_tcp_init(loop, c);

    if (uv_accept(server, (uv_stream_t*) c) == 0) {
        printf("uv start reading");
        uv_read_start((uv_stream_t*) c, alloc_buffer, echo_read);
    } else {
        printf("not accepted for %d", nclients-1);
        clients[nclients].state = -1;
        uv_close((uv_handle_t*) c, NULL);
    }

    
}

static void uvTask(mint asyncObjID, void* vtarg)
{
    fprintf(stderr, "\nHee uvTask: %d\n", asyncObjID);
    printf("Event-Loop started! \n");
    uv_run(loop, UV_RUN_DEFAULT);
}


DLLEXPORT int run_uvloop(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res) {
    printf("creating async task...\n");
    SocketTaskArgs threadArg = (SocketTaskArgs)malloc(sizeof(struct SocketTaskArgs_st));
    threadArg->ioLibrary = libData->ioLibraryFunctions; 
    threadArg->numericLibrary = libData->numericarrayLibraryFunctions;
    ioLibrary = libData->ioLibraryFunctions;
    numericLibrary = libData->numericarrayLibraryFunctions;
    
        
    asyncObjID = ioLibrary->createAsynchronousTaskWithThread(uvTask, threadArg);

    MArgument_setInteger(Res, asyncObjID); 
    return LIBRARY_NO_ERROR;     
}

DLLEXPORT int create_server(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res) 
{
    char* listenAddrName = MArgument_getUTF8String(Args[0]); 
    char* listenPortName = MArgument_getUTF8String(Args[1]); 
  
    //loop = uv_default_loop();

    uv_tcp_t* s = (uv_tcp_t*)malloc(sizeof(uv_tcp_t));
    servers[nservers].stream = (uv_stream_t*)s;
    servers[nservers].id = nservers * 7;


    uv_tcp_init(loop, s);

    uv_ip4_addr(listenAddrName, atoi(listenPortName), &(servers[nservers].addr));
    uv_tcp_bind(s, (const struct sockaddr*)&(servers[nservers].addr), 0);
    int r = uv_listen((uv_stream_t*) s, 128, on_new_connection);
    if (r) {
        fprintf(stderr, "Listen error %s\n", uv_strerror(r));
        return 1;
    }

    printf("LISTEN SOCKET at %s:%d\n", listenAddrName, atoi(listenPortName)); 

    //MArgument_setInteger(Res, nservers); 

    servers[nservers].asyncObjID = nservers;

    printf("server: %d\n", nservers); 

    MArgument_setInteger(Res, nservers); 
    nservers++;

    return LIBRARY_NO_ERROR; 
}

void echo_write(uv_write_t *req, int status) {
    printf("echo write\n");
    if (status) {
        int uid = fetchClientId(req->handle);
        printf("writeerror !\n");
        printf("making %d closed manually!\n", uid);
        uv_close((uv_handle_t*) clients[uid].stream, NULL);
        clients[uid].state = -1;        
    }

    printf("free write req !\n");
    free_write_req(req);
}

DLLEXPORT int socket_write(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res){

    
    int iResult; 
    WolframNumericArrayLibrary_Functions numericLibrary = libData->numericarrayLibraryFunctions; 
    int clientId = MArgument_getInteger(Args[0]); 

    if (clients[clientId].state == -1) {
        printf("Client %d is closed already!\n", clientId);
        MArgument_setInteger(Res, -1);
        return LIBRARY_NO_ERROR;
    }    

    if (uv_is_writable(clients[clientId].stream) == 0) {
        printf("Client %d i now writtable anymore!\n", clientId);
        uv_close((uv_handle_t*) clients[clientId].stream, NULL);
        clients[clientId].state = -1;
        MArgument_setInteger(Res, -1);
        return LIBRARY_NO_ERROR;
    }

    char *bytes = numericLibrary->MNumericArray_getData(MArgument_getMNumericArray(Args[1]));      
    mint bytesLen = MArgument_getInteger(Args[2]); 

    printf("*** sending stuff.... to socket %d\n", clientId);
    write_req_t *req = (write_req_t*) malloc(sizeof(write_req_t));
    req->buf = uv_buf_init(bytes, bytesLen);

    int st = uv_write((uv_write_t*) req, clients[clientId].stream, &req->buf, 1, echo_write);
    //ON ERROR send expection to mathematica
    printf("*** done with %d ***\n", st);

    MArgument_setInteger(Res, 0); 
    return LIBRARY_NO_ERROR; 
}

DLLEXPORT int socket_write_string(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res){
    int iResult; 
    WolframNumericArrayLibrary_Functions numericLibrary = libData->numericarrayLibraryFunctions; 
    int clientId = MArgument_getInteger(Args[0]); 

    if (clients[clientId].state == -1) {
        printf("Client %d is closed already!\n", clientId);
        MArgument_setInteger(Res, -1);
        return LIBRARY_NO_ERROR;
    }    

    if (uv_is_writable(clients[clientId].stream) == 0) {
        printf("Client %d i now writtable anymore!\n", clientId);
        uv_close((uv_handle_t*) clients[clientId].stream, NULL);
        clients[clientId].state = -1;
        MArgument_setInteger(Res, -1);
        return LIBRARY_NO_ERROR;
    }

    char *bytes = MArgument_getUTF8String(Args[1]);      
    mint bytesLen = MArgument_getInteger(Args[2]); 

    printf("*** sending stuff.... to socket %d\n", clientId);
    write_req_t *req = (write_req_t*) malloc(sizeof(write_req_t));
    req->buf = uv_buf_init(bytes, bytesLen);

    int st = uv_write((uv_write_t*) req, clients[clientId].stream, &req->buf, 1, echo_write);
    //ON ERROR send expection to mathematica
    printf("*** done with %d ***\n", st);

    MArgument_setInteger(Res, 0); 
    return LIBRARY_NO_ERROR; 
}

DLLEXPORT int close_socket(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res){
    int clientId = MArgument_getInteger(Args[0]); 

    printf("Client %d was closed by Wolfram!\n", clientId);
    uv_close((uv_handle_t*) clients[clientId].stream, NULL);
    clients[clientId].state = -1;    
    
    MArgument_setInteger(Res, 0);
    return LIBRARY_NO_ERROR; 
}

DLLEXPORT int stop_server(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res){
    exit(-1);
    //MArgument_setInteger(Res, libData->ioLibraryFunctions->removeAsynchronousTask(taskId)); 
    return LIBRARY_NO_ERROR; 
}

