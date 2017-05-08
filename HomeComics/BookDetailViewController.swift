//
//  BookDetailViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 07/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    @IBOutlet var background: UIImageView!
    
    //var image: UIImage?
    
    @IBOutlet var popButton: UIButton!
    
    @IBAction func popAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popButton.layer.cornerRadius = 5
        self.popButton.clipsToBounds = true
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.popButton.contentEdgeInsets = insets

       // background.image = self.image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
