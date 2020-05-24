//
//  ToSeeVC.swift
//  MyMovies
//
//  Created by user on 2/10/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit
import CoreData

final class ToSeeVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView = UITableView()
    private let rowHeight: CGFloat = 50
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Movie> = {
        let fetchRequest:NSFetchRequest<Movie> = Movie.fetchRequest()
        let dateSort = NSSortDescriptor(key: #keyPath(Movie.date), ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        fetchRequest.predicate = NSPredicate(format: "wasWatched == %@", NSNumber(value: false))
        
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
            print("Fetch error \(error), \(error.userInfo)")
        }
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                        action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = rowHeight
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseID)
    }
    
    
    @objc func addButtonPressed() {
        alertForAddAndUpdateMovie()
    }
}


extension ToSeeVC: UITableViewDataSource, UITableViewDelegate {
    
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
        presentMovieInfoVC(movie: movie)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            let movieToDelete = self.fetchedResultsController.object(at: indexPath)
            self.context.delete(movieToDelete)
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Can't save \(error), \(error.userInfo)")
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            let movie = self.fetchedResultsController.object(at: indexPath)
            self.alertForAddAndUpdateMovie(movie) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Watched") { (action, view, handler) in
            let movie = self.fetchedResultsController.object(at: indexPath)
            movie.date = Date()
            movie.wasWatched = true
            
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Can't save \(error), \(error.userInfo)")
            }
            
            let alert = UIAlertController(title: "Do you want to rate this film?", message: "Tap Yes", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "YES! Thanks.", style: .default) { [unowned self] action in
                self.presentMovieInfoVC(movie: movie)
            }
            let noAction = UIAlertAction(title: "NO. Maybe later.", style: .destructive)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true)
        }
        
        doneAction.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, doneAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}


extension ToSeeVC: NSFetchedResultsControllerDelegate {
    
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
}
