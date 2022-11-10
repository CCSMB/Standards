# WAV format for DFPWM data
*Author: JackMacWindows <@MCJack123>*
*Version: v1.0.0*
*Last updated: 2022-05-02*

This document describes how to store DFPWM data in a WAV file.

## Overview
DFPWM data is specified through the `WAVE_FORMAT_EXTENDED` data type, with the UUID `3ac1fa38-811d-4361-a40d-ce53ca607cd1`. Channels are stored interleaved, and samples are packed in groups of 8 per byte, as is consistent with raw DFPWM data. Only DFPWM1a data is considered here - original DFPWM should not be stored using this UUID.

## `fmt `&nbsp;chunk
The `fmt `&nbsp;chunk follows the standard layout for `WAVE_FORMAT_EXTENDED`, using the assigned DFPWM UUID:

| Offset | Bytes | Description                                     |
|--------|-------|-------------------------------------------------|
| 0x00   | 2     | Format code (`0xFFFE`)                          |
| 0x02   | 2     | Number of channels                              |
| 0x04   | 4     | Sample rate                                     |
| 0x08   | 4     | Byte rate (sample rate * channels / 8)          |
| 0x0C   | 2     | Block align (ceil(channels / 8))                |
| 0x0E   | 2     | Bits per sample (1)                             |
| 0x10   | 2     | Extra data size (`0x16`)                        |
| 0x12   | 2     | Valid bits per sample (1)                       |
| 0x14   | 4     | Channel configuraion                            |
| 0x18   | 16    | DFPWM UUID (`3ac1fa38811d4361a40dce53ca607cd1`) |

## `fact` chunk
The `fact` chunk is required when using a non-PCM format. This is simply a 32-bit integer specifying the total number of samples in a single channel. This should be equal to (data length * 8 / channels).

## `data` chunk
The `data` chunk stores the raw DFPWM data. For single channel audio, this is equivalent to existing raw DFPWM files. For multichannel audio, all samples are interleaved in the PCM input to the encoder. This may be implemented by first encoding the native audio representation to interleaved signed (or unsigned, depending on the codec's capabilities) 8-bit PCM, as would be stored in a PCM WAV file, then passed directly to the DFPWM encoder.

All data uses a single encoder instance with `q` and `s` set to 0, and `lt` set to -128. The instance parameters are used throughout the entire data block, and are never reset while encoding or decoding. The samples are decoded sequentially, with the least significant bit first. Since the data is interleaved before encoding, all channels share the same encoder and parameters, switching between channels for each frame. For example, if a byte `0b11001010` is stored in a 2-channel DFPWM file, the first bit (0) is decoded to the left channel, then the second bit (1) is decoded to the right channel, then the third bit (0) is decoded to the left channel, and so on.

## Compliant muxers/demuxers
The following muxers are known to support DFPWM data in WAV files:
- [AUKit](https://github.com/MCJack123/AUKit)
- [FFmpeg libavformat/libavcodec](https://ffmpeg.org) (since FFmpeg 5.1/avcodec 59.22/avformat 59.18)
