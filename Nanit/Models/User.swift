//
//  User.swift
//  Nanit
//

import Foundation
import UIKit

struct User {
    var name: String = ""
    private var birthdayDefault: Date
    var birthdayDate: Date
    var picturePath: String = ""
    var picture: UIImage?
    
    init() {
        let now = Date.now
        birthdayDefault = now
        birthdayDate = now
    }
    
    init(name: String, birthdayDate: Date, picturePath: String, picture: UIImage? = nil) {
        self.name = name
        self.birthdayDefault = Date.now
        self.birthdayDate = birthdayDate
        self.picturePath = picturePath
        self.picture = picture
    }
    
    func isBirthdaySet() -> Bool {
        return birthdayDefault != birthdayDate
    }
    
    func getAgeMonths() -> String {
        let components: DateComponents = Calendar.current.dateComponents([Calendar.Component.month], from: birthdayDate, to: Date.now)
        if let month = components.month {
            return String.init(format: "%d", month)
        }
        return ""
    }
    
    func getAgeYears() -> String {
        let components: DateComponents = Calendar.current.dateComponents([Calendar.Component.year], from: birthdayDate, to: Date.now)
        if let year = components.year {
            return String.init(format: "%d", year)
        }
        return ""
    }
}
