//
//  LoginViewController.swift
//  Crate
//
//  Created by JD Chiang on 18/5/2023.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func toJoin(_ sender: Any) {
    }
    
    @IBAction func resetPassword(_ sender: Any) {
    }
    
    @IBAction func login(_ sender: Any) {
        guard let email = emailField.text, email.isEmpty == false, email.contains("@") else {
            displayMessage(title: "Error", message: "Please enter valid email!")
            return
        }
        guard let password = passwordField.text, password.isEmpty == false else {
            displayMessage(title: "Error", message: "Please enter valid password!")
            return
        }
        Task {
            do {
                let authResult = try await Auth.auth().signInAnonymously()
                self.currentUser = User(userId: authResult.user.uid, userEmail: self.emailField.text)
                ///Save to core data
                ///
                ///
                self.performSegue(withIdentifier: self.SEGUE_LOGIN, sender: nil)
            } catch {
                fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
            }
        }
    }
    
    
    var currentUser: User?
    let SEGUE_LOGIN = "loginSegue"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_LOGIN {
            let destination = segue.destination as!
            DiscoveryCollectionViewController
            ///ADD THE FIRST SCREEN USER WILL SEE
        }
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
