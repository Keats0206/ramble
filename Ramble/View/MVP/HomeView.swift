//
//  HomeView.swift
//  Ramble
//
//  Created by Peter Keating on 11/19/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 14.0, *)
struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var globalPlayer: GlobalPlayer

    @ObservedObject var viewModel = RambService2()
    @ObservedObject var timerManager = TimerManager()
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var shareService = ShareService()
    
    @State var showShareMenu: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @State var length: Double = 0
    @State var user: User
    @State var showProfile: Bool = false
    @State var showList: Bool = false
    @State var openAudioUpload = false
    @State var rambUrl: String?
    @State var viewControl: ViewControl = .create
    
    var buttonSize: CGFloat {
        80
    }
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
                    
                    VStack {
    //                  UpperView
                        HStack {
                            switch viewControl {
                                case .create:
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Share your voice with the world")
                                                .font(.title)
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
                        VStack(alignment: .center) {
                                ZStack {
                                    if viewControl == .create {
                                        createView
                                    }
                                    if viewControl == .recordings {
                                        recordingsView
                                    }
                                }
                            }
                            .frame(height: UIScreen.main.bounds.height / 5)
    //                  TabView
                        tabControl
                    }.keyboardAdaptive()
                    
                    if shareService.shareState == true {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                LoadingAnimation()
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            }
            .background(Blur())
            .navigationBarItems(leading:
                    Button(action: {
                        self.showProfile.toggle()
                    }) {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    }
            .sheet(isPresented: $showProfile, onDismiss: {
                print("Modal dismisses")
            }) {
                EditProfileView(user: $user)
                }
            )
        }
    }
    func uploadRamb2(user: User, caption: String, rambUrl: String, fileId: String, length: Double, fileUrl: URL) {
        let timestamp = Int(NSDate().timeIntervalSince1970) * -1
        let length = length
        let uid = user.id!
        let ramb = Ramb2(
            caption: caption,
            length: length,
            rambUrl: rambUrl,
            fileId: fileId,
            timestamp: timestamp,
            plays: 0,
            user: user,
            uid: uid,
            fileUrl: fileUrl)
        globalPlayer.setGlobalPlayer(ramb: ramb)
        RambService2().addRamb(ramb)
    }
    func updateCaption(ramb: Ramb2, caption: String) {
        viewModel.updateCaption(ramb: ramb, caption: caption)
    }
    func shareToIG(ramb: Ramb2) {
        ShareService.shared.shareToIGLocal(
            ramb: ramb
        )
    }
}

@available(iOS 14.0, *)
private extension HomeView {
    var createView: some View {
        ZStack {
            Text(String(format: "%.1f", timerManager.secondsElapsed))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white).opacity(0.5)
                .offset(y: 60)
                switch audioRecorder.recorderState {
                case .ready:
                    Button(action: {
                        audioRecorder.startRecording()
                        timerManager.start()
                    }) {
                        Image(systemName: "mic.circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }.buttonStyle(PlayerButtonStyle())
                case .started:
                    Button(action: {
                        audioRecorder.stopRecording()
                        timerManager.stop()
                    }) {
                        Image(systemName: "stop.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                case .stopped:
                    LoadingAnimation()
                case.uploaded:
                    Spacer()
                        .onAppear {
                            rambUrl = audioRecorder.rambUrl
                            uploadRamb2(
                                user: user,
                                caption: globalPlayer.caption,
                                rambUrl: rambUrl!,
                                fileId: "fileId",
                                length: timerManager.secondsElapsed,
                                fileUrl: audioRecorder.recordings[0].fileUrl
                            )
                            viewControl = .recordings
                            timerManager.reset()
                    }
                }
            }.foregroundColor(.white)
    }
    var recordingsView: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    TextField("\(globalPlayer.playingRamb.caption)", text: $globalPlayer.caption, onCommit: {
                        updateCaption(ramb: globalPlayer.playingRamb, caption: globalPlayer.caption)
                      })
                        .font(.title)
                        .foregroundColor(.white)
                    Text("\(formatDate(timestamp: globalPlayer.playingRamb.timestamp)) ago")
                        .font(.system(size: 18, weight: .bold))
                        .bold()
                        .opacity(0.5)
                }
                Button(action: {
                    self.showShareMenu.toggle()
                }) {
                   Text("Share")
                        .font(.headline)
                }
                .actionSheet(isPresented: $showShareMenu, content: {
                    self.actionSheet })
            }
            .padding()
            Controls()
        }
    }
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Share Menu"),
                buttons: [
                    .default(Text("Instagram Stories")) {
                    shareService.shareState = true
                    self.shareToIG(ramb: globalPlayer.playingRamb)
                },
                    .destructive(Text("Cancel"))
                ])
    }
    var tabControl: some View {
        HStack {
            Spacer()
            Button(action: {
                self.viewControl = .create
            }) {
                Image(systemName: "music.mic")
                    .font(.title)
            }
            .padding(5)
            .foregroundColor(viewControl == .create ? .gray : .white)
            .background(Color.white.opacity(viewControl == .create ? 0.2 : 0.0))
            .cornerRadius(8.0)
            .buttonStyle(ScaleButtonStyle())
            Spacer()
            Button(action: {
                self.viewControl = .recordings
            }) {
                Image(systemName: "music.note.list")
                    .font(.title)
            }
            .padding(5)
            .foregroundColor(viewControl == .recordings ? .gray : .white)
            .background(Color.white.opacity(viewControl == .recordings ? 0.2 : 0.0))
            .cornerRadius(8.0)
            .buttonStyle(ScaleButtonStyle())
            Spacer()
        }.padding(.top)
    }
    
}

@available(iOS 14.0, *)
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
