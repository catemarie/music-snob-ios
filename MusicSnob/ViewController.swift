//
//  ViewController.swift
//  MusicSnob
//
//  Created by Cate Miller on 4/10/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var goButton: UIButton!
    
    var test: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventTableViewController{
            vc.searchParams.genre = "Trance"
            vc.searchParams.zipcode = "92104"
        }
    }

}

