//
//  ToneTestInteractor.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 04/04/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation

typealias FrequencyAmplitude = (frequency: Double, amplitude20: Double, amplitude40: Double, amplitude60: Double)
typealias AmplitudeConversionTable = [(frequency: Double, amplitudeIn: Double, amplitudeOut: Double)]

struct Contants {
    static let iPod_touch: [FrequencyAmplitude] = [(1000, -1,  0.008, 0.1),
                                                   (2000, -1,  0.019, 0.02),
                                                   (4000, -1,  0.035, 0.023),
                                                   (8000, -1,  0.0028, 0.025),
                                                   (500,  -1,       1, -1)]
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
        
        (8000,     -1, 20),
        (8000, 0.0028, 40),
        (8000,  0.025, 60),
        
        (500, -1, 20),
        (500,  1, 40),
        (500, -1, 60),
    ]
}

class TestInteractor {
    
    private lazy var stepsTree: ToneTestStep? = { () -> ToneTestStep? in
        debugPrint("Criou arvore")
        var firstToneTestStep: ToneTestStep?
        var lastToneTestStep: ToneTestStep?
        for (index, freq) in Contants.iPod_touch.enumerated() {
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
    
    func step(_ step: ToneTestStep?, forResult result: StepResult) -> ToneTestStep? {
        guard let currentStep = step else {
            return stepsTree
        }
        
        switch result {
        case .heard:
            return currentStep.heardTest
            
        case .notHeard:
            return currentStep.notHeardTest
            
        case .outOfRange:
            return currentStep.heardTest
            
        case .notTested:
            return currentStep.heardTest
        }
    }
    
}
