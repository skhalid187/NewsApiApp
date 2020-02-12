//
//  ContentView.swift
//  NewsAPIApp
//
//  Created by Salman Khalid on 08/02/2020.
//  Copyright © 2020 Salman Khalid. All rights reserved.
//

import SwiftUI

enum NewsCategory: String {
    case Headlines, Cricket, Football
    
    func getIntValue() -> Int {
        switch self {
        case .Headlines:
            return 0
        case .Cricket:
            return 1
        case .Football:
            return 2
        }
    }
}

struct ContentView : View {
    
    @ObservedObject var model = ArticleListViewModel()
    var newsCategories: [String] = [
        NewsCategory.Headlines.rawValue,
        NewsCategory.Cricket.rawValue,
        NewsCategory.Football.rawValue      
    ]
    
    var body: some View {
        VStack {
            Picker(selection: self.$model.currentSelectedValue, label: Text("Select news category?")) {
                        ForEach(0..<newsCategories.count) { index in
                            Text(self.newsCategories[index]).tag(index)
                        }
                
                }.pickerStyle(SegmentedPickerStyle())
            Spacer()
            if model.message != nil {
                Text(model.message!)
            } else {
                ArticlesList(articles: model.articles)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ArticlesList: View {
    
    var articlesList: [ArticleViewModel]

    init(articles: [ArticleViewModel]) {
        self.articlesList = articles
    }
    var body: some View {
        List(self.articlesList) { article in
            
            VStack(alignment: .leading) {
                
                Text(article.title)
                    .lineLimit(nil)
                
                Text(article.description)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
            }
        }
    }
}
