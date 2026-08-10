local pd <const> = playdate
local gfx <const> = pd.graphics

class('Playfield').extends()

local CELL_STATES = {
    ACTIVE = 0,
    WALLED = 2,
    FILLED = 3,
}

function Playfield:init(level)
    self.level = level
    self.eventIds = {}
    self.width = 400 / CELL_SIZE
    self.height = 240 / CELL_SIZE
    self.totalCells = self.width * self.height
    -- 1d array of active cells
    self.cells = table.create(self.width * self.height)
    self.activeCellsCount = self.width * self.height
    for x = 0, self.width - 1 do
        for y = 0, self.height - 1 do
            self.cells[x + y * self.width] = true
        end
    end
    -- local graph = pd.pathfinder.graph.new2DGrid(self.width, self.height, false)
    -- self.graph = graph
    table.insert(self.eventIds, Events:on(EVENTS.CellsClaimed, function(x1, y1, x2, y2)
        print('cells claimed', x1, y1, x2, y2)
        -- from x1, y1 to x2, y2, set the cells to unwalkable
        for x = x1, x2 do
            for y = y1, y2 do
                self:setCell(x, y, CELL_STATES.WALLED)
                -- self.graph:removeNodeWithXY(x, y)
                -- self.cells[x + y * self.width] = false
            end
        end
        self:updateActiveCells()
    end))
end

function Playfield:getCell(x, y)
    return self.cells[(x - 1) + (y - 1) * self.width]
end

function Playfield:setCell(x, y, state)
    if state ~= CELL_STATES.ACTIVE then print('setting cell', x, y, 'to', state) end
    self.cells[(x - 1) + (y - 1) * self.width] = state
end

function Playfield:updateActiveCells()
    -- Go through the cells, set all ACTIVE cells to FILLED
    for i = 1, #self.cells do
        local cell = self.cells[i]
        if not cell or cell == CELL_STATES.ACTIVE then
            self.cells[i] = CELL_STATES.FILLED
        end
    end
    self.activeCellsCount = 0

    -- Iterate on the balls
    local balls = self.level:getBalls()
    for i = 1, #balls do
        local ball = balls[i]
        local ballX, ballY = ball:getCellCoords()
        -- flood fill cells
        self:floodFill(ballX, ballY, { { ballX, ballY } })
    end
    print('active cells count', self.activeCellsCount)
    self:printCells()
    Events:emit(EVENTS.PlayfieldUpdated, self.activeCellsCount, self.totalCells)
end

function Playfield:floodFill(x, y, previousCells)
    -- 1 indexed
    local cell = self:getCell(x, y)
    if not cell then return end                   -- out of bounds
    if cell == CELL_STATES.WALLED then return end -- walled
    if cell == CELL_STATES.ACTIVE then return end -- already filled

    self:setCell(x, y, CELL_STATES.ACTIVE)
    self.activeCellsCount = self.activeCellsCount + 1
    -- If there is a cell to the right, left, top, or bottom, flood fill it
    local newPreviousCells = table.pack(previousCells, { x, y })
    self:floodFill(x + 1, y, newPreviousCells) -- right
    self:floodFill(x - 1, y, newPreviousCells) -- left
    self:floodFill(x, y + 1, newPreviousCells) -- top
    self:floodFill(x, y - 1, newPreviousCells) -- bottom
end

function Playfield:printCells()
    local cells = ''
    for y = 1, self.height do
        for x = 1, self.width do
            cells = cells .. self:getCell(x, y) .. ' '
        end
        cells = cells .. '\n'
    end
    print(cells)
end

function Playfield:leave()
    for _, id in ipairs(self.eventIds or {}) do
        Events:offById(id)
    end
    self.eventIds = {}
end
