class('GameManager').extends()

local pd <const> = playdate
local gfx <const> = pd.graphics

function GameManager:init()
    self.score = 0
    self.levelIndex = 1
end

function GameManager:getLevelIndex()
    return self.levelIndex
end

function GameManager:saveData()
    local saveData = {
        score = self.score,
        levelIndex = self.levelIndex,
        version = SAVEDATA_VERSION
    }
    pd.datastore.write(saveData)
end

function GameManager:loadData()
    local savedata = pd.datastore.read()
    if savedata == nil then return end
    self:reset()
    if SAVEDATA_VERSION ~= savedata['version'] then return end
    self.score = savedata.score
    self.levelIndex = savedata.levelIndex
end

function GameManager:reset()
    self.score = 0
    self.levelIndex = 1
end

GameManager = GameManager()
