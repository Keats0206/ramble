//
//  FeedView.swift
//  Ramble
//
//  Created by Peter Keating on 4/21/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh
import UIKit
import SDWebImageSwiftUI

struct RambFeed : View {
    @EnvironmentObject var sessionSettings: SessionSettings
    @ObservedObject var viewModel = RambService()
    @Binding var dataToggle: Int
    @State private var isShowing = false
    
    init(_ model: RambService, dataToggle: Binding<Int>){
        self.viewModel = model
        self._dataToggle = dataToggle
        model.observeRambs()
    }
    
    var body: some View {
        
        VStack{
            
            ScrollView{
                
                if dataToggle != 1 {
                    
                    ForEach(viewModel.rambs.sorted(by: { $0.claps > $1.claps })){ ramb in
                        
                        RambCell(ramb: ramb)
                    
                    }
                    
               } else {
                                    
                    ForEach(viewModel.rambs.sorted(by: { $0.timestamp < $1.timestamp })){ ramb in

                        RambCell(ramb: ramb)

                    }
                    
                }
                
            }
        }
        .padding()
        .environmentObject(SessionSettings())
            .pullToRefresh(isShowing: $isShowing) {
                    self.viewModel.observeRambs()
                    self.isShowing = false
            }
        
        }
    
    }
