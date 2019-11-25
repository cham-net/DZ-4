import Foundation
import UIKit
import RealmSwift

class Contact: Object {
  @objc dynamic var firstName: String?
  @objc dynamic var lastName: String?
  @objc dynamic var contactGroup: String?
  @objc dynamic var phoneNumber: String?
  var photo = UIImage(named: "DefaultFoto")
  @objc dynamic var deleted: Bool = false
  
  convenience init(firstName: String, lastName: String, contactGroup: String, phoneNumber: String, photo: UIImage?, deleted: Bool) {
    self.init()
    self.firstName = firstName
    self.lastName = lastName
    self.contactGroup = contactGroup
    self.phoneNumber = phoneNumber
    self.photo = photo
    self.deleted = deleted
  }
  
}
