//
//  NSAttributedString+Helper.swift
//  FSInvestor
//
//  Created by Yiming Dong on 21/10/18.
//  Copyright © 2018 Funding Societies. All rights reserved.
//

import UIKit

struct AttributedStringModel {
    var string: String
    var foregroundColor: UIColor?
    
    init(string: String, foregroundColor: UIColor? = nil) {
        self.string = string
        self.foregroundColor = foregroundColor
    }
    
    var attributes: [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let foregroundColor = foregroundColor {
            attributes[NSAttributedStringKey.foregroundColor] = foregroundColor
        }
        return attributes
    }
    
    var attributedString: NSAttributedString {
        return NSAttributedString(string: string, attributes: attributes)
    }
}

extension NSAttributedString {
    
    static func createFrom(models: [AttributedStringModel]) -> NSAttributedString {
        return models.reduce(NSAttributedString(string: "")) {$0.concat($1.attributedString)}
    }
    
    static func createFrom(model: AttributedStringModel) -> NSAttributedString {
        return model.attributedString
    }
    
    func concat(_ attrbutedString: NSAttributedString) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        result.append(attrbutedString)
        return result
    }
    
    func addSub(model: AttributedStringModel) -> NSAttributedString {
        guard let range = string.range(of: model.string) else {return self}
        
        let startPos = string.distance(from: string.startIndex, to: range.lowerBound)
        let nsRange = NSRange(location: startPos, length: model.string.count)
        
        let mutable = NSMutableAttributedString(attributedString: self)
        mutable.addAttributes(model.attributes, range: nsRange)
        
        return mutable
    }
}
