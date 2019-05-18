//
//  Transaction.swift
//  SmartExpense
//
//  Created by Mosquito1123 on 17/05/2019.
//  Copyright © 2019 Cranberry. All rights reserved.
//

import UIKit
protocol PopScene {
    func dismissPop()
}
class EncodableTrans:Codable{
    var transRecord:[String:[Transaction]]?
    required init() {
        
    }
}
class RecordLoader{
    /// document path plus the filename "userSetting"
    private let fullPath = NSHomeDirectory() + "/Documents/userSetting"
    
    func loadUserSetting()->UserSettings {
        let newUser = UserSettings()
        let mediator = RoleMediator(roles: [])
        newUser.mediator = mediator
        /// If the stored file exists
        if let myData = UserDefaults.standard.value(forKey: "userSettings") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(EncodableTrans.self, from: myData) {
                newUser.transactionRecord = objectsDecoded.transRecord!
            }
        }
        for temp in newUser.currentRoles {
            for tempA in temp.value {
                guard (newUser.mediator?.registerNewRole(name: tempA, role: temp.key))! else {
                    // print("false to create new payer.")
                    continue
                }
            }
        }
        newUser.mediator?.parentUserSetting = newUser
        return newUser
    }
    
    func saveRecord(userTrans:EncodableTrans) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userTrans) {
            UserDefaults.standard.set(encoded, forKey: "userSettings")
        }
        
    }
}
extension Date{
    /// Convert the date into format string "yyyyMMdd"
    func getMyDateString() -> String {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyyMMdd"
        return dateFmt.string(from: self)
    }
    
    /**
     Return the string array from date contains [*year*,*month*,*day*]
     
     format: "yyyyMMdd"
     */
    func getYearMonthDay() ->[String]{
        let dateStr = self.getMyDateString()
        let index = dateStr.index(dateStr.startIndex, offsetBy: 6)
        let index2 = dateStr.index(dateStr.startIndex, offsetBy: 4)
        let day = String(dateStr[index...])
        let month = String(dateStr[index2..<index])
        let year = String(dateStr[..<index2])
        return [year,month,day]
    }
    
    /**
     Extract the month and convert it into localize month string
     * English: January
     * Chinese: 一月
     */
    func getMonthString() -> String{
        let months = ["January","Febuary","March","April","May","June","July","August","September","October","November","December"]
        return NSLocalizedString(months[Int(self.getYearMonthDay()[1])! - 1], comment: "Month String")
    }
    
    /**
     - Parameter dateStr: the date string in format "yyyyMMdd"
     
     Passing the date string and return the Date class
     */
    static func getDateFromString(dateStr:String)-> Date {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyyMMdd"
        return fmt.date(from: dateStr)!
    }
}
extension UIColor {
    /// init the uicolor by enter the hex UInt, convert into RGB
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

class Transaction:Codable{
    var from: String!
    var to: String!
    var by:String!
    var money: Double!
    var date : Date!
    var remark: String?
    /// unique index in dictionary, for convenient removing the cell in table view.
    var index: Int!
    
    init(from:ExpenseRole, to:ExpenseRole,by: ExpenseRole,money: Double, date: Date, remark: String?,index: Int) {
        self.from = from.name
        self.to = to.name
        self.by = by.name
        self.money = money
        self.date = date
        if (remark != nil) {
            self.remark = remark
        }
        self.index = index
    }
}

