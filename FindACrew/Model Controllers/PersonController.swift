//
//  PersonController.swift
//  FindACrew
//
//  Created by Ben Gohlke on 5/4/20.
//  Copyright © 2020 BloomTech. All rights reserved.
//

import Foundation

class PersonController {
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    private let baseURL = URL(string: "https://swapi.dev/api/")!
    private lazy var peopleURL = URL(string: "people", relativeTo: baseURL)!
    
    var people: [Person] = []
    
    func searchForPeopleWith(searchTerm: String, completion: @escaping () -> Void) {
        // https://swapi.dev/api/people/?search=r2
        
        var urlComponents = URLComponents(url: peopleURL, resolvingAgainstBaseURL: true)
        let searchTermQueryTerm = URLQueryItem(name: "search", value: searchTerm)
        
        urlComponents?.queryItems = [searchTermQueryTerm]
        
        guard let requestURL = urlComponents?.url else {
            print("Request URL is nil")
            return
        }
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned from data task.")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let personSearch = try jsonDecoder.decode(PersonSearch.self, from: data)
                self.people.append(contentsOf: personSearch.results)
                completion()
            } catch {
                print("Unable to decode data into object of type [PersonSearch]: \(error)")
            }
            
        }
        
        task.resume()
        
    }
    
    /*
    private let baseURL = URL(string: "https://lambdaswapi.herokuapp.com")!
    private lazy var peopleURL = URL(string: "/api/people", relativeTo: baseURL)!
     */
}
