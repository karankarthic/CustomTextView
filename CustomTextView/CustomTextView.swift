//
//  CustomTextView.swift
//  CustomTextView
//
//  Created by Karan Karthic on 19/08/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import UIKit

class CustomTextView:UITextView{
    
    var tagsContainer:[String] = []
    var tagColor:UIColor = UIColor.blue
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func rangeOfReplacingStringWithDilimeter(dilimeter:Character)-> NSRange?{
        
        let textViewText = self.text ?? ""
        
        let content = textViewText
        
        if content.count == 1 && content.hasPrefix(String(dilimeter)) == false  {
            return nil
        }
        
        guard let swiftRange = Range.init(selectedRange, in: content) else {
            return nil
        }
        
        let endIndex = swiftRange.lowerBound
        
        let prefix = content.prefix(upTo: endIndex)
        
        guard let lastIndex = prefix.lastIndex(of: dilimeter) else
        {
            return nil
        }
        
        let startIndex = lastIndex
        
        let newRange = Range<String.Index>.init(uncheckedBounds: (lower: startIndex, upper: endIndex))
        
        let nsRange = content.nsRange(from: newRange)
        
        return nsRange
        
    }
    
    func addUser(model: String, selectedRange: NSRange, themeColor: UIColor) {
        
        tagColor = themeColor
        
        var textFieldSeletedRange = 0
        
        if selectedRange.length >= model.count{
            textFieldSeletedRange = selectedRange.length - model.count
        }else{
            textFieldSeletedRange = model.count - selectedRange.length
        }
        
        let paragraph = NSMutableParagraphStyle()
        
        if self.isRightToLeft{
            paragraph.alignment = .right
            
        }else{
            paragraph.alignment = .left
            
        }
        self.typingAttributes = [ NSAttributedString.Key.foregroundColor: themeColor ,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),NSAttributedString.Key.paragraphStyle:paragraph ]
        
        
        DispatchQueue.main.async {
            self.selectedRange = NSRange.init(location:  selectedRange.location, length: 0)
        }
        if let textRange = self.getTextRange(selectedRange){
            self.replace(textRange, withText: model)
        }
        
        self.typingAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular),NSAttributedString.Key.paragraphStyle:paragraph]
       
        
        
        if tagsContainer.contains(where: { $0 == model }) == false{
            tagsContainer.append(model)
        }
        DispatchQueue.main.async {
            self.selectedRange = NSRange.init(location:  selectedRange.location + textFieldSeletedRange, length: 0)
        }
    }
    
    func getTextRange(_ nsRange: NSRange) -> UITextRange? {
        let beginning = self.beginningOfDocument
        if let start = self.position(from: beginning, offset: nsRange.location), let end = self.position(from: start, offset: nsRange.length), let textRange = self.textRange(from: start, to: end) {
            
            return textRange
            
        }
        
        return nil
    }
    
}

extension CustomTextView:UITextViewDelegate{
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if textView.selectedRange.length == textView.text.count{
            return
        }
        
        if let selectedRange = textView.selectedTextRange {
            
            let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
            
            let cursorRange = NSRange.init(location: cursorPosition, length: textView.selectedRange.length)
            let textViewText = self.text ?? ""
            
            let replacementNsRange = cursorRange
            
            for model in tagsContainer{
                
                if let replacementRange = Range(replacementNsRange, in: textViewText)  {
                    
                    let nsRangesOfModel = textViewText.ranges(of: model)
                    
                    for nsRangeOfModel in nsRangesOfModel {
                        if let rangeOfModel = Range(nsRangeOfModel, in: textViewText) {
                            
                            let nsRange = NSRange(rangeOfModel, in: textViewText)
                            
                            
                            if replacementRange.overlaps(rangeOfModel) {
                                let attributedString = textView.attributedText.attributedSubstring(from: nsRange)
                                
                                var overlaps = false
                                
                                attributedString.enumerateAttribute(NSAttributedString.Key.foregroundColor, in: NSRange(location: 0, length: attributedString.length), options: NSAttributedString.EnumerationOptions.reverse) { (value, _, _) in
                                    if let value = value as? UIColor , value.hexString == self.tagColor.hexString {
                                        
                                        overlaps = true
                                        
                                    }
                                }
                                
                                if overlaps  {
                                    let beginning = textView.beginningOfDocument
                                    guard let start = textView.position(from: beginning, offset: nsRange.location), let end = textView.position(from: start, offset: (nsRange.length)) else { return }
                                    
                                    let textRange = textView.textRange(from: start, to: end)
                                    textView.selectedTextRange = textRange
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let paragraph = NSMutableParagraphStyle()
        
        if self.isRightToLeft{
            paragraph.alignment = .right
            
        }else{
            paragraph.alignment = .left
            
        }
        self.typingAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular),NSAttributedString.Key.paragraphStyle:paragraph]
        
        
        
        if text == "" {
            
            if range.length == textView.text.count, let textRange = self.getTextRange(range) {
                textView.replace(textRange, withText: "")
                tagsContainer.removeAll()
                return false
                
            }
            
            let textViewText = self.text ?? ""
            
            let replacementNsRange = range
            
            for (index,model) in tagsContainer.enumerated(){
                
                if let replacementRange = Range(replacementNsRange, in: textViewText)  {
                    
                    let nsRangesOfModel = textViewText.ranges(of: model)
                    
                    for nsRangeOfModel in nsRangesOfModel {
                        if let rangeOfModel = Range(nsRangeOfModel, in: textViewText) {
                            
                            let nsRange = NSRange(rangeOfModel, in: textViewText)
                            
                            
                            if replacementRange.overlaps(rangeOfModel) {
                                let attributedString = textView.attributedText.attributedSubstring(from: nsRange)
                                
                                var overlaps = false
                                
                                attributedString.enumerateAttribute(NSAttributedString.Key.foregroundColor, in: NSRange(location: 0, length: attributedString.length), options: NSAttributedString.EnumerationOptions.reverse) { (value, _, _) in
                                    if let value = value as? UIColor , value.hexString == self.tagColor.hexString {
                                        
                                        overlaps = true
                                        
                                    }
                                }
                                
                                if overlaps , let textRange = self.getTextRange(nsRange) {
                                    textView.replace(textRange, withText: "")
                                    return false
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
        
        return true
    }
    
}
