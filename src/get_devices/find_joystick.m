%function to find an attached joystick and set parameters for it
function [joystick, touch] = find_joystick(screen_refresh)
%clear the hardware in use
daqreset();

joystick = daq.createSession('ni');
joystick.Rate=20;
joystick.DurationInSeconds = 1/screen_refresh;
addAnalogInputChannel(joystick, 'Dev1',0,'Voltage');
addAnalogInputChannel(joystick, 'Dev1',1,'Voltage');

touch = daq.createSession('ni');
addDigitalChannel(touch,'Dev1','Port1/Line1','InputOnly');
