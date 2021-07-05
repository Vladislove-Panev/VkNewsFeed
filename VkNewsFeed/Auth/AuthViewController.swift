//
//  ViewController.swift
//  VkNewsFeed
//
//  Created by vladislavpanev on 22.05.2021.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var authButton: UIButton!
    
    var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authButton.layer.cornerRadius = 5
        view.backgroundColor = .systemBlue
        authService = SceneDelegate.shared().authService
    }

    @IBAction func auth(_ sender: UIButton) {
        authService.wakeUpSession()
    }
    
}

