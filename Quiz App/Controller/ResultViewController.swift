//
//  ResultViewController.swift
//  Quiz App
//
//  Created by wiz on 6/5/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit

protocol ResultviewControllerProtocol {
	func dialogDismissed()
}

class ResultViewController: UIViewController {

	@IBOutlet weak var dimView: UIView!
	@IBOutlet weak var dialogView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var feedbackLabel: UILabel!
	@IBOutlet weak var dismissButton: UIButton!
	
	var titleText = ""
	var feedbackText = ""
	var buttonText = ""
	
	var delegate:ResultviewControllerProtocol?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		dialogView.layer.cornerRadius = 10
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		//set text on label
		titleLabel.text = titleText
		feedbackLabel.text = feedbackText
		dismissButton.setTitle(buttonText, for: .normal)
		
		
		//hide UI Elements
		dimView.alpha = 0
		titleLabel.alpha = 0
		feedbackLabel.alpha = 0
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
			self.dimView.alpha = 1
			self.titleLabel.alpha = 1
			self.feedbackLabel.alpha = 1
		}, completion: nil)
	}
	@IBAction func dissmissBtntapped(_ sender: UIButton) {
		//TODO
		
		UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
			self.dimView.alpha = 0
		}) { (completed) in
			self.dismiss(animated: true, completion: nil)
			//Notifyt delegate the popup was dismissed
			self.delegate?.dialogDismissed()
		}
		
		
	}
	

	
}
