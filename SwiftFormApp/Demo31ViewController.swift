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

class Demo31ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    var pickerPreData: [AnyHashable] = []
    var arrTbvData: [Any] = []
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var lblResultCount: UILabel!
    @IBOutlet weak var viewResultCount: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var pickerPre: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "demo3-1：条件検索"
        arrTbvData = [Any]()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        pickerPreData = ["- prefecture -", "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県", "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県", "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"]
        
    }
    
    @IBAction func searchByEmail(_ sender: Any) {
        if ("" == txtEmail.text) {
            Utils.showAlert(self, title: "Alert", message: NSLocalizedString("please fill in the value", comment: ""))
        } else {
            ProgressHUD.show()
            Mbaas.getSearchData(txtEmail.text, searchBy: Mbaas.SearchByEnum.SearchByEmail, successCallback: { objects in
                //検索成功時の処理
                self.arrTbvData = objects!
                self.lblResultCount.text = String(format: NSLocalizedString("Condition Search Result", comment: ""), UInt(self.arrTbvData.count))
                self.table.reloadData()
                self.viewResultCount.isHidden = false
                
                ProgressHUD.dismiss()
            }, errorCallback: { error in
                //検索失敗時の処理
                ProgressHUD.dismiss()
                Utils.showAlert(self, title: "Alert", message: NSLocalizedString("Data acquisition failed", comment: ""))
            })
        }
    }
    @IBAction func searchByPre(_ sender: Any) {
        if pickerPre.selectedRow(inComponent: 0) == 0 {
            Utils.showAlert(self, title: "Alert", message: NSLocalizedString("please fill in the value", comment: ""))
        } else {
            ProgressHUD.show()
            let prefecture = pickerPreData[pickerPre.selectedRow(inComponent: 0)] as? String
            Mbaas.getSearchData(prefecture, searchBy: Mbaas.SearchByEnum.SearchByPrefecture, successCallback: { objects in
                //検索成功時の処理
                self.arrTbvData = objects!
                self.lblResultCount.text = String(format: NSLocalizedString("Condition Search Result", comment: ""), UInt(self.arrTbvData.count))
                self.table.reloadData()
                self.viewResultCount.isHidden = false
                
                ProgressHUD.dismiss()
            }, errorCallback: { error in
                //検索失敗時の処理
                ProgressHUD.dismiss()
                Utils.showAlert(self, title: "Alert", message: NSLocalizedString("Data acquisition failed", comment: ""))
            })
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerPreData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerPreData[row] as? String
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
