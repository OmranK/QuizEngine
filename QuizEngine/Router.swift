//
//  Router.swift
//  QuizEngine
//
//  Created by Omran Khoja on 3/19/21.
//

import Foundation


protocol Router {
    associatedtype Answer: Equatable
    associatedtype Question: Hashable

    typealias AnswerCallback = (Answer) -> Void
    func routeTo(question: Question, answerCallBack: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}
