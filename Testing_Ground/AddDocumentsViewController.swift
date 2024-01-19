// AddDocumentsViewController.swift
// Testing_Ground
//
// Created by Vivek Vangala on 1/19/24.

import Foundation
import UIKit
import CoreData

class AddDocumentsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var AddDocsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    var photoNames: [String] = []
    var selectedImageData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()

        AddDocsButton.target = self
        AddDocsButton.action = #selector(plusButtonTapped)

        tableView.dataSource = self

        print("View did load")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentcell1", for: indexPath)
        let photoName = photoNames[indexPath.row]
        cell.textLabel?.text = photoName
        print("Configuring cell for row: \(indexPath.row), photo name: \(photoName), binary data: \(String(describing: selectedImageData))")
        return cell
    }

    @objc func plusButtonTapped() {
        print("Plus button tapped")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            // Call openCamera() to open the camera
            self.openCamera()
        }

        let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.openPhotoLibrary()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(chooseFromLibraryAction)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available.")
        }
    }

    func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Image picked from library")

            // Capture the binary data associated with the selected image
            selectedImageData = pickedImage.jpegData(compressionQuality: 1.0)

            // Dismiss the photo picking screen
            picker.dismiss(animated: true) {
                // Show the confirmation alert after dismissal
                self.showConfirmationAlert(with: pickedImage)
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image picking cancelled")
        picker.dismiss(animated: true, completion: nil)
    }

    // Function to show a confirmation alert
    func showConfirmationAlert(with image: UIImage) {
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you'd like to input this photo?", preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            print("User confirmed to input the photo")
            self.showNameInputAlert(for: image)
        }

        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        present(alertController, animated: true, completion: nil)
    }

    // Function to show an alert for entering the name
    func showNameInputAlert(for image: UIImage) {
        let alertController = UIAlertController(title: "Enter Photo Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter name"
            textField.delegate = self
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let nameTextField = alertController.textFields?.first, let photoName = nameTextField.text, !photoName.isEmpty {
                // Process the entered name
                print("Entered photo name: \(photoName)")
                self?.updateTableView(with: image, name: photoName)
                // Save to CoreData
                self?.savePhotoToCoreData(childName: "childNameValue", date: Date(), image: "imageValue", title: "titleValue", userName: "userNameValue")
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    // Function to update the table view with the selected image and name
    func updateTableView(with image: UIImage, name: String) {
        print("Updating table view with the selected image and name: \(name), binary data: \(String(describing: selectedImageData))")
        photoNames.append(name)

        // Reload the table view on the main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // Function to generate a unique name for the photo (e.g., timestamp)
    func generateUniqueName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return "Photo_\(formatter.string(from: Date()))"
    }

    // Function to save photo data to CoreData
    func savePhotoToCoreData(childName: String, date: Date, image: String, title: String, userName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        // Create a managed object context
        let context = appDelegate.persistentContainer.viewContext

        // Create a new Documents entity
        if let newDocument = NSEntityDescription.insertNewObject(forEntityName: "Documents", into: context) as? NSManagedObject {

            // Assign values to the entity attributes
            newDocument.setValue(childName, forKey: "childName")
            newDocument.setValue(date, forKey: "date")
            newDocument.setValue(image, forKey: "image")
            newDocument.setValue(title, forKey: "title")
            newDocument.setValue(userName, forKey: "userName")

            // Save the changes to CoreData
            do {
                try context.save()
                print("Saved to CoreData: ChildName - \(childName), Date - \(date), Image - \(image), Title - \(title), UserName - \(userName)")
            } catch {
                print("Failed to save to CoreData: \(error.localizedDescription)")
            }
        }
    }
}
