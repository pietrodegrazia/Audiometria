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
        
    }
    @IBAction func button(sender: AnyObject) {
        
        let myStep = ORKInstructionStep(identifier: "intro")
        myStep.title = "Welcome to ResearchKit"
        
        let audioStep = ORKToneAudiometryStep(identifier: "audimetry")
        audioStep.title = "Pressione uma tecla para iniciar"
        audioStep.toneDuration = 5
        
        let task = ORKOrderedTask(identifier: "task", steps: [myStep, audioStep])
        
        let taskViewController = ORKTaskViewController(task: task, taskRunUUID: nil)
        taskViewController.delegate = self
        
        self.presentViewController(taskViewController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
        print(reason)
    }

}

