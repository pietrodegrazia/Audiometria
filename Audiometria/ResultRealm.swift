//
//  ResultRealm.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 20/08/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation
//import RealmSwift

class ResultsRealm /*: Object */ {
    var freq500_20db: StepResult
    var freq500_40db: StepResult
    var freq500_60db: StepResult
    
    var freq1000_20db: StepResult
    var freq1000_40db: StepResult
    var freq1000_60db: StepResult
    
    var freq2000_20db: StepResult
    var freq2000_40db: StepResult
    var freq2000_60db: StepResult
    
    var freq4000_20db: StepResult
    var freq4000_40db: StepResult
    var freq4000_60db: StepResult
    
    var freq8000_20db: StepResult
    var freq8000_40db: StepResult
    var freq8000_60db: StepResult
    
    func asResultDictionary() -> Results {
        let dict:Results = [
            500:[
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[500]![20]!, result: freq500_20db),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[500]![40]!, result: freq500_40db),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[500]![60]!, result: freq500_60db)
            ],
            1000:[
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[1000]![20]!, result: freq1000_20db),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[1000]![40]!, result: freq1000_40db),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[1000]![60]!, result: freq1000_60db)
            ],
            2000:[
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[2000]![20]!, result: freq2000_20db),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[2000]![40]!, result: freq2000_40db),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[2000]![60]!, result: freq2000_60db)
            ],
            4000:[
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[4000]![20]!, result: freq4000_20db),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[4000]![40]!, result: freq4000_40db),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[4000]![60]!, result: freq4000_60db)
            ],
            8000:[
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[8000]![20]!, result: freq8000_20db),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[8000]![40]!, result: freq8000_40db),
                ResultTuple(amplitude: iPodTouchAmplitudeAPITable[8000]![60]!, result: freq8000_60db)
            ]
        ]
        
        return dict
    }
    
    init(resultsDictionary: Results) {
        freq500_20db = .unknown
        freq500_40db = .unknown
        freq500_60db = .unknown
        
        freq1000_20db = .unknown
        freq1000_40db = .unknown
        freq1000_60db = .unknown
        
        freq2000_20db = .unknown
        freq2000_40db = .unknown
        freq2000_60db = .unknown
        
        freq4000_20db = .unknown
        freq4000_40db = .unknown
        freq4000_60db = .unknown
        
        freq8000_20db = .unknown
        freq8000_40db = .unknown
        freq8000_60db = .unknown
        
        for (frequency, results) in resultsDictionary {
            switch frequency {
            case 500:
                for result in results {
                    let resAux = result.result
                    switch result.amplitude {
                    case 20:
                        freq500_20db = resAux
                    case 40:
                        freq500_40db = resAux
                    case 60:
                        freq500_60db = resAux
                    default:
                        debugPrint("Amplitude \(result.amplitude) não esperada na frequencia \(frequency)")
                    }
                }
                
                
            case 1000:
                for result in results {
                    let resAux = result.result
                    switch result.amplitude {
                    case 20:
                        freq1000_20db = resAux
                    case 40:
                        freq1000_40db = resAux
                    case 60:
                        freq1000_60db = resAux
                    default:
                        debugPrint("Amplitude \(result.amplitude) não esperada na frequencia \(frequency)")
                    }
                }
                
                
            case 2000:
                for result in results {
                    let resAux = result.result
                    switch result.amplitude {
                    case 20:
                        freq2000_20db = resAux
                    case 40:
                        freq2000_40db = resAux
                    case 60:
                        freq2000_60db = resAux
                    default:
                        debugPrint("Amplitude \(result.amplitude) não esperada na frequencia \(frequency)")
                    }
                }
                
                
            case 4000:
                for result in results {
                    let resAux = result.result
                    switch result.amplitude {
                    case 20:
                        freq4000_20db = resAux
                    case 40:
                        freq4000_40db = resAux
                    case 60:
                        freq4000_60db = resAux
                    default:
                        debugPrint("Amplitude \(result.amplitude) não esperada na frequencia \(frequency)")
                    }
                }
                
                
            case 8000:
                for result in results {
                    let resAux = result.result
                    switch result.amplitude {
                    case 20:
                        freq8000_20db = resAux
                    case 40:
                        freq8000_40db = resAux
                    case 60:
                        freq8000_60db = resAux
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
