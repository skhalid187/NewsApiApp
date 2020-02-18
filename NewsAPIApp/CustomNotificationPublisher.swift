//
//  CustomNotificationPublisher.swift
//  NewsAPIApp
//
//  Created by Salman Khalid on 18/02/2020.
//  Copyright © 2020 Salman Khalid. All rights reserved.
//

import Combine
import Foundation

extension Notification.Name {
    static let newBlogPost = Notification.Name("new_blog_post")
}

struct BlogPost {
    let title: String
    let url: URL
}

let blogPostPublisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)
                                                    .map { (notification) -> String? in
                                                            return (notification.object as? BlogPost)?.title ?? ""
                                                        }

