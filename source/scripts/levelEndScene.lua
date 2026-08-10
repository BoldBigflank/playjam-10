-- shorthand variables
local pd <const> = playdate
local gfx <const> = pd.graphics

import "levels/levels"

class('LevelEndScene').extends(Room)

function LevelEndScene:enter(previous, text, badEnding)
    local gameOverSprite = Utils:textSprite(text or "")
    gameOverSprite:moveTo(200, 80)

    local gridview = pd.ui.gridview.new(0, 20)
    local options = {
        { label = "Restart Level", value = "restart_level" }
    }
    if not badEnding then
        table.insert(options, { label = "Next Level", value = "next_level" })
    end
    gridview:setNumberOfRows(#options)
    gridview:setCellPadding(0, 0, 5, 0)
    function gridview:drawCell(section, row, column, selected, x, y, width, height)
        if selected then
            gfx.fillRoundRect(x, y, width, height, 6)
            gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        else
            gfx.setImageDrawMode(gfx.kDrawModeCopy)
        end
        local cellText = options[row].label
        local fontHeight = gfx.getSystemFont():getHeight()
        gfx.drawTextInRect(cellText, x, y + (height / 2 - fontHeight / 2) + 6, width, height, nil, nil,
            kTextAlignment.center)
    end

    self.gridview = gridview

    local gridviewSprite = gfx.sprite.new()
    gridviewSprite:setCenter(0, 0)
    gridviewSprite:moveTo(100, 140)
    gridviewSprite:add()
    self.gridviewSprite = gridviewSprite
    self.options = options
end

function LevelEndScene:update()
    if self.gridview == nil or not self.gridview.needsDisplay then return end

    local gridviewImage = gfx.image.new(200, 100)
    gfx.pushContext(gridviewImage)
    self.gridview:drawInRect(0, 0, 200, 100)
    gfx.popContext()
    self.gridviewSprite:setImage(gridviewImage)
end

function LevelEndScene:upButtonDown()
    self.gridview:selectPreviousRow(true)
end

function LevelEndScene:downButtonDown()
    self.gridview:selectNextRow(true)
end

function LevelEndScene:AButtonDown()
    self.canAdvance = true
end

function LevelEndScene:AButtonUp()
    if not self.canAdvance then return end
    self.canAdvance = false

    local selected = self.options[self.gridview:getSelectedRow()]

    if selected.value == 'restart_level' then
        GameManager:setLives(3)
        SceneManager:enter(LevelScene)
    elseif selected.value == 'next_level' then
        GameManager:setBallCount(GameManager:getBallCount() + 1)
        GameManager:setLives(3)
        SceneManager:enter(LevelScene)
    end
end
