//
//  Model.swift
//  NewsAPIApp
//
//  Created by Salman Khalid on 08/02/2020.
//  Copyright © 2020 Salman Khalid. All rights reserved.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let message: String?
    let articles: [Article]?
}

struct Article: Codable {
    let title: String
    let description: String?
    let urlToImage: String?
}

struct Config: Codable {
    let newsApiKey: String

    static func readConfig() -> Config? {
        let path = Bundle.main.path(forResource: "config", ofType: "json")

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped) else {
            print("No resource found with name config.json")
            return nil
        }

        guard let response = try? JSONDecoder().decode(Config.self, from: data) else {
            print("Could not map config.json to model")
            return nil
        }

        return response
    }
}
