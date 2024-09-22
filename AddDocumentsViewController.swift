import UIKit
import CoreData

class AddDocumentsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var AddDocsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var user: String = "" // Current user
    var childName: String = "" // Child's name
    var photoNames: [String] = []
    var selectedImageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("User: \(user), Child: \(childName)")
        
        AddDocsButton.target = self
        AddDocsButton.action = #selector(plusButtonTapped)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: "DocumentTableViewCell")
        
        loadDocumentsFromCoreData()
    }
    
    // MARK: - Core Data Fetch
    
    func loadDocumentsFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Documents")
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@", user, childName)
        
        do {
            let fetchedDocuments = try context.fetch(fetchRequest)
            photoNames = fetchedDocuments.map { $0.value(forKey: "title") as! String }
            tableView.reloadData()
        } catch {
            print("Failed to fetch documents: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Save to Core Data
    
    func savePhotoToCoreData(childName: String, date: Date, image: UIImage, title: String, userName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Save image as binary data
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        let document = NSEntityDescription.insertNewObject(forEntityName: "Documents", into: context)
        document.setValue(userName, forKey: "userName")
        document.setValue(childName, forKey: "childName")
        document.setValue(title, forKey: "title")
        document.setValue(imageData, forKey: "storedImage") // Store the image binary data
        document.setValue(date, forKey: "date")
        
        do {
            try context.save()
            print("Document saved: \(title)")
            photoNames.append(title)
            savePhotoNamesToUserDefaults()
            tableView.reloadData()
        } catch {
            print("Failed to save document: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Edit Document
    
    func updateDocument(at indexPath: IndexPath, newTitle: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Documents")
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND title == %@", user, childName, photoNames[indexPath.row])
        
        do {
            let documents = try context.fetch(fetchRequest)
            if let document = documents.first {
                document.setValue(newTitle, forKey: "title")
                try context.save()
                
                photoNames[indexPath.row] = newTitle
                savePhotoNamesToUserDefaults()
                tableView.reloadData()
                print("Document updated to: \(newTitle)")
            }
        } catch {
            print("Failed to update document: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete Document
    
    func deleteDocument(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Documents")
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND title == %@", user, childName, photoNames[indexPath.row])
        
        do {
            let documents = try context.fetch(fetchRequest)
            if let documentToDelete = documents.first {
                context.delete(documentToDelete)
                try context.save()
                
                photoNames.remove(at: indexPath.row)
                savePhotoNamesToUserDefaults()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("Document deleted: \(photoNames[indexPath.row])")
            }
        } catch {
            print("Failed to delete document: \(error.localizedDescription)")
        }
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell", for: indexPath) as? DocumentTableViewCell else {
            return UITableViewCell()
        }
        
        let photoName = photoNames[indexPath.row]
        cell.textLabel?.text = photoName
        cell.editButtonAction = { [weak self] in
            self?.editButtonTappedForRow(at: indexPath)
        }
        
        return cell
    }
    
    // MARK: - Edit Photo Alert
    
    func editButtonTappedForRow(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit Photo Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = self.photoNames[indexPath.row]
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
            guard let newName = alertController?.textFields?.first?.text, !newName.isEmpty else { return }
            self?.updateDocument(at: indexPath, newTitle: newName)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Add New Photo
    
    @objc func plusButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
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
    
    // MARK: - Image Picker
    
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
        if let pickedImage = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true) {
                self.showNameInputAlert(for: pickedImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Confirm and Save
    
    func showNameInputAlert(for image: UIImage) {
        let alertController = UIAlertController(title: "Enter Photo Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Photo Name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
            guard let photoName = alertController?.textFields?.first?.text, !photoName.isEmpty else { return }
            self?.savePhotoToCoreData(childName: self?.childName ?? "", date: Date(), image: image, title: photoName, userName: self?.user ?? "")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UserDefaults for Photo Names
    
    func savePhotoNamesToUserDefaults() {
        UserDefaults.standard.set(photoNames, forKey: "SavedPhotoNames")
    }
    
    func loadPhotoNamesFromUserDefaults() {
        if let savedPhotoNames = UserDefaults.standard.stringArray(forKey: "SavedPhotoNames") {
            photoNames = savedPhotoNames
        }
    }
}

