-- Below is a small example program where you can move a circle
-- around with the crank. You can delete everything in this file,
-- but make sure to add back in a playdate.update function since
-- one is required for every Playdate game!
-- =============================================================

-- Importing libraries used for drawCircleAtPoint and crankIndicator
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "CoreLibs/nineslice"


-- Libraries
import "scripts/libraries/AnimatedSprite"
import "scripts/libraries/RoomyPlaydate"
import "scripts/libraries/PDOptions"
import "scripts/libraries/sequence"

-- Constants
import "scripts/constants"

-- Singletons
import "scripts/utils"
import "scripts/events"
import "scripts/gameManager"

-- Scenes
import "scripts/introScene"
import "scripts/creditsScene"
import "scripts/optionsScene"
import "scripts/menuScene"
import "scripts/levelScene"

-- Localizing commonly used globals
local pd <const> = playdate
local gfx <const> = playdate.graphics

SceneManager = Manager()

function loadGame()
    -- Font
    local font = gfx.font.new('font/topaz_11')
    math.randomseed(playdate.getSecondsSinceEpoch())
    gfx.setFont(font)

    -- Menu Items
    pd.getSystemMenu():addMenuItem('Main Menu', function()
        SceneManager:enter(MenuScene)
    end)
    pd.getSystemMenu():addMenuItem('Credits', function()
        SceneManager:push(CreditsScene)
    end)
    pd.getSystemMenu():addMenuItem('Options', function()
        SceneManager:push(OptionsScene)
    end)


    GameManager:loadData()
end

function pd.update()
    pd.timer.updateTimers()
    gfx.sprite.update()
    sequence.update()
    SceneManager:emit('update')
end

function pd.gameWillTerminate()
    GameManager:saveData()
end

function pd.deviceWillSleep()
    GameManager:saveData()
end

loadGame()
SceneManager:enter(MenuScene)
-- SceneManager:enter(LevelScene)
SceneManager:hook({})
