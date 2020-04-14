//
//  MovieCell.swift
//  MyMovies
//
//  Created by user on 2/11/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

final class MovieCell: UITableViewCell {

    static let reuseID = "Movie"
    let movieNameLabel = MMTitleLabel(textAlignment: .left, fontSize: 20)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(movie:Movie) {
        movieNameLabel.text = movie.name
    }
    
    
    private func configure() {
        addSubview(movieNameLabel)
        
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            movieNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            movieNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            movieNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            movieNameLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
