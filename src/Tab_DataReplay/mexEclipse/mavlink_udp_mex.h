/*
 * mavlink_udp_mex.h
 *
 *  Created on: 26 Nov 2019
 *      Author: kai.lehmkuehler
 */

#ifndef MAVLINK_UDP_MEX_H_
#define MAVLINK_UDP_MEX_H_


typedef struct xpcSocket
{
    unsigned short port;

    // X-Plane IP and Port
    char xpIP[16];
    unsigned short xpPort;

#ifdef _WIN32
    SOCKET sock;
#else
    int sock;
#endif
} XPCSocket;


// Low Level UDP Functions

/// Opens a new connection to XPC on an OS chosen port.
///
/// \param xpIP   A string representing the IP address of the host running X-Plane.
/// \returns      An XPCSocket struct representing the newly created connection.
XPCSocket openUDP(const char *xpIP);

/// Opens a new connection to XPC on the specified port.
///
/// \param xpIP   A string representing the IP address of the host running X-Plane.
/// \param xpPort The port of the X-Plane Connect plugin is listening on. Usually 49009.
/// \param port   The local port to use when sending and receiving data from XPC.
/// \returns      An XPCSocket struct representing the newly created connection.
XPCSocket aopenUDP(const char *xpIP, unsigned short xpPort, unsigned short port);

/// Closes the specified connection and releases resources associated with it.
///
/// \param sock The socket to close.
void closeUDP(XPCSocket sock);

/// Send data
int sendUDP(XPCSocket sock, char buffer[], int len);


#endif /* MAVLINK_UDP_MEX_H_ */
