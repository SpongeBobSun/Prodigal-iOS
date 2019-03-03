# Prodigal Player Theme Help

## How to create customize theme

Themes for `Prodigal Music Player` are basically folders. Folder name is the theme name.

Each theme should contain a `config.json` file, which contains colors, shapes and other attributes. **All values‘ type must be string.**

After done with `config.json`, you need to copy all icons you've used in it the same folder with `config.json`.

Supported icon format is `png` or `jpeg`.

For example a valid theme named in `My Customized Theme` should contain files listed in below.

```
|- My Customized Theme
    |- config.json
    |- next_icon.png
    |- prev_icon.png
    |- menu_icon.png
    |- play_icon.png
```

See below table for full supported attributes' names and valid values.

If you having troubles, please refer built-in themes' config file.



| Key               | Value                             | Explain                                  | Required                          |
| ----------------- | --------------------------------- | ---------------------------------------- | --------------------------------- |
| next              | Image file name                   | Image for next button                    | Yes                               |
| prev              | Image file name                   | Image for previous button                | Yes                               |
| menu              | Image file name                   | Image for menu button                    | Yes                               |
| play              | Image file name                   | Image for play button                    | Yes                               |
| wheel_outer       | Float as string                   | Outer bounds for wheel, max 1.0          | Yes                               |
| wheel_inner       | Float as string                   | Inner bounds for wheel, min 0.1          | Yes                               |
| wheel_color       | RGBA color value as string        | Wheel Color                              | Yes                               |
| button_background | RGBA color value as string        | Button background color as string        | Yes                               |
| background_color  | RGBA color value as string        | Main background color as string          | Yes                               |
| wheel_shape       | Wheel shape                       | Must be one of "rect", "oval", "polygon" | Yes                               |
| polygon_sides     | Integer value as string           | Polygon sides when wheel_shape is "polygon". Must greater than 4 | Yes when wheel_shape is "polygon" |
| background_cover  | Boolean(true or false)            | Display current playing album's cover image in main background or not     | No |

For example, a valid theme configuration file's content should looks like below.

```json
{
    "icons": {
        "next":"next.png",
        "prev":"prev.png",
        "play":"play.png",
        "menu":"menu.png"
    },
    "wheel_outer":"0.95",
    "wheel_inner":"0.3",
    "wheel_color":"#AAAAAAAA",
    "button_size":"0.2",
    "button_background": "#000000FF",
    "background_color": "#59A5C6",
    "wheel_shape": "rect",
    "card_color": "#AAAAAAAA",
    "item_color": "#4D93C6",
    "background_cover" : true
}
```

## How to upload themes to Prodigal Music Player

Check [this link](https://github.com/SpongeBobSun/Prodigal-iOS/blob/master/MoreTheme.md) for details

## How to apply a theme

To apply a theme, upload it to your phone and go to Prodigal app settings -> themes -> and select your theme

## Troubleshoot

If you find your theme doesn't looks right, please kill APP and re-launch APP.

If your APP crashing after loaded customized theme, please delete that theme via computer then re-launch APP.
