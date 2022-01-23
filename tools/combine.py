from lzma import MODE_NORMAL
from PIL import Image, ImageMode

def halfhalf(first, second, dest):
    first_img = Image.open(first)
    second_img = Image.open(second)

    res = Image.new("RGBA", (16, 16))
    res.paste(first_img.crop((0, 0, 8, 16)), (0, 0))
    res.paste(second_img.crop((8, 0, 16, 16)), (8, 0))
    res = res.resize((256, 256), Image.NEAREST)
    res.save(dest)