local pd <const> = playdate
local gfx <const> = pd.graphics

class('Arm').extends(gfx.sprite)

local STATE = {
    Completed = 1,
    Failed = 2,
    Active = 3,
}

local MAX_SPEED = 1

function Arm:init(entity)
    Arm.super.init(self)
    self:setZIndex(Z_INDEXES.Arm)
    self:setTag(TAGS.Arm)
    self:setGroups({ TAGS.Arm })
    self:setCollidesWithGroups({ TAGS.Ball, TAGS.Wall, TAGS.Arm, TAGS.Player })

    -- Settings
    self.length = entity.height or 8
    self.thickness = entity.width or 8
    self.direction = entity.direction or DIRECTIONS.Up
    self.state = STATE.Active
    self.failed = false
    self.speed = 0.25

    if self.direction == DIRECTIONS.Right then
        self:setCenter(0, 0.5)
    elseif self.direction == DIRECTIONS.Left then
        self:setCenter(1, 0.5)
    elseif self.direction == DIRECTIONS.Up then
        self:setCenter(0.5, 1)
    elseif self.direction == DIRECTIONS.Down then
        self:setCenter(0.5, 0)
    end

    self:applySize()
    self:add()
    self:moveTo(entity.x, entity.y)
    Events:on(EVENTS.CrankChange, function(change, acceleratedChange)
        if self.state ~= STATE.Active then return end
        local frameDistance = math.min(change * self.speed, MAX_SPEED)
        self.length = math.max(self.length + frameDistance, 8)
        self:applySize()
    end)
    Events:emit(EVENTS.ArmCreated, self)
end

function Arm:applySize()
    if self.direction == DIRECTIONS.Left or self.direction == DIRECTIONS.Right then
        self:setSize(self.length, self.thickness)
    else
        self:setSize(self.thickness, self.length)
    end
    self:markDirty()
    self:setCollideRect(0, 0, self:getSize())
end

function Arm:draw(x, y, width, height)
    local w, h = self:getSize()
    local fillColor = self.state == STATE.Completed and gfx.kColorBlack or gfx.kColorWhite
    gfx.setColor(fillColor)
    gfx.fillRect(0, 0, w, h)
    gfx.setColor(gfx.kColorBlack)
    gfx.drawRect(0, 0, w, h)
end

function Arm:collisionResponse(other)
    return gfx.sprite.kCollisionTypeOverlap
end

function Arm:update()
    self:setCollideRect(0, 0, self:getSize())
    if self.state ~= STATE.Active then return end
    local actualX, actualY, collisions, collisionCount = self:checkCollisions(self:getPosition())
    for i = 1, collisionCount do
        local collision = collisions[i]
        local other = collision.other
        local touch = collision.touch
        if other:getTag() == TAGS.Wall or other:getTag() == TAGS.Arm then
            self.state = STATE.Completed
            Events:emit(EVENTS.ArmCompleted, self)
            Particles:emit('explode', touch.x, touch.y)
            -- replace the arm with a wall
            -- account for the center of the arm (wall center is 0, 0)
            local x, y, width, height = self:getBounds()
            Events:emit(EVENTS.CellsClaimed, Utils:cellCoordsFromRect(x, y, width, height))
            SoundPlayer:playSound(SOUNDS.Shoot)
            break
        end
    end
end

function Arm:hitByBall()
    if self.state ~= STATE.Active then return end
    Events:emit(EVENTS.ArmDestroyed, self)
    -- remove the collision
    self:setGroups({})
    self:setCollidesWithGroups({})
    self.state = STATE.Failed
    self:remove()
end
