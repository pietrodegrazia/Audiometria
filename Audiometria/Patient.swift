//
//  Patient.swift
//  Audiometria
//
//  Created by Marcus Vinicius Kuquert on 23/08/17.
//  Copyright © 2017 darkshine. All rights reserved.
//

import Foundation
import RealmSwift

class Patient: Object {
    //Id deve ser gerado na tela de resultados quando o usuario escolhe salvar resultado
    dynamic var id = ""
    //Results deve ser um Object
//    dynamic var result: Results?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
