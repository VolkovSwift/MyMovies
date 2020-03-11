//
//  UIViewController + ext.swift
//  MyMovies
//
//  Created by user on 3/11/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentMovieInfoVC(movie: Movie) {
        let destVC = MovieInfoVC(currentMovie: movie)
        
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}
