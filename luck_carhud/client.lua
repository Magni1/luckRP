
ESX = nil

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local prevSpeed = 0
local currSpeed = 0
local seatbeltEjectSpeed = 140.0             -- Speed threshold to eject player (MPH)
local seatbeltEjectAccel = 80.0  
local tekerPatlak = false
local TgiannAracKaza = 80.0        
local mbgseatbeltEjectSpeed = 120.0             -- KM CİNSİNDEN CAMDAN UÇMA          -- KM CİNSİNDEN TEKER PATLATMA
local mbgseatbeltEjectAccel = 80.0      

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


ESX              = nil
local PlayerData = {}
local inVeh = false
local distance = 0
local vehPlate

local x = 0.01135
local y = 0.002
hasKM = 0
showKM = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
local cruiseSpeed = 999.0
local cruiseIsOn = false
local cruiseInput = 113      

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
		SetTextFont(font)
		SetTextProportional(0)
		SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - 0.1+w, y - 0.02+h)
end

-- print("Script starting...")


Citizen.CreateThread(function()
  while true do
	Citizen.Wait(250)
			if IsPedInAnyVehicle(PlayerPedId(), false) and not inVeh then
			-- print('player is now in a vehicle')
			Citizen.Wait(50)
			local veh = GetVehiclePedIsIn(PlayerPedId(),false)
			local driver = GetPedInVehicleSeat(veh, -1)
			if driver == PlayerPedId() and GetVehicleClass(veh) ~= 13 and GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 17 and GetVehicleClass(veh) ~= 21 then
			inVeh = true
			Citizen.Wait(50)
			vehPlate = GetVehicleNumberPlateText(veh)
			Citizen.Wait(1)
			-- print(vehPlate)
			ESX.TriggerServerCallback('esx_carmileage:getMileage', function(hasKM)
	
			showKM = math.floor(hasKM*1.33)/1000
	
			local oldPos = GetEntityCoords(PlayerPedId())
	
			Citizen.Wait(1000)
			local curPos = GetEntityCoords(PlayerPedId())
			
			if IsVehicleOnAllWheels(veh) then
			dist = GetDistanceBetweenCoords(oldPos.x, oldPos.y, oldPos.z, curPos.x, curPos.y, curPos.z, true)
			else
			dist = 0
			end
	
			hasKM = hasKM + dist
		
			TriggerServerEvent('esx_carmileage:addMileage', vehPlate, hasKM)
			inVeh = false
			end, GetVehicleNumberPlateText(veh))
			else
			-- print("salimos del bucle xq somos pasajero")
			end
		end
	end
end)




-- this will be used in the future to add damage to cars with more kms and make them slower

-- Citizen.CreateThread(function()
	-- while true do
	-- Citizen.Wait(250)
		-- if IsPedInAnyVehicle(PlayerPedId(), false) then
			-- local veh = GetVehiclePedIsIn(PlayerPedId(),false)
				-- local driver = GetPedInVehicleSeat(veh, -1)
					-- if driver == PlayerPedId() then
						-- if showKM >= 5000 then
						-- -- print("tiene mas de 5000 km")
						-- -- SetVehicleDirtLevel(veh, 15.0)
						-- SetVehicleEngineHealth(veh, 650)
						-- end
				-- end
			-- else
				-- Citizen.Wait(15000)
			-- end
		-- Citizen.Wait(1)
	-- end
-- end)
	
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end




function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function TargetVehicle()
    playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end



function endanimation()
    shiftheld = false
    ctrlheld = false
    tabheld = false
    ClearPedTasksImmediately(PlayerPedId())
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function TargetVehicle()
    playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function round( n )
    return math.floor( n + 0.5 )
end

DrivingSet = false
LastVehicle = nil
lastupdate = 0


alarmset = false

