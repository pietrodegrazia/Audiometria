//
//  ResultViewController.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/23/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import UIKit

struct AmplitudeResult {
    var amplitude: Double
    var heard: Bool
}

struct FrequencyResult {
    var frequency: Double
    var amplitudeResults: [AmplitudeResult]
}

struct TestResult {
    var results: [FrequencyResult]
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var result:TestResult
    
    struct Objects {
        
        var sectionName : Double!
        var sectionObjects : [Double]!
    }
    
    fileprivate var objectArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for (key, value) in results {
            print("\(key) -> \(value)")
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        
        cell.textLabel?.text = "Ouviu em: \(objectArray[sectionIndex].sectionObjects[rowIndex])"
        cell.backgroundColor = .green
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionName = objectArray[section].sectionName {
            return ("Frequencia: \(sectionName) Hz")
        } else{
            return "unknown"
        }
    }
    
}
