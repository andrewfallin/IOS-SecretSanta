//
//  ViewExchange.swift
//  IOS-SecretSantaApp
//
//  Created by Andrew Fallin on 4/28/19.
//  Copyright © 2019 Andrew Fallin. All rights reserved.
//

import UIKit
import CoreData

class ViewExchange: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    var exchange: Exchange?
    @IBOutlet weak var santasList: UITableView!
    @IBOutlet weak var priceCapLabel: UILabel!
    @IBOutlet weak var dateExchangeLabel: UILabel!
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedObjectContext =
            appDelegate.persistentContainer.viewContext
        
        self.navigationItem.prompt = "Secret Santa"
        self.navigationItem.title = exchange?.name;
        
        //changes format of the date and converts it to a string
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: exchange!.exDate!) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!) //date string
        
        priceCapLabel.text = ("Price Cap: " + exchange!.priceCap!)
        dateExchangeLabel.text = ("Exchange Date: " + myStringafd)

        // Do any additional setup after loading the view.
    }
    
    /* ----------- Table View Controls --------------*/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let santas = exchange?.santas
        return santas!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "santaCell", for: indexPath)
        let row = indexPath.row
        let san = exchange?.santas[row]
        cell.textLabel?.text = san!.name
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if ((exchange?.santas.count)! > 2){
                rearangeSantas(deletedSanta: (exchange?.santas[indexPath.row])!)
                removeSanta(uid: (exchange?.santas[indexPath.row].uid)!)
                
                exchange?.santas.remove(at: indexPath.row)
                updateSantas()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }else {
                let alert = UIAlertController(title: "OH NO!", message: "There will not be enough Santas to complete the exchange! If you wish to delete the exchange navigate to the exchange page.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    /* ----------- end of table --------------*/

    
    func rearangeSantas(deletedSanta: Santa){
        
        let santas = exchange?.santas
        for santa in santas!{
            if(santa.assignment == deletedSanta.name){
                santa.assignment = deletedSanta.assignment
            }
        }
        

        //send email
    }
    
    func updateSantas(){
    
        for santa in exchange!.santas {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SantaEntity")
            fetchRequest.predicate = NSPredicate(format: "uid = %@", santa.uid!)
           /* var upSanta: [NSManagedObject]!
            do {
                upSanta = try self.managedObjectContext.fetch(fetchRequest)
            } catch {
                print("Gather error: \(error)")
            }
            for a in upSanta{
                a.setValue(santa.assignment, forKey: "assignment")
                print(fetchRequest.predicate!.value(forKey: "assignment")!)
                print(santa.assignment!)
            }*/
            do {
                let test = try managedObjectContext.fetch(fetchRequest)
                let objectupdate = test[0]
                objectupdate.setValue(santa.assignment, forKey: "assignment")
                print(santa.name! + " : " + (objectupdate.value(forKey: "assignment") as! String))
                do {
                    try managedObjectContext.save()
                    print("Success")
                } catch {
                    print("Error saving: \(error)")
                }
            } catch {
                print("Problems")
            }
            
        }
        
    }
    
    func removeSanta(uid: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SantaEntity")
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        var santas: [NSManagedObject]!
        do {
            santas = try self.managedObjectContext.fetch(fetchRequest)
            print("Removed")
        } catch {
            print("Remove Exchange error: \(error)")
        }
        for s in santas {
            
            self.managedObjectContext.delete(s)
        }
        self.appDelegate.saveContext() // In AppDelegate.swift
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
