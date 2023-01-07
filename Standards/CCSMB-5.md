# CCSMB-5: Radio Transmissions
*Author: Emma Beurskens <@emmaknijn>*
*Version: v1.0.0*
*Last updated: YYYY-MM-DD*

## Design
A client will only listen to packets while the audio is being transmitted from a server
The server will communicate to the client over modem

## Packet
A packet consists of the following fields in a table:
- buffer: A table that contains Signed 8-bit PCM @ 48kHz audio
- station: A string that contains the name of the radio station
- title: A string that contains the song that is currently being played
- protocol: A string that contains the protocol used

The protocol field must be "CCSMB-5" in order to be compliant
A client must be able to accept the buffer field in order to be compliant
A server must be able to transmit all of the fields in order to be compliant
A server must time the packets appropriately in a way that the client is just able to play back the buffer in order to be compliant
A client must be able to deal with crosstalk