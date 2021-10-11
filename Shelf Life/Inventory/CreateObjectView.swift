//
//  ContentView.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 19.06.2021.
//

import SwiftUI

struct CreateObjectView: View {
    
    @State var input_image: UIImage = UIImage(imageLiteralResourceName: "bob_bg")
    @State var output_image: UIImage = UIImage(imageLiteralResourceName: "placeholder")
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 32) {
                // imageView(for: viewModel.selectedImage)
                imageView(for: viewModel.bgRemovedImage)
                    .cornerRadius(12)
            }
            controlBar()
            Text(self.viewModel.notification)
                .bold()
                .font(Font.system(size: 12))
                .multilineTextAlignment(.center)
                .padding()
            
            if self.viewModel.loadingPixelatedImages {
                ProgressView()
            }
            
            TabView {
                ForEach(self.viewModel.pixelatedImages, id: \.self) { pi in
                    ZStack {
                        Color.init(UIColor.init(named: "light-background")!)
                        Image(uiImage: pi)
                                    .interpolation(.none)
                                    .resizable()
                                    .frame(width: 256, height: 256)
                                    .scaledToFit()
                        .padding(16)
                        
                        HStack {
                            Spacer()
                            VStack {
                                Button.init {
                                    Inventory().addImage(image: pi)
                                    self.viewModel.notification = "🎉 Object successfully saved to your inventory!"
                                } label: {
                                    ZStack {
                                        Text(Image(systemName: "square.and.arrow.down")).foregroundColor(Color.init(UIColor.init(named: "text")!)) + Text(" Save").foregroundColor(Color.init(UIColor.init(named: "text")!)).bold()
                                    }.padding(8)
                                        .background(Color.init(UIColor.init(named: "background")!))
                                        .cornerRadius(12)
                                }
                                
                            }.padding(16)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                }
                .padding(16)
            }
            .frame(width: UIScreen.main.bounds.width, height: Util.getWidgetSize(size: "large").height + 2*16)
            .tabViewStyle(PageTabViewStyle())
            }
            .fullScreenCover(isPresented: $viewModel.isPresentingImagePicker, content: {
                ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
            })
        }
        
        @ViewBuilder
        func imageView(for image: UIImage?) -> some View {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
            }
            else {
                Text("No image selected")
            }
        }
        
        func controlBar() -> some View {
            VStack {
                HStack() {
                    Button.init {
                        viewModel.choosePhoto()
                    } label: {
                        ZStack {
                            Text(Image(systemName: "photo")).foregroundColor(Color.init(UIColor.init(named: "text")!)) + Text(" Choose Photo").foregroundColor(Color.init(UIColor.init(named: "text")!)).bold()
                        }.padding(8)
                            .background(Color.init(UIColor.init(named: "light-background")!))
                            .cornerRadius(12)
                    }

                    /*
                    Button(action: viewModel.takePhoto, label: {
                        Text("Take a Photo")
                    })
                    */
                        
                    Button.init {
                        viewModel.pixelate()
                    } label: {
                        ZStack {
                            Text(Image(systemName: "paintbrush.fill")).foregroundColor(Color.init(UIColor.init(named: "text")!)) + Text(" Pixelate!").foregroundColor(Color.init(UIColor.init(named: "text")!)).bold()
                        }.padding(8)
                            .background(Color.init(UIColor.init(named: "light-background")!))
                            .cornerRadius(12)
                    }
                }.padding()
            }
        }
}

extension CreateObjectView {
    final class ViewModel: ObservableObject {
        @Published var selectedImage: UIImage?
        @Published var bgRemovedImage: UIImage?
        @Published var pixelatedImages: [UIImage] = []
        @Published var isPresentingImagePicker = false
        
        @Published var loadingPixelatedImages = false
        
        @Published var notification = "For the best results, you should use images where the object is alone and the background has been removed. You can use https://remove.bg to make your photos ready!"

        
        private(set) var sourceType: ImagePicker.SourceType = .camera
    
        func pixelate() {
            let resizedImage = Util.resizeImage(image: self.selectedImage!, targetSize: CGSize.init(width: 512, height: 512))
            
            self.bgRemovedImage = resizedImage
            
            let imageBase64String = resizedImage!.jpegData(compressionQuality: 0.5)?.base64EncodedString()
                        loadingPixelatedImages = true
                        Util.requestPixelatedImage(base64: imageBase64String!) { (pixel_images) in
                            Purchase_CreateUserObject().decreaseTrials()
                            self.pixelatedImages = pixel_images
                            self.loadingPixelatedImages = false
                        }
        }
        
        func choosePhoto() {
            sourceType = .photoLibrary
            isPresentingImagePicker = true
        }
        
        func takePhoto() {
            sourceType = .camera
            isPresentingImagePicker = true
        }
        
        func didSelectImage(_ image: UIImage?) {
            self.selectedImage = image
            
            let resizedImage = Util.resizeImage(image: self.selectedImage!, targetSize: CGSize.init(width: 512, height: 512))
            
            self.bgRemovedImage = resizedImage
            
            isPresentingImagePicker = false
        }
    }
}

struct CreateObjectView_Previews: PreviewProvider {
    static var previews: some View {
        CreateObjectView()
            .previewDevice("iPhone 12 Pro Max")
    }
}
