//
//  LoginViewController.swift
//  TMDBLearning
//
//  Created by Laksh on 04/06/26.
//

import UIKit

final class LoginViewController : UIViewController {
    private let viewModel = LoginViewModel()
    
    private let emailTextField: UITextField = {

        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        return button
    }()

    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Account", for: .normal)
        return button
    }()

    private let activityIndicator = UIActivityIndicatorView(
        style: .large
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(
            self,
            action: #selector(loginTapped),
            for: .touchUpInside
        )

        signUpButton.addTarget(
            self,
            action: #selector(signUpTapped),
            for: .touchUpInside
        )

        NSLayoutConstraint.activate([

            emailTextField.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -80
            ),

            emailTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),

            emailTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),

            passwordTextField.topAnchor.constraint(
                equalTo: emailTextField.bottomAnchor,
                constant: 16
            ),

            passwordTextField.leadingAnchor.constraint(
                equalTo: emailTextField.leadingAnchor
            ),

            passwordTextField.trailingAnchor.constraint(
                equalTo: emailTextField.trailingAnchor
            ),

            loginButton.topAnchor.constraint(
                equalTo: passwordTextField.bottomAnchor,
                constant: 24
            ),

            loginButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            signUpButton.topAnchor.constraint(
                equalTo: loginButton.bottomAnchor,
                constant: 16
            ),

            signUpButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }
    
    private func bindViewModel(){
        viewModel.onStateChange = { [weak self] in
            guard let self = self else {return}
            self.updateUI();
        }
    }
    
    private func updateUI(){
        switch viewModel.state {
        case .idle:
            break
        case .loading:
            activityIndicator.startAnimating()
        case .success:
            activityIndicator.stopAnimating()
            let movieListVC = ViewController()
            let navController = UINavigationController( rootViewController: movieListVC )
            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate { sceneDelegate.window?.rootViewController = navController }
        case .error(let message):
            activityIndicator.stopAnimating()
            let alert = UIAlertController( title: "Login Failed",message: message,preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc
    private func loginTapped() {

        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty else {
                return
        }

        Task {
            await viewModel.login(
                email: email,
                password: password
            )
        }
    }

    @objc
    private func signUpTapped() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(
            signUpVC,
            animated: true
        )
    }

}
