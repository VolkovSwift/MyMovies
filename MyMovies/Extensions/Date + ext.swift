//
//  Date + ext.swift
//  MyMovies
//
//  Created by user on 3/5/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self)
    }
    
}
