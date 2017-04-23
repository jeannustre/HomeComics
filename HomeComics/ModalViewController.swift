//
//  ModalViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 23/04/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    @IBOutlet var ramValueLabel: UILabel!
    @IBOutlet var diskValueLabel: UILabel!
    @IBOutlet var ramSlider: UISlider!
    @IBOutlet var diskSlider: UISlider!
    
    @IBAction func saveAction(_ sender: Any) {
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            
        })
    }
    
    @IBAction func ramValueChanged(_ sender: UISlider) {
        ramValueLabel.text = Int(sender.value).description + "MB"
    }
    
    @IBAction func diskValueChanged(_ sender: UISlider) {
        diskValueLabel.text = Int(sender.value).description + "MB"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ramSlider.value = 128
        diskSlider.value = 512
        // Do any additional setup after loading the view.
        
        //TODO: - Load from user preferences
        ramValueLabel.text = "128MB"
        diskValueLabel.text = "512MB"
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
