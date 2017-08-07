dofile("rgb-led-driver.lua")
onboardLedPin = 4
gpio.mode(onboardLedPin, gpio.OUTPUT)
gpio.write(onboardLedPin, gpio.HIGH)      -- inveted pin. turn off led

gpio.mode(moveSensorPin, gpio.INT)

gpio.mode(ledsCnf.pinRed, gpio.OUTPUT)
gpio.mode(ledsCnf.pinGreen, gpio.OUTPUT)
gpio.mode(ledsCnf.pinBlue, gpio.OUTPUT)

gpio.write(ledsCnf.pinRed, gpio.LOW)
gpio.write(ledsCnf.pinGreen, gpio.LOW)
gpio.write(ledsCnf.pinBlue, gpio.LOW)

local countBackTimer = tmr.create()
local lightLevelTimer = tmr.create()
local noMotionTimer = tmr.create()

local ledDriver = LedDriver.init(ledsCnf.pinRed, 
                        ledsCnf.pinGreen, ledsCnf.pinBlue, 
                        ledsCnf.changeColorOncePerSeconds)
local lightSensor = LightSensor.init(lighSensorCnf.lowerThreshold, 
                        lighSensorCnf.upperThreshold)

local function lightLevelCheckTimerStop()
    lightLevelTimer:stop()
end

noMotionTimer:register(
    15 * 1000,
    tmr.ALARM_SEMI,
    function()
        print("No motion for a long period. Stopping light level check timer.")
        lightLevelCheckTimerStop()
    end
)

countBackTimer:register(
    1000 * ledsCnf.ledOnTimeoutSec,
    tmr.ALARM_SEMI,
    function()
        print("Tutn off led")
        countBackTimer:stop()
        ledDriver:off()
    end
)

local function turnOnLedAndRestartTurnOffTimer()
    local isRunning, mode = countBackTimer:state()

    if(isRunning) then
        print("Countback timer is running. Stopping")
        countBackTimer:stop()
    else
        --if(lightSensor:getState() == 0) then
            print("Turn on led")
            ledDriver:on()
        --else
        --    print("Do not turn led on. It's to bright.")
        --    return
       -- end
    end

    print("Starting countback timer")
    countBackTimer:start()
end

local function lightLevelCheckTimerStart()
    local isLightLevelRunning, mode = lightLevelTimer:state()

    if(not isLightLevelRunning) then
        lightLevelTimer:alarm(
            500,
            tmr.ALARM_AUTO, 
            function()
                local lightState = lightSensor:getState()
                -- print("light state check res: " .. lightState)
                if(lightState == 0) then
                    local isCountBackTimerRunning, mode = countBackTimer:state()
                    if(not isCountBackTimerRunning) then
                        turnOnLedAndRestartTurnOffTimer()
                    end
                end
            end
        )
    end
end

local function noMotionTimerStart()
    local isRunning, mode = noMotionTimer:state()

    if(isRunning) then
        noMotionTimer:stop()
    end
    noMotionTimer:start()
end

local function noMotionTimerStop()
    noMotionTimer:stop()
end
--[[
local function turnOff()
    ledDriver:off()
end
]]

local function moveDetected(level, time)
    print("move changed to " .. level)
    if(level == gpio.HIGH) then
        
        noMotionTimerStop()

        local isRunning, mode = countBackTimer:state()
        if(not isRunning) then
            print("(re)start light level timer")
            lightLevelCheckTimerStart()
        else
            turnOnLedAndRestartTurnOffTimer()
        end
        -- lightLevelCheckTimerStart()
    else
        print("no motion")
        noMotionTimerStart()
    end
end

print('init motion senson listener')
gpio.trig(moveSensorPin, 'both', moveDetected)
