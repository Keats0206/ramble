//
//  BigPlayerView.swift
//  Ramble
//
//  Created by Peter Keating on 10/9/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct BigPlayerView: View {
    var ramb: Ramb2
    var player: AVPlayer
    
    var body: some View {
        VStack{
            VStack{
                    Spacer(minLength: 0)

                    WebImage(url: URL(string: ramb.user.profileImageUrl))
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                    
                    Text("@ \(ramb.user.displayname)")
                        .foregroundColor(.gray)
                        .padding(.top,20)
                    
                    Text(ramb.user.username)
                        .foregroundColor(.gray)
                        .padding(.top,20)
                    
                    Text(ramb.caption)
                        .font(.system(size: 22,weight: .regular, design: .rounded))
                        .padding(.top,10)
                        .padding(.horizontal)
                    
                    AudioView(player: player)
                    
                    Spacer(minLength: 0)
                }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("bg"))
            .cornerRadius(35)
            
        }
    }
}

struct BigPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        BigPlayerView(ramb: _ramb2, player: _player)
    }
}
