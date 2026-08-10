local pd <const> = playdate
local gfx <const> = pd.graphics

import "scripts/introScene"
import "scripts/creditsScene"
import "scripts/optionsScene"
import "scripts/playfield"
import "scripts/player"
import "scripts/ball"
import "scripts/wall"

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
    self.playfield = Playfield(self)

    self.balls = {}
    for i = 1, LEVELS[1].balls do
        self.balls[i] = Ball()
    end

    self.walls = {}
    self.walls[1] = Wall({ x = 0, y = 0, width = 16, height = 240 })              -- left wall
    self.walls[2] = Wall({ x = 400 - 64, y = 0, width = 64, height = 240 })       -- right wall
    self.walls[3] = Wall({ x = 16, y = 0, width = 400 - 80, height = 16 })        -- top wall
    self.walls[4] = Wall({ x = 16, y = 240 - 16, width = 400 - 80, height = 16 }) -- bottom wall
end

function LevelScene:getBalls()
    return self.balls
end

function LevelScene:update()
    self.player:update()
    local change, acceleratedChange = pd.getCrankChange()
    Events:emit(EVENTS.CrankChange, change, acceleratedChange)
end
