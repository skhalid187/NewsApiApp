//
//  PublishedDemoVC.swift
//  NewsAPIApp
//
//  Created by Salman Khalid on 19/02/2020.
//  Copyright © 2020 Salman Khalid. All rights reserved.
//

import UIKit
import Combine

final class FormViewController: UIViewController {

    @Published var isSubmitAllowed: Bool = false
    private var switchSubscriber: AnyCancellable?

    @IBOutlet weak var acceptTermsSwitch: UISwitch!

    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        switchSubscriber = $isSubmitAllowed.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: submitButton)

    }
    @IBAction func didSwitch(_ sender: UISwitch) {
        isSubmitAllowed = sender.isOn
    }
}
