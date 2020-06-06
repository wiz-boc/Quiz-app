//
//  Question.swift
//  Quiz App
//
//  Created by wiz on 6/1/20.
//  Copyright © 2020 Codelife studio. All rights reserved.
//

import Foundation

struct Question: Codable {
	var question:String?
	var answers:[String]?
	var correctAnswerIndex: Int?
	var feedback:String?
}
