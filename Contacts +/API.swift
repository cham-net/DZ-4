import Foundation

typealias JSON = [String : Any]

enum API {
    func startAnimating() {}
    static var identifier: String { "TEST5" }
    static var baseURL: String {
        "https://ios-napoleonit.firebaseio.com/data/\(identifier)/"
    }
  
    static var storageName: String { "contacts" }
    
    static func loadContacts(completion: @escaping ([ContactAPI]?, NSError?) -> Void) {
        let url = URL(string: baseURL + ".json")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON
            else {
              completion(nil, error as NSError?)
              return
            }
            
            let contactsJSON = json[storageName] as! JSON
            var contacts = [ContactAPI]()

            for (_, data) in contactsJSON {
              let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
              let decode = try? JSONDecoder().decode(ContactAPI.self, from: jsonData!)
              if decode != nil {
                contacts.append(decode!)
              }
            }
            DispatchQueue.main.async {
              completion(contacts, nil)
              }
            }
        task.resume()
    }
    
    static func createContact(newContact: ContactAPI, completion: @escaping (Bool) -> Void) {
        let url = URL(string: baseURL + "/\(storageName)/\(newContact.uuid)/.json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(newContact)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                completion(error == nil)
            }
            task.resume()
    }
  
    static func deleteContact(contactID: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: baseURL + "/\(storageName)/\(contactID)/.json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(error == nil)
        }
        task.resume()
    }
  
  
}

