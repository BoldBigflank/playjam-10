local pd <const> = playdate
local gfx <const> = pd.graphics

import "scripts/introScene"
import "scripts/creditsScene"
import "scripts/optionsScene"

class('Player').extends(gfx.sprite)

function Player:init()
    -- Sprite
    local spritesheet = Utils:getSpritesheet()
    Player.super.init(self)
    -- self:setZIndex(entity.zIndex)
    self:setCollideRect(0, 0, self:getSize())
    self:setImage(spritesheet:getImage(SPRITES.Player))
    -- self:moveTo(entity.position.x + gameScene.offsetX, entity.position.y + gameScene.offsetY)
    self:setTag(TAGS.Player)
    self:setGroups({ TAGS.Player })
    self:setCollidesWithGroups({ TAGS.Pickup, TAGS.Hazard, TAGS.Enemy, TAGS.Wall, TAGS.Trigger })

    -- Settings
    self.rot = 0
    self.speed = 3
    self.x = 100
    self.y = 100
    self:moveTo(self.x, self.y)
    self:add()
end

function Player:update()
    -- Move with the direction pad
    local desiredX = self.x
    local desiredY = self.y
    local x = 0
    local y = 0
    if pd.buttonIsPressed(pd.kButtonUp) then
        y -= 1
    end
    if pd.buttonIsPressed(pd.kButtonDown) then
        y += 1
    end
    if (pd.buttonIsPressed(pd.kButtonLeft)) then
        x -= 1
    end
    if (pd.buttonIsPressed(pd.kButtonRight)) then
        x += 1
    end
    if x * x + y * y > 0 then
        self.rot = Utils:lookAt(0, 0, x, y)
        desiredX, desiredY = Utils:moveForwardAtAngle(self.x, self.y, self.rot, self.speed)
    end
    self:moveTo(desiredX, desiredY)
    self:setRotation(math.deg(self.rot))
end
