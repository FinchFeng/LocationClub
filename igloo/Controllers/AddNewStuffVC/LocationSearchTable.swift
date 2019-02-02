import UIKit
import MapKit

class LocationSearchTable : UITableViewController {
    
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("搜索VC出现")
        handleMapSearchDelegate?.hideDoneButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         print("搜索VC消失")
        handleMapSearchDelegate?.showDoneButton()
    }
    
}

extension LocationSearchTable : UISearchResultsUpdating {
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
    public func updateSearchResults(for searchController: UISearchController){//输入框输入之后的响应方法
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        //获取与location对应的附近的地点
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            //更新tableView
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension LocationSearchTable {
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
//override     public func tableView(_ tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    override
    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

       let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = ""
        return cell
    }
}
