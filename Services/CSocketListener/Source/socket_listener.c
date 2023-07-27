#undef UNICODE

#ifdef __linux__ 
    #include <string.h>
    #include <stdio.h>
    #include <sys/types.h>
    #include <sys/socket.h>
    #include <netinet/in.h>
    #include <arpa/inet.h>
    #include <netdb.h>
    #include <unistd.h>
    #include <errno.h>
    #include <fcntl.h> // for open
    #include <wchar.h>

    #define INVALID_SOCKET -1
    #define NO_ERROR 0
    #define SOCKET_ERROR -1
    #define ZeroMemory(Destination,Length) memset((Destination),0,(Length))

    inline void nopp() {}

    #define SLEEPFUN usleep
    #define SLEEPTIME 0.01

#elif _WIN32
    #define WIN32_LEAN_AND_MEAN
    #include <windows.h>
    #include <winsock2.h>
    #include <ws2tcpip.h>

    #define SLEEPFUN Sleep
    #define SLEEPTIME 1

    #ifdef __cplusplus
    extern "C" {
    #endif
       void WSAAPI freeaddrinfo( struct addrinfo* );
    
       int WSAAPI getaddrinfo( const char*, const char*, const struct addrinfo*,
                     struct addrinfo** );
    
       int WSAAPI getnameinfo( const struct sockaddr*, socklen_t, char*, DWORD,
                    char*, DWORD, int );
    #ifdef __cplusplus
    }
    #endif    
#else
    #include <string.h>
    #include <stdio.h>
    #include <stdlib.h>

    #include <sys/types.h>
    #include <sys/socket.h>
    #include <netinet/in.h>
    #include <arpa/inet.h>
    #include <netdb.h>
    #include <unistd.h>
    #include <errno.h>
    #include <fcntl.h> // for open
    #include <wchar.h>
 

    #define INVALID_SOCKET -1
    #define NO_ERROR 0
    #define SOCKET_ERROR -1
    #define ZeroMemory(Destination,Length) memset((Destination),0,(Length))

    #define SLEEPFUN usleep
    #define SLEEPTIME 0.01

    inline void nopp() {}
#endif

#if defined(_WIN32)
//Windows already defines SOCKET
#define ISVALIDSOCKET(s) ((s) != INVALID_SOCKET)
#define CLOSESOCKET(s) closesocket(s)
#define GETSOCKETERRNO() (WSAGetLastError())
#define WSACLEANUP (WSACleanup())
#else
#define SOCKET int
#define ISVALIDSOCKET(s) ((s) >= 0)
#define CLOSESOCKET(s) close(s)
#define GETSOCKETERRNO() (errno)
#define WSACLEANUP 
#define BYTE uint8_t
#endif

#include <stdlib.h>
#include <stdio.h>



#include "WolframLibrary.h"
#include "WolframIOLibraryFunctions.h"
#include "WolframNumericArrayLibrary.h"

int garbageLength = 0;
int* garbageSockets;

DLLEXPORT mint WolframLibrary_getVersion( ) {
    return WolframLibraryVersion;
}

DLLEXPORT int WolframLibrary_initialize(WolframLibraryData libData) {

    return 0;
}

DLLEXPORT void WolframLibrary_uninitialize(WolframLibraryData libData) {
    return;
}

typedef struct SocketTaskArgs_st {
    WolframNumericArrayLibrary_Functions numericLibrary;
    WolframIOLibrary_Functions ioLibrary;
    SOCKET listentSocket; 
}* SocketTaskArgs; 



