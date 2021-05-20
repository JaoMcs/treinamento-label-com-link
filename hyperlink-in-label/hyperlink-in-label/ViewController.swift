//
//  ViewController.swift
//  hyperlink-in-label
//
//  Created by João Marcos on 20/05/21.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var label: UILabel!
  
  var urlString = [String : NSRange]()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    label.text = "Prefeitura (nativo)\nNotícias (nativo)\nCidade (nativo)\nAgendamento de atendimento http://agendamento.serra.es.gov.br/\n"
    teste()
    
    label.isUserInteractionEnabled = true
    let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
    tapgesture.numberOfTapsRequired = 1
    label.addGestureRecognizer(tapgesture)

  }
  
  
  @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
    guard let text = label.text else { return }
    if let url = gesture.didTapAttributedTextInLabel(label: label, inRange: urlString) {
      print(url)
    }
  }

  func teste () {
    guard let input = label.text else {return}
    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

    for match in matches {
        guard let range = Range(match.range, in: input) else { continue }
        let url = String(input[range])
        print(url)
        urlString[url] = match.range
    }
  }
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: [String : NSRange] ) -> String? {

        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
      print(indexOfCharacter)
      
      for (key,value) in targetRange {
        if NSLocationInRange(indexOfCharacter, value) {
          return key
        }
      }
      return nil
    }
}
