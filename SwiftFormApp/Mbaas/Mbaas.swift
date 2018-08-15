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

class Mbaas {
    public enum SearchByEnum : Int {
        case SearchByEmail = 100
        case SearchByPrefecture = 200
    }
    /***** demo1：保存 *****/
    class func saveData(_ name: String?, email: String?, age: NSNumber?, prefecture: String?, title: String?, contents: String?, errorCallback: @escaping (_ error: Error?) -> Void) {
        // 保存先クラスの作成
        let object = NCMBObject(className: "Inquiry")
        // データの設定と保存
        object?.setObject(name, forKey: "name")
        object?.setObject(email, forKey: "emailAddress")
        object?.setObject(age, forKey: "age")
        object?.setObject(prefecture, forKey: "prefecture")
        object?.setObject(title, forKey: "title")
        object?.setObject(contents, forKey: "contents")
        object?.saveInBackground({error in
            //保存失敗
            errorCallback(error)
        })
    }

    /***** demo2：全件検索 *****/
    class func getAllData(_ successCallback: @escaping (_ objects: [Any]?) -> Void, errorCallback: @escaping (_ error: Error?) -> Void) {
        // インスタンスの生成
        let query = NCMBQuery(className: "Inquiry")
        // 保存日時降順
        query?.order(byDescending: "createDate")
        query?.findObjectsInBackground({ objects, error in
            if error != nil {
                // 検索失敗
                errorCallback(error)
            } else {
                // 検索成功
                successCallback(objects)
            }
        })
    }

    /***** demo3-1：条件検索 *****/
    class func getSearchData(_ q: String?, searchBy: SearchByEnum, successCallback: @escaping (_ objects: [Any]?) -> Void, errorCallback: @escaping (_ error: Error?) -> Void) {
        // インスタンスの生成
        let query = NCMBQuery(className: "Inquiry")
        // 保存日時降順
        query?.order(byDescending: "createDate")
        // データの条件検索取得（完全一致）
        if SearchByEnum.SearchByEmail == searchBy {
            query?.whereKey("emailAddress", equalTo: q)
        } else {
            query?.whereKey("prefecture", equalTo: q)
        }
        query?.findObjectsInBackground({ objects, error in
            if error != nil {
                //検索失敗時の処理
                errorCallback(error)
            } else {
                //検索成功時の処理
                successCallback(objects)
            }
        })
    }
    
    /***** demo3-2：条件検索（範囲指定） *****/
    class func getRangeSearchData(_ ageGreaterThan: NSNumber?, ageLessThan: NSNumber?, successCallback: @escaping (_ objects: [Any]?) -> Void, errorCallback: @escaping (_ error: Error?) -> Void) {
        // インスタンスの生成
        let query = NCMBQuery(className: "Inquiry")
        // 保存日時降順
        query?.order(byDescending: "createDate")
        // データのの条件検索取得（範囲指定）
        query?.whereKey("age", greaterThanOrEqualTo: ageGreaterThan)
        query?.whereKey("age", lessThan: ageLessThan)
        query?.findObjectsInBackground({ objects, error in
            if error != nil {
                // 検索失敗
                errorCallback(error)
            } else {
                // 検索成功
                successCallback(objects)
            }
        })
    }

}
