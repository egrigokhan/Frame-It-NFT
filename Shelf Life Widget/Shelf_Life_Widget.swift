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
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), widgetSize: "medium")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, widgetSize: "medium")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, widgetSize: "medium")
            entries.append(entry)
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
    @State var views: [ChildView]
    @State var backgroundColor: ChildView
    
    var body: some View {
        
                ZStack {
                    backgroundColor
                    // Color.init(.displayP3, red: 26/255, green: 11/255, blue: 2/255, opacity: 1.0)
                    Image("shelf_\(self.widgetType)\(self.widgetVariant)")
                        .interpolation(.none)
                        .resizable()
                        .frame(width: Util.getWidgetSize(size: self.widgetType).width, height: Util.getWidgetSize(size: self.widgetType).height, alignment: .center)
                    
                    
                    ForEach(views, id: \.id.uuidString) { view in
                        ZStack {
                            ChildView.init(type: ChildViewType.IMAGE, colorComponents: [], offset: view.state.offset, scale: view.state.scale, imageView: view.state.imageView)
                        }
                            .shadow(color: Color.black.opacity(0.1), radius: 0.1, x: 0, y: 5)
                            .shadow(color: Color.black.opacity(0.1), radius: 0.1, x: 1, y: 0)
                            .shadow(color: Color.black.opacity(0.1), radius: 0.1, x: -1, y: 0)
                    }
                }.offset(x: 0, y: 0)
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
}

struct Shelf_Life_WidgetEntryView : View {
    var entry: Provider.Entry
    // @State var views: [ChildImageView] = [] // UserDefaultsFunctions.readObject(key: "widget_SMALL")
    
    @State var widgetTypes = [WidgetFamily.systemSmall: "small",
                              WidgetFamily.systemMedium: "medium",
                              WidgetFamily.systemLarge: "large"]
    
    @State var SMALL = "small"
    @State var MEDIUM = "medium"
    @State var LARGE = "large"
    
    @State var SMALL_VIEW = UserDefaultsFunctions.readObject(key: "widget_small")
    @State var MEDIUM_VIEW = UserDefaultsFunctions.readObject(key: "widget_medium")
    @State var LARGE_VIEW = UserDefaultsFunctions.readObject(key: "widget_large")
    
    @Environment(\.widgetFamily) var family

        @ViewBuilder
        var body: some View {
            
            switch family {
            case .systemSmall:
                let SMALL_DICT = UserDefaultsFunctions.readObject(key: "widget_small\(UserDefaultsFunctions.readVariant(key: "shelf_variants")["VARIANT_SMALL"]!)")
                ShelfCanvasView_WIDGET.init(widgetType: self.$SMALL, widgetVariant: UserDefaultsFunctions.readVariant(key: "shelf_variants")["VARIANT_SMALL"]!, views: Array(SMALL_DICT[1...]), backgroundColor: SMALL_DICT[0])
            case .systemMedium:
                let MEDIUM_DICT = UserDefaultsFunctions.readObject(key: "widget_medium\(UserDefaultsFunctions.readVariant(key: "shelf_variants")["VARIANT_MEDIUM"]!)")
                ShelfCanvasView_WIDGET.init(widgetType: self.$MEDIUM, widgetVariant: UserDefaultsFunctions.readVariant(key: "shelf_variants")["VARIANT_MEDIUM"]!, views: Array(MEDIUM_DICT[1...]), backgroundColor: MEDIUM_DICT[0])
            case .systemLarge:
                let LARGE_DICT = UserDefaultsFunctions.readObject(key: "widget_large\(UserDefaultsFunctions.readVariant(key: "shelf_variants")["VARIANT_LARGE"]!)")
                ShelfCanvasView_WIDGET.init(widgetType: self.$LARGE, widgetVariant: UserDefaultsFunctions.readVariant(key: "shelf_variants")["VARIANT_LARGE"]!, views: Array(LARGE_DICT[1...]), backgroundColor: LARGE_DICT[0])
            default:
                Text("Some other WidgetFamily in the future.")
            }

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
            Shelf_Life_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), widgetSize: "small"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            Shelf_Life_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), widgetSize: "medium"))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            Shelf_Life_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), widgetSize: "large"))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        
    }
}
