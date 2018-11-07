function getty_handshake = set_up_handshake()

%HANDSHAKE BIT TO GETTY
to_getty = daq.createSession('ni');
addDigitalChannel(to_getty,'Dev1','Port0/Line15','OutputOnly');
to_getty.Channels(1).Name = 'modig';

%HANDSHAKE BIT FROM GETTY
from_getty = daq.createSession('ni');
addDigitalChannel(from_getty,'Dev1','Port1/Line7','InputOnly');
from_getty.Channels(1).Name = 'getty';

%BIND TO STRUCT
getty_handshake.from_getty = from_getty;
getty_handshake.to_getty = to_getty;
