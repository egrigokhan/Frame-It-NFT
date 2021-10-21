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

struct InventoryGridView: View {
        
    // @StateObject var inventory: Inventory = Inventory()
    @Binding var imageViews: [InventoryImageView]
    
    let layout = [
        GridItem(.adaptive(minimum: 80, maximum: 120))
    ]
    
    @State private var showingAlert = false
    
    @Binding var showingPurchaseAlert: Bool
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(
                    columns: layout,
                    spacing: 20
                ) {
                    
                    ForEach(imageViews) { item in
                                ZStack {
                                    Color.init(UIColor.init(named: "light-background")!)
                                    Image(uiImage: item.imageView)
                                        .interpolation(.none)
                                        .resizable()
                                        .scaledToFill()
                                        // .padding()
                                        .layoutPriority(-1)
                                    
                                }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            .frame(width: 80, height: 80, alignment: Alignment.center)
                        }
                }.padding(.all, 16)
            }
        }
    }
}


struct VaultView: View {
    
    @State private var showingPurchaseAlert = false
    @State var inventoryImageViews: [InventoryImageView]
    @State var item: CollectionRowView
        
    @State private var showImagePicker: Bool = false
    
    @Binding var refresh: Bool
    
    /*
    init(inventoryImageViews: [InventoryImageView], item: CollectionRowView) {
        // if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene) }
        self.inventoryImageViews = inventoryImageViews
        self.item = item
    }
    */
    var body: some View {
        ZStack {
                ScrollView {
                    VStack {
                        InventoryGridView(imageViews: self.$inventoryImageViews, showingPurchaseAlert: self.$showingPurchaseAlert)
                    }
                }.padding(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
            // .navigationViewStyle(StackNavigationViewStyle.init())
                
            // Purchase_CreateUserObject_POPUP.init(title: "Create your own objects", message: "Test", buttonText: "Buy ($0.99)", show: self.$showingPurchaseAlert)

        }.navigationBarTitle(Text(item != nil ? item.collectionTitle : "").bold())
        .toolbar {
            ZStack {
                Color.init(UIColor.init(named: "light-background")!)
                Button("Add Item") {
                    self.showImagePicker.toggle()
                }
                .foregroundColor(Color.init(UIColor.init(named: "text")!))
            }
    }
        .sheet(isPresented: self.$showImagePicker, onDismiss: {
    }, content: {
        FrameItImagePicker(sourceType: .photoLibrary) { image in
            if(image != nil) {
                /*
                let dictionary = UserDefaults(suiteName: "group.shelf-life")!.dictionaryRepresentation()
                dictionary.keys.forEach { key in
                    UserDefaults(suiteName: "group.shelf-life")!.removeObject(forKey: key)
                }
                UserDefaults.standard.removeSuite(named: "group.shelf-life")
                */
                Inventory.addImageToCollection(image: image, collectionId: self.item.collectionId)
                refresh.toggle()
            }
            self.showImagePicker.toggle()
        }
    })
    }
}

struct VaultView_Previews: PreviewProvider {
    static var previews: some View {
        CreateObjectView()
            .previewDevice("iPhone 12 Pro Max")
    }
}
