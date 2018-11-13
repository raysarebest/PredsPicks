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

class ViewController: UIViewController {
    
    var gameSound: SystemSoundID = 0
    
    var trivia = Quiz()

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answersView: UIStackView!
    @IBOutlet weak var playAgainButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        guard let question = trivia.currentQuestion else{
            displayScore()
            return
        }

        answersView.removeAllArrangedSubviews()

        for answer in question.possibleAnswers{
            let button = AnswerButton(answer: answer)
            button.addTarget(self, action: #selector(checkAnswer(_:)), for: .touchUpInside)
            answersView.addArrangedSubview(button)
        }

        questionField.text = question.text
        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        answersView.removeAllArrangedSubviews()
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(trivia.correctQuestions.count) out of \(trivia.questions.count) correct!"
        
    }
    
    @objc func checkAnswer(_ sender: AnswerButton) -> Void{

        if let buttons = answersView.arrangedSubviews as? [AnswerButton], let question = trivia.currentQuestion{
            for button in buttons{
                button.displayForAnswerCorectness(button.answer.isCorrect(for: question))
            }
        }

        do{
            let result = try trivia.answerCurrentQuestion(sender.answer)

            switch result{
                case .correct:
                    questionField.text = "Correct!"
                case .incorrect:
                    questionField.text = "Sorry, wrong answer!"
            }
        }
        catch{
            // The only error that can be thrown is if the quiz is over
            displayScore()
        }

        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if trivia.isComplete{
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() -> Void{
        trivia = Quiz()
        nextRound()
    }
    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: DispatchTimeInterval) -> Void{
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.nextRound()
        }
    }

    func loadNextRoundWithDelay(seconds: Int) -> Void{
        loadNextRoundWithDelay(seconds: .seconds(seconds))
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
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
