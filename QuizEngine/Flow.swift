//
//  Flow.swift
//  QuizEngine
//
//  Created by Omran Khoja on 3/17/21.
//

import Foundation

class Flow <Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    private let router:  R
    private let questions: [Question]
    private var answers: [Question:Answer] = [:]
    private var scoring: ([Question:Answer]) -> Int
    
    init(questions: [Question], router: R, scoring: @escaping ([Question: Answer]) -> Int) {
        self.router = router
        self.questions = questions
        self.scoring = scoring
    }
    
    func start() {
        if !questions.isEmpty {
            if let firstQuestion = questions.first {
                router.routeTo(question: firstQuestion, answerCallBack: nextCallBack(from: firstQuestion))
            }
        } else {
            router.routeTo(result: result())
        }
    }
    
    private func nextCallBack(from question: Question) -> R.AnswerCallback {
        return { [weak self] in self?.routeNext(question, $0)
        }
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
        if let indexOfCurrentQuestion = questions.firstIndex(of: question) {
            answers[question] = answer
            let nextQuestionIndex = indexOfCurrentQuestion + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallBack: nextCallBack(from: nextQuestion))
            } else {
                router.routeTo(result: result())
            }
        }
    }
    
    private func result() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers) )
    }
}
