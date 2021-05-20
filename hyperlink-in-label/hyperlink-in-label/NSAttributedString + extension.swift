//
//  NSAttributedString + extension.swift
//  hyperlink-in-label
//
//  Created by João Marcos on 20/05/21.
//

import Foundation

extension NSAttributedString {
  
  static func makeHyperLink(for paths: [String], in string: String) -> NSAttributedString {
    let nsString = NSString(string: string)
    let attributedString = NSMutableAttributedString(string: string)
    for path in paths {
      let substringRange = nsString.range(of: path)
      attributedString.addAttribute(.link, value: path, range: substringRange)
    }
    return attributedString
  }
  
  
  
}
