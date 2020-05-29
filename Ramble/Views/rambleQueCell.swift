//
//  RambleQueCell.swift
//  Ramble
//
//  Created by Peter Keating on 4/24/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct rambleQueCell: View {
    
    var body: some View {
            HStack{
                Image(systemName:"text.insert").padding(.trailing, 10)
                Text("Title").fontWeight(.heavy)
                Text("creator")
                
                Spacer()
                Image(systemName: "trash").padding()
            }
        
        }
    }


struct rambleQueCell_Previews: PreviewProvider {
    static var previews: some View {
        rambleQueCell()
    }
}
