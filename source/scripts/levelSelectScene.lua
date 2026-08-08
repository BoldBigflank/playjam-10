local pd <const> = playdate
local gfx <const> = pd.graphics

import "scripts/introScene"
import "scripts/creditsScene"
import "scripts/optionsScene"
import "scripts/levelScene"

import "levels/levels"

class('LevelSelectScene').extends(Room)

function LevelSelectScene:enter(previous)
    LevelSelectScene.super.enter(previous)
    local gridview = pd.ui.gridview.new(0, 20)

    local options = {}
    for _, level in ipairs(LEVELS) do
        table.insert(options, { label = level.name, value = level.name })
    end
    gridview:setNumberOfRows(#LEVELS)
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
    gridviewSprite:moveTo(100, 70)
    gridviewSprite:add()
    self.gridviewSprite = gridviewSprite
end

function LevelSelectScene:update()
    if self.gridview.needsDisplay then
        local gridviewImage = gfx.image.new(200, 100)
        gfx.pushContext(gridviewImage)
        self.gridview:drawInRect(0, 0, 200, 100)
        gfx.popContext()
        self.gridviewSprite:setImage(gridviewImage)
    end
    local crankTicks = pd.getCrankTicks(4)
    if crankTicks > 0 then
        self.gridview:selectNextRow(false)
    elseif crankTicks < 0 then
        self.gridview:selectPreviousRow(false)
    end
end

function LevelSelectScene:upButtonDown()
    self.gridview:selectPreviousRow(true)
end

function LevelSelectScene:downButtonDown()
    self.gridview:selectNextRow(true)
end

function LevelSelectScene:AButtonUp()
    local selected = self.gridview:getSelectedRow()
    print(selected)
    SceneManager:enter(LevelScene)
end

function LevelSelectScene:BButtonUp()
    SceneManager:pop()
end
