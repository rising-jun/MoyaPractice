//
//  UploadResponse.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/07.
//

import Foundation

public struct UploadResponse: Codable {
    let createdAt: String?
    let filename: String?
    let id: String?
    let url: String?
    
    func toAttachmentRequest() -> AttachmentRequest {
        return AttachmentRequest(createdAt: self.createdAt!, filename: self.filename!, id: self.id!, url: self.url!)
    }
    
    func toThumbnailRequest() -> ThumbnailRequest {
        return ThumbnailRequest(createdAt: self.createdAt!, filename: self.filename!, id: self.id!, url: self.url!)
    }
}

public struct AttachmentRequest: Codable {
    let createdAt: String
    let filename: String
    let id: String
    let url: String
}

public struct ThumbnailRequest: Codable {
    let createdAt: String
    let filename: String
    let id: String
    let url: String
}
