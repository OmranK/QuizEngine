//
//  Flow.swift
//  QuizEngine
//
//  Created by Omran Khoja on 3/17/21.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallBack: @escaping AnswerCallback)
    func routeTo(result: [String: String])
}

class Flow {
    private let router:  Router
    private let questions: [String]
    private var result: [String:String] = [:]
    
    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }
    
    func start() {
        if !questions.isEmpty {
            if let firstQuestion = questions.first {
                router.routeTo(question: firstQuestion, answerCallBack: nextCallBack(from: firstQuestion))
            }
        } else {
            router.routeTo(result: result)
        }
    }
    
    private func nextCallBack(from question: String) -> Router.AnswerCallback {
        return { [weak self] in self?.routeNext(question, $0)

//            if let strongSelf = self {
//                strongSelf.routeNext(question, answer)
//            }
        }
    }
    
    private func routeNext(_ question: String, _ answer: String) {
        if let indexOfCurrentQuestion = questions.firstIndex(of: question) {
            result[question] = answer
            let nextQuestionIndex = indexOfCurrentQuestion + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallBack: nextCallBack(from: nextQuestion))
            } else {
                router.routeTo(result: result)
            }
        }

    }
}


