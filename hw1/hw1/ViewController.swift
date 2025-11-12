//
//  ViewController.swift
//  hw1
//
//  Created by ChienLin Su on 2025/11/11.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SwiftUI view
        let ticTacToeView = TicTacToeGame()
        
        // Create a hosting controller to embed SwiftUI in UIKit
        let hostingController = UIHostingController(rootView: ticTacToeView)
        
        // Add the hosting controller as a child view controller
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }


}

