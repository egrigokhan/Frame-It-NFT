//
//  Shelf_Life_Widget.swift
//  Shelf Life Widget
//
//  Created by Gokhan Egri on 19.06.2021.
//

import WidgetKit
import SwiftUI
import Intents

import Foundation
import UIKit
import SwiftUI

/*
struct InventoryImageView: View, Identifiable {
    
    let id = UUID()
    var imageId: String {
        didSet {
            if(self.imageType == "user") {
                do {
                    var url = URL.init(fileURLWithPath: Inventory().documentsPathForFileName(name: self.imageId))
                    self.imageView = try UIImage(data: Data(contentsOf: url))!
                } catch {
                    print("Error!")
                }
            }
        }
    }
    var imageType: String = "asset" {
        didSet {
            if(self.imageType == "user") {
                do {
                    var url = URL.init(fileURLWithPath: Inventory().documentsPathForFileName(name: self.imageId))
                    self.imageView = try UIImage(data: Data(contentsOf: url))!
                } catch {
                    print("Error!")
                }
            }
        }
    }
    
    @State var imageView: UIImage
    
    var body: some View {
        switch self.imageType {
        case "asset":
            ZStack {
                Color.init(red: 0.95, green: 0.95, blue: 0.95)
                Image(imageId)
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
            }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .frame(minWidth: 80, minHeight: 80, maxHeight: 80, alignment: Alignment.center)

        case "user":
            ZStack {
                Color.init(red: 0.95, green: 0.95, blue: 0.95)
                Image(uiImage: self.imageView)
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
            }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .frame(minWidth: 80, minHeight: 80, maxHeight: 80, alignment: Alignment.center)

        default:
            ZStack {
                Color.init(red: 0.95, green: 0.95, blue: 0.95)
                Image(self.imageId)
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
            }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .frame(minWidth: 80, minHeight: 80, maxHeight: 80, alignment: Alignment.center)

        }
        
    }
}
*/

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry.init(date: Date(), configuration: ConfigurationIntent(), widgetSize: "small", thumbnail: UIImage.init(named: "placeholder")!, childViews: [])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        switch context.family {
        case .systemSmall:
            let currentDate = Date()
            let dict = (UserDefaultsFunctions.readTimelineObject(key: "widget_timeline_smallbegroovyorleaveman") as! [[String:[ChildView]]])
            completion(SimpleEntry.init(date: currentDate, configuration: configuration, widgetSize: "small", thumbnail: dict[0]["thumbnail"]![0].state.imageView, childViews: dict[0]["cv"]!))
        case .systemMedium:
            let currentDate = Date()
            let dict = (UserDefaultsFunctions.readTimelineObject(key: "widget_timeline_mediumbegroovyorleaveman") as! [[String:[ChildView]]])
            completion(SimpleEntry.init(date: currentDate, configuration: configuration, widgetSize: "medium", thumbnail: dict[0]["thumbnail"]![0].state.imageView, childViews: dict[0]["cv"]!))
        case .systemLarge:
            let currentDate = Date()
            let dict = (UserDefaultsFunctions.readTimelineObject(key: "widget_timeline_largebegroovyorleaveman") as! [[String:[ChildView]]])
            completion(SimpleEntry.init(date: currentDate, configuration: configuration, widgetSize: "large", thumbnail: dict[0]["thumbnail"]![0].state.imageView, childViews: dict[0]["cv"]!))
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        switch context.family {
        case .systemSmall:
            let currentDate = Date()
            for (i, e) in (UserDefaultsFunctions.readTimelineObject(key: "widget_timeline_smallbegroovyorleaveman") as! [[String:[ChildView]]]).enumerated() {
                let entryDate = Calendar.current.date(byAdding: .minute, value: i, to: currentDate)!
                entries.append(SimpleEntry.init(date: entryDate, configuration: configuration, widgetSize: "small", thumbnail: e["thumbnail"]![0].state.imageView, childViews: e["cv"]!))
            }
        case .systemMedium:
            let currentDate = Date()
            for (i, e) in (UserDefaultsFunctions.readTimelineObject(key: "widget_timeline_mediumbegroovyorleaveman") as! [[String:[ChildView]]]).enumerated() {
                let entryDate = Calendar.current.date(byAdding: .minute, value: i, to: currentDate)!
                entries.append(SimpleEntry.init(date: entryDate, configuration: configuration, widgetSize: "medium", thumbnail: e["thumbnail"]![0].state.imageView, childViews: e["cv"]!))
            }
        case .systemLarge:
            let currentDate = Date()
            for (i, e) in (UserDefaultsFunctions.readTimelineObject(key: "widget_timeline_largebegroovyorleaveman") as! [[String:[ChildView]]]).enumerated() {
                let entryDate = Calendar.current.date(byAdding: .minute, value: i, to: currentDate)!
                entries.append(SimpleEntry.init(date: entryDate, configuration: configuration, widgetSize: "large", thumbnail: e["thumbnail"]![0].state.imageView, childViews: e["cv"]!))
        }
        default:
            entries = [SimpleEntry.init(date: Date(), configuration: configuration, widgetSize: "small", thumbnail: UIImage.init(named: "placeholder")!, childViews: [])]
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
/*
class ChildImageViewState: ObservableObject {
    @Published var imageId: String {
        didSet {
            if(self.imageType == "user") {
                self.imageView = UIImage(named: "1")!
                /*
                do {
                    var url = URL.init(fileURLWithPath: Inventory().documentsPathForFileName(name: self.imageId))
                    self.imageView = try UIImage(data: Data(contentsOf: url))!
                } catch {
                    print("Error!")
                }
                */
            }
        }
    }
    @Published var offset: CGPoint = .zero
    @Published var scale: CGFloat = 1.0
    @Published var imageType: String = "asset" {
        didSet {
            if(self.imageType == "user") {
                do {
                    self.imageView = try UIImage(data: NSData(contentsOfFile: self.imageId) as Data)!
                } catch {
                    print("Error!")
                }
            }
        }
    }
        
    @Published var imageView: UIImage
    
    init(imageId: String, offset: CGPoint, scale: CGFloat, imageType: String, imageView: UIImage) {
        self.imageView = UIImage()
        self.imageId = imageId
        self.offset = offset
        self.scale = scale
        self.imageType = imageType
        self.imageView = imageView
    }
}

