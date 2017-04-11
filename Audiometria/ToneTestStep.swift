//
//  ToneTestStep.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 06/04/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation

enum StepResult: Int {
    case notHeard
    case heard
    
    // Frequencia nao testada pois o usuario ouviu tudo ou nao ouviu tudo
    // Exemplo:
    // Ouviu (1000Hz, 40db), foi pra (1000Hz, 20db), ou seja
    // nunca foi testado (1000Hz, 60db)
    case notTested
    
    // Dispositivo nao consegue tocar a frequencia/amplitude
    case outOfRange
}

class ToneTestStep {
    
    var frequency: Double
    var amplitude: Double
    var heardTest: ToneTestStep?
    var notHeardTest: ToneTestStep?
    var heard = false
    var result: StepResult
    var realAmplitude: Int {
        let row = Contants.iPodTouchConversionTable.filter { (row: (Int, Double, Int)) -> Bool in
            return self.frequency == Double(row.0) && self.amplitude == row.1
        }
        
        return row.first!.2
    }
    
    init(frequency: Double, amplitude: Double, heardTest: ToneTestStep?, notHeardTest: ToneTestStep?, result: StepResult = .notTested) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.heardTest = heardTest
        self.notHeardTest = notHeardTest
        self.result = result
    }
    
    var debugDescription: String {
        return "ToneTestStep { frequency: \(frequency), amplitude: \(self.amplitude), realAmplitude: \(realAmplitude) }"
    }
    
}

//extension ToneTestStep: Equatable {}
//
//func ==(lhs: ToneTestStep, rhs: ToneTestStep) -> Bool {
//    return lhs.amplitude ==
//}
//
