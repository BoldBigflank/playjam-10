local pd <const> = playdate
local gfx <const> = pd.graphics

import "scripts/arm"

class('Player').extends(gfx.sprite)

function Player:init()
    -- Sprite
    local spritesheet = Utils:getSpritesheet()
    Player.super.init(self)
    -- self:setZIndex(entity.zIndex)
    self:setImage(spritesheet:getImage(SPRITES.Player))
    self:setZIndex(Z_INDEXES.Player)
    self:setCollideRect(0, 0, self:getSize())
    -- self:moveTo(entity.position.x + gameScene.offsetX, entity.position.y + gameScene.offsetY)
    self:setTag(TAGS.Player)
    self:setGroups({ TAGS.Player })
    self:setCollidesWithGroups({ TAGS.Wall, TAGS.Arm })

    -- Settings
    self.collideWidth = self.width - 4
    self.collideHeight = self.height - 4
    self.rot = 0
    self.speed = 3
    self.x = 100
    self.y = 100
    self.armsCount = 0
    self.facingVertical = false
    self:moveTo(self.x, self.y)
    self:add()

    -- events
    Events:on(EVENTS.ArmCreated, function()
        self.armsCount = self.armsCount + 1
    end)
    Events:on(EVENTS.ArmDestroyed, function()
        self.armsCount = self.armsCount - 1
    end)
    Events:on(EVENTS.ArmCompleted, function()
        self.armsCount = self.armsCount - 1
    end)
end

function Player:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Wall then
        return gfx.sprite.kCollisionTypeSlide
    end
    return gfx.sprite.kCollisionTypeOverlap
end

function Player:isAbleToCreateArms()
    local isAble = true
    if self.armsCount > 0 then return false end
    local actualX, actualY, collisions, collisionCount = self:checkCollisions(self:getPosition())
    if collisionCount == 0 then return true end
    for i = 1, collisionCount do
        local collision = collisions[i]
        local other = collision.other
        print('other: ' .. other:getTag())
        if other:getTag() == TAGS.Wall or other:getTag() == TAGS.Arm then
            isAble = false
        end
    end
    return isAble
end

function Player:update()
    self:setCollideRect(
        0.5 * (self.width - self.collideWidth),
        0.5 * (self.height - self.collideHeight),
        self.collideWidth,
        self.collideHeight
    )

    -- Move with the direction pad
    if self:isAbleToCreateArms() then
        change, acceleratedChange = pd.getCrankChange()
        print('change: ' .. change .. ' acceleratedChange: ' .. acceleratedChange)
        if change > 0 then
            -- place arms at the player
            local arm = Arm({
                x = self.x,
                y = self.y,
                height = 8,
                direction = self.facingVertical and DIRECTIONS.Right or
                    DIRECTIONS.Up
            })
            local arm2 = Arm({
                x = self.x,
                y = self.y + 1,
                height = 8,
                direction = self.facingVertical and
                    DIRECTIONS.Left or DIRECTIONS.Down
            })
        end
    end
    if self.armsCount == 0 then
        local desiredX = self.x
        local desiredY = self.y
        local x = 0
        local y = 0
        if pd.buttonIsPressed(pd.kButtonUp) then
            y -= 1
            self.facingVertical = true
        end
        if pd.buttonIsPressed(pd.kButtonDown) then
            y += 1
            self.facingVertical = true
        end
        if (pd.buttonIsPressed(pd.kButtonLeft)) then
            x -= 1
            self.facingVertical = false
        end
        if (pd.buttonIsPressed(pd.kButtonRight)) then
            x += 1
            self.facingVertical = false
        end
        if x * x + y * y > 0 then
            self.rot = Utils:lookAt(0, 0, x, y)
            desiredX, desiredY = Utils:moveForwardAtAngle(self.x, self.y, self.rot, self.speed)
        end
        self:moveWithCollisions(desiredX, desiredY)
        self:setRotation(math.deg(self.rot))
    end
end
