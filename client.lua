ESX = nil
local HaveBagOnHead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function NearestPlayer() --This function send to server closestplayer

local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
local player = GetPlayerPed(-1)

if closestPlayer == -1 or closestDistance > 2.0 then 
    ESX.ShowNotification('~r~There is no player nearby')
else
  if not HaveBagOnHead then
    TriggerServerEvent('frp_headbag:sendclosest', GetPlayerServerId(closestPlayer))
    ESX.ShowNotification('~g~You put the head bag on ~w~' .. GetPlayerName(closestPlayer))
    TriggerServerEvent('frp_headbag:closest')
  else
    ESX.ShowNotification('~r~This player already have a bag on head')
  end
end

end

RegisterNetEvent('frp_headbag:openmenu') --This event open menu
AddEventHandler('frp_headbag:openmenu', function()
    OpenBagMenu()
end)

RegisterNetEvent('frp_headbag:puton') --This event put head bag on nearest player
AddEventHandler('frp_headbag:puton', function(gracz)
    local playerPed = GetPlayerPed(-1)
    Worek = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true) -- Create head bag object!
    AttachEntityToEntity(Worek, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- Attach object to head
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openGeneral'})
    HaveBagOnHead = true
end)    

AddEventHandler('playerSpawned', function() --This event delete head bag when player is spawn again
DeleteEntity(Worek)
SetEntityAsNoLongerNeeded(Worek)
SendNUIMessage({type = 'closeAll'})
HaveBagOnHead = false
end)

RegisterNetEvent('frp_headbag:putoff') --This event delete head bag from player head
AddEventHandler('frp_headbag:putoff', function(gracz)
    ESX.ShowNotification('~g~Someone removed the bag from your head!')
    DeleteEntity(Worek)
    SetEntityAsNoLongerNeeded(Worek)
    SendNUIMessage({type = 'closeAll'})
    HaveBagOnHead = false
end)

function OpenBagMenu() --This function is menu function

    local elements = {
          {label = 'Put bag on head', value = 'puton'},
          {label = 'Remove bag from head', value = 'putoff'},
          
        }
  
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'headbagging',
      {
        title    = 'HEAD BAG MENU',
        align    = 'top-left',
        elements = elements
        },
  
            function(data2, menu2)
  
  
              local player, distance = ESX.Game.GetClosestPlayer()
  
              if distance ~= -1 and distance <= 2.0 then
  
                if data2.current.value == 'puton' then
                    NearestPlayer()
                end
  
                if data2.current.value == 'putoff' then
                  TriggerServerEvent('frp_headbag:takeoff')
                end
              else
                ESX.ShowNotification('~r~There is no player nearby.')
              end
            end,
      function(data2, menu2)
        menu2.close()
      end
    )
  
  end

