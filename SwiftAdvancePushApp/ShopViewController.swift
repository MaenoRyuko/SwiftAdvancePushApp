//
//  ShopViewController.swift
//  SwiftAdvancePushApp
//
//  Created by Ikeda Natsumo on 2016/07/16.
//  Copyright © 2016年 NIFTY Corporation. All rights reserved.
//

import UIKit
import NCMB

class ShopViewController: UIViewController {
    // Shop画像を表示するView
    @IBOutlet weak var shopView: UIImageView!
    // お気に入りBarButtonItem
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    // Top画面のリストから取得したindex格納用
    var shopIndex: Int!
    // AppDelegate
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // インスタンス化された直後、初回のみ実行されるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        // 【mBaaS：ファイルストア】Shop画像ファイルの取得
        let imageName = appDelegate.shopList[shopIndex].objectForKey("shop_image") as! String
        let imageFile = NCMBFile.fileWithName(imageName, data: nil)
        imageFile.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error != nil {
                // ファイル取得失敗時の処理
                print("Shop画像の取得に失敗しました:\(error.code)")
            } else {
                // ファイル取得成功時の処理
                print("Shop画像の取得に成功しました")
                // Shop画像をImageViewに設定
                self.shopView.image = UIImage.init(data: data)
                // shopViewをViewに追加
                self.view.addSubview(self.shopView)
            }
        }
        
        // お気に入りBarButtonItemの初期設定
        favoriteBarButton.image = UIImage(named: "favorite_off") // 「♡」
        favoriteBarButton.tag = 0
        let favoriteObjectIdArray = appDelegate.currentUser.objectForKey("favorite") as! Array<String>
        // お気に入り登録されている場合の設定
        for objId in favoriteObjectIdArray {
            if objId == appDelegate.shopList[shopIndex].objectId {
                favoriteBarButton.image = UIImage(named: "favorite_on") // 「♥」
                favoriteBarButton.tag = 1
            }
        }
    }
    
    // 「お気に入り」ボタン押下時の処理
    @IBAction func tapFavoriteBtn(sender: UIBarButtonItem) {
        var favoriteObjectIdArray = appDelegate.currentUser.objectForKey("favorite") as! Array<String>
        let objeId = appDelegate.shopList[shopIndex].objectId
        // お気に入り状況に応じて処理
        if sender.tag == 0 {
            sender.image = UIImage(named: "favorite_on") // 「♥」
            sender.tag = 1
            // 追加
            favoriteObjectIdArray.append(objeId)
        } else {
            sender.image = UIImage(named: "favorite_off") // 「♡」
            sender.tag = 0
            var i = 0
            for element in favoriteObjectIdArray {
                if element == objeId {
                    // 削除
                    favoriteObjectIdArray.removeAtIndex(i)
                }
                i += 1
            }
        }
        
        // 【mBaaS：会員管理】ユーザー情報の更新
        // ログイン中のユーザーを取得
        let user = NCMBUser.currentUser()
        // favoriteに更新された値を設定
        user.setObject(favoriteObjectIdArray, forKey: "favorite")
        // ユーザー情報を更新
        user.saveInBackgroundWithBlock { (error: NSError!) -> Void in
            if error != nil {
                // 更新に失敗した場合の処理
                print("お気に入り情報更新に失敗しました:\(error.code)")
            } else {
                // 更新に成功した場合の処理
                print("お気に入り情報更新に成功しました")
                // AppDelegateに保持していたユーザー情報の更新
                self.appDelegate.currentUser = user
            }
        }
    }
}