//
//  DateExtended.swift
//  Geese
//
//  Created by Mohit Goyal on 15/08/18.
//  Copyright © 2018 Mohit Goyal. All rights reserved.
//

import Foundation

extension Date {
    var isInToday: Bool { Calendar.current.isDateInToday(self) }
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return Date()}

        return localDate
    }
}
