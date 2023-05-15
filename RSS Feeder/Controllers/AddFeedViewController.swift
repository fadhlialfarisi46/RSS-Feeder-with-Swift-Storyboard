//
//  AddFeedViewController.swift
//  RSS Feeder
//
//  Created by muhammad.alfarisi on 14/05/23.
//

import UIKit

class AddFeedViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        let name = nameLabel.text!
        let address = addressLabel.text!
        
        if name.count < 4 {
            showAlert("Error", alert: "Please enter a name longer than 4 characters")
            return
        }
        if address.count < 6 {
            showAlert("Error", alert: "Please enter a name longer than 4 characters")
            return
        }
        
        do {
            let feed = try FeedDataHelper.insert(item: Feed(id: 0, name: name, address: address)!)
            print(feed)
            
            nameLabel.text = ""
            addressLabel.text = ""
            
            navigationController?.popViewController(animated: true)
        } catch let error {
            print(error)
        }
    }
    
    func showAlert(_ title: String, alert: String) {
        let alertController = UIAlertController(title: title, message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            print("OK Pressed")
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true)
    }
}
