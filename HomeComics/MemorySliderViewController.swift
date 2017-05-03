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
        if let value = defaults?.integer(forKey: key!) {
            let index = steps?.index(of: value)
            slider.value = Float(index!)
            label.text = "\(value.description) MB"
        }
        slider.addTarget(self, action: #selector(memorySliderAction(sender:forEvent:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(dragSliderAction(sender:forEvent:)), for: .touchDragInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dragSliderAction(sender: UISlider, forEvent event: UIEvent) {
        sender.value = roundf(sender.value)
        if let value = steps?[Int(sender.value)] {
            label.text = "\(value.description) MB"
            //defaults?.set(value, forKey: key!)
        }
    }
    
    func memorySliderAction(sender: UISlider, forEvent event: UIEvent) {
        sender.value = roundf(sender.value)
        if let value = steps?[Int(sender.value)] {
            label.text = "\(value.description) MB"
            defaults?.set(value, forKey: key!)
        }
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
