local startTimer = tmr.create()

function startup()
    print('in startup')
    startTimer:stop()
    
    dofile("config.lua");
    dofile("move-and-led.lua");
--[[
    gpio.mode(8, gpio.OUTPUT)
    gpio.write(8, gpio.HIGH)
    ]]
    
--[[    dofile("light-sensor.lua");

    local timer = tmr.create()
    lightSensor = LightSensor.init(800, 900)
    timer:alarm(1000,
        tmr.ALARM_AUTO, 
        function()
            print(lightSensor:getState(), adc.read(0))
        end
    )
    ]]
--[[
    --local pinRed = 1
    local pinGreen = 2
    --local pinBlue = 8
    
    -- gpio.mode(pinRed, gpio.OUTPUT)
    gpio.mode(pinGreen, gpio.OUTPUT)
    -- gpio.mode(pinBlue, gpio.OUTPUT)
    
    --gpio.write(pinRed, gpio.LOW)
    gpio.write(pinGreen, gpio.LOW)
    --gpio.write(pinBlue, gpio.LOW)
    
    for i=0,8,1 do 
        gpio.mode(i, gpio.OUTPUT)
        gpio.write(i, gpio.LOW)
    end
]]
end

local onboardLedPin = 4
local isOn = false
gpio.mode(onboardLedPin, gpio.OUTPUT)

startTimer:alarm(
    100,
    tmr.ALARM_AUTO, 
    function()
        if(isOn) then
            gpio.write(onboardLedPin, gpio.HIGH)
        else
            gpio.write(onboardLedPin, gpio.LOW)
        end
        isOn = not isOn
    end
)

tmr.alarm(0,8000,0,startup)
startTimer:start()
print("init file executed")


