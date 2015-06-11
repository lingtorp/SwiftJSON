//
//  SwiftJSON.swift
//  SwiftJSON
//
//  Created by Alexander Lingtorp on 11/06/15.
//  Copyright (c) 2015 Alexander Lingtorp. All rights reserved.
//

import Foundation

class SwiftJSON {
    
    init() {
        let providerContract = ProviderContract(provider_id: 0, contract_type: ProviderContractType.Hourly, fee: 25, price: 2.5)
        let facility = Facility(id: "AB123", construction_year: 1994, area: 90, provider_contract: providerContract, street: "Infinity Loop 1", heating: Heating.HeatPump, facility_type: House.Apartment, postal_code: 12345, occupants: 2)
        let userInfo = UserInformation(username: "username", password: "password", email: "john@doe.com", facility: facility)
        println(JSON(userInfo))
    }
}

// MARK: - JSON Handling
/// Allows you to iterate over members of classes, structs.
func iterate<T>(t: T, block: (name: String, value: Any, parent: MirrorType, indexInParent: Int) -> Void) {
    let mirror = reflect(t)
    for i in 0..<mirror.count {
        block(name: mirror[i].0, value: mirror[i].1.value, parent: mirror, indexInParent: i)
    }
}

/// Recursive helper for JSON method
private func helperJSON<T>(t: T, moreContent: Bool) -> String {
    var json = "{\n"
    iterate(t, { (name, value, parent, index) -> Void in
        let mirror = reflect(value)
        // println(mirror.summary)
        if mirror.count > 1 {
            json += "\"\(mirror.summary)\":"
            let moreMembers = index < parent.count - 1 ? true : false
            json += helperJSON(value, moreMembers)
        } else {
            json += "\"\(name)\" : \"\(mirror.summary)\""
            if index != parent.count - 1 {
                json += ",\n"
            }
        }
    })
    json += "\n}"
    if moreContent { json += "," }
    return json
}

/// Generates a JSON string from any type T (like structs, classes, objects).
func JSON<T>(t: T) -> String {
    return helperJSON(t, false)
}

// MARK: - Enums
enum Heating: String, Reflectable {
    case Direct      = "DIRECT"
    case District    = "DISTRICT"
    case AirHeatPump = "AIR_HEATPUMP"
    case HeatPump    = "HEATPUMP"
    case None        = ""
    
    func getMirror() -> MirrorType {
        return self.rawValue.getMirror()
    }
}

enum House: String, Reflectable {
    case Villa      = "VILLA"
    case Apartment  = "APARTMENT"
    case RowHouse   = "ROWHOUSE"
    
    func getMirror() -> MirrorType {
        return self.rawValue.getMirror()
    }
}

enum ProviderContractType: String, Reflectable {
    case Fixed  = "FIXED"
    case Mixed  = "MIXED"
    case Hourly = "HOURLY"
    
    func getMirror() -> MirrorType {
        return self.rawValue.getMirror()
    }
}

// MARK: - Structs
struct UserInformation {
    let username: String
    let password: String
    let email: String
    let facility: Facility
}

struct ProviderContract {
    var provider_id: Int
    var contract_type: ProviderContractType
    var fee: Int
    var price: Double?
}

struct Facility {
    var id: String
    var construction_year: Int?
    var area: Int
    var provider_contract: ProviderContract
    var street: String
    var heating: Heating?
    var facility_type: House
    var postal_code: Int
    var occupants: Int
}
