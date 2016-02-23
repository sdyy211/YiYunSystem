//
//  personalMegcell.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
@objc protocol personalCellProtocol{
    func updateData()
}
class personalMegcell: UITableViewCell,HttpProtocol{

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var zhanghaoLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var mobileLabel: UILabel!
    
    @IBOutlet weak var banGongLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var zhanghaoText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var mobileText: UITextField!
    
    @IBOutlet weak var banGongText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var url = "/MyInfo/JMySet"
    var request = HttpRequest()
    var controllerV = UIViewController()
    var delegate = personalCellProtocol?()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func submitAction(sender: AnyObject) {
        loadDataMethod()
    }
    func loadDataMethod()
    {
        if(zhanghaoText.text != "" || passwordText.text != "")
        {
            let bodyStr = NSString(format: "uname=\(nameText.text!)&uno=\(zhanghaoText.text!)&upwd=\(passwordText.text!)&telphone=\(mobileText.text!)&bangong=\(banGongText.text!)&email=\(emailText.text!)")
            
            let str = "\(((UIApplication.sharedApplication().delegate) as! AppDelegate).getService())\(url)"
            request.delegate = self
            request.Post(str, str: bodyStr as String)
        }else{
            alter("提示", message: "用户名或密码不能为空！")
        }
        
    }
    func didResponse(result: NSDictionary) {
        print(result)
        let flag = result.objectForKey("flag") as? NSNumber
        if(Int(flag!) == 1)
        {
            NSUserDefaults.standardUserDefaults().setObject(self.zhanghaoText.text, forKey:"user")
            NSUserDefaults.standardUserDefaults().setObject(self.passwordText.text, forKey:"pwd")
            delegate?.updateData()
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        nameText.resignFirstResponder()
        zhanghaoText.resignFirstResponder()
        passwordText.resignFirstResponder()
        nameText.resignFirstResponder()
        banGongText.resignFirstResponder()
        emailText.resignFirstResponder()
    }
    
}
