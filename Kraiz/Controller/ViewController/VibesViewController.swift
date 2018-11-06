//
//  StoriesViewController.swift
//  StoryFi
//
//  Created by Kumar Agarwal, Kanhai on 30/06/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//
//  Class to Show all the Vibes for the user.

import UIKit

class VibesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var vibesTable: UITableView!
    @IBOutlet weak var topBarView: UIView!
    
    let IS_RECEIVER_COLOR = UIColor(displayP3Red: 230/255, green: 158/255, blue: 55/255, alpha: 1.0)
    let IS_SENDER_COLOR = UIColor(displayP3Red: 46/255, green: 66/255, blue: 100/255, alpha: 1.0)
    
    var connections = [ConnectionModel]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("VibesTableViewCell", owner: self, options: nil)?.first as! VibesTableViewCell
        
        cell.usernameField.text = connections[indexPath.row].username!
        cell.profileImage.image = UIImage(named: "Disha")
        cell.timestampField.text = connections[indexPath.row].timestamp
        cell.vibeNameField.text = connections[indexPath.row].vibeName
        
        let componentsPresent = getImagesForComponents(connection: connections[indexPath.row])
        
        if connections[indexPath.row].isUserSender! {
            cell.vibeNameContainer.backgroundColor = IS_SENDER_COLOR
        } else {
            cell.vibeNameContainer.backgroundColor = IS_RECEIVER_COLOR
        }
        
        for i in 0..<componentsPresent.count {
            if (i == 0) {
                cell.vibeComponent1.image = UIImage(named: componentsPresent[i])
            }
            if (i == 1) {
                cell.vibeComponent2.image = UIImage(named: componentsPresent[i])
            }
            if (i == 2) {
                cell.vibeComponent3.image = UIImage(named: componentsPresent[i])
            }
            if (i == 3) {
                cell.vibeComponent4.image = UIImage(named: componentsPresent[i])
            }
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for i in 0..<10 {
            connections.append(ConnectionModel(username: "username_\(i + 1)", vibeName: "vibe \(i + 1)", isLetterPresent: true, isPhotosPresent: true, isVideoPresent: true, isAudioPresent: true, timestamp: "10/11/2018", isUserSender: i % 2 == 0 ? true : false))
        }
        
//        AppSyncHelper.shared.getUserConnection(userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, mobileNumber: UserDefaults.standard.string(forKey: DeviceConstants.MOBILE_NUMBER)!, success: {
//            print("**************************************************")
//            print("Successfully fetched the user connection")
//        }) { (error) in
//            print("**************************************************")
//            print("Error in fetching the user connection")
//            print(error)
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        print("row selected: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        vibesTable.delegate = self
        vibesTable.dataSource = self
        
        vibesTable.separatorStyle = .singleLine
        vibesTable.separatorColor = UIColor.gray
        vibesTable.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        let topBarBackground = UIView(frame: CGRect(x: 0, y: topBarView.frame.height, width: topBarView.frame.width, height: 1))
        topBarBackground.backgroundColor = DeviceConstants.DEFAULT_SEPERATOR_COLOR
        topBarView.addSubview(topBarBackground)
    }
    
    func getImagesForComponents(connection: ConnectionModel) -> [String] {
        var componentImages = [String]()
        if (connection.isLetterPresent!) {
            componentImages.append("letter-on-all-vibes")
        }
        if (connection.isPhotosPresent!) {
            componentImages.append("photos-on-all-vibes")
        }
        if (connection.isVideoPresent!) {
            componentImages.append("video-on-all-vibes")
        }
        if (connection.isAudioPresent!) {
            componentImages.append("audio-on-all-vibes")
        }
        return componentImages
    }
}
