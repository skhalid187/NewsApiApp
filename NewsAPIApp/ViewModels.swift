//
//  ViewModels.swift
//  NewsAPIApp
//
//  Created by Salman Khalid on 08/02/2020.
//  Copyright © 2020 Salman Khalid. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class ArticleViewModel: CustomStringConvertible {
    
//    let id = UUID()

    let article: Article
    
    init(article: Article) {
        self.article = article
    }
    
    var title: String {
        return self.article.title
    }
    
    var description: String {
        return self.article.description ?? ""
    }
    
    var imageUrl: String {
        return self.article.urlToImage ?? ""
    }
}

class ArticleListViewModel: ObservableObject {

    let objectWillChange = PassthroughSubject<Void, Never>()
    var currentSelectedValue = NewsCategory.Headlines.getIntValue() {
        didSet {
            refreshService()
        }
    }

    private var apiKey: String?
    
    var articles = [ArticleViewModel]() {
        didSet {
            objectWillChange.send()
        }
    }
    var message: String? = nil {
        didSet {
            objectWillChange.send()
        }
    }
    
    init() {
        if let config = Config.readConfig() {
            self.apiKey = config.newsApiKey
            refreshService()
        }
    }
    
    private func refreshService() {
        switch currentSelectedValue {
        case NewsCategory.Headlines.getIntValue():
            fetchTopHeadlines()
        case NewsCategory.Cricket.getIntValue():
            fetchCategoryNews(NewsCategory.Cricket)
        case NewsCategory.Football.getIntValue():
            fetchCategoryNews(NewsCategory.Football)
        default:
            fetchTopHeadlines()
        }
    }
    
    
    private func fetchTopHeadlines() {
        guard let apiKey = apiKey else { return }
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)") else {
            fatalError("URL is not correct!")
        }

        fetchNews(newsUrl: url)
    }
    
    private func fetchCategoryNews(_ category: NewsCategory) {
        guard let apiKey = apiKey else { return }
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(category.rawValue)&from=2020-01-11&sortBy=publishedAt&apiKey=\(apiKey)") else {
            fatalError("URL is not correct!")
        }
        
        fetchNews(newsUrl: url)
    }
    
    private func fetchNews(newsUrl: URL) {
        Webservice().loadNewsFromUrl(url: newsUrl) { message, articles in
            
            if let message = message {
                self.message = message
            }
            
            if let articles = articles {
                self.articles = articles.map(ArticleViewModel.init) // ----- find out about this line.
                self.message = nil
            }
        }
    }
}

class RemoteImageUrl: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var data = Data() {
        didSet {
            objectWillChange.send()
        }
    }
    
    init(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}
