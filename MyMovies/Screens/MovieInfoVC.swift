//
//  MovieInfoVC.swift
//  MyMovies
//
//  Created by user on 2/12/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

class MovieInfoVC: UIViewController {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var rateDescriptionLabel = MMTitleLabel(textAlignment: .left, fontSize: 20)
    var currentRatingLabel = MMTitleLabel(textAlignment: .left, fontSize: 20)
    var dateLabel = MMBodyLabel(textAlignment: .center)
    var rateActionButton = MMButton(backgroundColor: .systemGray, title: "Rate")
    
    var currentMovie: Movie!
    
    let checkmarkImage = UIImage(systemName: "checkmark.seal.fill")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUIElements()
        layoutUI()
        configureRateActionButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = currentMovie.name
        //navigationController?.navigationBar.prefersLargeTitles = true
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    func configureUIElements() {
        rateDescriptionLabel.text = "You rated this film as:"
        currentRatingLabel.text = "7/10"
        
        dateLabel.text = "Watched at \(currentMovie.date!.convertToMonthYearFormat())"
    }
    
    func configureRateActionButton() {
        
        rateActionButton.addTarget(self, action: #selector(rate), for: .touchUpInside)
        
        view.addSubview(rateActionButton)
        
        NSLayoutConstraint.activate([
            rateActionButton.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -30),
            rateActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rateActionButton.widthAnchor.constraint(equalTo: dateLabel.widthAnchor),
            rateActionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }
    
    @objc func rate() {
        let alert = UIAlertController(title: "New rating", message: "Please rate this film", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            if let textField = alert.textFields?.first {
                self.update(rating: textField.text)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true)
    }
    
    func update(rating: String?) {
        guard let ratingString = rating,
            let rating = Double(ratingString) else {
                return
        }
        do {
            currentMovie.rating = rating
            try context.save()
            
            currentRatingLabel.text = "\(currentMovie.rating)/10"
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func layoutUI() {
        view.addSubview(rateDescriptionLabel)
        view.addSubview(currentRatingLabel)
        view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            rateDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rateDescriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            rateDescriptionLabel.widthAnchor.constraint(equalToConstant: 200),
            rateDescriptionLabel.heightAnchor.constraint(equalToConstant: 50),
            
            currentRatingLabel.centerYAnchor.constraint(equalTo: rateDescriptionLabel.centerYAnchor),
            currentRatingLabel.leadingAnchor.constraint(equalTo: rateDescriptionLabel.trailingAnchor, constant: 30),
            currentRatingLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            currentRatingLabel.heightAnchor.constraint(equalToConstant: 50),
            
            dateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 200),
            dateLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
    @objc func dismissVC() {
        dismiss(animated:true)
    }
}
