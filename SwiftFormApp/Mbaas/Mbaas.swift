/*
 Copyright 2017-2020 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
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
    class func saveData(_ name: String?, email: String?, age: NSNumber?, prefecture: String?, title: String?, contents: String?, callback: @escaping (_ error: Error?) -> Void) {
        // [demo1_1]保存先クラスの作成
        
        // [demo1_2]データの設定
        
        
        
        
        
        
        // [demo1_3]データの保存処理の実行
        
        
        
        
    }

    /***** demo2：全件検索 *****/
    class func getAllData(_ successCallback: @escaping (_ objects: [Any]?) -> Void, errorCallback: @escaping (_ error: Error?) -> Void) {
        // [demo2_1]保存先クラスのクエリを生成
        
        // [demo2_2]検索条件の設定（保存日時の降順）
        
        // [demo2_3]全件検索処理の実行
        
        
        
        
    }

    /***** demo3-1：条件検索 *****/
    class func getSearchData(_ q: String?, searchBy: SearchByEnum, successCallback: @escaping (_ objects: [Any]?) -> Void, errorCallback: @escaping (_ error: Error?) -> Void) {
        // [demo3-1_1]保存先クラスのクエリを生成
        
        // [demo3-1_2]検索条件の設定（保存日時の降順）
        
        
        if SearchByEnum.SearchByEmail == searchBy {
            // [demo3-1_3]検索条件（メールアドレス）の設定
            
        } else {
            // [demo3-1_4]検索条件（都道府県）の設定
            
        }
        // [demo3-1_5]全件検索処理の実行
        
        
        
        
    }
    
    /***** demo3-2：条件検索（範囲指定） *****/
    class func getRangeSearchData(_ ageGreaterThan: NSNumber?, ageLessThan: NSNumber?, successCallback: @escaping (_ objects: [Any]?) -> Void, errorCallback: @escaping (_ error: Error?) -> Void) {
        // [demo3-2_1]保存先クラスのクエリを生成
        
        // [demo3-2_2]検索条件の設定（保存日時の降順）
        
        // [demo3-2_3]検索条件（年齢）の設定（○○歳以上）
        
        // [demo3-2_4]検索条件（年齢）の設定（○○歳未満）
        
        // [demo3-2_5]全件検索処理の実行
        
        
        
        
    }

}
