//
//  File.swift
//  
//
//  Created by st6111339 on 2023-03-16.
//

import Foundation

struct LoginResponseDTO: Codable, ErrorContainingResponse, PasswordResponse {
    private var token: String?
    private(set) var details: String?
    private(set) var password: [String]?
    
    func toDomain() throws -> String {
        try requireNoError()
        try requireNoPasswordError()
        guard let token = token else { throw CommunicationError.incompleteResponse(self) }
        return token
    }
}
