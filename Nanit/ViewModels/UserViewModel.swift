//
//  UserViewModel.swift
//  Nanit
//

import Foundation
import PhotosUI
import CoreTransferable
import SwiftUI

class UserViewModel: ObservableObject {
    
    @Published var user: User
    @Published var userImage: Image?
    @Published var userImageShare: Image?
    var backgroundColor: Color = Color.colorFox
    var backgroundImage: String
    var backgroundUserDefault: String
    var backgroundTakePhoto: String
    var isForRendering: Bool = true
    var isForRenderingShare: Bool = false
    
    init() {
        user = User()
        backgroundImage = ""
        backgroundUserDefault = ""
        backgroundTakePhoto = ""
        pickUI(name: backgroundImage)
    }
    
    init(user: User, userImage: Image? = nil, userImageShare: Image? = nil, backgroundColor: Color, backgroundImage: String, backgroundUserDefault: String, backgroundTakePhoto: String, isForRendering: Bool = false) {
        self.user = user
        self.userImage = userImage
        self.userImageShare = userImageShare
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.backgroundUserDefault = backgroundUserDefault
        self.backgroundTakePhoto = backgroundTakePhoto
        self.isForRendering = isForRendering
        pickUI(name: nil)
    }
    
    init(userViewModel: UserViewModel){
        self.user = userViewModel.user
        self.userImage = userViewModel.userImage
        self.userImageShare = userViewModel.userImageShare
        self.backgroundColor = userViewModel.backgroundColor
        self.backgroundImage = userViewModel.backgroundImage
        self.backgroundUserDefault = userViewModel.backgroundUserDefault
        self.backgroundTakePhoto = userViewModel.backgroundTakePhoto
    }
    
    func copyFrom(userViewModel: UserViewModel) {
        self.user = userViewModel.user
        self.userImage = userViewModel.userImage
        self.userImageShare = userViewModel.userImageShare
        self.backgroundColor = userViewModel.backgroundColor
        self.backgroundImage = userViewModel.backgroundImage
        self.backgroundUserDefault = userViewModel.backgroundUserDefault
        self.backgroundTakePhoto = userViewModel.backgroundTakePhoto
    }
    
    func loadUser() {
        user = User()
        if let userName = UserDefaults.standard.string(forKey: ConstantsNanit.kUserName) {
            user.name = userName
        }
        if(UserDefaults.standard.object(forKey: ConstantsNanit.kUserBirthday) != nil) {
            let birthday = UserDefaults.standard.double(forKey: ConstantsNanit.kUserBirthday)
            user.birthdayDate = Date(timeIntervalSince1970: birthday)
        }
        Task {
            if let image: UIImage = loadImageFromDiskWith(fileName: ConstantsNanit.kUserImageName) {
                DispatchQueue.main.async {[weak self] ()->Void in
                    self?.userImage = Image(uiImage: image)
                }
            }
        }
        
        pickUI(name: nil)
    }
    
    func removeUserData() {
        UserDefaults.standard.removeObject(forKey: ConstantsNanit.kUserName)
        UserDefaults.standard.removeObject(forKey: ConstantsNanit.kUserBirthday)
        Task {
            deleteImage(imageName: ConstantsNanit.kUserImageName)
        }
        userImage = nil
        user = User()
    }
    
    func pickUI(name: String?) {
        var value: String? = name
        if(value == nil || value!.isEmpty) {
            let number = Int.random(in: 0...2)
            if(number == 0) {
                value = "BackgroundElephant"
            } else if(number == 1) {
                value = "BackgroundFox"
            } else {
                value = "BackgroundPelican"
            }
        }

        if(value == "BackgroundElephant") {
            backgroundColor = Color.colorElephant
            backgroundImage = "BackgroundElephant"
            backgroundUserDefault = "FaceYellow"
            backgroundTakePhoto = "PhotoYellow"
        } else if(value == "BackgroundFox") {
            backgroundColor = Color.colorFox
            backgroundImage = "BackgroundFox"
            backgroundUserDefault = "FaceGreen"
            backgroundTakePhoto = "PhotoGreen"
        } else if(value == "BackgroundPelican") {
            backgroundColor = Color.colorPelican
            backgroundImage = "BackgroundPelican"
            backgroundUserDefault = "FaceBlue"
            backgroundTakePhoto = "PhotoBlue"
        }
    }
    
    func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        //If file exists remove.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("UserViewModel, \(#line), couldn't remove file at fileURL=\(fileURL)", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("UserViewModel, \(#line), error saving file", error)
        }
     
    }

    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        
        return nil
    }
    
    func deleteImage(imageName: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("UserViewModel, \(#line), couldn't remove file at fileURL=\(fileURL)", removeError)
            }
        }
    }
}
