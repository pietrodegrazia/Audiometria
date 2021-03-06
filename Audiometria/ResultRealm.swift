//
//  ResultRealm.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 20/08/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation
import RealmSwift

class ResultsRealm: Object {
    dynamic var freq500_20db = -1
    dynamic var freq500_40db = -1
    dynamic var freq500_60db = -1
    
    dynamic var freq1000_20db = -1
    dynamic var freq1000_40db = -1
    dynamic var freq1000_60db = -1
    
    dynamic var freq2000_20db = -1
    dynamic var freq2000_40db = -1
    dynamic var freq2000_60db = -1
    
    dynamic var freq4000_20db = -1
    dynamic var freq4000_40db = -1
    dynamic var freq4000_60db = -1
    
    dynamic var freq8000_20db = -1
    dynamic var freq8000_40db = -1
    dynamic var freq8000_60db = -1
    
    func asResultDictionary() -> Results {
        let dict:Results = [
            500:[
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[500]![20]!, result: StepResult(rawValue: freq500_20db)!),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[500]![40]!, result: StepResult(rawValue: freq500_40db)!),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[500]![60]!, result: StepResult(rawValue: freq500_60db)!)
            ],
            1000:[
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[1000]![20]!, result: StepResult(rawValue: freq1000_20db)!),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[1000]![40]!, result: StepResult(rawValue: freq1000_40db)!),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[1000]![60]!, result: StepResult(rawValue: freq1000_60db)!)
            ],
            2000:[
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[2000]![20]!, result: StepResult(rawValue: freq2000_20db)!),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[2000]![40]!, result: StepResult(rawValue: freq2000_40db)!),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[2000]![60]!, result: StepResult(rawValue: freq2000_60db)!)
            ],
            4000:[
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[4000]![20]!, result: StepResult(rawValue: freq4000_20db)!),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[4000]![40]!, result: StepResult(rawValue: freq4000_40db)!),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[4000]![60]!, result: StepResult(rawValue: freq4000_60db)!)
            ],
            8000:[
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[8000]![20]!, result: StepResult(rawValue: freq8000_20db)!),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[8000]![40]!, result: StepResult(rawValue: freq8000_40db)!),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[8000]![60]!, result: StepResult(rawValue: freq8000_60db)!)
            ]
        ]
        
        return dict
    }
    
    convenience init(resultsDictionary: Results) {
        self.init()
        setVariableFrom(resultsDictionary: resultsDictionary)
    }
    
    func setVariableFrom(resultsDictionary: Results) {
        
        freq500_20db = StepResult.notTested.rawValue
        freq500_40db = StepResult.notTested.rawValue
        freq500_60db = StepResult.notTested.rawValue
        
        freq1000_20db = StepResult.notTested.rawValue
        freq1000_40db = StepResult.notTested.rawValue
        freq1000_60db = StepResult.notTested.rawValue
        
        freq2000_20db = StepResult.notTested.rawValue
        freq2000_40db = StepResult.notTested.rawValue
        freq2000_60db = StepResult.notTested.rawValue
        
        freq4000_20db = StepResult.notTested.rawValue
        freq4000_40db = StepResult.notTested.rawValue
        freq4000_60db = StepResult.notTested.rawValue
        
        freq8000_20db = StepResult.notTested.rawValue
        freq8000_40db = StepResult.notTested.rawValue
        freq8000_60db = StepResult.notTested.rawValue
        
        for (frequency, results) in resultsDictionary {
            switch frequency {
            case 500:
                for result in results {
                    let resAux = result.result
                    switch result.amplitude {
                    case 20:
                        freq500_20db = resAux.rawValue
                    case 40:
                        freq500_40db = resAux.rawValue
                    case 60:
                        freq500_60db = resAux.rawValue
                    default:
                        debugPrint("Amplitude \(result.amplitude) não esperada na frequencia \(frequency)")
                    }
                }
                
                
            case 1000:
                for result in results {
                    let resAux = result.result
                    switch result.amplitude {
                    case 20:
                        freq1000_20db = resAux.rawValue
                    case 40:
                        freq1000_40db = resAux.rawValue
                    case 60:
                        freq1000_60db = resAux.rawValue
                    default:
                        debugPrint("Amplitude \(result.amplitude) não esperada na frequencia \(frequency)")
                    }
                }
                
                
            case 2000:
                for result in results {
                    let resAux = result.result
                    switch result.amplitude {
                    case 20:
                        freq2000_20db = resAux.rawValue
                    case 40:
                        freq2000_40db = resAux.rawValue
                    case 60:
                        freq2000_60db = resAux.rawValue
                    default:
                        debugPrint("Amplitude \(result.amplitude) não esperada na frequencia \(frequency)")
                    }
                }
                
                
            case 4000:
                for result in results {
                    let resAux = result.result
                    switch result.amplitude {
                    case 20:
                        freq4000_20db = resAux.rawValue
                    case 40:
                        freq4000_40db = resAux.rawValue
                    case 60:
                        freq4000_60db = resAux.rawValue
                    default:
                        debugPrint("Amplitude \(result.amplitude) não esperada na frequencia \(frequency)")
                    }
                }
                
                
            case 8000:
                for result in results {
                    let resAux = result.result
                    switch result.amplitude {
                    case 20:
                        freq8000_20db = resAux.rawValue
                    case 40:
                        freq8000_40db = resAux.rawValue
                    case 60:
                        freq8000_60db = resAux.rawValue
                    default:
                        debugPrint("Amplitude \(result.amplitude) não esperada na frequencia \(frequency)")
                    }
                }
                
            default:
                debugPrint("Frequencia \(frequency) não esperada")
                
            }
        }
    }
}
