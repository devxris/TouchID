//
//  LoginViewController.swift
//  TouchID
//
//  Created by Chris Huang on 11/10/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	private var imageSet = ["cloud", "coffee", "food", "pmq", "temple"]
	
	var blurEffectView: UIVisualEffectView?
	var vibrancyEffectView: UIVisualEffectView?
	@IBOutlet weak var labelBlurView: UIVisualEffectView! {
		didSet {
			labelBlurView.layer.cornerRadius = 10
			labelBlurView.layer.masksToBounds = true
		}
	}
	
	lazy var privacyLabel: UILabel = {
		let label = UILabel()
		label.text = "By logging in, you agree to the Terms of Service and Privacy Policy"
		label.textColor = .darkGray
		label.textAlignment = .center
		label.numberOfLines = 2
		label.frame = self.labelBlurView.bounds
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Randomly pick an image
		let selectedImageIndex = Int(arc4random_uniform(5))
		backgroundImageView.image = UIImage(named: imageSet[selectedImageIndex])
		
		// Apply blurring and vibrancy effect
		let blurEffect = UIBlurEffect(style: .light)
		blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView?.frame = view.bounds
		
		let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
		vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
		vibrancyEffectView?.frame = view.bounds
		
		backgroundImageView.addSubview(blurEffectView!)
		backgroundImageView.addSubview(vibrancyEffectView!)
		
		// Add privacy label into label blur view
		labelBlurView.contentView.addSubview(privacyLabel)
		
		authenticateWithTouchID()
	}
	
	@objc func showLoginView() {
		// Move the login view off screen
		loginView.isHidden = true
		loginView.transform = CGAffineTransform(translationX: 0, y: -700)
		
		UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
			
			self.loginView.isHidden = false
			self.loginView.transform = CGAffineTransform.identity
			
		}, completion: nil)
	}
	
	func authenticateWithTouchID() {
		
		// Get the local authentication context
		let localAuthContext = LAContext()
		let reasonText = "Authentication is required to sign in AppCoda"
		var authError: NSError?
		
		// Check whether the device is capable of using TouchID
		if !localAuthContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
			if let error = authError { print(error.localizedDescription) }
			// Display the login dialog when Touch ID is not available
			showLoginView()
			return
		}

		// Perform the Touch ID authentication
		localAuthContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonText) { (success, error) in
			if !success {
				if let error = error {
					switch error {
					case LAError.authenticationFailed: print("Authentication Failed.")
					case LAError.passcodeNotSet: print("Passcode not set.")
					case LAError.systemCancel: print("Authentication was cancelled by system.")
					case LAError.biometryNotEnrolled:
						print("Authentication could not start because Touch ID has no enrolled fingers.")
					case LAError.biometryNotAvailable:
						print("Authentication could not start because Touch ID is not available.")
					case LAError.biometryLockout :
						print("Authentication could not start because Touch ID is locked out.")
					case LAError.userCancel: print("Authentication was cancelled by user.")
					case LAError.userFallback: print("User tapped the fallback button (Enter Password).")
					default : print(error.localizedDescription)
					}
					// fall back to loginView
					DispatchQueue.main.async { self.showLoginView() }
				}
			}
			print("Authentication Successfully!")
			DispatchQueue.main.async { self.performSegue(withIdentifier: "Login", sender: nil) }
		}
	}
	
	@IBAction func authenticateWithPassword() {
		if emailTextField.text == "hi@appcoda.com" && passwordTextField.text ==
			"1234" {
			performSegue(withIdentifier: "Login", sender: nil)
		} else {
			// Shake to indicate wrong login ID/password
			loginView.transform = CGAffineTransform(translationX: 25, y: 0)
			UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping:
				0.15, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
					self.loginView.transform = CGAffineTransform.identity
			}, completion: nil)
		}
	}
}
