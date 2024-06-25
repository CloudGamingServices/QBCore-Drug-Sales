local QBCore = exports['qb-core']:GetCoreObject()

local nazwaNarkotyku1 = 'weed'
local nazwaNarkotyku2 = 'coke'
local nazwaNarkotyku3 = 'meth'

local wynagrodzenieWeed = math.random(200, 400) --<< zakres wynagrodzenia za 1 sztuke narkotyku nr.1 (weed) | Domyslnie: od 200 - 400$ brudnego
local wynagrodzenieCoke = math.random(400, 600) --<< zakres wynagrodzenia za 1 sztuke narkotyku nr.2 (coke) | Domyslnie: od 400 - 600$ brudnego
local wynagrodzenieMeth = math.random(600, 800) --<< zakres wynagrodzenia za 1 sztuke narkotyku nr.3 (meth) | Domyslnie: od 600 - 800$ brudnego
local waitingForClient = 0


RegisterCommand('narkosell', function(source, rawCommand)
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)

	local copsOnDuty = 0
    local Players = QBCore.Functions.GetPlayers()

    for i = 1, #Players do
        local xPlayer = QBCore.Functions.GetPlayer(Players[i])

        if (xPlayer.PlayerData.job.name == 'police' and xPlayer.PlayerData.job.onduty) then
            copsOnDuty = copsOnDuty + 1
        end
    end


    if copsOnDuty < 1 then
	
	TriggerClientEvent('QBCore:Notify', _source, 'Need at least 1 LSPD.', 'error')
	return
    end
	
	if waitingForClient == 1 then
	TriggerClientEvent('QBCore:Notify', _source, 'You already have an appointment with the client.', 'error')
	return
	end
	
	if xPlayer.Functions.GetItemByName(nazwaNarkotyku1, 1) then
	    TriggerClientEvent("tostdrugs:getcustomer", _source)
	    waitingForClient = 1
	elseif xPlayer.Functions.GetItemByName(nazwaNarkotyku2, 1) then
		TriggerClientEvent("tostdrugs:getcustomer", _source)
	    waitingForClient = 1
	elseif xPlayer.Functions.GetItemByName(nazwaNarkotyku3, 1) then
		TriggerClientEvent("tostdrugs:getcustomer", _source)
	    waitingForClient = 1
	else
	    TriggerClientEvent('QBCore:Notify', _source, 'You dont have any drugs to sell.', 'error')
	end
	
end)

RegisterServerEvent('tostdrugs:udanyzakup')
AddEventHandler('tostdrugs:udanyzakup', function(x, y, z)
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
    
	
	local niezadowolenie = math.random(1,100)
	
	if niezadowolenie <= 20 then --<< 20% szans ze klient będzie niezadowolony i zwróci towar i nie zapłaci
	
	TriggerClientEvent('QBCore:Notify', _source, 'What is this shit? I was expecting good stuff and this is a shit, take it away, crook.', 'error')
	waitingForClient = 0
	return
	end
	
	
	if xPlayer.Functions.GetItemByName(nazwaNarkotyku1, 1) then
	
	TriggerClientEvent('QBCore:Notify', _source, 'You successfully sell Marijuana ' ..wynagrodzenieWeed.. '$')
	xPlayer.Functions.RemoveItem(nazwaNarkotyku1, 1)
	xPlayer.Functions.AddItem('markedbills', wynagrodzenieWeed)
	waitingForClient = 0
	elseif xPlayer.Functions.GetItemByName(nazwaNarkotyku2, 1) then
	
	TriggerClientEvent('QBCore:Notify', _source, 'You successfully sell Coke ' ..wynagrodzenieCoke.. '$')
	xPlayer.Functions.RemoveItem(nazwaNarkotyku2, 1)
	xPlayer.Functions.AddItem('markedbills', wynagrodzenieCoke)
	waitingForClient = 0
	elseif xPlayer.Functions.GetItemByName(nazwaNarkotyku3, 1) then
	
	TriggerClientEvent('QBCore:Notify', _source, 'You successfully sell Meth ' ..wynagrodzenieMeth.. '$')
	xPlayer.Functions.RemoveItem(nazwaNarkotyku3, 1)
	xPlayer.Functions.AddItem('markedbills', wynagrodzenieMeth)
	waitingForClient = 0
	else
	
	TriggerClientEvent('QBCore:Notify', _source, 'You have nothing to sell what this ad is for ', 'error')
	waitingForClient = 0
	end
	
	
	local infoPsy = math.random(1,100)
	
	if infoPsy <= 30 then --<< 30% ze zostanie wezwana policja
	TriggerClientEvent('tostdrugs:infoPolicja', -1, x, y, z)
	Wait(500)
	end
	
end)


RegisterServerEvent('tostdrugs:clientpassed')
AddEventHandler('tostdrugs:clientpassed', function()
waitingForClient = 0
end)