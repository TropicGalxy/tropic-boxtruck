Config = {}

Config.UseOxInventory = true -- set to false to use qb-inventory

Config.TruckModels = {
    "boxville3", 
}

Config.TruckSpots = {
    {x = 25.51, y = -1708.01, z = 29.3, heading = 24.98},
    {x = -570.78, y = -446.97, z = 34.14, heading = 267.78}, 
    {x = -256.67, y = -245.5, z = 48.96, heading = 194.77},
    {x = 604.79, y = 122.37, z = 92.9, heading = 293.31},
    {x = 735.39, y = 1301.02, z = 360.29, heading = 1.02},
    {x = 1218.22, y = 2393.08, z = 65.97, heading = 359.26}, 
    {x = 1967.3, y = 3904.19, z = 32.31, heading = 30.77}, -- add more spots if you want
} 



Config.MaxTrucks = 3 -- max trucks to spawn at once (changes every script/server restart)

Config.RequireItem = true -- set to false if no item is required
Config.RequiredItem = "bolt_cutter" -- set the item required to interact

Config.Minigame = {
    difficulty = 'medium', -- easy, medium, hard
    attempts = 3, -- number of attempts
}

Config.Cooldown = 600000 -- miliseconds
Config.SpawnInterval = 60 -- time between spawns (seconds)



Config.RewardItems = {
    {item = "bread", min = 1, max = 5},
    {item = "water", min = 1, max = 3},
    {item = "sandwich", min = 1, max = 2}
}

Config.MinRewardItems = 1
Config.MaxRewardItems = 3

