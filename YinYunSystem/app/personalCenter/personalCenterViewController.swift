//
//  personalCenterViewController.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class personalCenterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{


    @IBOutlet weak var tv: UITableView!
    
    var  url = "/Mobile/Mobile/JContacts"
    var itemArry = NSMutableArray()
    var titleArray = NSArray()
    var jibenArry = NSMutableArray()
    var qitaArry = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleArray = NSArray(objects: "个人信息")
        tv.delegate = self;
        tv.dataSource = self;
        self.automaticallyAdjustsScrollViewInsets = false
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  titleArray.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style:.Default, reuseIdentifier:"myCell")
        cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = titleArray.objectAtIndex(indexPath.row) as? String
        let image = UIImageView(image: UIImage(named: "10"))
        image.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds)-20,15, 10, 20)
        cell.addSubview(image)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("pushPersonalMeg", sender: self)
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
