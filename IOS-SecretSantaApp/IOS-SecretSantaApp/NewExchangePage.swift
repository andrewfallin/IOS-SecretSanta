//
//  NewExchangePage.swift
//  IOS-SecretSantaApp
//
//  Created by Andrew Fallin on 4/26/19.
//  Copyright © 2019 Andrew Fallin. All rights reserved.
//

import UIKit

class NewExchangePage: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    var newSantas: [String: String] = ["Andrew":"Andrew.fallin@gmail.com"]
    var priceCapData: [String] = [String]()
   
    @IBOutlet weak var exName: UITextField!
    @IBOutlet weak var santaList: UITableView!
    @IBOutlet weak var priceCap: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.prompt = "Secret Santa"
        self.navigationItem.title = "New Exchange";
        
        santaList.delegate = self
        santaList.dataSource = self
        
        self.priceCap.delegate = self
        self.priceCap.dataSource = self
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        priceCapData = ["$5.00", "$10.00", "$15.00", "$20.00", "$25.00", "$30.00", "$35.00", "$40.00", "$45.00", "$50.00", "$55.00", "$60.00", "$65.00", "$70.00", "$75.00", "$80.00", "$85.00", "$90.00", "$95.00", "$100.00", "No Cap...GO CRAZY!"]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priceCapData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priceCapData[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titledata = priceCapData[row]
        let mytitle = NSAttributedString(string: titledata, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return mytitle
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(newSantas.count)
        return newSantas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! SantaCell
       /* let row = indexPath.row
        let santas = Array(newSantas.keys)[row];
        print(santas)
        cell.promptLabel.text = santas*/
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //quiz.remove(at:  indexPath.row)
           // tableView.deleteRows(at: [indexPath], with: .fade)
            //numquestions -= 1;
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /* override func performSegue(withIdentifier identifier: String, sender: Any?) {
     
     }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
