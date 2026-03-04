//
//  CycleWidget.swift
//  CycleWidget
//
//  Created by Haider on 1/3/26.
//

import WidgetKit
import SwiftUI

// MARK: - Widget Configuration
struct CycleWidget: Widget {
    let kind: String
    let cardIndex: Int
    
    init() {
        cardIndex = 0
        kind = "CycleWidget0"
    }
    
    init(cardIndex: Int) {
        if cardIndex <= 4 {
            self.cardIndex = cardIndex
            kind = "CycleWidget\(cardIndex)"
        } else {
            self.cardIndex = 0
            kind = "CycleWidget0"
        }
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CycleWidgetEntryView(entry: entry, cardIndex: cardIndex)
                    .containerBackground(for: .widget, alignment: .center, content: { EmptyView() })
            } else {
                CycleWidgetEntryView(entry: entry, cardIndex: cardIndex)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName(
            cardIndex == 0 ? "Cycle - Page 1" :
            cardIndex == 1 ? "Cycle - Page 2" :
            cardIndex == 2 ? "Cycle - Page 3" :
            cardIndex == 3 ? "Cycle - Page 4" :
            cardIndex == 4 ? "Cycle - Page 5" :
            "LessPhone"
        )
        .description("Display your selected apps on Home Screen")
        .supportedFamilies([.systemSmall])
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {

        var entries: [SimpleEntry] = []
        let currentDate = Date()

        for minuteOffset in 0..<60 {
            if let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate) {
                entries.append(SimpleEntry(date: entryDate))
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
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
struct CycleWidgetEntryView : View {
    var entry: SimpleEntry
    
    @State private var cycleList: CycleModel = CycleModel.empty
    @State private var widgetConfig: CycleWidgetConfig
    let cardIndex: Int
    @State private var testMark = false
    
    
    @State private var isSubscribed = false // Use local state for real-time check
    
    init(entry: Provider.Entry, cardIndex: Int = 0) {
        self.entry = entry
        self.widgetConfig = CycleWidgetConfig.defaultConfig
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
            } else if cycleList.title.isEmpty {
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
            self.isSubscribed = Store.shared.userHasActivePurchase()
            
            let userDefault = UserDefaults(suiteName: "group.minimaldesk") ?? UserDefaults()
            
            if !isLocked {
                if let data = userDefault.data(forKey: "cycle-list\(cardIndex)"),
                   let cycleData = try? JSONDecoder().decode(CycleModel.self, from: data) {
                    cycleList = cycleData
                }
            }
 
            let config = userDefault.value(forKey: "cycle-list-config") as? Data ?? Data()
            if let widgetConfig = try? JSONDecoder().decode(CycleWidgetConfig.self, from: config) {
                CycleWidgetConfig.defaultConfig = widgetConfig
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
            
            Text(cycleList.title)
                .strikethrough(mark())
                .foregroundColor(Color(hex: widgetConfig.fontColor))
                .opacity(mark() ? 0.4 : 1)
                .textCase(widgetConfig.caseText == "default" ? nil : .uppercase)
                .font(.system(size: widgetConfig.fontSize, weight: FontWeightConverter(weightString: widgetConfig.fontWeight).value))
                .fontDesign(FontTypeConverter(FontString: widgetConfig.fontType).value)
            
            //Spacer()
            
            HStack(spacing: 0) {
                Text("Until ")
                Text(
                    untilDate(),
                    format: .dateTime
                        .month(.abbreviated)
                        .day()
                        .hour(.twoDigits(amPM: .abbreviated))
                        .minute()
                )
            }
            .font(.system(size: 12))
            .foregroundColor(Color(hex: widgetConfig.fontColor))
            .opacity(0.4)
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 15)
        

        
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
    
    func historyOccurIndex(date: Date) -> Int {
        let selectedDate = cycleList.selectedDate
        let repeateMin = cycleList.repeatNumber * (cycleList.repeatUnit == "hours" ? 60 : 1440)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: selectedDate, to: date)
        guard let totalMin = components.minute else { return 0 }
        return totalMin/repeateMin
    }
    
    func mark() -> Bool {
        let index = historyOccurIndex(date: entry.date)
        print("Farjum mark index : \(index)")
        if cycleList.completedCycles[index] != nil { return true}
        else { return false }
    }
    
    func untilDate() -> Date {
        let selectedDate = cycleList.selectedDate
        let repeateMin = cycleList.repeatNumber * (cycleList.repeatUnit == "hours" ? 60 : 1440)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: selectedDate, to: entry.date)
        guard var totalMin = components.minute else { return Date() }
        
        totalMin = totalMin + repeateMin
        
        let untilIndex = totalMin/repeateMin
        let untilMin = untilIndex*repeateMin
        
        let newDate = Calendar.current.date(
            byAdding: .minute,
            value: untilMin,
            to: selectedDate
        )
        //print("Farjum historyOccurIndex -> totalMin: \(totalMin), repeateHour: \(repeateMin) , date : \(date)")
        //return totalMin/repeateMin
        return newDate ?? entry.date
    }
}
