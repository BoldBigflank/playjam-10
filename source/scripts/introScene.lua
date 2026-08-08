-- shorthand variables
local pd <const> = playdate
local gfx <const> = pd.graphics

class('IntroScene').extends(Room)

local text = {
    'You are humanity\'s last hope\nof stopping an alien invasion.\nYou are given two weapons.',
    'The Reflect Gun shoots disks\nthat bounce off walls. Hit\nenemies around corners.',
    'The Float Gun lobs explosive\ncharges over walls. Very\neffective, but be careful',
    'You will always have another\nsoldier to take over, but the\nweapons will not refill.',
    'Press Menu to view your controls.'
}

function IntroScene:enter()
    local bgImage = gfx.image.new('images/intro')
    local mapSprite = gfx.sprite.new(bgImage)
    mapSprite:setCenter(0, 0)
    mapSprite:moveTo(0, 0)
    mapSprite:add()

    -- Mission image
    local titleSprite = Utils:textSprite(text[1])
    titleSprite:setCenter(0, 0)
    titleSprite:moveTo(80, 16)
    titleSprite:add()

    local titleSprite = Utils:textSprite(text[2])
    titleSprite:setCenter(0, 0)
    titleSprite:moveTo(128, 64)
    titleSprite:add()

    local titleSprite = Utils:textSprite(text[3])
    titleSprite:setCenter(0, 0)
    titleSprite:moveTo(80, 112)
    titleSprite:add()

    local titleSprite = Utils:textSprite(text[4])
    titleSprite:setCenter(0, 0)
    titleSprite:moveTo(128, 160)
    titleSprite:add()

    local titleSprite = Utils:textSprite(text[5])
    titleSprite:setCenter(0.5, 0)
    titleSprite:moveTo(200, 208)
    titleSprite:add()

    local aButtonSprite = AnimatedSprite(Utils:getSpritesheet())
    aButtonSprite:addState("idle", 1, 1,
        { xScale = 2, yScale = 2, frames = { SPRITES.AButton, SPRITES.Empty }, tickStep = 6 })
    aButtonSprite:changeState('idle', true)
    aButtonSprite:moveTo(400 - 32, 240 - 32)
end

function IntroScene:AButtonDown()
    self.canAdvance = true
end

function IntroScene:AButtonUp()
    if not self.canAdvance then return end
    -- SoundPlayer:playSound(SOUNDS.Shoot)
    -- SceneManager:enter(MissionBriefingScene)
end
