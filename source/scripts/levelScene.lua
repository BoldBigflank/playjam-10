local pd <const> = playdate
local gfx <const> = pd.graphics

import "scripts/introScene"
import "scripts/creditsScene"
import "scripts/optionsScene"
import "scripts/playfield"
import "scripts/player"
import "scripts/ball"
import "scripts/wall"
import "scripts/levelEndScene"

class('LevelScene').extends(Room)

function LevelScene:enter(previous)
    self:resetScene()
    self:setupEntities()

    -- Progress UI Bar sprite
    self.progressBar = gfx.sprite.new()
    self.progressBar:moveTo(0, 0)
    self.progressBar:setZIndex(100)
    self.progressBar:setVisible(true)
    self.progressBar:add()
    self:updateProgress(0)

    table.insert(self.eventIds, Events:on(EVENTS.PlayfieldUpdated, function(activeCellsCount, totalCells)
        if self.ended then return end
        self:updateProgress(math.floor((1 - (activeCellsCount / totalCells)) / 0.7))
    end))
    table.insert(self.eventIds, Events:on(EVENTS.ArmDestroyed, function(arm)
        if self.ended then return end
        GameManager:setLives(GameManager:getLives() - 1)
        self:updateHearts()
        if GameManager:getLives() <= 0 then
            self.ended = true
            Particles:emit('death', self.player.x, self.player.y)
            -- wait 1 second
            pd.timer.performAfterDelay(1000, function()
                SceneManager:enter(LevelEndScene, "Ran out of lives", true)
            end)
        end
    end))
end

function LevelScene:leave(next, ...)
    for _, id in ipairs(self.eventIds or {}) do
        Events:offById(id)
    end
    self.eventIds = {}
    LevelScene.super.leave(self, next, ...)
end

function LevelScene:resetScene()
    gfx.sprite.removeAll()
    self.eventIds = {}
    self.ended = false
    self.screenShake = 0
    self.screenShakeAngle = 0
    self.hearts = {}
    self:updateHearts()
end

function LevelScene:updateProgress(progress)
    progress = math.clamp(progress, 0, 1)

    local progressImage = self.progressBar:getImage(400, 16)
    gfx.pushContext(progressImage)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 16)
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(0, 0, 400 * progress, 16)
    gfx.popContext()
    self.progressBar:setImage(progressImage)
    if progress >= 1 then
        self.ended = true
        SceneManager:enter(LevelEndScene, "Victory!", false)
    end
end

function LevelScene:updateHearts()
    local spritesheet = Utils:getSpritesheet()
    local heartSprite = spritesheet:getImage(SPRITES.BigHeart)

    -- remove all hearts
    for i = 1, #self.hearts do
        self.hearts[i]:remove()
    end
    self.hearts = {}
    -- add hearts for each life
    for i = 1, GameManager:getLives() do
        self.hearts[i] = gfx.sprite.new()
        self.hearts[i]:setImage(heartSprite)
        self.hearts[i]:moveTo(400 - 32, 32 + 24 * i)
        self.hearts[i]:setZIndex(Z_INDEXES.UI)
        self.hearts[i]:setVisible(true)
        self.hearts[i]:add()
    end
end

function LevelScene:setupEntities()
    self.player = Player()
    self.playfield = Playfield(self)

    self.balls = {}
    for i = 1, GameManager:getBallCount() do
        self.balls[i] = Ball()
    end

    self.walls = {}
    self.walls[1] = Wall({ x = 0, y = 0, width = 16, height = 240 })              -- left wall
    self.walls[2] = Wall({ x = 400 - 64, y = 0, width = 64, height = 240 })       -- right wall
    self.walls[3] = Wall({ x = 16, y = 0, width = 400 - 80, height = 16 })        -- top wall
    self.walls[4] = Wall({ x = 16, y = 240 - 16, width = 400 - 80, height = 16 }) -- bottom wall

    Particles:emit('teleport', self.player.x, self.player.y)
end

function LevelScene:getBalls()
    return self.balls
end

function LevelScene:update()
    self.player:update()
    local change, acceleratedChange = pd.getCrankChange()
    Events:emit(EVENTS.CrankChange, change, acceleratedChange)
end

function LevelScene:leave(next)
    LevelScene.super.leave(next)
    for _, id in ipairs(self.eventIds or {}) do
        Events:offById(id)
    end
    self.eventIds = {}
    self.playfield:leave()
end