static void ListenSocketTask(mint asyncObjID, void* vtarg)
{
    SOCKET *clients = (SOCKET*)malloc(2 * sizeof(SOCKET)); 
    int clientsLength = 0;
    int clientsMaxLength = 2; 

    int iResult; 
    unsigned long int iMode = 1; 

    size_t buflen = 8192; 
    BYTE *buf = malloc(8192 * sizeof(BYTE)); 
    mint dims[1]; 
    MNumericArray data;

    SOCKET clientSocket = INVALID_SOCKET;
	SocketTaskArgs targ = (SocketTaskArgs)vtarg; 
    SOCKET listenSocket = targ->listentSocket; 
	WolframIOLibrary_Functions ioLibrary = targ->ioLibrary;
    WolframNumericArrayLibrary_Functions numericLibrary = targ->numericLibrary;

	DataStore ds;
    free(targ); 
    
    #ifdef _WIN32 
    iResult = ioctlsocket(listenSocket, FIONBIO, &iMode); 
    if (iResult != NO_ERROR) {
        printf("ioctlsocket failed with error: %d\n", iResult);
    }
    #else
    //iResult = fcntl(listenSocket, SOCK_NONBLOCK | SOCK_CLOEXEC, &iMode);
    //fcntl(listenSocket, F_SETFL, O_NONBLOCK);
    int flags = fcntl(listenSocket, F_GETFL);
    fcntl(listenSocket, F_SETFL, flags | O_NONBLOCK);

    

    #endif


    
	
	while(ioLibrary->asynchronousTaskAliveQ(asyncObjID))
	{
        //SLEEPFUN(1);
        //printf("TICK!");
        //if (blocked == 1) continue;
      
        clientSocket = accept(listenSocket, NULL, NULL);

        //if (blocked == 1) continue;

        //printf("TICK!\n %d\n", clientSocket);   

        if (clientSocket != INVALID_SOCKET) {
          
            printf("NEW CLIENT: %d\n", clientSocket);
            clients[clientsLength++] = clientSocket; 

            if (clientsLength == clientsMaxLength) {
                clientsMaxLength *= 2; 
                clients = (SOCKET*)realloc(clients, clientsMaxLength * sizeof(SOCKET)); 
            }
        } else {
             if (errno == EWOULDBLOCK) {
                //printf("No pending connections; sleeping for one second.\n");
                //sleep(1);
                SLEEPFUN(1);
              } else {
                perror("error when accepting connection");
                exit(1);
              }  
        }

        for (size_t i = 0; i < clientsLength; i++)
        {
            if (clients[i] == INVALID_SOCKET) continue;

            iResult = recv(clients[i], buf, buflen, 0); 
            if (iResult > 0){            
                printf("CURRENT NUMBER OF CLIENTS: %d\n", clientsLength);
                printf("MAX NUMBER OF CLIENTS: %d\n", clientsMaxLength);
                printf("RECEIVED %d BYTES\n", iResult);
                dims[0] = iResult; 
                numericLibrary->MNumericArray_new(MNumericArray_Type_UBit8, 1, dims, &data); 
                memcpy(numericLibrary->MNumericArray_getData(data), buf, iResult);
                
                ds = ioLibrary->createDataStore();
                ioLibrary->DataStore_addInteger(ds, listenSocket);
                ioLibrary->DataStore_addInteger(ds, clients[i]);
                ioLibrary->DataStore_addMNumericArray(ds, data);

                ioLibrary->raiseAsyncEvent(asyncObjID, "RECEIVED_BYTES", ds);
                printf("Done!!!\n");
            }
        }
	}

    printf("STOP ASYNCHRONOUS TASK %lld\n", asyncObjID); 
    for (size_t i = 0; i < clientsLength; i++)
    {
        CLOSESOCKET(clients[i]);
    }
    CLOSESOCKET(listenSocket);

    free(clients);
    free(buf);
}

