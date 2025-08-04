//
//  DigitView.swift
//  Nanit
//

import SwiftUI

struct DigitView: View {
    var digit: String = ""
    
    var body: some View {
        if let digit1 = ConstantsNanit.getDigit(from: digit, index: 0) {
            Image("Digit\(digit1)")
        }
        if let digit2 = ConstantsNanit.getDigit(from: digit, index: 1) {
            Image("Digit\(digit2)")
        }
        if let digit3 = ConstantsNanit.getDigit(from: digit, index: 2) {
            Image("Digit\(digit3)")
        }
    }
}

#Preview {
    DigitView()
}
