//
//  ToneTestViewController.swift
//  Audiometria
//
//  Created by Pietro Degrazia on 4/28/16.
//  Copyright © 2016 darkshine. All rights reserved.
//
import AVFoundation
import UIKit

class ToneTestViewController: UIViewController {
    
    @IBOutlet weak var soundPlayingIcon: UIImageView!
    @IBOutlet weak var currentFrequencyLabel: UILabel!
    @IBOutlet weak var currentAmplitudeLabel: UILabel!
    @IBOutlet weak var userHeardButton: UIButton!
    
    // MARK: Private constants
    private let InitialFrequencyIndex = 0
    private let InitialAmplitudeIndex = 1
    private let IntervalBetweenFrequencies:NSTimeInterval = 2.0
    private let IntervalBetweenAmplitudes:NSTimeInterval = 4.0
    
//    private let db = 20 * log10(v_noise * v_ref) + db_ref
    
    private var currentStepIndex = 0
    private let frequencies = [1000.0, 2000, 4000, 8000, 500]
    private let amplitudes = [20.0, 40, 60]
    
    // MARK: Private vars
    private var engine = AVAudioEngine()
    private var tone = AVTonePlayerUnit()
    private var timer = NSTimer()
    private var testStarted = false
    
    private var currentAmplitudeIndex: Int = 0 {
        didSet {
            createTimerWithTimerInterval(IntervalBetweenAmplitudes)
            
            let amplitude = amplitudes[currentAmplitudeIndex]
            currentAmplitudeLabel.text = String(amplitude)
            tone.amplitude = amplitude/100
            if testStarted {
                playSound()
            }
        }
    }
    
    private var currentFrequencyIndex: Int = 0 {
        didSet {
            createTimerWithTimerInterval(IntervalBetweenFrequencies)
            
            currentAmplitudeIndex = InitialAmplitudeIndex
            
            let frequency = frequencies[currentFrequencyIndex]
            currentFrequencyLabel.text = String(frequency)
            tone.frequency = frequency
            if testStarted {
                playSound()
            }
        }
    }
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    // MARK: Private helpers
    private func setupAudio(){
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        let mixer = engine.mainMixerNode
        
        engine.attachNode(tone)
        engine.connect(tone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func setInitialIndexes() {
        currentFrequencyIndex = InitialFrequencyIndex
        currentAmplitudeIndex = InitialAmplitudeIndex
    }
    
    private func startTest() {
        setInitialIndexes()
        testStarted = true
        playSound()
    }
    
    private func playSound() {
        stopSound()
        
        print("playSound")
        tone.preparePlaying()
        tone.play()
        engine.mainMixerNode.volume = 1.0
    }
    
    private func stopSound() {
        print("stopSound")
        tone.stop()
        engine.mainMixerNode.volume = 0.0
    }
    
    private func createTimerWithTimerInterval(interval:NSTimeInterval) {
        print(#function)
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(timedOut), userInfo: nil, repeats: true)
    }
    
    @objc private func timedOut(sender: AnyObject){
        print("timedOut")
        if isLastAmplitudeForTest {
            if isLastFrequency {
                endTest()
            } else {
                currentFrequencyIndex += 1
            }
        } else {
            // amplitude == 40
            currentAmplitudeIndex += 1
        }
    }
    
    private func endTest() {
        print("endTest")
        timer.invalidate()
        stopSound()
    }
    
    private var isLastAmplitudeForTest: Bool {
        get {
            return [0, amplitudes.count-1].contains(currentAmplitudeIndex)
        }
    }
    
    private var isLastFrequency: Bool {
        get {
            return currentFrequencyIndex == frequencies.count-1
        }
    }
    
    // MARK: IBActions
    @IBAction func userHeardButtonTapped(sender: UIButton) {
        if isLastAmplitudeForTest {
            if isLastFrequency {
                // finish test
                endTest()
            } else {
                currentAmplitudeIndex = InitialAmplitudeIndex
            }
        } else {
            currentAmplitudeIndex -= 1
        }
    }
    
    @IBAction func startProcedure(button: UIButton) {
//        button.enabled = false
        startTest()
    }
    
    
}


//func ==(lhs:ToneTestStep, rhs:ToneTestStep) -> Bool {
//    return lhs.frequency == rhs.frequency && lhs.amplitude == rhs.amplitude
//}
//
//struct FrequencyStep {
//
//}
//
//struct ToneTestStep {
//    var frequency: Double
//    var amplitude: [Double]
//    private var currentAmplitudeIndex = -1
//
//    init(frequency: Double, amplitudes: [Double], initialAmplitude: Double) {
//        self.frequency = frequency
//        self.amplitude = amplitudes
//
//        for (index, amplitude) in amplitudes.enumerate() {
//            if amplitude == initialAmplitude {
//                currentAmplitudeIndex = index
//                break
//            }
//        }
//        assert(currentAmplitudeIndex == -1, "Initial amplitude not found on amplitudes list")
//    }
//
//    mutating func increaseAmplitude() {
//        currentAmplitudeIndex += 1
//    }
//
//    mutating func decreaseAmplitude() {
//        currentAmplitudeIndex -= 1
//    }
//
//    static func createTonesWithFrequency(frequency: Double, andAmplitudes amplitudes:[Double]) -> [ToneTestStep] {
//        var tones = [ToneTestStep]()
//        for amplitude in amplitudes {
//            tones += [ToneTestStep(frequency: frequency, amplitude: amplitude)]
//        }
//        return tones
//    }
//
//    static func createTonesWithAmplitude(amplitude: Double, andFrequencies frequencies:[Double]) -> [ToneTestStep] {
//        var tones = [ToneTestStep]()
//        for frequency in frequencies {
//            tones += [ToneTestStep(frequency: frequency, amplitude: amplitude)]
//        }
//        return tones
//    }
//}

