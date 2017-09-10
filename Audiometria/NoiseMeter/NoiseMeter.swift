//
//  NoiseMeter.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/10/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import AVFoundation
import UIKit


class SharedSession {
    static let recorder: AVAudioRecorder = {
        let currentFileName = "recording-\(Date().toStringWithFormat("yyyyMMdd-HH-mm-ss")).m4a"
        let soundFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + currentFileName
        let soundFileURL = URL(fileURLWithPath: soundFilePath)
        let recordSettings: [String:AnyObject] = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless) as AnyObject,
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue as AnyObject,
            AVEncoderBitRateKey : 320000 as AnyObject,
            AVNumberOfChannelsKey: 2 as AnyObject,
            AVSampleRateKey : 44100.0 as AnyObject
        ]
        
        return try! AVAudioRecorder(url: soundFileURL, settings: recordSettings)
    }()
    
    static let engine = AVAudioEngine()
    
    static let tonePlayerUnit = AVTonePlayerUnit()
}

class NoiseMeter {
    
    // MARK: Private vars
    fileprivate var currentPower = [Int:Float]()
    fileprivate var peakPower = [Int:Float]()
    fileprivate var measureTimer: Timer?
    fileprivate var recorder = SharedSession.recorder
    fileprivate var channels = [Int]()
    
    // MARK: Public vars
    var isMeasuring: Bool {
        return recorder.isRecording
    }
    
    weak var delegate: NoiseMeterDelegate?
    
    init(channels: [Int]) {
        self.channels = channels
        recordWithPermission(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Public methods
    @objc func startMeasureWithInterval(_ measureInterval: TimeInterval){
        guard recorder.record() else {
            delegate?.noiseMeter(self, didOccurrError: NoiseMeterError.errorToRecord)
            return
        }
        
        measureTimer = Timer.scheduledTimer(timeInterval: measureInterval, target: self, selector: #selector(measurePower), userInfo: nil, repeats: true)
    }
    
    @objc func stopMeasure() {
        recorder.stop()
        measureTimer?.invalidate()
    }
    
    // MARK: Private methods
    fileprivate func signForNotications() {
        NotificationCenter.default.addObserver(self, selector: #selector(startMeasureWithInterval),
                                               name: NSNotification.Name.UIApplicationWillResignActive,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopMeasure),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(routeChange),
                                               name: NSNotification.Name.AVAudioSessionRouteChange,
                                               object: nil)
    }
    
    fileprivate func pauseMeasure() {
        recorder.pause()
        measureTimer?.invalidate()
    }
    
    fileprivate func recordWithPermission(_ setup: Bool) {
        AVAudioSession.sharedInstance().requestRecordPermission { (granted: Bool) -> Void in
            guard granted else {
                self.delegate?.noiseMeter(self, didOccurrError: NoiseMeterError.permissionDenied)
                return
            }
            
            self.setSessionPlayAndRecord()
            if setup {
                self.setupRecorder()
            }
        }
    }
    
    fileprivate func setSessionPlayAndRecord() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(true)
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            delegate?.noiseMeter(self, didOccurrError: error)
        }
    }
    
    fileprivate func setupRecorder() {
        
        
        
        recorder.isMeteringEnabled = true
        
        if !recorder.prepareToRecord() {
            delegate?.noiseMeter(self, didOccurrError: NoiseMeterError.errorPreparingToRecord)
        }
    }
    
    @objc fileprivate func measurePower() {
        if recorder.isRecording {
            recorder.updateMeters()
            for channel in channels {
                let apc0 = recorder.averagePower(forChannel: 0)
                let peak0 = recorder.peakPower(forChannel: 0)
                
                peakPower[channel] = max(peakPower[channel] ?? Float.leastNormalMagnitude, peak0)
                currentPower[channel] = apc0
                
                delegate?.noiseMeter(self, didMeasurePower: currentPower[channel]!, forChannel: channel)
            }
        }
    }
    
}

// MARK: - NoiseMeterError
enum NoiseMeterError: Error {
    case permissionDenied
    case errorPreparingToRecord
    case errorToRecord
    case errorCreatingRecorder(Error)
    case errorDeactivatingSession(Error)
}

// MARK: - NoiseMeterDelegate
protocol NoiseMeterDelegate: class {
    func noiseMeter(_ noiseMeter:NoiseMeter, didMeasurePower power: Float, forChannel channel: Int)
    func noiseMeter(_ noiseMeter:NoiseMeter, didOccurrError error: Error)
}

extension NoiseMeter {
    
    @objc fileprivate func routeChange(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            debugPrint("userInfo \(userInfo)")
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                debugPrint("reason \(reason)")
                switch AVAudioSessionRouteChangeReason(rawValue: reason)! {
                case .newDeviceAvailable:
                    debugPrint("NewDeviceAvailable")
                    debugPrint("did you plug in headphones?")
                    checkHeadphones()
                    
                case .oldDeviceUnavailable:
                    debugPrint("OldDeviceUnavailable")
                    debugPrint("did you unplug headphones?")
                    checkHeadphones()
                    
                case .categoryChange:
                    debugPrint("CategoryChange")
                    
                case .override:
                    debugPrint("Override")
                    
                case .wakeFromSleep:
                    debugPrint("WakeFromSleep")
                    
                case .unknown:
                    debugPrint("Unknown")
                    
                case .noSuitableRouteForCategory:
                    debugPrint("NoSuitableRouteForCategory")
                    
                case .routeConfigurationChange:
                    debugPrint("RouteConfigurationChange")
                    
                }
            }
        }
    }
    
    fileprivate func checkHeadphones() {
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    debugPrint("headphones are plugged in")
                    break
                } else {
                    debugPrint("headphones are unplugged")
                }
            }
        } else {
            debugPrint("checking headphones requires a connection to a device")
        }
    }
    
}
