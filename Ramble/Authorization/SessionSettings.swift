//
//  UserSettings.swift
//  Ramble
//
//  Created by Peter Keating on 7/2/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation

class SelectedRamb: ObservableObject {
    @Published var user: User?
    @Published var userProfileShown: Bool = false
}

class SessionSettings: ObservableObject {
    @Published var radius: Double = 25
}
