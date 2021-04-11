//
//  ViewController.swift
//  NetlogMobilCase
//
//  Created by Ömer Fildişi on 10.04.2021.
//

import UIKit
import GoogleMaps
import CoreLocation


class ViewController: UIViewController {


    @IBOutlet weak var mapContainer: UIView!
    let manager = CLLocationManager()
    @IBOutlet weak var collectionView: UICollectionView!
    var imageArray: [String] = ["info","arrow-up","man","arrow-down","note"]
    var shipmentQuestion: [String] = ["Yük Tipi","Yükleme Tipi", "Yükleme Adedi", "Yüklerin Kilosu", "Yükleme Saati", "Hacim","Çıkış Gümrük"]
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var buttonPicker: UIButton!
    @IBOutlet weak var shipmentCollectionView: UICollectionView!
    @IBOutlet weak var billImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shipmentCollectionView.delegate = self
        shipmentCollectionView.dataSource = self
        collectionView.backgroundColor = Colors.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        GMSServices.provideAPIKey("AIzaSyAGtN7co7XyS0EK0ZAxtR_yYzaCQqW_qU0")
        // Recognizer
        billImageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        billImageView.addGestureRecognizer(imageTapRecognizer)
                
    }
    
    @objc func selectImage() {
            
        self.performSegue(withIdentifier: "imageViewSegue", sender: self)
        
    }
  
}


extension ViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func tappedButton(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        userImageView.image = info[.editedImage] as? UIImage
        buttonPicker.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView{
        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 5 - gridLayout.minimumInteritemSpacing
        return CGSize(width:widthPerItem, height:50)
            
        } else {
            let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let widthPerItem = collectionView.frame.width / 2 - gridLayout.minimumInteritemSpacing
            return CGSize(width:widthPerItem, height:60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
           return imageArray.count
        } else {
            return shipmentQuestion.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.collectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: imageArray[indexPath.row])
        cell.imageView.image = cell.imageView.image?.withRenderingMode(.alwaysTemplate)
        cell.imageView.tintColor = Colors.iconColor
        
        if indexPath.row == 1{
            cell.imageView.image = cell.imageView.image?.withRenderingMode(.alwaysTemplate)
            cell.imageView.tintColor = Colors.mainColor
            cell.backgroundColor = Colors.backgroundColorSelectedCell
        }
        return cell
            
        } else {
            let shipmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "shipmentCell", for: indexPath) as! ShipmentCollectionViewCell
            shipmentCell.shipmentLabel.text = shipmentQuestion[indexPath.row]
            return shipmentCell
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            // The user accepted authorization
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        let coordinate = location.coordinate
        
        GoogleService().getAddress(lat: coordinate.latitude, lng: coordinate.longitude) {
            addressResult in
            if addressResult != nil {
                DispatchQueue.main.async {
                    self.addressLabel.text = addressResult?.results[0].formatted_address
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM"
                    self.dateLabel.text = formatter.string(from: date)
                }
                
                //print(addressResult?.results[0].formatted_address)
            }
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 20.0)
        let mapView = GMSMapView.map(withFrame: self.mapContainer.bounds, camera: camera)
        self.mapContainer.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.title = ""
        marker.snippet = ""
        marker.map = mapView
    }
}

