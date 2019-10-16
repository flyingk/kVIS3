#include "math.h"
#include "mex.h"
#include "string.h"
#include "stdint.h"
#include "stdbool.h"

bool mlStringCompare(const mxArray * mlVal, char * cStr);
bool mlGetdoubleArray(const mxArray * mlVal, double * dest, int numel);

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

XPCSocket sock;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    //All code and internal function calls go in here!
    if(!mxIsChar(prhs[0])) {
        mexErrMsgTxt("First parameter must be name of a function\n");
        return;
    }
    
    if(mlStringCompare(prhs[0], "UDP_Init"))
    {
        char xpIP[20] = "localhost";
        sock = aopenUDP(xpIP, 14550, 0);
        mexPrintf("open.\n");
    }
    
    else if(mlStringCompare(prhs[0], "UDP_Close"))
    {
        closeUDP(sock);
        mexPrintf("close.\n");
    }
    
    else if(mlStringCompare(prhs[0], "UDP_Transmit"))
    {
        int rc = sendUDP(sock, "Hello", 5);
        mexPrintf("sent: %d\n", rc);
    }
    
}

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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    if(mlStringCompare(prhs[0], "EKF_Init"))
    {
        double pos_ref[5];
        double ekf0[5];
        double mcal[13];
        
        if(nrhs != 4)
        {
            mexErrMsgTxt("Incorrect number of inputs for EKF init\n");
            return;
        }
        
        if( !mlGetdoubleArray(prhs[1], pos_ref, 5) || !mlGetdoubleArray(prhs[2], ekf0, 5) || !mlGetdoubleArray(prhs[3], mcal, 13))
            return;
        
        //init data structures to simulate UAVmainframe environment
        geo_ref.mag_ref[0] = ekf0[0];
        geo_ref.mag_ref[1] = ekf0[1];
        geo_ref.mag_ref[2] = ekf0[2];
        geo_ref.gravity    = 9.80665;
        
        Vehicle_Conf.x_air = ekf0[3];
        Vehicle_Conf.y_air = ekf0[4];
        
        geo_ref.ref_lon=pos_ref[0];
        geo_ref.ref_lat=pos_ref[1];
        geo_ref.ref_ecef[0]=pos_ref[2];
        geo_ref.ref_ecef[1]=pos_ref[3];
        geo_ref.ref_ecef[2]=pos_ref[4];
        
        // calculate ecef2ned transform for later use
		MATH_LNE_COMPUTE(&geo_ref);
                
        EKF_6DoF_Init();

        // initialise mag cal matrices
        for(int i =0; i<13; i++)
        {
        		CData.VMCC[i] = mcal[i];
        }
    }
    
    else if(mlStringCompare(prhs[0], "EKF_Init_X0"))
    {
        double pos0[3], vel0[3], q0[4], wind0[2], Xb0[16];
        
        if(nrhs != 6)
        {
            mexErrMsgTxt("Incorrect number of inputs for EKF init X0\n");
            return;
        }
        
        if(!mlGetdoubleArray(prhs[1], pos0, 3) || !mlGetdoubleArray(prhs[2], vel0, 3)
        || !mlGetdoubleArray(prhs[3], q0, 4) ||!mlGetdoubleArray(prhs[4], wind0, 2)
        || !mlGetdoubleArray(prhs[5], Xb0, 16))
        {
            mexErrMsgTxt("Data import failure for EKF init X0\n");
            return;
        }
        
        sys_ctrl.p_value[EKF_WIND_N_X0] = wind0[0];
        sys_ctrl.p_value[EKF_WIND_E_X0] = wind0[1];
        // initial airdata bias
        sys_ctrl.p_value[EKF_VAIR_BIAS] = Xb0[0];
        sys_ctrl.p_value[EKF_AOA_BIAS]  = Xb0[1];
        sys_ctrl.p_value[EKF_CW_BIAS]   = Xb0[2];
        sys_ctrl.p_value[EKF_ALT_BIAS]  = Xb0[3];
        
        // initial airdata scale
        sys_ctrl.p_value[EKF_VAIR_SCALE] = Xb0[4];
        sys_ctrl.p_value[EKF_AOA_SCALE]  = Xb0[5];
        sys_ctrl.p_value[EKF_CW_SCALE]   = Xb0[6];
        
        // initial accel bias (m/s2)
        sys_ctrl.p_value[EKF_ACC_X_BIAS] = Xb0[7];
        sys_ctrl.p_value[EKF_ACC_Y_BIAS] = Xb0[8];
        sys_ctrl.p_value[EKF_ACC_Z_BIAS] = Xb0[9];
        
        // initial gyro bias (rad/s)
        sys_ctrl.p_value[EKF_GYROX_BIAS] = Xb0[10];
        sys_ctrl.p_value[EKF_GYROY_BIAS] = Xb0[11];
        sys_ctrl.p_value[EKF_GYROZ_BIAS] = Xb0[12];
        
        // initial mag bias (Gauss)
        sys_ctrl.p_value[EKF_MAGX_BIAS] = Xb0[13];
        sys_ctrl.p_value[EKF_MAGY_BIAS] = Xb0[14];
        sys_ctrl.p_value[EKF_MAGZ_BIAS] = Xb0[15];
        
        EKF_6DoF_Init_X(pos0, vel0, q0);
        
    }
    
    else if(mlStringCompare(prhs[0], "EKF_Init_P0"))
    {
        double P0[EKF_6DOF_NUMX];
        
        if(nrhs != 2)
        {
            mexErrMsgTxt("Incorrect number of inputs for EKF init P0\n");
            return;
        }
        
        if(!mlGetdoubleArray(prhs[1], P0, EKF_6DOF_NUMX))
        {
            mexErrMsgTxt("Data import failure for EKF init P0\n");
            return;
        }
        
        EKF_6DoF_Init_P0(P0);
    }
    
    else if(mlStringCompare(prhs[0], "EKF_Init_N0"))
    {
        double N0[EKF_6DOF_NUMW];
        
        if(nrhs != 2)
        {
            mexErrMsgTxt("Incorrect number of inputs for EKF init N0\n");
            return;
        }
        
        if(!mlGetdoubleArray(prhs[1], N0, EKF_6DOF_NUMW))
        {
            mexErrMsgTxt("Data import failure for EKF init N0\n");
            return;
        }
        
        EKF_6DoF_Init_N0(N0);
    }
    
    else if(mlStringCompare(prhs[0], "EKF_Init_R0"))
    {
        double R0[EKF_6DOF_NUMV];
        
        if(nrhs != 2)
        {
            mexErrMsgTxt("Incorrect number of inputs for EKF init R0\n");
            return;
        }
        
        if(!mlGetdoubleArray(prhs[1], R0, EKF_6DOF_NUMV))
        {
            mexErrMsgTxt("Data import failure for EKF init R0\n");
            return;
        }
        
        EKF_6DoF_Init_R0(R0);
    }
    
    else if(mlStringCompare(prhs[0], "EKF_Prediction"))
    {
        double dT, accel_data[3], gyro_data[3];
        
        if(nlhs > 0)
        {
            // return current state vector
            double * data_out;
            int i;
            
            plhs[0] = mxCreateDoubleMatrix(1,EKF_6DOF_NUMX,0);
            
            data_out = mxGetData(plhs[0]);
            
            for(i = 0; i < EKF_6DOF_NUMX; i++)
            {
                data_out[i] = X6[i];
            }
        }
        
        if(nrhs != 4)
        {
            mexErrMsgTxt("Incorrect number of inputs for state prediction\n");
            return;
        }
        
        if(!mlGetdoubleArray(prhs[1], accel_data, 3) || !mlGetdoubleArray(prhs[2], gyro_data, 3) || !mlGetdoubleArray(prhs[3], &dT, 1))
            return;
        
        EKF_6DoF_Prediction(accel_data, gyro_data, dT);
        
    }
    
    else if(mlStringCompare(prhs[0], "EKF_Correction"))
    {
        double gps_data[7], air_data[4], mag_data[3], sensors;
        
        if(nrhs != 5) {
            mexErrMsgTxt("Incorrect number of inputs for correction\n");
            return;
        }
        
        if(!mlGetdoubleArray(prhs[1], gps_data, 7) || !mlGetdoubleArray(prhs[2], air_data, 4) || !mlGetdoubleArray(prhs[3], mag_data, 3) || !mlGetdoubleArray(prhs[4], &sensors, 1))
        {
            mexErrMsgTxt("Error with the input parameters\n");
            return;
        }
        
        EKF_6DoF_Correction((uint16_t)sensors, gps_data, air_data, mag_data, &DVehicle_State, Zsave, Ysave);
        
        if(nlhs > 0)
        {
            // return current state vector
            double * data_out;
            int i;
            
            plhs[0] = mxCreateDoubleMatrix(1,EKF_6DOF_NUMX,0);
            
            data_out = mxGetData(plhs[0]);
            
            for(i = 0; i < EKF_6DOF_NUMX; i++)
            {
                data_out[i] = X6[i];
            }
        }
        
        if(nlhs > 1)
        {
            //return covariance estimate diagonal
            double * p_out;
            int i;
            
            plhs[1] = mxCreateDoubleMatrix(1,EKF_6DOF_NUMX,0);
            
            p_out = mxGetData(plhs[1]);
            
            for(i = 0; i < EKF_6DOF_NUMX; i++)
            {
                p_out[i] = sqrt(P6[i][i]);
            }
        }
        
        if(nlhs > 2)
        {
            //return meas vec Z
            double * z_out;
            int i;
            
            plhs[2] = mxCreateDoubleMatrix(1,EKF_6DOF_NUMV,0);
            
            z_out = mxGetData(plhs[2]);
            
            for(i = 0; i < EKF_6DOF_NUMV; i++)
            {
                z_out[i] = Zsave[i];
            }
        }
        
        if(nlhs > 3)
        {
            //return predicted meas vec Y
            double * y_out;
            int i;
            
            plhs[3] = mxCreateDoubleMatrix(1,EKF_6DOF_NUMV,0);
            
            y_out = mxGetData(plhs[3]);
            
            for(i = 0; i < EKF_6DOF_NUMV; i++)
            {
                y_out[i] = Ysave[i];
            }
        }
    }

    return;
}
     
     */

