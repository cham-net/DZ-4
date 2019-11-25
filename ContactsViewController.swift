import UIKit
import RealmSwift

class ContactsViewController: UITableViewController {
  
  @IBOutlet var tableViewContacts: UITableView!
  
  @IBOutlet weak var indicatorView: UIActivityIndicatorView!
  
  var realmItems: Results<Contact>!
  
  var items = [Contact]()

  var alert: UIAlertController!
  var addAction: UIAlertAction!
  
  private var contacts = [ContactAPI]() {
    didSet {
        tableView.reloadData()
    }
  }
  
  @IBAction func newContactOnTheServer(_ sender: Any) {
    alert = UIAlertController(title: "Новый контакт", message: "Введите данные для создания нового контакта на сервере", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
    addAction = UIAlertAction(title: "Добавить", style: .default) { _ -> Void in
    let serverFirstNameTextField = self.alert.textFields![0]
    let textServerFirstNameTextField = serverFirstNameTextField.text!
    let serverLastNameTextField = self.alert.textFields![1]
    let textServerLastNameTextField = serverLastNameTextField.text!
    let serverPhoneNumberTextField = self.alert.textFields![2]
    let textPhoneNumberTextField = serverPhoneNumberTextField.text!
    let serverGroupTextField = self.alert.textFields![3]
    let textGroupTextField = serverGroupTextField.text!
    let newServerContact = ContactAPI(
      firstName: "\(String(describing: textServerFirstNameTextField))",
      lastName: "\(String(describing: textServerLastNameTextField))",
      phoneNumber: "\(String(describing: textPhoneNumberTextField))",
      group: "\(String(describing: textGroupTextField))")
      self.indicatorView.startAnimating()
      API.createContact(newContact: newServerContact) { result in
      guard result else { return }
      API.loadContacts{contactsArr, err in
        self.contacts = contactsArr!
        ContactAPI2.shared.value.removeAll()
        ContactAPI2.shared.value = self.contacts
        DispatchQueue.main.async {
          self.indicatorView.stopAnimating()
          self.indicatorView.isHidden = true
          }
        }
      }
    }
    alert.addAction(addAction)
    alert.addTextField { serverFirstNameTextField in
      serverFirstNameTextField.placeholder = "Введите имя"
    }
    alert.addTextField { serverLastNameTextField in
      serverLastNameTextField.placeholder = "Введите фамилию"
    }
    alert.addTextField { serverPhoneNumberTextField in
      serverPhoneNumberTextField.placeholder = "Введите номер телефона"
    }
    alert.addTextField { serverGroupTextField in
      serverGroupTextField.placeholder = "Введите группу контакта"
    }
    present(alert, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    indicatorView.startAnimating()
    super.viewDidLoad()
    let realm = try! Realm()
    self.realmItems = realm.objects(Contact.self)
    API.loadContacts{contactsArr, err in
      self.contacts = contactsArr!
      ContactAPI2.shared.value.removeAll()
      ContactAPI2.shared.value = self.contacts
      DispatchQueue.main.async {
        self.indicatorView.stopAnimating()
        self.indicatorView.isHidden = true
        }
      }
    }
    
}



extension ContactsViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch (section) {
    case 0:
      let headerViewOne = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
      let labelOne = UILabel()
      labelOne.frame = CGRect.init(x: 5, y: 5, width: headerViewOne.frame.width-10, height: headerViewOne.frame.height-10)
      labelOne.text = "  ЛОКАЛЬНЫЕ КОНТАКТЫ"
      labelOne.font = UIFont.systemFont(ofSize: 16)
      labelOne.textColor = UIColor.black
      labelOne.backgroundColor = UIColor.orange
      headerViewOne.addSubview(labelOne)
      return headerViewOne
    case 1:
      let headerViewTwo = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
      let labelTwo = UILabel()
      labelTwo.frame = CGRect.init(x: 5, y: 5, width: headerViewTwo.frame.width-10, height: headerViewTwo.frame.height-10)
      labelTwo.text = "  СЕРВЕРНЫЕ КОНТАКТЫ"
      labelTwo.font = UIFont.systemFont(ofSize: 16)
      labelTwo.textColor = UIColor.black
      labelTwo.backgroundColor = UIColor.orange
      headerViewTwo.addSubview(labelTwo)
      return headerViewTwo
    default:
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 50
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch (section) {
    case 0:
      return realmItems.count
    case 1:
      return contacts.count
    default:
      return 1
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactsCell
    switch (indexPath.section) {
    case 0:
      cell.contact = realmItems[indexPath.row]
    case 1:
      cell.setup(with: contacts[indexPath.row])
    default:
      print("!!!!")
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      tableView.beginUpdates()
      switch (indexPath.section) {
      case 0:
        let realm = try! Realm()
        let delRealmItems = realmItems[indexPath.row]
        try! realm.write {
          realm.delete(delRealmItems)
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
      case 1:
        self.indicatorView.startAnimating()
        var uuid: String = ""
        uuid = ContactAPI2.shared.value[indexPath.row].uuid
        API.deleteContact(contactID: uuid) { result in
        guard result else {return}
        }
        contacts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        DispatchQueue.main.async {
          self.indicatorView.stopAnimating()
          self.indicatorView.isHidden = true
        }
      default:
        print("!!!!")
      }
      tableView.endUpdates()
    }
  }
  
}

extension ContactsViewController {
  @IBAction func CancelViewController(_ segue: UIStoryboardSegue) {
  }
  @IBAction func SaveDetail(_ segue: UIStoryboardSegue) {
    guard
      let contactDetailsViewController = segue.source as? ​ContactDetailsViewController,
      let contact = contactDetailsViewController.contact
      else {
        return
    }
    //items.append(contact)
    let realm = try! Realm()
    try! realm.write {
      realm.add(contact)
    }
    tableView.insertRows(at: [IndexPath(row: realmItems.count-1, section: 0)], with: .automatic)
  }
}
