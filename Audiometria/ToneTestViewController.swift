//
//  ToneTestViewController.swift
//  Audiometria
//
//  Created by Pietro Degrazia on 4/28/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import AVFoundation
import UIKit

enum Segue: String {
    
    case ShowResult
    
}

class ToneTestStep {
    
    var frequency: Double
    var amplitude: Double
    var heardTest: ToneTestStep?
    var notHeardTest: ToneTestStep?
    var heard = false
    
    init(frequency: Double, amplitude: Double, heardTest: ToneTestStep?, notHeardTest: ToneTestStep?) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.heardTest = heardTest
        self.notHeardTest = notHeardTest
    }
    
    var description:String {
        return "ToneTestStep { frequency: \(frequency), amplitude: \(amplitude) }"
    }
    
    
}

typealias Tone = (Frequency:Double, Amplitude:Double)

class ToneTestViewController: UIViewController {
    
    @IBOutlet weak var currentAmplitudeLabel: UILabel!
    @IBOutlet weak var currentFrequencyLabel: UILabel!
    @IBOutlet weak var soundPlayingImageView: UIImageView!
    @IBOutlet weak var userHeardButton: UIButton!
    
    // MARK: Private constants
    private let frequencies = [1000.0, 2000.0, 4000.0, 8000.0, 500.0]
    private let intervalBetweenAmplitudes: NSTimeInterval = 2.0
    private let intervalBetweenFrequencies: NSTimeInterval = 1.0
    private let toneDuration: NSTimeInterval = 1.0
    
    // MARK: Private vars
    private var currentToneTestStep:ToneTestStep? {
        willSet(newValue) {
            print(newValue?.description)
            stopSound()
            if newValue == nil {
                endTest()
            } else {
                if newValue?.frequency != currentToneTestStep?.frequency {
                    delay(intervalBetweenFrequencies) {
                        Queue.Main.execute {
                            print("trocou frequencia")
                            self.playSound()
                        }
                    }
                } else if newValue?.amplitude != currentToneTestStep?.amplitude {
                    delay(intervalBetweenAmplitudes) {
                        Queue.Main.execute {
                            print("trocou amplitude")
                            self.playSound()
                        }
                    }
                } else {
                    print("outro caso")
                }
            }
        }
    }
    
    private var engine = AVAudioEngine()
    private var firstToneTestStep:ToneTestStep?
    private var heardTones = [Double:[Double]]()
    private var testStarted = false
    private var timer = NSTimer()
    private var tone = AVTonePlayerUnit()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        generateTree()
    }
    
    // MARK: Private helpers
    private func generateTree() {
        var lastToneTestStep:ToneTestStep?
        for (index, freq) in frequencies.enumerate() {
            let heardStep = ToneTestStep(frequency: freq, amplitude: 20.0, heardTest: nil, notHeardTest: nil)
            let notHeardStep = ToneTestStep(frequency: freq, amplitude: 60.0, heardTest: nil, notHeardTest: nil)
            let step = ToneTestStep(frequency: freq, amplitude: 40.0, heardTest: heardStep, notHeardTest: notHeardStep)
            
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
    }
    
    private func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
            let mixer = engine.mainMixerNode
            
            engine.attachNode(tone)
            engine.connect(tone, to: mixer, format: format)
            try engine.start()
        } catch let error as NSError {
            hvprint(error)
        }
    }
    
    private func startTest() {
        currentToneTestStep = firstToneTestStep
    }
    
    private func playSound() {
        userHeardButton.enabled = true
        
        self.currentFrequencyLabel.text = "Frequência: \(currentToneTestStep!.frequency)"
        self.currentAmplitudeLabel.text = "Amplitude: \(currentToneTestStep!.amplitude)"
        self.createTimerWithTimerInterval(self.toneDuration)
        
        tone.amplitude = currentToneTestStep!.amplitude/100
        tone.frequency = currentToneTestStep!.frequency
        
        tone.preparePlaying()
        tone.play()
        engine.mainMixerNode.volume = 1.0
        soundPlayingImageView.image = UIImage(named: "playing")
    }
    
    private func stopSound() {
        userHeardButton.enabled = false
        
        tone.stop()
        engine.mainMixerNode.volume = 0.0
        soundPlayingImageView.image = UIImage(named: "mute")
    }
    
    private func endTest() {
        timer.invalidate()
        stopSound()
        
        performSegueWithIdentifier(Segue.ShowResult.rawValue, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Segue.ShowResult.rawValue {
            if let vc = segue.destinationViewController as? ResultViewController {
                vc.results = heardTones
            }
        }
    }
    
    private func createTimerWithTimerInterval(interval: NSTimeInterval) {
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(timedOut), userInfo: nil, repeats: true)
    }
    
    @objc private func timedOut(){
        timer.invalidate()
        currentToneTestStep = currentToneTestStep!.notHeardTest
    }
    
    // MARK: IBActions
    @IBAction func userHeardButtonTapped(sender: UIButton) {
        timer.invalidate()
        let key = currentToneTestStep!.frequency
        let el = currentToneTestStep!.amplitude
        if case nil = heardTones[key]?.append(el) { heardTones[key] = [el] }
        currentToneTestStep = currentToneTestStep!.heardTest
    }
    
    @IBAction func startProcedure(button: UIButton) {
        startTest()
    }
    
    
}

public extension SequenceType {
    
    /// Categorises elements of self into a dictionary, with the keys given by keyFunc
    func categorise<U : Hashable>(@noescape keyFunc: Generator.Element -> U) -> [U:[Generator.Element]] {
        var dict: [U:[Generator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}