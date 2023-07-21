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
    @State private var showPlayerControl = false
    
    init(isConnected: Bool = false, spotifyController: SpotifyController) {
        self.isConnected = isConnected
        self.spotifyController = spotifyController
    }
    
    //    @StateObject private var cameraVM = CameraViewModel()
    //    @StateObject private var cameraManager = CameraManager()
    @StateObject private var model = CameraFrameHandler()
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                Image(uiImage: (spotifyController.albumImage ?? UIImage())!)
                    .resizable()
                    .ignoresSafeArea()
                
                ZStack {
                    
                    CameraFrameView(image: model.frame, takenImage: model.image)
                        .cornerRadius(20)
                        .frame(width: geo.size.width - 10, height: geo.size.height - 100)
//                        .onTapGesture {
//                            showPlayerControl.toggle()
//                        }

                    
                    VStack {
                        
                        // MARK: - Top half/Player Controls
                            VStack {
                                
                                // Album/Song/Arist view
                                HStack {
                                    Image(uiImage: (spotifyController.albumImage ?? UIImage(named: "Image"))!)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .padding(5)
                                    
                                    VStack {
                                        
                                        Text(spotifyController.trackLabelText)
                                            .font(.body)
                                        
                                        Text(spotifyController.artistLabelText)
                                            .font(.caption)
                                        
                                    }
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                }
                                
                                // Player controls
                                HStack {
                                    
                                    Button {
                                        spotifyController.tappedSkipPreviousButton()
                                    } label: {
                                        Image(systemName: "backward.end.circle.fill")
                                    }
                                    
                                    Button {
                                        spotifyController.tappedPauseOrPlay()
                                    } label: {
                                        Image(systemName: spotifyController.playingState ? "pause.circle.fill" : "play.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    }
                                    .padding()
                                    
                                    Button {
                                        spotifyController.tappedSkipForwardButton()
                                    } label: {
                                        Image(systemName: "forward.end.circle.fill")
                                    }
                                    
                                }
                                .foregroundColor(.white)
                                
                                
                            }
                            .frame(width: geo.size.width)
                        
                        
                        Spacer()
                        
                        // MARK: - Bottom half/Camera button
                        HStack {
                            
                            Spacer()
                                .frame(width: geo.size.width/3)
                            
                            // Capture button
                            Button {  print("Camera button tapped")
                                model.capturePhoto()
                                } label: {
                            Image(systemName: "circle")
                                .resizable()
                                .frame(width:  80, height: 80)
                                .foregroundColor(.green)
                        }
                        .frame(width: geo.size.width/3)
                            
                            
                            Spacer()
                            
                            // Flip Camera button
                            Button {
                                model.discardPhoto()
                            } label: {
                                Image(systemName: model.image == nil ? "arrow.triangle.2.circlepath.camera.fill" : "trash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                                .padding()
                        }
                            
                            Spacer()
                    
                        }
                        .padding(.bottom, 70)
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .background(.ultraThinMaterial)
                
            }
        
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(spotifyController: SpotifyController())
    }
}
