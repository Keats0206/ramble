//
//  BigPlayerView.swift
//  Ramble
//
//  Created by Peter Keating on 10/9/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct BigPlayerView: View {
    @State var width : CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
    @State var timer = Timer.publish(every: 0.5, on: .current, in: .default).autoconnect()
    @State var angle : Double = 0
    
    var body: some View {
        
        VStack{
            
            // TOpView....
            
            HStack{
                
                Button(action: {}) {
                    
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.black)
                }
                
                Spacer(minLength: 0)
                
                Button(action: {}) {
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            VStack{
                
                Spacer(minLength: 0)
                
                ZStack{
                    
                    // Album Image...
                    Circle()
                        .frame(width: width, height: width)
                    
                    ZStack{
                        
                        // SLider...
                        Circle()
                            .trim(from: 0, to: 0.8)
                            .stroke(Color.black.opacity(0.06),lineWidth: 4)
                            .frame(width: width + 45, height: width + 45)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(angle) / 360)
                            .stroke(Color("orange"),lineWidth: 4)
                            .frame(width: width + 45, height: width + 45)
                        
                        // Slider Circle...
                        
                        Circle()
                            .fill(Color("orange"))
                            .frame(width: 25, height: 25)
                            // Moving View...
                            .offset(x: (width + 45) / 2)
                            .rotationEffect(.init(degrees: angle))
                        // gesture...
//                            .gesture(DragGesture().onChanged(homeData.onChanged(value:)))
                        
                        
                    }
                    // Rotating View For Bottom Facing...
                    // Mid 90 deg + 0.1*360 = 36
                    // total 126
                    .rotationEffect(.init(degrees: 126))
                    
                    // Time Texts....
                    
                    Text("3:30")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .offset(x: UIScreen.main.bounds.height < 750 ? -65 : -85 , y: (width + 70) / 2)

                    Text("3:30")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .offset(x: UIScreen.main.bounds.height < 750 ? 65 : 85 , y: (width + 70) / 2)
                }
                
                Text("Pete Keating")
                    .foregroundColor(.gray)
                    .padding(.top,20)
                
                Text("This is a song about how to be wild")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .padding(.top,10)
                    .padding(.horizontal)
                    .lineLimit(1)
                
                HStack(spacing: 55){
                    
                    Button(action: {}) {
                        
                        Image(systemName: "backward.fill")
                            .font(.title)
                    }
                    
                    Button(action: {
                        print("Playe")
                    }) {
                        
                        Image(systemName: "play.fill")
                            .font(.title)
                            .padding(20)
                            .background(Color("orange"))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {}) {
                        
                        Image(systemName: "forward.fill")
                            .font(.title)
                    }
                }
                .padding(.top,25)
                
                //Volume Control....
                
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .background(Color("bg"))
            .cornerRadius(35)
            
            HStack(spacing: 0){
                
                ForEach(buttons,id: \.self){name in
                    
                    Button(action: {}) {
                        Image(systemName: name)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    
                    if name != buttons.last{Spacer(minLength: 0)}
                }
            }
            .padding(.horizontal,35)
            .padding(.top,25)
            .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom != 0 ? 5 : 15)
        }
        .background(
        
            VStack{
                Color("Color")
                Color("Color1")
            }
            .edgesIgnoringSafeArea(.all)
        )
    }
    var buttons = ["suit.heart.fill","star.fill","eye.fill","square.and.arrow.up.fill"]
}

struct BigPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        BigPlayerView()
    }
}
