//
//  HomeView.swift
//  Ramble
//
//  Created by Peter Keating on 11/19/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var user: User
    @State var showProfile: Bool = false
    @State var showList: Bool = false
    
    @State var viewControl: ViewControl = .recordings
    
    var body: some View {
        NavigationView{
            ZStack{
                GeometryReader { geometry in
                    
                    Image("gradient")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    
                    Blur(style: .dark)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack{
//                  UpperView
                    HStack{
                        switch viewControl {
                        case .create:
                            VStack(alignment: .leading){
                                HStack{
                                    Text("Tap the circle to start recording!")
                                        .font(.title)
                                        .bold()
                                    Spacer()
                                }
                                Spacer()
                            }.padding()
                        case .recordings:
                            RecordingsList()
                                .animation(.easeInOut)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
//                  AudioRecodView
                    HStack {
                        RecordView(viewControl: $viewControl, user: user)
                    }
                    .frame(height: UIScreen.main.bounds.height / 5)
//                  TabView
                    HStack{
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
                }
            }
        }
        .background(Blur())
        .navigationBarItems(leading:
                    Button(action: {
                        self.showProfile.toggle()
                    }) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.accent3)
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

