////
////  ToneTest.swift
////  Audiometria
////
////  Created by Henrique Valcanaia on 4/29/16.
////  Copyright © 2016 darkshine. All rights reserved.
////
//
//import AVFoundation
//import Foundation
//
//class ToneTest {
//    
//    // MARK: Private vars
//    private var engine = AVAudioEngine()
//    private var tone = AVTonePlayerUnit()
//    private var timer: NSTimer?
//    
//    private let InitialFrequencyIndex = 0
//    private let InitialAmplitudeIndex = 1
//    
//    private let IntervalBetweenFrequencies:NSTimeInterval = 4.0
//    private let IntervalBetweenAmplitudes:NSTimeInterval = 2.0
//    private let Frequencies = [1000.0, 2000.0, 4000.0, 8000.0, 500.0]
//    private let Amplitudes = [20.0, 40.0, 60.0]
//    
//    private var frequencyIndex = 0
//    private var amplitudeIndex = 1
//    
//    private var lastFrequency:Double
//    private var lastAmplitude:Double
//    
//    weak var delegate:ToneTestDelegate?
//    
//    init() {
//        setupAudio()
//    }
//    
//    func startTest() {
//        createTimerWithTimerInterval(IntervalBetweenFrequencies)
//    }
//    
//    func finishTest() {
//        timer!.invalidate()
//        timer = nil
//    }
//    
//    // MARK: Private helpers
//    private func createTimerWithTimerInterval(interval:NSTimeInterval) {
//        if timer != nil {
//            timer!.invalidate()
//        }
//        
//        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(triggerTimer), userInfo: nil, repeats: true)
//    }
//    
//    private func setupAudio(){
//        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
//        let mixer = engine.mainMixerNode
//        
//        engine.attachNode(tone)
//        engine.connect(tone, to: mixer, format: format)
//        do {
//            try engine.start()
//        } catch let error as NSError {
//            print(error)
//        }
//    }
//    
//    private func playSound() {
//        print("playSound")
//        tone.preparePlaying()
//        tone.play()
//        engine.mainMixerNode.volume = 1.0
//    }
//    
//    private func stopSound() {
//        print("stopSound")
//        tone.stop()
//        engine.mainMixerNode.volume = 0.0
//    }
//    
//    @objc private func triggerTimer() {
//        let currentState = TestState(Frequency: Frequencies[frequencyIndex], Amplitude: Amplitudes[amplitudeIndex])
//        let reason:TestFinishReason
//        // Last test
//        if frequencyIndex == Frequencies.count-1 {
//            reason = .Finished
//        }
//        
//        if amplitudeIndex == InitialAmplitudeIndex {
//            reason = .TimedOut
//        }
//        
//        delegate?.toneTest(delegate!, didFinishWithReason: reason, andState: currentState)
//    }
//    
//}
//
//func ==(lhs:Tone, rhs:Tone) -> Bool {
//    return lhs.frequency == rhs.frequency && lhs.amplitude == rhs.amplitude
//}
//
//struct Tone {
//    var frequency: Double
//    var amplitude: Double
//    
//    static func createTonesWithFrequency(frequency: Double, andAmplitudes amplitudes:[Double]) -> [Tone] {
//        var tones = [Tone]()
//        for amplitude in amplitudes {
//            tones += [Tone(frequency: frequency, amplitude: amplitude)]
//        }
//        return tones
//    }
//    
//    static func createTonesWithAmplitude(amplitude: Double, andFrequencies frequencies:[Double]) -> [Tone] {
//        var tones = [Tone]()
//        for frequency in frequencies {
//            tones += [Tone(frequency: frequency, amplitude: amplitude)]
//        }
//        return tones
//    }
//}
//
//typealias TestState = (Frequency: Double, Amplitude: Double)
//enum TestFinishReason {
//    case UserHeard
//    case TimedOut
//    case Finished
//}
//
//
////extension ToneTest: ToneTestDelegate {
////    
////    func toneTest(toneTest: ToneTestDelegate, didFinishWithReason reason:TestFinishReason, andState state:TestState) {
////        switch reason {
////        case .TimedOut:
////            print("timedout")
////            toneTest.toneTest(toneTest, timedOutWithState: state)
////            
////        case .UserHeard:
////            print("user heard")
////            toneTest.toneTest(toneTest, userHeadWithState: state)
////            
////        case .Finished:
////            print("finished")
////            
////        }
////    }
////    
////    func timeIntervalBetweenAmplitudes() -> Double {
////        return IntervalBetweenAmplitudes
////    }
////    
////    func timeIntervalBetweenFrequencies() -> Double {
////        return IntervalBetweenFrequencies
////    }
////    
////    func toneTest(toneTest: ToneTestDelegate, timedOutWithState state:TestState) {
////        if [20, 60].contains(state.Amplitude) {
////            toneTest.toneTest(toneTest, startNextState: TestState(Frequency: state.Frequency, Amplitude: 1.0))
////        }
////    }
////    
////    func toneTest(toneTest:ToneTest, userHeardWithState state:TestState) {
////        // toca proxima frequencia
////        frequencyIndex += 1
////        
////    }
////    
////    func toneTest(toneTest: ToneTest, startState: TestState) {
////        
////    }
////    
////}
////
////protocol ToneTestDelegate: class {
////    
////    func timeIntervalBetweenFrequencies() -> Double
////    func timeIntervalBetweenAmplitudes() -> Double
////    func toneTest(toneTest:ToneTestDelegate, didFinishWithReason:TestFinishReason, andState:TestState)
////    func toneTest(toneTest:ToneTestDelegate, userHeardWithState:TestState)
////    func toneTest(toneTest:ToneTestDelegate, startState:TestState)
////    
////}