//
//  PlayerView.swift
//  Ramble
//
//  Created by Peter Keating on 11/19/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct RecordPostView: View {
    @ObservedObject var audioRecorder = AudioRecorder()

    @Binding var position: CardPosition
    
    @State var caption = ""
    @Binding var rambUrl: String
    @Binding var length: Double
            
    @State var showAlert: Bool = false
    
    var buttonDisabled: Bool {
        caption != "" ? false : true
    }
    
    var imageScale = UIScreen.main.bounds.width * 0.7
    
    var user: User
    
    func uploadRamb2(user: User, caption: String, rambUrl: String, fileId: String, length: Double){
        let timestamp = Int(NSDate().timeIntervalSince1970) * -1
        let isSelected = false
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
            isSelected: isSelected)
        RambService2().addRamb(ramb)
    }
    
    static let rambDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
        }()
    
    var postDate = Date()
    
    var body: some View {
        if rambUrl != "" {
            VStack(alignment: .center, padding) {
                TextField("Untitled Ramb - \(postDate, formatter: Self.rambDateFormat)", text: $caption)
                    .multilineTextAlignment(.center)
                    .font(.system(.body, design: .rounded))
                                
                AudioControlView(player: AVPlayer(url: URL(string: rambUrl)!), showSlider: .constant(true))
                            
                Button(action: {
                    self.uploadRamb2(
                        user: user,
                        caption: caption,
                        rambUrl: rambUrl,
                        fileId: "",
                        length: length
                    )
                }) {
                    Text("POST")
                        .font(.system(.headline, design: .rounded))
                        .bold()
                        .padding()
                        .padding(.horizontal, 30)
                    
                }.disabled(buttonDisabled)
                    .foregroundColor(.white)
                    .background(buttonDisabled ? .gray : Color.accent3)
                    .cornerRadius(40)
                
                Spacer()

            }.padding()
        } else {
            LoadingAnimation()
        }
    }
}
