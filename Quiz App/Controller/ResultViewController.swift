//
//  ResultViewController.swift
//  Quiz App
//
//  Created by wiz on 6/5/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

	@IBOutlet weak var dimView: UIView!
	@IBOutlet weak var dialogview: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var feedbackLabel: UILabel!
	@IBOutlet weak var dismissButton: UIButton!
	
	var titleText = ""
	var feedbackText = ""
	var buttonText = ""
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		//set text on label
		titleLabel.text = titleText
		feedbackLabel.text = feedbackText
		dismissButton.setTitle(buttonText, for: .normal)
		
    }
	@IBAction func dissmissBtntapped(_ sender: UIButton) {
		//TODO
	}
	
	
	
}
