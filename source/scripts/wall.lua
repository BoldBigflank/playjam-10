local pd <const> = playdate
local gfx <const> = pd.graphics

class('Wall').extends(gfx.sprite)

function Wall:init(entity)
    local x, y, width, height = Utils:snapToCellCoords(entity.x, entity.y, entity.width, entity.height)
    self.nineSlice = gfx.nineSlice.new('images/wall', 8, 8, 16, 16)
    Wall.super.init(self)
    self:setCenter(0, 0)
    self:setZIndex(Z_INDEXES.Wall)
    self:setTag(TAGS.Wall)
    self:setGroups({ TAGS.Wall })
    self:setCollidesWithGroups({ TAGS.Ball })

    -- Settings
    self.height = height
    self.width = width

    local wallImage = gfx.image.new(self.width, self.height)
    self.wallImage = wallImage
    gfx.pushContext(wallImage)
    self.nineSlice:drawInRect(0, 0, self.width, self.height)
    gfx.popContext()
    self:setSize(self.width, self.height)
    self:setImage(wallImage)
    self:add()
    self:moveTo(x, y)
    Events:emit(EVENTS.CellsClaimed, Utils:cellCoordsFromRect(self.x, self.y, self.width, self.height))
end

function Wall:update()
    self:setCollideRect(0, 0, self:getSize())
    -- print(self.x, self.y, self.width, self.height)
    -- self:setSize(self.width, self.height)
end
