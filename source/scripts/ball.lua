local pd <const> = playdate
local gfx <const> = pd.graphics

class('Ball').extends(gfx.sprite)

function Ball:init()
    local spritesheet = Utils:getSpritesheet()
    Ball.super.init(self)

    -- Sprite
    self:setZIndex(Z_INDEXES.Ball)
    self:setCollideRect(0, 0, self:getSize())
    self:setImage(spritesheet:getImage(SPRITES.BulletLarge))
    self:setTag(TAGS.Ball)
    self:setGroups({ TAGS.Ball })
    self:setCollidesWithGroups({ TAGS.Player })

    -- Settings
    self.x = 200
    self.y = 100
    self.speed = 3
    self.rot = 0

    self:moveTo(self.x, self.y)
    self:add()
end

function Ball:update()
    self:moveTo(self.x + self.speed * math.cos(self.rot), self.y + self.speed * math.sin(self.rot))
end
