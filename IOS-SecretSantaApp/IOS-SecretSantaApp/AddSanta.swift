//
//  AddSanta.swift
//  IOS-SecretSantaApp
//
//  Created by Andrew Fallin on 4/26/19.
//  Copyright © 2019 Andrew Fallin. All rights reserved.
//

import UIKit

class AddSanta: UIViewController {

    @IBOutlet weak var santaName: UITextField!
    @IBOutlet weak var santaEmail: UITextField!
    
    var santaInfoArray: [String] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.prompt = "Secret Santa"
        self.navigationItem.title = "Add Santa";
        
        let saveSantaBB = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        let cancelBB = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        
        navigationItem.rightBarButtonItem = saveSantaBB
        navigationItem.leftBarButtonItem = cancelBB

        // Do any additional setup after loading the view.
    }
    
    @objc func saveTapped(){
        
        santaInfoArray.append(santaName.text!)
        santaInfoArray.append(santaEmail.text!)
        performSegue(withIdentifier: "saveNewSanta", sender: nil)
    
    }
    @objc func cancelTapped(){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "saveNewSanta"){
            let newEPage = segue.destination as! NewExchangePage
            if (santaInfoArray.isEmpty != true){
                newEPage.newSantas[santaInfoArray[0]] = santaInfoArray[1]
               // newEPage.tableView.reloadData()
            }
            
        }
        
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
