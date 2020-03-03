//
//  MovieInfoVC.swift
//  MyMovies
//
//  Created by user on 2/12/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

class MovieInfoVC: UIViewController {

    var nameLabel = MMTitleLabel(textAlignment: .center, fontSize: 20)
    
    var movieName:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        configureUIElements()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = movieName
        navigationController?.navigationBar.prefersLargeTitles = true
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    func configureUIElements() {
        nameLabel.text = movieName
    }
    
    
    func layoutUI() {
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
    @objc func dismissVC() {
        dismiss(animated:true)
    }
}
