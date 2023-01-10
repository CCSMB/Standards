# *CCSMB 7:* Nitrogen Fingers Text

*Author: oeed (Oliver Cooper)*

*Version: 1.0.0*

*Last revised: 2017-01-28*

*Original source: https://github.com/oeed/CraftOS-Standards/blob/master/standards/6-nft.md*

## Quick information
| Information |                           |
| ----------- | ------------------------- |
| Version     | 1.0.0                     |
| Type        | Image file format         |
| MIME        | `image/nft`               |
| Extensions  | `.nft`                    |

## Technical details
The format is similar to the paintutils image format in that colours are defined using a hexadecimal character (`0-9`
and `a-f`). Refer to [CCSMB 6](https://ccsmb.github.io/standards/ccsmb-6) for specifics.

Unlike the paintutils format, however, this format allows characters and text colours to be saved, in addition to the
background colour.

### Special characters
The format uses two special characters, a character whose byte is `30` and another whose byte is `31`.

| Byte | Represents |
| ---- | ---------- |
|  30  | Background colour definition |
|  31  | Text colour definition |

If a `30` or `31` character is encountered the character immediately after will be a hexadecimal. If the character is
`30` the colour represented by the hexadecimal becomes the 'active' background colour. Hence, any proceeding pixels will
use the active background colour (until the next `30` character changes it). The same applies with the `31` character,
but it instead sets the text colour.

### Text characters
Any character that is not `30`, `31` or the character immediately after those two represents the character that should
be written to the screen. A space represents a blank (background colour only) pixel.

As with the paintutils format, each line represents a row of pixels. When the line ends 'active' background and text
colours are reset, with the default being transparent.

### Example
In this example the `30` character is represented by `@`, the `31` character by `#` and a space character by `∙`

```
@4∙@3#bnft
@3∙∙@d∙∙
@d∙∙∙∙
```
