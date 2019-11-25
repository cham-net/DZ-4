import UIKit

class GroupsDataSource: NSObject {

  var groups = [
    "Друзья",
    "Коллеги",
    "Одноклассники",
  ]

  var selectedGroup: String? {
    didSet {
      if let selectedGroup = selectedGroup,
        let index = groups.firstIndex(of: selectedGroup) {
        selectedGroupIndex = index
      }
    }
  }

  var selectedGroupIndex: Int?

  func selectGroup(at indexPath: IndexPath) {
    selectedGroup = groups[indexPath.row]
  }

  func numberOfGroups() -> Int {
    groups.count
  }

  func groupName(at indexPath: IndexPath) -> String {
    groups[indexPath.row]
  }
}
