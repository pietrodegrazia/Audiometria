//
//  ResultCell.swift
//  Audiometria
//
//  Created by Henrique Valcanaia on 19/05/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation
import UIKit

class ResultTableViewCell: UITableViewCell {
    
    static let identifier = "ResultTableViewCell"
    
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultText: UILabel!
    
    
    private func cleanForReuse() {
        resultImage.image = UIImage()
        backgroundColor = .white
        resultText.text = ""
    }
    
    func configureWith(_ resultTuple: ResultTuple, frequency: Frequency) {
        cleanForReuse()
        
        let amplitude  = amplitudeReal(frequency: frequency, amplitudeAPI: resultTuple.amplitude)
        
        switch resultTuple.result {
        case .heard:
            resultText.text = "👍" + "\(amplitude)db"
            resultImage.image = #imageLiteral(resourceName: "heard")
            
        case .notHeard:
            resultText.text = "👎" + "\(amplitude)db"
            resultImage.image = #imageLiteral(resourceName: "notHeard")
            
        case .outOfRange:
            resultText.text = "⚠️" + "\(amplitude) não suportada!"
            resultImage.image = #imageLiteral(resourceName: "outOfRange")
            
        case .notTested:
            resultText.text = "\(amplitude) não testada."
            backgroundColor = .yellow
            
        case .unknown:
            resultText.text = "\(resultTuple) resultado inválido"
            backgroundColor = .red
        }
    }
}
