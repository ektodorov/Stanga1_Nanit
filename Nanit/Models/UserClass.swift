//
//  UserClass.swift
//  Nanit
//

import Foundation

class UserClass : ObservableObject {
    @Published var name: String = ""
    @Published var birthday: String = ""
    @Published var picturePath: String = ""
    
    init() {
        
    }
    
    init(name: String, birthday: String, picturePath: String) {
        self.name = name
        self.birthday = birthday
        self.picturePath = picturePath
    }
}
