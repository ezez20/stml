//
//  NetworkError.swift
//  stml
//
//  Created by Ezra Yeoh on 7/10/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidServerResponse
    case generalError
}
