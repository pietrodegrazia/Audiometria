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
    private var noiseMeter = NoiseMeter(channels: [0,1])
    private let interval:NSTimeInterval = 1/60
    
    // MARK: Outlets
    @IBOutlet weak var channel0ProgressView: UIProgressView!
    @IBOutlet weak var channel1ProgressView: UIProgressView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNoiseMeter()
    }
    
    // MARK: IBAction
    @IBAction func buttonPressed(sender: AnyObject) {
        noiseMeter.isMeasuring ? noiseMeter.stopMeasure() : noiseMeter.startMeasureWithInterval(interval)
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
        let mappedPower = map(power, inMin: -160, inMax: 160).floatValue
        switch channel {
        case 0:
            channel0ProgressView.setProgress(mappedPower, animated: true)
        
        case 1:
            channel1ProgressView.setProgress(mappedPower, animated: true)
        
        default:
            print("Unknown channel")
            
        }
        
        print("power(\(channel)): \(power)")
    }
    
}