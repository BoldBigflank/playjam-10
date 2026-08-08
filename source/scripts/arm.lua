local pd <const> = playdate
local gfx <const> = pd.graphics

class('Arm').extends(gfx.sprite)

function Arm:init(entity)
    local spritesheet = Utils:getSpritesheet()
    Arm.super.init(self)
    self:setImage(spritesheet:getImage(SPRITES.ProximityDoor))
    self:setZIndex(Z_INDEXES.Arm)
    self:setTag(TAGS.Arm)
    self:setGroups({ TAGS.Arm })
    self:setCollidesWithGroups({ TAGS.Ball, TAGS.Wall, TAGS.Arm, TAGS.Player })

    -- Settings
    self.height = entity.height or 8
    print('height: ' .. self.height)
    self.width = entity.width or 8
    self.direction = entity.direction or DIRECTIONS.Up
    self.completed = false
    self.speed = 0.2

    self:setCenter(0.5, 1)
    if self.direction == DIRECTIONS.Right then
        self:setRotation(90)
    elseif self.direction == DIRECTIONS.Left then
        self:setRotation(270)
    elseif self.direction == DIRECTIONS.Up then
        self:setRotation(0)
    elseif self.direction == DIRECTIONS.Down then
        self:setRotation(180)
    end
    self:setSize(self.width, self.height)

    self:add()
    self:moveTo(entity.x, entity.y)
    Events:on(EVENTS.CrankChange, function(change, acceleratedChange)
        if self.completed then return end
        self.height = math.max(self.height + change * self.speed, 1)
        print('height: ' .. self.height)
        self.width = math.max(self.width, 8)
        self:setSize(self.width, self.height)
        self:setScale(1, self.height / 16)
        self:setCollideRect(0, 0, self:getSize())
    end)
    Events:emit(EVENTS.ArmCreated, self)
end

function Arm:collisionResponse(other)
    if other:getTag() == TAGS.Player then
        return gfx.sprite.kCollisionTypeOverlap
    end
    return gfx.sprite.kCollisionTypeOverlap
end

function Arm:update()
    self:setCollideRect(0, 0, self:getSize())
    if self.completed then return end
    local actualX, actualY, collisions, collisionCount = self:checkCollisions(self:getPosition())
    for i = 1, collisionCount do
        local collision = collisions[i]
        local other = collision.other
        if other:getTag() == TAGS.Wall then
            print('collision with wall')
            self.completed = true
            Events:emit(EVENTS.ArmCompleted, self)
        end
    end
end
