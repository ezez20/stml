//
//  APIErrors.swift
//  stml
//
//  Created by Ezra Yeoh on 7/17/23.
//

import Foundation

enum APIErrors {
    
    static func handleResponseCode(_ responseCode: Int) {
        guard responseCode == 200 else {
            print("Invalid response code: \(responseCode)")
            switch responseCode {
            case 204:
                print("Successful response: .")
            case 401:
                print("Invalid response: Bad or expired token. This can happen if the user revoked a token or the access token has expired. You should re-authenticate the user.")
            case 403:
                print("Invalid response: Bad OAuth request (wrong consumer key, bad nonce, expired timestamp...). Unfortunately, re-authenticating the user won't help here.")
            case 429:
                print("Invalid response: The app has exceeded its rate limits.")
            default:
                print("Invalid reponse - default: unknown")
            }
            return
        }
    }
    
}
