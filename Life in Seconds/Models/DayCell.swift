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
        
        let dF = DateFormatter()
        dF.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        dF.dateFormat = "dd"
        self.day = dF.string(from: date) + " "
        
        let weekDay = dF.shortWeekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        self.weekDay = weekDay
        
        dF.dateFormat = "MMMM"
        self.month = dF.string(from: date)
        
        dF.dateFormat = "yyyy"
        self.year = dF.string(from: date)
 }
     
}
