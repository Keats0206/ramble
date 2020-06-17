//
//  ProfileHeader.swift
//  Ramble
//
//  Created by Peter Keating on 4/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct ProfileHeader: View {
    var body: some View {
        
        VStack{
            VStack{
                Image("User-image")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .cornerRadius(80, corners: [.bottomLeft, .bottomRight])
                
                Text("@Username").font(.system(size: 25)).fontWeight(.heavy)
                
                Spacer().frame(height: 10)
                
                Text("Listeners/Following").font(.system(size: 18))
                
                Spacer().frame(height: 10)
                
                Text("This is my bio where I tell you about who I am and what I do").font(.system(size: 16))
                
                Divider()
            }
            .frame(width: 200)
            .padding(.vertical, 15)
        }
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
