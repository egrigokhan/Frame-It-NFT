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
    
    @Binding var shouldTakeScreenshot: Bool
    @Binding var screenshot: UIImage
    
    @ObservedObject var state: ShelfBuildViewState
        
    @Binding var notification: String
    
    @Binding var isSpectatorsOn: Bool

    var CanvasView: some View {
        ZStack {
            self.state.backgroundColor
                .frame(width: Util.getWidgetSize(size: widgetType).width, height: Util.getWidgetSize(size: widgetType).height, alignment: .center)
                .clipped()

            if(isSpectatorsOn) {
                VStack {
                    Spacer().frame(height: Util.getWidgetSize(size: widgetType).height - 32, alignment: .center)
                    ChildView.init(type: .FLOOR, colorComponents: [], offset: .zero, scale: 1.0, imageView: UIImage.init(named: "floor")!, imagePath: "floor").frame(height: 32, alignment: .center)
                }
            }
            ForEach(self.state.shelfViews) { view in
                view
                    // .shadow(radius: 1, x: 0, y: 5)
                    // .shadow(radius: 1, x: 1, y: 0)
                    // .shadow(radius: 1, x: -1, y: 0)
                    .gesture(TapGesture(count: 2)
                                .onEnded({ value in
                                    self.state.shelfViews = self.state.shelfViews.filter { $0.id != view.id }
                    }))
            }
        }
        .frame(width: Util.getWidgetSize(size: widgetType).width, height: Util.getWidgetSize(size: widgetType).height, alignment: .center)
        .clipped()
        .onLongPressGesture {
                let shelfie = self.body.snapshot()
            
                // notification = "📸 Saved your shelfie to your library!"
                        
            let av = UIActivityViewController(activityItems: ["Check out my gallery on Frame It!, available on the iOS App Store! #museumvibes #frameit", shelfie, URL(string: "https://apps.apple.com/us/app/shelf-life/id1574161725")], applicationActivities: nil)
            
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

        }.onChange(of: shouldTakeScreenshot) { value in
            if(self.shouldTakeScreenshot == true) {
                self.screenshot = self.body.snapshot()
                self.shouldTakeScreenshot = false
            }
        } // .offset(x: 0, y: -24)
        }
    
    @State var tempImg: Image = Image("")
    
    
    var body: some View {
            CanvasView
                .frame(width: Util.getWidgetSize(size: widgetType).width, height: Util.getWidgetSize(size: widgetType).height)
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
    
    @State var notification: String = "Double click art works to remove them. \n Press and hold to immortalize your gallery."
    
    @State var shelfActivated: Bool = true
    
    @State var shouldTakeScreenshot: Bool = false
    @State var screenshot: UIImage = UIImage()
    
    @State var isSpectatorsOn: Bool = false
    
    @State var selectedCollectionIndex: Int = 0
    @State var selectedCollection: [String:Any] = ["title": "All", "views": Inventory().objectImageViews]

    var refresh: () -> Void
    
    @State var id = UUID()
    
    var body: some View {
        VStack {
            Spacer()
            Text(self.notification)
                .bold()
                .multilineTextAlignment(.center)
                .font(Font.system(size: 12))
            
            ShelfCanvasView(widgetType: self.$widgetType, widgetVariant: self.$widgetVariant, shouldTakeScreenshot: self.$shouldTakeScreenshot, screenshot: self.$screenshot, state: self.state, notification: self.$notification, isSpectatorsOn: self.$isSpectatorsOn)
                .onChange(of: screenshot) { value in
                if(value != nil) {
                    var shelfStates: [TransferState] = []
                    
                    self.state.shelfViews = self.state.shelfViews
                    self.state.backgroundColor = self.state.backgroundColor
                    
                    if(self.state.backgroundColor != nil) {
                        var ts_ = TransferState.init(id: "background-color", isColor: true, colorRGB: (self.state.backgroundColor.state.colorComponents), offset: CGPoint.zero, scale: -1, imageData: Data.init(), imagePath: nil)
                        ts_.clean()
                        shelfStates.append(ts_) // imageData: Data.init()))
                    }
                    
                    for v in self.state.shelfViews {
                        var ts_ = TransferState.init(id: v.id.uuidString, offset: v.state.offset, scale: v.state.scale, imageData: v.state.imageView.jpegData(compressionQuality: 0.3)!, imagePath: v.state.imagePath)
                        ts_.clean()
                        shelfStates.append(ts_) // imageData: Data.init()))
                    }
                    
                    self.shouldTakeScreenshot = true
                    
                    // shelfStates.append(TransferState.init(id: "thumbnail", offset: CGPoint.zero, scale: -1, imageData: value.jpegData(compressionQuality: 0.3)!))
                    
                    UserDefaultsFunctions.addTimelineObject(key: "widget_timeline_" + self.widgetType + self.widgetVariant, value: ["thumbnail": [TransferState.init(id: "thumbnail", offset: CGPoint.zero, scale: 1, imageData: value.jpegData(compressionQuality: 0.3)!, imagePath: nil)], "ts": shelfStates], index: state.timelineIndex)
                    
                    self.shouldTakeScreenshot = false
                    
                    self.notification = "🎉 Your shelf should now be updated!"
                    self.id = UUID()
                    
                    self.refresh()
                    
                    WidgetCenter.shared.reloadTimelines(ofKind: "Widgets") // WidgetCenter.shaared.reloadAllTimelines()
                }
            }
            
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
                        self.shouldTakeScreenshot = true
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
            if(isSpectatorsOn) {
                HStack {
                    ZStack {
                        HStack {
                            Text("Spectators")
                                .bold()
                                .foregroundColor(Color.init("text"))
                                .font(Font.init(UIFont.systemFont(ofSize: 16, weight: .bold)))
                            Image(systemName: "arrowtriangle.down.fill").resizable().frame(width: 10, height: 7, alignment: .center).foregroundColor(Color.init("text"))
                        }.padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                    }
                    Spacer()
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(inventory.spectatorObjectImageViews, id: \.id) { view in
                            view.gesture(TapGesture()
                                            .onEnded({ value in
                                                self.state.shelfViews.append(ChildView.init(type: .SPECTATOR, colorComponents: [], offset: .zero, scale: 1.0, imageView: view.imageView, imagePath: view.imagePath))
                            }))
                        }
                    }
                }
            }
            if(!isSpectatorsOn) {
                HStack {
                    ZStack {
                        HStack {
                            Text(selectedCollection["title"] as! String)
                                .bold()
                                .foregroundColor(Color.init("text"))
                                .font(Font.init(UIFont.systemFont(ofSize: 16, weight: .bold)))
                            Image(systemName: "arrowtriangle.down.fill").resizable().frame(width: 10, height: 7, alignment: .center).foregroundColor(Color.init("text"))
                        }.padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                    }
                    .onTapGesture {
                        self.selectedCollectionIndex += 1
                        self.selectedCollectionIndex = self.selectedCollectionIndex % (inventory.collectionImageViews.count + 1)
                        
                        if(self.selectedCollectionIndex == 0) {
                            self.selectedCollection = ["title": "All", "views": inventory.objectImageViews]
                        } else {
                            self.selectedCollection = ["title": inventory.collectionImageViews[self.selectedCollectionIndex - 1].collectionTitle, "views": inventory.collectionImageViews[self.selectedCollectionIndex - 1].collectionImageViews]
                        }
                    }
                    Spacer()
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(selectedCollection["views"] as! [InventoryImageView], id: \.id) { view in
                            view
                                .gesture(TapGesture()
                                            .onEnded({ value in
                                                self.state.shelfViews.append(ChildView.init(type: .IMAGE, colorComponents: [], offset: .zero, scale: 1.0, imageView: view.imageView, imagePath: view.imagePath))
                            }))
                        }
                    }
                }
            }
            
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
                            self.state.backgroundColor = ChildView.init(type: .COLOR, colorComponents: (Util.BACKGROUND_COLORS[i].cgColor?.components!)!, offset: .zero, scale: 1.0, imageView: UIImage(), imagePath: nil)
                        }
                    }
                }
            }
        }.padding(16)
        .onChange(of: self.widgetType) { _ in
            print("TESTING")
            self.state.shelfViews = Array((UserDefaultsFunctions.readObject(key: "widget_\(widgetType)\(widgetVariant)") as! [String:[ChildView]])["cv"]![1...])
            self.state.backgroundColor = ((UserDefaultsFunctions.readObject(key: "widget_\(widgetType)\(widgetVariant)") as! [String:[ChildView]])["cv"]![0])
        }
        .onChange(of: self.widgetVariant) { _ in
            self.state.shelfViews = Array((UserDefaultsFunctions.readObject(key: "widget_\(widgetType)\(widgetVariant)") as! [String:[ChildView]])["cv"]![1...])
            self.state.backgroundColor = ((UserDefaultsFunctions.readObject(key: "widget_\(widgetType)\(widgetVariant)") as! [String:[ChildView]])["cv"]![0])
        }.toolbar {
            Toggle.init("Spectators", isOn: self.$isSpectatorsOn).font(Font(UIFont.systemFont(ofSize: 16, weight: .bold)))
        }
    }
}

struct ShelfBuildView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        }
    }
}
