function kVIS_dataTimerFcn(hObject, event)

% txt1 = ' event occurred at ';
% 
% event_type = event.Type;
% event_time = datestr(event.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF');
% 
% msg = [event_type txt1 event_time];
% disp(msg)

Data = hObject.UserData;

i = Data.currentStep;

VS = getDataVS(Data.DAT(i,:), Data.LLA(i,:));

kVIS_dataReplayMex('ML_VehicleState', VS)

F = zeros(14,1);
F(1) = VS(1);
F(2) = Data.CTRL(i,1);
F(3) = Data.CTRL(i,1);
F(4) = Data.CTRL(i,2);
F(5) = Data.CTRL(i,2);
F(6) = Data.CTRL(i,3);
F(7) = Data.CTRL(i,3);
F(8) = Data.CTRL(i,3);
F(9) = Data.CTRL(i,3);
F(10) = Data.CTRL(i,4);
F(11) = Data.CTRL(i,4);
F(12) = Data.CTRL(i,4);
F(13) = Data.CTRL(i,4);
kVIS_dataReplayMex('ML_FlapFeedback', F)

%
% Update time indicator line
%
Data.lineHandle.XData = [VS(1) VS(1)];

%
% Next timestep
%
Data.currentStep = Data.currentStep + 10;

%
% Stop playback at end of data
%
if Data.currentStep >= size(Data.DAT,1)
    kVIS_dataReplayStop_Callback(hObject, []);
    msgbox('End of Data Playback.')
    return
end

% https://de.mathworks.com/matlabcentral/answers/302939-accessing-timer-userdata-fields
hObject.UserData = Data;
end



function VS = getDataVS(DAT,lla)

% mavlink_vehicle_state_t packet;
% packet.time_boot_ms = VS[0];
% packet.Lat = VS[1];
% packet.Lon = VS[2];
% packet.Alt_msl = VS[3];
% packet.Alt_agl = VS[4];
% packet.Pn = VS[5];
% packet.Pe = VS[6];
% packet.Pd = VS[7];
% packet.Vn = VS[8];
% packet.Ve = VS[9];
% packet.Vd = VS[10];
% packet.p = VS[11];
% packet.q = VS[12];
% packet.r = VS[13];
% packet.Roll = VS[14];
% packet.Pitch = VS[15];
% packet.Yaw = VS[16];
% packet.Vair = VS[17];
% packet.AoA = VS[18];
% packet.AoS = VS[19];
% packet.Nz = VS[20];

VS = zeros(21,1);

VS(1) = DAT(1);

VS(2) = lla(1);
VS(3) = lla(2);
VS(4) = lla(3);

VS(15) = DAT(8);
VS(16) = DAT(9);
VS(17) = DAT(10);

end