local pd <const> = playdate
local gfx <const> = pd.graphics

import "scripts/introScene"
import "scripts/creditsScene"
import "scripts/optionsScene"

import "scripts/player"

class('LevelScene').extends(Room)

function LevelScene:enter(previous)
    self:resetScene()
    self:setupEntities()
end

function LevelScene:resetScene()
    gfx.sprite.removeAll()
    self.eventIds = {}
    self.screenShake = 0
    self.screenShakeAngle = 0
end

function LevelScene:setupEntities()
    self.player = Player()
    self.walls = {}
end

function LevelScene:update()
    self.player:update()
end
