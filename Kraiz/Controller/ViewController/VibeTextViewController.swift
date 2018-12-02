//
//  VibeTextViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 01/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeTextViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pageController: UIPageViewController!
    var controllers = [UIViewController]()
    var vibeModel = VibeModel()
    var isDismissOverlayVisible = false
    
    var imagesSegue = "gotoImages"
    var overlayView: UIView = UIView()
    
    let string0 : String = "kdhfkdh kdfkdfh kdhfkdhf"
    let string1 : String = "You can use Amazon Pinpoint to analyze funnels, which visualize how many users complete each of a series of steps in your app. For example, the series of steps in a funnel can be a conversion process that results in a purchase (as in a shopping cart), or some other intended user behavior.\nBy monitoring funnels, you can assess whether conversion rates have improved because of"
    let string2 : String = "This example chart shows the percentage of users who complete each step in the process of updating an app. By comparing the values between columns, you can determine the drop off rates between steps. In this example, there is a 35% drop off between users who receive a notification and those who start an app session. Then there is a 19% drop off between users who start a session and those who open the app settings page.\nTo create a funnel, you specify each event that is part of the conversion process you want to analyze. Your app reports these events to Amazon Pinpoint as long as it integrates Amazon Mobile Analytics through one of the supported AWS SDKs. If your app is a project in AWS Mobile Hub, you integrate Amazon Mobile Analytics by enabling the App Analytics feature in the AWS Mobile Hub console."
    
    let string3 : String = "Hitler was born in Austria—then part of Austria-Hungary—and was raised near Linz. He moved to Germany in 1913 and was decorated during his service in the German Army in World War I. In 1919, he joined the German Workers' Party (DAP), the precursor of the NSDAP, and was appointed leader of the NSDAP in 1921. In 1923, he attempted to seize power in a failed coup in Munich and was imprisoned. While in jail he dictated the first volume of his autobiography and political manifesto Mein Kampf ('My Struggle'). \nAfter his release from prison in 1924, Hitler gained popular support by attacking the Treaty of Versailles and promoting Pan-Germanism, anti-semitism and anti-communism with charismatic oratory and Nazi propaganda. He frequently denounced international capitalism and communism as being part of a Jewish conspiracy."
    
    let string4 : String = "Hitler sought Lebensraum ('living space') for the German people in Eastern Europe and his aggressive foreign policy is considered to be the primary cause of the outbreak of World War II in Europe. He directed large-scale rearmament and on 1 September 1939 invaded Poland, resulting in Britain and France declaring war on Germany. In June 1941, Hitler ordered an invasion of the Soviet Union. By the end of 1941, German forces and the European Axis powers occupied most of Europe and North Africa. In December 1941, he formally declared war on the United States, bringing them directly into the conflict. Failure to defeat the Soviets and the entry of the United States into the war forced Germany onto the defensive and it suffered a series of escalating defeats. In the final days of the war during the Battle of Berlin in 1945, he married his long-time lover Eva Braun. Less than two days later on 30 April 1945, the two committed suicide to avoid capture by the Soviet Red Army and their corpses were burned."
    
    let string5 : String = "Under Hitler's leadership and racially motivated ideology, the Nazi regime was responsible for the genocide of at least 5.5 million Jews and millions of other victims whom he and his followers deemed Untermenschen (sub-humans) or socially undesirable. Hitler and the Nazi regime were also responsible for the killing of an estimated 19.3 million civilians and prisoners of war. In addition, 29 million soldiers and civilians died as a result of military action in the European theatre. The number of civilians killed during the Second World War was unprecedented in warfare and the casualties constituted the deadliest conflict in human history."
    //    let string5 : String = ""
    
    var allText : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textView : UITextView = UITextView(frame: CGRect(x: view.frame.width / 20, y: view.frame.height / 15, width: 4 * view.frame.width / 5, height: 9 * view.frame.height / 10))
        textView.isEditable = false
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = true

        switch(view.frame.height) {
            case DeviceConstants.IPHONEXR_HEIGHT : textView.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 32.0)
                break
            case DeviceConstants.IPHONEX_HEIGHT : textView.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 23.0)
                break
            case DeviceConstants.IPHONE7PLUS_HEIGHT: textView.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 23.0)
                break
            case DeviceConstants.IPHONE7_HEIGHT: textView.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 30.0)
                break
            case DeviceConstants.IPHONE5S_HEIGHT: textView.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 18.0)
                break
            default:
                textView.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 24.0)
                break;
        }
        
        var words : [Substring] = getWords(text: "")
        if vibeModel.isLetterPresent {
            words = getWords(text: vibeModel.letter.text!)
        }
        var pageTexts = [String]()
        
        var upperLimit = words.count
        var lowerLimit = 0
        var singlePageText : String = ""
        var singlePageWords : [Substring] = [Substring]()
        var mid : Int = (upperLimit + lowerLimit) / 2
        
        textView.text = words.joined(separator: " ")
        if textView.frame.height > textView.contentSize.height {
            pageTexts.append(words.joined(separator: " "))
        } else {
            while (true) {
                while(lowerLimit <= upperLimit) {
                    mid = (upperLimit + lowerLimit) / 2
                    singlePageWords = Array(words[0...mid])
                    singlePageText = singlePageWords.joined(separator: " ")
                    textView.text = singlePageText
                    if textView.contentSize.height > textView.frame.height {
                        upperLimit = mid - 1
                    } else {
                        lowerLimit = mid + 1
                    }
                }
                pageTexts.append(singlePageText)
                let count = words.count
                if count - mid == 1 {
                    break
                } else if count <= 0 {
                    break
                } else {
                    words = Array(words[(mid+1)...(count - 1)])
                    lowerLimit = 0
                    upperLimit = words.count - 1
                }
            }
        }
        
        pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        
        addChild(pageController)
        view.addSubview(pageController.view)
        
        let views = ["pageController": pageController.view] as [String: AnyObject]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
        
        for i in 0 ... pageTexts.count - 1 {
            let vc = UIViewController()
            vc.view.isUserInteractionEnabled = true

            let imageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: vc.view.frame.width, height: vc.view.frame.height))
            imageView.image = UIImage(named: VibeTextBackgrounds.TEXT_BACKGROUNDS[vibeModel.letter.background!])
            imageView.isUserInteractionEnabled = true
            vc.view.addSubview(imageView)
            let textView1 : UITextView = UITextView(frame: CGRect(x: view.frame.width / 10, y: view.frame.height / 15, width: 4 * view.frame.width / 5, height: 9 * view.frame.height / 10))
            textView1.isEditable = false
            textView1.isSelectable = false
            textView1.backgroundColor = UIColor.clear
            textView1.textColor = UIColor(displayP3Red: 10/255, green: 21/255, blue: 53/255, alpha: 1.0)
            textView1.isScrollEnabled = false
            textView1.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeDismissViewStatus))
            textView1.addGestureRecognizer(tapGesture)
            switch(vc.view.frame.height) {
            case DeviceConstants.IPHONEXR_HEIGHT : textView1.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 32.0)
                break
            case DeviceConstants.IPHONEX_HEIGHT : textView1.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 23.0)
                break
            case DeviceConstants.IPHONE7PLUS_HEIGHT: textView1.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 23.0)
                break
            case DeviceConstants.IPHONE7_HEIGHT: textView1.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 30.0)
                break
            case DeviceConstants.IPHONE5S_HEIGHT: textView1.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 18.0)
                break
            default:
                textView1.font = UIFont(name: VibeTextBackgrounds.TEXT_FONTS[vibeModel.letter.background!], size: 24.0)
                break;
            }
            textView1.textColor = VibeTextBackgrounds.FONT_COLORS[vibeModel.letter.background!]
            textView1.text = pageTexts[i]
            print("textView1.text for \(i + 1): \(textView1.text)")
            
            vc.view.addSubview(textView1)
            
