//
//  DateWidgetViews.swift
//  MinimalDesk
//
//  Created by Rakib Hasan on 17/7/24.
//

import Foundation
import SwiftUI

struct DateWidgetView: View {
    let height: CGFloat
    @State var widgetConfig: DateConfig
    
    private var theme: String {
        let userdefault = UserDefaults(suiteName: "group.minimaldesk")
        let viewName = userdefault?.value(forKey: "current-widget-theme") as? String ?? "Nil"
        
        print("[DateWidget] [TimelineProvider] viewName = \(viewName)")
        
        return viewName
    }
    
    var body: some View {
        VStack {
            switch theme {
            case "DateTimeViewType1": DateTimeViewType1(height: height)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: widgetConfig.arr[0].backgroundColor))
                    .foregroundColor(Color(hex: widgetConfig.arr[0].fontColor))
            case "DateTimeViewType2": DateTimeViewType2()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: widgetConfig.arr[1].backgroundColor))
                    .foregroundColor(Color(hex: widgetConfig.arr[1].fontColor))
            case "DateTimeViewType3": DateTimeViewType3()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: widgetConfig.arr[2].backgroundColor))
                    .foregroundColor(Color(hex: widgetConfig.arr[2].fontColor))
            case "DateTimeViewType4": DateTimeViewType4()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: widgetConfig.arr[3].backgroundColor))
                    .foregroundColor(Color(hex: widgetConfig.arr[3].fontColor))
            case "DateTimeViewType5": DateTimeViewType5()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: widgetConfig.arr[4].backgroundColor))
                    .foregroundColor(Color(hex: widgetConfig.arr[4].fontColor))
            case "DateTimeViewType6": DateTimeViewType6()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: widgetConfig.arr[5].backgroundColor))
                    .foregroundColor(Color(hex: widgetConfig.arr[5].fontColor))
            case "DateTimeViewType7": DateTimeViewType7()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: widgetConfig.arr[6].backgroundColor))
                    .foregroundColor(Color(hex: widgetConfig.arr[6].fontColor))
            case "DateTimeViewType8": DateTimeViewType8()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: widgetConfig.arr[7].backgroundColor))
                    .foregroundColor(Color(hex: widgetConfig.arr[7].fontColor))
            default:                  DateTimeViewType2()
            }
        }
        .onAppear {
            let userDefault = UserDefaults(suiteName: "group.minimaldesk") ?? UserDefaults()
            let config = userDefault.value(forKey: "favorite-date-config") as? Data ?? Data()
            if let widgetConfig = try? JSONDecoder().decode(DateConfig.self, from: config) {
                DateConfig.defaultConfig = widgetConfig
                self.widgetConfig = widgetConfig
            }
        }

    }

}

struct DateTimeViewType1: View {
    var date: Date { .now }
    let height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                ZStack {
                    Image(systemName: "square")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: height, height: height)

                    Text("\(date.formatted(.dateTime.day()))")
                        .font(.system(size: height * 0.45, weight: .bold))
                }
                
                VStack(alignment: .leading) {
                    Text(date.formatted(.dateTime.month(.wide)))
                        //.foregroundColor(.white)
                        .font(.title)
                    
                    Spacer()
                    
                    Text(date.formatted(.dateTime.weekday(.wide)))
                        //.foregroundColor(.gray)
                        .font(.title2)
                }
                .frame(height: height)
            }
        }
    }
}

struct DateTimeViewType2: View {
    var date: Date { .now }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("\(date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)).minute()))")
                .font(.largeTitle)
                .bold()
            
            Text(date.formatted(.dateTime.month(.wide).day().year()))
                .font(.title2)
        }
        //.foregroundColor(.white)
    }
}

struct DateTimeViewType3: View {
    var date: Date { .now }
    
    private var day: String { date.formatted(.dateTime.day(.twoDigits)) }
    private var month: String { date.formatted(.dateTime.month(.wide)) }
    private var year: String { date.formatted(.dateTime.year()) }
    
    var body: some View {
        HStack(alignment: .center, spacing: 15.0) {
            Text(day)
                .font(.title2)
                .padding(10)
                .background(.white)
                .clipShape(Circle())
            
            Text(month)
                .font(.title2)
                .padding(.vertical, 5)
                .padding(.horizontal)
                .background(.white)
                .clipShape(Capsule())
            
            Text(year)
                .font(.title2)
                .padding(.vertical, 5)
                .padding(.horizontal)
                .overlay {
                    Capsule()
                        .stroke(.white, lineWidth: 1.0)
                }
                //.foregroundColor(.white)
        }
        //.foregroundColor(.black)
    }
}

