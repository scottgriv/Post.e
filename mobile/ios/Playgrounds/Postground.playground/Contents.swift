import Foundation

//Structure
struct Languages: Decodable {
    
    struct Header: Decodable {
        
        let current_language_code: String?
        let current_language_name: String?
        
        enum CodingKeys: String, CodingKey {
            case current_language_code = "current_language_code"
            case current_language_name = "current_language_name"
        }
    }
    
    struct Details: Decodable {
        
        let language_code: String?
        let language_name: String?
        
        enum CodingKeys: String, CodingKey {
            case language_code = "language_code"
            case language_name = "language_name"
        }
    }
    
    var header = [Header]()
    var details = [Details]()
    
    enum CodingKeys: String, CodingKey {
        case header = "header"
        case details = "details"
    }
}

let json = """
{
    "header": [{
        "current_language_code": "ru",
        "current_language_name": "Russian (Test)"
    }],
    "details": [{
        "language_code": "en",
        "language_name": "English (English)"
    }, {
        "language_code": "ru",
        "language_name": "Russian (Test)"
    }]
}
"""

do {
    let languages = try
    JSONDecoder().decode(Languages.self, from: json.data(using: .utf8)!)
    
    print("Current Language Code:", languages.header.first?.current_language_code! as Any)
    print("Current Language Name:", languages.header.first?.current_language_name! as Any)
    
    for (index, value) in languages.details.enumerated() {
        
        print("\(index): \(value)")
            
    }
    
    languages.header.forEach { h in
        
        print(h)

        print(h.current_language_code!)
        print(h.current_language_name!)
        
    }
    
    languages.details.forEach { d in
        
        print(d)

        print(d.language_code!)
        print(d.language_name!)
        
    }
    
} catch let jsonErr {
    print ("Error serializing json: ", jsonErr)
}

