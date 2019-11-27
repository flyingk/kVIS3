function kVIS_heartbeatTimerFcn(obj, event)

txt1 = ' event occurred at ';

event_type = event.Type;
event_time = datestr(event.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF');

msg = [event_type txt1 event_time];
disp(msg)


kVIS_dataReplayMex('ML_Heartbeat')