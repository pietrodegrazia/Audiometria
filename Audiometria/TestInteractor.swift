//
//  ToneTestInteractor.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 04/04/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation

typealias FrequencyAmplitude = (frequency: Frequency, amplitude20: AmplitudeAPI, amplitude40: AmplitudeAPI, amplitude60: AmplitudeAPI)
typealias AmplitudeConversionTable = [(frequency: Frequency, amplitudeIn: AmplitudeReal, amplitudeOut: AmplitudeAPI)]

public struct Constants {
    static let iPod_touch: [FrequencyAmplitude] = [(1000,     -1,  0.008, 0.1),
                                                   (2000,     -1,  0.019, 0.02),
                                                   (4000,     -1,  0.035, 0.023),
                                                   (8000, 0.0002, 0.0028, 0.025),
                                                   (500,      -1,      1, -2)]
    static let iPodTouchConversionTable = [
        (1000,    -1, 20),
        (1000, 0.008, 40),
        (1000,   0.1, 60),
        
        (2000,    -1, 20),
        (2000, 0.019, 40),
        (2000,  0.02, 60),
        
        (4000,    -1, 20),
        (4000, 0.035, 40),
        (4000, 0.023, 60),
        
        (8000, 0.0002, 20),
        (8000, 0.0028, 40),
        (8000,  0.025, 60),
        
        (500, -1, 20),
        (500,  1, 40),
        (500, -1, 60),
        ]
}


typealias Frequency = Int
typealias AmplitudeReal = Int
typealias AmplitudeAPI = Double
typealias HeardStatus = Bool

let iPodTouchAmplitudeRealTable: [Frequency:[HeardStatus:AmplitudeReal]] = [
    1000: [
        true:20,
        false:60,
    ],
    2000: [
        true:20,
        false:60,
    ],
    4000: [
        true:20,
        false:60,
    ],
    8000: [
        true:20,
        false:60,
    ],
    500: [
        true:20,
        false:60,
    ]
]

//public func amplitude(fromTone tone: PlayerTone) -> Int {
//    let frequencyData = iPodTouchAmplitudeAPITable[tone.Frequency]!.first { (val: (key: AmplitudeReal, value: AmplitudeAPI)) -> Bool in
//        return val.value == tone.Amplitude
//    }
//    
//    return Int(frequencyData!.value)
//}

//1000: [
//    20:-1,
//    40:0.008,
//    60:0.1,
//],

//func amplitude(fromStep step: ToneTestStep) -> Int {
//    let frequencyData = iPodTouchAmplitudeAPITable[step.frequency]!.first { (val: (key: AmplitudeReal, value: AmplitudeAPI)) -> Bool in
//        return val.key == step.amplitude
////        return true
//    }
//    
//    return Int(frequencyData!.value)
//}

class TestInteractor {
    
    private lazy var stepsTree: ToneTestStep? = { () -> ToneTestStep? in
        debugPrint("Criou arvore")
        var firstToneTestStep: ToneTestStep?
        var lastToneTestStep: ToneTestStep?
        for (index, freq) in Constants.iPod_touch.enumerated() {
            let heardStep = ToneTestStep(frequency: freq.frequency, amplitude: freq.amplitude20, heardTest: nil, notHeardTest: nil)
            let notHeardStep = ToneTestStep(frequency: freq.frequency, amplitude: freq.amplitude60, heardTest: nil, notHeardTest: nil)
            let step = ToneTestStep(frequency: freq.frequency, amplitude: freq.amplitude40, heardTest: heardStep, notHeardTest: notHeardStep)
            
            if index == 0 {
                firstToneTestStep = step
            } else {
                lastToneTestStep!.heardTest?.heardTest = step
                lastToneTestStep!.heardTest?.notHeardTest = step
                lastToneTestStep!.notHeardTest?.heardTest = step
                lastToneTestStep!.notHeardTest?.notHeardTest = step
            }
            
            lastToneTestStep = step
        }
        
        return firstToneTestStep
    }()
    
    private let initialAmplitude: AmplitudeReal = 40
    private let frequencyOrder: [Frequency] = [1000, 2000, 4000, 8000, 500]
    
    func step(_ step: ToneTestStep?, didHear: Bool) -> ToneTestStep? {
        guard let currentStep = step else {
            let tone = ToneTestStep(frequency: frequencyOrder.first!, amplitude: Double(initialAmplitude))
            return tone
        }
        
        let amplitudeRealCurrent = Constants.iPodTouchConversionTable
            .filter { $0.0 == Int(currentStep.frequency) }
            .filter { abs($0.1 - currentStep.amplitude) <= 1e-3 }
            .first!.2
        
        if amplitudeRealCurrent == initialAmplitude {
            let frequencyData = iPodTouchAmplitudeRealTable[currentStep.frequency]!
            let amplitudeReal = Double(frequencyData[didHear]!)
            return ToneTestStep(frequency: currentStep.frequency, amplitude: amplitudeReal)
        } else {
            let indexCurrentFrequency = frequencyOrder.index(of: currentStep.frequency)!
            let indexNextFrequency = indexCurrentFrequency + 1
            if indexNextFrequency > frequencyOrder.endIndex-1 {
                // acabou teste
                return nil
            } else {
                let nextFrequency = frequencyOrder[indexNextFrequency]
//                let frequencyData = iPodTouchAmplitudeRealTable[nextFrequency]!
                //                let amplitudeReal = Double(frequencyData[didHear]!)
                let amplitudeReal = Double(40) // sempre 40 pq aqui trocou frequencia
                return ToneTestStep(frequency: nextFrequency, amplitude: amplitudeReal)
            }
        }
    }
    
}

func ==(lhs: Double, rhs: Double) -> Bool {
    let threshold = 1e-3
    return (abs(lhs - rhs) <= threshold)
}


