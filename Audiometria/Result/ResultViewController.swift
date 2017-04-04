//
//  ResultViewController.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 5/23/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    typealias summary = (frequency: Double, listened: Bool)
    
    var results:[Double:[ResultTuple]]!
    var patient: Patient?
    
    struct Objects {
        
        var sectionName : Double!
        var sectionObjects : [ResultTuple]!
    }
    
    fileprivate var objectArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action,
                                                target: self,
                                                action: #selector(shareButtonAction))
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                                 target: self,
                                                 action: #selector(doneButtonAction))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        for (key, value) in results {
            print("\(key) -> \(value)")
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        
        tableView.reloadData()
    }
    
    func shareButtonAction() {
        //TODO: Implements export sheet, including e-mail export
    }
    
    func doneButtonAction() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        let resultTuple = objectArray[sectionIndex].sectionObjects[rowIndex]
        
        switch resultTuple.result {
        case .notHeard:
            cell.textLabel?.text = "Não ouviu em: \(resultTuple.amplitude)"
            cell.backgroundColor = .red
            break
            
        case .heared:
            cell.textLabel?.text = "Ouviu em: \(resultTuple.amplitude)"
            cell.backgroundColor = .green
            break
            
        case .outOfRange:
            cell.textLabel?.text = "Fora da amplitude suportada ⚠️ \(resultTuple.amplitude)"
            cell.backgroundColor = .blue
            break
            
        case .notTested:
            cell.textLabel?.text = "Frequencia não testada \(resultTuple.amplitude)"
            cell.backgroundColor = .yellow
            break
        }
        
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
