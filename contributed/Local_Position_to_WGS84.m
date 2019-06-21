function [ Longitude_UNIT_deg, Latitude_UNIT_deg, Altitude_UNIT_m ] = Local_Position_to_WGS84(Position_UNIT_m_FRAME_N, Reference_Position_UNIT_m_FRAME_E, M_NE)
%#codegen

% Reference_Position_UNIT_m_FRAME_E and M_NE have data scope "parameter"
% (equivalent to constant input)

%% Local position to WGS84 coordinates

% Transform local position to ECEF

Position_UNIT_m_FRAME_E = Reference_Position_UNIT_m_FRAME_E + M_NE' * Position_UNIT_m_FRAME_N;

% Calculate WGS84 coordinates from ECEF position

x = Position_UNIT_m_FRAME_E(1);
y = Position_UNIT_m_FRAME_E(2);
z = Position_UNIT_m_FRAME_E(3);
r = sqrt(x^2 + y^2);

% Earth:
a = 6378137.0;     % semi-major [m]
b = 6356752.3142;  % semi-minor [m]
f = (a-b)/a;       % flattening
e = sqrt(f*(2-f)); % first excentricity

% Mysterious stuff
e2 = (a/b)^2 - 1;
E2 = a^2 - b^2;
F  = 54 * b^2 * z^2;
G  = r^2 + (1-e^2) * z^2 - e^2 * E2;
c  = e^4 * F * r^2 / G^3;
s  = (1 + c + sqrt(c^2 + 2 * c))^(1/3);
P  = F / (3 * (s + 1/s + 1)^2 * G^2);
Q  = sqrt(1 + 2 * e^4 * P);
r0 = sqrt(a^2/2 * (1 + 1/Q) - P * (1-e^2) * z^2 / (Q * (1 + Q)) - P * r^2 / 2) - P * e^2 * r / (1 + Q);
U  = sqrt((r - e^2 * r0)^2 + z^2);
V  = sqrt((r - e^2 * r0)^2 + (1 - e^2) * z^2);
z0 = b^2 * z / (a * V);

Longitude_UNIT_deg = rad2deg(atan2(y, x));
Latitude_UNIT_deg  = rad2deg(atan2(z + e2 * z0, r));
Altitude_UNIT_m    = U * (1 - b^2 / (a * V));

end