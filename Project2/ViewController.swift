//
//  ViewController.swift
//  Project2
//
//  Created by Robert Silverman on 6/2/20.
//  Copyright © 2020 Robert Silverman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var highScore = 0
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
        
        loadHighScore()
        
        title = "Country: \(correctCountry) --- Score: \(score)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        requestAndScheduleNotifications()
        
        askQuestion()
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
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 20, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 20, options: [], animations: {
            sender.transform = .identity
        })
        
        if sender.tag == correctAnswer {
            alertTitle = "Correct"
            score += 1
            checkUpdateHighScore()
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
    
    func checkUpdateHighScore() {
        if score > highScore {
            highScore = score
            saveHighScore()
        }
        print("High Score: \(highScore)")
    }
    
    func saveHighScore() {
        let jEncoder = JSONEncoder()
        if let savedData = try? jEncoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "high-score")
        } else {
            print("Unable to save highScore")
        }
    }
    
    func loadHighScore() {
        let defaults = UserDefaults.standard
        if let savedScore = defaults.object(forKey: "high-score") as? Data {
            let jDecoder = JSONDecoder()
            
            do {
                highScore = try jDecoder.decode(Int.self, from: savedScore)
            } catch {
                print("Could not load highScore data")
            }
        }
    }
    
    func requestAndScheduleNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) {
            (completion, error) in
            if completion {
                print("Authorized")
            } else {
                print("Not Authorized")
            }
        }
        
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.delegate = self
        
        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 15
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Time to learn!"
        content.body = "Just 10 minutes a day will make you better at, uh, flags!"
        content.categoryIdentifier = "reminder"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
}

