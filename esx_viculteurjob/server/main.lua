-----------------------------------------
-- Created and modify by L'ile Légale RP
-- SenSi and Kaminosekai
-----------------------------------------

ESX = nil
local PlayersTransforming  = {}
local PlayersSelling       = {}
local PlayersHarvesting = {}
local champagne = 1
local jus = 1
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'vicult', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'vicult', _U('vicultron_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'vicult', 'vicultron', 'society_vicult', 'society_vicult', 'society_vicult', {type = 'private'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if xPlayer ~= nil and zone == "PommenFarm" then
		--if zone == "pommeFarm" then
			local itemQuantity = xPlayer.getInventoryItem('pomme').count
			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('pomme', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_vicultronjob:startHarvest')
AddEventHandler('esx_vicultronjob:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('pomme_taken'))  
		Harvest(_source,zone)
	end
end)


RegisterServerEvent('esx_vicultronjob:stopHarvest')
AddEventHandler('esx_vicultronjob:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)


local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if xPlayer ~= nil and zone == "TraitementVin" then
		--if zone == "TraitementVin" then
			local itemQuantity = xPlayer.getInventoryItem('pomme').count
			
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_pomme'))
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('pomme', 1)
						xPlayer.addInventoryItem('grand_jus', 1)
						TriggerClientEvent('esx:showNotification', source, _U('grand_jus'))
						Transform(source, zone)
					end)
				else
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('pomme', 1)
						xPlayer.addInventoryItem('champagne', 1)
				
						Transform(source, zone)
					end)
				end
			end
		elseif zone == "TraitementJus" then
			local itemQuantity = xPlayer.getInventoryItem('pomme').count
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_pomme'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('pomme', 1)
					xPlayer.addInventoryItem('jus_pomme', 1)
		  
					Transform(source, zone)	  
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_vicultronjob:startTransform')
AddEventHandler('esx_vicultronjob:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_vicultronjob:stopTransform')
AddEventHandler('esx_vicultronjob:stopTransform', function()

	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~transformer votre pomme')
		PlayersTransforming[_source]=true
		
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)

		if xPlayer ~= nil and zone == 'SellFarm' then
		--if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('champagne').count <= 0 then
				champagne = 0
			else
				champagne = 1
			end
			
			if xPlayer.getInventoryItem('jus_pomme').count <= 0 then
				jus = 0
			else
				jus = 1
			end
		
			if champagne == 0 and jus == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('champagne').count <= 0 and jus == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_vin_sale'))
				champagne = 0
				return
			elseif xPlayer.getInventoryItem('jus_pomme').count <= 0 and champagne == 0then
				TriggerClientEvent('esx:showNotification', source, _U('no_jus_sale'))
				jus = 0
				return
			else
				if (jus == 1) then
					SetTimeout(1100, function()
						local money = math.random(20,50)
						local argent = math.random(20,50)
						xPlayer.removeInventoryItem('jus_pomme', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vicult', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							xPlayer.addMoney(argent)
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned') .. argent)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				elseif (champagne == 1) then
					SetTimeout(1100, function()
						local money = math.random(40,80)
						local argent = math.random(40,80)
						xPlayer.removeInventoryItem('champagne', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vicult', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							xPlayer.addMoney(argent)
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned') .. argent)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				end
				
			end
		end
	end
end

RegisterServerEvent('esx_vicultronjob:startSell')
AddEventHandler('esx_vicultronjob:startSell', function(zone)

	local _source = source
	
	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		Sell(_source, zone)
	end

end)

RegisterServerEvent('esx_vicultronjob:stopSell')
AddEventHandler('esx_vicultronjob:stopSell', function()

	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end

end)

RegisterServerEvent('esx_vicultronjob:getStockItem')
AddEventHandler('esx_vicultronjob:getStockItem', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vicult', function(inventory)

		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

	end)

end)

ESX.RegisterServerCallback('esx_vicultronjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vicult', function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('esx_vicultronjob:putStockItems')
AddEventHandler('esx_vicultronjob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)
  local sourceItem = xPlayer.getInventoryItem(itemName)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vicult', function(inventory)

    local inventoryItem = inventory.getItem(itemName)

    if sourceItem.count >= count and count > 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_vicultronjob:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})

end)


ESX.RegisterUsableItem('jus_pomme', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('jus_pomme', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 40000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_jus'))

end)

ESX.RegisterUsableItem('grand_jus', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('grand_jus', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 400000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_grand_jus'))

end)
