//
//  TestViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 24/04/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request("http://127.0.0.1:1337/book").responseArray { (response: DataResponse<[Book]>) in
            if let bookArray = response.result.value {
                for book in bookArray {
                    print(book.title ?? "title error")
                }
            }
    
        }
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
