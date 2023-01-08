# CCSMB-5: Radio Transmissions
*Author: Emma Beurskens <@emmaknijn>*
*Version: v1.0.0*
*Last updated: YYYY-MM-DD*

## Design
A client will only listen to packets while the audio is being transmitted from a server
The server will communicate to the client over modem


## Packet
A packet consists of the following fields in a table:
- `buffer`: A table that contains Signed 8-bit PCM @ 48kHz audio
- `id`: The ID of the server sending the message
- `station`: A string that contains the name of the radio station
- `title`: A string that contains the song that is currently being played, or other relevant metadata
- `protocol`: A string that contains the protocol used

In order to be compliant the
- protocol field must be "CCSMB-5"
- client must be able to deal with crosstalk by allowing the user to select a station if there are multiple stations on a single channel
- client must reject a packet with an invalid `protocol` field
- server must time the packets appropriately in a way that the client is just able to play back the buffer