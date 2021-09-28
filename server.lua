ESX						= nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('frp_headbag:closest')
AddEventHandler('frp_headbag:closest', function()
    local name = GetPlayerName(nearest)
    TriggerClientEvent('frp_headbag:puton', nearest)
end)

RegisterServerEvent('frp_headbag:sendclosest')
AddEventHandler('frp_headbag:sendclosest', function(closestPlayer)
    nearest = closestPlayer
end)

RegisterServerEvent('frp_headbag:takeoff')
AddEventHandler('frp_headbag:takeoff', function()
    TriggerClientEvent('frp_headbag:putoff', nearest)
end)

ESX.RegisterUsableItem('headbag', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('frp_headbag:openmenu', _source)
    TriggerEvent('frp_headbag:debugger', source)
end)
