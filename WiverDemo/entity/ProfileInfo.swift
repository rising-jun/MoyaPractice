//
//  ProfileModel.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/03.
//

import Foundation

public struct UpdateProfileRequest: Codable {
    let imageUrl: String
    let nickname: String
}

struct ProfileInfo: Codable {
    var id: String?
    var userId: String?
    var nickname: String?
    var imageUrl: String?
    var updatedAt: String?
    var createdAt: String?
    
}
