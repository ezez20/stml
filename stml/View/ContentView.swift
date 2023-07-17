//
//  ContentView.swift
//  stml
//
//  Created by Ezra Yeoh on 6/15/23.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var spotifyController: SpotifyController
    @State private var isConnected = false
    
    // MARK: - View
    var body: some View {
        
        GeometryReader { geo in
            
            if spotifyController.appRemote.isConnected == false {
                
                VStack {
                    ConnectToSpotifyView(spotifyController: spotifyController)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            
            } else {
                
                TabView {
                    
                    ReadView()
                        .tabItem {
                            Label("Read", systemImage: "book")
                        }
                    
                    MainScreenView(spotifyController: spotifyController)
                        .tabItem {
                            Label("Capture", systemImage: "camera")
                        }
                    
                    JournalView()
                        .tabItem {
                            Label("Journal", systemImage: "square.and.pencil")
                        }
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .tabViewStyle(PageTabViewStyle())
                .onAppear {
                    UITabBar.appearance().backgroundColor = UIColor.secondarySystemBackground
                    UITabBar.appearance().isTranslucent = true
                }
                
            }
            
        }
        .ignoresSafeArea()
        .onChange(of: spotifyController.trackLabelText) { v in
            print("onChange")
            if spotifyController.appRemote.isConnected {
                isConnected = true
                print("DDD: Connected")
            } else {
                isConnected = false
                print("DDD: Not connected")
            }
        }
        
    }
    
    // MARK: - Functions
    
}


// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(spotifyController: SpotifyController()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
