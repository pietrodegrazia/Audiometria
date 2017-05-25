//
//  ResultViewController.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/23/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public vars
    var results: Results!
    var patient: Patient?
    
    // MARK: - Private types
    private struct Objects {
        var sectionName: Frequency!
        var sectionObjects: [ResultTuple]!
    }
    
    // MARK: - Private vars
    private var objectArray = [Objects]()
    private lazy var leftBarButtonItem: UIBarButtonItem = { () -> UIBarButtonItem in
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        for (key, value) in results {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    @objc private func shareButtonAction() {
        //TODO: Implements export sheet, including e-mail export
    }
    
    @objc private func doneButtonAction() {
        let alertController = UIAlertController(title: "Você deseja salvar o teste?",
                                                message: "Caso não queira salver esse resultado será descartado permanentemente",
                                                preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) { (alertAction) in
            //TODO: Cancel
        }
        
        let saveAction = UIAlertAction(title: "Salvar", style: UIAlertActionStyle.default) { (alertAction) in
            //TODO: Save, on the save action it creates a Patient and save it on the database
        }
        
        let deleteAction = UIAlertAction(title: "Deletar", style: UIAlertActionStyle.destructive) { (alertAction) in
            //TODO: delete
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - UITableViewDataSource
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
        
        switch resultTuple.result {
        case .notHeard:
            cell.resultText.text = "\(resultTuple.amplitude)db"
            cell.resultImage.image = #imageLiteral(resourceName: "notHeard")

        case .heard:
            cell.resultText.text = "\(resultTuple.amplitude)db"
            cell.resultImage.image = #imageLiteral(resourceName: "heard")
            
        case .outOfRange:
            cell.resultText.text = "\(resultTuple.amplitude) não suportada!"
            cell.resultImage.image = #imageLiteral(resourceName: "outOfRange")
            
        case .notTested:
            cell.resultText.text = "Amplitude \(resultTuple.amplitude) não testada."
            cell.backgroundColor = .yellow
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


func -(rect: CGRect, value: NSNumber) -> CGRect {
    return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width - CGFloat(value), height: rect.size.height - CGFloat(value))
}
