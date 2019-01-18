//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Giordany Orellana on 12/23/18.
//  Copyright © 2018 Giordany Orellana. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memes : UIImage!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.detailImageView!.image = memes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
