//
//  ViewController.swift
//  NewsAPIApp
//
//  Created by Salman Khalid on 18/02/2020.
//  Copyright © 2020 Salman Khalid. All rights reserved.
//

import UIKit
import Combine

class CustomViewController: UIViewController {

    @IBOutlet var notificationLabel: UILabel!
    
    var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let lastPostLabelSubscriber = Subscribers.Assign(object: notificationLabel, keyPath: \.text)
        blogPostPublisher.subscribe(lastPostLabelSubscriber)
    }

    @IBAction func PostNotificationClicked(_ sender: Any) {
        counter += 1
        let blogPost = BlogPost(title: "Counter: \(counter)", url: URL(string: "https://www.msn.com")!)
        NotificationCenter.default.post(name: .newBlogPost, object: blogPost)
    }
}

