# CCSMB-5: Radio Transmissions
*Author: Emma Beurskens <@emmaknijn>*
*Version: v1.0.0*
*Last updated: YYYY-MM-DD*

## Design
A client will only listen to packets while the audio is being transmitted from a server
The server will communicate to the client over modem
It is recommended that servers use channels 2048-4096

## Packet
An audio packet consists of the following fields in a table:
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

## Discovery
A discovery packet is sent over channel 759 and must contain the following fields in a table:
- `type`: The type of request

The following fields are only for servers responding to a discovery packet
- `channel`: An integer that contains the modem channel of the radio station
- `station`: A string that contains the name of the radio station
- `title`: A string that contains the song that is currently being played, or other relevant metadata