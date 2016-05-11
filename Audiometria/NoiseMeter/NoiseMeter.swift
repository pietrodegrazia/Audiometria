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
    private var currentPower: [Int:Float] = [:]
    private var peakPower: [Int:Float] = [:]
    private var measureTimer: NSTimer!
    private var recorder: AVAudioRecorder!
    private var channels = [Int]()
    
    // MARK: Public vars
    var isMeasuring:Bool {
        get {
            return recorder.recording
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
    @objc func startMeasureWithInterval(measureInterval: NSTimeInterval){
        guard self.recorder.record() else {
            self.delegate?.noiseMeter(self, didOccurrError: NoiseMeterError.ErrorToRecord)
            return
        }
        
        measureTimer = NSTimer.scheduledTimerWithTimeInterval(measureInterval, target: self, selector: #selector(measurePower), userInfo: nil, repeats: true)
    }
    
    @objc func stopMeasure() {
        recorder.stop()
        measureTimer.invalidate()
    }
    
    // MARK: Private methods
    private func signForNotications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(startMeasureWithInterval), name:UIApplicationWillResignActiveNotification, object: 0.1)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(stopMeasure), name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(routeChange), name:AVAudioSessionRouteChangeNotification, object: nil)
    }
    
    private func pauseMeasure() {
        recorder.pause()
        measureTimer.invalidate()
    }
    
    @objc private func routeChange(notification:NSNotification) {
        print("routeChange \(notification.userInfo)")
        
        if let userInfo = notification.userInfo {
            //print("userInfo \(userInfo)")
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                //print("reason \(reason)")
                switch AVAudioSessionRouteChangeReason(rawValue: reason)! {
                case AVAudioSessionRouteChangeReason.NewDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                    
                case AVAudioSessionRouteChangeReason.OldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                    
                case AVAudioSessionRouteChangeReason.CategoryChange:
                    print("CategoryChange")
                    
                case AVAudioSessionRouteChangeReason.Override:
                    print("Override")
                    
                case AVAudioSessionRouteChangeReason.WakeFromSleep:
                    print("WakeFromSleep")
                    
                case AVAudioSessionRouteChangeReason.Unknown:
                    print("Unknown")
                    
                case AVAudioSessionRouteChangeReason.NoSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                    
                case AVAudioSessionRouteChangeReason.RouteConfigurationChange:
                    print("RouteConfigurationChange")
                    
                }
            }
        }
    }
    
    private func checkHeadphones() {
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
    
    private func recordWithPermission(setup: Bool) {
        AVAudioSession.sharedInstance().requestRecordPermission { (granted: Bool) -> Void in
            guard granted else {
                self.delegate?.noiseMeter(self, didOccurrError: NoiseMeterError.PermissionDenied)
                return
            }
            
            self.setSessionPlayAndRecord()
            if setup {
                self.setupRecorder()
            }
        }
    }
    
    private func setSessionPlayAndRecord() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.setActive(true)
        } catch let error as NSError {
            delegate?.noiseMeter(self, didOccurrError: error)
        }
        
    }
    
    private func setupRecorder() {
        do {
            let currentFileName = "recording-\(NSDate().toStringWithFormat("yyyyMMdd-HH-mm-ss")).m4a"
            let soundFilePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] + "/" + currentFileName
            let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
            let recordSettings: [String:AnyObject] = [
                AVFormatIDKey: Int(kAudioFormatAppleLossless),
                AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
                AVEncoderBitRateKey : 320000,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey : 44100.0
            ]
            
            recorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings )
            recorder.meteringEnabled = true
            
            if !recorder.prepareToRecord() {
                delegate?.noiseMeter(self, didOccurrError: NoiseMeterError.ErrorPreparingToRecord)
            }
        } catch let error as NSError {
            delegate?.noiseMeter(self, didOccurrError: NoiseMeterError.ErrorPreparingToRecord)
        }
    }
    
    @objc private func measurePower() {
        if recorder.recording {
            recorder.updateMeters()
            for channel in channels {
                let apc0 = recorder.averagePowerForChannel(0)
                let peak0 = recorder.peakPowerForChannel(0)
                
                
                
                peakPower[channel] = max(peakPower[channel] ?? FLT_MIN, peak0)
                currentPower[channel] = decibelsForPower(apc0)
                
                delegate?.noiseMeter(self, didMeasurePower: currentPower[channel]!, forChannel: channel)
            }
        }
    }
    
    private func decibelsForPower(averagePowerForChannel:Float) -> Float {
        let referenceLevel:Float = 5.0
        let range:Float = 160.0
        let offset:Float = 0
        
        let spl = 20 * log10(referenceLevel * powf(10.0, (averagePowerForChannel/20)) * range) + offset
        return spl
    }
    
}

// MARK: - NoiseMeterError
enum NoiseMeterError: ErrorType {
    case PermissionDenied
    case ErrorPreparingToRecord
    case ErrorToRecord
}

// MARK: - NoiseMeterDelegate
protocol NoiseMeterDelegate:class {
    
    func noiseMeter(noiseMeter:NoiseMeter, didMeasurePower power: Float, forChannel channel: Int)
    func noiseMeter(noiseMeter:NoiseMeter, didOccurrError error: ErrorType)
    
}