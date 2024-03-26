# CCSMB-3 bimg File Format

*Author: SkyTheCodeMaster*

*Contributors: MasonGulu, spr2-dev*

*Version: 1.0.0*

*Last Revised: 2022-07-29*

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

bimg (abbreviation of "blit image") is a versatile image format for the ComputerCraft Minecraft mod.
This specification aims to provide a standardized image format that can be easily implemented and used throughout the entire ComputerCraft ecosystem.

## File Structure

The examples shown throughout this specification are based on a sample image file, serialized using `textutils.serialize`.

An image file MUST be separated into two sections: metadata data and frame data. The bimg parsers MUST be able to parse these two sections even if they are switched around. Meaning that they can be correctly written and read by parsers regardless of whether the metadata or the frame data comes first:
```lua
   {
    -- frame data --
        {
            {
                "First Line",
                "0000000000",
                "ffffffffff",
            },
            {
                "Bimg Image",
                "dddd0aaaaa",
                "ffffffffff",
            },
        },
    -- end of frame data --

    -- metadata --
        version = "1.0.0",
        animation = false,
        palette = {
            [colors.white] = {0xffffff},
            [colors.purple] = {0xb266e5},
            [colors.green] = {0x57a64e},
            [colors.black] = {0x000000},
        },
        title = "Example",
        description = "This is an example of the .bimg format, a universal ComputerCraft image.",
        author = "SkyTheCodeMaster",
        creator = "Keyboard and Mouse",
        date = "2022-05-30T22:32:24+0000",
    -- end of metadata --
   }
```

Metadata contains information about the image itself, while the remaining of the file MUST contain one or more frames, representing the images.

For more information on metadata, see [Metadata](#metadata). For more information on the image data and frames, see [Image Data](#image-data)
.

## Metadata

bimg stores the following metadata along the image data in the file.

| Field | Type | Description |
|:--|:-:|:--|
| `version` | `string` | Format version of the file. Used to differentiate two bimg file formats. Composed of three numbers separated by dots, defining the major, minor, and revision number respectively. |
| `author` | `string` | Author of the image. |
| `title` | `string` | Title of the image. Set by the author.
| `description` | `string` | Description of the image. Set by the author. |
| `creator` | `string` | Software that created the image. |
| `date` | `string` | Date and time the image was created on, in ISO-8601 format. |
| `width` | `number` | Width of the image in characters. |
| `height` | `number` | Height of the image in characters. |
| `animated` | `boolean` | Whether the file contains multiple frames and can be interpreted as an [animation](#animations).
| (if animated) `secondsPerFrame` | `number` | Default length of each frame in seconds.
| `palette` | `table` | Color palette table applied to the whole set of frames. For more information on palette formats, see [Palettes](#palettes).

Renderers SHOULD support all metadata fields, and MUST support the `version` and `animated` fields.

## Image Data

Aside the metadata are stored the frames of the image. At least one frame MUST be present for the file to be considered valid.
For animation support, see [Animations](#animations).

### Frame Structure

A single frame MUST be composed of multiple numerically-indexed tables, each representing a single line of the image.
Additionally, a frame MAY contain per-frame palette can be provided to alter the colors of that frame only. For more information on palettes, see [Palettes](#palettes).

When the image is an animation, a `duration` field MAY also be provided. This field WILL override the `secondsPerFrame` field set in the metadata, and therefore sets a specific duration (in seconds) for that frame only.

```lua
{
  -- frame optional data --
  duration = 0.6,
  palette = {
    [colors.red] = { 0xff0000 },
  },
  -- end of frame optional data --

  -- line 1 --
  {
    "First Line",
    "0000000000",
    "ffffffffff",
  },
  -- end of line 1 --

  -- line 2 --
  {
    "Bimg Image",
    "dddd0aaaaa",
    "ffffffffff",
  },
  -- end of line 2 --
},
```

Each line MUST be composed of three `string` values forming a blit table, that MUST be able to be unpacked directly to `term.blit` when rendering the image.

Spaces in any of the blit strings SHOULD make the corresponding color of the pixel transparent, according to the following rules:
| Foreground | Background | Result |
|:-:|:-:|---|
| Colored | Colored | The pixel is rendered as is, using the colors set in the blit strings. No transparency is applied. |
| Colored | Transparent | The background color of the pixel that is about to be replaced is used as the new background color. |
| Transparent | Colored | The background color of the pixel that is about to be replaced is used as the new foreground color. |
| Transparent | Transparent | The pixel is not rendered.

### Animations

bimg renderers CAN support multiple frames per image file. Each frame is numerically indexed at the root of the table, along the metadata. This allows easy retrieval with `ipairs`.

In the event multiple frames are provided, the image is considered as an animation. Consequently, the `animated` boolean MUST be set to `true`, and the `secondsPerFrame` field SHOULD be set. If it is not present, the default value MUST be set to `0.05` seconds.

## Palettes

Palettes allows the modification of the existing 16 ComputerCraft colors available in the `colors` API to custom RGB values, applied to the whole terminal at once.
bimg allows the use of such palettes to render images more realistically, allowing for image effects (like dithering) to be applied.

Palettes MUST be formatted as a table, where the keys corresponds to the indexes of the ComputerCraft color values (ranged from 0 to 15), and the values the new RGB colors to apply.
Values MUST be contained themselves in a table, and MAY be either represented by a triplet of float numbers ranged from 0 to 1, each representing a color component, or a single integer number representing the three components at once:
 - `{ 1, 1, 0 }` sets the red and green components to full, outputting a bright yellow.
 - `{ 0xFFFF00 }` has the same effect, and will also provide a bright yellow.

This allows both versions of `term.setPaletteColor()` to be supported through a single call, by unpacking the color table into the last argument:
```lua
for color, tbl in pairs(palette) do
    term.setPaletteColor(2 ^ color, table.unpack(tbl))
end
```

Full example of a bimg color palette, featuring both color formats:
```lua
{
    [14] = { 1, 0, 0 },
    [13] = { 0, 1, 0 },
    [11] = { 0x0000FF },
    [7] = { 0.5, 0.5, 0.5 }
}
```

If palettes are both defined in the metadata and in a frame, the palette in the frame MUST take higher precedence over the one defined in the metadata. Colors that are defined in the metadata palette but not in the frame palette MUST still be applied.

In the example below, both colors are modified and applied when rendering the frame:
```lua
-- In metadata
palette = {
    [14] = { 0xFF0000 }
}

-- In frame
palette = {
    [11] = { 0x0000FF }
}
```
