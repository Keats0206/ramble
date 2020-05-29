//
//  MusicPlayer.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//


import SwiftUI
import AVKit

struct musicPlayerTop : View {
    
    @State var data : Data = .init(count: 0)
    @State var title = ""
    @State var player : AVAudioPlayer!
    @State var playing = false
    @State var width : CGFloat = 0
    @State var songs = ["Jimi","Love"]
    @State var current = 0
    @State var finish = false
    @State var del = AVdelegate()
    
    var body : some View {
        
    VStack {
        
        //Music player cell top
        
        //Play button
        Button(action: {
                        
                        if self.player.isPlaying{
                            
                            self.player.pause()
                            self.playing = false
        
                        } else {
                            
                            if self.finish{
                                
                                self.player.currentTime = 0
                                self.width = 0
                                self.finish = false
                            }
                           
                            self.player.play()
                            self.playing = true
                            
                        }
                                        
                    }){
                        
                        Image(systemName: self.playing && !self.finish ? "pause.circle" : "play.circle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.red)
                        
        }.padding(5)
        
        //Music player cell middle
            
        VStack(){
                
                //Player controls
                
                HStack(spacing: UIScreen.main.bounds.width / 5 - 30){
                            
                            Button(action: {
                                
                                if self.current > 0 {
                                    
                                    self.current -= 1
                                    
                                    self.getChangeSongs()
                                }
                                                
                            }){
                                
                                Image(systemName: "backward.fill").font(.title)
                                
                            }
                            
                            Button(action: {
                                
                                self.player.currentTime -= 15
                                                   
                            }){
                                
                                Image(systemName: "gobackward.15").font(.title)
                                
                            }
                    
                    
//                    PLace holder for speed control
                            
                    Text("1.5x").fontWeight(.heavy)
                            
                            Button(action: {
                                
                                let increase = self.player.currentTime + 15
                                
                                if increase < self.player.duration {
                                    
                                    self.player.currentTime = increase
                                    
                                }
                                                
                            }){
                                
                                Image(systemName: "goforward.15").font(.title)
                                
                            }
                            
                            Button(action: {
                                
                                if self.songs.count - 1 != self.current {
                                    
                                    self.current += 1
                                    
                                    self.getChangeSongs()
                                    
                                }
                                                
                            }){
                                
                                Image(systemName: "forward.fill").font(.title)
                                
                            }
                        }.padding(.top, 0)
                            .foregroundColor(.red)
                
                Spacer()
                Spacer()
                
                // Current song and creator
            
                HStack(){
                        Text("Post Title").bold()
                        Text("Creator Name")
                        Spacer()
                }
               
            Spacer().frame(height: 10)
            
//              Bar that fills as the song plays
                                
                ZStack(alignment: .leading) {
            
                    Capsule().fill(Color.black.opacity(0.08)).frame(height: 8)
            
                    Capsule().fill(Color.red).frame(width: self.width, height: 8)
                        .gesture(DragGesture().onChanged({ (value) in
            
                            let x = value.location.x
        
                            self.width = x
            
                        }).onEnded({ (value) in
        
                            let x = value.location.x
            
                            let screen = UIScreen.main.bounds.width - 30
            
                            let percent = x / screen
            
                            self.player.currentTime = Double(percent) * self.player.duration
            
                        }))
            
                }
                
            }
            .onAppear {
                
                let url = Bundle.main.path(forResource: self.songs[self.current], ofType: "mp3")
                
                self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
                
                self.player.delegate = self.del
                
                self.player.prepareToPlay()
                self.getData()
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                    
                    if self.player.isPlaying{
                        
                        let screen = UIScreen.main.bounds.width - 30
                        
                        let value = self.player.currentTime / self.player.duration
                        
                        self.width = screen * CGFloat(value)
                    }
                }
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main) { (_) in
                    
                    self.finish = true
                }
                
            }
            .frame(height: 100)
            .padding()
        
//        Unused user bio cell
//        HStack{
//
//           Image("User-image")
//                   .resizable()
//                   .frame(width: 75, height: 75)
//                   .cornerRadius(25)
//
//            VStack(alignment: .leading){
//
//                HStack{
//                    Text("@Username").font(.system(size: 19)).fontWeight(.heavy)
//
//                    Spacer()
//
//                    Button(action: {
//                        print("Follow tapped!")
//                    }) {
//                        HStack {
//                            Text("Follow")
//                                .font(.system(size: 12)).fontWeight(.heavy)
//                        }
//                        .padding(5)
//                        .foregroundColor(.white)
//                        .background(Color.black)
//                        .cornerRadius(40)
//                    }
//                }
//
//
//                Text("Bio paragraph bio paragraph bio paragraph bio paragraph bio paragraph").frame(width: 250).multilineTextAlignment(.leading)
//            }
//        }.padding()
        
        //Music Player Cell Bottom

        
        VStack(alignment: .leading){
        
            Divider()
            
            Spacer().frame(height: 20)
        
            Text("Up Next").fontWeight(.heavy)
            
            ScrollView(){
                ForEach(0..<20){ indicator in
                    HStack{
                        rambleQueCell()
                    Spacer()
                    }
                }
            }
        }.padding()

    }
}
    
func getData(){
        
    let asset = AVAsset(url: self.player.url!)
        
        for i in asset.commonMetadata{
            
            if i.commonKey?.rawValue == "artwork"{
                
            let data = i.value as! Data
            self.data = data
        }
        
            if i.commonKey?.rawValue == "title"{
            
            let title = i.value as! String
            self.title = title
        
            }
        }
    }
    
    func getChangeSongs() {
        
        let url = Bundle.main.path(forResource: self.songs[self.current], ofType: "mp3")
        
        self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
        
        self.player.delegate = self.del
        
        self.data = .init(count: 0)
        
        self.title = ""
        
        self.player.prepareToPlay()
        self.getData()
        
        self.playing = true
        
        self.finish = false
        
        self.width = 0
        
        self.player.play()
    }
}

class AVdelegate : NSObject, AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}



struct musicPlayerTop_Previews: PreviewProvider {
    static var previews: some View {
        musicPlayerTop()
    }
}
