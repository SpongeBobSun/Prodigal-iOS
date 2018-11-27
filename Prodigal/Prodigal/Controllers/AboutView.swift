//
//  TickableScrollView.swift
//  Prodigal
//

/**   Copyright 2017 Bob Sun
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *  Created by bob.sun on 25/04/2017.
 *
 *          _
 *         ( )
 *          H
 *          H
 *         _H_ 
 *      .-'-.-'-.
 *     /         \
 *    |           |
 *    |   .-------'._
 *    |  / /  '.' '. \
 *    |  \ \ @   @ / /
 *    |   '---------'
 *    |    _______|
 *    |  .'-+-+-+|              I'm going to build my own APP with blackjack and hookers!
 *    |  '.-+-+-+|
 *    |    """""" |
 *    '-.__   __.-'
 *         """
 **/

import Foundation
import UIKit

class AboutView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonContact: UIButton!
    @IBOutlet weak var icons8Text: UITextView!
    
    @IBOutlet weak var buttonSource: UIButton!
    static func viewFromNib() -> AboutView {
        let bundle = Bundle.init(for: self)
        return (bundle.loadNibNamed("AboutView", owner: self, options: nil)?.first as? AboutView)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        icons8Text.isEditable = false
        icons8Text.dataDetectorTypes = .link
        self.backgroundColor = ThemeManager.currentTheme.backgroundColor
        self.scrollView.backgroundColor = UIColor.clear
    }
    
    func scrollDown() {
        let current = scrollView.contentOffset.y
        let height = scrollView.contentSize.height - scrollView.bounds.size.height
        var to = current + 30
        if to >= height  {
            to = height
        }
        scrollView.scrollRectToVisible(CGRect.init(x: 0, y: to, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height), animated: true)
    }
    func scrollUp() {
        let current = scrollView.contentOffset.y
        var to = current - 30
        if to < 0 {
            to = 0
        }
        scrollView.scrollRectToVisible(CGRect.init(x: 0, y: to, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height), animated: true)
    }
    @IBAction func goTheme(_ sender: Any) {
        let url = URL(string: "https://github.com/SpongeBobSun/Prodigal-iOS/blob/master/Theme.md")
        UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    @IBAction func sendMail(_ sender: Any) {
        let url = URL(string: "mailto:bobsun@outlook.com")
        UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    @IBAction func goGitHub(_ sender: Any) {
        let url = URL(string: "https://github.com/SpongeBobSun/Prodigal-iOS")
        UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}

extension AboutView: WheelViewTickDelegate {
    func onNextTick() {
        scrollDown()
    }
    
    func onPreviousTick() {
        scrollUp()
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
