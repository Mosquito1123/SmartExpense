//
//  ExpenseRole.swift
//  SmartExpense
//
//  Created by Mosquito1123 on 17/05/2019.
//  Copyright © 2019 Cranberry. All rights reserved.
//

import Foundation
/// enum for role type
enum Roles : Int,Codable{
    case Payer = 0
    case Payment = 1
    case Payee = 2
}

class ExpenseRole:Codable{
    var name:String = ""
    var role:Roles = .Payer
    // unique role id
    private var roleId:Int = 0
    
    init(name:String, role:Roles, roleId:Int, mediator: RoleMediator) {
        self.name = name
        self.role = role
        self.roleId = roleId
    }
    
    func getRoleId() -> Int{
        return self.roleId
    }
    
}
