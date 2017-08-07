
-- dofile('filename.lua');
function callHttps ()
    local t = sjson.decode('{"lowVersion":1,"highVersion":3}')
    print(t.lowVersion)
    
    http.get("http://httpbin.org/ip", nil, function(code, data)
        if (code < 0) then
            print("HTTP request failed")
        else
            print(code, data)
        end
        --[[
        http.request("https://otmechalka.com/", "GET", "", "", 
            function(code, data)
                if (code < 0) then
                    print("HTTP request failed")
                else
                    print(code, data)
                end
            end)
        ]]
    end)
end

function syncTime()
    sntp.sync("pool.ntp.org", function(sec, us, server, info)
            print ("Seconds: "..sec.." Server: "..server.." Stratum: "..info.stratum)
        end,
        function(errorcode, info)
            print ("SNTP errorcode: "..errorcode.." Info: "..info)
        end,
    true)
end

wifi.setmode(wifi.STATION)

station_cfg={}
station_cfg.ssid="Noga"
station_cfg.pwd="k4iJjg84Nq"
wifi.sta.config(station_cfg)

wifi.sta.connect()

local wifiTimer = tmr.create()
wifiTimer:alarm(1000, 1, function() 
    if wifi.sta.getip() == nil then 
        print("Obtaining IP...") 
    else
        wifiTimer:stop()
        wifiTimer:unregister()
        print("Got IP. "..wifi.sta.getip())

        callHttps()
        syncTime()
    end
end)


local pinNumber = 4 -- built in led gpio2 = 4 pin
gpio.mode(pinNumber, gpio.OUTPUT)
local pinTimer = tmr.create()
local pinIsOn = false
pinTimer:alarm(
    30, 
    tmr.ALARM_AUTO, 
    function()
        if(pinIsOn) then
            gpio.write(pinNumber, gpio.LOW)
            -- print("pin to low" .. pinNumber)
            pinIsOn = false
        else
            gpio.write(pinNumber, gpio.HIGH)
            -- print("pin to high")
            pinIsOn = true
        end
        -- gpio.write(3, gpio.HIGH)
        -- tmr.delay(1000000)   -- wait 1,000,000 us = 1 second
        -- gpio.write(3, gpio.LOW)
        -- tmr.delay(1000000)   -- wait 1,000,000 us = 1 second
    end
)
