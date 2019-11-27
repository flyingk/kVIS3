/*
 * mavlink_tx.c
 *
 *  Created on: 26 Nov 2019
 *      Author: kai.lehmkuehler
 */
#include "math.h"
#include "mex.h"
#include "string.h"
#include "stdint.h"
#include "stdbool.h"

#include "mavlink_udp_mex.h"

#ifdef _WIN32 /* WIN32 SYSTEM */
#include <winsock2.h>
#include <ws2tcpip.h>
#pragma comment(lib,"ws2_32.lib") //Winsock Library
#elif (__APPLE__ || __linux)
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#endif

extern XPCSocket sock;

/*****************************************************************************/
/****                       Low Level UDP functions                       ****/
/*****************************************************************************/
XPCSocket openUDP(const char *xpIP)
{
    return aopenUDP(xpIP, 49009, 0);
}

XPCSocket aopenUDP(const char *xpIP, unsigned short xpPort, unsigned short port)
{
    // Setup Port
    struct sockaddr_in recvaddr;
    recvaddr.sin_family = AF_INET;
    recvaddr.sin_addr.s_addr = INADDR_ANY;
    recvaddr.sin_port = htons(port);

    // Set X-Plane Port and IP
    if (strcmp(xpIP, "localhost") == 0)
    {
        xpIP = "127.0.0.1";
    }
    strncpy(sock.xpIP, xpIP, 16);
    sock.xpPort = xpPort;

#ifdef _WIN32
    WSADATA wsa;
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
    {
        //printError("OpenUDP", "WSAStartup failed");
        //exit(EXIT_FAILURE);
    }
#endif

    if ((sock.sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1)
    {
        //printError("OpenUDP", "Socket creation failed");
        //exit(EXIT_FAILURE);
    }
    if (bind(sock.sock, (struct sockaddr*)&recvaddr, sizeof(recvaddr)) == -1)
    {
        //printError("OpenUDP", "Socket bind failed");
        //exit(EXIT_FAILURE);
    }

    // Set timeout to 100ms
#ifdef _WIN32
    DWORD timeout = 100;
#else
    struct timeval timeout;
    timeout.tv_sec = 0;
    timeout.tv_usec = 250000;
#endif
    if (setsockopt(sock.sock, SOL_SOCKET, SO_RCVTIMEO, (char*)&timeout, sizeof(timeout)) < 0)
    {
        //printError("OpenUDP", "Failed to set timeout");
    }
    return sock;
}

void closeUDP(XPCSocket sock)
{
#ifdef _WIN32
    int result = closesocket(sock.sock);
#else
    int result = close(sock.sock);
#endif
    if (result < 0)
    {
        //printError("closeUDP", "Failed to close socket");
        //exit(EXIT_FAILURE);
    }
}

/// Sends the given data to the X-Plane plugin.
///
/// \param sock   The socket to use to send the data.
/// \param buffer A pointer to the data to send.
/// \param len    The number of bytes to send.
/// \returns      If an error occurs, a negative number. Otehrwise, the number of bytes sent.
int sendUDP(XPCSocket sock, char buffer[], int len)
{
    // Preconditions
    if (len <= 0)
    {
        //printError("sendUDP", "Message length must be positive.");
        //return -1;
    }

    // Set up destination address
    struct sockaddr_in dst;
    dst.sin_family = AF_INET;
    dst.sin_port = htons(sock.xpPort);
    inet_pton(AF_INET, sock.xpIP, &dst.sin_addr.s_addr);

    int result = sendto(sock.sock, buffer, len, 0, (const struct sockaddr*)&dst, sizeof(dst));
    if (result < 0)
    {
        //printError("sendUDP", "Send operation failed.");
        //return -2;
    }
    if (result < len)
    {
        //printError("sendUDP", "Unexpected number of bytes sent.");
    }
    return result;
}

