//
//  LoginViewController.swift
//  Twitter
//
//  Created by Aldo Socarras on 2/17/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

let USER_LOGGED_IN = "USER_LOGGED_IN"

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 45
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.bool(forKey: USER_LOGGED_IN) == true) {
            goToHome()
        }
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        let url = "https://api.twitter.com/oauth/request_token"
        
        TwitterAPICaller.client?.login(url: url, success: {
            UserDefaults.standard.set(true, forKey: USER_LOGGED_IN)
            self.goToHome()
        }, failure: { Error in
            print("Error: " + Error.localizedDescription)
        })
    }
    
    func goToHome() {
        performSegue(withIdentifier: "loginToHome", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