bool mlGetdoubleArray(const mxArray * mlVal, double * dest, int numel) {
    if(!mxIsNumeric(mlVal) || (!mxIsDouble(mlVal) && !mxIsSingle(mlVal)) || (mxGetNumberOfElements(mlVal) != numel)) {
        mexErrMsgTxt("Data misformatted (either not double or not the right number)");
        return false;
    }
    
    if(mxIsSingle(mlVal)) {
        memcpy(dest,mxGetData(mlVal),numel*sizeof(*dest));
    } else {
        int i;
        double * data_in = mxGetData(mlVal);
        for(i = 0; i < numel; i++)
            dest[i] = data_in[i];
    }
    
    return true;
}

bool mlStringCompare(const mxArray * mlVal, char * cStr) {
    int i;
    char * mlCStr = 0;
    bool val = false;
    int strLen = mxGetNumberOfElements(mlVal);
    
    mlCStr = mxCalloc((1+strLen),  sizeof(*mlCStr));
    if(!mlCStr)
        return false;
    
    if(mxGetString(mlVal, mlCStr, strLen+1))
        goto cleanup;
    
    for(i = 0; i < strLen; i++) {
        if(mlCStr[i] != cStr[i])
            goto cleanup;
    }
    
    if(cStr[i] == '\0')
        val = true;
    
    cleanup:
        if(mlCStr) {
            mxFree(mlCStr);
            mlCStr = 0;
        }
        return val;
}
