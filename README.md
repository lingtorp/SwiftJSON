# SwiftJSON
_Simple methods for creating JSON from a generic Swift struct_

Written in Swift 1.2.

## Ever wanted to turn this ...
```swift
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
```

## ... into this.
```javascript
{
    "YourCompany.UserInformation": {
        "username": "testuser123",
        "password": "test123",
        "email": "test123@gmail.com",
        "YourCompany.Facility": {
            "id": "123455432167890",
            "construction_year": "nil",
            "area": "90",
            "YourCompany.ProviderContract": {
                "provider_id": "1234",
                "contract_type": "HOURLY",
                "fee": "300",
                "price": "nil"
            },
            "street": "Inifinity Loop 1",
            "heating": "nil",
            "facility_type": "ROWHOUSE",
            "postal_code": "12345",
            "occupants": "2"
        }
    }
}
```
Well, with these three methods you can.
Just call JSON(yourStruct) and it will return you a valid JSON string, hopefully.

```swift
let userInfo = UserInformation() // Create your struct somehow ...
let userInfoJSON = JSON(userInfo) 
// Do something with it! 
```

# How to  ...

## Enums
Let's say we have this House enum (which we used above). Since the enums does not implement the Reflectable protocol and the Swift runtime default implementation just gives us back "(Enum Value)" when reflected we need to implement the protocol ourselves. 

If your enums are of a type which actually has an implementation for the Reflectable protocol then you are in luck! The template below produces; "VILLA" for Villa and so on.
```swift
enum House: String, Reflectable {
    case Villa      = "VILLA"
    case Apartment  = "APARTMENT"
    case RowHouse   = "ROWHOUSE"
    
    func getMirror() -> MirrorType {
        return self.rawValue.getMirror()
    }
}
```
# Where it falls short
 * Objects. 
 * It will append the product name to globally defined struct such as "YourCompany.YourStructName : { / ... / }" Feature or bug? Take your pick.
 * All untested scenarios ...
 * It's probably super slow.

# TODO
 * 'nil' should perhaps be 'NULL'
 * Improve objects?
 * Format the JSON: prettyprinted? spacesaving?
 * Tests
 * Swift 2.0?
