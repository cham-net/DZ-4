import Foundation

struct ContactAPI: Codable {
    
    private(set) var uuid: String = UUID().uuidString
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var group: String
    
    //init(id: String, data: JSON) {
    //    self.uuid = UUID().uuidString
    //    self.firstName = data["firstName"] as! String
    //    self.lastName = data["lastName"] as! String
    //    self.phoneNumber = data["phoneNumber"] as! String
    //    self.group = data["group"] as! String
    //}
    
}
