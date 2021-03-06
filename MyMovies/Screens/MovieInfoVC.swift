//
//  MovieInfoVC.swift
//  MyMovies
//
//  Created by user on 2/12/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit
import CoreData

class MovieInfoVC: UIViewController {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var rateDescriptionLabel = MMTitleLabel(textAlignment: .left, fontSize: 20)
    private var currentRatingLabel = MMTitleLabel(textAlignment: .left, fontSize: 20)
    private var dateLabel = MMBodyLabel(textAlignment: .center)
    private var rateActionButton = MMButton(backgroundColor: .systemGray, title: "Rate")
    
    private var currentMovie: Movie!
    
    
    init(currentMovie: Movie) {
        super.init(nibName: nil, bundle: nil)
        self.currentMovie = currentMovie
        title = currentMovie.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUIElements(movie: currentMovie)
        layoutUI()
        configureRateActionButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = currentMovie.name
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    @objc func dismissVC() {
        dismiss(animated:true)
    }
    
    
    private func configureUIElements(movie: Movie) {
        rateDescriptionLabel.text = "You rated this film as:"
        currentRatingLabel.text = "\(movie.rating)/10"
        dateLabel.text = "Watched at \(currentMovie.date!.convertToMonthYearFormat())"
    }
    
    private func configureRateActionButton() {
        
        rateActionButton.addTarget(self, action: #selector(rate), for: .touchUpInside)
        view.addSubview(rateActionButton)
        
        NSLayoutConstraint.activate([
            rateActionButton.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -30),
            rateActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rateActionButton.widthAnchor.constraint(equalTo: dateLabel.widthAnchor),
            rateActionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    
    @objc private func rate() {
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
   
    
    private func update(rating: String?) {
        guard let ratingString = rating,
            let rating = Double(ratingString) else {
                return
        }
        do {
            currentMovie.rating = rating
            try context.save()
            configureUIElements(movie: currentMovie)
        } catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && (error.code == NSValidationNumberTooLargeError || error.code == NSValidationNumberTooSmallError) {
                rate()
            } else {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    
    private func layoutUI() {
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
            currentRatingLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            currentRatingLabel.heightAnchor.constraint(equalToConstant: 50),
            
            dateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 200),
            dateLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

