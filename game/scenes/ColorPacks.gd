extends Node

enum COLOR_PACK {
    WHITE
    BASIC
}

func get_color_pack(id):
    if id == 0:
        return [ Color("ffffff") ]
    elif id == 1:
        return [ Color("#FF606060"),
        Color("#FFFF3333"),
        Color("#FF99FF33"),
        Color("#FF3399FF"),
        Color("#FF9933FF"),
        Color("#FFFF9933"),
        Color("#FF181833") ]
