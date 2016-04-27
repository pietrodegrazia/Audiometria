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
        
        let task = ORKOrderedTask(identifier: "task", steps: [myStep, formStep])
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
    
    private var formStep: ORKStep {
        let step = ORKFormStep(identifier: "FormStep", title: "Dados do paciente", text: "Insira os dados do paciente")
        
        let answerFormat = ORKAnswerFormat.textAnswerFormat()
        answerFormat.multipleLines = false
        
        let formItem01 = ORKFormItem(identifier: "FormItem1", text: "Nome", answerFormat: answerFormat)
        formItem01.placeholder = ""
        
        let formItem02 = ORKFormItem(identifier: "FormItem2", text: "DOB", answerFormat: ORKAnswerFormat.dateAnswerFormat())
        formItem02.placeholder = ""
        
        let formItem03 = ORKFormItem(identifier: "FormItem3", text: "Data do exame", answerFormat: ORKAnswerFormat.dateAnswerFormatWithDefaultDate(NSDate(), minimumDate: NSDate(), maximumDate: nil, calendar: NSCalendar.currentCalendar()))
        formItem03.placeholder = ""
        
        let choice01 = ORKTextChoice(text: "Male", value: 0)
        let choice02 = ORKTextChoice(text: "Female", value: 1)
        let formItem04 = ORKFormItem(identifier: "FormItem4", text: "Sexo", answerFormat: ORKAnswerFormat.valuePickerAnswerFormatWithTextChoices([choice01, choice02]))
        
        step.formItems = [
            formItem01,
            formItem02,
            formItem03,
            formItem04
        ]
        
        return step
    }

}

