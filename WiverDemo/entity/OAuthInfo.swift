//
//  OAuthModel.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/02.
//

import Foundation

struct OAuthInfo: Codable {
    var refreshExpiresIn: Double
    var tokenType: String
    var accessToken : String
    var sessionState : String
    var scope : String
    var expiresIn : Double
    var refreshToken : String
    var notBeforePolicy : Int

    enum CodingKeys: String, CodingKey {
        case refreshExpiresIn = "refresh_expires_in"
        case tokenType = "token_type"
        case accessToken = "access_token"
        case sessionState = "session_state"
        case scope = "scope"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case notBeforePolicy = "not-before-policy"
    }
}
