//
//  ViewController.swift
//  ProspectDemo
//
//  Created in collaboration with William Shepherd & Dom Bartenope on 25/01/22.
//

import UIKit

import ActivityKit
import OneSignalFramework

class ViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnJourney: UIButton!
    @IBOutlet weak var btnLA: UIButton!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBtnTheme(btn: btnSettings)
        self.setBtnTheme(btn: btnJourney)
        self.setBtnTheme(btn: btnLA)

    }
    
    
    func setBtnTheme(btn: UIButton) {
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 6
    }
    
    @IBAction func onBtnSettings(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func journeyBtnPressed(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "JourneyViewController") as? JourneyViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func StartLiveActity(_ sender: UIButton) {
        let attributes = LiveActivityAttributes(name: "Switzerland vs. Germany", homeTeam: "Switzerland", awayTeam: "Germany", fifaLogo: "fifa_logo", sponsorLogo: "cocacola_logo")
        let contentState = LiveActivityAttributes.ContentState(homeScore: 6, awayScore: 1)
        let activityContent = ActivityContent(state: contentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)

        do {

                let activity = try Activity<LiveActivityAttributes>.request(

                        attributes: attributes,
                        contentState: contentState,
                        pushType: .token)

                Task {

                    for await data in activity.pushTokenUpdates {

                        let myToken = data.map {String(format: "%02x", $0)}.joined()
                        OneSignal.LiveActivities.enter("my_activity_id", withToken: myToken)
                    }
                }

            } catch (let error) {
                print(error.localizedDescription)
            }
    }
    
}
    
