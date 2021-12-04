import PIL
from PIL import Image
import json

def main(src, dest):
    img = Image.open(src)
    out = {
        "tiles": [],
        "name": "test", # TODO take from filename
        "bonus": 32, # TODO based on number of colors?
        "w": img.width,
        "h": img.height
    }
    for x in range(img.width):
        for y in range(img.height):
            rgb = img.getpixel((x, y))
            out["tiles"].append({"c": rgb, "x": x, "y": y})

    with open(dest, "w+") as f:
        json.dump(out, f, indent=4)
        f.truncate()

if __name__ == "__main__":
    import sys
    main(sys.argv[1], "test.json")