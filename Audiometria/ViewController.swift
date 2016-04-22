//
//  ViewController.swift
//  Audiometria
//
//  Created by Marcus Vinicius Kuquert on 22/04/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import UIKit
import ResearchKit

class ViewController: UIViewController, ORKTaskViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myStep = ORKInstructionStep(identifier: "intro")
        myStep.title = "Welcome to ResearchKit"
        
        let task = ORKOrderedTask(identifier: "task", steps: [myStep])
        
        let taskViewController = ORKTaskViewController(task: task, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        print(reason)
    }

}

