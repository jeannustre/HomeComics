//
//  MemorySliderViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 03/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class MemorySliderViewController: UIViewController {

    @IBOutlet var slider: UISlider!
    @IBOutlet var label: UILabel!
    
    var steps: [Int]?
    var defaults: UserDefaults?
    var key: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slider.isContinuous = false
        slider.maximumValue = Float((steps?.count)! - 1)
        
        slider.addTarget(self, action: #selector(memorySliderAction(sender:forEvent:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func memorySliderAction(sender: UISlider, forEvent event: UIEvent) {
        sender.value = roundf(sender.value)
        if let value = steps?[Int(sender.value)] {
            defaults?.set(value, forKey: key!)
            label.text = "\(value.description) MB"
        }
        
//        print("old : \(sliderValue) new : \(newValue)")
        
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