DLLEXPORT int create_server(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res) 
{
    int iResult; 
    char* listenPortName = MArgument_getUTF8String(Args[0]); 
    SOCKET listenSocket = INVALID_SOCKET; 
    WolframIOLibrary_Functions ioLibrary = libData->ioLibraryFunctions; 
    WolframNumericArrayLibrary_Functions numericLibrary = libData->numericarrayLibraryFunctions;
    
    #ifdef __linux__ 
    #elif _WIN32
    WSADATA wsaData; 
    iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
    if (iResult != 0) {
        printf("WSAStartup failed with error: %d\n", iResult);
        return 1;
    }
    #else
    #endif
    
    struct addrinfo *address = NULL; 
    struct addrinfo addressHints; 

    ZeroMemory(&addressHints, sizeof(addressHints));
    addressHints.ai_family = AF_INET;
    addressHints.ai_socktype = SOCK_STREAM;
    addressHints.ai_protocol = IPPROTO_TCP;
    addressHints.ai_flags = AI_PASSIVE;

    iResult = getaddrinfo(NULL, listenPortName, &addressHints, &address); 
    if ( iResult != 0 ) {
        printf("getaddrinfo failed with error: %d\n", iResult);
        WSACLEANUP;
        return 1;
    }
    
    #ifdef _WIN32
    listenSocket = socket(address->ai_family, address->ai_socktype, address->ai_protocol);
    #else
    listenSocket = socket(address->ai_family, address->ai_socktype, address->ai_protocol);
    #endif
    if (!ISVALIDSOCKET(listenSocket)) {
        printf("socket failed with error: %d\n", GETSOCKETERRNO());
        freeaddrinfo(address);
        WSACLEANUP;
        return 1;
    }

    iResult = bind(listenSocket, address->ai_addr, (int)address->ai_addrlen);
    if (iResult == SOCKET_ERROR) {
        printf("bind failed with error: %d\n", GETSOCKETERRNO());
        freeaddrinfo(address);
        CLOSESOCKET(listenSocket);
        WSACLEANUP;
        return 1;
    }

    freeaddrinfo(address);
    #ifdef _WIN32
    iResult = listen(listenSocket, SOMAXCONN);
    #else
    iResult = listen(listenSocket, SOMAXCONN);
    #endif

    
    if (iResult == SOCKET_ERROR) {
        printf("listen failed with error: %d\n", GETSOCKETERRNO());
        CLOSESOCKET(listenSocket);
        WSACLEANUP;
        return 1;
    }

    printf("LISTEN SOCKET\n"); 

    SocketTaskArgs threadArg = (SocketTaskArgs)malloc(sizeof(struct SocketTaskArgs_st));
    threadArg->ioLibrary=ioLibrary; 
    threadArg->listentSocket=listenSocket;
    threadArg->numericLibrary=numericLibrary;
    mint asyncObjID;
    asyncObjID = ioLibrary->createAsynchronousTaskWithThread(ListenSocketTask, threadArg);

    MArgument_setInteger(Res, asyncObjID); 
    return LIBRARY_NO_ERROR; 
}

size_t send_full_msg(int sock_fd, char *write_buf, size_t write_buf_length, size_t chunk_s) {

        fd_set set;
        struct timeval socktimeout;
        int rv;
        FD_ZERO(&set); /* clear the set */
        FD_SET(sock_fd, &set); /* add our file descriptor to the set */

        socktimeout.tv_sec = 6;
        socktimeout.tv_usec = 0;


        //log.msg("Preparing to send an entire message through. msg size is...." + to_string(write_buf_length));

        //const size_t chunk_size = 16000;        //will read 16000 bytes at a time
        size_t chunk_size = chunk_s;
        if (write_buf_length < chunk_size) chunk_size = write_buf_length;
        //fcntl(sock_fd, F_SETFL, O_NONBLOCK); //makes the socket nonblocking

        //log.msg("Set socket non blocking..." + to_string(write_buf_length));

        //struct timeval time_val_struct;
        //time_val_struct.tv_sec = 0;
        //time_val_struct.tv_usec = 0;
        //setsockopt(sock_fd, SOL_SOCKET,SO_SNDTIMEO,(const char*)&time_val_struct,sizeof(time_val_struct));
        //log.msg("Turned off socket timeout");


        size_t pos_in_buf = 0; //starts at 0 and is incremented to write to the right location
        ssize_t size_sent = 0; //the size of the values obtained from a recv

        int num_neg_count=0;
     
        //log.msg("Entering loop non block on write...");
        int total_failed = 0;


        while (pos_in_buf < write_buf_length)
        {
   
            rv = select(sock_fd+1, NULL, &set, NULL, &socktimeout);

            if (total_failed > 32) return -1;

            if(rv==0){
                //log.msg("Select timeout...num neg count is: " + to_string(num_neg_count));
                //timeout
                num_neg_count++;
                total_failed++;
                if(num_neg_count > 3){ //three timeouts in a row
                    return pos_in_buf == 0 ? -1 : pos_in_buf;
                }else{
                    continue;
                }
            }
            else if(rv==-1){
                //do nothing if this hits the timeout it will break out
                //log.msg("Select error...num neg count is: " + to_string(num_neg_count));
                total_failed++;
            }
            else{
                //there is data to be handled
                //log.msg("Select is saying socket is available for sending...");
                //remaining buf size is the total buf length minus the position (plus 1?)
                size_t remaining_buf_size = write_buf_length - pos_in_buf;                                     //avoids a segmentation fault

                size_t bytes_to_write = remaining_buf_size > chunk_size ? chunk_size : remaining_buf_size; //works to prevent a segmentation fault
                size_sent = send(sock_fd, write_buf+pos_in_buf, bytes_to_write, 0);

                //log.msg("Sent bytes..." + to_string(size_sent));
                //log.msg("Pos in buf..." + to_string(pos_in_buf));
                //log.msg("Bytes to write..." + to_string(bytes_to_write));
                //log.msg("Remaining buf size..." + to_string(remaining_buf_size));
                
                // log.msg("size_recv: " + to_string(size_recv));
                // log.msg("bytes to read: " + to_string(bytes_to_read));

                if (size_sent < 0)
                {
                    perror("Socket send returned -1");
                    total_failed++;
                    num_neg_count++; //if there are 3 consecutive failed writes we will quit
                    //this_thread::sleep_for(chrono::microseconds(100)); //needs to wait to try and get more data
                    continue;
                }else{
                    num_neg_count = 0; //reset the failed writes
                    pos_in_buf += size_sent;
                }

                //log.msg("Data received! Length: " + to_string(size_recv));

            }

            //cout << "Duration: " << duration.count() << endl;
            //cout << "Timeout: " << timeout.count() << endl;

            if (num_neg_count>3) //timeout or 3 consecutive failed writes
            {
                //log.msg("Timeout exceeded");
                return -1;
            }


            
        }

        //log.msg("Total data length sent was: " + to_string(pos_in_buf));
        if(pos_in_buf == 0)
            return -1; //error, no data received

        return pos_in_buf; //the full size of the message received
    }


