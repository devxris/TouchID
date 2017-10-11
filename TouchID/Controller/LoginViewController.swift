//
//  LoginViewController.swift
//  TouchID
//
//  Created by Chris Huang on 11/10/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit

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
	}

}

