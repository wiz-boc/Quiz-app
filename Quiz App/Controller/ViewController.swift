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
		answerTable.delegate = self
		answerTable.dataSource = self
		
		model.delegate = self
		model.getQuestions()
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
	}

}

extension ViewController: QuizProtocol {
	func questionsRetrieved(_ questions: [Question]) {
		//Get refernce to the questions
		self.questions = questions
		
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
		
		let question = questions[currentQuestionIndex]
		
		if question.correctAnswerIndex! == indexPath.row {
			//user got it right
			print("correct")
		}else{
			//user got it wrong
			print("wrong")
		}
		
		//Show popup
		if resultDialog != nil {
			present(resultDialog!, animated: true, completion: nil)
		}
		
		currentQuestionIndex += 1
		displayQuestion()
		
		
	}
	
	
	
}

