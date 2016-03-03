//
//  personalCenterViewController.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class personalCenterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpProtocol,personalCellProtocol{


    @IBOutlet weak var tv: UITableView!
    
    var  url = "/Mobile/Mobile/JContacts"
    var itemArry = NSMutableArray()
    var titleArray = NSArray()
    var jibenArry = NSMutableArray()
    var qitaArry = NSMutableArray()
    var rightItem = UIButton()
    var request = HttpRequest()
    var itemDic = NSDictionary()
    var color = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        titleArray = NSArray(objects: "个人信息")
        tv.delegate = self;
        tv.dataSource = self;
        self.automaticallyAdjustsScrollViewInsets = false
        addRightItem()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
        loadDataMethod()
    }
    func addRightItem()
    {
        rightItem = UIButton(frame: CGRectMake(0, 0,60, 30))
        rightItem.selected = false
        rightItem.setTitle("编辑", forState: UIControlState.Normal)
        rightItem.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        rightItem.titleLabel?.textAlignment = NSTextAlignment.Right
        rightItem.addTarget(self, action: Selector("rightItemAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        let item2=UIBarButtonItem(customView: rightItem)
        self.navigationItem.rightBarButtonItem = item2
    }
    func rightItemAction(send:UIButton)
    {
        if(rightItem.selected == false)
        {
            rightItem.selected = true
            rightItem.setTitle("返回", forState: UIControlState.Normal)
            tv.reloadData()
        }else if(rightItem.selected == true){
            rightItem.selected = false
            rightItem.setTitle("编辑", forState: UIControlState.Normal)
            tv.reloadData()
        }
    }
    //MARK: 加载数据的方法
    func loadDataMethod()
    {
        loadingAnimationMethod.sharedInstance.startAnimation()
        let bodyStr = NSString(format: "page=1&rows=100000")
        let str = "\(((UIApplication.sharedApplication().delegate) as! AppDelegate).getService())\(url)"
        request.delegate = self
        request.Post(str, str: bodyStr as String)
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        let arryIt =  (result.objectForKey("dt") as? NSMutableArray)!
        let userName = ((UIApplication.sharedApplication().delegate) as! AppDelegate).getUserName()
        for(var i = 0;i < arryIt.count;++i)
        {
            let arryDic =  arryIt.objectAtIndex(i) as! NSDictionary
            let str = arryDic.objectForKey("U_UName") as! String
            if(userName == str)
            {
                itemArry.addObject(arryDic)
            }
        }
        tv.reloadData()
    }
    func updateData() {
        rightItem.selected = false
        rightItem.setTitle("编辑", forState: UIControlState.Normal)
        tv.reloadData()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  titleArray.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGRectGetHeight(UIScreen.mainScreen().bounds)-130
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerNib(UINib(nibName: "personalMegcell", bundle: nil), forCellReuseIdentifier:"cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let cell:personalMegcell = tableView.dequeueReusableCellWithIdentifier("cell")! as! personalMegcell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.controllerV = self
        cell.delegate = self
        if(itemArry.count > 0)
        {
            itemDic = (itemArry.objectAtIndex(indexPath.row) as? NSDictionary)!
        }
        
        if(rightItem.selected == false)
        {
            cell.nameText.hidden = true
            cell.zhanghaoText.hidden = true
            cell.passwordText.hidden = true
            cell.mobileText.hidden = true
            cell.banGongText.hidden = true
            cell.emailText.hidden = true
            
            cell.nameLabel.hidden = false
            cell.zhanghaoLabel.hidden = false
            cell.passwordLabel.hidden = false
            cell.mobileLabel.hidden = false
            cell.banGongLabel.hidden = false
            cell.emailLabel.hidden = false
            
            cell.submitBtn.hidden = true
            
            cell.nameLabel.text = itemDic.objectForKey("U_Name") as? String
            cell.zhanghaoLabel.text = itemDic.objectForKey("U_UName") as? String
            cell.passwordLabel.text = ((UIApplication.sharedApplication().delegate) as! AppDelegate).getPassword()
            cell.mobileLabel.text = itemDic.objectForKey("TELEPHONE") as? String
            cell.banGongLabel.text = itemDic.objectForKey("Phone") as? String
            cell.emailLabel.text = itemDic.objectForKey("EMAIL") as? String
            
        }else{
            cell.nameText.hidden = false
            cell.zhanghaoText.hidden = false
            cell.passwordText.hidden = false
            cell.mobileText.hidden = false
            cell.banGongText.hidden = false
            cell.emailText.hidden = false
            
            cell.nameLabel.hidden = true
            cell.zhanghaoLabel.hidden = true
            cell.passwordLabel.hidden = true
            cell.mobileLabel.hidden = true
            cell.banGongLabel.hidden = true
            cell.emailLabel.hidden = true
            
            cell.submitBtn.hidden = false
            cell.nameText.text = itemDic.objectForKey("U_Name") as? String
            cell.zhanghaoText.text = itemDic.objectForKey("U_UName") as? String
            cell.passwordText.text = ((UIApplication.sharedApplication().delegate) as! AppDelegate).getPassword()
            cell.mobileText.text = itemDic.objectForKey("TELEPHONE") as? String
            cell.banGongText.text = itemDic.objectForKey("Phone") as? String
            cell.emailText.text = itemDic.objectForKey("EMAIL") as? String
        
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