RegisterNetEvent("CarFuelAlarm")
AddEventHandler("CarFuelAlarm",function()
    if not alarmset then
        alarmset = true
        local i = 5
        exports['mythic_notify']:DoHudText('error', 'Benzin az!')
        while i > 0 do
            PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            i = i - 1
            Citizen.Wait(300)
        end
        Citizen.Wait(60000)
        alarmset = false
    end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

-- CONFIG --
local showCompass = true
-- CODE --
local compass = "Loading GPS"

local lastStreet = nil
local lastStreetName = ""
local zone = "Unknown";

function playerLocation()
    return lastStreetName
end

function playerZone()
    return zone
end

-- Thanks @marxy
function getCardinalDirectionFromHeading(heading)
    if heading >= 315 or heading < 45 then
        return "Kuzey"
    elseif heading >= 45 and heading < 135 then
        return "Batı"
    elseif heading >=135 and heading < 225 then
        return "Güney"
    elseif heading >= 225 and heading < 315 then
        return "Doğu"
    end
end

local seatbelt = false
RegisterNetEvent("seatbelt")
AddEventHandler("seatbelt", function(belt)
    seatbelt = belt
end)

local nos = 0
local nosEnabled = false
RegisterNetEvent("noshud")
AddEventHandler("noshud", function(_nos, _nosEnabled)
    if _nos == nil then
        nos = 0
    else
        nos = _nos
    end
    nosEnabled = _nosEnabled
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name)
    if job ~= "police" then isCop = false else isCop = true end
end)

local time = "12:00"
RegisterNetEvent("timeheader2")
AddEventHandler("timeheader2", function(h,m)
    if h < 10 then
        h = "0"..h
    end
    if m < 10 then
        m = "0"..m
    end
    time = h .. ":" .. m
end)

local black = false
local counter = 0
local Mph = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6
local uiopen = false
local colorblind = false
local compass_on = false

RegisterNetEvent('option:colorblind')
AddEventHandler('option:colorblind',function()
    colorblind = not colorblind
end)

Citizen.CreateThread(function()
    

  
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
    currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
    zone = tostring(GetNameOfZone(x, y, z))
    local area = GetLabelText(zone)
    playerStreetsLocation = area

    if not zone then
        zone = "UNKNOWN"
    end

    if intersectStreetName ~= nil and intersectStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. area .. "]"
    elseif currentStreetName ~= nil and currentStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | [" .. area .. "]"
    else
        playerStreetsLocation = "[" .. area .. "]"
    end

    while true do
        Citizen.Wait(200)
        local player = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(player, true))
        local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
        currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
        intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
        zone = tostring(GetNameOfZone(x, y, z))
        local area = GetLabelText(zone)
        playerStreetsLocation = area

        if not zone then
            zone = "UNKNOWN"
        end

        if intersectStreetName ~= nil and intersectStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. area .. "]"
        elseif currentStreetName ~= nil and currentStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | [" .. area .. "]"
        else
            playerStreetsLocation = "[".. area .. "]"
        end
        -- compass = getCardinalDirectionFromHeading(math.floor(GetEntityHeading(player) + 0.5))
        -- street = compass .. " | " .. playerStreetsLocation
        street = playerStreetsLocation
        local veh = GetVehiclePedIsIn(player, false)
        if IsVehicleEngineOn(veh) then          

            if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                }) 
            end

            Mph = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(player, false)) * 3.6)
			
			 local hours = GetClockHours()
            if string.len(tostring(hours)) == 1 then
                trash = '0'..hours
            else
                trash = hours
            end
    
            local mins = GetClockMinutes()
            if string.len(tostring(mins)) == 1 then
                mins = '0'..mins
            else
                mins = mins
            end
			
            local atl = false
            if IsPedInAnyPlane(player) or IsPedInAnyHeli(player) then
                atl = string.format("%.1f", GetEntityHeightAboveGround(veh) * 3.28084)
            end
            local engine = false
            if GetVehicleEngineHealth(veh) < 400.0 then
                engine = true
            end
            local GasTank = false
            if exports["LegacyFuel"]:GetFuel(veh) < 25.0 then
                GasTank = true
            end
            kmm = round(showKM, 2)

            if not IsThisModelABicycle(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) and
            not IsThisModelABoat(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) and
            not IsThisModelAHeli(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) and
            -- not IsThisModelAJetski(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) and
            not IsThisModelAPlane(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) then
                black = false
            else
                black = true
            end
            SendNUIMessage({
              open = 2,
              mph = Mph,
              km = kmm,
              fuel = math.ceil(exports["LegacyFuel"]:GetFuel(veh)),
              street = street,
              belt = seatbelt,
              nos = nos,
              nosEnabled = nosEnabled,
              time = hours .. ':' .. mins,
              colorblind = colorblind,
              atl = atl,
              engine = engine,
              GasTank = GasTank,
              blacklist = black,
            }) 
        else

            if uiopen and not compass_on then
                SendNUIMessage({
                  open = 3,
                }) 
                uiopen = false
            end
        end
    end
