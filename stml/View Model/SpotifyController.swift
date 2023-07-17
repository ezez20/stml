//
//  SpotifyController.swift
//  stml
//
//  Created by Ezra Yeoh on 7/3/23.
//

import SwiftUI
import SpotifyiOS

class SpotifyController: NSObject, ObservableObject {
    
    // MARK: - Spotify Authorization & Configuration
    var responseCode: String? {
        didSet {
            fetchAccessToken { (dictionary, error) in
                if let error = error {
                    print("Fetching token request error \(error)")
                    return
                }
                let accessToken = dictionary!["access_token"] as! String
                DispatchQueue.main.async {
                    self.appRemote.connectionParameters.accessToken = accessToken
                    self.appRemote.connect()
                }
            }
        }
    }
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    var accessToken = UserDefaults.standard.string(forKey: accessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: accessTokenKey)
        }
    }
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: spotifyClientId, redirectURL: redirectUri)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating
        // otherwise another app switch will be required
        configuration.playURI = ""
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    lazy var sessionManager: SPTSessionManager? = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    var lastPlayerState: SPTAppRemotePlayerState?
    
    @Published var trackLabelText = ""
    @Published var artistLabelText = ""
    @Published var playPauseImage = UIImage(systemName: "play.circle.fill")
    @Published var albumImage = UIImage(named: "")
    @Published var currentTrackURI = ""
    @Published var playBackPositionState = 0
    
    func update(playerState: SPTAppRemotePlayerState) {
        print("update triggered")
        if lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
        }
        
        DispatchQueue.main.async { [self] in
            print("trackLabelText: \(trackLabelText)")
            lastPlayerState = playerState
            trackLabelText = playerState.track.name
            artistLabelText = playerState.track.artist.name
            currentTrackURI = playerState.track.uri
        }
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        
        if playerState.isPaused {
            playPauseImage = UIImage(systemName: "play.circle.fill")
        } else {
            playPauseImage = UIImage(systemName: "pause.circle.fill")
        }
        
    }
    
    func connectButtonTapped() {
        guard let sessionManager = sessionManager else { return }
        sessionManager.initiateSession(with: scopes, options: .clientOnly)
        print("connectButtonTapped")
    }
    
    func tappedPauseOrPlay() {
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            appRemote.playerAPI?.resume(nil)
        } else {
            appRemote.playerAPI?.pause(nil)
        }
    }
    
    func tappedSkipForwardButton() {
        appRemote.playerAPI?.skip(toNext: { _, error in
            if let error = error {
                print("appRemote Error skipping song on Spotify")
            }
        })
    }
    
    func tappedSkipPreviousButton() {
        appRemote.playerAPI?.skip(toPrevious: { _, error in
            if let error = error {
                print("appRemote Error skipping song on Spotify")
            }
        })
    }
    
    func getCurrentPlaybackInfo() {
        appRemote.playerAPI?.getPlayerState({ (playerState, error) in
            if let error = error {
                print("Error getting player state: " + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                
                print("Track URI: \(playerState.track.uri)")
                self.currentTrackURI = playerState.track.uri
                print("Playback info: \(playerState.playbackPosition)")
                self.playBackPositionState = playerState.playbackPosition
               
            }
        })
    }
    
}

// MAYBE: Move to Content View so we can updae views based on
extension SpotifyController: SPTAppRemoteDelegate {
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        // Add "updateContentView" function
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe { success, error in
            if let error = error {
                print("Error subscribing to Spotify's playerAPI: \(error.localizedDescription)")
            }
            if success != nil {
                print("Success != nil")
                self.fetchPlayerState()
            }
        }
       
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        // Add "updateContentView" function
        print("lastPlayerState = nil")
        lastPlayerState = nil
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        // Add "updateContentView" function
        print("lastPlayerState = nil")
        lastPlayerState = nil
    }
    
}

// MARK: - SPTAppRemotePlayerAPIDelegate
extension SpotifyController: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("Spotify Track name: \(trackLabelText)")
        update(playerState: playerState)
    }
}

// MAYBE: Move to Content View
extension SpotifyController: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = accessToken
        appRemote.connect()
        print("sessionManager did initiate")
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        if error.localizedDescription == "The operation couldn’t be completed. (com.spotify.sdk.login error 1.)" {
            print("AUTHENTICATE with WEBAPI")
        } else {
            // Present AlertVC for error
            print("Authorization Failed: \(error.localizedDescription)")
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("Session renewed: \(session.description)")
        // Present AlertVC for Session renewed
    }
    
}

// MARK: - Networking for Spotify's API
extension SpotifyController {
    
    func fetchAccessToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((spotifyClientId + ":" + spotifyClientSecretKey).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]
        
        var requestBodyComponents = URLComponents()
        let scopeAsString = stringScopes.joined(separator: " ")
        
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: spotifyClientId),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: responseCode!),
            URLQueryItem(name: "redirect_uri", value: redirectUri.absoluteString),
            URLQueryItem(name: "code_verifier", value: ""), // not currently used
            URLQueryItem(name: "scope", value: scopeAsString),
        ]
        
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                              // is there data
                  let response = response as? HTTPURLResponse,  // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                  error == nil else {                           // was there no error, otherwise ...
                print("Error fetching token \(error?.localizedDescription ?? "")")
                return completion(nil, error)
            }
            let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            print("Access Token Dictionary=", responseObject ?? "")
            if let unwrappedResponse = responseObject {
                let accessTokenUnwrapped = unwrappedResponse["access_token"] as! String
                print("ACCESS TOKEN UNWRAPPED: \(accessTokenUnwrapped)")
                let defaults = UserDefaults.standard
                defaults.set(accessTokenUnwrapped, forKey: "accessTokenUnwrapped")
            }
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    func fetchArtwork(for track: SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                DispatchQueue.main.async {
                    self.albumImage = image
                }
            }
        })
    }
    
    func fetchPlayerState() {
        appRemote.playerAPI?.getPlayerState({ (playerState, error) in
            if let error = error {
                print("Error getting player state: " + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self.update(playerState: playerState)
                print("Successfully fetched player state")
            }
        })
    }
    
}
