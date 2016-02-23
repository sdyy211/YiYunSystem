//
//  KQNewBLTimeViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQNewBLTimeViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        
        let datefor = NSDateFormatter()
        datefor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        chooseDate = datefor.stringFromDate(datePicker.date)
        performSegueWithIdentifier("UnwindToNewBL", sender: self)
    }
    //选中的时间
    var chooseDate: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
