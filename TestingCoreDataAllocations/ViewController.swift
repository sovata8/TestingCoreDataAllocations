//
//  ViewController.swift
//  TestingCoreDataAllocations
//
//  Created by sovata on 10/05/2017.
//  Copyright © 2017 Nikolay Suvandzhiev. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController
{
    private var managedObjectContext: NSManagedObjectContext!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    

    @IBAction func buttonPressed_createBook()
    {
        print(#function)
        
        let book = Book(context: self.managedObjectContext)
        book.title = "Hello \(Date().timeIntervalSinceReferenceDate)"
    }

    
    @IBAction func buttonPressed_listAllBooks()
    {
        print(#function)
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        let books = try! self.managedObjectContext.fetch(request)
        books.forEach{print("Book: \($0.title ?? "<no title>")")}
    }
}

