//
//  KQViewController.swift
//  YinYunSystem
//  考勤页面控制器
//  Created by 魏辉 on 16/1/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var listTableView: UITableView!

    var workArray = ["我的工作日历","考勤申请记录","考勤补录记录"]

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToKQ(segue: UIStoryboardSegue){
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RLCell", forIndexPath: indexPath) as! KQTableViewCell
        cell.nameLabel.text = workArray[indexPath.row]

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let num = indexPath.row
        switch num {
        case 0 :
            self.listTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("RLSegue", sender: self)
        case 1:
            self.listTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("SQSegue", sender: self)
        case 2:
            self.listTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("BLSegue", sender: self)
        default:
            break
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RLSegue" {
            let vc = segue.destinationViewController as! UITabBarController
            vc.tabBar.backgroundColor = UIColor(red: 67, green: 70, blue: 76, alpha: 1.0)
        }
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
