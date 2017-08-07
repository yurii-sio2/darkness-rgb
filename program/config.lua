moveSensorPin = 1     -- GPIO5

lighSensorCnf={}
lighSensorCnf.lowerThreshold = 850
lighSensorCnf.upperThreshold = 900

ledsCnf = {}
ledsCnf.pinRed = 7            -- GPIO13
ledsCnf.pinGreen = 6          -- GPIO12
ledsCnf.pinBlue = 5           -- GPIO14
ledsCnf.ledOnTimeoutSec = 120
ledsCnf.changeColorOncePerSeconds = 20