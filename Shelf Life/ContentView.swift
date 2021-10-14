//
//  ContentView.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 19.06.2021.
//
/*
import SwiftUI
import WidgetKit
import StoreKit
import Photos

struct InventoryGridView: View {
    @ObservedObject var photos = PhotosModel()
    @StateObject var inventory: Inventory = Inventory()
    
    let layout = [
        GridItem(.adaptive(minimum: 120, maximum: 120))
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
                    //ForEach(inventory.objectImageViews) { item in
                    if(true) {
                        ForEach(inventory.objectImageViews) { item in
                                    ZStack {
                                        Color.init(UIColor.init(named: "light-background")!)
                                        Image(uiImage: item.imageView)
                                            .interpolation(.none)
                                            .resizable()
                                            .scaledToFit()
                                            .padding()
                                        
                                        
                                        /*
                                        HStack {
                                           Spacer()
                                            VStack {
                                                HStack {
                                                        Image(uiImage: UIImage(systemName: "staroflife.fill")!)
                                                            .renderingMode(.template)
                                                            .colorMultiply(Color.green)
                                                            .frame(width: 20, height: 20, alignment: .center)
                                                }.padding(8)
                                                Spacer()
                                            }
                                        }
                                        */
                                    }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                    .frame(width: 120, height: 120, alignment: Alignment.center)
                            }
                    }
                    

                }.padding(.all, 16)
            }
        }
    }
}

@ViewBuilder
func buildNavigationLink(destination: ShelfBuildView) -> some View {
    NavigationLink(destination: destination) {
        ZStack {
            Text(Image(systemName: "pencil")).foregroundColor(Color.init(UIColor.init(named: "text")!)) + Text(" Edit").foregroundColor(Color.init(UIColor.init(named: "text")!)).bold()
        }.padding(8)
            .background(Color.init(UIColor.init(named: "background")!))
            .cornerRadius(12)
    }
}

struct ShelfHorizontalScroll: View {
    
    @State var widgetTypes = ["small", "medium", "large"]
    
    @State var SMALL_VIEW = UserDefaultsFunctions.readObject(key: "widget_small")
    @State var MEDIUM_VIEW = UserDefaultsFunctions.readObject(key: "widget_medium")
    @State var LARGE_VIEW = UserDefaultsFunctions.readObject(key: "widget_large")
    
    @State var SHELF_VARIANTS = UserDefaultsFunctions.readVariant(key: "shelf_variants") {
        didSet {
            UserDefaultsFunctions.saveVariant(key: "shelf_variants", value: self.SHELF_VARIANTS)
        }
    }
    
    @State var shelfVariants = ["begroovyorleaveman"] // ["", "_T_2", "_3"]
    
    @State var dummyRefresh = true
    
