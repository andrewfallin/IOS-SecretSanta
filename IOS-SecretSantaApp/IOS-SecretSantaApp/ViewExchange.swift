//
//  ViewExchange.swift
//  IOS-SecretSantaApp
//
//  Created by Andrew Fallin on 4/28/19.
//  Copyright © 2019 Andrew Fallin. All rights reserved.
//

import UIKit

class ViewExchange: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    var exchange: Exchange?
    @IBOutlet weak var santasList: UITableView!
    @IBOutlet weak var priceCapLabel: UILabel!
    @IBOutlet weak var dateExchangeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            // Delete the row from the data source
           // let index = newSantasArr.lastIndex(of: newSantas[indexPath.row].name!)
           // newSantasArr.remove(at: index!)
           // newSantas.remove(at: indexPath.row)
            if ((exchange?.santas.count)! > 2){
                rearangeSantas(deletedSanta: (exchange?.santas[indexPath.row])!)
                exchange?.santas.remove(at: indexPath.row)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
