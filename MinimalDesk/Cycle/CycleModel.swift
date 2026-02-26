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
    var repeatNumber: Int
    var repeatUnit: String
    var completedCycles: [Int: Date]
    //var mark: Bool = false
    //var markDate: Date = Date()
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy 'at' hh:mm a"
        return formatter.string(from: selectedDate)
    }
}

extension CycleModel {
    static var empty: CycleModel {
        CycleModel(
            title: "",
            selectedDate: Date(),
            repeatNumber: 1,
            repeatUnit: "hours",
            completedCycles: [:]
        )
    }
}
