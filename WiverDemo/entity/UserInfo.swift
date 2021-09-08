//
//  UserModel.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/03.
//

import Foundation

struct UserInfo: Codable {
    let birth: String?
    let createdDate: String? // ($date-time)
    let createdBy: String?
    let lastModifiedBy: String?
    let id: String?
    let lastName: String?
    let firstName: String?
    let email: String?
    let imageUrl: String?
    let langKey: String
    let gender: String? // enum [FEMALE, MALE]
    let activated: Bool
    let lastModifiedDate: String? // ($date-time)
    let login: String
    let authorities: [Authority]?
}

//struct UpdateUserResponse: Codable {
//    let t1: UserInfo
//    let t2: ProfileModel
//}

struct Authority: Codable {
    let name: String
}

extension UserInfo {
    func needAdditionalInformation() -> Bool {
        return self.birth == nil || self.gender == nil
    }
}

struct UserBlockDTO: Codable {
    let createdAt: String?
    let id: String?
    let peerId: String?
    let updatedAt: String?
    let userId: String?
}
