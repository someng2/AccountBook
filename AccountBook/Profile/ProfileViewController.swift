//
//  ProfileViewController.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/16.
//

import UIKit
import RxSwift

class ProfileViewController: UIViewController {
    
    let bag = DisposeBag()
    let viewModel: ProfileViewModel = ProfileViewModel()
    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-56, height: 60))
        button.setTitleColor(UIColor(named: "GrayButton"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitle("로그아웃", for: .normal)
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor(named: "GrayButton")?.cgColor
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 10
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        viewModel.getUserInfo()
        setupUI()
    }
    
    private func bind() {
        viewModel.uid
            .subscribe { [weak self] uid in
                self?.viewModel.user.uid = uid
            }.disposed(by: bag)
        
        viewModel.email
            .subscribe { [weak self] email in
                self?.viewModel.user.email = email
                self?.addEmailLabel(email)
            }.disposed(by: bag)
        
        viewModel.nickname
            .subscribe { [weak self] nickname in
                self?.viewModel.user.nickname = nickname
                self?.addNicknameLabel(nickname)
            }.disposed(by: bag)
    }
    
    private func addNicknameLabel(_ nickname: String) {
        nicknameLabel.text = nickname
        view.addSubview(nicknameLabel)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25)
        ])
    }
    
    private func addEmailLabel(_ email: String) {
        emailLabel.text = email
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 25),
            emailLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor)
        ])
    }
    
    private func setupUI() {
        view.addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logOutButton.bottomAnchor.constraint(equalTo: (view.safeAreaLayoutGuide.bottomAnchor), constant: -50),
            logOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func logOutButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "Uid")
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
