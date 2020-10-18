ESX = nil

cachedData = {}


local l_37 = 0
local l_3B = 0.306;
local l_3C = 0.31;
local l_3D = 0.98;
local l_45 = {0.0, -0.97, 0.05 }
local name = "Soda"

Citizen.CreateThread(function()
	while not ESX do
		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end
	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local sprunk = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("prop_vend_soda_02"), false)
		local ecola = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("prop_vend_soda_01"), false)
		--local closestTank = ESX.Game.GetClosestObject({"prop_vend_soda_01","prop_vend_soda_02"},pedCoords)

		if DoesEntityExist(sprunk) or DoesEntityExist(ecola) then
			sleepThread = 5
			local markerCoords = GetOffsetFromEntityInWorldCoords(sprunk, 0.0, -0.97, 0.05)
			local distanceCheck1 = #(pedCoords - markerCoords)
			local markerCoords2 = GetOffsetFromEntityInWorldCoords(ecola, 0.0, -0.97, 0.05)
			local distanceCheck2 = #(pedCoords - markerCoords2)
			if distanceCheck1 <= 0.5 then
				
				local drinkable, displayText = not cachedData["drinking"], cachedData["drinking"] and "Bebiendo..." or "~INPUT_DETONATE~ Para comprar una Sprunk por $" .. Config.precio

				ESX.ShowHelpNotification(displayText)

				if drinkable then
					if IsControlJustPressed(0, 47) then
						PurchaseDrink(markerCoords,sprunk)
					end
				end
			elseif distanceCheck2 <= 0.5 then
				local drinkable, displayText = not cachedData["drinking"], cachedData["drinking"] and "Bebiendo..." or "~INPUT_DETONATE~ Para comprar una Ecola por $" .. Config.precio

				ESX.ShowHelpNotification(displayText)

				if drinkable then
					if IsControlJustPressed(0, 47) then
						PurchaseDrink(markerCoords2,ecola)
					end
				end
			end
		end

		Citizen.Wait(sleepThread)
	end
end)


PurchaseDrink = function(coords,maquina)
    ESX.TriggerServerCallback("sistema_bebidas:validarcompra", function(validated)
        if validated then
			EjecutarAnim(coords,maquina)
        else
           ESX.ShowNotification('~r~No tienes suficiente dinero')
        end
    end)
end

requestDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

function EjecutarAnim(CoordsMaquina,maquina)
	if GetHashKey("prop_vend_soda_02") == GetEntityModel(maquina) then
		prop = "prop_ld_can_01b"
	elseif GetHashKey("prop_vend_soda_01") == GetEntityModel(maquina) then
		prop = "prop_ecola_can"
	end
	RequestAmbientAudioBank("VENDING_MACHINE", 0)
	if GetFollowPedCamViewMode() == 4 then
		DicAnim = requestDict("mini@sprunk@first_person")
	else
		DicAnim = requestDict("mini@sprunk")
	end
	local taks TaskGoStraightToCoord(PlayerPedId(), CoordsMaquina, 1.0, 20000, GetEntityHeading(maquina), 0.1)
	Citizen.Wait(1000)
	while GetIsTaskActive(PlayerPedId(),task) do Citizen.Wait(1); end
	if IsEntityAtCoord(PlayerPedId(), CoordsMaquina, 0.1, 0.1, 0.1, 0, 1, 0) then
		local taks2 = TaskLookAtEntity(PlayerPedId(), maquina, 2000, 2048, 2);
		Citizen.Wait(1000)
		while GetIsTaskActive(PlayerPedId(),task2) do Citizen.Wait(1); end
		TaskPlayAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1", 4.0, -1000.0, -1, 0x100000, 0.0, 0, 2052, 0);
		FreezeEntityPosition(PlayerPedId(),true)
	end
	while true do
		Citizen.Wait(1)
		
			if (IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1", 3)) then
				if (GetEntityAnimCurrentTime(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1") < 0.52) then
					if (not IsEntityAtCoord(PlayerPedId(), CoordsMaquina, 0.1, 0.1, 0.1, 0, 1, 0)) then
						sub_35e89(1);
					end
				end
				if (IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1", 3)) then
					if (GetEntityAnimCurrentTime(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1") > l_3C) then
						if (DoesEntityExist(l_37)) then
							if (GetEntityAnimCurrentTime(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1") > l_3D) then
								if (not IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT2", 3)) then
									TaskPlayAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT2", 4.0, -1000.0, -1, 0x100000, 0.0, 0, 2052, 0);
									TaskClearLookAt(PlayerPedId(), 0, 0);
								end
								if (IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1", 3)) then
									StopAnimTask(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT1", -1.5);
								end
							end
						else
							l_37 = CreateObjectNoOffset(GetHashKey(prop), CoordsMaquina, 1, 0, 0);
							AttachEntityToEntity(l_37, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1);
						end
					end
				end
			elseif (IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT2", 3)) then
				if (GetEntityAnimCurrentTime(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT2") > 0.98) then
					if (not IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT3", 3)) then
						TaskPlayAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT3", 1000.0, -4.0, -1, 0x100030, 0.0, 0, 2048, 0);
						--UltimaFuncion()
						TaskClearLookAt(PlayerPedId(), 0, 0);
						TriggerEvent("esx_status:add", "thirst", 200000)
					end
					
				end
			elseif (IsEntityPlayingAnim(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT3", 3)) then
				if (GetEntityAnimCurrentTime(PlayerPedId(), DicAnim, "PLYR_BUY_DRINK_PT3") > l_3B) then
					
					if (RequestAmbientAudioBank("VENDING_MACHINE", 0)) then
						ReleaseAmbientAudioBank();
					end
					HintAmbientAudioBank("VENDING_MACHINE", 0);
					sub_35e89(1);
					break
				end
			end
	end
end

function sub_35e89(a_0) 
    if (DoesEntityExist(l_37)) then
        if (IsEntityAttached(l_37)) then
            DetachEntity(l_37, 1, 1)
            if (a_0) then
                ApplyForceToEntity(l_37, 1, 6.0, 10.0, 2.0, 0.0, 0.0, 0.0, 0, 1, 1, 0, 0, 1)
            end
        end
		FreezeEntityPosition(PlayerPedId(),false)
        SetObjectAsNoLongerNeeded(l_37)
		DeleteObject(l_37)
		l_37 = nil
    end
end
