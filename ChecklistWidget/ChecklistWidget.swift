//
//  ChecklistWidget.swift
//  ChecklistWidget
//
//  Created by Haider on 13/2/26.
//

import WidgetKit
import SwiftUI

// MARK: - Widget Configuration
struct ChecklistWidget: Widget {
    let kind: String
    let cardIndex: Int
    
    init() {
        cardIndex = 0
        kind = "ChecklistWidget0"
    }
    
    init(cardIndex: Int) {
        if cardIndex <= 4 {
            self.cardIndex = cardIndex
            kind = "ChecklistWidget\(cardIndex)"
        } else {
            self.cardIndex = 0
            kind = "ChecklistWidget0"
        }
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ChecklistWidgetEntryView(entry: entry, cardIndex: cardIndex)
                    .containerBackground(for: .widget, alignment: .center, content: { EmptyView() })
            } else {
                ChecklistWidgetEntryView(entry: entry, cardIndex: cardIndex)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName(
            cardIndex == 0 ? "Todo List - Page 1" :
                cardIndex == 1 ? "Todo List - Page 2" :
                cardIndex == 2 ? "Todo List - Page 3" :
                cardIndex == 3 ? "Todo List - Page 4" :
                cardIndex == 4 ? "Todo List - Page 5" :
                "LessPhone"
        )
        .description("Display your selected apps on Home Screen")
        .supportedFamilies([.systemLarge])
    }
}


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
struct ChecklistWidgetEntryView : View {
    var entry: Provider.Entry
    
    @State private var checkList: [TodoItem] = [TodoItem(title: "test", isCompleted: false)]
    @State private var widgetConfig: ChecklistWidgetConfig
    let cardIndex: Int
    
    // private let userdefault = UserDefaults(suiteName: "group.minimaldesk")
    
    @State private var isSubscribed = false // Use local state for real-time check
    
    init(entry: Provider.Entry, cardIndex: Int = 0) {
        self.entry = entry
        self.widgetConfig = ChecklistWidgetConfig.defaultConfig
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
            } else if checkList.isEmpty {
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
        .onAppear {
            print("Farjum: \(widgetConfig.fontColor)")
            self.isSubscribed = Store.shared.userHasActivePurchase()
            
            let userDefault = UserDefaults(suiteName: "group.minimaldesk") ?? UserDefaults()
            
            if !isLocked {
                if let data = userDefault.data(forKey: "todo-list\(cardIndex)"),
                   let todoList = try? JSONDecoder().decode([TodoItem].self, from: data) {
                    checkList = todoList
                }
            }
 
            let config = userDefault.value(forKey: "todo-list-config") as? Data ?? Data()
            if let widgetConfig = try? JSONDecoder().decode(ChecklistWidgetConfig.self, from: config) {
                ChecklistWidgetConfig.defaultConfig = widgetConfig
                self.widgetConfig = widgetConfig
            }
        }
    }
    
    @ViewBuilder
    private func cardAlignment(alignment: String) -> some View {
        
        if getHorizontalAlignment(widgetConfig.alignment) == .trailing || getVerticalAlignment(widgetConfig.alignment) == .bottom  {
            Spacer()
        }
        
        VStack(alignment: (alignment == "horizonatal" ? getHorizontalAlignment(widgetConfig.alignment) ?? .center : .center), spacing: widgetConfig.spacing) {
            
            ForEach(checkList, id: \.self) { list in
                Text(list.title)
                    .strikethrough(list.isCompleted)
                    .foregroundColor(Color(hex: widgetConfig.fontColor))
                    .opacity(list.isCompleted ? 0.4 : 1)
                    .textCase(widgetConfig.caseText == "default" ? nil : .uppercase)
                    .font(.system(size: widgetConfig.fontSize, weight: FontWeightConverter(weightString: widgetConfig.fontWeight).value))
                    .fontDesign(FontTypeConverter(FontString: widgetConfig.fontType).value)
                    //.foregroundColor(Color(hex: widgetConfig.fontColor))
            }
        }
        .padding(.all, 25)
        

        
        if getHorizontalAlignment(widgetConfig.alignment) == .leading || getVerticalAlignment(widgetConfig.alignment) == .top   {
            Spacer()
        }
    }
        
    private var isLocked: Bool {
        return cardIndex > 0 && !isSubscribed
    }
        
    private func getHorizontalAlignment(_ alignmentString: String) -> HorizontalAlignment? {
        switch alignmentString {
        case "hCenter", "vCenter": return .center
        case "right": return .trailing
        case "left": return .leading
        default: return nil
        }
    }
    
    private func getVerticalAlignment(_ alignmentString: String) -> VerticalAlignment? {
        switch alignmentString {
        case "top": return .top
        case "bottom": return .bottom
        default: return nil
        }
    }
}
