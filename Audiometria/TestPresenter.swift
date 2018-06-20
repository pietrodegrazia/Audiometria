//
//  TestPresenter.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 04/04/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation

let iPodTouchAmplitudeAPITable:[Frequency:[AmplitudeReal:AmplitudeAPI]] = [
    1000: [
        20:-1,
        40:0.008,
        60:0.1,
    ],
    2000: [
        20:-1,
        40:0.019,
        60:0.02,
    ],
    4000: [
        20:-1,
        40:0.035,
        60:0.023,
    ],
    8000: [
        20:0.0002,
        40:0.0028,
        60:0.025,
    ],
    500: [
        20:-1,
        40:1,
        60:-1,
    ]
]

func amplitudeReal(frequency: Frequency, amplitudeAPI: AmplitudeAPI) -> AmplitudeReal {
    let dict = iPodTouchAmplitudeAPITable[frequency]!
    let filtered = dict.filter { (dict: (key: AmplitudeReal, value: AmplitudeAPI)) -> Bool in
        return dict.value == amplitudeAPI
    }
    
    if let val = filtered.first {
        return val.key
    } else {
        print("(\(frequency), \((amplitudeAPI)))")
//        assertionFailure("Não tem suporte à esta amplitude na frequencia de \(frequency)!")
        return 0
    }
}

func amplitudeAPI(frequency: Frequency, amplitudeReal: AmplitudeReal) -> AmplitudeAPI {
    let dict = iPodTouchAmplitudeAPITable[frequency]!
    if let filtered = dict[amplitudeReal] {
        return filtered
    } else {
        print("(\(frequency), \((amplitudeReal))")
//        assertionFailure("Não tem suporte à esta amplitude na frequencia de \(frequency)!")
        return 0
    }
}

typealias ResultTuple = (amplitude: AmplitudeAPI, result: StepResult)
typealias Results = [Frequency:[ResultTuple]]

protocol TestInterface {
    func didStartTest()
    func didStopTest()
    func didFinishTest(results: Results)
    func play(step: ToneTestStep, withDuration duration: TimeInterval)
}

class TestPresenter {
    
    private struct ToneDuration {
        static let betweenAmplitude: TimeInterval = 4
        static let betweenFrequency: TimeInterval = 2
    }
    
    // MARK: - Public vars
    var interface: TestInterface?
    
    // MARK: - Private vars
    private var results: Results?
    private var currentResult: StepResult!
    
    private var currentStep: ToneTestStep? {
        willSet {
            // finalizando teste
            if newValue != nil {
                if let step = currentStep {
                    if results == nil {
                        results = Results()
                    }
                    
                    if results![step.frequency] == nil {
                        results![step.frequency] = [ResultTuple]()
                    }
                    
                    let amplitudeReal = Constants.iPodTouchConversionTable
                        .filter { $0.0 == Int(step.frequency) }
                        .filter { abs($0.1 - step.amplitude) <= 1e-3 }
                        .first!.2
                    
                    let result = ResultTuple(Double(amplitudeReal), currentResult)
                    results![step.frequency]!.append(result)
                } else {
                    debugPrint("Vai trocar o step, currentStep é nil, está comecando o teste?")
                }
            } else {
                debugPrint("Vai trocar o currentStep pra nil, está finalizando o teste?")
            }
        }
    }
    private var interactor = TestInteractor()
    
    // MARK: - Public methods
    func startTest() {
        interface?.didStartTest()
        results = nil
        nextStep()
    }
    
    func stopTest() {
        interface?.didStopTest()
    }
    
    func timeout() {
        nextStep(forResult: .notHeard)
    }
    
    func userHeard() {
        nextStep(forResult: .heard)
    }
    
    // MARK: - Private methods
    private func finishTest() {
        stopTest()
        currentStep = nil
        if results != nil {
            interface?.didFinishTest(results: results!)
        } else {
            debugPrint("Sem results")
        }
    }
    
    private func nextStep(forResult result: StepResult = .notTested) {
        let heard = (result == .heard)
        var step = interactor.step(currentStep, didHear: heard)
        step?.amplitude = iPodTouchAmplitudeAPITable[step!.frequency]![Int(step!.amplitude)]!
        
        currentResult = result
        currentStep = step
        
        while (step != nil && step!.amplitude < 0) {
            currentResult = (step!.amplitude < 0) ? .outOfRange : .heard
            step = interactor.step(currentStep, didHear: heard)
            step?.amplitude = iPodTouchAmplitudeAPITable[step!.frequency]![Int(step!.amplitude)]!
            currentStep = step
        }
        
        if step == nil {
            finishTest()
        } else {
            var duration: TimeInterval = ToneDuration.betweenAmplitude
            if currentStep != nil && currentStep!.amplitude > 0 {
                if currentStep?.amplitude != step!.amplitude {
                    duration = ToneDuration.betweenAmplitude
                }
                
                if currentStep?.frequency != step!.frequency {
                    duration = ToneDuration.betweenFrequency
                }
            }
            
            interface?.play(step: step!, withDuration: duration)
        }
    }
}
