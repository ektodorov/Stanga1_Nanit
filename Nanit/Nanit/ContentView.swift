//
//  ContentView.swift
//  Nanit
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject private var userViewModel: UserViewModel
    
    init() {
        _userViewModel = StateObject(wrappedValue: UserViewModel())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Happy Birthday!").padding()
                TextField("Name", text: $userViewModel.user.name, onCommit: {
                    //UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle.roundedBorder)
                .padding()
                
                DatePicker("Select a Date",
                           selection: $userViewModel.user.birthdayDate,
                    displayedComponents: .date)
                .padding()
                
                if(userViewModel.userImage != nil) {
                    userViewModel.userImage?
                        .resizable()
                        .frame(width: 208.0, height: 208.0, alignment: Alignment.center)
                        .clipShape(Circle())
                } else {
                    Image(userViewModel.backgroundUserDefault)
                }
                
                NavigationLink {
                    HappyBirthday(viewModel: userViewModel)
                } label: {
                    Text("Show birthday screen").padding().border(userViewModel.backgroundColor)
                }
                .disabled((userViewModel.user.name.isEmpty || !userViewModel.user.isBirthdaySet()))
                .padding()

                Spacer()
            }
            .padding()
            .overlay(alignment: .bottomTrailing) {
                Button {
                    userViewModel.removeUserData()
                } label: {
                    Text("Remove data")
                }
                .padding()
                .border(userViewModel.backgroundColor)
                .padding()
            }
            .onAppear {
                userViewModel.loadUser()
                userViewModel.isForRendering = true
            }
            .onDisappear {
                UserDefaults.standard.set(userViewModel.user.name, forKey: ConstantsNanit.kUserName)
                UserDefaults.standard.set(userViewModel.user.birthdayDate.timeIntervalSince1970, forKey: ConstantsNanit.kUserBirthday)
            }
        }
    }
}

#Preview {
    ContentView()
}