end)

local seatbelt = false



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        if IsControlJustReleased(0, 311) and IsPedInAnyVehicle(PlayerPedId()) then
            if not IsThisModelABicycle(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) and
            not IsThisModelABoat(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) and
            not IsThisModelAHeli(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) and
            -- not IsThisModelAJetski(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) and
            not IsThisModelAPlane(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) then
                if seatbelt == false then
                    TriggerEvent("seatbelt",true)
                    TriggerEvent("InteractSound_CL:PlayOnOne","seatbelt",0.1)
                    exports['mythic_notify']:DoHudText('inform', 'Kemer Takıldı!')
            
                    seatbelt = true
                else
                    TriggerEvent("seatbelt",false)
                    TriggerEvent("InteractSound_CL:PlayOnOne","seatbeltoff",0.7)
                    exports['mythic_notify']:DoHudText('inform', 'Kemer çıkartıldı!')
                    seatbelt = false
                end
            else
                exports['mythic_notify']:DoHudText('error', 'Bu araçta kemer takamazsın!')
            end
			
		end
	end
end)

Citizen.CreateThread(function()
    while true do
    
        Citizen.Wait(0)


        if seatbelt then
            DisableControlAction(0, 75)
        end   

        local player = GetPlayerPed(-1)
        local position = GetEntityCoords(player)
        local vehicle = GetVehiclePedIsIn(player, false)


        if IsPedInAnyVehicle(player, false) then
            pedInVeh = true
        else 
            pedInVeh = false
            cruiseIsOn = false
            seatbelt = false
        end

    
           
         if pedInVeh then
            local vehicleClass = GetVehicleClass(vehicle)
            if pedInVeh and vehicleClass ~= 13 then
             
 
                SetPedConfigFlag(PlayerPedId(), 32, true)
                
                
                local prevSpeed = currSpeed
                currSpeed = GetEntitySpeed(vehicle)
                

                if not seatbelt then
                    vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
                    local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()           
                    if (vehIsMovingFwd and (prevSpeed*3.6 > (seatbeltEjectSpeed)) and (vehAcc > (seatbeltEjectAccel*7.20))) then           
                     SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                        SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                        Citizen.Wait(1)
                        SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
                    else
                        -- Update previous velocity for ejecting player
                        prevVelocity = GetEntityVelocity(vehicle)
                    end
                end
     

               

            
                if GetPedInVehicleSeat(vehicle, -1) == player then
                    local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
                    if IsControlJustReleased(0, 246) and (enableController or GetLastInputMethod(0)) then
                        cruiseIsOn = not cruiseIsOn
                        cruiseSpeed = currSpeed
                    end
                    local maxSpeed = cruiseIsOn and cruiseSpeed or GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                    SetEntityMaxSpeed(vehicle, maxSpeed)
                    if (vehIsMovingFwd and (prevSpeed*3.6 > (TgiannAracKaza)) and (vehAcc > (mbgseatbeltEjectAccel*7.20))) then
                        local vehicle = GetPlayersLastVehicle()
                        
                        local RastgeleTeker = (math.random(1,4))
                        if RastgeleTeker == 1 then
                            SetVehicleTyreBurst(vehicle, 0, 1, 100.0)
                        elseif RastgeleTeker == 2 then
                            SetVehicleTyreBurst(vehicle, 0, 1, 100.0)
                            SetVehicleTyreBurst(vehicle, 4, 1, 100.0)
                        elseif RastgeleTeker == 3 then
                            SetVehicleTyreBurst(vehicle, 0, 1, 100.0)
                            SetVehicleTyreBurst(vehicle, 1, 1, 100.0)
                            SetVehicleTyreBurst(vehicle, 4, 1, 100.0)                        
                        elseif RastgeleTeker == 4 then
                            SetVehicleTyreBurst(vehicle, 0, 1, 100.0)
                            SetVehicleTyreBurst(vehicle, 1, 1, 100.0)
                            SetVehicleTyreBurst(vehicle, 4, 1, 100.0)
                            SetVehicleTyreBurst(vehicle, 5, 1, 100.0)
                        end
                    end
                else
                    cruiseIsOn = false
                end

                if IsVehicleTyreBurst(vehicle, 0) or IsVehicleTyreBurst(vehicle, 1) or IsVehicleTyreBurst(vehicle, 4) or IsVehicleTyreBurst(vehicle, 5) then 
                    tekerPatlak = true
                else
                    tekerPatlak = false
                end


       
        end
    end
end
end)


