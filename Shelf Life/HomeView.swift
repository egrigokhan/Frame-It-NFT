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

struct ShelfTimelineHorizontalScrollItem_SMALL: View {
    
    @ObservedObject var state: ShelfBuildViewState
    @State var thumbnail: UIImage
    
    @State var widgetType: String = "small"
    @State var widgetVariant: String = "begroovyorleaveman"
    @State var timelineIndex: Int
    
    var body: some View {
        NavigationLink(destination: ShelfBuildView.init(state: state, widgetType: self.$widgetType, widgetVariant: self.$widgetVariant)) {
            ZStack {
                // Color.init("light-background")
                            Image.init(uiImage: thumbnail).resizable().scaledToFit()
                        }.frame(width: Util.getWidgetSize(size: "small").width, height: Util.getWidgetSize(size: "small").height)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
        }
    }

struct ShelfTimelineHorizontalScroll_SMALL: View {
        
    @State var TIMELINE_SMALL = UserDefaultsFunctions.readTimelineObject(key: "widget_timeline_smallbegroovyorleaveman")
    
    @State var widgetType: String = "small"
    @State var widgetVariant: String = "begroovyorleaveman"
    
    @State var dummyRefresh = true
    
    // @State var state: ShelfBuildViewState = ShelfBuildViewState.init(widgetType: "small", shelfVariant: "begroovyorleaveman", )
    
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
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ZStack {
                        HStack {
                            Image.init(systemName: "plus")
                        }
                        .padding(16)
                        VStack {
                                HStack {
                                    Spacer()
                                    VStack {
                                        HStack {
                                            buildNavigationLink(destination: ShelfBuildView.init(state: ShelfBuildViewState.init(widgetType: "small", shelfVariant:  "begroovyorleaveman", shelfViews: [], thumbnailImage: UIImage.init(), timelineIndex: -1), widgetType: self.$widgetType, widgetVariant: self.$widgetVariant))
                                        }
                                    }

                                }.offset(x: -16, y: 16)
                            Spacer()
                        }
                    }.frame(width: 16, height: Util.getWidgetSize(size: "small").height)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    ForEach(0..<self.TIMELINE_SMALL.count) { index in
                        ShelfTimelineHorizontalScrollItem_SMALL(state: ShelfBuildViewState.init(widgetType: "small", shelfVariant:  "begroovyorleaveman", shelfViews: self.TIMELINE_SMALL[index]["cv"]!, thumbnailImage: self.TIMELINE_SMALL[index]["thumbnail"]![0].state.imageView, timelineIndex: index), thumbnail: self.TIMELINE_SMALL[index]["thumbnail"]![0].state.imageView, timelineIndex: index)
                    }
                }
                }
                .tabViewStyle(PageTabViewStyle())
        }
    }
}

struct ShelfTimelineHorizontalScrollItem_MEDIUM: View {
    
    @ObservedObject var state: ShelfBuildViewState
    @State var thumbnail: UIImage
    
    @State var widgetType: String = "medium"
    @State var widgetVariant: String = "begroovyorleaveman"
    @State var timelineIndex: Int
    
    var body: some View {
        NavigationLink(destination: ShelfBuildView.init(state: state, widgetType: self.$widgetType, widgetVariant: self.$widgetVariant)) {
            ZStack {
                // Color.init("light-background")
                            Image.init(uiImage: thumbnail).resizable().scaledToFit()
                        }.frame(width: Util.getWidgetSize(size: "medium").width, height: Util.getWidgetSize(size: "medium").height)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
        }
    }

struct ShelfTimelineHorizontalScroll_MEDIUM: View {
        
    @State var TIMELINE_SMALL = UserDefaultsFunctions.readTimelineObject(key: "widget_timeline_mediumbegroovyorleaveman")
    
    @State var widgetType: String = "medium"
    @State var widgetVariant: String = "begroovyorleaveman"
    
    @State var dummyRefresh = true
    
