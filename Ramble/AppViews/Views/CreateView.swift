//
//  RecordView.swift
//  Ramble
//
//  Created by Peter Keating on 4/22/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct CreateView: View {
    
    var body: some View {
        
        NavigationView{

            RecorderView(audioRecorder: AudioRecorder())
                .navigationBarTitle("Recorder",displayMode: .inline)
                .navigationBarItems(leading:
                
                    HStack{
                        Image("User-image")
                .resizable().frame(width: 35, height: 35)
                .clipShape(Circle())
                .onTapGesture { print("slide out menu .....")
                    }
                },
                trailing:
                    HStack{
                        EditButton()
                    }
            )
        }
    }
}
    
struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
