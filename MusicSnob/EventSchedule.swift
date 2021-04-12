//
//  EventSchedule.swift
//  MusicSnob
//
//  Created by Cate Miller on 4/11/21.
//

import Foundation

class EventSchedule {
    
    var statesDictionary = ["NM": "New Mexico", "SD": "South Dakota", "TN": "Tennessee", "VT": "Vermont", "WY": "Wyoming", "OR": "Oregon", "MI": "Michigan", "MS": "Mississippi", "WA": "Washington", "ID": "Idaho", "ND": "North Dakota", "GA": "Georgia", "UT": "Utah", "OH": "Ohio", "DE": "Delaware", "NC": "North Carolina", "NJ": "New Jersey", "IN": "Indiana", "IL": "Illinois", "HI": "Hawaii", "NH": "New Hampshire", "MO": "Missouri", "MD": "Maryland", "WV": "West Virginia", "MA": "Massachusetts", "IA": "Iowa", "KY": "Kentucky", "NE": "Nebraska", "SC": "South Carolina", "AZ": "Arizona", "KS": "Kansas", "NV": "Nevada", "WI": "Wisconsin", "RI": "Rhode Island", "FL": "Florida", "TX": "Texas", "AL": "Alabama", "CO": "Colorado", "AK": "Alaska", "VA": "Virginia", "AR": "Arkansas", "CA": "California", "LA": "Louisiana", "CT": "Connecticut", "NY": "New York", "MN": "Minnesota", "MT": "Montana", "OK": "Oklahoma", "PA": "Pennsylvania", "ME": "Maine"]
    
    var eventList = [String]()
    var KEY = ""
    
    init() {
        eventList += ["Andrew Rayel", "Infected Mushroom", "Gareth Emery"]
        var dictRoot: NSDictionary?
        if let path = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") {
            dictRoot = NSDictionary(contentsOfFile: path)
        }

        if dictRoot != nil
        {
            KEY = dictRoot?["EDMTRAIN_KEY"] as! String
        }
        else {
            print("Did not find an EDM Train client API key")
        }
    }
    
    func getStateName(abv: String) -> String {
        return statesDictionary[abv]!
    }
    
    func setSearchParams(genre: String, city: String, state: String) {
        let stateTemp = getStateName(abv: state)
        let cityTemp = city.replacingOccurrences(of: " ", with: "%20")
        print("User selected genre: " + genre)
        print("User selected location: " + cityTemp + ", " + stateTemp)
    }
    
}