struct ChildImageView: View, Identifiable {
    
    let id = UUID()
    // var imageId: String
    // @State var offset_: CGPoint = .zero
    // @State var scale_: CGFloat = 1.0
    
    @ObservedObject var state: ChildImageViewState = ChildImageViewState.init(imageId: "", offset: .zero, scale: 1.0, imageType: "asset", imageView: UIImage())
    
    init(imageId: String? = "",
         offset_: CGPoint? = .zero,
         scale_: CGFloat? = 1.0,
         imageType: String,
         imageView: UIImage) {
        if(imageType == "user") {
            do {
                self.state = ChildImageViewState.init(imageId: imageId!, offset: offset_!, scale: scale_!, imageType: imageType, imageView: imageView)

            } catch {
                print("Error!")
            }
        } else {
            self.state = ChildImageViewState.init(imageId: imageId!, offset: offset_!, scale: scale_!, imageType: imageType, imageView: UIImage())
        }
        }
    
    var body: some View {
        VStack {
            switch self.state.imageType {
            case "user":
                Image(uiImage: self.state.imageView)
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                    .scaledToFit()
                    .offset(x: self.state.offset.x, y: self.state.offset.y)
                    .scaleEffect(self.state.scale)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                            self.state.offset = gesture.location
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                                .onChanged { value in
                        self.state.scale = value.magnitude
                                }
                            )
            default:
                Image(self.state.imageId)
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                    .scaledToFit()
                    .offset(x: self.state.offset.x, y: self.state.offset.y)
                    .scaleEffect(self.state.scale)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                            self.state.offset = gesture.location
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                                .onChanged { value in
                        self.state.scale = value.magnitude
                                }
                            )
            }
            
            // Text("\(self.state.offset.x)")
            // Text("\(self.state.offset.y)")
        }
    }
}
*/

struct ShelfCanvasView_WIDGET: View {
    
    @Environment(\.widgetFamily) var family
    
    @Binding var widgetType: String
    @State var widgetVariant: String
    @State var views: [ChildView] {
        didSet {
            for v in views {
                if(v.state.type == .SPECTATOR) {
                    self.shouldShowFloorView = true
                }
            }
        }
    }
    @State var backgroundColor: ChildView
    @State var thumbnail: UIImage
    
    @State var shouldShowFloorView: Bool = false
    
    var body: some View {
        
                ZStack {
                    // backgroundColor
                    Image(uiImage: thumbnail).resizable().scaledToFill()
                    // Color.init(.displayP3, red: 26/255, green: 11/255, blue: 2/255, opacity: 1.0)
                    
                    /*
                    Image("shelf_\(self.widgetType)\(self.widgetVariant)")
                        .interpolation(.none)
                        .resizable()
                        .frame(width: Util.getWidgetSize(size: self.widgetType).width, height: Util.getWidgetSize(size: self.widgetType).height, alignment: .center)
                    */
                    
                    /*
                    if(self.shouldShowFloorView) {
                        VStack {
                            Spacer().frame(height: Util.getWidgetSize(size: widgetType).height - 32, alignment: .center)
                            ChildView.init(type: .FLOOR, colorComponents: [], offset: .zero, scale: 1.0, imageView: UIImage.init(named: "floor")!, imagePath: "floor").frame(height: 32, alignment: .center)
                        }
                    }
                    */
                    
                    ForEach(views, id: \.id.uuidString) { view in
                        if(view.state.type == .IMAGE) {
                            ZStack {
                                ChildView.init(type: ChildViewType.IMAGE, colorComponents: [], offset: view.state.offset, scale: view.state.scale, imageView: view.state.imageView, imagePath: view.state.imagePath, shadow: true)
                            }
                        } else if(view.state.type == .SPECTATOR) {
                            ZStack {
                                ChildView.init(type: ChildViewType.SPECTATOR, colorComponents: [], offset: view.state.offset, scale: view.state.scale, imageView: view.state.imageView, imagePath: view.state.imagePath, shadow: true)
                            }
                        }
                            
                    }
                }
                .frame(width: Util.getWidgetSize(size: widgetType).width, height: Util.getWidgetSize(size: widgetType).height, alignment: .center)
                .clipped()
                .offset(x: 0, y: 0)
                .unredacted()
    }
    
