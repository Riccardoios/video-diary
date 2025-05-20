//
//  DayCell.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 01/01/22.
//

import UIKit

struct DayCell {
    var date: Date
    var day: String
    var weekDay: String
    var month: String
    var year: String
    var isSelected: Bool
    var image: UIImage?
    var isGrayedout: Bool
    
    init(date:Date, image:UIImage?) {
        self.date = date
        self.image = image
        self.isSelected = false
        self.isGrayedout = false
        
        // day-of-month ("1", "2", ..., "31")
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        dateFormatter.calendar = calendar
        dateFormatter.locale   = Locale.current
        dateFormatter.dateFormat = "dd"
        self.day = dateFormatter.string(from: date)

        // abbreviated weekday ("Mon", "Tue", etc.), correctly indexed
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.calendar = calendar
        weekdayFormatter.locale   = Locale.current
        // use the standalone symbols so you don’t get context-dependent forms
        let symbols = weekdayFormatter.shortStandaloneWeekdaySymbols
        // Calendar.weekday is 1 for Sunday … 7 for Saturday, so subtract 1
        let weekdayIndex = calendar.component(.weekday, from: date) - 1
        self.weekDay = symbols?[weekdayIndex] ?? ""
        
        dateFormatter.dateFormat = "MMMM"
        self.month = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "yyyy"
        self.year = dateFormatter.string(from: date)
 }
     
}
