//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController, LightningQuizDelegate{
    
    var trivia = Quiz()

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answersView: UIStackView!
    @IBOutlet weak var playAgainView: UIStackView!
    @IBOutlet weak var countdownView: CountdownView!
    

    override func viewDidLoad() -> Void{
        super.viewDidLoad()
    }
    
    func displayQuestion() {
        guard let question = trivia.currentQuestion else{
            displayScore()
            return
        }

        countdownView.resetCount()
        answersView.removeAllArrangedSubviews()

        for answer in question.possibleAnswers{
            let button = AnswerButton(answer: answer)
            button.addTarget(self, action: #selector(checkAnswer(_:)), for: .touchUpInside)
            answersView.addArrangedSubview(button)
        }

        questionField.text = question.text
        playAgainView.isHidden = true

        if let quiz  = trivia as? LightningQuiz{ // If we're in lightning mode, we need to start the timer once the question is displayed
            quiz.startQuestionTimer()
        }
    }
    
    func displayScore() {
        // Hide the answer buttons and countdown
        answersView.removeAllArrangedSubviews()
        countdownView.isHidden = true
        
        // Display play again buttons
        playAgainView.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(trivia.correctQuestions.count) out of \(trivia.questions.count) correct!"
        
    }

    @objc private func prepareForAnswer() -> Void{
        GameSound.correctAnswer.prepare()
        GameSound.incorrectAnswer.prepare()
    }
    
    @objc func checkAnswer(_ sender: AnswerButton) -> Void{
        if let lightningQuiz = trivia as? LightningQuiz{
            lightningQuiz.stopQuestionTimer()
        }
        do{
            guard let currentQuestion = trivia.currentQuestion else{
                displayScore()
                return
            }
            let result = try trivia.answerCurrentQuestion(sender.answer)
            displayAnswerRevealView(question: currentQuestion, userAnswerState: result)
            if let sound = result.sound, sound.duration != Double.signalingNaN{
                sound.play()
                loadNextRoundWithDelay(seconds: Int(Double.maximum(sound.duration.rounded(), 3)))
            }
            else{
                loadNextRoundWithDelay()
            }
        }
        catch{
            // The only error that can be thrown is if the quiz is over
            displayScore()
        }
    }
    
    func nextRound() -> Void{
        if trivia.isComplete{
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain(_ sender: LightningModeSelectionButton) -> Void{
        newGame(lightning: sender.lightningMode)
    }

    func newGame(lightning: Bool) -> Void{
        trivia = lightning ? LightningQuiz(delegate: self) : Quiz()
        countdownView.isHidden = !lightning
        GameSound.gameStart.play()
        nextRound()
    }
    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: DispatchTimeInterval) -> Void{
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.nextRound()
        }
    }

    func loadNextRoundWithDelay(seconds: Int = 3) -> Void{
        loadNextRoundWithDelay(seconds: .seconds(seconds))
    }

    func displayAnswerRevealView(question: Question, userAnswerState: Quiz.QuestionAnswerState) -> Void{
        if let buttons = answersView.arrangedSubviews as? [AnswerButton]{
            for button in buttons{
                button.displayForAnswerCorectness(button.answer.isCorrect(for: question))
            }
        }
        switch userAnswerState{
            case .correct:
                questionField.text = "Correct!"
            case .incorrect:
                questionField.text = "Sorry, wrong answer!"
            case .unanswered:
                questionField.text = "Oops, out of time!"
        }
    }
    // MARK: - LightningQuizDelegate Conformance

    func timerDidTick(for question: Question, remainingSeconds: TimeInterval, quiz: LightningQuiz) -> Void{
        countdownView.tick()
    }

    func timerDidExpire(for question: Question, quiz: LightningQuiz) -> Void{
        displayAnswerRevealView(question: question, userAnswerState: .unanswered(correctAnswer: question.correctAnswer))
        loadNextRoundWithDelay(seconds: 4)
    }
}

extension UIStackView{
    func removeAllArrangedSubviews() -> Void{
        for view in arrangedSubviews{
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}


extension Quiz.QuestionAnswerState{
    var sound: GameSound?{
        get{
            switch self {
                case .correct:
                    return .correctAnswer
                case .incorrect, .unanswered:
                    return .incorrectAnswer
            }
        }
    }
}
