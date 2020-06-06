//
//  QuizModel.swift
//  Quiz App
//
//  Created by wiz on 6/1/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import Foundation

protocol QuizProtocol {
	func questionsRetrieved(_ questions:[Question])
}

class QuizModel {
	
	
	var delegate: QuizProtocol?
	
	func getQuestions(){
			
		//TODO: fetch the question
		getLocalJsonFile()
		
	}
	
	func getLocalJsonFile(){
		//Get bundle path to json file
		let path = Bundle.main.path(forResource: "Questions", ofType: "json")
		
		guard path != nil else {
			print("cudnt find json data file")
			return
		}
		
		//Create a url object from the path
		let url = URL(fileURLWithPath: path!)
		
		//get the data from the URL
		do {
			//get data from url
			let data = try Data(contentsOf: url)
			
			//try to decode data
			let decoder = JSONDecoder()
			let array = try decoder.decode([Question].self, from: data)
			
			//notify the delegate of the parsed objects
			delegate?.questionsRetrieved(array)
			
		}catch{
			//error couldnt read the data at the URL
			print(error.localizedDescription)
		}
		
	}
	
	func getRemoteJsonFile(){
		
	}
}
