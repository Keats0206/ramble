//
//  SessionSettings.swift
//  Ramble
//
//  Created by Peter Keating on 12/10/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class SessionSettings: ObservableObject {
    @Published var firstColor: Color = .clear
    @Published var secondColor: Color = .clear
    @Published var thirdColor: Color = .clear
    @Published var fourthColor: Color = .clear
    
    @Published var userUIImage: UIImage = UIImage(named: "experienced")!
    
    func setSettings(user: User) {
        setUserImage(profileImageURL: user.profileImageUrl)
    }
    
    func setUserImage(profileImageURL: String) {
        let url = URL(string: profileImageURL)!
        if let imageData = try? Data(contentsOf: url) {
            let image = UIImage(data: imageData)!
            self.setAverageColor(image: image)
            self.userUIImage = image
        }
    }
    
    func setAverageColor(image: UIImage) {
        image.getColors { colors in
            self.firstColor = Color((colors?.background)!)
            self.secondColor  = Color((colors?.primary)!)
            self.thirdColor = Color((colors?.secondary)!)
            self.fourthColor = Color((colors?.detail)!)
        }
    }
}
