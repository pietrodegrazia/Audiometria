//
//  MeterTableSwift.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/17/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import Foundation

//
//  MeterTableOC.m
//

class MaterTableSwift {
    
    fileprivate let inMinDecibels:Float = -80.0
    fileprivate let inTableSize:size_t = 400
    fileprivate let inRoot:Float = 2.0
    
    fileprivate var mMinDecibels:Float = 0.0
    fileprivate var mDecibelResolution:Float = 0.0
    fileprivate var mScaleFactor:Float = 0.0
    fileprivate var mTable = [Float]()
    
    init () {
        setupWithMinDb(inMinDecibels, tableSize: inTableSize, root: inRoot)
    }
    
    func initWithMinDb(_ minDb:Float) {
        setupWithMinDb(minDb, tableSize: inTableSize, root: inRoot)
    }
    
    func initWithMinDb(_ minDb:Float, tableSize aTableSize:size_t, root aRoot:Float) {
        setupWithMinDb(minDb, tableSize: aTableSize, root: aRoot)
    }
    
    func setupWithMinDb(_ minDb:Float, tableSize inTableSize:size_t, root aRoot:Float) {
        mMinDecibels = minDb
        mDecibelResolution = mMinDecibels / Float(inTableSize - 1)
        mScaleFactor = 1.0 / mDecibelResolution
        
        
        assert((inMinDecibels <= 0.0), "MeterTable inMinDecibels must be negative")
        
        let minAmp = ampForDb(inMinDecibels)
        let ampRange = 1.0 - minAmp;
        let invAmpRange = 1.0 / ampRange;
        
        let rroot = 1.0 / aRoot;
        for i in 0..<inTableSize {
            let decibels = Float(i) * mDecibelResolution
            let amp = ampForDb(decibels)
            let adjAmp = (amp - minAmp) * invAmpRange
            mTable += [pow(adjAmp, rroot)]
        }
    }
    
    func ampForDb(_ inDb:Float) -> Float {
        return pow(10.0, 0.05 * inDb)
    }
    
    func valueAt(_ inDecibels:Float) -> Float{
        if (inDecibels < mMinDecibels){
            return 0.0;
        }
        
        if (inDecibels >= 0.0) {
            return 1.0
        }
        
        let index = (inDecibels * mScaleFactor)
        if (index < Float(mTable.count)) {
            return mTable[Int(index)];
        }
        return 1.0;
        
    }
}
