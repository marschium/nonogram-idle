import os
import json

pattern_folder = "game/patterns"

ids = {
    0: [
        "blue",
        "gray",
        "green",
        "navy",
        "orange",
        "purple",
        "red",
        "white",
    ]
}

for pack_id, patterns in ids.items():
    for p in patterns:
        with open(os.path.join(pattern_folder, p + ".json"), "r+") as f:
            j = json.load(f)
            j["pack_id"] = pack_id
            f.seek(0)
            f.truncate()
            json.dump(j, f, indent=4)