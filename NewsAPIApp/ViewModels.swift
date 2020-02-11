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

// Get API Key from https://newsapi.org/
let API_KEY = "API_KEY_GOES_HERE"

class ArticleViewModel: Identifiable, CustomStringConvertible {
    
    let id = UUID()

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
}

class ArticleListViewModel: ObservableObject {
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    var currentSelectedValue = NewsCategory.Headlines.getIntValue() {
        didSet {
            refreshService()
        }
    }
    
    var articles = [ArticleViewModel]() {
        didSet {
            objectWillChange.send()
        }
    }
    
    init() {
        refreshService()
    }
    
    func refreshService() {
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
    
    
    func fetchTopHeadlines() {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(API_KEY)") else {
            fatalError("URL is not correct!")
        }

        fetchNews(newsUrl: url)
    }
    
    func fetchCategoryNews(_ category: NewsCategory) {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(category.rawValue)&from=2020-01-11&sortBy=publishedAt&apiKey=\(API_KEY)") else {
            fatalError("URL is not correct!")
        }
        
        fetchNews(newsUrl: url)
    }
    
    private func fetchNews(newsUrl: URL) {
        Webservice().loadNewsFromUrl(url: newsUrl) { articles in
            if let articles = articles {
                self.articles = articles.map(ArticleViewModel.init)
            }
        }
    }
}
