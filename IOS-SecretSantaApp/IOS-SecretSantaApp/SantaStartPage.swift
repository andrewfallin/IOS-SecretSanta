//
//  SantaStartPage.swift
//  IOS-SecretSantaApp
//
//  Created by Andrew Fallin on 4/25/19.
//  Copyright © 2019 Andrew Fallin. All rights reserved.
//

import UIKit
import CoreData
class SantaStartPage: UITableViewController {

    
    var exchanges: [Exchange] = []
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedObjectContext =
            appDelegate.persistentContainer.viewContext
        
        retrieveExchange()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exchanges.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exchangeCell", for: indexPath)

        let row = indexPath.row
        let exchange = exchanges[row]
        cell.textLabel?.text = exchange.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showExchange"){
            let viewExchangeVC = segue.destination as! ViewExchange
            let selectedRow = tableView.indexPathForSelectedRow?.row
            viewExchangeVC.exchange = exchanges[selectedRow!]
        }
       
    }
    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //send email to all people saying exchange was canceled
            removeExchange(exname: exchanges[indexPath.row].name!)
            exchanges.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func retrieveExchange()
    {
        var exchange: Exchange!
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ExchangeEntity")
        var retExchanges: [NSManagedObject]!
        do {
            retExchanges = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("Fetch error: \(error)")
        }
        print("Found \(retExchanges.count) Exchanges")
        for ex in retExchanges{
            exchange = Exchange()
            exchange.name = ex.value(forKey: "name") as? String
            exchange.exDate = ex.value(forKey: "date") as? Date
            exchange.priceCap = ex.value(forKey: "pricecap") as? String
            exchange.santas = retrieveSantaData(euid: ex.value(forKey: "uid") as! String)
            exchanges.append(exchange)
        }
    }
    
    func retrieveSantaData(euid: String) -> [Santa]
    {
        var santa: Santa!
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SantaEntity")
        var retSantas: [NSManagedObject]!
        var loadedSantas: [Santa] = []
        do {
            retSantas = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("Fetch error: \(error)")
        }
        print("Found \(retSantas.count) Santas")
        for p in retSantas{
            if ((p.value(forKey: "euid") as! String) == euid){
                santa = Santa()
                santa.name = p.value(forKey: "name") as? String
                santa.assignment = p.value(forKey: "assignment") as? String
                santa.email = p.value(forKey: "email") as? String
                loadedSantas.append(santa)
            }
        }
        return loadedSantas
    }
    
    func removeExchange(exname: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ExchangeEntity")
        let otherFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SantaEntity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", exname)
        var exchanges: [NSManagedObject]!
        var santas: [NSManagedObject]!
        do {
            exchanges = try self.managedObjectContext.fetch(fetchRequest)
            santas = try self.managedObjectContext.fetch(otherFetchRequest)
            print("Removed")
        } catch {
            print("Remove Exchange error: \(error)")
        }
        for ex in exchanges {
            for s in santas{
                self.managedObjectContext.delete(s)
            }
            self.managedObjectContext.delete(ex)
        }
        self.appDelegate.saveContext() // In AppDelegate.swift
    }
    
    @IBAction func unwindToStart(seque: UIStoryboardSegue){
        
    }

}
