//
//  MainScreenView.swift
//  stml
//
//  Created by Ezra Yeoh on 7/12/23.
//

import SwiftUI

struct MainScreenView: View {
    
    @State private var isConnected = false
    @ObservedObject var spotifyController: SpotifyController
    
    init(isConnected: Bool = false, spotifyController: SpotifyController) {
        self.isConnected = isConnected
        self.spotifyController = spotifyController
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack {
                
                // MARK: - Top half/Player Controls
                VStack {
                    
                    // Album/Song/Arist view
                    HStack {
                        Image(uiImage: (spotifyController.albumImage ?? UIImage())!)
                            .resizable()
                            .frame(width: 40, height: 40)
                   
                        VStack {
                            
                            Text(spotifyController.trackLabelText)
                                .font(.body)

                            Text(spotifyController.artistLabelText)
                                .font(.caption)
                            
                        }
                        .frame(height: 40)
                    }
              
                    
                    // Player controls
                    HStack {
                        
                        Button {
                            spotifyController.tappedSkipPreviousButton()
                        } label: {
                            Image(uiImage: UIImage(systemName: "backward.end.circle.fill")!)
                        }
                        
                        Button {
                            spotifyController.tappedPauseOrPlay()
                        } label: {
                            Image(uiImage: (spotifyController.playPauseImage ?? UIImage(systemName: "play.circle.fill"))!)
                        }
                        .padding()
                        
                        Button {
                            spotifyController.tappedSkipForwardButton()
                        } label: {
                            Image(uiImage: UIImage(systemName: "forward.end.circle.fill")!)
                        }
                        
                    }
                    
                }
                .frame(width: geo.size.width - 20)
                
                Spacer()
                
                // MARK: - Bottom half/Camera button
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
            .frame(width: geo.size.width, height: geo.size.height)
            
        }
        
    }

}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(spotifyController: SpotifyController())
    }
}
