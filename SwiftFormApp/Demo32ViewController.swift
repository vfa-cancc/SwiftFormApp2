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
import NCMB
import ProgressHUD

class Demo32ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    var arrPickerData: [AnyHashable] = []
    var arrTbvData: [Any] = []
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var lblResultCount: UILabel!
    @IBOutlet weak var viewResultCount: UIView!
    @IBOutlet weak var pickerGreaterThan: UIPickerView!
    @IBOutlet weak var pickerLessThan: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "demo3-2：条件検索"
        arrTbvData = [Any]()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        arrPickerData = [AnyHashable]()
        arrPickerData.append("- age -")
        for i in 0...120 {
            arrPickerData.append(String(format: "%i", i))
        }
    }
    
    @IBAction func searchByRange(_ sender: Any) {
        let greater: Int = pickerGreaterThan.selectedRow(inComponent: 0) - 1
        let less: Int = pickerLessThan.selectedRow(inComponent: 0) - 1
        if greater == -1 || less == -1 {
            Utils.showAlert(self, title: "Alert", message: NSLocalizedString("please fill in the value", comment: ""))
        } else if greater >= less {
            Utils.showAlert(self, title: "Alert", message: NSLocalizedString("Value is invalid", comment: ""))
        } else {
            ProgressHUD.show("Loading...")
            Mbaas.getRangeSearchData(greater as NSNumber, ageLessThan: less as NSNumber, successCallback: { objects in
                //検索成功時の処理
                self.arrTbvData = objects!
                self.lblResultCount.text = String(format: NSLocalizedString("Conditional search (range designation) result", comment: ""), UInt(self.arrTbvData.count))
                self.table.reloadData()
                self.viewResultCount.isHidden = false
                ProgressHUD.dismiss()
            }, errorCallback: { error in
                ProgressHUD.dismiss()
                Utils.showAlert(self, title: "Alert", message: NSLocalizedString("Data acquisition failed", comment: ""))
            })
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPickerData[row] as? String
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTbvData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "DataTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? DataTableViewCell
        
        if arrTbvData.count > 0 {
            let obj = arrTbvData[indexPath.row] as? NCMBObject
            cell?.lblTitle.text = obj?.object(forKey: "title") as? String
            cell?.lblCreatedDate.text = Utils.formatDate(obj?.object(forKey: "createDate") as? String)
            let contents: String? = String.localizedStringWithFormat("%@ (%@) - %@ - %@", (obj?.object(forKey: "name") as? String)!,(obj?.object(forKey: "prefecture") as? String)!, (obj?.object(forKey: "age") as? NSNumber)!, (obj?.object(forKey: "emailAddress") as? String)!)
            cell?.lblContents.text = contents
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arrTbvData[indexPath.row] as? NCMBObject
        Utils.showAlert(self, title: "Alert", message: (obj?.object(forKey: "contents") as! String))
    }

    
}
