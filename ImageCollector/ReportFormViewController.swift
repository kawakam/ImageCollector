//
//  ReportFormViewController.swift
//  ImageCollector
//
//  Created by 川上智樹 on 2016/03/15.
//  Copyright © 2016年 yatuhasiumai. All rights reserved.
//

import UIKit

class ReportFormViewController: UIViewController {
    @IBOutlet weak var reportTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func sendReport(_ sender: UIButton) {
        save(reportTextView.text)
        showAlert()
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func save(_ text: String) {
        let reportObject = NCMBObject(className: "report")
        reportObject?.setObject(text, forKey: "text")
        reportObject?.saveInBackground { (error) in
            if error == nil {
                print("保存完了")
            }
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "送信完了", message: "レポートが送信されました", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
