//
//  AllResultsViewController.swift
//  Audiometria
//
//  Created by Marcus Vinicius Kuquert on 04/04/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class AllResultsViewController: UIViewController, SimpleEmailComposer {
    
    @IBOutlet weak var tableView: UITableView!
    
    var patients = [Patient]()
    
    private lazy var shareBarButtonItem: UIBarButtonItem = { () -> UIBarButtonItem in
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action,
                                     target: self,
                                     action: #selector(shareButtonAction))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = shareBarButtonItem
        
        
        retrivePatientsFromRealm()
        tableView.reloadData()
        
    }
    
    private func retrivePatientsFromRealm() {
        do {
            patients = try Array(Realm().objects(Patient.self))
            patients.sort { $0.0.timestamp > $0.1.timestamp }
        } catch let error {
            print(error)
        }
    }
    
    @objc private func shareButtonAction() {
        let data = try! Exporter.exportPatients(patients)
        sendEmailWithData(data, fileName: "allPatients.csv")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.ShowResult.rawValue,
            let patient = sender as? Patient,
            let vc = segue.destination as? ResultViewController {
            vc.patient = patient
            
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
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY - HH:mm:ss"
        
        cell.textLabel?.text = patient.reabableId() + " (" + dateFormatter.string(from: patient.timestamp) + ")"
        cell.textLabel?.font = boldFont
        
        cell.textLabel?.textColor = UIColor(red: 0x99/255,
                                            green: 0x99/255,
                                            blue: 0x9A/255,
                                            alpha: 1.0)
        return cell
    }
}

extension AllResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patient = patients[indexPath.row]
        performSegue(withIdentifier: Segue.ShowResult.rawValue, sender: patient)
    }
    
}

extension AllResultsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            print("Error: \(String(describing: error))")
        }
        dismiss(animated: true)
    }
}
