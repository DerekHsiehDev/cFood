//
//  DetailView.swift
//  cFood-swiftUI
//
//  Created by Derek Hsieh on 11/29/20.
//

import SwiftUI

let screen = UIScreen.main.bounds

struct DetailView: View {
    @State var show = false
    @State var activeView = CGSize.zero
    
    
    var body: some View {
        
        
        VStack {
            Spacer()
            ZStack(alignment: .top) {
                Text("awesifjuawoeifjawoeifjawoiefjawoeifjoaweifjoaweijfoawejifasdfjlaisejflaiejflaiwejflawijeflwiajefliwaejfliawjefliwjaefiljwaelfijawilefjlwiaejflwiajefliawjelfijwaleifjlaweijflawjieflwiejflij")
                    .padding(30)
                    .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? .infinity : 100)
                    .offset(y: show ? -100 : 0)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    .opacity(show ? 1: 0)
                
                VStack {
                    
                    Spacer()
                    
                    HStack() {
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 8.0) {
                            
                            if show {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.white)
                                    }    .frame(width: 36, height: 36)
                                    .background(Color.black)
                                    .clipShape(Circle())
                                }
                            }
                            
                            Spacer()
                            
                            Text(show ? "Hot Dog" : "34")
                                .font(.system(size: show ? 40 : 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.top, show ? 15 : 0)
                            
                            
                            
                            
                            
                            
                        }
                        Spacer()
                        
                        
                    }
                    Spacer()
                    
                }
                .padding(show ? 30 : 20)
                .padding(.top, show ? 30 : 0)
                //        .frame(width: show ? screen.width : screen.width - 60, height: show ? screen.height : 280)
                .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? 300 : 100)
                .background(show ? Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)) : Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)).opacity(0.3), radius: 20, x: 0, y: 20)
                .onTapGesture {
                    self.show.toggle()
                }
                
            }
            .frame(height: show ? screen.height: 200)
            .scaleEffect(1 - self.activeView.height/1000)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            .edgesIgnoringSafeArea(.all)
            .gesture(
                DragGesture().onChanged { value in
                    self.activeView = value.translation
                }
                .onEnded { value in
                    if self.activeView.height > 50 {
                        self.show = false
                    }
                    self.activeView = .zero
                }
                
        )
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