    func buildView(views: [AnyView], index: Int) -> AnyView {
        return views[index]
    }
}

/*
struct ShelfBuildView: View {
    
    @State var widgetType: String = "medium"
    @State var shelfViews: [ChildImageView] = [] // UserDefaultsFunctions.readObject(key: "widget_SMALL")
            
    var body: some View {
        ShelfCanvasView(views: self.$shelfViews)
    }
}
*/

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let widgetSize: String
    let thumbnail: UIImage
    let childViews: [ChildView]
}

struct Shelf_Life_WidgetEntryView : View {
    var entry: Provider.Entry
    // @State var views: [ChildImageView] = [] // UserDefaultsFunctions.readObject(key: "widget_SMALL")
    
    @State var widgetType_SMALL: String = "small"
    @State var widgetType_MEDIUM: String = "medium"
    @State var widgetType_LARGE: String = "large"

    @ViewBuilder
    func buildCanvasView() -> some View {
        switch self.entry.widgetSize {
        case "small":
            ShelfCanvasView_WIDGET.init(widgetType: self.$widgetType_SMALL, widgetVariant: "begroovyorleaveman", views: Array(entry.childViews[1...]), backgroundColor: entry.childViews[0], thumbnail: entry.thumbnail)
        case "medium":
            ShelfCanvasView_WIDGET.init(widgetType: self.$widgetType_MEDIUM, widgetVariant: "begroovyorleaveman", views: Array(entry.childViews[1...]), backgroundColor: entry.childViews[0], thumbnail: entry.thumbnail)
        case "large":
            ShelfCanvasView_WIDGET.init(widgetType: self.$widgetType_LARGE, widgetVariant: "begroovyorleaveman", views: Array(entry.childViews[1...]), backgroundColor: entry.childViews[0], thumbnail: entry.thumbnail)
        default:
            ShelfCanvasView_WIDGET.init(widgetType: self.$widgetType_LARGE, widgetVariant: "begroovyorleaveman", views: Array(entry.childViews[1...]), backgroundColor: entry.childViews[0], thumbnail: entry.thumbnail)

        }
    }
    
    @ViewBuilder
        var body: some View {
            
            ZStack {
                // Image(uiImage: entry.thumbnail).interpolation(.high).resizable().scaledToFill()
                buildCanvasView()
                if(entry.widgetSize == "large") {
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Image(uiImage: UIImage.init(named: "logo-text")!).interpolation(.high).resizable().renderingMode(.template).foregroundColor(Color.init("text")).frame(width: 1464/1140 * 20 + 20, height: 1464/1140 * 20 + 20, alignment: .center)
                            }
                            .background(
                                Color.init("light-background").frame(width: 1464/1140 * 20 + 20, height: 1464/1140 * 20 + 20, alignment: .center)).cornerRadius(6)
                            .frame(width: 1464/1140 * 20 + 20, height: 1464/1140 * 20 + 20, alignment: .center)
                            .padding(16)
                            .cornerRadius(6)
                            .clipped()
                            .opacity(1.0)
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                        }
                        Spacer()
                    }
                } else {
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Image(uiImage: UIImage.init(named: "logo-text")!).interpolation(.high).resizable().renderingMode(.template).foregroundColor(Color.init("text")).frame(width: 1464/1140 * 14 + 14, height: 1464/1140 * 14 + 14, alignment: .center)
                            }
                            .background(
                                Color.init("light-background").frame(width: 1464/1140 * 14 + 14, height: 1464/1140 * 14 + 14, alignment: .center)).cornerRadius(4)
                            .frame(width: 1464/1140 * 14 + 14, height: 1464/1140 * 14 + 14, alignment: .center)
                            .padding(16)
                            .cornerRadius(4)
                            .clipped()
                            .opacity(1.0)
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                        }
                        Spacer()
                    }
                }
                
            }.offset(x: 0, y: 0)
                .unredacted()

        }
}

@main
struct Shelf_Life_Widget: Widget {
    let kind: String = "Shelf_Life_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Shelf_Life_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Shelf Life Widget")
        .description("Put your life on your screen!")
    }
}

struct Shelf_Life_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Shelf_Life_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), widgetSize: "small", thumbnail: UIImage.init(named: "placeholder")!, childViews: []))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            Shelf_Life_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), widgetSize: "medium", thumbnail: UIImage.init(named: "placeholder")!, childViews: []))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            Shelf_Life_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), widgetSize: "large", thumbnail: UIImage.init(named: "placeholder")!, childViews: []))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        
    }
}
