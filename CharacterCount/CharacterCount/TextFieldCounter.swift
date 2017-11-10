//
//  TextFieldCounter.swift
//  CharacterCount
//
//  Created by Muhammad Hilmy Fauzi on 10/11/17.
//  Copyright © 2017 Hilmy Corp. All rights reserved.
//

import UIKit

protocol TextFieldWithCharacterCountDelegate: class {
    //beberapa method textfield delegate yang akan digunakan
    func didEndEditing()
    func didBeginEditing()
    
    //method lain yang digunakan
    func didReachCharacterLimit(_ reach : Bool)
    
}

@IBDesignable class TextFieldWithCharacterCount : UITextField {
    
    //declare fileprivate countLabel
    fileprivate let countLabel = UILabel()
    
    //declare drhDelegate as Object from TextFieldWithCharacterCountDelegate
    weak var drhDelegate: TextFieldWithCharacterCountDelegate?
    
    //declare variable lengthlimit
    @IBInspectable var lengthLimit : Int = 0
    //declare variable countLabelColor
    @IBInspectable var countLabelColor : UIColor = UIColor.black
    
    //declare variable costumDelegate
    weak var costumDelegate : UITextFieldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //if lengthlimit > 0
        if lengthLimit > 0 {
            //call method setCountLabel
            setCountLabel()
        }
        
        delegate = self as? UITextFieldDelegate
    }
    
    //make method set setCountLabel
    fileprivate func setCountLabel(){
        rightViewMode = .always
        //setting size font
        countLabel.font = font?.withSize(10)
        countLabel.textColor = countLabelColor
        //setting text align to left
        countLabel.textAlignment = .left
        rightView = countLabel
        
        countLabel.text = initialCounterValue(text)
        //check if text same with text
        if let text = text{
            //condition if same, will count the text with format utf16
            countLabel.text = "\(text.utf16.count)/\(lengthLimit)"
            
        }else{
            //condition if not same, will show 0
            countLabel.text = "0\(lengthLimit)"
        }
    }
    
    //make new method initialCounterValue
    fileprivate func initialCounterValue(_ text: String?) -> String {
        
        //check if text = text
        if let text = text {
            //condition if same, will count sum of text
            return "\(text.utf16.count)/\(lengthLimit)"
        }else{
            //if not same, will return value 0
            return "0/\(lengthLimit)"
        }
        
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        //check if the value more than 0
        if lengthLimit > 0 {
            //condition if value of limit > 0
            //return value with x, y and width height value
            return CGRect(x: frame.width - 35 , y: 0, width: 30, height:30)
        }
        return CGRect()
    }
}

//add extension

extension TextFieldWithCharacterCount: UITextFieldDelegate {
    
    //add function shouldchangecharacters
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //declare value of text
        guard let text = textField.text , lengthLimit != 0 else {return true}
        
        //declare newLength
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        //check if newLength <= lengthLimit
        if newLength <= lengthLimit {
            //condition if newLenght <= lengthLimit
            //countlabel show text newlength
            countLabel.text = "\(newLength)/\(lengthLimit)"
            drhDelegate?.didReachCharacterLimit(false)
            
        }else{
            //condition if not same
            drhDelegate?.didReachCharacterLimit(true)
            
            //add animation
            UIView.animate(withDuration: 0.1, animations: {
                self.countLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { (finish) in UIView.animate(withDuration: 0.1, animations: {
                self.countLabel.transform = CGAffineTransform.identity
            })})
        }
        //add return
        return newLength <= lengthLimit
        
    }
    
    //add method textFieldEndEditing
    func textFieldDidEndEditing(_ textField: UITextField) {
        drhDelegate?.didEndEditing()
    }
    //add method didBeginingEditing
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        drhDelegate?.didBeginEditing()
    }
}

