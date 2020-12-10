//
//  Extensions.swift
//  Ramble
//
//  Created by Peter Keating on 9/29/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    static let primaryBackground = Color(red: 25/255, green: 21/255, blue: 22/255) /* #191516 */
    static let secondaryBackground = Color(red: 85/255, green: 83/255, blue: 88/255) /* #555358 */
    static let accent1 = Color(red: 56/255, green: 255/255, blue: 18/255) /* #38ff12 */
    static let accent2 = Color(red: 255/255, green: 241/255, blue: 0/255) /* #fff100 */
    static let accent3 = Color(red: 0/255, green: 245/255, blue: 251/255) /* #00f5fb */
    static let accent4 = Color(red: 255/255, green: 0/255, blue: 227/255) /* #ff00e3 */
    static let flatDarkBackground = Color(red: 38/255, green: 38/255, blue: 38/255) /* #262626 */

    static let flatDarkCardBackground = Color(red: 77/255, green: 77/255, blue: 77/255) /* #4d4d4d */
 
// swiftlint:disable identifier_name
// swiftlint:disable large_tuple
    
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

// swiftlint:enable identifier_name
//
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()

        // update the appearance

        navigationBar.standardAppearance = appearance
        navigationBar.backIndicatorImage = UIImage(systemName: "arrowshape.up.and.left")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrowshape.up.and.left")
    }
}

struct CornerShape: Shape {
    var corner: UIRectCorner
    var size: CGSize
        func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: size)
        return Path(path.cgPath)
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemChromeMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
