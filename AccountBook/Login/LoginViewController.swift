//
//  LoginViewController.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/03.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        errorMessageLabel.text = ""
    }
    
    private func configureUI() {
        emailTextField.layer.cornerRadius = 15
        pwTextField.layer.cornerRadius = 15
        logInButton.layer.cornerRadius = 30
        signUpButton.layer.cornerRadius = 30
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        let email: String = emailTextField.text!.description
        let pw: String = pwTextField.text!.description
        
        if email.isEmpty {
            errorMessageLabel.text = "이메일을 입력해주세요."
            return
        }
        if pw.isEmpty {
            errorMessageLabel.text = "비밀번호를 입력해주세요."
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pw) {authResult, error in
            if authResult != nil {
                self.errorMessageLabel.text = ""
                print("로그인 성공")
            } else {
                self.errorMessageLabel.text = "이메일과 비밀번호를 다시 확인해주세요."
                print("로그인 실패")
                print(error.debugDescription)
            }
            
        }
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") else {
            return
        }
        self.present(vc, animated:true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
}
