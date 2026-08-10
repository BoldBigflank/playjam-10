local pd <const> = playdate
local sound <const> = pd.sound

class('SoundPlayer').extends()

function SoundPlayer:init()
    SoundPlayer.super.init()
end

function SoundPlayer:playSound(name)
    local s = nil
    s = sound.sampleplayer.new(name)
    s:play()
end

SoundPlayer = SoundPlayer()
