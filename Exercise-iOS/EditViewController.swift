//
//  EditViewController.swift
//  Exercise-iOS
//
//  Created by Viktor Glaes on 9/16/20.
//  Copyright © 2020 Viktor Glaes. All rights reserved.
//
import RealmSwift
import UIKit

class EditViewController: UIViewController {
    
    
    public var item: ExerciseItem?
    public var deletionHandler: (() -> Void)?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var commentLabel: UITextView!
    
    private let realm = try! Realm()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = item?.title
        commentLabel.text = item?.comment
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
    }
    
    @objc private func didTapDelete() {
        guard let curItem = self.item else {
            return
        }
        
        realm.beginWrite()
        
        realm.delete(curItem)
        
        try! realm.commitWrite()
        deletionHandler?()
        
        navigationController?.popToRootViewController(animated: true)
    }
}
