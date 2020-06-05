//
//  ViewController.swift
//  Project2
//
//  Created by Robert Silverman on 6/2/20.
//  Copyright © 2020 Robert Silverman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var correctCountry = "Loading"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        title = "Country: \(correctCountry) --- Score: \(score)"
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctCountry = countries[correctAnswer].uppercased()
        
        updateTitle(country: correctCountry, score: score)
        
    }
    
    func updateTitle(country: String, score: Int){
        title = "Country: \(country) --- Score: \(score)"
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["Score: \(score)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var alertTitle: String
        var alertMessage: String
        
        if sender.tag == correctAnswer {
            alertTitle = "Correct"
            score += 1
            alertMessage = "Your score is \(score)."
        } else {
            alertTitle = "Incorrect"
            score -= 1
            alertMessage = "Correct answer: \(correctCountry). Your score is \(score)."
        }
        
        let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
}

