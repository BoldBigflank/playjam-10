import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('OptionsScene').extends(PauseRoom)

function OptionsScene:enter(previous, ...)
    OptionsScene.super.enter(self, previous, ...)

    local defs = {
        {
            header = "Save Data",
            options = {
                { name = 'Reset Data', key = Options.RESET }
            }
        }
    }
    local function onHide()
        Opts:saveUserOptions()
        Events:emit('options_changed')
        SceneManager:pop()
    end
    Opts = Options(defs, false, OPTIONS_PATH, onHide)
    Opts:show()
end