DLLEXPORT int socket_write(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res){
    int iResult; 
    WolframNumericArrayLibrary_Functions numericLibrary = libData->numericarrayLibraryFunctions; 
    SOCKET clientId = MArgument_getInteger(Args[0]); 
    mint trueLength = libData->numericarrayLibraryFunctions->MNumericArray_getFlattenedLength(MArgument_getMNumericArray(Args[1]));

    BYTE *bytes = numericLibrary->MNumericArray_getData(MArgument_getMNumericArray(Args[1]));      
    mint bytesLen = MArgument_getInteger(Args[2]); 

    printf("sending stuff....\n");
    printf("real length: %lld, claimed: %lld\n", trueLength, bytesLen);



    //iResult = send(clientId, bytes, bytesLen, MSG_NOSIGNAL); 
    iResult =send_full_msg(clientId, bytes, bytesLen, 16000);
    if (iResult == SOCKET_ERROR) {
        wprintf(L"send failed with error: %d\n", GETSOCKETERRNO());
        CLOSESOCKET(clientId);
        MArgument_setInteger(Res, GETSOCKETERRNO()); 
        return LIBRARY_FUNCTION_ERROR; 
    }


    
    
    printf("WRITE %lld BYTES\n", bytesLen);

    MArgument_setInteger(Res, 0); 
    return LIBRARY_NO_ERROR; 
}

DLLEXPORT int socket_write_string(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res){
    int iResult; 
    WolframNumericArrayLibrary_Functions numericLibrary = libData->numericarrayLibraryFunctions; 
    SOCKET clientId = MArgument_getInteger(Args[0]); 
    char *text = MArgument_getUTF8String(Args[1]);      
    int textLen = MArgument_getInteger(Args[2]); 

    //iResult = send(clientId, text, textLen, 0); 
    iResult = send_full_msg(clientId, text, textLen, 16000);
    if (iResult == SOCKET_ERROR) {
        wprintf(L"send failed with error: %d\n", GETSOCKETERRNO());
        CLOSESOCKET(clientId);
        MArgument_setInteger(Res, GETSOCKETERRNO()); 
        return LIBRARY_FUNCTION_ERROR; 
    }

    printf("WRITE %d BYTES\n", textLen);
    MArgument_setInteger(Res, 0); 
    return LIBRARY_NO_ERROR; 
}

DLLEXPORT int close_socket(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res){
    SOCKET s = MArgument_getInteger(Args[0]);
    MArgument_setInteger(Res, CLOSESOCKET(s));
    return LIBRARY_NO_ERROR; 
}

DLLEXPORT int stop_server(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res){
    mint taskId = MArgument_getInteger(Args[0]); 
    MArgument_setInteger(Res, libData->ioLibraryFunctions->removeAsynchronousTask(taskId)); 
    return LIBRARY_NO_ERROR; 
}
