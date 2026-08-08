import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('OptionsScene').extends(PauseRoom)

function OptionsScene:enter(previous, ...)
    OptionsScene.super.enter(self, previous, ...)
    local dpadTank = 'Tank:\n' ..
        ' Up - Move forward\n' ..
        ' Down - Move back\n' ..
        ' Left - Turn left\n' ..
        ' Right - Turn right\n'
    local dpadModern = 'Modern:\n' ..
        ' Up - Move forward\n' ..
        ' Down - Move back\n' ..
        ' Left - Turn left\n' ..
        ' Right - Turn right\n'
    local crankButtons = 'Buttons:\n' ..
        ' A - Fire\n' ..
        ' B - Move Forwad\n' ..
        ' Down - Swap\n'
    local crankDpad = 'Dpad:\n' ..
        ' Up - Move forward\n' ..
        ' Down - Move back\n' ..
        ' Left - Fire\n' ..
        ' Right - Fire\n' ..
        ' B - Swap\n'


    local defs = {
        {
            header = "Preferences",
            options = {
                {
                    name = 'No Crank Control',
                    key = "dpadControl",
                    values = { 'Tank', 'Modern' },
                    tooltip = dpadTank .. dpadModern
                },
                {
                    name = 'Crank Control',
                    key = "crankControl",
                    values = { 'A-Fire', 'L/R Fire' },
                    tooltip = crankButtons .. crankDpad
                },
            }
        },
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
