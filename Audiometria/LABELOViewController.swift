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
    
    private var tone = AVTonePlayerUnit()
    private var engine = AVAudioEngine()
    
    private var isPlaying = false
    
    private var noiseMeter = NoiseMeter(channels: [0, 1])
    
    private struct AmplitudeConfig {
        static let min = 0.0
        static let max = 1.0
    }
    
    private struct FrequencyConfig {
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        slideAmplitude(emissionAmplitudeSlider)
        slideFrequency(emissionFrequencySlider)
    }
    
    @IBAction func slideAmplitude(sender: UISlider) {
        //        let mappedValue = map(sender.value, inMin: 0, inMax: 1, outMin: AmplitudeConfig.min, outMax: AmplitudeConfig.max)
        let mappedValue = Double(sender.value)
        emissionAmplitudeTextField.text = "\(mappedValue)"
        tone.amplitude = mappedValue
    }
    
    @IBAction func slideFrequency(sender: UISlider) {
        let mappedValue = map(sender.value, inMin: 0, inMax: 1, outMin: FrequencyConfig.min, outMax: FrequencyConfig.max)
        emissionFrequencyTextField.text = "\(mappedValue)"
        tone.frequency = mappedValue.doubleValue
    }
    
    @IBAction func play(sender: AnyObject) {
        if tone.playing {
            stopSound()
            playBtn.setTitle("Play", forState: UIControlState.Normal)
        } else {
            playSound()
            playBtn.setTitle("Stop", forState: UIControlState.Normal)
        }
    }
    
    private func playSound() {
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
    
    private func stopSound() {
        tone.stop()
        engine.mainMixerNode.volume = 0.0
    }
    
    
    private func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
            let mixer = engine.mainMixerNode
            
            engine.attachNode(tone)
            engine.connect(tone, to: mixer, format: format)
            try engine.start()
        } catch let error {
            hvprint(error)
        }
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}


extension LABELOViewController: NoiseMeterDelegate {
    func noiseMeter(noiseMeter: NoiseMeter, didOccurrError error: ErrorType) {
        hvprint(error)
    }
    
    func noiseMeter(noiseMeter: NoiseMeter, didMeasurePower power: Float, forChannel channel: Int) {
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