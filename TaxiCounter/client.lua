--Prix du kilomètre
local perKilometer = 10
--Prix minimum
local  min = 5;

--prix de l'heure le jour (2 mins IRL)
local perGTAHourDay = 3
--prix de l'heure la nuit (2 mins IRL)
local perGTAHourNight = 5

--Vitesse moyenne
local averageV = 0
--Adition des vitesses
local total = 0
--Prix
local price = 0

--Formule jour/nuit
local night = false
--Calcul le prix ?
local started = false
--Repère temps 1/2 sec
local time = 0


RegisterNetEvent('taxi-counter:ChooseNight')
AddEventHandler('taxi-counter:ChooseNight', function ()
    night = true
end)

RegisterNetEvent('taxi-counter:ChooseDay')
AddEventHandler('taxi-counter:ChooseDay', function ()
    night = false
end)

RegisterNetEvent('taxi-counter:Start')
AddEventHandler('taxi-counter:Start', function()
    Clear()
    started = true
    Calcul()
end)



RegisterNetEvent('taxi-counter:Clear')
AddEventHandler('taxi-counter:Clear', function()
    total = 0
    time = 0
    price = 0
end)

function Clear()
    total = 0
    time = 0
    price = 0
    started = false
end

RegisterNetEvent('taxi-counter:Stop')
AddEventHandler('taxi-counter:Stop', function()
        started = false
end)

RegisterNetEvent('taxi-counter:Pay')
AddEventHandler('taxi-counter:Pay', function()
        --Votre script de facturation / Payement method: price var: price
end)

RegisterNetEvent('taxi-counter:Resume')
AddEventHandler('taxi-counter:Resume', function()
       started = true
       Calcul()
end)

function Calcul()
    while true do
        Citizen.Wait(50)
        local player = GetPlayerPed(-1)
        local plVehicle = GetLastDrivenVehicle(player)
        if not started then
                return
        end
        
        --Gérer le temps
        time = time + 1
        total = total + GetEntitySpeed(plVehicle) * 3.6
        averageV = total / time

        -- V x T
        local distance = averageV * time / 3600 / 20

        if night then
                price = (min + perKilometer * distance + (time / 600 * perGTAHourNight))
        elseif not night then
                price = (min + perKilometer * distance + (time / 600 * perGTAHourDay))
        end

        local message = "~b~ The price is: ~g~" .. tostring(round(price)) .. " $."

        ShowSubtitle(message, 51)
      
    end
end

function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end


function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, true)
end

function ShowSubtitle(text, ms)  
    BeginTextCommandPrint("STRING") 
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(ms, 1)
end
