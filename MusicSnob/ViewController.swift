//
//  ViewController.swift
//  MusicSnob
//
//  Created by Cate Miller on 4/10/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var genrePicker: UIPickerView!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    var genreData: [String] = [String]()
    var genreSelection = 0
    var citySelection = ""
    var stateSelection = ""
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 5
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("Current zip code changed to: " + zipcodeField.text!)
        getCityStateFromZip(zipcode: zipcodeField.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventTableViewController{
            vc.genre = genreData[genreSelection]
            vc.city = citySelection
            vc.state = stateSelection
        }
    }
    
    func getCityStateFromZip(zipcode: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(zipcode) { [self]
            (placemarks, error) -> Void in
            if let placemark = placemarks?[0] {
                print(placemark.administrativeArea!)
                print(placemark.subAdministrativeArea!)
                saveValidLocation(city: placemark.subAdministrativeArea!, state: placemark.administrativeArea!)
            }

        }
    }
    
    func saveValidLocation(city: String, state: String) {
        citySelection = city
        stateSelection = state
    }
}