struct DateTimeViewType4: View {
    var date: Date { .now }
    
    private var hour: String { date.formatted(.dateTime.hour(.twoDigits(amPM: .omitted))) }
    private var minute: String { date.formatted(.dateTime.minute(.twoDigits)) }
    private var amPm: String { String(date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated))).suffix(2)) }
    
    private var day: String { date.formatted(.dateTime.day(.twoDigits)) }
    private var month: String { date.formatted(.dateTime.month(.wide)) }
    private var year: String { date.formatted(.dateTime.year()) }
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack(alignment: .center) {
                Text(hour)
                    .font(.title2)
                    .padding(10)
                    .background(.white)
                    .clipShape(Circle())
                
                Text(":")
                    .font(.title2)
                    //.foregroundColor(.white)
                
                Text(minute)
                    .font(.title2)
                    .padding(10)
                    .background(.white)
                    .clipShape(Circle())
                
                Text(amPm)
                    .font(.title2)
                    //.foregroundColor(.white)
            }
            
            HStack {
                Text("\(month) \(day), \(year)")
                    .font(.title3)
                    //.foregroundColor(.white)
            }
        }
        //.foregroundColor(.black)
    }
}

struct DateTimeViewType5: View {
    var date: Date { .now }
    
    private var hour: String { date.formatted(.dateTime.hour(.twoDigits(amPM: .omitted))) }
    private var minute: String { date.formatted(.dateTime.minute(.twoDigits)) }
    private var amPm: String { String(date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated))).suffix(2)) }
    
    private var day: String { date.formatted(.dateTime.day(.twoDigits)) }
    private var month: String { date.formatted(.dateTime.month(.wide)) }
    private var year: String { date.formatted(.dateTime.year()) }
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack(alignment: .center) {
                Text(hour)
                    .font(.title2)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(10)
                
                Text(":")
                    .font(.title2)
                    //.foregroundColor(.white)
                
                Text(minute)
                    .font(.title2)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(10)
                
                Text(amPm)
                    .font(.title2)
                    //.foregroundColor(.white)
            }
            
            HStack {
                Text("\(month) \(day), \(year)")
                    .font(.title3)
                    //.foregroundColor(.white)
            }
        }
        //.foregroundColor(.black)
    }
}


struct DateTimeViewType6: View {
    var date: Date { .now }
    
    private var hour: String { date.formatted(.dateTime.hour(.twoDigits(amPM: .omitted))) }
    private var minute: String { date.formatted(.dateTime.minute(.twoDigits)) }
    private var amPm: String { String(date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated))).suffix(2)) }
    
    private var day: String { date.formatted(.dateTime.day(.twoDigits)) }
    private var month: String { date.formatted(.dateTime.month(.wide)) }
    private var year: String { date.formatted(.dateTime.year()) }
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack(alignment: .center) {
                Text(date.formatted(.dateTime.weekday(.wide)))
                    .font(.title)
            }
            
            HStack(alignment: .center) {
                Text(hour)
                    .font(.title2)
                    //.padding(10)
                
                Text(":")
                    .font(.title2)
                
                Text(minute)
                    .font(.title2)
                    //.padding(10)
                    .clipShape(Circle())
                
                Text(amPm)
                    .font(.title2)
            }
        }
        //.foregroundColor(.black)
    }
}

struct DateTimeViewType7: View {
    var date: Date { .now }
    
    private var day: String { date.formatted(.dateTime.day(.twoDigits)) }
    private var month: String { date.formatted(.dateTime.month(.wide)) }
    private var year: String { date.formatted(.dateTime.year()) }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5.0) {
            HStack(alignment: .center) {
                Text("\(date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)).minute()))")
                    .font(.largeTitle)
                    .bold()
            }
            
            HStack(alignment: .center, spacing: 15.0) {
                Text(day)
                    .font(.title2)
                    .padding(10)
                    .background(.white)
                    .clipShape(Circle())
                
                Text(month)
                    .font(.title2)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background(.white)
                    .clipShape(Capsule())
                
                Text(year)
                    .font(.title2)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background(.white).background(.white)
                    .clipShape(Capsule())
                    //.foregroundColor(.white)
            }
            //.foregroundColor(.black)
        }
        //.foregroundColor(.black)
    }
}

struct DateTimeViewType8: View {
    var date: Date { .now }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(date.formatted(.dateTime.month(.wide).day().year()))
                .font(.title2)
        }
        //.foregroundColor(.black)
    }
}


#Preview {
    DateTimeViewType5()
}
