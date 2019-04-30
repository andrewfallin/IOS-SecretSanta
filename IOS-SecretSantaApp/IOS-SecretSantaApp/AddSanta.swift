//
//  AddSanta.swift
//  IOS-SecretSantaApp
//
//  Created by Andrew Fallin on 4/26/19.
//  Copyright © 2019 Andrew Fallin. All rights reserved.
//

import UIKit

class AddSanta: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var santaName: UITextField!
    @IBOutlet weak var santaEmail: UITextField!
    
    var santaInfoArray: [String] = []
    var newSanta: Santa?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.prompt = "Secret Santa"
        self.navigationItem.title = "Add Santa";
        santaName.delegate = self
        santaEmail.delegate = self
        
        let saveSantaBB = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        let cancelBB = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        
        navigationItem.rightBarButtonItem = saveSantaBB
        navigationItem.leftBarButtonItem = cancelBB

        // Do any additional setup after loading the view.
    }
    
    @objc func saveTapped(){
        
        newSanta = Santa()
        newSanta?.name = santaName.text!
        newSanta?.email = santaEmail.text!
        performSegue(withIdentifier: "saveNewSanta", sender: nil)

    }
    @objc func cancelTapped(){
        performSegue(withIdentifier: "cancelAddSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "saveNewSanta"){
            let newEPage = segue.destination as! NewExchangePage
            if (newSanta != nil){
                newEPage.newSantas.append(newSanta!)
                newEPage.newSantasArr.append((newSanta?.name)!)
                newEPage.santaList.reloadData()
            }
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
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
