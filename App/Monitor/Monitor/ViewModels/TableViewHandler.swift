import Foundation
import UIKit
import Combine

/// Struct that holds the minimum data that can be rendered on a UITableView using cells with the `UITableViewCell.CellStyle.subtitle` style.
struct Entity {
    let title: String
    let subtitle: String
}

/// Simple UITableView DataSource implementation based on an array of elements that shows cells with the `UITableViewCell.CellStyle.subtitle` style.
final class TableViewHandler: NSObject {
    weak var tableView: UITableView?
    
    /// Published property with no value to indicate that the table just reloaded it's data
    @Published var reloaded: Void = ()
    /// Published selected index
    @Published var selectedIndex: IndexPath? = nil
    
    let reuseIdentifier = "cell"
    var entities = [Entity]() {
        didSet {
            self.tableView?.reloadData()
            self.reloaded = ()
        }
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

/// Very standard and regular code to populate a UITableView based on an array of elements, nothing fancy
extension TableViewHandler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) ?? UITableViewCell(style: .value1, reuseIdentifier: self.reuseIdentifier)
        
        cell.textLabel?.text = entities[indexPath.row].title
        cell.detailTextLabel?.text = entities[indexPath.row].subtitle
        
        return cell
    }
}

/// Conformance to UITableViewDelegate
extension TableViewHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We simply store the selected index path
        self.selectedIndex = indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // As we currently don't support multiple selection is ok to assume our currently selected index
        // was deselected
        self.selectedIndex = nil
    }
}
