import UIKit

class ​ContactDetailsViewController: UITableViewController {
    
    var contact: Contact?
  
    var group = "" {
      didSet {
        detailLabel.text = group
      }
    }
    
    var imagePicker: ImagePicker!
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var photoView: UIImageView!
  @IBAction func photoSeletion(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
  }

  required init?(coder aDecoder: NSCoder) {
    print("init ContactDetailsViewController")
    super.init(coder: aDecoder)
  }
  deinit {
    print("deinit ContactDetailsViewController")
  }
  
    override func viewDidLoad() {
      group = "Одноклассники"
      firstNameTextField.becomeFirstResponder()
      self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
    
    if segue.identifier == "SaveGroup",
          let contactFirstName = firstNameTextField.text,
          let contactLastName = lastNameTextField.text,
          let contactPhoneNumber = phoneNumberTextField.text,
          let groupName = detailLabel.text,
          let photo = photoView.image {
      contact = Contact(firstName: contactFirstName, lastName: contactLastName, contactGroup: groupName, phoneNumber: contactPhoneNumber, photo: photo, deleted: false)
       }
    if segue.identifier == "ChooseGroup",
       let groupsViewController = segue.destination as? ​GroupsViewController {
      groupsViewController.groupsDataSource.selectedGroup = group
    }
  }
}

extension ​ContactDetailsViewController {
  @IBAction  func  SelectedGroup (segue: UIStoryboardSegue) {
    if let groupViewController = segue.source as? ​GroupsViewController,
       let selectedGame = groupViewController.groupsDataSource.selectedGroup {
      group = selectedGame
    }
  }
}

extension ​ContactDetailsViewController: ImagePickerDelegate {
  func didSelect(image: UIImage?) {
      self.photoView.image = image
  }
}




