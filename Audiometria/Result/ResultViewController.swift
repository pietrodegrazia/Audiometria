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

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var result: TestResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return result.results.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.results[section].amplitudeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let amplitudeResult = result.results[indexPath.section].amplitudeResults[indexPath.row]
        if amplitudeResult.heard {
            cell.textLabel?.text = "Ouviu em: \(amplitudeResult.amplitude)"
            cell.backgroundColor = .green
        } else {
            cell.textLabel?.text = "Não ouviu em: \(amplitudeResult.amplitude)"
            cell.backgroundColor = .red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let frequency = result.results[section].frequency
        return ("Frequencia: \(frequency) Hz")
    }

}

