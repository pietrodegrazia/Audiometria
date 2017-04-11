//
//  TestPresenter.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 04/04/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation

typealias ResultTuple = (amplitude: Double, result: StepResult)
typealias Results = [Double:[ResultTuple]]

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
    
    private var currentStep: ToneTestStep? {
        willSet {
            if let step = currentStep {
                if results == nil {
                    results = Results()
                }
                
                if results![step.frequency] == nil {
                    results![step.frequency] = [ResultTuple]()
                }
                
                let result = ResultTuple(step.amplitude, step.result)
                results![step.frequency]!.append(result)
            } else {
                debugPrint("Vai trocar o step, currentStep é nil, está comecando o teste?")
            }
        }
    }
    private var interactor = TestInteractor()
    
    // MARK: - Public methods
    func startTest() {
        interactor.printTree()
        
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
        var step = interactor.step(currentStep, forResult: result)
        while (step != nil && step!.amplitude < 0) {
            currentStep = step
            step = interactor.step(currentStep, forResult: .outOfRange)
        }
        
        if step == nil {
            finishTest()
        } else {
            var duration: TimeInterval = ToneDuration.betweenAmplitude
            if currentStep != nil && currentStep?.amplitude != -1 {
                if currentStep?.amplitude != step!.amplitude {
                    duration = ToneDuration.betweenAmplitude
                }
                
                if currentStep?.frequency != step!.frequency {
                    duration = ToneDuration.betweenFrequency
                }
            }
            
            interface?.play(step: step!, withDuration: duration)
            currentStep = step
        }
    }
}
