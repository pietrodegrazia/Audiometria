//
//  ToneTestViewController.swift
//  Audiometria
//
//  Created by Pietro Degrazia on 4/28/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import UIKit

enum Segue: String {
    case ShowResult
}

class ToneTestViewController: UIViewController, PlayerInterface, TestInterface {
    @IBOutlet weak var currentAmplitudeLabel: UILabel!
    @IBOutlet weak var currentFrequencyLabel: UILabel!
    @IBOutlet weak var soundPlayingImageView: UIImageView!
    @IBOutlet weak var userHeardButton: UIButton!
    
    // MARK: - Private constants
    private let eventHandler = TestPresenter()
    private let player = TonePlayer()
    
    
    // MARK: - Private vars
    private var timer = Timer()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Warning: arrumar
        eventHandler.interface = self
        player?.interface = self
    }
    
    // MARK: - Private helpers
    private func createTimer(withTimerInterval interval: TimeInterval) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timedOut), userInfo: nil, repeats: true)
    }
    
    private func stopSound() {
        player?.stop()
    }
    
    @objc private func timedOut() {
        //        debugPrint("Timeout")
        stopSound()
        eventHandler.timeout()
    }
    
    // MARK: - IBActions
    @IBAction func didTapHeardButton(_ sender: UIButton) {
        debugPrint("Ouviu")
        eventHandler.userHeard()
    }
    
    @IBAction func didTapStart(_ button: UIButton) {
        eventHandler.startTest()
    }
    
    // MARK: - PlayerInterface
    func didStopPlaying(tone: PlayerTone) {
        DispatchQueue.main.async {
            debugPrint("Parando som (\(tone.Frequency), \(amplitude(fromTone: tone)), \(tone.Amplitude))")
            self.userHeardButton.isEnabled = false
            self.soundPlayingImageView.image = #imageLiteral(resourceName: "mute")
        }
    }
    
    func didStartPlaying(tone: PlayerTone) {
        DispatchQueue.main.async {
            self.userHeardButton.isEnabled = true
            
            self.currentFrequencyLabel.text = "Frequência: \(tone.Frequency)"
            self.currentAmplitudeLabel.text = "Amplitude: \(tone.Amplitude)"
            
            self.soundPlayingImageView.image = #imageLiteral(resourceName: "playing")
        }
    }
    
    func didOccurErrorInitializing(error: Error) {
        debugPrint(error)
    }
    
    // MARK: - TestInterface
    func didStartTest() {
        debugPrint("start test")
    }
    
    func didStopTest() {
        debugPrint("stop test")
        stopSound()
    }
    
    func didFinishTest(results: Results) {
        debugPrint("finish test")
        timer.invalidate()
        stopSound()
        
        let identifier = "ResultViewController"
        if let vc = storyboard?.instantiateViewController(withIdentifier: identifier) as? ResultViewController {
            vc.results = results
            navigationController?.pushViewController(vc, animated: true)
        } else {
            debugPrint("Nao achou a VC com id: \(identifier)")
        }
    }
    
    func play(step: ToneTestStep, withDuration duration: TimeInterval) {
        debugPrint("Iniciando som (\(step.frequency), \(amplitude(fromStep: step)), \(step.amplitude) com duration \(duration))")
        player?.play(amplitude: step.amplitude, frequency: step.frequency)
        createTimer(withTimerInterval: duration)
    }
    
}
