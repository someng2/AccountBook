//
//  SignUpViewController.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/04.
//

import UIKit
import FirebaseAuth
import Combine

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailAuthButton: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var nickErrorLabel: UILabel!
    
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwDoubleTextField: UITextField!
    
    @IBOutlet weak var pwErrorLabel: UILabel!
    
    var subscriptions = Set<AnyCancellable>()
    var emailAuthCompleted = false
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        UserDefaults.standard.link = ""
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        UserDefaults.standard.link = "1234"
    }
    
    private func configureUI() {
        emailTextField.layer.cornerRadius = 15
        nicknameTextField.layer.cornerRadius = 15
        pwTextField.layer.cornerRadius = 15
        pwDoubleTextField.layer.cornerRadius = 15
        signUpButton.layer.cornerRadius = 30
        emailAuthButton.layer.cornerRadius = 20
        resetErrorLabel()
        configureBtnShadow(button: emailAuthButton)
        configureBtnShadow(button: signUpButton)
    }
    
    private func bind() {
        UserDefaults.standard
            .publisher(for: \.link)
            .handleEvents(receiveOutput: { link in
                print("---> link = \(link)")
                if !link.isEmpty {
                    self.updateErrorMessage(label: self.emailErrorLabel, isError: false, message: "이메일 인증 완료!")
                    self.emailAuthCompleted = true
                } else {
                    self.emailErrorLabel.text = ""
                    self.emailAuthCompleted = false
                }
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    private func configureBtnShadow(button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 10
    }
    
    private func updateErrorMessage(label: UILabel, isError: Bool, message: String) {
        label.textColor = isError ? .red : UIColor(named: "PrimaryBlue")
        label.text = message
    }
    
    private func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func resetErrorLabel() {
        emailErrorLabel.text = ""
        nickErrorLabel.text = ""
        pwErrorLabel.text = ""
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        resetErrorLabel()
        guard let email = self.emailTextField.text else {
            return
        }
        if email.isEmpty {
            updateErrorMessage(label: emailErrorLabel, isError: true, message: "이메일을 입력해주세요.")
            return
        }
        if !emailAuthCompleted {
            updateErrorMessage(label: emailErrorLabel, isError: true, message: "이메일 인증을 해주세요.")
            return
        }
        
        guard let nickname = nicknameTextField.text else {
            return
        }
        if nickname.isEmpty {
            updateErrorMessage(label: nickErrorLabel, isError: true, message: "닉네임을 입력해주세요.")
            return
        }
        
        guard let pw = self.pwTextField.text, let pwDouble = self.pwDoubleTextField.text else {
            return
        }
        if pw.isEmpty {
            updateErrorMessage(label: pwErrorLabel, isError: true, message: "비밀번호를 입력해주세요.")
            return
        }
        if pw.count < 6 {
            updateErrorMessage(label: pwErrorLabel, isError: true, message: "최소 6자 이상의 비밀번호를 입력해주세요.")
            return
        }
        if pwDouble.isEmpty {
            updateErrorMessage(label: pwErrorLabel, isError: true, message: "비밀번호를 중복하여 입력해주세요.")
            return
        }
        if pw != pwDouble {
            updateErrorMessage(label: pwErrorLabel, isError: true, message: "비밀번호가 일치하지 않습니다.")
            return
        }
        
//        Auth.auth().signIn(withEmail: email, link: UserDefaults.standard.link) { [weak self] result, error in
//            if let error = error {
//                print("email auth error \"\(error.localizedDescription)\"")
//                return
//            }
//            print("---> sign In: \(result)")
//        }
        viewModel.email = email
        viewModel.nickname = nickname
        viewModel.saveNewUser(email: email, pw: pw)
        
    }
    
    @IBAction func emailAuthButtonTapped(_ sender: Any) {
        emailErrorLabel.text = ""
        view.endEditing(true)
        
        guard let email = emailTextField.text else {
            return
        }
        
        guard !email.isEmpty else {
            updateErrorMessage(label: emailErrorLabel, isError: true, message: "이메일을 입력해주세요.")
            return
        }
        
        if !isValidEmail(email: email) {
            updateErrorMessage(label: emailErrorLabel, isError: true, message: "이메일 형식이 잘못되었습니다.")
            return
        }
        
        // TODO: 이메일 가입여부 확인
        
        
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://accountbook-270f1.firebaseapp.com/?email=\(email)")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                print("이메일 전송실패 \"\(error.localizedDescription)\"")
                return
            } else {
                print("이메일 전송완료!")
                // Save the email locally so you don't need to ask the user for it again
                // if they open the link on the same device.
                UserDefaults.standard.set(email, forKey: "Email")
                self.updateErrorMessage(label: self.emailErrorLabel, isError: false, message: "인증 메일을 확인해주세요.")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
}

extension UserDefaults {
    @objc var link: String {
        get {
            return string(forKey: "Link") ?? ""
        }
        set {
            set(newValue, forKey: "Link")
        }
    }
}
