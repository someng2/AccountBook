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
    
    var viewModel = LoginViewModel()
    
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
        self.navigationItem.setHidesBackButton(true, animated: true)
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
                print("로그인 성공! uid = \(String(describing: authResult?.user.uid))")
                // Save the email locally so you don't need to ask the user for it again
                // if they open the link on the same device.
                UserDefaults.standard.set(authResult?.user.uid, forKey: "Uid")
                print("userDeaults: \(UserDefaults.standard.dictionaryRepresentation())")
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "AccountBookListViewController") as! AccountBookListViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.errorMessageLabel.text = "이메일 또는 비밀번호를 다시 확인해주세요."
                print("로그인 실패")
                print(error.debugDescription)
            }
        }
        
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController else {
            return
        }
        vc.viewModel = self.viewModel
        self.present(vc, animated:true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
}
