//
//  ViewController.swift
//  MusicSnob
//
//  Created by Cate Miller on 4/10/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var genrePicker: UIPickerView!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    var genreData: [String] = [String]()
    var genreSelection = 0
    var zipcodeSelection = "92104"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.genrePicker.delegate = self
        self.genrePicker.dataSource = self
        
        self.zipcodeField.delegate = self

        genreData = ["House", "Trance"]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genreData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genreData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Current genre selection changed to: " + genreData[row])
        genreSelection = row
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        zipcodeField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Current zip code changed to: " + zipcodeField.text!)
        zipcodeSelection = zipcodeField.text!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventTableViewController{
            vc.searchParams.genre = genreData[genreSelection]
            vc.searchParams.zipcode = zipcodeSelection
        }
    }

}

