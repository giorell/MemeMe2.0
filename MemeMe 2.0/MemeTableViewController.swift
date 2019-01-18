//
//  MemeTableViewController.swift
//  MemeMe 2.0
//
//  Created by Giordany Orellana on 12/17/18.
//  Copyright © 2018 Giordany Orellana. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Reloads table data
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //set up cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        let memecell = self.memes[(indexPath as NSIndexPath).row]
        
        //Set cell parameters
        cell.sentMemeImage.image = memecell.memedImage
        cell.sentMemeTopText.text = memecell.topText
        cell.sentMemeBottomText.text = memecell.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //transition to detail view of meme
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memes = self.memes[(indexPath as NSIndexPath).row].memedImage
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
