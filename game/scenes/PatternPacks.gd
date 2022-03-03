extends Node


enum PATTERN_PACK {
    STARTER,
    FARM,
    BUSINESS
}


func get_pattern_pack(pack_id):
    if pack_id == PATTERN_PACK.STARTER:
        return ["white"]
