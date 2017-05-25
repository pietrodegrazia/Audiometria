//
//  AllResultsViewController.swift
//  Audiometria
//
//  Created by Marcus Vinicius Kuquert on 04/04/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import UIKit

class Patient {
    var id: String?
    var result: Results?
}

class AllResultsViewController: UIViewController {
    
    //The key is the patient ID
    var patients = [Patient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action,
                                                 target: self,
                                                 action: #selector(shareButtonAction))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func shareButtonAction() {
        //TODO: Implements export sheet, including e-mail export
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.ShowResult.rawValue,
            let results = sender as? Results,
            let vc = segue.destination as? ResultViewController {
            vc.results = results
        }
    }
}


extension AllResultsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath)
        let patient = patients[indexPath.row]
        cell.textLabel?.text = patient.id
        return cell
    }
}

extension AllResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patient = patients[indexPath.row]
        performSegue(withIdentifier: Segue.ShowResult.rawValue, sender: patient.result)
    }
    
}
