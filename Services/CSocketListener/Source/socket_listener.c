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

    #define INVALID_SOCKET -1
    #define NO_ERROR 0
    #define SOCKET_ERROR -1
    #define ZeroMemory(Destination,Length) memset((Destination),0,(Length))

    inline void nopp() {}
#elif _WIN32
    #define WIN32_LEAN_AND_MEAN
    #include <windows.h>
    #include <winsock2.h>
    #include <ws2tcpip.h>

    #define SLEEP Sleep

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

    #define SLEEP sleep

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
    #else
    iResult = fcntl(listenSocket, O_NONBLOCK, &iMode); 
    #endif
    if (iResult != NO_ERROR) {
        printf("ioctlsocket failed with error: %d\n", iResult);
    }
	
	while(ioLibrary->asynchronousTaskAliveQ(asyncObjID))
	{
        SLEEP(1);
        clientSocket = accept(listenSocket, NULL, NULL);
        if (clientSocket != INVALID_SOCKET) {
            printf("NEW CLIENT: %d\n", clientSocket);
            clients[clientsLength++] = clientSocket; 

            if (clientsLength == clientsMaxLength){
                clientsMaxLength *= 2; 
                clients = (SOCKET*)realloc(clients, clientsMaxLength * sizeof(SOCKET)); 
            }
        }

        for (size_t i = 0; i < clientsLength; i++)
        {
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
            }
        }
	}

    printf("STOP ASYNCHRONOUS TASK %d\n", asyncObjID); 
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
    
    listenSocket = socket(address->ai_family, address->ai_socktype, address->ai_protocol);
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

    iResult = listen(listenSocket, SOMAXCONN);
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

DLLEXPORT int socket_write(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res){
    int iResult; 
    WolframNumericArrayLibrary_Functions numericLibrary = libData->numericarrayLibraryFunctions; 
    SOCKET clientId = MArgument_getInteger(Args[0]); 
    BYTE *bytes = numericLibrary->MNumericArray_getData(MArgument_getMNumericArray(Args[1]));      
    int bytesLen = MArgument_getInteger(Args[2]); 

    iResult = send(clientId, bytes, bytesLen, 0); 
    if (iResult == SOCKET_ERROR) {
        wprintf(L"send failed with error: %d\n", GETSOCKETERRNO());
        CLOSESOCKET(clientId);
        MArgument_setInteger(Res, GETSOCKETERRNO()); 
        return LIBRARY_FUNCTION_ERROR; 
    }
    
    printf("WRITE %d BYTES\n", bytesLen);
    MArgument_setInteger(Res, 0); 
    return LIBRARY_NO_ERROR; 
}

DLLEXPORT int socket_write_string(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res){
    int iResult; 
    WolframNumericArrayLibrary_Functions numericLibrary = libData->numericarrayLibraryFunctions; 
    SOCKET clientId = MArgument_getInteger(Args[0]); 
    char *text = MArgument_getUTF8String(Args[1]);      
    int textLen = MArgument_getInteger(Args[2]); 

    iResult = send(clientId, text, textLen, 0); 
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
