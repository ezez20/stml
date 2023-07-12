//
//  MainScreenView.swift
//  stml
//
//  Created by Ezra Yeoh on 7/12/23.
//

import SwiftUI

struct MainScreenView: View {
    
    @State private var isConnected = false
    @State private var spotifyController: SpotifyController
    
    init(isConnected: Bool = false, spotifyController: SpotifyController) {
        self.isConnected = isConnected
        self.spotifyController = spotifyController
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack {
                
                Spacer()

                HStack {
                    
                    Spacer()
                    .frame(width: geo.size.width/3)
                    
                    // Capture button
                    Button { }
                    label: {
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width:  100, height: 100)
                        .foregroundColor(.yellow)
                    
                    }
                    .frame(width: geo.size.width/3)
                    
                    Spacer()
                    
                    // Capture button
                    Button { }
                    label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .resizable()
                        .frame(width: 35, height: 30)
                        .foregroundColor(.gray)
                        .padding()
                    }
                    .frame(width: geo.size.width/3)
                    
                }
                .padding(.bottom, 20)
                
            }
            .background(.mint)
            
        }
        
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(spotifyController: SpotifyController())
    }
}
