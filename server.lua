QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('tropic-boxtruck:giveReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local totalItems = math.random(Config.MinRewardItems, Config.MaxRewardItems)

    for i = 1, totalItems do
        local itemData = Config.RewardItems[math.random(#Config.RewardItems)]
        local itemCount = math.random(itemData.min, itemData.max)

        if Config.UseOxInventory then
            exports.ox_inventory:AddItem(src, itemData.item, itemCount)
        else
            Player.Functions.AddItem(itemData.item, itemCount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemData.item], 'add')
        end
    end
end)
