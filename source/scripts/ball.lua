local pd <const> = playdate
local gfx <const> = pd.graphics

class('Ball').extends(gfx.sprite)

function Ball:init()
    local spritesheet = Utils:getSpritesheet()
    Ball.super.init(self)
    self.width = 16
    self.height = 16
    self:setSize(self.width, self.height)
    self.collideWidth = self.width - 4
    self.collideHeight = self.height - 4

    -- Sprite
    self:setZIndex(Z_INDEXES.Ball)
    self:setCollideRect(
        0.5 * (self.width - self.collideWidth),
        0.5 * (self.height - self.collideHeight),
        self.collideWidth,
        self.collideHeight
    )
    self:setImage(spritesheet:getImage(SPRITES.BulletLarge))
    self:setTag(TAGS.Ball)
    self:setGroups({ TAGS.Ball })
    self:setCollidesWithGroups({ TAGS.Wall, TAGS.Ball, TAGS.Arm })


    -- Settings
    self.x = math.random(16, 400 - 32)
    self.y = math.random(16, 240 - 32)
    self.speed = 1
    self.angle = math.random() * 2 * math.pi
    self.rot = 0

    self:moveTo(self.x, self.y)
    self:add()
end

function Ball:update()
    local goalX, goalY = Utils:moveForwardAtAngle(self.x, self.y, self.angle, self.speed)
    local actualX, actualY, collisions, length = self:moveWithCollisions(goalX, goalY)
    if length > 0 then
        for i = 1, length do
            local collision = collisions[i]
            local bounce = collision.bounce
            local touch = collision.touch
            local other = collision.other

            if other:getTag() == TAGS.Arm then
                other:hitByBall()
            end

            -- set the angle to the vector created by touch to bounce
            if touch and bounce then
                local angle = Utils:lookAt(touch.x, touch.y, bounce.x, bounce.y)
                self.angle = angle
            end
        end
    end
end

function Ball:getCellCoords()
    return Utils:cellCoordsFromPoint(self.x, self.y)
end

function Ball:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Player or tag == TAGS.Ball then
        return gfx.sprite.kCollisionTypeOverlap
    end
    return gfx.sprite.kCollisionTypeBounce
end
