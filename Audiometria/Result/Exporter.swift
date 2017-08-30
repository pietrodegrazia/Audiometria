//
//  Exporter.swift
//  Audiometria
//
//  Created by Marcus Vinicius Kuquert on 28/08/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation
import CSV

enum ExporterError: Error {
    case nilPatientResuls
    case invalidDataObjectCasting
}

class Exporter {
    
    private static let headerRow = ["patient",
                                    "freq500_20db",
                                    "freq500_40db",
                                    "freq500_60db",
                                    
                                    "freq1000_20db",
                                    "freq1000_40db",
                                    "freq1000_60db",
                                    
                                    "freq2000_20db",
                                    "freq2000_40db",
                                    "freq2000_60db",
                                    
                                    "freq4000_20db",
                                    "freq4000_40db",
                                    "freq4000_60db",
                                    
                                    "freq8000_20db",
                                    "freq8000_40db",
                                    "freq8000_60db"]
    
    static func exportPatient(_ patient: Patient) throws -> Data {
        
        let stream = OutputStream(toMemory: ())
        let csv = try CSVWriter(stream: stream)
        
        try csv.write(row: headerRow)
        try csv.write(row: rowFromPatient(patient))
        
        csv.stream.close()
        
        if let csvData = stream.property(forKey: .dataWrittenToMemoryStreamKey) as? NSData {
            return Data(referencing: csvData)
        } else {
            throw ExporterError.invalidDataObjectCasting
        }
    }
    
    static func exportPatients(_ patients: [Patient]) throws -> Data{
        let stream = OutputStream(toMemory: ())
        let csv = try CSVWriter(stream: stream)
        
        // Write CSV Header
        try csv.write(row: headerRow)
        
        try patients.forEach {
            try csv.write(row: rowFromPatient($0))
        }
        
        csv.stream.close()
        
        if let csvData = stream.property(forKey: .dataWrittenToMemoryStreamKey) as? NSData {
            return Data(referencing: csvData)
        } else {
            throw ExporterError.invalidDataObjectCasting
        }
    }
    
    private static func rowFromPatient(_ patient: Patient) throws -> [String] {
        guard let resultsRealm = patient.results else { throw ExporterError.nilPatientResuls }
        
        let id = patient.id
        let freq500_20db = String(resultsRealm.freq500_20db)
        let freq500_40db = String(resultsRealm.freq500_40db)
        let freq500_60db = String(resultsRealm.freq500_60db)
        let freq1000_20db = String(resultsRealm.freq1000_20db)
        let freq1000_40db = String(resultsRealm.freq1000_40db)
        let freq1000_60db = String(resultsRealm.freq1000_60db)
        let freq2000_20db = String(resultsRealm.freq2000_20db)
        let freq2000_40db = String(resultsRealm.freq2000_40db)
        let freq2000_60db = String(resultsRealm.freq2000_60db)
        let freq4000_20db = String(resultsRealm.freq4000_20db)
        let freq4000_40db = String(resultsRealm.freq4000_40db)
        let freq4000_60db = String(resultsRealm.freq4000_60db)
        let freq8000_20db = String(resultsRealm.freq8000_20db)
        let freq8000_40db = String(resultsRealm.freq8000_40db)
        let freq8000_60db = String(resultsRealm.freq8000_60db)
        
        let r = [id,
                 freq500_20db,
                 freq500_40db,
                 freq500_60db,
                 freq1000_20db,
                 freq1000_40db,
                 freq1000_60db,
                 freq2000_20db,
                 freq2000_40db,
                 freq2000_60db,
                 freq4000_20db,
                 freq4000_40db,
                 freq4000_60db,
                 freq8000_20db,
                 freq8000_40db,
                 freq8000_60db]
        
        return r
    }
}
