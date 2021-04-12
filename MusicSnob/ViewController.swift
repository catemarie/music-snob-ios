//
//  ViewController.swift
//  MusicSnob
//
//  Created by Cate Miller on 4/10/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var genrePicker: UIPickerView!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    var genreData: [String] = [String]()
    var genreSelection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.genrePicker.delegate = self
        self.genrePicker.dataSource = self

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventTableViewController{
            vc.searchParams.genre = genreData[genreSelection]
            vc.searchParams.zipcode = "92104"
        }
    }

}

