//
//  Flow.swift
//  QuizEngine
//
//  Created by Omran Khoja on 3/17/21.
//

import Foundation

protocol Router {
    func routeTo(question: String, answerCallBack: @escaping (String) -> Void)
}

class Flow {
    let router:  Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }
    
    func start() {
        if !questions.isEmpty {
            if let q1 = questions.first {
                router.routeTo(question: q1) { [weak self] _ in
                    guard let strongSelf = self else { return }
                    let indexOfQ1 = strongSelf.questions.firstIndex(of: q1)
                    let nextQuestion = strongSelf.questions[indexOfQ1! + 1]
                    strongSelf.router.routeTo(question: nextQuestion) { _ in }
                    
                }
            }
        }
    }
}
