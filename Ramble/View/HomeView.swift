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
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessions: SessionSettings
    @EnvironmentObject var globalPlayer: GlobalPlayer
    
    @ObservedObject var viewModel = RambService2()
    @ObservedObject var timerManager = TimerManager()
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var shareService = ShareService()
    
    @Binding var user: User
    
    @State var showShareMenu: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @State var length: Double = 0
    @State var showProfile: Bool = false
    @State var showList: Bool = false
    @State var rambUrl: String?
    @State var viewControl: ViewControl = .create
    
    var buttonSize: CGFloat {
        80
    }
    func uploadRamb2(user: User, caption: String, rambUrl: String, fileId: String, length: Double, fileUrl: URL) {
        let timestamp = Int(NSDate().timeIntervalSince1970) * -1
        let length = length
        let uid = user.id!
        let caption = "Untitled \(Date().toString(dateFormat: "MMM d"))"
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
        let rambId = viewModel.addRamb(ramb)
        viewModel.fetchRamb(rambId: rambId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            globalPlayer.setGlobalPlayer(ramb: viewModel.lastUploadRamb)
            viewControl = .recordings
        }
    }
    func updateCaption(ramb: Ramb2, caption: String) {
        viewModel.updateCaption(ramb: ramb, caption: caption)
    }
    
    var body: some View {
            NavigationView {
                ZStack {
                    GeometryReader { geometry in
                        Image("gradient2")
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
                                    EmptyView()
                                case .recordings:
                                    RambUserList(user: user)
                                }
                            }
                            .innerShadow(color: Color.white.opacity(viewControl == .recordings ? 0.1 : 0.0 ), radius: 0.07)
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
                    }
//                    .actionSheet(isPresented: $showShareMenu, content: {
//                        self.actionSheet
//                    })
                }
                .alert(isPresented: $shareService.wasError) {
                    Alert(title: Text("Error sharing to Instagram"),
                          message: Text("Try again, sorry!"),
                          dismissButton: .default(Text("Got it!")))
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
}

private extension HomeView {
    var createView: some View {
        ZStack(alignment: .bottom) {
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
                    ZStack {
                        RecordingAnimation()
                        Button(action: {
                            audioRecorder.stopRecording()
                            timerManager.stop()
                        }) {
                        Image(systemName: "stop.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
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
                            timerManager.reset()
                    }
                }
            }
            .foregroundColor(.white)
    }
    var recordingsView: some View {
        VStack {
            if globalPlayer.playingRamb == nil {
                Text("Nothing playing, select a ramble above!")
                    .font(.headline)
                    .foregroundColor(.white)
            } else {
                HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            TextField("\(globalPlayer.playingRamb!.caption)", text: $globalPlayer.caption, onCommit: {
                                updateCaption(ramb: globalPlayer.playingRamb!, caption: globalPlayer.caption)
                              }).font(.headline)
                            
                            Text("\(formatDate(timestamp: globalPlayer.playingRamb!.timestamp)) ago")
                                .font(.system(size: 16, weight: .bold))
                                .bold()
                                .opacity(0.5)
                        }
                        NavigationLink(destination: ShareView(ramb: globalPlayer.playingRamb!, user: user)){
                            Text("Share")
                                 .font(.headline)
                        }
                    }.foregroundColor(.white)
                    .padding()
        
                ControlsView()
                
            }
        }
    }
//    var actionSheet: ActionSheet {
//        ActionSheet(title: Text("Share Menu"),
//                buttons: [
//                    .default(Text("Instagram Stories")) { shareService.shareToSocial(ramb: globalPlayer.playingRamb!, social: SocialPlatform.instagram)},
////                    .default(Text("Facebook Stories")) { shareService.shareToSocial(ramb: globalPlayer.playingRamb!)},
////                    .default(Text("Snap Stories")) { shareService.shareToSocial(ramb: globalPlayer.playingRamb!)},
////                    .default(Text("Twitter Stories")) { shareService.shareToSocial(ramb: globalPlayer.playingRamb!)},
//                    .destructive(Text("Cancel"))
//                ])
//    }
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
                .foregroundColor(viewControl == .create ? .white : .gray)
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
                .foregroundColor(viewControl == .recordings ? .white : .gray)
                .background(Color.white.opacity(viewControl == .recordings ? 0.2 : 0.0))
                .cornerRadius(8.0)
                .buttonStyle(ScaleButtonStyle())
            Spacer()
        }.padding(.top)
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


extension View {
    func innerShadow(color: Color, radius: CGFloat = 0.1) -> some View {
        modifier(InnerShadow(color: color, radius: min(max(0, radius), 1)))
    }
}

private struct InnerShadow: ViewModifier {
    var color: Color = .gray
    var radius: CGFloat = 0.1

    private var colors: [Color] {
        [color.opacity(0.60), color.opacity(0.0), .clear]
    }

    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .overlay(LinearGradient(gradient: Gradient(colors: self.colors), startPoint: .bottom, endPoint: .top)
                    .frame(height: self.radius * self.minSide(geo)),
                         alignment: .bottom)
        }
    }

    func minSide(_ geo: GeometryProxy) -> CGFloat {
        CGFloat(3) * min(geo.size.width, geo.size.height) / 2
    }
}
