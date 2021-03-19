//
//  Result.swift
//  QuizEngine
//
//  Created by Omran Khoja on 3/19/21.
//

import Foundation

struct Result<Question:Hashable, Answer> {
    let answers: [Question: Answer]
    let score: Int
}
