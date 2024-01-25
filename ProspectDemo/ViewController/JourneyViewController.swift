//
//  JourneyViewController.swift
//  ProspectDemo
//
//  Created by Mohit Kumar on 13/09/23.
//

import UIKit
import Toast_Swift
import OneSignalFramework

class JourneyViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnOnboarding: UIButton!
    @IBOutlet weak var btnReEngagement: UIButton!
    @IBOutlet weak var btnAbandonedCart: UIButton!
    @IBOutlet weak var btnPromotion: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblInfo.text = "Trigger a journey by clicking any of the following example. Click again to end the journey."
        lblInfo.numberOfLines = 0
        
        setBtnTheme(btn: btnOnboarding)
        setBtnTheme(btn: btnReEngagement)
        setBtnTheme(btn: btnAbandonedCart)
        setBtnTheme(btn: btnPromotion)
        
        refreshBtnState()
    }
    
    func setBtnTheme(btn: UIButton) {
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 6
    }
    
    func refreshBtnState() {
        setBtnState(btn: btnOnboarding, tag: TAG_ONBOARDING)
        setBtnState(btn: btnReEngagement, tag: TAG_ENGAGEMENT)
        setBtnState(btn: btnAbandonedCart, tag: TAG_ABANDONED_CART)
        setBtnState(btn: btnPromotion, tag: TAG_PROMOTION)
    }
    
    func setBtnState(btn: UIButton, tag: String) {
        let localOnboardingVal = UserDefaults.standard.bool(forKey: tag)
        if localOnboardingVal {
            btn.backgroundColor = .black.withAlphaComponent(0.8)
        } else {
            btn.backgroundColor = UIColor(named: "btnColor")
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onboardingBtnPressed(_ sender: UIButton) {
        self.inverseTagState(tag: TAG_ONBOARDING)
    }
    
    @IBAction func reEngagementBtnPressed(_ sender: UIButton) {
        self.inverseTagState(tag: TAG_ENGAGEMENT)
    }
    
    @IBAction func abandonedBtnPressed(_ sender: UIButton) {
        self.inverseTagState(tag: TAG_ABANDONED_CART)
    }
    
    @IBAction func promotionBtnPressed(_ sender: UIButton) {
        self.inverseTagState(tag: TAG_PROMOTION)
    }
    
    
    
    func inverseTagState(tag: String) {
        let localVal = UserDefaults.standard.bool(forKey: tag)
        if localVal {
            OneSignal.User.removeTag(tag)
            self.view.makeToast("Tag removed successfully.")
        } else {
            OneSignal.User.addTags([tag: "true"])
            self.view.makeToast("Tag saved successfully.")
        }
        UserDefaults.standard.set(!localVal, forKey: tag)
        
        self.refreshBtnState()
    }
}
