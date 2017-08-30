//
//  TonePlayer.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 06/04/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation
import AVFoundation

public typealias PlayerTone = (frequency: Double, amplitude: Double)

protocol PlayerInterface: class {
    func didStartPlaying(tone: PlayerTone)
    func didStopPlaying(tone: PlayerTone)
    func didOccurErrorInitializing(error: Error)
}

class TonePlayer {
    
    weak var interface: PlayerInterface?
    
    private var tone = AVTonePlayerUnit()
    private var engine = AVAudioEngine()
    private var firstToneTestStep: ToneTestStep?
    
    init() { setupAudio() }
    
    private func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
            let mixer = engine.mainMixerNode
            
            engine.attach(tone)
            engine.connect(tone, to: mixer, format: format)
            try engine.start()
        } catch let error {
            interface?.didOccurErrorInitializing(error: error)
        }
    }
    
    func play(amplitude: Double, frequency: Double) {
        tone.amplitude = amplitude
        tone.frequency = frequency
        tone.preparePlaying()
        tone.play()
        
        engine.mainMixerNode.volume = 1.0
        
        let playerTone = PlayerTone(amplitude: tone.amplitude, frequency: tone.frequency)
        interface?.didStartPlaying(tone: playerTone)
    }
    
    func stop() {
        tone.stop()
        engine.mainMixerNode.volume = 0.0
        
        let playerTone = PlayerTone(amplitude: tone.amplitude, frequency: tone.frequency)
        interface?.didStopPlaying(tone: playerTone)
    }
}
