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
        
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForRequest = TimeInterval(60)
        urlSessionConfiguration.timeoutIntervalForResource = TimeInterval(60)
        let databaseURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(AWSConstants.DATABASE_NAME, isDirectory: false)
        do {
            let appSyncClientConfig = try AWSAppSyncClientConfiguration.init(url: AWSConstants.APP_SYNC_ENDPOINT,
                               serviceRegion: AWSConstants.AWS_REGION,
                               userPoolsAuthProvider: MyCognitoUserPoolsAuthProvider(),
                               urlSessionConfiguration: urlSessionConfiguration,
                               databaseURL: databaseURL)
            AppSyncHelper.shared.appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncClientConfig)

            AppSyncHelper.shared.appSyncClient?.apolloClient?.cacheKeyForObject = { $0["id"] }
        } catch {
            print("Error in initializing the AppSync Client")
            print("Error: \(error)")
            UserDefaults.standard.set(nil, forKey: DeviceConstants.ID_TOKEN)
        }
    }
    
    /// Returns the app sync client.
    public func getAppSyncClient() -> AWSAppSyncClient? {
        if let client = AppSyncHelper.shared.appSyncClient {
            return client
        }
        return nil
    }
    
    public func getUserProfileByUsername(username: String, success: @escaping (ProfileModel) -> Void, failure: @escaping (NSError) -> Void) {
        let queryInput = GetUserProfileByUsernameQuery(username: username)
        var cachePolicy = CachePolicy.returnCacheDataAndFetch
        
        if !APPUtilites.isInternetConnectionAvailable() {
            cachePolicy = CachePolicy.returnCacheDataDontFetch
        }
        
        if appSyncClient != nil {
            appSyncClient?.fetch(query: queryInput, cachePolicy: cachePolicy, queue: DispatchQueue.global(qos: .background), resultHandler: { (result, error) in
                if error != nil {
                    failure(error! as NSError)
                } else {
                    var profileModel = ProfileModel()
                    if let error = result?.errors {
                        print("Error inside result")
                        failure(error[0] as NSError)
                        return
                    }
                    if let data = result?.data {
                        if let snapshot = data.snapshot["getUserProfileByUsername"] as? [Any?] {
                            if snapshot.count > 0 {
                                print("Number of profiles is greater than 0")
                                if let userProfile = snapshot[0] as? [String : Any?] {
                                    print("UserProfile is not nil")
                                    profileModel = ProfileModel(id: nil, username: userProfile["username"] as? String, mobileNumber: userProfile["mobileNumber"] as? String, name: userProfile["name"] as? String, gender: (userProfile["gender"] as? Gender).map { $0.rawValue }, dob: userProfile["dob"] as? String, profilePicId: userProfile["profilePicId"] as? String)
                                }
                            } else {
                                print("Number of profiles is 0")
                            }
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
    
    public func getUserProfile(userId: String, success: @escaping (ProfileModel) -> Void, failure: @escaping (NSError) -> Void) {
        let getQuery = GetUserProfileQuery(id: userId)
        print("getQuery.id: \(getQuery.id)")
        var cachePolicy = CachePolicy.returnCacheDataAndFetch
        if !APPUtilites.isInternetConnectionAvailable() {
            print("Internet Connection is not available")
            cachePolicy = .returnCacheDataDontFetch
        }
        if appSyncClient != nil {
            print("AppSyncClient is not nil")
                appSyncClient?.fetch(query: getQuery, cachePolicy: cachePolicy, queue: DispatchQueue.global(qos: .background), resultHandler: { (result, error) in
                    if error != nil {
                        failure(error! as NSError)
                    } else {
                        var profileModel = ProfileModel()
                        print("result: \(result)")
                        if let data = result?.data {
                            print("data: \(data)")
                            if let userProfile = data.snapshot["getUserProfile"] as? [String: Any?] {
                                profileModel = ProfileModel(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID), username: userProfile["username"] as? String, mobileNumber: userProfile["mobileNumber"] as? String, name: userProfile["name"] as? String, gender: (userProfile["gender"] as? Gender).map { $0.rawValue }, dob: userProfile["dob"] as? String, profilePicId: userProfile["profilePicId"] as? String)
                                success(profileModel)
                            } else {
                                self.appSyncClient?.fetch(query: getQuery, cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: DispatchQueue.global(qos: .background), resultHandler: { (result, error) in
                                    if error != nil {
                                        failure(error as! NSError)
                                        return
                                    } else {
                                        print("data.snapshot is nil from the cache")
                                        var profileModel = ProfileModel()
                                        print("result: \(result)")
                                        if let data = result?.data {
                                            print("data: \(data)")
                                            if let userProfile = data.snapshot["getUserProfile"] as? [String: Any?] {
                                                profileModel = ProfileModel(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID), username: userProfile["username"] as? String, mobileNumber: userProfile["mobileNumber"] as? String, name: userProfile["name"] as? String, gender: (userProfile["gender"] as? Gender).map { $0.rawValue }, dob: userProfile["dob"] as? String, profilePicId: userProfile["profilePicId"] as? String)
                                            } else {
                                                print("data.snapshot is nil from Server")
                                            }
                                        }
                                        success(profileModel)
                                    }
                                })
                            }
                        }
                    }
                })
        } else {
            APPUtilites.displayErrorSnackbar(message: "Error in the user session. Please login again")
        }
    }

    public func createVibe(vibe: VibeModel, success: @escaping (Bool) -> Void, failure: @escaping (NSError) -> Void) {
        let senderFsmComponentInput = FsmComponentInput(type: nil, category: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: vibe.from, id: nil, author: nil)
        let receiverFsmComponentnput = FsmComponentInput(type: nil, category: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: vibe.to, id: nil, author: nil)
        var userInputList = [FsmComponentInput]()
        userInputList.append(senderFsmComponentInput)
        userInputList.append(receiverFsmComponentnput)
        let userComponent = FsmComponent(exists: true, list: userInputList)
        var vibeComponents = [VibeComponentInput]()
        if vibe.isLetterPresent {
            print("Letter is present")
            let letterComponent = VibeComponentInput(ids: nil, sequence: nil, texts: [vibe.letter.text!], format: Format.text, globalSequence: 1)
            vibeComponents.append(letterComponent)
        }
        if vibe.isPhotosPresent {
            print("images are present")
            print("number of images: \(vibe.images.count)")
            let imagesComponent = VibeComponentInput(ids: APPUtilites.getVibeImageIds(images: vibe.images), sequence: nil, texts: APPUtilites.getVibeImageCaptions(images: vibe.images), format: Format.image, globalSequence: vibe.isLetterPresent ? 2 : 1)
            vibeComponents.append(imagesComponent)
        }
        
        let vibeComponentInput = FsmComponentInput(type: VibeTypesLocal.getVibeType(index: vibe.type), category: VibeCategories.getVibeCategory(index: vibe.category), isAnonymous: vibe.isSenderAnonymous, name: vibe.vibeName, vibeComponents: vibeComponents, comment: nil, mobileNumber: nil, id: nil, author: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)
        var list = [FsmComponentInput]()
        list.append(vibeComponentInput)
        let fsmInput = FsmInput(action: Action.createVibe, users: userComponent, vibes: FsmComponent(exists: true, list: list), hails: FsmComponent(exists: false))
        let mutation = TriggerFsmMutation(input: fsmInput, userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)
        
        if appSyncClient != nil {
            appSyncClient?.perform(mutation: mutation, queue: DispatchQueue.global(qos: .background), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
                print("result: \(result)")
                if error != nil {
                    failure(error! as NSError)
                } else if result?.errors == nil {
                    success(true)
                } else {
                    print(result?.errors)
                    success(false)
                }
            })
        } else {
            DispatchQueue.main.async {
                APPUtilites.displayErrorSnackbar(message: "Error in user session. Please login again")
            }
        }
    }

    public func createUserProfile(profile: ProfileModel, success: @escaping (Bool) -> Void, failure: @escaping (NSError) -> Void) {
        let profileInput = CreateUserProfileInput.init(id: profile.getId()!, mobileNumber: profile.getMobileNumber()!, username: profile.getUsername()!, name: profile.getName(), dob: profile.getDob()?.description, gender: profile.getGender().map { Gender(rawValue: $0) }! ?? Gender(rawValue: "Male"), profilePicId: profile.getProfilePicId())
        
        let createQuery = CreateUserProfileMutation(input: profileInput)
        if appSyncClient == nil {
            APPUtilites.displayErrorSnackbar(message: "Error in the user session. Please login again")
        } else {
            appSyncClient?.perform(mutation: createQuery, queue: DispatchQueue.global(qos: .background), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
                if error != nil {
                    failure(error! as NSError)
                } else {
                    if result?.errors == nil {
                        success(true)
                    } else {
                        success(false)
                    }
                }
            })
        }
    }
    
    func updateUserProfile(profile: ProfileModel, success: @escaping (Bool) -> Void, failure: @escaping (NSError) -> Void) {
        
        let updateInput = UpdateUserProfileInput(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, username: profile.getUsername(), name: profile.getName(), dob: profile.getDob(), gender: profile.getGender().map { Gender(rawValue: $0) }! ?? Gender(rawValue: "Male"), profilePicId: profile.getProfilePicId())
        let updateQuery = UpdateUserProfileMutation(input: updateInput)
        
        appSyncClient?.perform(mutation: updateQuery, queue: DispatchQueue.global(qos: .background), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
            if error != nil {
                failure(error! as NSError)
            } else {
                if result?.errors == nil {
                    success(true)
                } else {
                    print("result.errors in updateUserProfile: \(result?.errors)")
                    success(false)
                }
            }
        })
    }
    
    func updateUserProfilePicture(profilePictureId: String, success: @escaping (Bool) -> Void, failure: @escaping (NSError) -> Void) {
        var updateInput = UpdateUserProfileInput(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, username: nil, name: nil, dob: nil, gender: nil, profilePicId: profilePictureId)
        if profilePictureId == "" {
            updateInput.profilePicId = nil
        }
        let updateQuery = UpdateUserProfileMutation(input: updateInput)
        appSyncClient?.perform(mutation: updateQuery, queue: DispatchQueue.global(qos: .background), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
            if error != nil {
                failure(error! as NSError)
            } else {
                if result?.errors == nil {
                    success(true)
                } else {
                    print("result.errors in updateUserProfile: \(result?.errors)")
                    success(false)
                }
            }
        })
    }
}

class MyCognitoUserPoolsAuthProvider: AWSCognitoUserPoolsAuthProvider {
    
    // background thread - asynchronous
    func getLatestAuthToken() -> String {
        print("Inside getLatestAuthToken")
        var token: String? = nil
        if let tokenString = UserDefaults.standard.string(forKey: DeviceConstants.ID_TOKEN) {
            token = tokenString
            return token!
        }
        return token!
    }
}
