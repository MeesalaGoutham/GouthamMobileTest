//
//  ViewController.swift
//  GauthamMobileTest
//
//  Created by Apple on 01/06/18.
//  Copyright © 2018 Gautham. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    @IBAction func loginButtonClicked(_ sender:UIButton){
        
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
                let hash:HashTagSearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "HashTagSearchViewController") as! HashTagSearchViewController
                hash.userID = (session?.userID)!
                self.navigationController?.pushViewController(hash, animated: true)
                
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

