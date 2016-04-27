//
//  NoiseMeterViewController.swift
//  Audiometria
//
//  Created by Marcus Vinicius Kuquert on 26/04/16.
//  Copyright © 2016 darkshine. All rights reserved.
//

import UIKit

class NoiseMeterViewController: UIViewController {

    @IBOutlet weak var levelView: UIView!
    @IBOutlet weak var levelHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelHeightConstraint.constant = 0
        levelView.frame.size.height = 300
        levelView.backgroundColor = .blackColor()
        
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        levelHeightConstraint.constant = 100
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
