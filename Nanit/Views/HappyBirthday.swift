//
//  HappyBirthday.swift
//  Nanit
//

import SwiftUI
import PhotosUI

struct HappyBirthday: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: UserViewModel
    
    //photo picker
    @State private var showPickerDialog: Bool = false
    @State private var showPicker: Bool = false
    @State private var showPickerCamera: Bool = false
    @State private var showPickerPhotos: Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    func degreesToRadians(number: CGFloat) -> CGFloat {
        return number * CGFloat.pi / 180
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: HorizontalAlignment.center, spacing: 0.0) {
                Spacer()
                ZStack() {
                    if(viewModel.userImage != nil) {
                        viewModel.userImage?
                            .resizable()
                            .frame(width: 208.0, height: 208.0, alignment: Alignment.center)
                            .clipShape(Circle())
                    } else {
                        Image(viewModel.backgroundUserDefault)
                    }
                }
                .frame(width: 208.0, height: 208.0)
                Spacer().frame(height: 185.0)
            }
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
            
            Image(viewModel.backgroundImage)
                .resizable()
                .aspectRatio(contentMode: ContentMode.fill)
                .ignoresSafeArea()
                .focusable(false)
                .disabled(true)
            
            VStack(alignment: HorizontalAlignment.center, spacing: 0.0) {
                Spacer()
                ZStack() {
                    if(!viewModel.isForRenderingShare) {
                        Button {
                            showPickerDialog = true
                        } label: {
                            Image(viewModel.backgroundTakePhoto)
                        }
                        .position(
                            x: 104.0 + 104.0 * cos(degreesToRadians(number: 315.0)),
                            y: 104.0 + 104.0 * sin(degreesToRadians(number: 315.0))
                        )
                        .alert("Select Action", isPresented: $showPickerDialog) {
                            Button {
                                showPickerPhotos = false
                                if(showPickerCamera && UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                                    showPickerCamera = true
                                    showPicker = true
                                }
                            } label: {
                                Text("Take Picture")
                            }
                            Button {
                                showPickerCamera = false
                                showPicker = false
                                showPickerPhotos = true
                            } label: {
                                Text("Select Photo")
                            }
                        }
                    }
                }
                .frame(width: 208.0, height: 208.0)
                Spacer().frame(height: 185.0)
            }.frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
                        
            VStack(alignment: HorizontalAlignment.center, spacing: 0.0) {
                Text("Today \(viewModel.user.name) is")
                    .textCase(Text.Case.uppercase)
                    .font(Font.system(size: 22.0))
                    .frame(maxWidth: CGFloat.infinity, alignment: Alignment.center)
                    .padding(EdgeInsets(top: 20.0, leading: 60.0, bottom: 13.0, trailing: 60.0))
                    .multilineTextAlignment(TextAlignment.center)
                
                HStack(spacing: 0.0) {
                    Image("SwirlsLeft").padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 22.0))
                    if((Int(viewModel.user.getAgeMonths()) ?? 0) > 12) {
                        DigitView(digit: viewModel.user.getAgeYears())
                    } else {
                        DigitView(digit: viewModel.user.getAgeMonths())
                    }
                    Image("SwirlsRight").padding(EdgeInsets(top: 0.0, leading: 22.0, bottom: 0.0, trailing: 0.0))
                }
                
                if((Int(viewModel.user.getAgeMonths()) ?? 0) > 12) {
                    Text("Years old!")
                        .textCase(Text.Case.uppercase)
                        .padding(EdgeInsets(top: 14.0, leading: 0.0, bottom: 20.0, trailing: 0.0))
                } else {
                    Text("Months old!")
                        .textCase(Text.Case.uppercase)
                        .padding(EdgeInsets(top: 14.0, leading: 0.0, bottom: 20.0, trailing: 0.0))
                }
                Spacer()
            }
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
                        
            VStack(alignment: HorizontalAlignment.center, spacing: 0.0) {
                Spacer()
                Image("Nanit").padding(EdgeInsets(top: 15.0, leading: 0.0, bottom: 53.0, trailing: 0.0))
                
                if(!viewModel.isForRenderingShare) {
                    let shareImage = viewModel.userImageShare ?? (viewModel.userImage ?? Image(viewModel.backgroundTakePhoto))
                    ShareLink(item: shareImage, preview: SharePreview("image", image: shareImage)) {
                        Text("Share the news").foregroundColor(Color.white)
                        Image(systemName: "arrowshape.turn.up.right.fill").foregroundColor(Color.white)
                    }
                    .labelStyle(.iconOnly)
                    .imageScale(.large)
                    .symbolVariant(.fill)
                    .padding(EdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0))
                    .frame(minWidth: 44.0, minHeight: 44.0)
                    .background(
                        Capsule().fill(Color.colorShareButton)
                    )
                } else {
                    Spacer().frame(height: 44.0)
                }
                
                Spacer().frame(height: 53.0)
            }
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
        }
        .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
        .background(viewModel.backgroundColor)
        .photosPicker(isPresented: $showPickerPhotos, selection: $selectedItem, matching: .images, photoLibrary: .shared())
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                    if(selectedImageData != nil) {
                        if let uiImage = UIImage(data: selectedImageData!) {
                            viewModel.userImage = Image(uiImage: uiImage)
                            viewModel.saveImage(imageName: ConstantsNanit.kUserImageName, image: uiImage)
                        }
                    }
                    showPickerCamera = false
                    showPicker = false
                    showPickerPhotos = false
                    viewModel.isForRendering = false
                    let model = UserViewModel(userViewModel: viewModel)
                    model.isForRendering = false
                    model.isForRenderingShare = true
                    let image: UIImage? = ConstantsNanit.render(contentView: HappyBirthday(viewModel: model), displayScale: 1.0)
                    if(image != nil) {
                        viewModel.userImageShare = Image(uiImage: image!)
                    }
                }
            }
        }
        .onAppear(perform: {
            if(viewModel.isForRendering) {
                viewModel.isForRendering = false
                let model = UserViewModel(userViewModel: viewModel)
                model.isForRendering = false
                model.isForRenderingShare = true
                Task {
                    let image: UIImage? = ConstantsNanit.render(contentView: HappyBirthday(viewModel: model), displayScale: 1.0)
                    if(image != nil) {
                        viewModel.userImageShare = Image(uiImage: image!)
                    }
                }
            }
        })
        .onDisappear {
            showPickerCamera = false
            showPicker = false
            showPickerPhotos = false
        }
        .fullScreenCover(isPresented: $showPicker) {
            CameraPickerView { image in
                viewModel.userImage = Image(uiImage: image)
                showPickerCamera = false
                showPicker = false
                showPickerPhotos = false
            }
        }
        .navigationBarBackButtonHidden(true) // Hide default button
        .navigationBarItems(leading: BackButtonNanit(dismiss: self.dismiss))
        
        //start VStack
