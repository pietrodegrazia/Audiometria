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
    
    
    var timer = NSTimer()
    
    let intervalBetweenFrequencies = 4
    let frequencies = [1000, 2000, 4000, 8000, 500]
    var currentFrequencyIndex = 0 {
        didSet {
            currentAmplitude = initialAmplitude
        }
    }
    
    var isPlaying = false {
        didSet (newValue) {
            if !newValue {
                print("stop sound")
                engine.mainMixerNode.volume = 0.0
                userHeardButton.enabled = false
                tone.stop()
                let image = UIImage(named: "mute")
                soundPlayingIcon.image = image
                
            } else {
                let image = UIImage(named: "playing")
                soundPlayingIcon.image = image
                userHeardButton.enabled = true
                print("start sound")
                let freq = frequencies[currentFrequencyIndex]
                print("freq: \(freq)")
                tone.frequency = Double(freq)
                currentFrequencyLabel.text = String(freq)
                if let resultForFreq = resultDictionary[freq] {
                    if resultForFreq != initialAmplitude {
                        currentFrequencyIndex += 1
                    } else {
                        currentAmplitude -= amplitudeDelta
                    }
                } else {
                    currentAmplitude += amplitudeDelta
                }
                
                print("amp: \(currentAmplitude)")
//                tone.play()
                tone.preparePlaying()
                tone.play()
                engine.mainMixerNode.volume = 1.0

            }
        }
    }
    
    var resultDictionary = [Int: Double]()
    let initialAmplitude = 0.40
    let amplitudeDelta = 0.20
    
    var currentAmplitude: Double = 0 {
        didSet {
            tone.amplitude = Double(currentAmplitude)
            currentAmplitudeLabel.text = String(currentAmplitude)
        }
    }
    
    
    @IBAction func userHeardButtonTapped(sender: UIButton) {
        let freq = frequencies[currentFrequencyIndex]
        resultDictionary[freq] = currentAmplitude
        print(resultDictionary)
    }
    
    var engine = AVAudioEngine()
    var tone = AVTonePlayerUnit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    @IBAction func startProcedure(button: UIButton) {
        button.enabled = false
        timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(timedOut), userInfo: nil, repeats: true)
    }
    
    func timedOut(sender: AnyObject){
        print("timedOut")
        isPlaying = !isPlaying
    }
    
    func setupAudio(){
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
}

