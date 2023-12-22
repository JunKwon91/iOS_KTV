//
//  DateComponentsFormatterExtension.swift
//  KTV
//
//  Created by 박준권 on 12/22/23.
//

import Foundation

extension DateComponentsFormatter {
    static let playTimeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        return formatter
    }()
}
