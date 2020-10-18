ESX = nil

TriggerEvent("esx:getSharedObject", function(library) 
	ESX = library 
end)

ESX.RegisterServerCallback("sistema_bebidas:validarcompra", function(source, callback)
	local player = ESX.GetPlayerFromId(source)

	if player then
		if player.getMoney() >= Config.precio then
			player.removeMoney(Config.precio)

			callback(true)
		else
			callback(false)
		end
	else
		callback(false)
	end
end)
