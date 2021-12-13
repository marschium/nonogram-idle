import os

import tools.pattern

if __name__ == "__main__":
    for f in os.listdir("images"):
        dest = f.replace(".png", ".json")
        tools.pattern.gen(os.path.join("images", f), os.path.join("game", "patterns", dest))