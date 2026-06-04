//
//  SignUpViewController.swift
//  TMDBLearning
//
//  Created by Laksh on 04/06/26.
//

import UIKit

final class SignUpViewController: UIViewController {

    private let authService = AuthService()

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

        title = "Sign Up"

        view.backgroundColor = .systemBackground

        setupUI()
    }

    private func setupUI() {

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        signUpButton.addTarget(
            self,
            action: #selector(signUpTapped),
            for: .touchUpInside
        )

        NSLayoutConstraint.activate([

            emailTextField.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -60
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

            signUpButton.topAnchor.constraint(
                equalTo: passwordTextField.bottomAnchor,
                constant: 24
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

    @objc
    private func signUpTapped() {

        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty else {

            return
        }

        activityIndicator.startAnimating()

        Task {

            do {

                try await authService.signUp(
                    email: email,
                    password: password
                )

                activityIndicator.stopAnimating()

                let alert = UIAlertController(
                    title: "Success",
                    message: "Account created successfully",
                    preferredStyle: .alert
                )

                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default
                    ) { [weak self] _ in

                        self?.navigationController?
                            .popViewController(animated: true)
                    }
                )

                present(alert, animated: true)

            } catch {

                activityIndicator.stopAnimating()

                let alert = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )

                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default
                    )
                )

                present(alert, animated: true)
            }
        }
    }
}
