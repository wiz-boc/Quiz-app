//
//  ViewController.swift
//  Quiz App
//
//  Created by wiz on 6/1/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	

	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var answerTable: UITableView!
	@IBOutlet weak var stackViewLeadingconstraint: NSLayoutConstraint!
	@IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
	@IBOutlet weak var rootStackView: UIStackView!
	
	var model = QuizModel()
	var questions = [Question]()
	var currentQuestionIndex = 0
	var numCorrect = 0
	
	var resultDialog: ResultViewController?
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//initialize the result diaglog
		resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController
		resultDialog?.modalPresentationStyle = .overCurrentContext
		resultDialog?.delegate = self
		
		answerTable.delegate = self
		answerTable.dataSource = self
		
		model.delegate = self
		model.getQuestions()
	}
	
	func slideInQuestion(){
		stackViewLeadingconstraint.constant = 1000
		stackViewTrailingConstraint.constant = -1000
		rootStackView.alpha = 0
		view.layoutIfNeeded()
		
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
			self.stackViewLeadingconstraint.constant = 0
			self.stackViewTrailingConstraint.constant = 0
			self.rootStackView.alpha = 1
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	func slideOutQuestion(){
		stackViewTrailingConstraint.constant = 0
		stackViewLeadingconstraint.constant = 0
		rootStackView.alpha = 1
		view.layoutIfNeeded()
		
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
			self.stackViewLeadingconstraint.constant = -1000
			self.stackViewTrailingConstraint.constant = 1000
			self.rootStackView.alpha = 0
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	func displayQuestion(){
		//check if there are questions and check that the currentQuesdtionIndex is not out of bounds
		
		guard questions.count > 0 &&
			currentQuestionIndex < questions.count else {
				return
		}
		
		//Display the question text
		questionLabel.text = questions[currentQuestionIndex].question
		answerTable.reloadData()
		DispatchQueue.main.async {
			self.slideInQuestion()
		}
	}

}

extension ViewController: QuizProtocol {
	func questionsRetrieved(_ questions: [Question]) {
		//Get refernce to the questions
		self.questions = questions
		let savedIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
		
		if savedIndex != nil && savedIndex! < self.questions.count {
			currentQuestionIndex = savedIndex!
			let savedNumCorrect = StateManager.retrieveValue(key: StateManager.numCorrectKey) as? Int
			
			if savedNumCorrect != nil {
				numCorrect = savedNumCorrect!
			}
		}
		
		//display the first question
		displayQuestion()

	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		//return the number of answer for question
		guard questions.count > 0 else {
			return 0
		}
		let numberOfAns = questions[currentQuestionIndex].answers?.count ?? 0
		return numberOfAns
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Answercell", for: indexPath)
		
		let label = cell.viewWithTag(1) as? UILabel
		
		if label != nil {
			
			let question = questions[currentQuestionIndex]
			
			if question.answers != nil && indexPath.row < question.answers!.count {
				//TODO: Set the answer text for UILabel
				label?.text = question.answers?[indexPath.row]
			}
		}
		//cell.textLabel?.text = questions[currentQuestionIndex].answers?[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//user has tapped on a row, check if it the correct ans
		var titleText = ""
		let question = questions[currentQuestionIndex]
		
		if question.correctAnswerIndex! == indexPath.row {
			titleText = "Correct! 🎊"
			numCorrect += 1
		}else{
			titleText = "Wrong! 😣"
		}
		DispatchQueue.main.async {
			self.slideOutQuestion()
		}
		
		//Show popup
		if resultDialog != nil {
			
			//CUSTOMIZE THE DIALOG TEXT
			resultDialog!.titleText = titleText
			resultDialog!.feedbackText = question.feedback!
			resultDialog!.buttonText = "NEXT"
			
			DispatchQueue.main.async {
				self.present(self.resultDialog!, animated: true, completion: nil)
			}
			
		}
		
	}
	
}

extension ViewController: ResultviewControllerProtocol {
	func dialogDismissed() {
		currentQuestionIndex += 1
		
		if currentQuestionIndex == questions.count{
			//the user just answer the last question
			if resultDialog != nil {
				
				//CUSTOMIZE THE DIALOG TEXT
				resultDialog!.titleText = "Summary"
				resultDialog!.feedbackText = "You got \(numCorrect) correct out of \(questions.count)"
				resultDialog!.buttonText = "Restart"
				
				present(resultDialog!, animated: true, completion: nil)
				StateManager.clearState()
			}
		}else if currentQuestionIndex > questions.count {
			currentQuestionIndex = 0
			numCorrect = 0
			displayQuestion()
		}
		else if currentQuestionIndex < questions.count {
			displayQuestion()
			StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
		}
		
	}
}

