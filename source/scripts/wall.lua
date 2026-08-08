local pd <const> = playdate
local gfx <const> = pd.graphics

class('Wall').extends(gfx.sprite)

function Wall:init(entity)
    printTable(entity)
    self.nineSlice = gfx.nineSlice.new('images/wall', 8, 8, 16, 16)
    Wall.super.init(self)
    self:setZIndex(Z_INDEXES.Wall)

    -- Settings
    self.height = entity.height or 16
    self.width = entity.width or 16
    self.direction = entity.direction or DIRECTIONS.Horizontal

    local wallImage = gfx.image.new(self.width, self.height)
    self.wallImage = wallImage
    gfx.pushContext(wallImage)
    self.nineSlice:drawInRect(0, 0, self.width, self.height)
    gfx.popContext()
    self:setSize(self.width, self.height)
    self:setImage(wallImage)
    if self.direction == DIRECTIONS.Right then
        self:setCenter(0, 0.5)
    elseif self.direction == DIRECTIONS.Left then
        self:setCenter(1, 0.5)
    elseif self.direction == DIRECTIONS.Up then
        self:setCenter(0.5, 1)
    elseif self.direction == DIRECTIONS.Down then
        self:setCenter(0.5, 0)
    end
    self:add()
    self:moveTo(entity.x, entity.y)
end

function Wall:update()
    -- print(self.x, self.y, self.width, self.height)
    -- self:setSize(self.width, self.height)
end
