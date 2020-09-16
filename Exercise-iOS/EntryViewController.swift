//
//  EntryViewController.swift
//  Exercise-iOS
//
//  Created by Viktor Glaes on 9/16/20.
//  Copyright © 2020 Viktor Glaes. All rights reserved.
//
import RealmSwift
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var commentField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    
    @IBOutlet var timeButtons: [UIButton]!
    
    private let realm = try! Realm()
    public var completionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.becomeFirstResponder()
        textField.delegate = self
        
        commentField.becomeFirstResponder()
        commentField.delegate = self
        
        datePicker.setDate(Date(), animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func didTapSaveButton() {
        if let text = textField.text, !text.isEmpty {
            let date = datePicker.date
            let comment = "\(commentField.text!)"
            
            realm.beginWrite()
            
            let newItem = ExerciseItem()
            newItem.comment = comment
            newItem.date = date
            newItem.title = text
            realm.add(newItem)
            try! realm.commitWrite()
            
            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
        } else {
            print("Add Title")
        }
    }
    
    
    @IBAction func timeSelection(_ sender: UIButton) {
        timeButtons.forEach{ (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum Times: String {
        case oneHour = "1 Hour"
        case twoHours = "2 Hours"
        case threeHours = "3 Hours"
    }
    
    @IBAction func didTapTime(_ sender: UIButton) {
        guard let title = sender.currentTitle, let time = Times(rawValue: title) else {
            return
        }
        var timeSelected = ""
        switch time {
        case .oneHour:
            timeSelected = "One Hour"
        case .twoHours:
            timeSelected = "Two Hours"
        default:
            timeSelected = "Three Hours"
        }
        print(timeSelected)
    }
}
