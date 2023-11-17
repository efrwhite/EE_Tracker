//
//  AddDocumentsViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 10/29/23.
//

import Foundation
import UIKit
class AddDocumentsViewController: UIViewController{
    
    @IBOutlet weak var AddDocsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
            super.viewDidLoad()

            // action for the plus button
            AddDocsButton.target = self
            AddDocsButton.action = #selector(plusButtonTapped)
        }

        @objc func plusButtonTapped() {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
                // Handle taking a photo (Not sure how to implement this)
            }

            let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
                // Handle choosing from the library (Not sure how to implement this, have to figure out how to open Files or Photos App?)
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            actionSheet.addAction(takePhotoAction)
            actionSheet.addAction(chooseFromLibraryAction)
            actionSheet.addAction(cancelAction)

            // Present the action sheet
            present(actionSheet, animated: true, completion: nil)
        }
    }


