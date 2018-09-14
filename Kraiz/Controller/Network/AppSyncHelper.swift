//
//  DbHelper.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 09/09/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import AWSAppSync

class AppSyncHelper {
    
    private var appSyncClient: AWSAppSyncClient?
    
    static let shared = AppSyncHelper()
    
    private init() {
    }
    
    /// Sets the app sync client by fetching the idToken from the Cognito user session.
    public func setAppSyncClient() {
        do {
            let appSyncClientConfig = try AWSAppSyncClientConfiguration.init(url: AWSConstants.APP_SYNC_ENDPOINT, serviceRegion: AWSConstants.AWS_REGION, userPoolsAuthProvider: MyCognitoUserPoolsAuthProvider())
            AppSyncHelper.shared.appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncClientConfig)
        } catch {
            print("Error: \(error)")
        }
    }
    
    /// Returns the app sync client.
    public func getAppSyncClient() -> AWSAppSyncClient? {
        if let client = AppSyncHelper.shared.appSyncClient {
            return client
        }
        return nil
    }
    
    public func getUserProfile(userId: String, success: @escaping (ProfileModel) -> Void, failure: @escaping (NSError) -> Void) {
        let getQuery = GetUserProfileQuery(id: userId)
        print("getQuery.id: \(getQuery.id)")
        let queue = DispatchQueue.main
        if appSyncClient != nil {
            print("AppSyncClient is not nil")
            appSyncClient?.fetch(query: getQuery, cachePolicy: CachePolicy.returnCacheDataElseFetch, queue: queue, resultHandler: { (result, error) in
                if error != nil {
                    failure(error! as NSError)
                } else {
                    var profileModel = ProfileModel()
                    if let data = result?.data {
                        print("data: \(data)")
                        if let userProfile = data.snapshot["getUserProfile"] as? [String: Any?] {
                            profileModel = ProfileModel(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID), username: userProfile["username"] as? String, mobileNumber: userProfile["mobileNumber"] as? String, name: userProfile["name"] as? String, gender: userProfile["gender"] as? String, dob: userProfile["dob"] as? String, profilePicUrl: userProfile["profilePicUrl"] as? String)
                        } else {
                            print("data snapshot is nil")
                        }
                    }
                    success(profileModel)
                }
            })
        } else {
            APPUtilites.displayErrorSnackbar(message: "Error in the user session. Please login again")
        }
    }
    
    public func createUserProfile(profile: ProfileModel, success: @escaping (Bool) -> Void, failure: @escaping (NSError) -> Void) {
        print("*****************************************************************")
        print("Inside createUserProfile. profile:")
        print(profile.getId())
        print(profile.getUsername())
        print(profile.getName())
        print(profile.getMobileNumber())
        print(profile.getGender())
        print(profile.getProfilePicUrl())
        
        let profileInput = CreateUserProfileInput.init(id: profile.getId()!, mobileNumber: profile.getMobileNumber()!, username: profile.getUsername()!, name: profile.getName(), dob: profile.getDob()?.description, gender: profile.getGender().map { Gender(rawValue: $0) }, profilePicUrl: profile.getProfilePicUrl())
        
        let createQuery = CreateUserProfileMutation(input: profileInput)
        if appSyncClient == nil {
            APPUtilites.displayErrorSnackbar(message: "Error in the user session. Please login again")
        } else {
            appSyncClient?.perform(mutation: createQuery, queue: DispatchQueue.main, optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
                if error != nil {
                    failure(error! as NSError)
                } else {
                    print("result: \(result)")
                    print("result.data: \(result?.data)")
                    if result?.errors == nil {
                        print("result?.data?.snapshot: \(result?.data?.snapshot)")
                        success(true)
                    } else {
                        success(false)
                    }
                }
            })
        }
    }
}

class MyCognitoUserPoolsAuthProvider: AWSCognitoUserPoolsAuthProvider {
    
    // background thread - asynchronous
    func getLatestAuthToken() -> String {
        var token: String? = nil
        CognitoHelper.shared.getUserPool()?.currentUser()?.getSession().continueOnSuccessWith(block: { (task) -> Any? in
            token = task.result!.idToken!.tokenString
            return nil
        }).waitUntilFinished()
        return token!
    }
}
