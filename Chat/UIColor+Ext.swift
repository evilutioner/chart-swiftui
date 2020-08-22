//
//  UIColor+Ext.swift
//  Chat
//
//  Created by Oleg Marchik on 8/5/20.
//  Copyright © 2020 Oleg Marchik. All rights reserved.
//

import SwiftUI

extension Color {
    init(hex: String) {
        
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)

        switch hex.count {
        case 6:
            let (red, green, blue) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
            self = Color(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
        default:
            assertionFailure()
            self = .clear
        }
    }
}
