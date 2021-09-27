//
//  ShelfBuildView.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 19.06.2021.
//

import SwiftUI
import UIKit
import WidgetKit

struct ShelfCanvasView: View {
    @Binding var widgetType: String
    @Binding var widgetVariant: String
    // @Binding var views: [ChildView]
    // @Binding var backgroundColor: ChildView
    
    @ObservedObject var state: ShelfBuildViewState
        
    @Binding var notification: String

    var CanvasView: some View {
        ZStack {
            self.state.backgroundColor
            Image("shelf_\(self.widgetType)\(self.widgetVariant)")
                .interpolation(.none)
                .resizable()
                .frame(width: Util.getWidgetSize(size: widgetType).width, height: Util.getWidgetSize(size: widgetType).height, alignment: .center)
            ForEach(self.state.shelfViews) { view in
                view
                    .shadow(radius: 1, x: 0, y: 5)
                    .shadow(radius: 1, x: 1, y: 0)
                    .shadow(radius: 1, x: -1, y: 0)
                    .gesture(TapGesture(count: 2)
                                .onEnded({ value in
                                    self.state.shelfViews = self.state.shelfViews.filter { $0.id != view.id }
                    }))
            }
        }.onLongPressGesture {
                let shelfie = self.body.snapshot()
            
                // notification = "📸 Saved your shelfie to your library!"
                        
            let av = UIActivityViewController(activityItems: ["Check out my awesome shelf on Shelf-Life, available on the iOS App Store! #shelflife", shelfie, URL(string: "https://apps.apple.com/us/app/shelf-life/id1574161725")], applicationActivities: nil)
            
            av.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                
                if !completed {
                    // User canceled
                    return
                }
                // User completed activity
                if (activityType == UIActivity.ActivityType.postToTwitter || activityType == UIActivity.ActivityType.postToFacebook) {
                    Purchase_CreateUserObject().addTrials()
                }
            }

            
                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)

        } // .offset(x: 0, y: -24)
        }
    
    @State var tempImg: Image = Image("")
    
    
    var body: some View {
            CanvasView
                .frame(width: Util.getWidgetSize(size: widgetType).width, height: Util.getWidgetSize(size: widgetType).height)
            tempImg
    }
    
    func buildView(views: [AnyView], index: Int) -> AnyView {
        return views[index]
    }
}

struct ShelfBuildView: View {
    
    // @State var shelfViews: [ChildView] = []
    // @State var backgroundColor: ChildView = ChildView.init(type: .COLOR, colorComponents: UIColor.clear.cgColor.components!, offset: .zero, scale: 1.0, imageView: UIImage.init())
    
    @ObservedObject var state: ShelfBuildViewState
    
    @Binding var widgetType: String
    @Binding var widgetVariant: String
    
    @StateObject var inventory: Inventory = Inventory()
    
    @State var notification: String = "Double click objects to remove them. \n Press and hold to take a shelfie."
    
    @State var shelfActivated: Bool = true
    
    @State var id = UUID()
    
    var body: some View {
        VStack {
            Spacer()
            Text(self.notification)
                .bold()
                .multilineTextAlignment(.center)
                .font(Font.system(size: 12))
            
            ShelfCanvasView(widgetType: self.$widgetType, widgetVariant: self.$widgetVariant, state: self.state, notification: self.$notification)
            
            VStack {
                HStack {
                    Button.init {
                        self.state.shelfViews = []
                    } label: {
                        ZStack {
                            Text(Image(systemName: "xmark")).foregroundColor(Color.init(UIColor.init(named: "text")!)) + Text(" Clear").foregroundColor(Color.init(UIColor.init(named: "text")!)).bold()
                        }.padding(8)
                            .background(Color.init(UIColor.init(named: "light-background")!))
                            .cornerRadius(12)
                    }
                    
                    Button.init {
                        var shelfStates: [TransferState] = []
                        
                        self.state.shelfViews = self.state.shelfViews
                        self.state.backgroundColor = self.state.backgroundColor
                        
                        if(self.state.backgroundColor != nil) {
                            shelfStates.append(TransferState.init(id: "background-color", isColor: true, colorRGB: (self.state.backgroundColor.state.colorComponents), offset: CGPoint.zero, scale: -1, imageData: Data.init()))
                        }
                        
                        for v in self.state.shelfViews {
                            shelfStates.append(TransferState.init(id: v.id.uuidString, offset: v.state.offset, scale: v.state.scale, imageData: v.state.imageView.pngData()!))
                        }
                        UserDefaultsFunctions.saveObject(key: "widget_" + self.widgetType + self.widgetVariant, value: shelfStates)
                        
                        self.notification = "🎉 Your shelf should now be updated!"
                        self.id = UUID()
                        
                        DispatchQueue.main.async {
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                    } label: {
                        ZStack {
                            Text(Image(systemName: "square.and.arrow.down")).foregroundColor(Color.init(UIColor.init(named: "text")!)) + Text(" Save").foregroundColor(Color.init(UIColor.init(named: "text")!)).bold()
                        }.padding(8)
                            .background(Color.init(UIColor.init(named: "light-background")!))
                            .cornerRadius(12)
                    }
                }
            }
            
            Spacer()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<Util.BACKGROUND_COLORS.count) {i in
                        ZStack {
                            Color.init("light-background")
                            Util.BACKGROUND_COLORS[i]
                                .frame(width: 24, height: 24, alignment: Alignment.center)
                                .cornerRadius(6)
                        }
                        .frame(width: 32, height: 32, alignment: .center)
                        .cornerRadius(8)
                        .onTapGesture {
                            self.state.backgroundColor = ChildView.init(type: .COLOR, colorComponents: (Util.BACKGROUND_COLORS[i].cgColor?.components!)!, offset: .zero, scale: 1.0, imageView: UIImage())
                        }
                    }
                }
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(inventory.objectImageViews, id: \.id) { view in
                        view.gesture(TapGesture()
                                        .onEnded({ value in
                                            self.state.shelfViews.append(ChildView.init(type: .IMAGE, colorComponents: [], offset: .zero, scale: 1.0, imageView: view.imageView))
                        }))
                    }
                }
            }
        }.padding(16)
        .onChange(of: self.widgetType) { _ in
            print("TESTING")
            self.state.shelfViews = Array(UserDefaultsFunctions.readObject(key: "widget_\(widgetType)\(widgetVariant)")[1...])
            self.state.backgroundColor = (UserDefaultsFunctions.readObject(key: "widget_\(widgetType)\(widgetVariant)")[0])
        }
        .onChange(of: self.widgetVariant) { _ in
            self.state.shelfViews = Array(UserDefaultsFunctions.readObject(key: "widget_\(widgetType)\(widgetVariant)")[1...])
            self.state.backgroundColor = (UserDefaultsFunctions.readObject(key: "widget_\(widgetType)\(widgetVariant)")[0])
        }
    }
}

struct ShelfBuildView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        }
    }
}
