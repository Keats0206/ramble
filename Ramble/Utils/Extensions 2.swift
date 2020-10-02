//
//  Extensions.swift
//  Ramble
//
//  Created by Peter Keating on 9/29/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    static let primaryBackground = Color(red: 25/255, green: 21/255, blue: 22/255) /* #191516 */
    static let secondaryBackground = Color(red: 85/255, green: 83/255, blue: 88/255) /* #555358 */
    static let accent1 = Color(red: 56/255, green: 255/255, blue: 18/255) /* #38ff12 */
    static let accent2 = Color(red: 255/255, green: 241/255, blue: 0/255) /* #fff100 */
    static let accent3 = Color(red: 0/255, green: 245/255, blue: 251/255) /* #00f5fb */
    static let accent4 = Color(red: 255/255, green: 0/255, blue: 227/255) /* #ff00e3 */
    static let flatDarkBackground = Color(red: 38/255, green: 38/255, blue: 38/255) /* #262626 */

    static let flatDarkCardBackground = Color(red: 77/255, green: 77/255, blue: 77/255) /* #4d4d4d */
 
    func ToUIColor() -> UIColor {

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}
