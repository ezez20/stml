//
//  APIService.swift
//  stml
//
//  Created by Ezra Yeoh on 7/10/23.
//

import Foundation


class APIService {
    
    static let shared = APIService()
    
    func createURLRequest(accessToken: String, search: String) -> URLRequest? {
        
        let query = "search"
        let httpRequestMethod = "GET"
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/\(query)"
        
        components.queryItems = [
            // https://developer.spotify.com/documentation/web-api/reference/search
            URLQueryItem(name: "type", value: "track"),
            // Query or "q". Double check in Spotify's doc.
            URLQueryItem(name: "q", value: "\(search)")
            
        ]
        
        guard let url = components.url else { return nil }
        var urlRequest = URLRequest(url: url)
        
        let defaults = UserDefaults.standard
//        let token = defaults.string(forKey: "accessTokenUnwrapped")!
        let token = accessToken
        
        urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = httpRequestMethod
        
        return urlRequest
    }
    
    func searchSongs(accessToken: String) async throws -> [String] {
        guard let urlReuqest = createURLRequest(accessToken: accessToken, search: "Drake") else { throw NetworkError.invalidURL }
        
        let (data, _) = try await URLSession.shared.data(for: urlReuqest)
        
        let decoder = JSONDecoder()
        let results = try decoder.decode(Response.self, from: data)
        
        let items = results.tracks.items
        let songs = items.map({$0.name})
        return songs
    }
    
    func playSpotifyTrack(trackUri: String, playbackPosition: Int) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/me/player/play"
        
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "accessTokenUnwrapped") else { return }
        
        urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = "PUT"
        
        let jsonDict: [String: AnyHashable] = [
            "uris": [trackUri],
            "offset": ["position": 0],
            "position_ms": playbackPosition
        ]

        let data = try! JSONSerialization.data(withJSONObject: jsonDict, options: .fragmentsAllowed)
        
        URLSession.shared.uploadTask(with: urlRequest, from: data) { (responseData, response, error) in
            
            if let error = error {
                print("Error making PUT request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                
                APIErrors.handleResponseCode(responseCode)
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    print("Response JSON data = \(responseJSONData)")
                }
                
            }
            
        }.resume()
        
    }
    
    func skipToPreviousSong() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/me/player/previous"
        
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "accessTokenUnwrapped") else { return }
        
        urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: urlRequest) { (responseData, response, error) in
            if let error = error {
                print("Error making POST request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                APIErrors.handleResponseCode(responseCode)
            }
            
        }
        .resume()
    }
    
    func skipToNextSong() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/me/player/next"
        
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "accessTokenUnwrapped") else { return }
        
        urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: urlRequest) { (responseData, response, error) in
            if let error = error {
                print("Error making POST request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                APIErrors.handleResponseCode(responseCode)
            }
            
        }
        .resume()
    }
    
    
}

struct Response: Codable {
    let tracks: Track
}

struct Track: Codable {
    let items: [SpotifyItem]
}

struct SpotifyItem: Codable {
    let name: String
}