//        VStack(alignment: HorizontalAlignment.center, spacing:0.0, content: {
//            Text("Today John Rambo is")
//                .textCase(Text.Case.uppercase)
//                .font(Font.system(size: 22.0))
//                .frame(maxWidth: CGFloat.infinity, alignment: Alignment.center)
//                .padding(EdgeInsets(top: 20.0, leading: 60.0, bottom: 13.0, trailing: 60.0))
//            
//            HStack(spacing: 0.0) {
//                Image("SwirlsLeft").padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 22.0))
//                Image("Digit1")
//                //Image("Digit2")
//                //Image("Digit3")
//                Image("SwirlsRight").padding(EdgeInsets(top: 0.0, leading: 22.0, bottom: 0.0, trailing: 0.0))
//            }
//            
//            Text("Month old!")
//                .textCase(Text.Case.uppercase)
//                .padding(EdgeInsets(top: 14.0, leading: 0.0, bottom: 20.0, trailing: 0.0))
//            Spacer()
//            
//            ZStack() {
//                if(viewModel.userImage != nil) {
//                    viewModel.userImage?
//                        .resizable()
//                        .frame(width: 208.0, height: 208.0, alignment: Alignment.center)
//                        .clipShape(Circle())
//                } else {
//                    Image("FaceGreen")
//                }
//                
//                Button {
//                    showPickerDialog = true
//                } label: {
//                    Image("PhotoGreen")
//                }
//                .position(
//                    x: 104.0 + 104.0 * cos(degreesToRadians(number: 315.0)),
//                    y: 104.0 + 104.0 * sin(degreesToRadians(number: 315.0))
//                )
//                .alert("Select Action", isPresented: $showPickerDialog) {
//                    Button {
//                        showPickerPhotos = false
//                        if(showPickerCamera && UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
//                            showPickerCamera = true
//                            showPicker = true
//                        }
//                    } label: {
//                        Text("Take Picture")
//                    }
//                    Button {
//                        showPickerCamera = false
//                        showPicker = false
//                        showPickerPhotos = true
//                    } label: {
//                        Text("Select Photo")
//                    }
//                }
//            }.frame(width: 208.0, height: 208.0)
//            
//            Image("Nanit").padding(EdgeInsets(top: 15.0, leading: 0.0, bottom: 53.0, trailing: 0.0))
//            
//            let shareImage = viewModel.userImage ?? Image("PhotoGree")
//            ShareLink(item: shareImage, preview: SharePreview("image", image: shareImage)) {
//                Text("Share the news").foregroundColor(Color.white)
//                Image(systemName: "arrowshape.turn.up.right.fill").foregroundColor(Color.white)
//            }
//            .labelStyle(.iconOnly)
//            .imageScale(.large)
//            .symbolVariant(.fill)
//            .padding(EdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0))
//            .frame(minWidth: 44.0, minHeight: 44.0)
//            .background(
//                Capsule().fill(Color.colorShareButton)
//            )
//            .disabled(viewModel.userImage == nil)
//            Spacer().frame(height: 53.0)
//        })
//        .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
//        .background(content: {
//            Image("BackgroundFox")
//                .resizable()
//                .aspectRatio(contentMode: ContentMode.fill)
//                .ignoresSafeArea()
//                //.background(Color.colorFox)
//        })
//        .background(Color.colorFox)
//        .photosPicker(isPresented: $showPickerPhotos, selection: $selectedItem, matching: .images, photoLibrary: .shared())
//        .onChange(of: selectedItem) { oldValue, newValue in
//            Task {
//                if let data = try? await newValue?.loadTransferable(type: Data.self) {
//                    selectedImageData = data
//                    if(selectedImageData != nil) {
//                        if let uiImage = UIImage(data: selectedImageData!) {
//                            viewModel.userImage = Image(uiImage: uiImage)
//                        }
//                    }
//                    showPickerCamera = false
//                    showPicker = false
//                    showPickerPhotos = false
//                }
//            }
//        }.onDisappear {
//            showPickerCamera = false
//            showPicker = false
//            showPickerPhotos = false
//        }
//        .fullScreenCover(isPresented: $showPicker) {
//            CameraPickerView { image in
//                viewModel.userImage = Image(uiImage: image)
//                showPickerCamera = false
//                showPicker = false
//                showPickerPhotos = false
//            }
//        }
        //end VStack
    }
}

#Preview {
    @Previewable @StateObject var viewModel: UserViewModel = UserViewModel()
    HappyBirthday(viewModel: viewModel)
}
