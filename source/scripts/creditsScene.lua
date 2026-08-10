import "CoreLibs/animator"

-- shorthand variables
local pd <const> = playdate
local gfx <const> = pd.graphics

class('CreditsScene').extends(PauseRoom)

local text = {
    'Alex Swan created this game.\nHe does game dev and\nweb development in Chicago.',
    'Created in one week for\nPlayJam 10 (August 2026)\nTheme: Swap',
    'Made using Aseprite,\nSquidGod Tutorials,\nand Roomy and AnimatedSprite libs',
    'Some sounds and images were\nderived from Kenney\'s\nAll-in-1 Asset Pack.',
    ''
}

function CreditsScene:enter(previous, ...)
    print('credits scene enter')
    if (previous.className == self.className) then SceneManager:pop() end
    CreditsScene.super.enter(self, previous, ...)
    local bgImage = gfx.image.new(400, 240)
    gfx.pushContext(bgImage)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 240)
    gfx.setColor(gfx.kColorBlack)
    local bgSprite = gfx.sprite.new(bgImage)
    bgSprite:setCenter(0, 0)
    bgSprite:moveTo(0, 240)
    bgSprite:add()

    local titleImage = Utils:textImage(text[1])
    if titleImage == nil then return end
    -- titleImage:setCenter(0, 0)
    titleImage:draw(80, 16)

    local titleImage = Utils:textImage(text[2])
    if titleImage == nil then return end
    -- titleImage:setCenter(0, 0)
    titleImage:draw(128, 64)

    local titleImage = Utils:textImage(text[3])
    if titleImage == nil then return end
    -- titleImage:setCenter(0, 0)
    titleImage:draw(80, 112)

    local titleImage = Utils:textImage(text[4])
    if titleImage == nil then return end
    -- titleImage:setCenter(0, 0)
    titleImage:draw(128, 160)

    gfx.popContext()

    -- local aButtonSprite = AnimatedSprite(Utils:getSpritesheet())
    -- aButtonSprite:addState("idle", 1, 1,
    --     { xScale = 2, yScale = 2, frames = { SPRITES.AButton, SPRITES.Empty }, tickStep = 6 })
    -- aButtonSprite:changeState('idle', true)
    -- aButtonSprite:moveTo(400 - 32, 240 - 32)
    -- self.bgImage = bgImage
    self.bgSprite = bgSprite
    -- 1000ms, or 1 second
    local animationDuration = 500
    -- We're animating from the left to the right of the screen
    local startY, endY = 240, 0
    local easingFunction = playdate.easingFunctions.outQuint
    local animator = playdate.graphics.animator.new(animationDuration, startY, endY, easingFunction)
    animator.repeatCount = 0 -- Make animator repeat forever
    self.animator = animator
end

function CreditsScene:update()
    -- self.bgImage:draw(0, self.animator:currentValue())
    self.bgSprite:moveTo(0, self.animator:currentValue())
end

function CreditsScene:AButtonDown()
    self.canAdvance = true
end

function CreditsScene:AButtonUp()
    print('credits scene AButtonUp')
    if not self.canAdvance then return end
    -- SoundPlayer:playSound(SOUNDS.Shoot)
    SceneManager:pop()
end

function CreditsScene:BButtonUp()
    SceneManager:pop()
end
