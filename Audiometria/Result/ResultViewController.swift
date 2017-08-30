//
//  ResultViewController.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/23/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import UIKit
import MessageUI
import RealmSwift

class ResultViewController: UIViewController, SimpleEmailComposer {
    
    @IBOutlet weak var tableView: UITableView!
    
    var patient: Patient?
    
    var results: Results? {
        return patient?.results?.asResultDictionary()
    }
    
    fileprivate struct Objects {
        var sectionName: Frequency!
        var sectionObjects: [ResultTuple]!
    }
    
    fileprivate var objectArray = [Objects]()
    
    private lazy var shareBarButtonItem: UIBarButtonItem = { () -> UIBarButtonItem in
        let button = UIBarButtonItem(barButtonSystemItem: .action,
                                     target: self,
                                     action: #selector(shareButtonAction))
        return button
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = { () -> UIBarButtonItem in
        let button = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: self,
                                     action: #selector(doneButtonAction))
        return button
    }()
    
    private lazy var leftBarButtonItem: UIBarButtonItem = { () -> UIBarButtonItem in
        let button = UIBarButtonItem(barButtonSystemItem: .cancel,
                                     target: self,
                                     action: #selector(cancelButtonAction))
        button.title = "deletar"
        button.tintColor = .red
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let results = results,
            let patient = patient else { return }
        
        tableView.dataSource = self
        
        savePatientOnRealm(patient)
        setupNavigationBar()
        populateDataSourceWith(results)
        tableView.reloadData()
    }
    
    private func populateDataSourceWith(_ results: Results) {
        for (key, value) in results {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
    }
    
    private func setupNavigationBar() {
        
        title = patient?.reabableId()
//        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func savePatientOnRealm(_ patient: Patient) {
        do {
            let realm = try Realm()
            try realm.write { realm.add(patient, update: false) }
        } catch let error {
            print(error)
        }
    }
    
    private func deletePatientFromRealm(_ patient: Patient) {
        do {
            let realm = try Realm()
            try realm.write { realm.delete(patient) }
        } catch let error {
            print(error)
        }
    }
    
    @objc private func cancelButtonAction() {
        let alertController = UIAlertController(title: "Você deseja cancelar este teste?",
                                                message: "O cancelamento do teste resulta em deleção permanente do mesmo, você deseja realmnete deletar esse resultado?",
                                                preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Deletar", style: .destructive) { (alertAction) in
            self.deletePatientFromRealm(self.patient!)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func doneButtonAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func shareButtonAction() {
        let data = try! Exporter.exportPatient(patient!)
        sendEmailWithData(data, fileName: "\(patient?.id ?? "unknown").csv")
    }
}


extension ResultViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as! ResultTableViewCell
        let section = indexPath.section
        let row = indexPath.row
        
        let resultTuple = objectArray[section].sectionObjects[row]
        if let frequency = objectArray[section].sectionName {
            cell.configureWith(resultTuple, frequency: frequency)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let frequency = objectArray[section].sectionName {
            return ("Frequência: \(frequency) Hz")
        } else {
            return "Sem frequencia"
        }
    }
}

extension ResultViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            print("Error: \(String(describing: error))")
        }
        dismiss(animated: true)
    }
}
