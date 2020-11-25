//
//  HomeView.swift
//  Ramble
//
//  Created by Peter Keating on 11/19/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var globalPlayer: GlobalPlayer
    
    @State private var keyboardHeight: CGFloat = 0
    
    @State var user: User
    @State var showProfile: Bool = false
    @State var showList: Bool = false
    
    @State var viewControl: ViewControl = .create
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    Image("gradient")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    Blur(style: .dark)
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                    VStack{
//                  UpperView
                        HStack {
                            switch viewControl {
                            case .create:
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Untitled Record #1")
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    Spacer()
                                }.padding()
                            case .recordings:
                                RambUserList(user: user)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
//                  AudioRecodView
                        VStack(alignment: .center){
                            RecordPlayerView(player: globalPlayer.globalRambPlayer, viewControl: $viewControl, user: user)
                        }
                        .frame(height: UIScreen.main.bounds.height / 5)
                    }
//                  TabView
                    HStack {
                        Spacer()
                        Button(action: {
                            self.viewControl = .create
                        }){
                            Image(systemName: "music.mic")
                                .font(.title)
                        }.padding(5)
                        .foregroundColor(viewControl == .create ? .gray : .white)
                        .background(Color.white.opacity(viewControl == .create ? 0.2 : 0.0))
                        .cornerRadius(8.0)
                        Spacer()
                        Button(action: {
                            self.viewControl = .recordings
                        }){
                            Image(systemName: "music.note.list")
                                .font(.title)
                        }.padding(5)
                        .foregroundColor(viewControl == .recordings ? .gray : .white)
                        .background(Color.white.opacity(viewControl == .recordings ? 0.2 : 0.0))
                        .cornerRadius(8.0)
                        Spacer()
                    }
                        .padding(.top)
                    }.keyboardAdaptive()
                }
            }
            .background(Blur())
            .navigationBarItems(leading:
                    Button(action: {
                        self.showProfile.toggle()
                    }) {
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                    }.sheet(isPresented: $showProfile, onDismiss: {
                        print("Modal dismisses")
                    }) {
                        EditProfileView(user: $user)
                }
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: testUser)
    }
}


enum ViewControl {
    case create
    case recordings
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(y: -keyboardHeight / 2)
            .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}
