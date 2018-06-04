//
//  HashTagSearchViewController.swift
//  GauthamMobileTest
//
//  Created by Apple on 01/06/18.
//  Copyright © 2018 Gautham. All rights reserved.
//

import UIKit
import TwitterKit

class HashTagSearchViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var searchTableView:UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var hashTagsArray:NSMutableArray = []
    var userID:String=""
    var searchString:String=""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search #Tags"
        searchTableView.tableHeaderView = searchController.searchBar
        self.searchTableView.estimatedRowHeight = 70
        self.searchTableView.rowHeight = UITableViewAutomaticDimension
        
        self.searchTableView.register(UINib.init(nibName: "HashTagTableViewCell", bundle: nil), forCellReuseIdentifier: "HashTagTableViewCell")
        searchString = "hello"
        self.updateSearchData(_searchText: searchString,count:"15")
        // Do any additional setup after loading the view.
    }
    
    func updateSearchData(_searchText:String,count:String){
        
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
        let replaced = _searchText.replacingOccurrences(of: "#", with: "")
        
        let params = ["id": self.userID,"count":count,"q":"#"+replaced]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
            
            do {
                
                guard let serverData = data else {
                    return
                }
                
                if let json = try JSONSerialization.jsonObject(with: serverData, options: [.mutableContainers]) as? [String: AnyObject] {
                    
                    if let success:NSMutableArray = json["statuses"] as? NSMutableArray{
                        DispatchQueue.main.async {
                            
                            var dataArray = NSMutableArray()
                            dataArray = success
                            self.hashTagsArray.addObjects(from: dataArray as [AnyObject])
                            self.searchTableView.reloadData()
                            
                        }                    }
                    
                }
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if (searchController.searchBar.text?.count)!>0 {
            searchString = searchController.searchBar.text!
            self.hashTagsArray.removeAllObjects()
            self.updateSearchData(_searchText: searchString,count: "15")

            
        } else {
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hashTagsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        let cell: HashTagTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HashTagTableViewCell") as! HashTagTableViewCell
        
        if self.hashTagsArray.count>0{
            let dic:NSDictionary = self.hashTagsArray[indexPath.row] as! NSDictionary
            cell.hashTextLabel?.text = dic.value(forKey:"text") as? String
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.hashTagsArray.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.updateSearchData(_searchText: searchString,count:"5")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
