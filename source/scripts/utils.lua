local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Utils").extends()

local tilemap = nil

function Utils:getSpritesheet()
    if not tilemap then
        tilemap = gfx.imagetable.new("images/sprites-table-16-16.png")
    end
    return tilemap
end

function Utils:moveForwardAtAngle(x, y, rot, dist)
    local newX, newY = x, y
    newX += math.sin(rot) * dist
    newY -= math.cos(rot) * dist
    return newX, newY
end

function Utils:lookAt(x, y, targetX, targetY)
    return math.atan(targetX - x, -1 * (targetY - y))
end

function Utils:turnToLookAt(originalRot, desiredRot, maxRotSpeed)
    local twoPi = 2 * math.pi
    local oRot = originalRot + twoPi
    local dRot = desiredRot + twoPi
    local mRot = math.rad(maxRotSpeed)

    local result = dRot - oRot
    result = (result + math.pi) % twoPi - math.pi

    -- maxRotSpeed is in deg/frame
    if result < 0 then
        result = math.max(result, -1 * mRot)
    else
        result = math.min(result, mRot)
    end
    return originalRot + result
end

function Utils:textImage(text)
    local textString = '' .. text
    local textImage = gfx.image.new(gfx.getTextSize(textString))
    gfx.pushContext(textImage)
    gfx.drawText(textString, 0, 0)
    gfx.popContext()
    return textImage
end

function Utils:textSprite(text)
    local textImage = Utils:textImage(text)
    local textSprite = gfx.sprite.new(textImage)
    textSprite:add()
    return textSprite
end

function Utils:textSpriteInRect(text, width, height)
    local textImage = gfx.image.new(width, height)
    gfx.pushContext(textImage)
    gfx.drawTextInRect(text, 0, 0, width, height, nil, nil, kTextAlignment.left)
    gfx.popContext()
    local textSprite = gfx.sprite.new(textImage)
    textSprite:add()
    return textSprite
end

Utils = Utils()