    // @State var state: ShelfBuildViewState = ShelfBuildViewState.init(widgetType: "small", shelfVariant: "begroovyorleaveman", )
    
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
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ZStack {
                        HStack {
                            Image.init(systemName: "plus")
                        }
                        .padding(16)
                        VStack {
                                HStack {
                                    Spacer()
                                    VStack {
                                        HStack {
                                            buildNavigationLink(destination: ShelfBuildView.init(state: ShelfBuildViewState.init(widgetType: "medium", shelfVariant:  "begroovyorleaveman", shelfViews: [], thumbnailImage: UIImage.init(), timelineIndex: -1), widgetType: self.$widgetType, widgetVariant: self.$widgetVariant))
                                        }
                                    }

                                }.offset(x: -16, y: 16)
                            Spacer()
                        }
                    }.frame(width: 16, height: Util.getWidgetSize(size: "medium").height)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    ForEach(0..<self.TIMELINE_SMALL.count) { index in
                        ShelfTimelineHorizontalScrollItem_MEDIUM(state: ShelfBuildViewState.init(widgetType: "medium", shelfVariant:  "begroovyorleaveman", shelfViews: self.TIMELINE_SMALL[index]["cv"]!, thumbnailImage: self.TIMELINE_SMALL[index]["thumbnail"]![0].state.imageView, timelineIndex: index), thumbnail: self.TIMELINE_SMALL[index]["thumbnail"]![0].state.imageView, timelineIndex: index)
                    }
                }
                }
                .tabViewStyle(PageTabViewStyle())
        }
    }
}

struct ShelfTimelineHorizontalScrollItem_LARGE: View {
    
    @ObservedObject var state: ShelfBuildViewState
    @State var thumbnail: UIImage
    
    @State var widgetType: String = "large"
    @State var widgetVariant: String = "begroovyorleaveman"
    @State var timelineIndex: Int
    
    var body: some View {
        NavigationLink(destination: ShelfBuildView.init(state: state, widgetType: self.$widgetType, widgetVariant: self.$widgetVariant)) {
            ZStack {
                // Color.init("light-background")
                            Image.init(uiImage: thumbnail).resizable().scaledToFit()
                        }.frame(width: Util.getWidgetSize(size: "large").width, height: Util.getWidgetSize(size: "large").height)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
        }
    }

struct ShelfTimelineHorizontalScroll_LARGE: View {
        
    @State var TIMELINE_SMALL = UserDefaultsFunctions.readTimelineObject(key: "widget_timeline_largebegroovyorleaveman")
    
    @State var widgetType: String = "large"
    @State var widgetVariant: String = "begroovyorleaveman"
    
    @State var dummyRefresh = true
    
    // @State var state: ShelfBuildViewState = ShelfBuildViewState.init(widgetType: "small", shelfVariant: "begroovyorleaveman", )
    
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
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ZStack {
                        HStack {
                            Image.init(systemName: "plus")
                        }
                        .padding(16)
                        VStack {
                                HStack {
                                    Spacer()
                                    VStack {
                                        HStack {
                                            buildNavigationLink(destination: ShelfBuildView.init(state: ShelfBuildViewState.init(widgetType: "large", shelfVariant:  "begroovyorleaveman", shelfViews: [], thumbnailImage: UIImage.init(), timelineIndex: -1), widgetType: self.$widgetType, widgetVariant: self.$widgetVariant))
                                        }
                                    }

                                }.offset(x: -16, y: 16)
                            Spacer()
                        }
                    }.frame(width: 16, height: Util.getWidgetSize(size: "large").height)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    ForEach(0..<self.TIMELINE_SMALL.count) { index in
                        ShelfTimelineHorizontalScrollItem_LARGE(state: ShelfBuildViewState.init(widgetType: "large", shelfVariant:  "begroovyorleaveman", shelfViews: self.TIMELINE_SMALL[index]["cv"]!, thumbnailImage: self.TIMELINE_SMALL[index]["thumbnail"]![0].state.imageView, timelineIndex: index), thumbnail: self.TIMELINE_SMALL[index]["thumbnail"]![0].state.imageView, timelineIndex: index)
                    }
                }
                }
                .tabViewStyle(PageTabViewStyle())
        }
    }
}


struct HomeView: View {
    
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
                        // Text("Small").bold()
                        ShelfTimelineHorizontalScroll_SMALL()
                        Spacer(minLength: 12)
                        // Text("Medium").bold().multilineTextAlignment(.leading)
                        ShelfTimelineHorizontalScroll_MEDIUM()
                        Spacer(minLength: 12)
                        // Text("Large").bold()
                        ShelfTimelineHorizontalScroll_LARGE()
                        Spacer(minLength: 12)
                        // InventoryGridView(showingPurchaseAlert: self.$showingPurchaseAlert)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateObjectView()
            .previewDevice("iPhone 12 Pro Max")
    }
}
