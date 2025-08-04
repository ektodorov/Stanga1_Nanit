//
//  ConstantsNanit.swift
//  Nanit
//

import Foundation
import SwiftUI

struct ConstantsNanit {
    
    static let kUserName = "user_name"
    static let kUserBirthday = "user_birthday"
    static let kUserImageName = "user_image.jpg"
    
    static func getDigit(from: String, index: Int) -> String? {
        if(from.count <= index) {
            return nil
        }
        
        let start = from.index(from.startIndex, offsetBy: index)
        let end = from.index(from.startIndex, offsetBy: (index + 1))
        let range = start..<end

        let digit: String = String(from[range])
        
        return digit
    }
    
    @MainActor static func render(contentView: some View, displayScale: CGFloat) -> UIImage? {
        let renderer = ImageRenderer(content: contentView)
        renderer.scale = displayScale
        
        let uiImage = renderer.uiImage
        return uiImage
    }
}
