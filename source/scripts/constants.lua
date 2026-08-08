SAVEDATA_VERSION = '1'

OPTIONS_PATH = 'settings'

TAGS = {
    Wall = 1,
    Pickup = 2,
    Player = 3,
    Bullet = 4,
    Hazard = 5, -- Enemy projectiles are Hazards
    Enemy = 6,
    Trigger = 7
}

Z_INDEXES = {
    Particle = 15,
    -- Enemy = 20,
    Bullet = 100,
    UI = 1000
}

SIZES = {
    Small = 1,
    Medium = 2,
    Large = 3,
    Missile = 4
}

SPRITES = {
    Player = 1,
    PlayerFists = 2,
    PlayerGun = 3,
    PlayerFlameGun = 4,
    PlayerHold = 5,
    PlayerRifle = 6,
    Crosshair = 7,
    BulletLarge = 8,
    BulletSmall = 9,
    Missile = 10,
    Flame = 11,
    MachineGun = 12,
    Trigun = 13,
    FlameGun = 14,
    SelectArrow = 15,
    Empty = 16,
    Grub = 16 * 1 + 1,
    Grub2 = 16 * 1 + 2,
    PlayerPistols = 16 * 1 + 3,
    Button = 16 * 1 + 7,
    ReflectBullet = 16 * 1 + 8,
    DestructibleWall = 16 * 1 + 9,
    ReflectGun = 16 * 1 + 12,
    FloatGun = 16 * 1 + 13,
    Pistols = 16 * 1 + 14,
    Worm = 16 * 2 + 1,
    AButton = 16 * 2 + 5,
    BButton = 16 * 2 + 6,
    DownButton = 16 * 2 + 7,
    BigBug = 16 * 3 + 1,
    AmmoPowerup = 16 * 3 + 5,
    HealthPowerup = 16 * 3 + 6,
    CashPowerup = 16 * 3 + 7,
    SkullPowerup = 16 * 3 + 8,
    Bug = 16 * 4 + 1,
    Crown = 16 * 4 + 7,
    Skull = 16 * 4 + 8,
    Fighter = 16 * 5 + 1,
    DoubleShooter = 16 * 6 + 1,
    Shooter = 16 * 7 + 1,
    ProximityDoor = 16 * 8 + 1,
    TeleporterOff = 16 * 7 + 3,
    Teleporter = 16 * 9 + 1,
    Barrel = 16 * 6 + 5,
    Explode = 16 * 9 + 6,
    Puff = 16 * 9 + 11,
    Spurt = 16 * 9 + 14,
    Splatter = 16 * 10 + 7,
    Teleport = 16 * 8 + 6,
    Death = 16 * 7 + 7
}

SOUNDS = {
    Door = 'sounds/door.wav',
    DoorClose = 'sounds/doorclose.wav',
    Laser = 'sounds/laser.wav',
    Button = 'sounds/button.wav',
    Explode = 'sounds/explode.wav',
    Explode2 = 'sounds/explode2',
    Shoot = 'sounds/shoot',
    Float = 'sounds/float',
    Teleport = 'sounds/teleport',
    Bite = 'sounds/bite',
    Hit1 = 'sounds/hit1',
    Hit2 = 'sounds/hit2',
    Hit3 = 'sounds/hit3',
    Hit4 = 'sounds/hit4',

}

WEAPON = {
    LittleBite = 1,
    BigBite = 2,
    MachineGun = 12,
    Trigun = 13,
    FlameGun = 14,
    Float = 29,
    Pistols = 30,
    Reflect = 16 * 1 + 12,
}

DPAD_CONTROL = {
    TANK = 1,
    DPAD = 2
}
CRANK_CONTROL = {
    A = 1,
    DPAD = 2
}
