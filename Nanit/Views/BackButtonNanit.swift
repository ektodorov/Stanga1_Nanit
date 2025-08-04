//
//  BackButtonNanit.swift
//  Nanit
//

import SwiftUI

struct BackButtonNanit: View {
    let dismiss: DismissAction
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "arrow.backward").foregroundColor(Color.black)
        }
    }
}

#Preview {
    @Previewable @Environment(\.dismiss) var dismiss
    BackButtonNanit(dismiss: dismiss)
}
