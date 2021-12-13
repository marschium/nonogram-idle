import PIL
from PIL import Image
import json
import os

BONUS_BASE = 64

def gen(src, dest):
    img = Image.open(src)
    out = {
        "tiles": [],
        "name": os.path.splitext(src),
        "w": img.width,
        "h": img.height
    }
    colors = set()
    for x in range(img.width):
        for y in range(img.height):
            rgb = img.getpixel((x, y))
            out["tiles"].append({"c": rgb, "x": x, "y": y})
            colors.add(rgb)
    out["bonus"] = BONUS_BASE * len(colors)

    with open(dest, "w+") as f:
        json.dump(out, f, indent=4)
        f.truncate()

if __name__ == "__main__":
    import sys
    gen(sys.argv[1], sys.argv[2])