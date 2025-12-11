
// MARK: - Widget Configuration
struct FavAppWidget: Widget {
    let kind: String
    let cardIndex: Int
    
    init() {
        cardIndex = 0
        kind = "FavAppWidget0"
    }
    
    init(cardIndex: Int) {
        if cardIndex <= 4 {
            self.cardIndex = cardIndex
            kind = "FavAppWidget\(cardIndex)"
        } else {
            self.cardIndex = 0
            kind = "FavAppWidget0"
        }
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                FavAppWidgetEntryView(entry: entry, cardIndex: cardIndex)
                    .containerBackground(for: .widget, alignment: .center, content: { EmptyView() })
            } else {
                FavAppWidgetEntryView(entry: entry, cardIndex: cardIndex)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName(
            cardIndex == 0 ? "LessPhone - Page 1" :
                cardIndex == 1 ? "LessPhone - Page 2" :
                cardIndex == 2 ? "LessPhone - Page 3" :
                cardIndex == 3 ? "LessPhone - Page 4" :
                cardIndex == 4 ? "LessPhone - Page 5" :
                "LessPhone"
        )
        .description("Display your selected apps on Home Screen")
        .supportedFamilies([.systemLarge])
    }
}


//
//  FavAppWidget.swift
//  FavAppWidget
//
//  Created by Tipu Sultan on 4/8/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for _ in 0 ..< 1 {
            let entryDate = Calendar.current.date(byAdding: .second, value: 0, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct FontTypeConverter {
    let FontString: String
    
    var value: Font.Design {
        switch FontString.lowercased() {
        case "default": return .default
        case "serif": return .serif
        case "rounded": return .rounded
        case "monospaced": return .monospaced
        default: return .default
        }
    }
}

struct FontWeightConverter {
    let weightString: String
    
    var value: Font.Weight {
        switch weightString.lowercased() {
        case "ultralight": return .ultraLight
        case "thin": return .thin
        case "light": return .light
        case "regular": return .regular
        case "medium": return .medium
        case "semibold": return .semibold
        case "bold": return .bold
        case "heavy": return .heavy
        case "black": return .black
        default: return .regular
        }
    }
}

// MARK: - Entry View
struct FavAppWidgetEntryView : View {
    var entry: Provider.Entry
    
    @State private var favApps = [["name": "Testapp", "link": "Testlink"]]
    @State private var widgetConfig: FavAppWidgetConfig
    let cardIndex: Int
    
    @State private var isSubscribed = false // Use local state for real-time check
    
    init(entry: Provider.Entry, cardIndex: Int = 0) {
        self.entry = entry
        self.widgetConfig = FavAppWidgetConfig.defaultConfig
        self.cardIndex = cardIndex
    }
    
    var body: some View {
        ZStack {
            Color(hex: widgetConfig.backgroundColor)
                .ignoresSafeArea()
            
            if isLocked {
                VStack {
                    Text("Subscribe to unlock multiple widgets")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: widgetConfig.fontColor))
                        .padding()
                }
            } else if favApps.isEmpty {
                Text("Add Favorite apps to be shown here.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: widgetConfig.fontColor))
                    .ignoresSafeArea()
            } else {
                
                if widgetConfig.alignment == "top" ||  widgetConfig.alignment == "bottom" {
                    VStack {
                        cardAlignment(alignment: "vertical")
                    }
                } else {
                    HStack {
                        cardAlignment(alignment: "horizonatal")
                    }
                }
            }
        }
        //       .onAppear {
        //           // Use App Group defaults instead of Store.shared
        //           let defaults = UserDefaults(suiteName: "group.minimaldesk")!
        //           
        //           let hasActiveSubscription = defaults.bool(forKey: "hasActiveSubscription")
        //           
        //           if hasActiveSubscription {
        //               self.isSubscribed = true
        //           } else if let expirationDate = defaults.object(forKey: "expirationDate") as? Date {
        //               self.isSubscribed = expirationDate > Date()
        //           } else {
        //               self.isSubscribed = false
        //           }
        //
        //           if UserDefaults.standard.bool(forKey: "lifetimePurchase") {
        //               self.isSubscribed = true
        //           }
        //           let userDefault = UserDefaults(suiteName: "group.minimaldesk") ?? UserDefaults()
        //           
        //           if !isLocked {
        //              // favApps = (userDefault.value(forKey: "favorite-apps$cardIndex)") as? [[String: String]] ?? []
        //               
        //                 favApps = (userDefault.value(forKey: "favorite-apps\(cardIndex)") as? [[String: String]] ?? [])
        //                   .sorted { Int($0["rank"] ?? "") ?? 0 < Int($1["rank"] ?? "") ?? 0 }
        //           }
        //
        //           let config = userDefault.value(forKey: "favorite-apps-config") as? Data ?? Data()
        //           if let widgetConfig = try? JSONDecoder().decode(FavAppWidgetConfig.self, from: config) {
        //               FavAppWidgetConfig.defaultConfig = widgetConfig
        //               self.widgetConfig = widgetConfig
        //           }
        //       }
        
        
        .onAppear {
            self.isSubscribed = Store.shared.userHasActivePurchase()
            
            let userDefault = UserDefaults(suiteName: "group.minimaldesk") ?? UserDefaults()
            
            if !isLocked {
                favApps = (userDefault.value(forKey: "favorite-apps\(cardIndex)") as? [[String: String]] ?? [])
                    .sorted { Int($0["rank"] ?? "") ?? 0 < Int($1["rank"] ?? "") ?? 0 }
            }
            
            let config = userDefault.value(forKey: "favorite-apps-config") as? Data ?? Data()
            if let widgetConfig = try? JSONDecoder().decode(FavAppWidgetConfig.self, from: config) {
                FavAppWidgetConfig.defaultConfig = widgetConfig
                self.widgetConfig = widgetConfig
            }
        }
        
    }
    
    @ViewBuilder
    private func cardAlignment(alignment: String) -> some View {
        //HStack {
        if getAlignment(widgetConfig.alignment) == .trailing || getAlignment1(widgetConfig.alignment) == .bottom {
                Spacer()
            }
            
        VStack(alignment: alignment == "horizonatal" ? getAlignment(widgetConfig.alignment) : getAlignment1(widgetConfig.alignment), spacing: widgetConfig.spacing) {
                ForEach(favApps.prefix(widgetConfig.maxNumberOfApps), id: \.self) { app in
                    Button(intent: OpenAppIntent(urlStr: app["link"] ?? "Empty Link")) {
                        Text(app["name"] ?? "Loading...")
                            .foregroundColor(Color(hex: widgetConfig.fontColor))
                            .font(.system(
                                size: CGFloat(widgetConfig.fontSize),
                                weight: FontWeightConverter(weightString: widgetConfig.fontWeight).value,
                                design: FontTypeConverter(FontString: widgetConfig.fontType).value
                            ))
                    }
                    .buttonStyle(PlainButtonStyle())
                    //.font(Font.custom(widgetConfig.fontType, size: CGFloat(widgetConfig.fontSize)))
                }
            }
            .padding(.horizontal, 25)
            
            if getAlignment(widgetConfig.alignment) == .leading || getAlignment1(widgetConfig.alignment) == .top  {
                Spacer()
            }
        ///}
    }
    
    private var isLocked: Bool {
        return cardIndex > 0 && !isSubscribed
    }
    
    
    private func getAlignment(_ alignmentString: String) -> HorizontalAlignment? {
        switch alignmentString {
        case "hCenter": return .center
        case "right": return .trailing
        case "left": return .trailing
        default: return nil
        }
    }
    
    private func getAlignment1(_ alignmentString: String) -> VerticalAlignment? {
        switch alignmentString {
        case "vCenter": return .center
        case "top": return .top
        case "bottom": return .bottom
        default: return nil
        }
    }
}
