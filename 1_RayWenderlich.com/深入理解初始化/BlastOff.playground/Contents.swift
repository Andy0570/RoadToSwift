import Foundation

struct RocketConfiguration {
    let name: String = "Athena 9 Heavy"
    let numberOfFirstStageCores: Int = 3
    let numberOfSecondStageCores: Int = 1

    let numberOfStageReuseLandingLegs: Int? = nil
}

// 如果结构体的存储属性是可选常量，且没有赋初始值，编译器报错
// let numberOfStageReuseLandingLegs: Int?
let athena9Heavy = RocketConfiguration()


struct RocketStageConfiguration {
    let propellantMass: Double
    let liquidOxygenMass: Double
    let nominalBurnTime: Int
}

// 如果你自定义了一个初始化器，系统就不再提供默认的成员初始化器了
// 但如果你把自定义初始化器写在 extension 里面，鱼和熊掌兼得
extension RocketStageConfiguration {
    init(propellantMass: Double, liquidOxygenMass: Double) {
        self.propellantMass = propellantMass
        self.liquidOxygenMass = liquidOxygenMass
        self.nominalBurnTime = 180
    }
}

// 如果结构体中存储属性的声明次序发生改变，编译器报错
// 如果某个存储属性自带初始值，编译器报错
// let stageOneConfiguration = RocketStageConfiguration(propellantMass: 119.1, liquidOxygenMass: 276.0)
let stageOneConfiguration = RocketStageConfiguration(propellantMass: 119.1,
  liquidOxygenMass: 276.0, nominalBurnTime: 180)


struct Weather {
    let temperatureCelsius: Double
    let windSpeedKilometersPerHour: Double

    init(temperatureFahrenheit: Double = 72, windSpeedMilesPerHour: Double = 5) {
      self.temperatureCelsius = (temperatureFahrenheit - 32) / 1.8
      self.windSpeedKilometersPerHour = windSpeedMilesPerHour * 1.609344
    }
}

let currentWeather = Weather(temperatureFahrenheit: 87, windSpeedMilesPerHour: 2)
currentWeather.temperatureCelsius
currentWeather.windSpeedKilometersPerHour


struct GuidanceSensorStatus {
    var currentZAngularVelocityRadiansPerMinute: Double
    let initialZAngularVelocityRadiansPerMinute: Double
    var needsCorrection: Bool

    init(zAngularVelocityDegreesPerMinute: Double, needsCorrection: Bool = false) {
        let radiansPerMinute = zAngularVelocityDegreesPerMinute * 0.01745329251994
        self.currentZAngularVelocityRadiansPerMinute = radiansPerMinute
        self.initialZAngularVelocityRadiansPerMinute = radiansPerMinute
        self.needsCorrection = needsCorrection
    }

    init(zAngularVelocityDegreesPerMinute: Double, needsCorrection: Int) {
      self.init(zAngularVelocityDegreesPerMinute: zAngularVelocityDegreesPerMinute,
       needsCorrection: (needsCorrection > 0))
    }

}

let guidanceStatus = GuidanceSensorStatus(zAngularVelocityDegreesPerMinute: 2.2)
guidanceStatus.currentZAngularVelocityRadiansPerMinute // 0.038
guidanceStatus.needsCorrection // false



struct CombustionChamberStatus {
    var temperatureKelvin: Double
    var pressureKiloPascals: Double

    init(temperatureKelvin: Double, pressureKiloPascals: Double) {
        print("Phase 1 init")
        self.temperatureKelvin = temperatureKelvin
        self.pressureKiloPascals = pressureKiloPascals
        print("CombustionChamberStatus fully initialized")
        print("Phase 2 init")
    }

    init(temperatureCelsius: Double, pressureAtmospheric: Double) {
        print("Phase 1 delegating init")
        let temperatureKelvin = temperatureCelsius + 273.15
        let pressureKiloPascals = pressureAtmospheric * 101.325
        self.init(temperatureKelvin: temperatureKelvin, pressureKiloPascals: pressureKiloPascals)
        print("Phase 2 delegating init")
    }
}

CombustionChamberStatus(temperatureCelsius: 32, pressureAtmospheric: 0.96)

// 油箱状态
struct TankStatus {
    var currentVolume: Double
    var currentLiquidType: String?

    init?(currentVolume: Double, currentLiquidType: String?) {
        if currentVolume < 0 {
            return nil
        }
        if currentVolume > 0 && currentLiquidType == nil {
            return nil
        }
        self.currentVolume = currentVolume
        self.currentLiquidType = currentLiquidType
    }
}

if let tankStatus = TankStatus(currentVolume: 0.0, currentLiquidType: nil) {
    print("Nice, tank status created.") // Printed!
} else {
    print("Oh no, an initialization failure occurred.")
}


enum InvalidAstronautDataError: Error {
    case EmptyName
    case InvalidAge
}

// 宇航员
struct Astronaut {
    let name: String
    let age: Int

    init(name: String, age: Int) throws {
        if name.isEmpty {
            throw InvalidAstronautDataError.EmptyName
        }
        if age < 18 || age > 70 {
            throw InvalidAstronautDataError.InvalidAge
        }
        self.name = name
        self.age = age
    }
}

// let johnny = try? Astronaut(name: "Johnny Cosmoseed", age: 42)
let johnny = try? Astronaut(name: "Johnny Cosmoseed", age: 17)

