//
//  EventSchedule.swift
//  MusicSnob
//
//  Created by Cate Miller on 4/11/21.
//

import Foundation

class EventSchedule {
    
    typealias CompletionHandler = () -> Void
    
    struct EventEntry {
        var date: String
        var artist: String
        var venue: String
    }
    
    struct City: Codable {
        var id: Int
    }

    struct Locations: Codable {
        var data: Array<City>
    }

    struct Artist: Codable {
        var id: Int
        var name: String
    }

    struct Venue: Codable {
        var id: Int
        var name: String
    }

    struct Event: Codable {
        var id: Int
        var festivalInd: Bool
        var livestreamInd: Bool
        var date: String
        var venue: Venue
        var artistList: Array<Artist>
    }
    struct Events: Codable {
        var data: Array<Event>
    }
    
    var locationId = 0
    var genreSelection = ""

    var statesDictionary = ["NM": "New Mexico", "SD": "South Dakota", "TN": "Tennessee", "VT": "Vermont", "WY": "Wyoming", "OR": "Oregon", "MI": "Michigan", "MS": "Mississippi", "WA": "Washington", "ID": "Idaho", "ND": "North Dakota", "GA": "Georgia", "UT": "Utah", "OH": "Ohio", "DE": "Delaware", "NC": "North Carolina", "NJ": "New Jersey", "IN": "Indiana", "IL": "Illinois", "HI": "Hawaii", "NH": "New Hampshire", "MO": "Missouri", "MD": "Maryland", "WV": "West Virginia", "MA": "Massachusetts", "IA": "Iowa", "KY": "Kentucky", "NE": "Nebraska", "SC": "South Carolina", "AZ": "Arizona", "KS": "Kansas", "NV": "Nevada", "WI": "Wisconsin", "RI": "Rhode Island", "FL": "Florida", "TX": "Texas", "AL": "Alabama", "CO": "Colorado", "AK": "Alaska", "VA": "Virginia", "AR": "Arkansas", "CA": "California", "LA": "Louisiana", "CT": "Connecticut", "NY": "New York", "MN": "Minnesota", "MT": "Montana", "OK": "Oklahoma", "PA": "Pennsylvania", "ME": "Maine"]
    
    var eventList = [EventEntry]()
    var KEY = ""
    
    var updateHandler: CompletionHandler
    
    init() {
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
        updateHandler = {}
    }
    
    func setUpdateHandler(handler: @escaping CompletionHandler) {
        updateHandler = handler
    }
    
    func getStateName(abv: String) -> String {
        return statesDictionary[abv]!
    }
    
    func setSearchParams(genre: String, city: String, state: String) {
        let stateTemp = getStateName(abv: state).replacingOccurrences(of: " ", with: "%20")
        let cityTemp = city.replacingOccurrences(of: " ", with: "%20")
        print("User selected genre: " + genre)
        print("User selected location: " + cityTemp + ", " + stateTemp)
        setGenereSelection(genre: genre)
        setLocation(city: cityTemp, state: stateTemp)
    }

    func filterEvents(entry: EventEntry) {
        let artist = entry.artist.replacingOccurrences(of: " ", with: "%20")
        print(artist)
        
        let url = URL(string: "http://127.0.0.1:5000/api/genres/lookup?name=" + String(artist))
        if url != nil {
            let task = URLSession.shared.dataTask(with: url!) { [self](data, response, error) in
                guard let data = data else { return }
                print(String(data: data, encoding: .utf8)!)
                
                let genres: Array<String> = try! JSONDecoder().decode(Array<String>.self, from: data)
                print(genreSelection)
                if genreSelection == "" {
                    self.eventList.append(entry)
                }
                else {
                    for g in genres {
                        if g.contains(self.genreSelection) {
                            self.eventList.append(entry)
                            break
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func getEventsForLocation() {
        let url = URL(string: "https://edmtrain.com/api/events?locationIds=" + String(locationId) + "&client=" + KEY)
        let task = URLSession.shared.dataTask(with: url!) { [self](data, response, error) in
            
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
            let events: Events = try! JSONDecoder().decode(Events.self, from: data)
            for event in events.data {
                if (!event.livestreamInd && !event.festivalInd) {
                    print(event.date)
                    print("    " + event.venue.name)
                    
                    for artist in event.artistList {
                        print("        " + artist.name)
                        let newEventEntry = EventEntry(date: event.date, artist: artist.name, venue: event.venue.name)
                        self.filterEvents(entry: newEventEntry)
                    }
                }
            }
            self.updateHandler()
        }
        task.resume()
    }

    func setLocation (city: String, state: String) {
        let url = URL(string: "https://edmtrain.com/api/locations?state=" + state + "&city=" + city + "&client=" + KEY)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
            let location: Locations = try! JSONDecoder().decode(Locations.self, from: data)
            self.locationId = location.data[0].id
            print("Set location ID: " + String(self.locationId))
            self.getEventsForLocation()
        }
        task.resume()
    }
    
    func setGenereSelection (genre: String) {
        self.genreSelection = genre
    }
}
