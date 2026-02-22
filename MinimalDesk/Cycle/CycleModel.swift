//
//  CycleModel.swift
//  MinimalDesk
//
//  Created by Haider on 20/2/26.
//

import Foundation

struct CycleModel: Codable {
    var title: String
    var selectedDate: Date
    var selectedTime: Date
    var repeatNumber: Int
    var repeatUnit: String
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter.string(from: selectedDate)
    }

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: selectedTime)
    }
}

extension CycleModel {
    static var empty: CycleModel {
        CycleModel(
            title: "",
            selectedDate: Date(),
            selectedTime: Date(),
            repeatNumber: 1,
            repeatUnit: "hours"
        )
    }
}