    @ViewBuilder
    func buildShelfActivated(shelfSize: Int, shelfVariant: String) -> some View {
        
        switch shelfSize {
        case 0:
            if (self.SHELF_VARIANTS["VARIANT_SMALL"]! == shelfVariant) {

                Button(action: {
                                print("")
                            }, label: {
                                ZStack {
                                    Image(uiImage: UIImage(systemName: "checkmark.square.fill")!)
                                        .renderingMode(.template)
                                        .colorMultiply(Color.init("background"))
                                        // .foregroundColor(Color.init("background"))
                                }
                            }).buttonStyle(PlainButtonStyle())
                            .padding(8)
                            .foregroundColor(Color("background"))
                            .background(Color.blue)
                            .cornerRadius(8)
                        
            } else {
                Button(action: {
                    var variants = UserDefaultsFunctions.readVariant(key: "shelf_variants")
            
                    self.SHELF_VARIANTS["VARIANT_SMALL"] = shelfVariant
                    
                    UserDefaultsFunctions.saveVariant(key: "shelf_variants", value: self.SHELF_VARIANTS)
                    
                    var shelfStates: [TransferState] = []
                    
                    let SMALL_DICT = (UserDefaultsFunctions.readObject(key: "widget_small" + shelfVariant) as! [String:[ChildView]])["cv"]
                    
                    if(SMALL_DICT.count > 0) {
                        shelfStates.append(TransferState.init(id: "background-color", isColor: true, colorRGB: (SMALL_DICT[0].state.colorComponents), offset: CGPoint.zero, scale: -1, imageData: Data.init()))
                    }
                    
                    for v in (SMALL_DICT[1...]) {
                        shelfStates.append(TransferState.init(id: v.id.uuidString, offset: v.state.offset, scale: v.state.scale, imageData: v.state.imageView.jpegData(compressionQuality: 0.3)!))
                    }
                    UserDefaultsFunctions.saveObject(key: "widget_small" + shelfVariant, value: shelfStates)
                    WidgetCenter.shared.reloadTimelines(ofKind: "Widgets")

                    }, label: {
                                ZStack {
                                    Image(uiImage: UIImage(systemName: "checkmark.square.fill")!)
                                        .renderingMode(.template)
                                        .colorMultiply(Color.init("text"))
                                        // .foregroundColor(Color.init("background"))
                                }
                            }).buttonStyle(PlainButtonStyle())
                            .padding(8)
                            .background(Color("background"))
                            .cornerRadius(8)
            }
        case 1:
            if (self.SHELF_VARIANTS["VARIANT_MEDIUM"]! == shelfVariant) {

                Button(action: {
                                print("")
                            }, label: {
                                ZStack {
                                    Image(uiImage: UIImage(systemName: "checkmark.square.fill")!)
                                        .renderingMode(.template)
                                        .colorMultiply(Color.init("background"))
                                        // .foregroundColor(Color.init("background"))
                                }
                            }).buttonStyle(PlainButtonStyle())
                            .padding(8)
                            .foregroundColor(Color("background"))
                            .background(Color.blue)
                            .cornerRadius(8)
                        
            } else {
                Button(action: {
                            var variants = UserDefaultsFunctions.readVariant(key: "shelf_variants")
                    
                            self.SHELF_VARIANTS["VARIANT_MEDIUM"] = shelfVariant
                            
                            UserDefaultsFunctions.saveVariant(key: "shelf_variants", value: self.SHELF_VARIANTS)
                    
                    var shelfStates: [TransferState] = []
                    
                    let MEDIUM_DICT = (UserDefaultsFunctions.readObject(key: "widget_medium" + shelfVariant) as! [String:[ChildView]])["cv"]
                    
                    if(MEDIUM_DICT.count > 0) {
                        shelfStates.append(TransferState.init(id: "background-color", isColor: true, colorRGB: (MEDIUM_DICT[0].state.colorComponents), offset: CGPoint.zero, scale: -1, imageData: Data.init()))
                    }
                    
                    for v in (MEDIUM_DICT[1...]) {
                        shelfStates.append(TransferState.init(id: v.id.uuidString, offset: v.state.offset, scale: v.state.scale, imageData: v.state.imageView.jpegData(compressionQuality: 0.3)!))
                    }
                    UserDefaultsFunctions.saveObject(key: "widget_medium" + shelfVariant, value: shelfStates)
                    WidgetCenter.shared.reloadTimelines(ofKind: "Widgets")

                            }, label: {
                                ZStack {
                                    Image(uiImage: UIImage(systemName: "checkmark.square.fill")!)
                                        .renderingMode(.template)
                                        .colorMultiply(Color.init("text"))
                                        // .foregroundColor(Color.init("background"))
                                }
                            }).buttonStyle(PlainButtonStyle())
                            .padding(8)
                            .background(Color("background"))
                            .cornerRadius(8)
            }
        case 2:
            if (self.SHELF_VARIANTS["VARIANT_LARGE"]! == shelfVariant) {

                Button(action: {
                                print("")
                            }, label: {
                                ZStack {
                                    Image(uiImage: UIImage(systemName: "checkmark.square.fill")!)
                                        .renderingMode(.template)
                                        .colorMultiply(Color.init("background"))
                                        // .foregroundColor(Color.init("background"))
                                }
                            }).buttonStyle(PlainButtonStyle())
                            .padding(8)
                            .foregroundColor(Color("background"))
                            .background(Color.blue)
                            .cornerRadius(8)
                        
            } else {
                Button(action: {
                    var variants = UserDefaultsFunctions.readVariant(key: "shelf_variants")
            
                    self.SHELF_VARIANTS["VARIANT_LARGE"] = shelfVariant
                    
                    UserDefaultsFunctions.saveVariant(key: "shelf_variants", value: self.SHELF_VARIANTS)
                    
                    var shelfStates: [TransferState] = []
                    
                    let LARGE_DICT = (UserDefaultsFunctions.readObject(key: "widget_large" + shelfVariant) as! [String:[ChildView]])["cv"]
                    
                    if(LARGE_DICT!.count > 0) {
                        shelfStates.append(TransferState.init(id: "background-color", isColor: true, colorRGB: (LARGE_DICT![0].state.colorComponents), offset: CGPoint.zero, scale: -1, imageData: Data.init()))
                    }
                    
                    for v in (LARGE_DICT![1...]) {
                        shelfStates.append(TransferState.init(id: v.id.uuidString, offset: v.state.offset, scale: v.state.scale, imageData: v.state.imageView.jpegData(compressionQuality: 0.3)!))
                    }
                    UserDefaultsFunctions.saveObject(key: "widget_large" + shelfVariant, value: shelfStates)
                    
                    WidgetCenter.shared.reloadTimelines(ofKind: "Widgets")

                    }, label: {
                                HStack {
                                    Image(uiImage: UIImage(systemName: "checkmark.square.fill")!)
                                        .renderingMode(.template)
                                        .colorMultiply(Color.init("text"))
                                        // .foregroundColor(Color.init("background"))
                                }
                            }).buttonStyle(PlainButtonStyle())
                            .padding(8)
                            .background(Color("background"))
                            .cornerRadius(8)
            }
        default:
            if (self.SHELF_VARIANTS["VARIANT_LARGE"]! == shelfVariant) {

                Button(action: {
                                print("")
                            }, label: {
                                ZStack {
                                    Image(uiImage: UIImage(systemName: "checkmark.square.fill")!)
                                        .renderingMode(.template)
                                        .colorMultiply(Color.init("background"))
                                        // .foregroundColor(Color.init("background"))
                                }
                            }).buttonStyle(PlainButtonStyle())
                            .padding(8)
                            .foregroundColor(Color("background"))
                            .background(Color.blue)
                            .cornerRadius(8)
                        
            } else {
                Button(action: {
                    var variants = UserDefaultsFunctions.readVariant(key: "shelf_variants")
            
                    self.SHELF_VARIANTS["VARIANT_SMALL"] = shelfVariant
                    
                    UserDefaultsFunctions.saveVariant(key: "shelf_variants", value: self.SHELF_VARIANTS)
                    WidgetCenter.shared.reloadTimelines(ofKind: "Widgets")
                    }, label: {
                                ZStack {
                                    Image(uiImage: UIImage(systemName: "checkmark.square.fill")!)
                                        .renderingMode(.template)
                                        .colorMultiply(Color.init("text"))
                                        // .foregroundColor(Color.init("background"))
                                }
                            }).buttonStyle(PlainButtonStyle())
                            .padding(8)
                            .background(Color("background"))
                            .cornerRadius(8)
                
            }
        }
    }
    
