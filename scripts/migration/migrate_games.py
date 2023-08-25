import os
import json
from datetime import date

class terminalColors:
    WARNING = '\033[93m'
    INFO = '\033[94m'
    END_COLOR = '\033[0m'

# first of all, jump into this directory no matter where we actually started this script
script_path = os.path.abspath(__file__)
script_directory = os.path.dirname(script_path)
os.chdir(script_directory)

def migrate_age_restriction(age_restriction):
    if (age_restriction == 3):
        return "usk6"
    if (age_restriction == 4):
        return "usk12"
    if (age_restriction == 5):
        return "usk16"
    if (age_restriction == 6):
        return "usk18"
    return "usk0"

def migrate_status(status):
    if (status == 1):
        return "playing"
    if (status == 2):
        return "onPileOfShame"
    if (status == 3):
        return "completed100Percent"
    if (status == 4):
        return "completed"
    if (status == 5):
        return "cancelled"
    if (status == 7):
        return "endlessGame"
    return "onWishList"

def migrate_platform(platform):
    # PC
    if (platform == "PC" or platform == "VR: Oculus" or platform == "PC: XBox"):
        return "PC"
    if (platform == "PC: Steam" or platform == "VR: Steam"):
        return "Steam"
    if (platform == "PC: Gog"):
        return "Gog"
    if (platform == "PC: U-Play"):
        return "Ubi"
    if (platform == "PC: Epic"):
        return "Epic"
    if (platform == "PC: Twitch"):
        return "Twitch"
    if (platform == "PC: Origin"):
        return "EA"
    # Sony
    if (platform == "PlayStation"):
        return "PSX"
    if (platform == "PlayStation 2"):
        return "PS2"
    if (platform == "PlayStation 3"):
        return "PS3"
    if (platform == "PlayStation 4" or platform == "PlayStation 4 (PS+)" or platform == "PlayStation VR"):
        return "PS4"
    if (platform == "PlayStation 5" or platform == "PlayStation 5 (PS+)" or platform == "PlayStation VR 2"):
        return "PS5"
    if (platform == "PlayStation Portable"):
        return "PSP"
    if (platform == "PlayStation Vita"):
        return "PS Vita"
    # Microsoft
    if (platform == "XBox"):
        return "XBox"
    if (platform == "XBox 360"):
        return "XBox 360"
    if (platform == "XBox One"):
        return "XBox One"
    if (platform == "XBox Series S/X"):
        return "XBox Series"
    # Nintendo
    if (platform == "Nintendo Entertainment System"):
        return "NES"
    if (platform == "Super Nintendo Entertainment System"):
        return "SNES"
    if (platform == "Nintendo 64"):
        return "N64"
    if (platform == "Nintendo GameCube"):
        return "GCN"
    if (platform == "Nintendo Wii" or platform == "Virtual Console: Wii"):
        return "Wii"
    if (platform == "Nintendo Wii U"):
        return "Wii U"
    if (platform == "Nintendo Switch" or platform == "Nintendo Switch Online"):
        return "Switch"
    if (platform == "GameBoy"):
        return "GB"
    if (platform == "GameBoy Color"):
        return "GBC"
    if (platform == "GameBoy Advance"):
        return "GBA"
    if (platform == "Nintendo DS"):
        return "NDS"
    if (platform == "Nintendo DSi"):
        return "DSi"
    if (platform == "Nintendo 3DS" or platform == "Virtual Console: 3DS"):
        return "3DS"
    
def migrate_price(price):
    if (price is not None):
        return price
    return 0.0

def migrate_lastModified(lastModified):
    if (lastModified is not None):
        return lastModified
    return date.today().isoformat()

def migrate_game(game):
    platforms = game["platforms"]

    result = []

    for platform in platforms:
        migration = {
            "id": game["uuid"],
            "name": game["title"],
            "platform": migrate_platform(platform),
            "price": migrate_price(game["price"]),
            "lastModified": migrate_lastModified(game["lastUpdated"]),
            "releaseDate": game["releaseDate"],
            "coverArt": game["coverImage"],
            "usk": migrate_age_restriction(game["ageRestriction"]),
            "status": migrate_status(game["gameState"])
        }
        result.append(migration)
    return result

with open('./games_to_migrate.json', mode="r", encoding="utf8") as file:
    # Read file as json
    jsonContents = json.load(file)

    # define the output
    migrated_games = []

    # Perform some conversions on the data
    for game in jsonContents:
        games = migrate_game(game)
        for migrated_game in games:
            migrated_games.append(migrated_game)

    # generate output
    with open('./migrated_games.json', 'w', encoding="utf8") as output:
        json.dump({"games": migrated_games}, output, indent=2, ensure_ascii=False)