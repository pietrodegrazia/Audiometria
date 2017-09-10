//
//  ViewController.swift
//  Audiometria
//
//  Created by Marcus Vinicius Kuquert on 22/04/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import AVFoundation
import UIKit

class LABELOViewController: UITableViewController {
    
    @IBOutlet weak var emissionAmplitudeTextField: UITextField!
    @IBOutlet weak var emissionAmplitudeSlider: UISlider!
    
    @IBOutlet weak var emissionFrequencyTextField: UITextField!
    @IBOutlet weak var emissionFrequencySlider: UISlider!
    
    @IBOutlet weak var captationAmplitudeLabelCh0: UILabel!
    @IBOutlet weak var captationAmplitudeLabelCh1: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    fileprivate var tone = SharedSession.tonePlayerUnit
    fileprivate var engine = SharedSession.engine
    
    fileprivate var isPlaying = false
    
    fileprivate var noiseMeter = NoiseMeter(channels: [0, 1])
    
    fileprivate struct AmplitudeConfig {
        static let min = 0.0
        static let max = 1.0
    }
    
    fileprivate struct FrequencyConfig {
        static let min = 0.0
        static let max = 8000.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        
        noiseMeter.delegate = self
        noiseMeter.startMeasureWithInterval(0.001)
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slideAmplitude(emissionAmplitudeSlider)
        slideFrequency(emissionFrequencySlider)
    }
    
    @IBAction func slideAmplitude(_ sender: UISlider) {
        //        let mappedValue = map(sender.value, inMin: 0, inMax: 1, outMin: AmplitudeConfig.min, outMax: AmplitudeConfig.max)
        let mappedValue = Double(sender.value)
        emissionAmplitudeTextField.text = "\(mappedValue)"
        tone.amplitude = mappedValue
    }
    
    @IBAction func slideFrequency(_ sender: UISlider) {
        let mappedValue = map(x: NSNumber(value: sender.value),
                              inMin: NSNumber(value: 0),
                              inMax: NSNumber(value: 1),
                              outMin: NSNumber(value: FrequencyConfig.min),
                              outMax: NSNumber(value: FrequencyConfig.max))
        
        print(mappedValue)
        emissionFrequencyTextField.text = "\(mappedValue)"
        tone.frequency = mappedValue.doubleValue
    }
    
    @IBAction func play(_ sender: AnyObject) {
        if tone.isPlaying {
            stopSound()
            playBtn.setTitle("Play", for: UIControlState())
        } else {
            playSound()
            playBtn.setTitle("Stop", for: UIControlState())
        }
    }
    
    fileprivate func playSound() {
        guard let amplitudeString = emissionAmplitudeTextField.text else {
            hvprint("Informe a amplitude")
            emissionAmplitudeTextField.becomeFirstResponder()
            return
        }
        
        guard let amplitude = Double(amplitudeString) else {
            hvprint("Erro ao converter amplitude")
            return
        }
        
        guard let frequencyString = emissionFrequencyTextField.text else {
            hvprint("Informe a frequencia")
            emissionFrequencyTextField.becomeFirstResponder()
            return
        }
        
        guard let frequency = Double(frequencyString) else {
            hvprint("Erro ao converter frequencia")
            return
        }
        
        tone.amplitude = amplitude
        tone.frequency = frequency
        
        tone.preparePlaying()
        tone.play()
        engine.mainMixerNode.volume = 1.0
    }
    
    fileprivate func stopSound() {
        tone.stop()
        engine.mainMixerNode.volume = 0.0
    }
    
    fileprivate func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
            let mixer = engine.mainMixerNode
            
            engine.attach(tone)
            engine.connect(tone, to: mixer, format: format)
            try engine.start()
        } catch let error {
            hvprint(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension LABELOViewController: NoiseMeterDelegate {
    func noiseMeter(_ noiseMeter: NoiseMeter, didOccurrError error: Error) {
        hvprint(error)
    }
    
    func noiseMeter(_ noiseMeter: NoiseMeter, didMeasurePower power: Float, forChannel channel: Int) {
        switch channel {
        case 0:
            captationAmplitudeLabelCh0.text = "\(power)"
        
        case 1:
            captationAmplitudeLabelCh1.text = "\(power)"
        
        default:
            hvprint("Canal \(channel) desconhecido! Valor: \(power)")
        }
    }
}
