//
//  Diet1ViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 2/1/24.
//

import Foundation
import UIKit
import CoreData

class Diet1ViewController: UIViewController {
    
    @IBOutlet weak var Diet1GoodView: UIView!
    @IBOutlet weak var Diet1BadView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var user = ""
    var userchild = ""
    var Diet1GoodViewController: Diet1GoodViewController?
    var Diet1BadViewController: Diet1BadViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        // initial view at view load
        Diet1GoodView.isHidden = false
        Diet1BadView.isHidden = true
        
        // Get reference to child view controllers
        Diet1GoodViewController = children.first(where: { $0 is Diet1GoodViewController }) as? Diet1GoodViewController
        Diet1BadViewController = children.first(where: { $0 is Diet1BadViewController }) as? Diet1BadViewController
        
    }
   
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Diet1GoodView.isHidden = false
            Diet1BadView.isHidden = true
        } else {
            Diet1GoodView.isHidden = true
            Diet1BadView.isHidden = false
        }
    }
}

