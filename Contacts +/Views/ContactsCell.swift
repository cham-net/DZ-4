import UIKit

class ContactsCell: UITableViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    
    var contact: Contact? {
      didSet {
        guard let contact = contact else { return }
        firstNameLabel.text = contact.firstName
        lastNameLabel.text = contact.lastName
        phoneNumberLabel.text = contact.phoneNumber
        groupLabel.text = contact.contactGroup
        photoImage.image = contact.photo
      }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup(with contactAPI: ContactAPI) {
      firstNameLabel.text = contactAPI.firstName
      lastNameLabel.text = contactAPI.lastName
      phoneNumberLabel.text = contactAPI.phoneNumber
      groupLabel.text = contactAPI.group
      photoImage.image = UIImage(named: "DefaultFoto")
  }


}
