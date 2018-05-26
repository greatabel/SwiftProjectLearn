import UIKit

private let kRefreshViewHeight: CGFloat = 200

class RefreshingTableViewController: UITableViewController {
    private var refreshView : RefreshView!

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshView = RefreshView(frame: CGRect(x: 0, y: -kRefreshViewHeight,
                                                width: (view.bounds).width,
                                                height: kRefreshViewHeight), scrollView: tableView)
        view.insertSubview(refreshView, at: 0)
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) 
        cell.textLabel?.text = "第 \(indexPath.row) 行"
        // Configure the cell...

        return cell
    }






}
