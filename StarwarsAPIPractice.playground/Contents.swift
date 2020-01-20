import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    
    private static let baseURL = URL(string: "https://swapi.co/api/")
    private static let peoplePathComponent = "people/"
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        let finalURL = baseURL.appendingPathComponent("\(peoplePathComponent)\(id)")
        // 2 - Contact Server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            // 3 - Handle errors
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            // 4 - Check for data
            guard let data = data else { return completion(nil)}
            // 5 - Decode Person from JSON
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            // 2 - Handle errors
            if let error = error {
                print(error, error.localizedDescription)
            }
            // 3 - Check for data
            guard let data = data else { return completion(nil)}
            // 4 - Decode Film from JSON
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                completion(film)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
}


func fetchFilm(url: URL) {
  SwapiService.fetchFilm(url: url) { film in
      if let film = film {
        print(film.title, film.release_date)
      }
  }
}

SwapiService.fetchPerson(id: 2) { (person) in
    guard let person = person else {return}
    print(person.name + "was in these films:")
    for url in person.films {
        fetchFilm(url: url)
    }
}



