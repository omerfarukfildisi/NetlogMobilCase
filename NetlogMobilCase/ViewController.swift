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
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.backgroundColor = Colors.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        GMSServices.provideAPIKey("AIzaSyAGtN7co7XyS0EK0ZAxtR_yYzaCQqW_qU0")
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 5 - gridLayout.minimumInteritemSpacing
        return CGSize(width:widthPerItem, height:50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    }
    
    
}

extension ViewController: CLLocationManagerDelegate {
    
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

