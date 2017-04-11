//
//  TonePlayer.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 06/04/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlayerInterface: class {
    func didStartPlaying(tone: PlayerTone)
    func didStopPlaying(tone: PlayerTone)
    func didOccurErrorInitializing(error: Error)
}

public typealias PlayerTone = (Frequency: Double, Amplitude: Double)

class TonePlayer {
    private var engine = AVAudioEngine()
    private var firstToneTestStep: ToneTestStep?
    private var tone = AVTonePlayerUnit()
    
    weak var interface: PlayerInterface?
    
    init?() {
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
        DispatchQueue.main.async {
            self.tone.amplitude = amplitude
            self.tone.frequency = frequency
            
            self.tone.preparePlaying()
            self.tone.play()
            self.engine.mainMixerNode.volume = 1.0
            
            let playerTone = PlayerTone(Amplitude: self.tone.amplitude, Frequency: self.tone.frequency)
            self.interface?.didStartPlaying(tone: playerTone)
        }
    }
    
    func stop() {
        DispatchQueue.main.async {
            self.tone.stop()
            self.engine.mainMixerNode.volume = 0.0
            
            let playerTone = PlayerTone(Amplitude: self.tone.amplitude, Frequency: self.tone.frequency)
            self.interface?.didStopPlaying(tone: playerTone)
        }
    }
}
