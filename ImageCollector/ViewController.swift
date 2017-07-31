//
//  ViewController.swift
//  ImageGetter
//
//  Created by 川上智樹 on 2015/10/28.
//  Copyright © 2015年 yatuhasiumai. All rights reserved.
//

import UIKit
import Accounts
import Social
import WebKit
import Alamofire

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var allSaveBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    var myCollectionView : UICollectionView!
    var accountStore = ACAccountStore()
    var twAccount: ACAccount?
    var currentSelectedArticle: String?
    var imageMana = ImageManager.sharedInstance
    var selectedArray: Array<Image> = []
    var savingImageArray: Array<Image> = []
    var tmpNumber: Double?
    var maxNumber: Int64?
    var userId: String!
    var loading = false
    
    var twitterAccount = ACAccount()
    var store = ACAccountStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        // Cell一つ一つの大きさ.
        layout.itemSize = CGSize(width: 78, height: 78)
        
        // Cellのマージン.
        layout.sectionInset = UIEdgeInsetsMake(16, 16, 32, 16)
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width: 100, height: 0)
        
        // CollectionViewを生成.
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 90)
        
        self.myCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.myCollectionView.frame.origin = CGPoint(x: 0, y: 68)
        self.myCollectionView.backgroundColor = UIColor(red: 170 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1.0)
        
        // Cellに使われるクラスを登録.
        self.myCollectionView.register(CustomCell.self, forCellWithReuseIdentifier: "myCell")
        
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        self.view.addSubview(self.myCollectionView)

        // account選択
        selectTwitterAccount()
        
        }
    
    // Backボタンが押された時
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true) { () -> Void in
            self.imageMana.images.removeAll()
        }
    }

    // カメラロールに保存の時にエラーが出たら表示====================================================================================================================================================================================================================================================================================================================
    func image(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        print("image delegate method")
        if error != nil {
            print("save error \(image)")
            print(error.description)
        } else {
            print("save completed \(image)")
            savingImageArray.remove(at: 0)
            saveImages()
        }
    }
    
    // 保存ボタンが押された時に呼び出される
    @IBAction func tapSaveImage(_ sender: UIButton) {
        if loading == false {
            
            for tmp in self.imageMana.images {
                if tmp.selected == true {
                    savingImageArray.append(tmp)
                }
            }
            
            if savingImageArray.count > 0 {
                let selectSaveAlertController = UIAlertController(title: "Save", message: "選択した画像をカメラロールに保存しますか？", preferredStyle: UIAlertControllerStyle.actionSheet)
                let saveAction = UIAlertAction(title: "はい", style: UIAlertActionStyle.default, handler: {
                    (action: UIAlertAction) -> Void in
                    self.loading = true
                    self.reloadBtn.isEnabled = false
                    self.saveBtn.isEnabled = false
                    self.allSaveBtn.isEnabled = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true

                    
                    self.saveImages()
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                selectSaveAlertController.addAction(saveAction)
                selectSaveAlertController.addAction(cancelAction)
                self.present(selectSaveAlertController, animated: true, completion: nil)
            }
        } else {
            print("loading now")
            return
        }
    }
    
    // 一括保存ボタンが押された時に呼び出される
    @IBAction func tapSaveAll(_ sender: UIButton) {
        if loading == false {
            
            let saveAllAlertController = UIAlertController(title: "Save All", message: "全ての画像をカメラロールに保存しますか？", preferredStyle: UIAlertControllerStyle.actionSheet)
            let saveAction = UIAlertAction(title: "はい", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction) -> Void in
                self.loading = true
                self.reloadBtn.isEnabled = false
                self.saveBtn.isEnabled = false
                self.allSaveBtn.isEnabled = false
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.savingImageArray = self.imageMana.images
                self.saveImages()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            saveAllAlertController.addAction(saveAction)
            saveAllAlertController.addAction(cancelAction)
            self.present(saveAllAlertController, animated: true, completion: nil)
            
            selectedArray.removeAll()
        } else {
            print("loading now")
            return
        }
    }
    
    // イメージを端末に保存するメソッド
    func saveImages() {
        if self.savingImageArray.count > 0 {
            let req = Alamofire.request(savingImageArray[0].url)
            req.response() { response in
                if response.error == nil {
                    DispatchQueue.main.async { () in
                        let tmpImage = UIImage(data: response.data! as Data)
                        UIImageWriteToSavedPhotosAlbum(tmpImage!, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    }
                }
            }
            
        } else {
            let alertController = UIAlertController(title: "Completed!", message: "画像が保存出来ました", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.loading = false
                self.reloadBtn.isEnabled = true
                self.saveBtn.isEnabled = true
                self.allSaveBtn.isEnabled = true
            })
            
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            savingImageArray.removeAll()
            for num in self.imageMana.images {
                if num.selected == true {
                    num.selected = false
                }
            }
            myCollectionView.reloadData()
        }
    }
    
    // リロード200メソッド
    @IBAction func reload200(_ sender: UIButton) {
        if loading == false {
            print("start loding")
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            getTimeline(maxNumber)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            print(imageMana.images.count)
        } else {
            print("loading now")
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    
    
    
    

    // アクセス承認============================================================================================================================================================================================================================================================================================================
    fileprivate func selectTwitterAccount() {
        
        // 認証するアカウントのタイプを選択（他にはFacebookやWeiboなどがある）
//        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
//        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (granted:Bool, error:NSError?) -> Void in
//            if error != nil {
//                // エラー処理
//                print("error! \(error)")
//                return
//            }
//            
//            if !granted {
//                print("error! Twitterアカウントの利用が許可されていません")
//                return
//            }
//            
//            let accounts = self.accountStore.accounts(with: accountType) as! [ACAccount]
//            if accounts.count == 0 {
//                print("error! 設定画面からアカウントを設定してください")
//                return
//            }
//            self.showAccountSelectSheet(accounts)
//        } as! ACAccountStoreRequestAccessCompletionHandler
        
        let accountType = store.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        store.requestAccessToAccounts(with: accountType, options: nil) { [weak self] granted, error in
            guard self != nil else { return }
            
            if !granted {
                print("error! Twitterアカウントの利用が許可されていません")
                return
            }
            
            if error != nil {
                print("error! 設定画面からアカウントを設定してください")
                return
            }
            
            let accounts = self?.store.accounts(with: accountType)
                as! [ACAccount]
            
            self?.selectTwitterAccount(accounts: accounts)
            
        
        }
    }
    
    /**
     アカウント選択
     */
    func selectTwitterAccount(accounts: [ACAccount]) {
        let alert = UIAlertController(title: "Twitter",
                                      message: "アカウントを選択してください",
                                      preferredStyle: .actionSheet)
        
        
        for account in accounts {
            alert.addAction(UIAlertAction(title: account.username, style: .default,
                                          handler: { (action) -> Void in
                                            self.twitterAccount = account
                                            
            }))
        }
        
        // 表示する
        self.present(alert, animated: true, completion: nil)
    }
    
    // アカウント選択のActionSheetを表示する
    fileprivate func showAccountSelectSheet(_ accounts: [ACAccount]) {
        
        let alert = UIAlertController(title: "Twitter", message: "アカウントを選択してください", preferredStyle: .actionSheet)
        
        // アカウント選択のActionSheetを表示するボタン
        for account in accounts {
            alert.addAction(UIAlertAction(title: account.username, style: .default, handler: { (action) -> Void in
                self.twAccount = account
                
                // TL取得
                self.getTimeline(nil)
            }))
        }
        
        // キャンセルボタン
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // 表示する
        self.present(alert, animated: true, completion: nil)
    }

    // データを取得するメソッド
    fileprivate func getTimeline(_ maxNumber: Int64?) {
        print("getTimeline started")
        loading = true
        reloadBtn.isEnabled = false
        saveBtn.isEnabled = false
        allSaveBtn.isEnabled = false
        let URL: Foundation.URL
        if let unwrappedMaxNumber = maxNumber {
            URL = Foundation.URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(userId)&count=200&max_id=\(unwrappedMaxNumber)&trim_user=true&contributor_details=false&exclude_replies=true&include_rts=false")!
        } else {
            URL = Foundation.URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(userId)&count=200&trim_user=true&contributor_details=false&exclude_replies=true&include_rts=false")!
        }
        
        // GET/POSTやパラメータに気をつけてリクエスト情報を生成
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: URL, parameters: nil)
        
        // 認証したアカウントをセット
        request?.account = twAccount
        
        // APIコールを実行
        request?.perform { (responseData, urlResponse, error) -> Void in
            if error != nil {
                print("error is \(String(describing: error))")
                self.loading = false
            } else {
                // 結果の表示
                do {
                    if let result = try JSONSerialization.jsonObject(with: responseData!, options: .allowFragments) as? NSArray {
                        let task = URLSession.shared.dataTask(with: URL, completionHandler:{data, response, error in
                            for tweet in result {
                                let tweetDic = tweet as! NSDictionary
                                var entities = tweetDic["entities"] as! NSDictionary
                                if tweetDic["extended_entities"] != nil {
                                    entities = tweetDic["extended_entities"] as! NSDictionary
                                }
                                if let media = entities["media"] as? NSArray {
                                    for num in 0 ..< media.count{
                                        let media_url = media[num]["media_url_https"] as! String
                                        self.tmpNumber = Double(media[num]["id"] as! NSNumber)
                                        self.maxNumber = Int64(self.tmpNumber!)
                                        let image = Image(url: media_url, callback: { () in
                                            self.myCollectionView.reloadData()
                                        })
                                        self.imageMana.images.append(image)
                                    }
                                }
                            }
                            print("get tweets done")
                            self.loading = false
                            self.reloadBtn.isEnabled = true
                            self.saveBtn.isEnabled = true
                            self.allSaveBtn.isEnabled = true
                        })
                        task.resume()
                    }
                } catch {
                }
            }
        }
    }
    
    // cellのレイアウトなど=========================================================================================================================================================================================================================================================================================================================

    
    
    // Cellが選択された際に呼び出される
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Num: \(indexPath.row)")
        
        if imageMana.images[indexPath.row].selected == false {
            imageMana.images[indexPath.row].selected = true
        } else {
            imageMana.images[indexPath.row].selected = false
        }
        myCollectionView.reloadData()
    }
    
    // Cellの総数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageMana.images.count
    }
    
    // Cellに値を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CustomCell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CustomCell
        cell.cellImageView.image = self.imageMana.images[indexPath.row].img
        cell.layer.borderWidth = 3
        if imageMana.images[indexPath.row].selected == true {
            cell.layer.borderColor = UIColor.orange.cgColor
        } else {
            cell.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        }
        return cell
    }
}

