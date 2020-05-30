//
//  ProfilePic.swift
//  Ramble
//
//  Created by Peter Keating on 5/29/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfilePic : View {

    @ObservedObject var observedData = getData()
    
     var userimage = ""

    var body: some View {
                
        Image(userimage).resizable().frame(width: 35, height: 35).clipShape(Circle()).onTapGesture {
            
            print("slide out menu ....")
        }
    }
}

struct ProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePic()
    }
}
