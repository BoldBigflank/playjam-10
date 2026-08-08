local pd <const> = playdate
local gfx <const> = pd.graphics

import "scripts/introScene"
import "scripts/creditsScene"
import "scripts/optionsScene"

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

    self.balls = {}
    for i = 1, LEVELS[1].balls do
        self.balls[i] = Ball()
    end

    self.walls = {}
    self.walls[1] = Wall({ x = 16, y = 8, width = 256, height = 16, direction = DIRECTIONS.Right })
    self.walls[2] = Wall({ x = 16, y = 192, width = 256, height = 16, direction = DIRECTIONS.Right })
    self.walls[3] = Wall({ x = 8, y = 0, width = 16, height = 192, direction = DIRECTIONS.Down })
    self.walls[4] = Wall({ x = 256 + 16, y = 0, width = 16, height = 192, direction = DIRECTIONS.Down })
end

function LevelScene:update()
    self.player:update()
end
