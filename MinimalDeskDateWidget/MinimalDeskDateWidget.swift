//
//  MinimalDeskDateWidget.swift
//  MinimalDeskDateWidget
//
//  Created by Rakib Hasan on 17/7/24.
//

import WidgetKit
import SwiftUI

//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date())
//    }
//    
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date())
//        completion(entry)
//    }
//    
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//        
//        let currentDate = Date()
//        for dayOffset in 0 ..< 60 {
//            let entryDate = Calendar.current.date(byAdding: .second, value: dayOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate)
//            entries.append(entry)
//        }
//        
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}

//struct SimpleEntry: TimelineEntry {
//    let date: Date
//}



//struct MinimalDeskDateWidget: Widget {
//    let kind: String = "MinimalDeskDateWidget"
//    
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            if #available(iOS 17.0, *) {
//                MinimalDeskDateWidgetEntryView(entry: entry)
//                //.containerBackground(.black, for: .widget)
//                    .containerBackground(for: .widget, alignment: .center, content: { EmptyView() })
//            } else {
//                MinimalDeskDateWidgetEntryView(entry: entry)
//                    .padding()
//            }
//        }
//        .contentMarginsDisabled()
//        .configurationDisplayName("Date & Time Widget")
//        .description("Add this widget to the top of your home screen page")
//        .supportedFamilies([.systemMedium])
//    }
//}



struct Provider: AppIntentTimelineProvider {
    typealias Entry = SimpleEntry
    typealias Intent = WidgetConfigIntent
    
    
    
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), transparencyOption: .opaque, backgroundColor: WidgetBackgroundColor.black.rawValue)
//    }
//    
//    
//    func snapshot(for configuration: WidgetConfigIntent, in context: Context) async -> SimpleEntry {
//        SimpleEntry(date: Date(), transparencyOption: configuration.transparency, backgroundColor: configuration.backgroundColor.rawValue)
//    }
//    
//    func timeline(for configuration: WidgetConfigIntent, in context: Context) async -> Timeline<SimpleEntry> {
//        var entries: [SimpleEntry] = []
//        let currentDate = Date()
//        
//        for offset in 0..<60 {
//            let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, transparencyOption: configuration.transparency, backgroundColor: configuration.backgroundColor.rawValue)
//            entries.append(entry)
//        }
//        
//        return Timeline(entries: entries, policy: .atEnd)
//    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), backgroundColor: WidgetBackgroundColor.black.rawValue)
    }
    
    
    
    func snapshot(for configuration: WidgetConfigIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), backgroundColor: configuration.backgroundColor.rawValue)
    }
    
    func timeline(for configuration: WidgetConfigIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        for offset in 0..<60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, backgroundColor: configuration.backgroundColor.rawValue)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
}


//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let transparencyOption: BackgroundTransparency
//}

struct SimpleEntry: TimelineEntry {
    let date: Date
    //let transparencyOption: BackgroundTransparency
    let backgroundColor: String
}

struct MinimalDeskDateWidgetEntryView : View {
    var entry: Provider.Entry
    
    @State private var widgetConfig: FavAppWidgetConfig
    let height = 90.0
    
    init(entry: Provider.Entry) {
        self.entry = entry
        self.widgetConfig = FavAppWidgetConfig.defaultConfig
    }
    
    var body: some View {
        DateWidgetView(height: height)
    }
}



@available(iOS 17.0, *)
struct MinimalDeskDateWidget: Widget {
    let kind: String = "MinimalDeskDateWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: WidgetConfigIntent.self, provider: Provider()) { entry in
            MinimalDeskDateWidgetEntryView(entry: entry)
                .containerBackground(Color(hex: entry.backgroundColor), for: .widget)
                  
                
            
            
//                .containerBackground(for: .widget, alignment: .center) {
//                    if entry.transparencyOption == .opaque {
//                        Color(hex: entry.backgroundColor)
//                    } else {
//                        ContainerRelativeShape()
//                            .foregroundStyle(.ultraThinMaterial)
//                    }
//                }
            
            
        }
        .configurationDisplayName("Date & Time Widget")
        .description("Add this widget to the top of your home screen page")
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}


import AppIntents

//struct WidgetConfigIntent: AppIntent, WidgetConfigurationIntent {
//    static var title: LocalizedStringResource = "Widget Configuration"
//
//    @Parameter(
//        title: "Transparent Background"
//    )
//    var isTransparent: Bool
//
//    var transparency: BackgroundTransparency {
//        isTransparent ? .transparent : .opaque
//    }
//
//    init() {
//        self.isTransparent = false // default: opaque
//    }
//
//    init(isTransparent: Bool) {
//        self.isTransparent = isTransparent
//    }
//}

struct WidgetConfigIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Widget Configuration"
    
//    @Parameter(title: "Transparent Background")
//    var isTransparent: Bool
    
    @Parameter(title: "Background Color")
    var backgroundColor: WidgetBackgroundColor
    
//    var transparency: BackgroundTransparency {
//        isTransparent ? .transparent : .opaque
//    }

    
    init() {
        //self.isTransparent = false
        self.backgroundColor = .widDateColor
    }
    
    
    init(isTransparent: Bool, backgroundColor: WidgetBackgroundColor) {
        //self.isTransparent = isTransparent
        self.backgroundColor = backgroundColor
    }
}


