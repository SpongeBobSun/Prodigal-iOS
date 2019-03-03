# Prodigal 音乐播放器主题说明文档

## 如何创建自定义主题

Prodigal 播放器的主题文件本质上是一个文件夹，文件夹的名字就是主题的名字。

每个主题都应该包含一个 `config.json` 文件, 里面包含了颜色、形状以及其他参数。**所有的值都必须为字符串(String)类型。**

编写好 `config.json` 之后，你需要将该文件中用到的所有图标资源(png或者jpg格式)与这个配置文件放到同一个文件夹。

例如，一个叫做 `My Customized Theme` 的主题应该包含如下的文件清单

```
|- My Customized Theme
    |- config.json
    |- next_icon.png
    |- prev_icon.png
    |- menu_icon.png
    |- play_icon.png
```

下面的表格列出了所有配置项的名称和有效值。

如果遇到了问题，可以参考[自带主题](https://github.com/SpongeBobSun/Prodigal-iOS/blob/master/Themes/Provided%20by%20Developer.zip)的配置文件。



| 配置项            | 值                                        | 含义                            | 是否为必须项                          |
| ----------------- | ----------------------------------------- | ------------------------------- | ------------------------------------- |
| next              | 图片文件名                                | "下一首"按钮的图标              | 是                                    |
| prev              | 图片文件名                                | "上一首"按钮的图标              | 是                                    |
| menu              | 图片文件名                                | "菜单"按钮的图标                | 是                                    |
| play              | 图片文件名                                | "播放\暂停"按钮的图标           | 是                                    |
| wheel_outer       | 字符串格式的浮点数                        | Outer bounds for wheel, max 1.0 | 是                                    |
| wheel_inner       | 字符串格式的浮点数                        | Inner bounds for wheel, min 0.1 | 是                                    |
| wheel_color       | 字符串格式的RGBA颜色值                    | 滚轮的颜色                      | 是                                    |
| button_background | 字符串格式的RGBA颜色值                    | 按钮的背景色                    | 是                                    |
| background_color  | 字符串格式的RGBA颜色值                    | 主界面的背景色                  | 是                                    |
| wheel_shape       | 必须是 "rect", "oval", "polygon" 中的一种 | 滚轮的形状                      | 是                                    |
| polygon_sides     | 字符串格式的、大于4的整数                 | 滚轮多边形的边数                | 当wheel_shape 为 "polygon" 时为必填值 |
| background_cover  | 布尔值(true或者false)                     | 是否在主界面显示唱片封面        | 否                                    |


例如，一个有效的配置文件可以是如下内容

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

## 如何上传主题

参考[这个链接](https://github.com/SpongeBobSun/Prodigal-iOS/blob/master/MoreTheme.md)

## 如何应用主题

首先通过iTunes上传主题到Prodigal 播放器，然后在播放器中到 设置 -> 主题 -> 选择你的主题

## 如遇问题

如果你的主题看起来不太对，请在"最近使用"列表中移除Prodigal并重新打开APP试试

如果APP在加载了自定义主题之后崩溃或者闪退，请把手机连接到电脑并通过iTunes删除Prodigal播放器中的`Themes`这个文件夹，然后重新打开APP

