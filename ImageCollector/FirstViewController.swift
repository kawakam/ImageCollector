//
//  FirstViewController.swift
//  ImageGetter
//
//  Created by 川上智樹 on 2015/11/11.
//  Copyright © 2015年 yatuhasiumai. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tapBtnObject: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextField.delegate = self
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.userId = self.inputTextField.text
    }
    
    @IBAction func tapBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "mySegue", sender: "self")
    }
    
}
