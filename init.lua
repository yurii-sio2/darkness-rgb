function startup()
    print('in startup')
    -- dofile('main.lua')
    dofile("move-and-led.lua");
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

tmr.alarm(0,6000,0,startup)
print("init file executed")

