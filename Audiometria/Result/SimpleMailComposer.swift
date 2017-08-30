//
//  SimpleMailComposer.swift
//  Audiometria
//
//  Created by Marcus Vinicius Kuquert on 30/08/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation
import MessageUI

protocol SimpleEmailComposer {
    func sendEmailWithTitle(fileName: String, data: Data)
}

extension SimpleEmailComposer where Self: UIViewController, Self: MFMailComposeViewControllerDelegate {
    
    func sendEmailWithData(_ data: Data, fileName: String) {
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setSubject("Resultados exames audiometria")
            mailComposeVC.setMessageBody("<b>RESULTADOS</b>", isHTML: true)
            mailComposeVC.setToRecipients(["recipients"])
            mailComposeVC.addAttachmentData(data, mimeType: "application/csv", fileName: fileName)
            present(mailComposeVC, animated: true, completion: nil)
            
        } else {
            let title = NSLocalizedString("Error", value: "Error", comment: "")
            let message = NSLocalizedString("Your device doesn't support Mail messaging",
                                            value: "Your device doesn't support Mail messaging",
                                            comment: "")
            
            if #available(iOS 9, *) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                show(alert, sender: nil)
            } else {
                let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", value: "OK", comment: ""))
                alertView.show()
            }
        }
    }
}
