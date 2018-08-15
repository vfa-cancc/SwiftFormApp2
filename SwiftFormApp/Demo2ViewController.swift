/*
 Copyright 2017-2018 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import ProgressHUD
import NCMB

class Demo2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrData: [Any] = []
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var lblResultCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "demo2：全件検索"
        arrData = [Any]()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        ProgressHUD.show("Loading...")
        Mbaas.getAllData({ objects in
            self.arrData = objects!
            self.lblResultCount.text = String(format: NSLocalizedString("All search results", comment: ""), UInt(self.arrData.count
            ))
            self.table.reloadData()
            ProgressHUD.dismiss()
        }, errorCallback: { error in
            ProgressHUD.dismiss()
            Utils.showAlert(self, title: "Alert", message: NSLocalizedString("Data acquisition failed", comment: ""))
            if let anError = error {
                print("全件検索失敗：\(anError)")
            }
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "DataTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? DataTableViewCell

        if arrData.count > 0 {
            let obj = arrData[indexPath.row] as! NCMBObject
            cell?.lblTitle.text = obj.object(forKey: "title") as? String
            cell?.lblCreatedDate.text = Utils.formatDate(obj.object(forKey: "createDate") as? String)
            let name = obj.object(forKey: "name") as? String
            let pre = obj.object(forKey: "prefecture") as? String
            let age = obj.object(forKey: "age") as? NSNumber
            let email = obj.object(forKey: "emailAddress") as? String
            let contents = String(format:"%@ (%@) - %@ - %@", name!, pre!, age!, email!)
            cell?.lblContents.text = contents
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arrData[indexPath.row] as? NCMBObject
        Utils.showAlert(self, title: "Alert", message: obj?.object(forKey: "contents") as? String)
    }
    
    
}
