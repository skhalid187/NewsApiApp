//
//  WebService.swift
//  NewsAPIApp
//
//  Created by Salman Khalid on 08/02/2020.
//  Copyright © 2020 Salman Khalid. All rights reserved.
//

import Foundation

class Webservice {

    func loadNewsFromUrl(url: URL, completion: @escaping (String?, [Article]?) -> Void) {

        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data, error == nil else {
                completion(nil, nil)
                return
            }

            let response = try? JSONDecoder().decode(NewsResponse.self, from: data)
            if let response = response {
                DispatchQueue.main.async {
                    if response.status == "error" {
                        completion(response.message, nil)
                        return
                    }

                    completion(nil, response.articles)
                }
            }
        }.resume()
    }
}
