//
//  NoiseMeterViewController.swift
//  Audiometria
//
//  Created by Marcus Vinicius Kuquert on 26/04/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import AVFoundation
import UIKit

class NoiseMeterViewController: UIViewController {
    
    // MARK: Private vars
    private var lastEnvironmentNoiseState = EnvironmentNoiseState.Forbidden {
        willSet(currentState) {
            if currentState != lastEnvironmentNoiseState {
                let duration:CFTimeInterval = 1/10
                startBtn.enabled = (currentState != .Forbidden)
                detailText.setTextWithFade(currentState.detailText(), withDuration: duration)
                view.layer.animateToBackgroundColor(currentState.color().CGColor, withDuration: duration)
            }
        }
    }
    
    // MARK: Private consts
    private let interval:NSTimeInterval = 1/60
    private let meterTable = MeterTableOC(minDB: -80)
    private let noiseMeter = NoiseMeter(channels: [0,1])
    
    // MARK: Outlets
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoiseMeter()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        noiseMeter.stopMeasure()
    }
    
    // MARK: Private helpers
    private func setupNoiseMeter() {
        noiseMeter.delegate = self
        noiseMeter.startMeasureWithInterval(interval)
    }
    
}

// MARK: - NoiseMeterDelegate
extension NoiseMeterViewController: NoiseMeterDelegate {
    
    func noiseMeter(noiseMeter: NoiseMeter, didOccurrError error: ErrorType) {
        print(error)
    }
    
    func noiseMeter(noiseMeter: NoiseMeter, didMeasurePower power: Float, forChannel channel: Int) {
        lastEnvironmentNoiseState = EnvironmentNoiseState(power: power)
    }
    
}

// MARK: - EnvironmentNoiseState enum
enum EnvironmentNoiseState: Int {
    
    case Acceptable = 0
    case Warning = 1
    case Forbidden = 2
    
    init(power: Float) {
        if (power < -20) {
            self.init(rawValue: EnvironmentNoiseState.Acceptable.rawValue)!
        } else if (power >= -20 && power <= -10) {
            self.init(rawValue: EnvironmentNoiseState.Warning.rawValue)!
        } else {
            self.init(rawValue: EnvironmentNoiseState.Forbidden.rawValue)!
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .Acceptable:
            return UIColor ( red: 0.0, green: 0.5381, blue: 0.0002, alpha: 1.0 )
        case .Warning:
            return UIColor ( red: 0.8907, green: 0.8174, blue: 0.0342, alpha: 1.0 )
        case .Forbidden:
            return UIColor ( red: 0.7127, green: 0.0, blue: 0.0, alpha: 1.0 )
        }
    }
    
    func detailText() -> String {
        switch self {
        case .Acceptable:
            return "O teste pode ser realizado neste ambiente"
        case .Warning:
            return "O teste pode ser realizado neste ambiente, porém, os resultados podem não ser precisos"
        case .Forbidden:
            return "O teste não pode ser realizado neste ambiente, por favor vá até um ambiente mais silencioso"
        }
    }
    
}