RegisterNetEvent('carHud:compass')
AddEventHandler('carHud:compass', function()
   compass_on = not commpass_on
end)

RegisterNetEvent('carHud:compass1')
AddEventHandler('carHud:compass1', function(table)
    compass_on = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local player = PlayerPedId()
        if IsVehicleEngineOn(GetVehiclePedIsIn(player, false)) then
            -- in vehicle
            SendNUIMessage({
                open = 2,
                direction = math.floor(calcHeading(-GetEntityHeading(player) % 360)),
            })
        elseif compass_on == true then
            -- has compass toggled
            if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                })
            end
			
		    local hours = GetClockHours()
            if string.len(tostring(hours)) == 1 then
                trash = '0'..hours
            else
                trash = hours
            end
    
            local mins = GetClockMinutes()
            if string.len(tostring(mins)) == 1 then
                mins = '0'..mins
            else
                mins = mins
            end

            SendNUIMessage({
                open = 4,
                time = hours .. ':' .. mins,
                direction = math.floor(calcHeading(-GetEntityHeading(player) % 360)),
            })
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(250)
        local player = PlayerPedId()

        if (IsPedInAnyVehicle(player, false)) then

            local veh = GetVehiclePedIsIn(player,false)

            if GetPedInVehicleSeat(veh, -1) == player then

                if not DrivingSet then

                    if LastVehicle ~= veh then
    
                            Fuel = exports["LegacyFuel"]:GetFuel(veh)
                    else
                        Fuel = exports["LegacyFuel"]:GetFuel(veh)
                    end
                else

                    if Fuel > 105 then
                        Fuel = exports["LegacyFuel"]:GetFuel(veh)
                    end                     
                    if Fuel == 101 then
                        Fuel = exports["LegacyFuel"]:GetFuel(veh)
                    end
                end

                if ( lastupdate > 300) then
                    Fuel = exports["LegacyFuel"]:GetFuel(veh)
                    lasteupdate = 0
                end


                if Fuel < 15 then
                    if not IsThisModelABike(GetEntityModel(veh)) then
                        TriggerEvent("CarFuelAlarm")
                    end
                end

               
            end
        else

            if DrivingSet then
                DrivingSet = false
                DecorSetInt(LastVehicle, "CurrentFuel", round(Fuel))
            end
            Citizen.Wait(2000)
        end
    end
end)

Controlkey = {["generalUse"] = {38,"E"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
    Controlkey["generalUse"] = table["generalUse"]
end)


---------------------------------
-- Compass shit
---------------------------------

--[[
    Heavy Math Calcs
 ]]--

 local imageWidth = 100 -- leave this variable, related to pixel size of the directions
 local containerWidth = 100 -- width of the image container
 
 -- local width =  (imageWidth / containerWidth) * 100; -- used to convert image width if changed
 local width =  0;
 local south = (-imageWidth) + width
 local west = (-imageWidth * 2) + width
 local north = (-imageWidth * 3) + width
 local east = (-imageWidth * 4) + width
 local south2 = (-imageWidth * 5) + width
 
 function calcHeading(direction)
     if (direction < 90) then
         return lerp(north, east, direction / 90)
     elseif (direction < 180) then
         return lerp(east, south2, rangePercent(90, 180, direction))
     elseif (direction < 270) then
         return lerp(south, west, rangePercent(180, 270, direction))
     elseif (direction <= 360) then
         return lerp(west, north, rangePercent(270, 360, direction))
     end
 end
 
 function rangePercent(min, max, amt)
     return (((amt - min) * 100) / (max - min)) / 100
 end
 
 function lerp(min, max, amt)
     return (1 - amt) * min + amt * max
 end