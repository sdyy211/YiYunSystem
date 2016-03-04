//
//  YZViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/3/4.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class YZViewController: UIViewController {
    @IBOutlet weak var listTableView: UITableView!
    
    var workArray = ["我要申请","我的申请列表"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableFooterView = UIView(frame: CGRectZero)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToYZ(segue: UIStoryboardSegue){
        
    }
}
private typealias TableViewDataSource = YZViewController

extension TableViewDataSource: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BXCell", forIndexPath: indexPath) as! BXTableViewCell
        cell.listName.text = workArray[indexPath.row]
        
        return cell
    }
}

private typealias TableViewDelegate = YZViewController

extension TableViewDelegate: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let num = indexPath.row
        switch num {
        case 0 :
            self.listTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("MyBXSegue", sender: self)
        case 1:
            self.listTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("BXListSegue", sender: self)
        default:
            break
        }
        
    }
    
}

private typealias Segues = YZViewController

extension Segues {
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RLSegue" {
            let vc = segue.destinationViewController as! UITabBarController
            vc.tabBar.backgroundColor = UIColor(red: 67, green: 70, blue: 76, alpha: 1.0)
        }
    }
    
}

