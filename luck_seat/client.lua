local seatdis = true --Seat Function 

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        local PlayerPed = GetPlayerPed(-1)
        local Car = GetVehiclePedIsIn(PlayerPed, false)
		if IsPedInAnyVehicle(PlayerPed, false) and seatdis then
    		if GetPedInVehicleSeat(Car, 0) == PlayerPed then
				if GetIsTaskActive(PlayerPed, 165) then
					SetPedIntoVehicle(PlayerPed, Car, 0)
				end
			end
		end
	end
end)



function round(value, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end



RegisterCommand("koltuk", function(source, args)
    local PlayerPed = GetPlayerPed(-1)
    local Car = GetVehiclePedIsIn(PlayerPed, false)
    
    if args[1] == nil then
        Koltuk = -1
    else
        Koltuk = round(tonumber(args[1]-2))
    end
	
    if IsPedInAnyVehicle(PlayerPed, false) then
        if IsVehicleSeatFree(Car, Koltuk) then 
            SetPedIntoVehicle(PlayerPed, Car, Koltuk)
        else
            TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = 'Koltuk Dolu!'})
        end
    end
end)