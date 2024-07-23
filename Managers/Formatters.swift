//
//  Formatters.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import Foundation

func getDateString(date: Date) -> String{
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

    return dateFormatter.string(from: date)
    
}

func getTimeString(date: Date) -> String{
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "HH:mm"

    return dateFormatter.string(from: date)
    
}

func getMonthAndYearFromString(from dateString: String) -> (year: Int, month: Int)? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    if let date = dateFormatter.date(from: dateString) {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else {
            return nil
        }
        return (year, month)
    } else {
        return nil
    }
}

func getCurrentYearAndMonth() -> (year: Int, month: Int) {
    let currentDate = Date()
    let calendar = Calendar.current
    
    let components = calendar.dateComponents([.year, .month], from: currentDate)
    
    if let year = components.year, let month = components.month {
        return (year, month)
    } else {
        return (0, 0)
    }
}

func formatNumber(_ number: Double) -> String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 0
    numberFormatter.locale = Locale(identifier: "id_ID")
    
    return numberFormatter.string(from: NSNumber(value: number))
}
