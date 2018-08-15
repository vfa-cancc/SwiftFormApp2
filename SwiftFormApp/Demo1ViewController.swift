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
import UITextView_Placeholder

class Demo1ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var pickerAge: UIPickerView!
    @IBOutlet weak var pickerPre: UIPickerView!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtContents: UITextView!
    
    private var pickerAgeData: [AnyHashable] = []
    private var pickerPreData: [AnyHashable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "demo1：保存"
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // UI
        let borderColor = UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        txtContents.layer.borderColor = borderColor.cgColor
        txtContents.layer.borderWidth = 1.0
        txtContents.layer.cornerRadius = 3.0
        txtContents.placeholder = "contents"
        
        // Initialize Data
        pickerAgeData = [AnyHashable]()
        pickerAgeData.append("- age -")
        for i in 0...120 {
            pickerAgeData.append(String(format: "%i", i))
        }
        pickerPreData = ["- prefecture -", "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県", "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県", "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"]
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
        // 入力チェック
        if ("" == txtName.text) {
            Utils.showAlert(self, title: "Alert", message: NSLocalizedString("Name is not entered", comment: ""))
        } else if ("" == txtEmail.text) {
            Utils.showAlert(self, title: "Alert", message: NSLocalizedString("E-mail address is not entered", comment: ""))
        } else if pickerAge.selectedRow(inComponent: 0) == 0 {
            Utils.showAlert(self, title: "Alert", message: NSLocalizedString("Age has not been entered", comment: ""))
        } else if pickerPre.selectedRow(inComponent: 0) == 0 {
            Utils.showAlert(self, title: "Alert", message: NSLocalizedString("State or province is not entered", comment: ""))
        } else if ("" == txtTitle.text) {
            Utils.showAlert(self, title: "Alert", message: NSLocalizedString("Inquiry title has not been entered", comment: ""))
        } else if ("" == txtContents.text) {
            Utils.showAlert(self, title: "Alert", message: NSLocalizedString("Inquiry content is not entered", comment: ""))
            
        // データの保存
        } else {
            ProgressHUD.show("Please wait...")
            let name = txtName.text
            let email = txtEmail.text
            let pre = "\(pickerPreData[pickerPre.selectedRow(inComponent: 0)])"
            let age = pickerAge.selectedRow(inComponent: 0) - 1
            let title = txtTitle.text
            let contents = txtContents.text
            Mbaas.saveData(name, email: email, age: age as NSNumber, prefecture: pre, title: title, contents: contents, errorCallback: { error in
                ProgressHUD.dismiss()
                if error != nil {
                    //保存失敗
                    Utils.showAlert(self, title: "Alert", message: NSLocalizedString("I failed to accept inquiries", comment: ""))
                } else {
                    // 保存成功
                    Utils.showAlert(self, title: "Alert", message: NSLocalizedString("Inquiries accepted", comment: ""))
                }
            })
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == self.pickerAge) {
            return pickerAgeData.count;
        }
        else {
            return pickerPreData.count;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerAge {
            return pickerAgeData[row] as? String
        } else {
            return pickerPreData[row] as? String
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

