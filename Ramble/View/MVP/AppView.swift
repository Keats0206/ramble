//
//  AppView.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.

import SwiftUI
import Foundation
import MinimizableView
import UIKit

@available(iOS 14.0, *)
struct AppView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var globalPlayer: GlobalPlayer
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var viewModel = RambService2()
            
    @State var user: User    
    @State var hidNav = false
    @State var recordingModalShown = false
    @State private var selection = 0
    @State private var position = CardPosition.bottom
    @State private var background = BackgroundStyle.blur
    @State var actionState: Int? = 0
    @State var selectedUser: User = testUser
        
    @State var rambUrl: String = ""
    @State var length: Double = 0.0
            
    private var actionSelection: Binding<Int> {
        Binding<Int>(get: {
            self.selection
        }) { (newValue: Int) in
            if newValue == 1 {
                self.recordingModalShown = true
            } else {
                self.selection = newValue
            }
        }
    }

    func getUser() {
        let uid = session.session!.id!
        UserService2.shared.fetchUser(uid: uid) { user in
            self.user = user
            print(user)
            return
        }
    }
    
    var body: some View {
        ZStack {
            HomeView(user: user)
        }
        .onAppear {
            self.getUser()
            viewModel.setUp(globalPlayer: self.globalPlayer)
        }
    }
}
