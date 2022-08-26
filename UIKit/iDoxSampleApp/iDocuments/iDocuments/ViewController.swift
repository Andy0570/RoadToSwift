//
//  ViewController.swift
//  iDocuments
//
//  Created by Martina on 08/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cardView: UIView!
    @IBOutlet var idView: UIView!
    @IBOutlet var healthView: UIView!
    @IBOutlet var studentView: UIView!
    @IBOutlet var idRing: UIView!
    @IBOutlet var healthRing: UIView!
    @IBOutlet var studentRing: UIView!
    @IBOutlet var idButton: UIButton!
    @IBOutlet var healthButton: UIButton!
    @IBOutlet var studentButton: UIButton!
    @IBOutlet var numberCard: UILabel!
    @IBOutlet var expiryCard: UILabel!
    @IBOutlet var issuerCard: UILabel!
    @IBOutlet var copyToCB: UIButton!
    @IBOutlet var copiedTextNotif: UIView!
    
    
    lazy var cardViews = [idView,
                          healthView,
                          studentView]
    lazy var ringViews = [idRing,
                          healthRing,
                          studentRing]
    
    lazy var labels = [numberCard,
                       expiryCard,
                       issuerCard]
    
    
    var idCard = card(id: "1234567890",
                      expiry: "06/25",
                      issuer: "Town Hall")
    
    var healthCard = card(id: "369121518",
                          expiry: "01/27",
                          issuer: "Doctor")
    
    var studentCard = card(id: "235711131719",
                           expiry: "2/03/2029",
                           issuer: "University")
    
    struct card {
        
        var pic = UIImage()
        var title = String()
        var id = String()
        var expiry = String()
        var issuer = String()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        copiedTextNotif.alpha = 0
        
        cardView.layer.cornerRadius = 25
        
        cornerRadius(views: cardViews)
        cornerRadius(views: ringViews)
        
        copyToCB.layer.cornerRadius = copyToCB.frame.height / 2
        
    }
    
    
    func switchCard(selected: UIButton) {
        
        for label in labels {
            if let label = label {
                self.labelDisappears(label: label)
            }
        }
        
        switch selected {
            
        case idButton:
            numberCard.text = idCard.id
            expiryCard.text = idCard.expiry
            issuerCard.text = idCard.issuer
        case healthButton:
            numberCard.text = healthCard.id
            expiryCard.text = healthCard.expiry
            issuerCard.text = healthCard.issuer
        case studentButton:
            numberCard.text = studentCard.id
            expiryCard.text = studentCard.expiry
            issuerCard.text = studentCard.issuer
            
        default: return
            
        }
        
    }
    
    
    
    func cornerRadius(views: [UIView?]) {
        
        for view in views {
            if let view = view {
                
                view.layer.cornerRadius = view.frame.width / 2
                
            }
        }
    }

    
    func labelAppears(label: UILabel) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.5) {
            
            label.alpha = 1
            
        }
        
    }
    
    func labelDisappears(label: UILabel) {
        
        UIView.animate(withDuration: 0.5,
                           delay: 0.5) {
            
            label.alpha = 0
            self.labelAppears(label: label)
            
        }
        
    }
    
    
    func buttonTapped(button: UIButton) {
        
        for view in cardViews {
            
            if let view = view {
                
                view.layer.borderWidth = 0
                
            }
            
        }
        
        switch button {
            
        case idButton:
            idView.layer.borderWidth = 5
            idView.layer.borderColor = UIColor.purple.cgColor
            switchCard(selected: idButton)
            
        case healthButton:
            healthView.layer.borderWidth = 5
            healthView.layer.borderColor = UIColor.purple.cgColor
            switchCard(selected: healthButton)
            
        case studentButton:
            studentView.layer.borderWidth = 5
            studentView.layer.borderColor = UIColor.purple.cgColor
            switchCard(selected: studentButton)
            
        default: return
            
        }
        
    }
    
    
    func copiedTextAlert() {
        
        copiedTextNotif.alpha = 1
        UIView.animate(withDuration: 5, delay: 0) {
            
            self.copiedTextNotif.alpha = 0
            
        }
    }
    
    
    @IBAction func idButtonTapped(_ sender: Any) {
        
        buttonTapped(button: idButton)
        
    }
    
    @IBAction func healthButtonTapped(_ sender: Any) {
        
        buttonTapped(button: healthButton)
        
    }
    
    @IBAction func studentButtonTapped(_ sender: Any) {
        
        buttonTapped(button: studentButton)
        
    }
    
    
    @IBAction func copyToCBAction(_ sender: Any) {
        
        UIPasteboard.general.string = numberCard.text
        copiedTextAlert()
        
    }
    

}