    var body: some View {
            TabView {
                ForEach(0..<self.shelfVariants.count) {v in
                    ForEach(0..<3) { i in
                        ZStack {
                            Color.init(UIColor.init(named: "light-background")!)
                            HStack {
                                Image("shelf_\(self.widgetTypes[i])\(self.shelfVariants[v])")
                                        .interpolation(.none)
                                        .resizable()
                                        .frame(width: Util.getWidgetSize(size: widgetTypes[i]).width, height: Util.getWidgetSize(size: widgetTypes[i]).height, alignment: .center)
                                        .scaledToFit()
                            }
                            .padding(16)
                            
                            VStack {
                                    HStack {
                                        Spacer()
                                        VStack {
                                            HStack {
                                                buildNavigationLink(destination: ShelfBuildView(state: ShelfBuildViewState.init(widgetType: self.widgetTypes[i], shelfVariant:  self.shelfVariants[v]), widgetType: self.$widgetTypes[i], widgetVariant: self.$shelfVariants[v]))
                                            }
                                        }
                                        self.buildShelfActivated(shelfSize: i, shelfVariant: self.shelfVariants[v])

                                    }.offset(x: -16, y: 16)
                                Spacer()
                            }
                            
                                                        
                            
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    }
                    .padding(16)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: Util.getWidgetSize(size: "large").height + 2*16)
            .tabViewStyle(PageTabViewStyle())
        }
}

struct ContentView: View {
    
    @State private var showingPurchaseAlert = false
    
    init() {
        if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene) }

    }

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack {
                        // Text("Shelves").bold()
                        ShelfHorizontalScroll()
                        Spacer(minLength: 32)
                        Text("Inventory").bold()
                        InventoryGridView(showingPurchaseAlert: self.$showingPurchaseAlert)
                    }
                }
                .navigationBarTitle(Text("Home").bold())
                .toolbar {
                    Button("Update inventory!") {
                        Inventory().updateInventoryFromOpenSea()
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle.init())
                
            Purchase_CreateUserObject_POPUP.init(title: "Create your own objects", message: "Test", buttonText: "Buy ($0.99)", show: self.$showingPurchaseAlert)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreateObjectView()
            .previewDevice("iPhone 12 Pro Max")
    }
}
*/
