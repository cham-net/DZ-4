import UIKit

class ​GroupsViewController: UITableViewController {
  let groupsDataSource = GroupsDataSource()
}

extension ​GroupsViewController {
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    groupsDataSource.numberOfGroups()
  }
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
    cell.textLabel?.text = groupsDataSource.groupName(at: indexPath)
    if indexPath.row == groupsDataSource.selectedGroupIndex {
      cell.accessoryType = .checkmark
    }
    return cell
  }
}

extension ​GroupsViewController {
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let index = groupsDataSource.selectedGroupIndex {
      let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
      cell?.accessoryType = .none
    }
    groupsDataSource.selectGroup(at: indexPath)
    let cell = tableView.cellForRow(at: indexPath)
    cell?.accessoryType = .checkmark
    performSegue(withIdentifier: "unwind", sender: cell) //Укажем переход с помощью идентификатора
  }
}
