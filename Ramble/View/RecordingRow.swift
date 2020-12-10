//
//  RecordingRow.swift
//  Ramble
//
//  Created by Peter Keating on 11/23/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct RambRow: View {
    @State var showShareMenu: Bool = false

    var ramb: Ramb2
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("\(ramb.caption)")
                            .font(.headline)
                        Text("\(formatDate(timestamp: ramb.timestamp)) ago")
                            .font(.subheadline)
                            .bold()
                            .opacity(0.5)
                    }
                    Spacer()
                    Text("\(TimeHelper.formatSecondsToHMS(ramb.length))")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }.padding(.bottom)
            }
        }
    }
}

private extension RambRow {
    var recordingRowBottom: some View {
        HStack {
            Spacer()
            HStack(spacing: 20) {
                Button(action: {
                    print("Show share to IG menu")
                }) {
                    Image(systemName: "backward.end.fill")
                }
                Button(action: {
                    print("Show share to IG menu")
                }) {
                    Image(systemName: "play.fill")
                }
                Button(action: {
                    print("Show share to IG menu")
                }) {
                    Image(systemName: "goforward.15")
                }
            }
            .foregroundColor(Color.primary)
            
        }.font(.title)
            .buttonStyle(BorderlessButtonStyle())
    }
}
