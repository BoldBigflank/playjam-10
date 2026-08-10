local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Particles").extends()
class("scripts/libraries/AnimatedSprite")

function Particles:init()
    self.spriteSheet = gfx.imagetable.new("images/sprites-table-16-16.png")
    self.states = {
        {
            name = "puff",
            firstFrameIndex = SPRITES.Puff,
            framesCount = 2,
            tickStep = 8,
            loop = false
        },
        {
            name = "spurt",
            firstFrameIndex = SPRITES.Spurt,
            framesCount = 3,
            tickStep = 4,
            loop = false
        },
        {
            name = "splatter",
            firstFrameIndex = SPRITES.Splatter,
            framesCount = 1,
            loop = false
        },
        {
            name = "explode",
            firstFrameIndex = SPRITES.Explode,
            framesCount = 5,
            loop = false,
            xScale = 1.5,
            yScale = 1.5
        },
        {
            name = "teleport",
            firstFrameIndex = SPRITES.Teleport,
            framesCount = 8,
            loop = false,
            xScale = 1.5,
            yScale = 1.5,
            tickStep = 3
        },
        {
            name = 'death',
            firstFrameIndex = SPRITES.Death,
            framesCount = 7,
            loop = false,
            xScale = 1.5,
            yScale = 1.5,
            tickStep = 3
        }
    }
    -- Initialize the pool
    self.pool = {}
    -- I can't figure out why pre-allocating the pool is making the animation end event not work on pre-allocated sprites
end

function Particles:addSpriteToPool()
    local sprite = AnimatedSprite.new(self.spriteSheet, self.states, false)
    sprite.isInUse = false
    table.insert(self.pool, sprite)
    return self.pool[#self.pool]
end

function Particles:getFromPool()
    for i, sprite in ipairs(self.pool) do
        if not sprite.isInUse then
            sprite.isInUse = true
            return sprite
        end
    end
    -- If pool is exhausted, create a new sprite
    local sprite = self:addSpriteToPool()
    sprite.isInUse = true
    return sprite
end

function Particles:returnToPool(sprite)
    sprite:stopAnimation()
    sprite.isInUse = false
    sprite:setVisible(false)
end

function Particles:emit(name, x, y, persist)
    local sprite = self:getFromPool()
    sprite:setVisible(true)
    sprite:moveTo(x, y)
    sprite:stopAnimation()

    -- Set the animation end event for this specific emission
    local state = sprite.states[name]
    state.onAnimationEndEvent = function()
        if not persist then
            self:returnToPool(sprite)
        end
    end

    sprite:changeState(name, true)
    sprite:playAnimation()
    sprite:setZIndex(name == 'teleport' and Z_INDEXES.Bullet or Z_INDEXES.Particle)
    return sprite
end

function Particles:clearPool()
    for _, sprite in ipairs(self.pool) do
        self:returnToPool(sprite)
    end
end

Particles = Particles()
