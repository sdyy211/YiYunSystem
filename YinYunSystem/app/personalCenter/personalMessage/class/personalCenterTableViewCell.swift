//
//  personalCenterTableViewCell.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/22.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
@objc protocol personalCellProtocol{
    func updateData()
}

class personalCenterTableViewCell: UITableViewCell,HttpProtocol{

    var url = "/MyInfo/JMySet"
    var request = HttpRequest()
    var delegate = personalCellProtocol.self
    var controllerV = UIViewController()
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var zhanghao: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var mobilePhone: UILabel!
    @IBOutlet weak var banGongPhone: UILabel!
    @IBOutlet weak var maile: UILabel!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var zhanghaoText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var mobilePhoneText: UITextField!
    
    @IBOutlet weak var banGongPhoneText: UITextField!
    
    @IBOutlet weak var maileText: UITextField!
    
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBAction func submitBtnAction(sender: AnyObject) {
        loadDataMethod()
    }
    //MARK: 加载数据的方法
    func loadDataMethod()
    {
        if(zhanghaoText.text != "" || passwordText.text != "")
        {
            let bodyStr = NSString(format: "uname=\(nameText.text!)&uno=\(zhanghaoText.text!)&upwd=\(passwordText.text!)&telphone=\(mobilePhoneText.text!)&bangong=\(banGongPhoneText.text!)&email=\(maileText.text!)")
            
            let str = "\(((UIApplication.sharedApplication().delegate) as! AppDelegate).getService())\(url)"
            request.delegate = self
            request.Post(str, str: bodyStr as String)
        }else{
             alter("提示", message: "用户名或密码不能为空！")
        }
        
    }
    func didResponse(result: NSDictionary) {
        print(result)
        let flag = result.objectForKey("flag")
        if("\(flag)" == "1")
        {
            NSUserDefaults.standardUserDefaults().setObject(self.nameText.text, forKey:"user")
            NSUserDefaults.standardUserDefaults().setObject(self.passwordText.text, forKey:"pwd")
            alter("提示", message: "请求成功")
            
        }else{
             let meg = result.objectForKey("msg") as? String
             alter("提示！", message: meg!)
        }
       
    }
    func alter(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertView.addAction(alertViewCancelAction)
        controllerV.presentViewController(alertView, animated:true , completion: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        nameText.resignFirstResponder()
        zhanghaoText.resignFirstResponder()
        passwordText.resignFirstResponder()
        mobilePhoneText.resignFirstResponder()
        banGongPhoneText.resignFirstResponder()
        maileText.resignFirstResponder()
        
    }
    
}
