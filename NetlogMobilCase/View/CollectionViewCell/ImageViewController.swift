//
//  ImageViewController.swift
//  NetlogMobilCase
//
//  Created by Ömer Fildişi on 11.04.2021.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate{

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var billImageView: UIImageView!
    var billImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        self.navigationController?.setNavigationBarHidden(true,animated:false)
        billImageView.image = billImage
      
     
    }
    

    @IBAction func tappedButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return billImageView
    }
}

