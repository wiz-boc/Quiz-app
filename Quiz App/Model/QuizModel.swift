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
		//getLocalJsonFile()
		getRemoteJsonFile()
		
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
		let urlString = "https://codewithchris.com/code/QuestionData.json"
		guard let url = URL(string: urlString) else {
			print("Could not create the URL object")
			return
		}
		
		let session = URLSession.shared
		let dataTask = session.dataTask(with: url) { (data, response, error) in
			
			if error == nil && data != nil {
				
				do{
					let decoder = JSONDecoder()
					let array = try decoder.decode([Question].self, from: data!)
					
					DispatchQueue.main.async{
						self.delegate?.questionsRetrieved(array)
					}
					
				}catch{
					print(error.localizedDescription)
				}
				
			}
			
		}
		dataTask.resume()
	}
}
