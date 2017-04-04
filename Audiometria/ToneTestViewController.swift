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

enum ResultEnum: Int {
    case notHeard, heared, notTested, outOfRange
}

typealias ResultTuple = (amplitude: Double, result: ResultEnum)
typealias FrequencyAmplitude = (frequency: Double, amplitude20: Double, amplitude40: Double, amplitude60: Double)

struct Contants {
    let a = ["a":"b", "c":"d"]
    
    
    
    static let iPod_touch: [FrequencyAmplitude] = [(1000, -1,  0.008, 0.1),
                                                  (2000, -1,  0.019, 0.02),
                                                  (4000, -1,  0.035, 0.023),
                                                  (8000, -1,  0.0028, 0.025),
                                                  (500,  -1,       1, -1)]
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
    fileprivate let frequencies: [FrequencyAmplitude] = Contants.iPod_touch
    fileprivate let intervalBetweenAmplitudes: TimeInterval = 2.0
    fileprivate let intervalBetweenFrequencies: TimeInterval = 1.0
    fileprivate let toneDuration: TimeInterval = 7.0
    
    // MARK: Private vars
    fileprivate var currentToneTestStep: ToneTestStep? {
        willSet(newValue) {
            navigationItem.backBarButtonItem?.isEnabled = false
            stopSound()
            if newValue == nil {
                endTest()
            } else {
                if newValue?.frequency != currentToneTestStep?.frequency {
                    delay(intervalBetweenFrequencies) {
                        Queue.main.execute {
                            print("trocou frequencia")
                            self.playSound()
                        }
                    }
                } else if newValue?.amplitude != currentToneTestStep?.amplitude {
                    delay(intervalBetweenAmplitudes) {
                        Queue.main.execute {
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
    
    fileprivate var engine = AVAudioEngine()
    fileprivate var firstToneTestStep:ToneTestStep?
    // The key is the frequency, the value is the array of ResultTuples.
    
    fileprivate var allTones = [Double:[ResultTuple]]()
    fileprivate var testStarted = false
    fileprivate var timer = Timer()
    fileprivate var tone = AVTonePlayerUnit()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        generateTree()
        populateAllTonesDictionary()
    }
    
    // MARK: Private helpers
    fileprivate func generateTree() {
        //Remove -1 frequencies from tree
        var lastToneTestStep:ToneTestStep?
        for (index, freq) in frequencies.enumerated() {
            let heardStep = ToneTestStep(frequency: freq.frequency, amplitude: freq.amplitude20, heardTest: nil, notHeardTest: nil)
            let notHeardStep = ToneTestStep(frequency: freq.frequency, amplitude: freq.amplitude60, heardTest: nil, notHeardTest: nil)
            let step = ToneTestStep(frequency: freq.frequency, amplitude: freq.amplitude40, heardTest: heardStep, notHeardTest: notHeardStep)
            
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
    
    func populateAllTonesDictionary() {
        for freq in frequencies {
            
            let resultTupleArray = [ResultTuple(freq.amplitude20, freq.amplitude20 == -1.0 ? .outOfRange : .notTested),
                                    ResultTuple(freq.amplitude40, freq.amplitude40 == -1.0 ? .outOfRange : .notTested),
                                    ResultTuple(freq.amplitude60, freq.amplitude60 == -1.0 ? .outOfRange : .notTested)]
            
            allTones[freq.frequency] = resultTupleArray
        }
    }
    
    fileprivate func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
            let mixer = engine.mainMixerNode
            
            engine.attach(tone)
            engine.connect(tone, to: mixer, format: format)
            try engine.start()
        } catch let error as NSError {
            hvprint(error)
        }
    }
    
    fileprivate func startTest() {
        currentToneTestStep = firstToneTestStep
    }
    
    fileprivate func playSound() {
        userHeardButton.isEnabled = true
        
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
    
    fileprivate func stopSound() {
        userHeardButton.isEnabled = false
        
        tone.stop()
        engine.mainMixerNode.volume = 0.0
        soundPlayingImageView.image = UIImage(named: "mute")
    }
    
    fileprivate func endTest() {
        timer.invalidate()
        stopSound()
        
        performSegue(withIdentifier: Segue.ShowResult.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.ShowResult.rawValue {
            if let vc = segue.destination as? ResultViewController {
                vc.results = allTones
            }
        }
    }
    
    fileprivate func createTimerWithTimerInterval(_ interval: TimeInterval) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timedOut), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func timedOut(){
        timer.invalidate()
        currentToneTestStep = currentToneTestStep!.notHeardTest
        let key = currentToneTestStep!.frequency
        let el = currentToneTestStep!.amplitude
        let result = ResultTuple(el, .notHeard)
        allTones[key]?.append(result)
    }
    
    // MARK: IBActions
    @IBAction func userHeardButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        let key = currentToneTestStep!.frequency
        let el = currentToneTestStep!.amplitude
        let result = ResultTuple(el, .heared)
        allTones[key]?.append(result)
        currentToneTestStep = currentToneTestStep!.heardTest
    }
    
    @IBAction func startProcedure(_ button: UIButton) {
        startTest()
    }
}

public extension Sequence {
    
    /// Categorises elements of self into a dictionary, with the keys given by keyFunc
    func categorise<U : Hashable>(_ keyFunc: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}
