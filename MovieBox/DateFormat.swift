//
//  DateFormat.swift
//  MovieBox
//
//  Created by Uriel Castillo on 19/02/24.
//

import Foundation

extension String {
    func movieFormat() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")

        if let date = inputFormatter.date(from: self) {
            let newDateString = outputFormatter.string(from: date)
            return newDateString
        } else {
            print("Invalid date")
            return ""
        }
    }
}
