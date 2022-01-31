import PIL
from PIL import Image
import json
import os

BONUS_BASE = 64

def gen(src, dest):
    img = Image.open(src)
    out = {
        "tiles": [],
        "name": os.path.basename(os.path.splitext(src)[0]),
        "w": img.width,
        "h": img.height
    }
    colors = set()
    for x in range(img.width):
        for y in range(img.height):
            rgb = img.getpixel((x, y))
            if isinstance(rgb, int) or (len(rgb) == 4 and rgb[3] == 0):
                continue
            out["tiles"].append({"c": rgb, "x": x, "y": y})
            colors.add(rgb)
    out["colors"] = list(colors)
    out["bonus"] = BONUS_BASE * len(colors)

    # if file already exists only overrwite the tiles
    if os.path.exists(dest):
        with open(dest, "r+") as f:
            j = json.load(f)
            j["tiles"] = out["tiles"]
            f.seek(0)
            json.dump(j, f, indent=4)
            f.truncate()
    else:
        with open(dest, "w+") as f:
            json.dump(out, f, indent=4)
            f.truncate()

if __name__ == "__main__":
    import sys
    gen(sys.argv[1], sys.argv[2])