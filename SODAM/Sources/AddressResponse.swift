//
//  AddressResponse.swift
//  SODAM
//
//  Created by 박세라 on 5/14/25.
//

import Foundation

struct AddressResponse: Codable {
    let response: AddressResponseBody
}

struct AddressResponseBody: Codable {
    let service: AddressService
    let status: String
    let input: AddressInput
    let result: [AddressResult]?
}

struct AddressService: Codable {
    let name: String
    let version: String
    let operation: String
    let time: String
}

struct AddressInput: Codable {
    let point: AddressPoint
    let crs: String
    let type: String
}

struct AddressPoint: Codable {
    let x: String
    let y: String
}

struct AddressResult: Codable {
    let zipcode: String?
    let type: String?
    let text: String?
    let structure: AddressStructure?
}

struct AddressStructure: Codable {
    let level0: String?
    let level1: String?
    let level2: String?
    let level3: String?
    let level4L: String?
    let level4LC: String?
    let level4A: String?
    let level4AC: String?
    let level5: String?
    let detail: String?
}

