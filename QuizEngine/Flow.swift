//
//  Flow.swift
//  QuizEngine
//
//  Created by Omran Khoja on 3/17/21.
//

import Foundation

protocol Router {
    associatedtype Answer
    associatedtype Question: Hashable

    typealias AnswerCallback = (Answer) -> Void
    func routeTo(question: Question, answerCallBack: @escaping (Answer) -> Void)
    func routeTo(result: [Question: Answer])
}

class Flow <Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    private let router:  R
    private let questions: [Question]
    private var result: [Question:Answer] = [:]
    
    init(questions: [Question], router: R) {
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
    
    private func nextCallBack(from question: Question) -> R.AnswerCallback {
        return { [weak self] in self?.routeNext(question, $0)

//            if let strongSelf = self {
//                strongSelf.routeNext(question, answer)
//            }
        }
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
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


