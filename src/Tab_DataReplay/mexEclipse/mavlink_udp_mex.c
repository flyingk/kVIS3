#include "math.h"
#include "mex.h"
#include "string.h"
#include "stdint.h"
#include "stdbool.h"

#include "mavlink_udp_mex.h"
#include "mavlink.h"

bool mlStringCompare(const mxArray * mlVal, char * cStr);
bool mlGetdoubleArray(const mxArray * mlVal, double * dest, int numel);


XPCSocket sock;


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	mavlink_system_t mavlink_system;

	mavlink_system.sysid = 42;       ///< ID 42 for this airplane
	mavlink_system.compid = MAV_COMP_ID_IMU;     ///< The component sending the message is the IMU, it could be also a Linux process
	//mavlink_system.type = MAV_TYPE_FIXED_WING;   ///< This system is an airplane / fixed wing


    //All code and internal function calls go in here!
    if(!mxIsChar(prhs[0])) {
        mexErrMsgTxt("First parameter must be name of a function\n");
        return;
    }
    
    if(mlStringCompare(prhs[0], "UDP_Init"))
    {
        char xpIP[20] = "localhost";
        sock = aopenUDP(xpIP, 14550, 0);
        mexPrintf("UDP open.\n");
    }
    
    else if(mlStringCompare(prhs[0], "UDP_Close"))
    {
        closeUDP(sock);
        mexPrintf("UDP closed.\n");
    }
    
    else if(mlStringCompare(prhs[0], "UDP_Transmit"))
    {
        int rc = sendUDP(sock, "Hello", 5);
        mexPrintf("sent: %d\n", rc);
    }
    
    else if(mlStringCompare(prhs[0], "ML_Heartbeat"))
    {
    	// Initialize the required buffers
    	mavlink_message_t msg;
    	uint8_t buf[MAVLINK_MAX_PACKET_LEN];


    	/** @param type Type of the MAV (quadrotor, helicopter, etc., up to 15 types, defined in MAV_TYPE ENUM)
    	 * @param autopilot Autopilot type / class. defined in MAV_AUTOPILOT ENUM
    	 * @param base_mode System mode bitfield, see MAV_MODE_FLAGS ENUM in mavlink/include/mavlink_types.h
    	 * @param custom_mode A bitfield for use for autopilot-specific flags.
    	 * @param system_status System status flag, see MAV_STATE ENUM
    	 */

    	mavlink_msg_heartbeat_pack(mavlink_system.sysid, mavlink_system.compid, &msg, MAV_TYPE_FIXED_WING,
    			MAV_AUTOPILOT_GENERIC, 0, 0, 0);

    	uint16_t len = mavlink_msg_to_send_buffer(buf, &msg);

    	sendUDP(sock, (char*)buf, len);
    }
    
    else if(mlStringCompare(prhs[0], "ML_VehicleState"))
    {
        double VS[21];

        if( !mlGetdoubleArray(prhs[1], VS, 21))
            return;

    	mavlink_vehicle_state_t packet;
    	packet.time_boot_ms = VS[0];
    	packet.Lat = VS[1];
    	packet.Lon = VS[2];
    	packet.Alt_msl = VS[3];
    	packet.Alt_agl = VS[4];
    	packet.Pn = VS[5];
    	packet.Pe = VS[6];
    	packet.Pd = VS[7];
    	packet.Vn = VS[8];
    	packet.Ve = VS[9];
    	packet.Vd = VS[10];
    	packet.p = VS[11];
    	packet.q = VS[12];
    	packet.r = VS[13];
    	packet.Roll = VS[14];
    	packet.Pitch = VS[15];
    	packet.Yaw = VS[16];
    	packet.Vair = VS[17];
    	packet.AoA = VS[18];
    	packet.AoS = VS[19];
    	packet.Nz = VS[20];

    	mavlink_message_t msg;
    	uint8_t buf[MAVLINK_MAX_PACKET_LEN];

    	mavlink_msg_vehicle_state_encode(mavlink_system.sysid, mavlink_system.compid, &msg,
    			&packet);

    	uint16_t len = mavlink_msg_to_send_buffer(buf, &msg);

    	sendUDP(sock, (char*)buf, len);
    }
    
    else if(mlStringCompare(prhs[0], "ML_EngineFeedback"))
    {
        int rc = sendUDP(sock, "Hello", 5);
        mexPrintf("sent: %d\n", rc);
    }
    
    else if(mlStringCompare(prhs[0], "ML_FlapFeedback"))
    {
        double F[14];

        if( !mlGetdoubleArray(prhs[1], F, 14))
            return;

    	mavlink_flap_feedback_t packet;
    	packet.time_boot_ms = F[0];
    	packet.FLAP_LHS_CAN_11 = F[1];
    	packet.FLAP_LHS_CAN_12 = F[2];
    	packet.FLAP_RHS_CAN_21 = F[3];
    	packet.FLAP_RHS_CAN_22 = F[4];
    	packet.FLAP_LHS_WING_31 =F[5];
    	packet.FLAP_LHS_WING_32 = F[6];
    	packet.FLAP_LHS_WING_33 = F[7];
    	packet.FLAP_LHS_WING_34 = F[8];
    	packet.FLAP_RHS_WING_41 = F[9];
    	packet.FLAP_RHS_WING_42 = F[10];
    	packet.FLAP_RHS_WING_43 = F[11];
    	packet.FLAP_RHS_WING_44 = F[12];
    	packet.FLAP_STATUS = F[13];

    	mavlink_message_t msg;
    	uint8_t buf[MAVLINK_MAX_PACKET_LEN];

    	mavlink_msg_flap_feedback_encode(mavlink_system.sysid, mavlink_system.compid, &msg,
    			&packet);

    	uint16_t len = mavlink_msg_to_send_buffer(buf, &msg);

    	sendUDP(sock, (char*)buf, len);
    }
    
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
