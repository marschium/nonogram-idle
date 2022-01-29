import os
import shutil

import tools.pattern
import tools.combine

if __name__ == "__main__":
    for f in os.listdir("images"):
        if os.path.isdir(os.path.join("images", f)):
            continue
        dest = f.replace(".png", ".json")
        tools.pattern.gen(os.path.join("images", f), os.path.join("game", "patterns", dest))
        shutil.copy2(os.path.join("images", f), os.path.join("game", "images", f))

    # with open("bonuses.csv") as f:
    #     for line in f:
    #         bonus = line.split(",")
    #         name = bonus[0]
    #         tools.combine.halfhalf(
    #             os.path.join("images", bonus[1].strip() + ".png"),
    #             os.path.join("images", bonus[2].strip() + ".png"),
    #             f"game/images/bonuses/{name}.png")