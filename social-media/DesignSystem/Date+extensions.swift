//
//  Date+extensions.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 30/08/22.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM dd, yyyy"
        
        return formatter.string(from: self).capitalized
    }
}
