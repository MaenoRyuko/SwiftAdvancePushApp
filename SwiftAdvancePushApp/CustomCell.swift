//
//  CustomCell.swift
//  SwiftAdvancePushApp
//
//  Created by Natsumo Ikeda on 2016/07/16.
//  Copyright © 2016年 NIFTY Corporation. All rights reserved.
//

import UIKit
import NCMB

class CustomCell: UITableViewCell {
    /** Top画面のTableViewのcell用 **/
    // icon表示用ImageView
    @IBOutlet weak var iconImageView_top: UIImageView!
    // Shop名表示用ラベル
    @IBOutlet weak var shopName_top: UILabel!
    // カテゴリ表示用ラベル
    @IBOutlet weak var category_top: UILabel!
    
    /** お気に入り画面のTableViewのcell用 **/
    // Shop名表示用ラベル
    @IBOutlet weak var shopName_favorite: UILabel!
    // お気に入りON/OFF設定用スイッチ
    @IBOutlet weak var favoriteSwitch_favorite: UISwitch!
    // スイッッチ選択時objectId一時保管用
    var objectIdTemporary: String!
    
    // AppDelegate
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    /** Top画面のTableViewのcell **/
    func setCell_top(object: NCMBObject) {
        // 【mBaaS：ファイルストア】icon画像の取得
        let imageName = object.objectForKey("icon_image") as! String
        let imageFile = NCMBFile.fileWithName(imageName, data: nil)
        imageFile.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error != nil {
                // ファイル取得失敗時の処理
                print("icon画像の取得に失敗しました:\(error.code)")
            } else {
                // ファイル取得成功時の処理
                print("icon画像の取得に成功しました")
                // icon画像を設定
                self.iconImageView_top.image = UIImage.init(data: data)
            }
        }
        // Shop名を設定
        shopName_top.text = object.objectForKey("name") as? String
        // categoryを設定
        category_top.text = object.objectForKey("category") as? String
    }
    
    /** お気に入り画面のTableViewのcell **/
    func setCell_favorite(object: NCMBObject) {
        let objId = object.objectId
        //　Shop名を設定
        shopName_favorite.text = object.objectForKey("name") as? String
        // objectIdを保持
        objectIdTemporary = objId
        // スイッチ選択時に実行されるメソッドの設定
        favoriteSwitch_favorite.addTarget(self, action: "switchChenged:", forControlEvents: UIControlEvents.ValueChanged)
        // スイッチの初期設定
        favoriteSwitch_favorite.on = false
        // お気に入り登録されている場合はスイッチをONに設定
        let favoriteArray = appDelegate.currentUser.objectForKey("favorite") as! Array<String>
        for element in favoriteArray {
            if element == objId {
                favoriteSwitch_favorite.on = true
            }
        }
    }
    
    // スイッチ選択時の処理
    func switchChenged(sender: UISwitch) {
        if sender.on {
            // スイッチがONになったときの処理
            // 追加
            appDelegate.favoriteObjectIdTemporaryArray.append(objectIdTemporary)
        } else {
            // スイッチがOFFになったときの処理
            var i = 0
            for element in appDelegate.favoriteObjectIdTemporaryArray {
                if element == objectIdTemporary {
                    // 削除
                    appDelegate.favoriteObjectIdTemporaryArray.removeAtIndex(i)
                }
                i += 1
            }
        }
    }
}