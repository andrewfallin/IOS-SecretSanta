//
//  NewExchangePage.swift
//  IOS-SecretSantaApp
//
//  Created by Andrew Fallin on 4/26/19.
//  Copyright © 2019 Andrew Fallin. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class NewExchangePage: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    
    var newSantas: [Santa] = []
    var newSantasArr: [String] = []
    var newExchange: Exchange?
    var selectedPriceCap: String? = "$5.00"
    
    var priceCapData: [String] = [String]()
   
    
    @IBOutlet weak var exName: UITextField!
    @IBOutlet weak var santaList: UITableView!
    @IBOutlet weak var priceCap: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var exchangeID: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        
        exName.delegate = self
        // Do any additional setup after loading the view.
        self.navigationItem.prompt = "Secret Santa"
        self.navigationItem.title = "New Exchange";
        
        let startExchangeBB = UIBarButtonItem(title: "Start!", style: .plain, target: self, action: #selector(saveTapped))
       // startExchangeBB.title = "Start!"
        
        self.navigationItem.rightBarButtonItem = startExchangeBB
        
        santaList.delegate = self
        santaList.dataSource = self
        
        self.priceCap.delegate = self
        self.priceCap.dataSource = self
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        priceCapData = ["$5.00", "$10.00", "$15.00", "$20.00", "$25.00", "$30.00", "$35.00", "$40.00", "$45.00", "$50.00", "$55.00", "$60.00", "$65.00", "$70.00", "$75.00", "$80.00", "$85.00", "$90.00", "$95.00", "$100.00", "No Cap...GO CRAZY!"]
        
        exchangeID = idGenerator()

    }
    
    /* Sets all Contents and Formation for the Price Cap Picker*/
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPriceCap = priceCapData[row]
    }
    /* ------- End of Price Cap Datat Picker ------ */
    
    
    /* ---------- Controlls Santa List Table -----------*/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(newSantas.count)
        return newSantas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let row = indexPath.row
        let santas = newSantas[row]
        cell.textLabel?.text = santas.name
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let index = newSantasArr.lastIndex(of: newSantas[indexPath.row].name!)
            newSantasArr.remove(at: index!)
            newSantas.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    /* ------- End of santa list table -------- */
    
    @objc func saveTapped(){
        assignSantas()
        newExchange = Exchange()
        newExchange?.name = exName.text
        newExchange?.santas = newSantas
        newExchange?.exDate = datePicker.date
        newExchange?.priceCap = selectedPriceCap
        sendEmail()
        saveSantas()
        
        let exchangeTBS = NSEntityDescription.insertNewObject(forEntityName: "ExchangeEntity", into: managedObjectContext)
        exchangeTBS.setValue(newExchange!.name, forKey: "name")
        exchangeTBS.setValue(newExchange!.exDate, forKey: "date")
        exchangeTBS.setValue(newExchange!.priceCap, forKey: "pricecap")
        exchangeTBS.setValue(exchangeID, forKey: "uid")
        do {
            try managedObjectContext.save()
            print("Success")
        } catch {
            print("Error saving: \(error)")
        }
        performSegue(withIdentifier: "initializeExchange", sender: nil)
        
    }
    
    func saveSantas(){
        for santa in newSantas {
            let newuid = idGenerator()
             let santaTBS = NSEntityDescription.insertNewObject(forEntityName: "SantaEntity", into: managedObjectContext)
            santaTBS.setValue(santa.name, forKey: "name")
            santaTBS.setValue(santa.assignment, forKey: "assignment")
            santaTBS.setValue(santa.email, forKey: "email")
            santaTBS.setValue(newuid, forKey: "uid")
            santaTBS.setValue(exchangeID, forKey: "euid")
            santa.uid = newuid
        }
        do {
            try managedObjectContext.save()
            print("Success")
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func idGenerator() -> String{
        return String(Int.random(in: 0..<100))
    }
    
    func assignSantas(){
        var assignees = newSantasArr
        
        
        assignees.shuffle()
       
        for person in newSantas{
            for person2 in assignees{
                if (person.name != person2){
                    person.assignment = person2
                    let index = assignees.lastIndex(of: person2)
                    assignees.remove(at: index!)
                    break;
                    
                } else if (assignees.count == 1){
                    let flip = newSantas[0].assignment
                    newSantas[0].assignment = person2
                    person.assignment = flip

                }
                
            }

        }
        
        
        
    }
    
     /*override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
     }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "initializeExchange"){
            let newEx = segue.destination as! SantaStartPage
            if (newExchange != nil){
                newEx.exchanges.append(newExchange!)
                // newEPage.newSantasArr.append((newSanta?.name)!)
                newEx.tableView.reloadData()
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    
    func sendEmail() {
        //ios can't send email's directly from the app, So I chose to use mailgun as my api service
       

        for santa in newSantas{
            let session = URLSession.shared
            let request: NSMutableURLRequest = URLRequest(url: URL(string: "https://api.mailgun.net/v3/sandboxb5e82ee7d5d5467a8851b263bb30b38b.mailgun.org/messages")!) as! NSMutableURLRequest
            request.httpMethod = "POST"
            
            let loginstring = NSString(format: "%@:%@", "api","7b3c01267d0c5dd5a475a67091fb9d79-7bce17e5-13aebe04")
            let loginData: NSData = loginstring.data(using: String.Encoding.utf8.rawValue)! as NSData
            let base64LoginString = loginData.base64EncodedString(options: [])
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let emaildata = "from=Secret Santa App!<mailgun@sandboxb5e82ee7d5d5467a8851b263bb30b38b.mailgun.org>&to=<" + santa.email! + ">&subject= Secret Santa Rules and Assignment!&text= Dear " + santa.name! + ",\n\nWelcome to the " + exName.text! + " exchange! Here are the general rules:\n       - You cannot spend more than the Price Cap\n       - Get a gift for your assigned person\n       - Don't be an animal, wrap your gift\n       - Have fun!\n\nPrice Cap: "+selectedPriceCap!+"\nDate of Exchange: " + formatDate(date: newExchange!.exDate!) + "\nAssignment: " + santa.assignment! + "\n\nMerry Christmas!"
           // request.setValue("key-7b3c01267d0c5dd5a475a67091fb9d79-7bce17e5-13aebe04", forHTTPHeaderField: "api")
            request.httpBody = emaildata.data(using: String.Encoding.utf8)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(emaildata, response, error) -> Void in
                
                if let error = error {
                print(error)
                }
                if let response = response {
                    
                    print("url = \(response.url!)")
                    print("response = \(response)")
                    let httpResponse = response as! HTTPURLResponse
                    print("response code = \(httpResponse.statusCode)")
                }
                
                })
        
            task.resume()
            
            
        }
    }
    
    
    
    func formatDate(date: Date) -> String{
        //changes format of the date and converts it to a string
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!) //date string
        
        return myStringafd
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindToPageOneCancel( segue: UIStoryboardSegue){
        
    }
    @IBAction func unwindToPageOneAlternateSave(seque: UIStoryboardSegue){
        
    }
    
   
}
