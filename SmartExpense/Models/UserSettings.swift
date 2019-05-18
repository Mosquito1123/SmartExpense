//
//  UserSettings.swift
//  SmartExpense
//
//  Created by Mosquito1123 on 17/05/2019.
//  Copyright © 2019 Cranberry. All rights reserved.
//

import Foundation
class UserSettings:Codable{
    /// roles dictionary, mainly used in addRec view
    var currentRoles: [Roles:[String]] = [.Payer:["Me"],
                                          .Payment: ["Default","Cash","Debit","Credit","Alipay","Wepay","Paypal","Online","Check"],
                                          .Payee:["Default","Food","Supermarket","Shop", "Traffic", "Transfer","Movie","Rent","Hospital","Finance","Gift"]]
    /// (Codable)Store the transaction record
    var transactionRecord: [String:[Transaction]] = [:]
    /// mediator instance
    var mediator: RoleMediator?
    
    init(){
        let mediator = RoleMediator(roles: [])
        /// init the default roles
        for temp in currentRoles {
            for tempA in temp.value {
                guard mediator.registerNewRole(name: tempA, role: temp.key) else {
                    // print("false to create new payer.")
                    return
                }
            }
        }
        self.mediator = mediator
        self.mediator?.parentUserSetting = self
    }
}
