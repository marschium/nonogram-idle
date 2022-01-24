from lzma import MODE_NORMAL
from PIL import Image, ImageMode

def halfhalf(first, second, dest):
    first_img = Image.open(first)
    second_img = Image.open(second)

    res = Image.new("RGBA", (16 , 16))
    res.paste(first_img.crop((0, 0, 5, 10)), (3, 3))
    res.paste(second_img.crop((5, 0, 10, 10)), (8, 3))
    res = res.resize((256, 256), Image.NEAREST)
    res.save(dest)