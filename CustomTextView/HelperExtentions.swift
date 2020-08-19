//
//  HelperExtentions.swift
//  CustomTextView
//
//  Created by Karan Karthic on 19/08/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import UIKit


extension String
{
    func getSubString(from range:NSRange) -> String
    {
        let start = self.index(self.startIndex, offsetBy: range.location)
        let end = self.index(start, offsetBy: range.length)
        let subString = String(self[start..<end])
        return subString
    }
    
    func indices(of string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
    
    func ranges(of string: String) -> [NSRange] {
        var ranges = [NSRange]()
        for index in self.indices(of: string) {
            let range = NSRange.init(location: index, length: string.count)
            ranges.append(range)
        }
        return ranges
    }
}

extension UIView{
    
    var isRightToLeft: Bool
    {
        return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
    }
}

extension Substring {
    func suffixUptoSpace(fromIndex: String.Index) -> Substring {
        return suffix(from: fromIndex).prefix { char -> Bool in
            return char != " "
        }
    }
}

extension StringProtocol {
    func nsRange(from range: Range<Index>) -> NSRange {
        return .init(range, in: self)
    }
}

extension Array {
    
    mutating func remove(at indexs: [Int]) {
        guard self.isEmpty == false else{ return }
        let newIndexs = indexs.reversed()
        newIndexs.forEach {
            guard $0 < count, $0 >= 0 else { return }
            remove(at: $0)
        }
    }
    
}

extension UIColor {
    var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0,0,0,0)
    }
    
    var hexString: String {
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(rgbComponents.red * 255)), lroundf(Float(rgbComponents.green * 255)), lroundf(Float(rgbComponents.blue * 255)), lroundf(Float(rgbComponents.alpha * 255)) )
    }
    
    var alphaComponent: CGFloat {
        return rgbComponents.alpha * 255
    }
}
