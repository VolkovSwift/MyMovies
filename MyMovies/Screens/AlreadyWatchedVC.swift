//
//  AlreadyWatchedVC.swift
//  MyMovies
//
//  Created by user on 2/10/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit
import CoreData

class AlreadyWatchedVC: UIViewController {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView = UITableView()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Movie> = {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let nameSort = NSSortDescriptor(key: #keyPath(Movie.name), ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        fetchRequest.predicate = NSPredicate(format: "wasWatched == %@", NSNumber(value: true))
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetch error \(error) \(error.userInfo)")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                        action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 40
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseID)
    }
    
    @objc func addButtonPressed() {
        alertForAddAndUpdateMovie()
    }
}


extension AlreadyWatchedVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseID) as! MovieCell
        let movie = fetchedResultsController.object(at: indexPath)
        cell.set(movie: movie)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = fetchedResultsController.object(at: indexPath)
        
        let destVC = MovieInfoVC()
        destVC.currentMovie = movie
        let navController = UINavigationController(rootViewController: destVC)
        
        present(navController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            let movieToDelete = self.fetchedResultsController.object(at: indexPath)
            self.context.delete(movieToDelete)
            self.appDelegate.saveContext()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            let movie = self.fetchedResultsController.object(at: indexPath)
            self.alertForAddAndUpdateMovie(movie) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
                print(movie)
            }
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

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
            textField.placeholder = "Enter Team Name"
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


extension AlreadyWatchedVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! MovieCell
            let movie = fetchedResultsController.object(at: indexPath!)
            cell.set(movie: movie)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            break
        }
    }
}
