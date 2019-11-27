% kVIS3 Data Visualisation
%
% Copyright (C) 2012 - present  Kai Lehmkuehler, Matt Anderson and
% contributors
%
% Contact: kvis3@uav-flightresearch.com
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


function kVIS_dataReplayStart_Callback(hObject, ~)

[fds, name] = kVIS_getCurrentFds(hObject);

if isempty(name)
    errordlg('Nothing loaded...')
    return
end

DAT = kVIS_fdsGetGroup(fds, 'SIDPAC_fdata');
Time = DAT(:,1);

lat = kVIS_fdsGetChannel(fds, 'Default_Group','PhiGeo_INS3');
lon = kVIS_fdsGetChannel(fds, 'Default_Group','LambdaGeo_INS3');
h   = kVIS_fdsGetChannel(fds, 'Default_Group','HGeo_INS3');
h = h - 3.5;

cl   = kVIS_fdsGetChannel(fds, 'SIDPAC_fdata','Canard L');
cr   = kVIS_fdsGetChannel(fds, 'SIDPAC_fdata','Canard R');
wl   = kVIS_fdsGetChannel(fds, 'SIDPAC_fdata','Flap L');
wr   = kVIS_fdsGetChannel(fds, 'SIDPAC_fdata','Flap R');

kVIS_dataReplayMex('UDP_Init')

for i=1:10:500 %length(Time)
    
    if mod(i,11) == 0
        kVIS_dataReplayMex('ML_Heartbeat')
    end
    
    VS = getDataVS(DAT(i,:), [lat(i), lon(i), h(i)]);
    kVIS_dataReplayMex('ML_VehicleState', VS)
    
    F = zeros(14,1);
    F(1) = VS(1);
    F(2) = cl(i);
    F(3) = cl(i);
    F(4) = cr(i);
    F(5) = cr(i);
    F(6) = wl(i);
    F(7) = wl(i);
    F(8) = wl(i);
    F(9) = wl(i);
    F(10) = wr(i);
    F(11) = wr(i);
    F(12) = wr(i);
    F(13) = wr(i);
    kVIS_dataReplayMex('ML_FlapFeedback', F)
    
    pause(0.1)
end

kVIS_dataReplayMex('UDP_Close')

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