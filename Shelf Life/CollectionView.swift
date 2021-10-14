//
//  ContentView.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 19.06.2021.
//

import SwiftUI
import WidgetKit
import StoreKit
import Photos

struct CollectionGridView: View {
        
    @State var inventory: Inventory = Inventory()
    
    @State var refresh: Bool = false
    
    let layout = [
        GridItem(.adaptive(minimum: 1000))
    ]
    
    @State private var showingAlert = false
    
    @Binding var showingPurchaseAlert: Bool
    
    @ViewBuilder
    func buildCollectionViewImageView(item: CollectionRowView) -> some View {
        HStack {
            Image(uiImage: item.collectionImageViews[0].imageView)
                .interpolation(.none)
                .resizable()
                .scaledToFill()
                .layoutPriority(-1)
                .frame(width: 100, height: 100, alignment: Alignment.center)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            ForEach(0..<4) { v in
                VStack {
                    if(item.collectionImageViews.count == 2*v + 2) {
                        Image(uiImage: item.collectionImageViews[2*v + 1].imageView)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFill()
                            .layoutPriority(-1)
                            .frame(width: 45, height: 45, alignment: Alignment.center)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        Spacer()
                    }
                    if(item.collectionImageViews.count >= 2*v + 3) {
                        Image(uiImage: item.collectionImageViews[2*v + 1].imageView)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFill()
                            .layoutPriority(-1)
                            .frame(width: 45, height: 45, alignment: Alignment.center)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        Image(uiImage: item.collectionImageViews[2*v + 2].imageView)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFill()
                            .layoutPriority(-1)
                            .frame(width: 45, height: 45, alignment: Alignment.center)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    }
                }
            }
 
            Spacer()
        }
    }
    
    @ViewBuilder
    func buildCollectionView(item: CollectionRowView) -> some View {
        ZStack {
            Color.init(UIColor.init(named: "light-background")!)
            VStack {
                HStack {
                    Text(item.collectionTitle)
                        .foregroundColor(Color.init(UIColor.init(named: "text")!))
                        .font(Font.init(UIFont.systemFont(ofSize: 20, weight: .bold)))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text(String((item.collectionImageViews).count))
                        .foregroundColor(Color.init(UIColor.init(named: "text")!))
                        .font(Font.init(UIFont.systemFont(ofSize: 12, weight: .bold)))
                        .multilineTextAlignment(.trailing)
                }
                buildCollectionViewImageView(item: item)
            }
            .padding(16)
            
        }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .frame(alignment: Alignment.leading)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(
                    columns: layout,
                    spacing: 20
                ) {
                    ForEach(inventory.collectionImageViews, id: \.id) { item in
                        NavigationLink(destination: VaultView.init(inventoryImageViews: item.collectionImageViews, item: item, refresh: self.$refresh)) {
                            buildCollectionView(item: item)
                        }
                    }.onDelete(perform: { indexSet in
                        print("delete")
                    })
                }.padding(.all, 16)
            }
        }.onChange(of: self.refresh) { _ in
            self.inventory = Inventory()
        }
    }
}


struct CollectionView: View {
    
    @State private var showSheet = false
    @State private var showImagePicker: Bool = false

    @State private var showingPurchaseAlert = false
    
    @State private var addCollectionTitle: String = ""
    @State private var addCollectionImage: UIImage?
    
    init() {
        // if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene) }
    }

    var body: some View {
        ZStack {
                ScrollView {
                    VStack {
                        CollectionGridView(showingPurchaseAlert: self.$showingPurchaseAlert)
                    }
                }.padding(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            Purchase_CreateUserObject_POPUP.init(title: "Create your own objects", message: "Test", buttonText: "Buy ($0.99)", show: self.$showingPurchaseAlert)
        }.navigationBarTitle(Text("Vault").bold())
        .toolbar {
            ZStack {
                Color.init(UIColor.init(named: "light-background")!)
                Button("Add Collection") {
                    print("add")
                    self.showSheet = true
                }
                .foregroundColor(Color.init(UIColor.init(named: "text")!))
            }
        }
        .sheet(isPresented: self.$showImagePicker, onDismiss: {
            self.showImagePicker.toggle()
        }, content: {
            FrameItImagePicker(sourceType: .photoLibrary) { image in
                if(image != nil) {
                    self.addCollectionImage = image
                }
                self.showImagePicker.toggle()
            }
        }).sheet(isPresented: self.$showSheet, content: {
            ZStack {
                Color.init("background")
                VStack {
                    HStack {
                        Text("Add Collection")
                            .foregroundColor(Color.init(UIColor.init(named: "text")!))
                            .font(Font.init(UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.bold))).multilineTextAlignment(.leading).padding(EdgeInsets.init(top: 0, leading: 0, bottom: 16, trailing: 0))
                        Spacer()
                    }
                    TextField("Collection Title", text: self.$addCollectionTitle).padding(EdgeInsets.init(top: 16, leading: 16, bottom: 16, trailing: 16))
                        .background(Color.init("light-background")).cornerRadius(12)
                    ZStack {}.frame(height: 16, alignment: .center)
                    // Spacer(minLength: 200)
                    ZStack {
                        Color.init(UIColor.init(named: "light-background")!)
                        VStack {
                            HStack {
                                Text(self.addCollectionTitle != "" ? self.addCollectionTitle : "Your awesome collection")
                                    .font(Font.init(UIFont.systemFont(ofSize: 20, weight: .bold)))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if(self.addCollectionImage != nil) {
                                    Text("1")
                                        .bold()
                                        .font(Font.init(UIFont.systemFont(ofSize: 12)))
                                        .multilineTextAlignment(.trailing)
                                } else {
                                    Text("0")
                                        .bold()
                                        .font(Font.init(UIFont.systemFont(ofSize: 12)))
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                            HStack {
                                ZStack {
                                    Color("background")
                                    if(self.addCollectionImage != nil) {
                                        Image(uiImage: self.addCollectionImage!)
                                            .interpolation(.none)
                                            .resizable()
                                            .scaledToFill()
                                            .layoutPriority(-1)
                                    } else {
                                        Image.init(systemName: "plus")
                        .renderingMode(.template)
                                            .interpolation(.none)
                                            .resizable()
                                            .scaledToFill()
                                            .layoutPriority(-1)
                                            .padding(32)
                                            .foregroundColor(Color.init(UIColor.init(named: "text")!))
                                    }
                                }.frame(width: 100, height: 100, alignment: Alignment.center)
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                .onTapGesture {
                                    self.showImagePicker.toggle()
                                }
                                Spacer()
                            }
                        }
                        .padding(16)
                        
                    }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    Button("Looks good!") {
                        Inventory().addCollection(collection: CollectionRowView.init(collectionId: addCollectionTitle, collectionTitle: addCollectionTitle, collectionPaths: [], collectionImageViews: []), image: addCollectionImage!)

                    }.disabled(!(addCollectionTitle != "" && addCollectionImage != nil))
                .frame(alignment: Alignment.leading)
                }.frame(height: 120, alignment: .leading)
                .padding(32)
            }
        })
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateObjectView()
            .previewDevice("iPhone 12 Pro Max")
    }
}
