//
//  NoiseMeter.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/10/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import AVFoundation
import UIKit

class NoiseMeter {
    
    // MARK: Private vars
    fileprivate var currentPower: [Int:Float] = [:]
    fileprivate var peakPower: [Int:Float] = [:]
    fileprivate var measureTimer: Timer?
    fileprivate var recorder: AVAudioRecorder!
    fileprivate var channels = [Int]()
    
    // MARK: Public vars
    var isMeasuring: Bool {
        get {
            return recorder.isRecording
        }
    }
    weak var delegate: NoiseMeterDelegate?
    
    init(channels:[Int]) {
        self.channels = channels
        recordWithPermission(true)
//        signForNotications()
    }
    
    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        do {
            recorder.stop()
            measureTimer?.invalidate()
            try AVAudioSession.sharedInstance().setActive(false)
        } catch let error {
            delegate?.noiseMeter(self, didOccurrError: NoiseMeterError.errorDeactivatingSession(error))
        }
    }
    
    // MARK: Private methods
    fileprivate func signForNotications() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(startMeasureWithInterval), name: AVAudioEngineConfigurationChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startMeasureWithInterval), name:NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopMeasure), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(routeChange), name:NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    fileprivate func pauseMeasure() {
        do {
            recorder.pause()
            measureTimer?.invalidate()
            try AVAudioSession.sharedInstance().setActive(false)
        } catch let error {
            delegate?.noiseMeter(self, didOccurrError: NoiseMeterError.errorDeactivatingSession(error))
        }
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
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.setActive(true)
        } catch let error as NSError {
            delegate?.noiseMeter(self, didOccurrError: error)
        }
        
    }
    
    fileprivate func setupRecorder() {
        do {
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
            
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.isMeteringEnabled = true
            
            if !recorder.prepareToRecord() {
                delegate?.noiseMeter(self, didOccurrError: NoiseMeterError.errorPreparingToRecord)
            }
        } catch let error as NSError {
            delegate?.noiseMeter(self, didOccurrError: NoiseMeterError.errorCreatingRecorder(error))
        }
    }
    
    @objc fileprivate func measurePower() {
        if recorder.isRecording {
            recorder.updateMeters()
            for channel in channels {
                let apc0 = recorder.averagePower(forChannel: 0)
                let peak0 = recorder.peakPower(forChannel: 0)
                
                peakPower[channel] = max(peakPower[channel] ?? FLT_MIN, peak0)
                currentPower[channel] = decibelsForPower(apc0)
                
                delegate?.noiseMeter(self, didMeasurePower: currentPower[channel]!, forChannel: channel)
            }
        }
    }
    
    fileprivate func decibelsForPower(_ power: Float) -> Float {
        return power
        
//        let referenceLevel:Float = 5.0
//        let range:Float = 160.0
//        let offset:Float = 0
//        
//        let spl = 20 * log10(referenceLevel * powf(10.0, (power/20)) * range) + offset
//        return spl
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
        print("routeChange \((notification as NSNotification).userInfo)")
        
        if let userInfo = (notification as NSNotification).userInfo {
            //print("userInfo \(userInfo)")
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                //print("reason \(reason)")
                switch AVAudioSessionRouteChangeReason(rawValue: reason)! {
                case AVAudioSessionRouteChangeReason.newDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                    
                case AVAudioSessionRouteChangeReason.oldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                    
                case AVAudioSessionRouteChangeReason.categoryChange:
                    print("CategoryChange")
                    
                case AVAudioSessionRouteChangeReason.override:
                    print("Override")
                    
                case AVAudioSessionRouteChangeReason.wakeFromSleep:
                    print("WakeFromSleep")
                    
                case AVAudioSessionRouteChangeReason.unknown:
                    print("Unknown")
                    
                case AVAudioSessionRouteChangeReason.noSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                    
                case AVAudioSessionRouteChangeReason.routeConfigurationChange:
                    print("RouteConfigurationChange")
                    
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
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        } else {
            print("checking headphones requires a connection to a device")
        }
    }
    
}
