//
//  personalMessageViewController.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/22.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class personalMessageViewController: UIViewController,HttpProtocol,UITableViewDelegate,UITableViewDataSource{
    

    @IBOutlet weak var tv: UITableView!
    var  url = "/Mobile/Mobile/JContacts"
    var itemArry = NSMutableArray()
    var titleArray = NSArray()
    var jibenArry = NSMutableArray()
    var qitaArry = NSMutableArray()
    var rightBtn = UIButton()
    var request = HttpRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tabBarController?.tabBar.hidden = true
        addRightItem()
        loadDataMethod()
    }
    func addRightItem()
    {
        rightBtn = UIButton(frame: CGRectMake(0, 0,60, 30))
        rightBtn.setTitle("编辑", forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        rightBtn.titleLabel?.textAlignment = NSTextAlignment.Right
        rightBtn.addTarget(self, action: Selector("rightItemAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        let item2=UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = item2
    }
    //MARK: 点击编辑按钮
    func rightItemAction(send:UIButton)
    {
        let btn = send as UIButton
        if( btn.selected == false)
        {
            btn.selected = true
            rightBtn.setTitle("返回", forState: UIControlState.Normal)
        }else if(btn.selected == true){
            btn.selected = false
            rightBtn.setTitle("编辑", forState: UIControlState.Normal)
        }
        tv.reloadData()
    }
    
    //MARK: 加载数据的方法
    func loadDataMethod()
    {
        let bodyStr = NSString(format: "page=1&rows=100000")
        let str = "\(((UIApplication.sharedApplication().delegate) as! AppDelegate).getService())\(url)"
        request.delegate = self
        request.Post(str, str: bodyStr as String)
    }
    func didResponse(result: NSDictionary) {
        let arryIt =  (result.objectForKey("dt") as? NSMutableArray)!
        let userName = ((UIApplication.sharedApplication().delegate) as! AppDelegate).getUserName()
        for(var i = 0;i < arryIt.count;++i)
        {
            let arryDic =  arryIt.objectAtIndex(i) as! NSDictionary
            let str = arryDic.objectForKey("U_UName") as! String
            if(userName == str)
            {
                itemArry.addObject(arryDic)
                tv.reloadData()
            }
        }
        
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 380
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "personalCenterTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let cell:personalCenterTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! personalCenterTableViewCell
        cell.controllerV = self
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        if(itemArry.count > 0)
        {
            let dic =  itemArry.objectAtIndex(indexPath.row) as! NSDictionary
            
            if(rightBtn.selected != true)
            {
                cell.nameText.hidden = true
                cell.zhanghaoText.hidden = true
                cell.passwordText.hidden = true
                cell.mobilePhoneText.hidden = true
                cell.banGongPhoneText.hidden = true
                cell.maileText.hidden = true
                cell.submitBtn.hidden = true
                
                cell.name.text = dic.objectForKey("U_Name") as? String
                cell.zhanghao.text = dic.objectForKey("U_UName") as? String
                cell.password.text = ((UIApplication.sharedApplication().delegate) as! AppDelegate).getPassword()
                cell.mobilePhone.text = dic.objectForKey("TELEPHONE") as? String
                cell.banGongPhone.text = dic.objectForKey("Phone") as? String
                cell.maile.text = dic.objectForKey("EMAIL") as? String
            }else{
                cell.nameText.hidden = false
                cell.zhanghaoText.hidden = false
                cell.passwordText.hidden = false
                cell.mobilePhoneText.hidden = false
                cell.banGongPhoneText.hidden = false
                cell.maileText.hidden = false
                cell.submitBtn.hidden = false
                
                cell.nameText.text = dic.objectForKey("U_Name") as? String
                cell.zhanghaoText.text = dic.objectForKey("U_UName") as? String
                cell.passwordText.text = ((UIApplication.sharedApplication().delegate) as! AppDelegate).getPassword()
                cell.mobilePhoneText.text = dic.objectForKey("TELEPHONE") as? String
                cell.banGongPhoneText.text = dic.objectForKey("Phone") as? String
                cell.maileText.text = dic.objectForKey("EMAIL") as? String
            }
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cusView = UIView()
        cusView.frame = CGRectMake(0, 0, CGRectGetWidth(tv.frame),50)
        cusView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        let lab = UILabel()
        lab.frame = CGRectMake(20, 0,CGRectGetWidth(tv.frame)-20,50)
        lab.text = "基本信息"
        lab.textColor = UIColor.grayColor()
        lab.font = UIFont.systemFontOfSize(20.0)
        cusView.addSubview(lab)
        return cusView
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
