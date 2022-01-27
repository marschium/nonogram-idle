extends Node


enum PATTERN_PACK {
    STARTER
}


func get_pattern_pack(pack_id):
    if pack_id == PATTERN_PACK.STARTER:
        return ["white"]
