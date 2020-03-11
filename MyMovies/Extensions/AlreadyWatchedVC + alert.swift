//
//  AlreadyWatchedVC + alert.swift
//  MyMovies
//
//  Created by user on 3/11/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import Foundation
import UIKit

extension AlreadyWatchedVC {
    func alertForAddAndUpdateMovie(_ movie:Movie? = nil, completion:(() -> Void)? = nil) {
        
        var title = "New Movie"
        var doneButton = "Save"
        
        if movie != nil {
            title = "Edit Movie"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new name", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter Movie Name"
            textField.text = movie?.name ?? ""
        }
        let saveAction = UIAlertAction(title: doneButton, style: .default) {[weak self] action in
            guard let self = self else {return}
            
            guard let nameTextField = alert.textFields?.first else { return }
            
            if let movie = movie {
                movie.name = nameTextField.text

                self.appDelegate.saveContext()
            } else {
                let movie = Movie(entity: Movie.entity(), insertInto: self.context)
                movie.name = nameTextField.text
                movie.wasWatched = true
                movie.date = Date()
                self.appDelegate.saveContext()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: completion)
    }
}
