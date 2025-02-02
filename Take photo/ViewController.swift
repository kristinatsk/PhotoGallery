//
//  ViewController.swift
//  Milestone Projects 10-12
//
//  Created by Kristina Kostenko on 29.09.2024.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pictures = [Picture]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        let defaults = UserDefaults.standard
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
            } catch {
                print("Failed to save pictures")
            }
        }
    }
    
    @objc func addTapped() {
       
        let pickerTakePhoto = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerTakePhoto.sourceType = .camera
        }
        pickerTakePhoto.allowsEditing = true
        pickerTakePhoto.delegate = self
        present(pickerTakePhoto, animated: true)
        
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        
        dismiss(animated: true, completion: nil)
        
        let picture = Picture(name: "Unknown", image: imageName)
        
        let ac = UIAlertController(title: "Add caption", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "OK", style: .default) {[weak self, ac] _ in
            let newName = ac.textFields![0]
            picture.name = newName.text!
            //self?.submit(picture.name, picture.image)
            
            self?.pictures.insert(picture, at: 0)
            self?.save()
            self?.tableView.reloadData()
            
        }
       
        ac.addAction(submitAction)
        present(ac, animated: true)
        
            
    }
    
//    func submit(_ caption: String, _ image: String) {
//        
//        let picture = Picture(name: caption, image: image)
//        pictures.insert(picture, at: 0)
//        tableView.reloadData()
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = pictures[indexPath.row]
        cell.textLabel?.text = picture.name
        
//        let path = getDocumentsDirectory().appendingPathComponent(picture.image)
//        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let picture = pictures[indexPath.row]
        
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            
            vc.selectedImage = pictures[indexPath.row]//vc.selectedImage = picture.image
            //vc.selectedPictureNumber = indexPath.row + 1
            navigationController?.pushViewController(vc, animated: true)
        }
    
        tableView.reloadData()
        
    }

//    func submit(_ answer: String) {
//        let indexPath = IndexPath(row: 0, section: 0)
//        let picture = pictures[indexPath.row]
//        pictures.insert(answer, at: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let saveData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "pictures")
        } else {
            print("Failed to save pictures")
        }
    }

}

