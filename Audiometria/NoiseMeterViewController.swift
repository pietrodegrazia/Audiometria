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
    
    @IBOutlet weak var amplitudeLabel: UILabel!
    
    
    // MARK: Private vars
    fileprivate var lastEnvironmentNoiseState = EnvironmentNoiseState.forbidden {
        willSet(currentState) {
            if currentState != lastEnvironmentNoiseState {
                let duration:CFTimeInterval = 1/10
                startBtn.isEnabled = (currentState != .forbidden)
                detailText.setTextWithFade(currentState.detailText(), withDuration: duration)
                view.layer.animateToBackgroundColor(currentState.color().cgColor, withDuration: duration)
            }
        }
    }
    
    // MARK: Private consts
    fileprivate let interval: TimeInterval = 1/60
    fileprivate let meterTable = MeterTableOC(minDB: -80)
    fileprivate let noiseMeter = NoiseMeter(channels: [0,1])
    
    // MARK: Outlets
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoiseMeter()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        noiseMeter.stopMeasure()
    }
    
    // MARK: Private helpers
    fileprivate func setupNoiseMeter() {
        noiseMeter.delegate = self
        noiseMeter.startMeasureWithInterval(interval)
    }
    
}

// MARK: - NoiseMeterDelegate
extension NoiseMeterViewController: NoiseMeterDelegate {
    
    func noiseMeter(_ noiseMeter: NoiseMeter, didOccurrError error: Error) {
        print(error)
    }
    
    func noiseMeter(_ noiseMeter: NoiseMeter, didMeasurePower power: Float, forChannel channel: Int) {
        amplitudeLabel.text = "\(power)"
        lastEnvironmentNoiseState = EnvironmentNoiseState(power: power)
    }
    
}

// MARK: - EnvironmentNoiseState enum
enum EnvironmentNoiseState: Int {
    
    case acceptable = 0
    case warning = 1
    case forbidden = 2
    
    init(power: Float) {
        if (power < -20) {
            self.init(rawValue: EnvironmentNoiseState.acceptable.rawValue)!
        } else if (power >= -20 && power <= -10) {
            self.init(rawValue: EnvironmentNoiseState.warning.rawValue)!
        } else {
            self.init(rawValue: EnvironmentNoiseState.forbidden.rawValue)!
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .acceptable:
            return UIColor ( red: 0.0, green: 0.5381, blue: 0.0002, alpha: 1.0 )
        case .warning:
            return UIColor ( red: 0.8907, green: 0.8174, blue: 0.0342, alpha: 1.0 )
        case .forbidden:
            return UIColor ( red: 0.7127, green: 0.0, blue: 0.0, alpha: 1.0 )
        }
    }
    
    func detailText() -> String {
        switch self {
        case .acceptable:
            return "O teste pode ser realizado neste ambiente"
        case .warning:
            return "O teste pode ser realizado neste ambiente, porém, os resultados podem não ser precisos"
        case .forbidden:
            return "O teste não pode ser realizado neste ambiente, por favor vá até um ambiente mais silencioso"
        }
    }
    
}
