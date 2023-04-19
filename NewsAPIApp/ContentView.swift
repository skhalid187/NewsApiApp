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

    @State var newsCategories: [NewsCategory] = [
        NewsCategory.Headlines,
        NewsCategory.Cricket,
        NewsCategory.Football
    ]

    @State var someCategories: [String] = ["First", "Second", "Third"]

    var body: some View {
        VStack {
            Picker(selection: self.$model.currentSelectedValue, label: Text("Select news category?")) {

                ForEach(newsCategories, id: \.self) { item in

                    Text(item.rawValue).tag(item.getIntValue())
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
        List(self.articlesList, id: \ArticleViewModel.title) { article in
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    ImageViewContainer(imageURL: article.imageUrl)
                    Spacer()
                }
                Text(article.title)
                    .lineLimit(nil)
                Text(article.description)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
            }
        }
    }
}

struct ImageViewContainer: View {
    @ObservedObject var remoteImageURL: RemoteImageUrl
    
    init(imageURL: String) {
        remoteImageURL = RemoteImageUrl(imageURL: imageURL)
    }
    
    var body: some View {
        Image( uiImage: (remoteImageURL.data.isEmpty) ? UIImage(imageLiteralResourceName: "swiftUi") : UIImage(data: remoteImageURL.data)!)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 250, height: 150)
    }
}