//            let closebuttonClick = UITapGestureRecognizer(target: self, action: #selector(self.onCloseClick))
//
//            let closebtn : UIButton = UIButton(frame: CGRect(x: 40, y: 40, width: 100, height: 100))
//            closebtn.backgroundColor = UIColor.clear
//            closebtn.setTitle("X", for: .normal)
//            closebtn.addGestureRecognizer(closebuttonClick)
//            vc.view.addSubview(closebtn)
            
//            if i == pageTexts.count - 1 {
//                let nextbuttonClick = UITapGestureRecognizer(target: self, action: #selector(self.onNextClick))
                
//                let nextbtn : UIButton = UIButton(frame: CGRect(x: 9 * vc.view.frame.width / 10, y: vc.view.frame.height / 4, width: 30, height: vc.view.frame.height / 2))
//                nextbtn.backgroundColor = UIColor.clear
//                nextbtn.setTitle("->", for: .normal)
//                nextbtn.addGestureRecognizer(nextbuttonClick)
//                vc.view.addSubview(nextbtn)
//            }
            controllers.append(vc)
        }
        
        pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
        overlayView = createOverlayView()
    }
    
    @objc func onCloseClick() {
        print("Clicked on the close button")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onNextClick() {
        performSegue(withIdentifier: imagesSegue, sender: self)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController) {
            if index > 0 {
                return controllers[index - 1]
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            } else {
                return nil
            }
        }
        
        return nil
    }

    func createOverlayView() -> UIView {
        let overlayView = UIView(frame: CGRect(x: 0, y: -view.frame.height / 10, width: view.frame.width, height: view.frame.height / 10))
        overlayView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        let dismissButton = UIButton(frame: CGRect(x: overlayView.frame.width / 20, y: overlayView.frame.height / 2 - 5, width: overlayView.frame.height / 2, height: overlayView.frame.height / 2))
        dismissButton.backgroundColor = UIColor.white
        dismissButton.setTitle("X", for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCloseClick))
        dismissButton.addGestureRecognizer(tapGesture)
        dismissButton.setTitleColor(UIColor.black, for: .normal)
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        overlayView.addSubview(dismissButton)
        view.addSubview(overlayView)
        overlayView.isHidden = true
        return overlayView
    }
    
    @objc func changeDismissViewStatus() {
        UIView.animate(withDuration: 0.2, animations: {
            if self.isDismissOverlayVisible {
                self.isDismissOverlayVisible = false
                self.overlayView.frame.origin.y = -self.overlayView.frame.height
            } else {
                self.isDismissOverlayVisible = true
                self.overlayView.isHidden = false
                self.overlayView.frame.origin.y = 0
            }
        }) { (success) in
            if !self.isDismissOverlayVisible {
                self.overlayView.isHidden = true
            }
        }
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    func randomColor() -> UIColor {
        return UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1)
    }
    
    func getWords(text : String) -> [Substring] {
        let words : [Substring] = text.split(separator: " ")
        return words
    }
}
