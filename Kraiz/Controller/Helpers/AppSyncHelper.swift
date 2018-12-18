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
    
    /// Fetch the UserProfile by Username. Using returnCacheElseFetch for faster fetch.
    /// - Parameters:
    ///     - username: Username.
    ///     - success: Success Closure if the Get query succeeds.
    ///     - failure: Failure Closure if the Get query fails.
    public func getUserProfileByUsername(username: String, success: @escaping (ProfileModel) -> Void, failure: @escaping (NSError) -> Void) {
        let queryInput = GetUserProfileByUsernameQuery(username: username)
        var cachePolicy = CachePolicy.returnCacheDataElseFetch
        
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
    
    /// Fetch the UserProfile by UserID. Using returnCacheElseFetch for faster fetch.
    /// - Parameters:
    ///     - userId: UserID.
    ///     - success: Success Closure if the Get query succeeds.
    ///     - failure: Failure Closure if the Get query fails.
    public func getUserProfile(userId: String, success: @escaping (ProfileModel) -> Void, failure: @escaping (NSError) -> Void) {
        let getQuery = GetUserProfileQuery(id: userId)
        print("getQuery.id: \(getQuery.id)")
        var cachePolicy = CachePolicy.returnCacheDataElseFetch
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

    /// Gets the User Channel.
    /// The channel will contain the following:
    ///     1. New Vibes which have been sent to the user.
    ///     2. Profiles which have been updated by other Users.
    public func getUserChannel() {
        print("=======> Inside getUserChannel")
        let getChannelQuery = GetUserChannelViewQuery()
        let cachePolicy = CachePolicy.fetchIgnoringCacheData

        if appSyncClient != nil {
            appSyncClient?.fetch(query: getChannelQuery, cachePolicy: cachePolicy, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated), resultHandler: { [weak self] (result, error) in
                if error != nil {
                    print("========> error in getUserChannel: \(error)")
                } else if let data = result?.data {
                    if let userChannel = data.snapshot["getUserChannel"] as? [String: Any] {
                        var liveBucketVibeIds = [GraphQLID]()
                        var liveBucketProfileIds = [GraphQLID]()
                        var nonVibeProfiles = userChannel["profiles"]
                        var lastPublicVibeFetchTime = userChannel["lastPublicVibeFetchTime"]
                        if let userVibesOuter = userChannel["userVibes"] as? [String: Any] {
                            if let vibesInner = userVibesOuter["userVibes"] {
                                let allVibes = vibesInner as! [Any?]
                                print("allVibes.count: \(allVibes.count)")
                                for i in 0 ..< allVibes.count {
                                    if let vibe = allVibes[i] as? [String : Any] {
                                        liveBucketVibeIds.append((vibe["vibeId"] as? String)!)
                                        let vibeDataForCache = VibeDataEntity()
                                        vibeDataForCache.setIsSeen(vibe["seen"] as! Bool)
                                        vibeDataForCache.setReach(vibe["reach"] as! Int)
                                        vibeDataForCache.setVibeId(vibe["vibeId"] as? String)
                                        vibeDataForCache.setVersion(vibe["version"] as? String)
                                        vibeDataForCache.setIsSender(vibe["isSender"] as! Bool)
                                        vibeDataForCache.setVibeName(vibe["vibeName"] as? String)
                                        vibeDataForCache.setProfileId(vibe["profileId"] as? String)
                                        vibeDataForCache.setIsAnonymous(vibe["isAnonymous"] as! Bool)
                                        vibeDataForCache.setUpdatedTime(vibe["updatedTime"] as! Int)
                                        vibeDataForCache.setVibeTypeGsiPK(vibe["vibeTypeGsiPk"] as? String)
                                        vibeDataForCache.setVibeTypeTagGsiPK(vibe["vibeTypeTagGsiPk"] as? String)
                                        CacheHelper.shared.writeVibeToCache(vibeDataForCache)
                                    }
                                }
                            }
                            if let hailsOuter = userVibesOuter["hails"] {
                                print("hails: \(hailsOuter)")
                                let hails = hailsOuter as! [Any]
                                for i in 0 ..< hails.count {
                                    if let hail = hails[i] as? [String : Any] {
                                        let hailForCache = HailsEntity()
                                        hailForCache.setId(id: hail["id"] as! String)
                                        hailForCache.setAuthor(author: hail["author"] as! String)
                                        hailForCache.setVibeId(vibeId: hail["vibeId"] as! String)
                                        hailForCache.setComment(comment: hail["comment"] as! String)
                                        hailForCache.setCreatedAt(createdAt: hail["createdAt"] as! Int)
                                        CacheHelper.shared.writeHailToCache(hailForCache)
                                    }
                                }
                            }
                            if let vibeProfilesOuter = userVibesOuter["profiles"] {
                                let allVibeProfiles = vibeProfilesOuter as! [Any]
                                
                                for i in 0 ..< allVibeProfiles.count {
                                    if let profile = allVibeProfiles[i] as? [String : Any] {
                                        print(profile)
                                        
                                        let cacheProfile = ProfileEntity()
                                        cacheProfile.setId(profile["id"] as? String)
                                        cacheProfile.setDob(profile["dob"] as? String)
                                        cacheProfile.setName(profile["name"] as? String)
                                        cacheProfile.setUsername(profile["username"] as? String)
                                        cacheProfile.setMobileNumber(profile["mobileNumber"] as? String)
                                        cacheProfile.setProfilePicId(profile["profilePicId"] as? String)
                                        CacheHelper.shared.writeProfileToCache(cacheProfile)
                                    }
                                }
                            }
                        }
                        self!.deleteUserChannelUpdates(liveBucketVibeIds: liveBucketVibeIds, liveBucketProfileIds: liveBucketProfileIds)
                    }
                }
            })
        }
    }

    /// Gets the User Vibes based on the Vibe Tag and Vibe Type.
    /// Gets only the requested number of Vibes with the after token not null.
    /// If the after token is null, then there are no more Vibes to be fetched.
    /// - Parameters:
    ///     - vibeTag: Vibe Category.
    ///     - vibeType: Public or Private.
    ///     - first: Number of vibes to be fetched in each of the passes.
    ///     - after: The next token for fetching the next set of vibes. If it is null, then don't fetch.
    func getUserVibesPaginated(requestedVibeTag: VibeTag, requestedVibeType: VibeType, first: Int, after: String?) {
        print("==========> inside getUserVibesPaginated")
        let query = GetPaginatedUserVibesQuery(vibeTag: requestedVibeTag, vibeType: requestedVibeType, first: first, after: after != nil ? after! : nil)
        let cachePolicy = CachePolicy.fetchIgnoringCacheData
        if appSyncClient == nil {
            setAppSyncClient()
        }
        appSyncClient?.fetch(query: query, cachePolicy: cachePolicy, queue: DispatchQueue.global(qos: DispatchQoS.userInteractive.qosClass), resultHandler: { [weak self] (result, error) in
            if error != nil {
                print("error in the query: \(error)")
                return
            }
            if let data = result?.data {
                print("data for VibeTag: \(requestedVibeTag)")
                print("data: \(data)")
                if let userVibesOuter = data.snapshot["getUserVibes"] as? [String : Any] {
                    let nextToken = userVibesOuter["nextToken"] as? String
                    if let hailsOuter = userVibesOuter["hails"] {
                        print("hails: \(hailsOuter)")
                        let hails = hailsOuter as! [Any]
                        for i in 0 ..< hails.count {
                            if let hail = hails[i] as? [String : Any] {
                                let hailForCache = HailsEntity()
                                hailForCache.setId(id: hail["id"] as! String)
                                hailForCache.setAuthor(author: hail["author"] as! String)
                                hailForCache.setVibeId(vibeId: hail["vibeId"] as! String)
                                hailForCache.setComment(comment: hail["comment"] as! String)
                                hailForCache.setCreatedAt(createdAt: hail["createdAt"] as! Int)
                                CacheHelper.shared.writeHailToCache(hailForCache)
                            }
                        }
                    }
                    if let vibesOuter = userVibesOuter["userVibes"] {
                        let allVibes = vibesOuter as! [Any?]
                        for i in 0 ..< allVibes.count {
                            if let vibe = allVibes[i] as? [String : Any] {
                                let vibeDataForCache = VibeDataEntity()
                                vibeDataForCache.setIsSeen(vibe["seen"] as! Bool)
                                vibeDataForCache.setReach(vibe["reach"] as! Int)
                                vibeDataForCache.setVibeId(vibe["vibeId"] as? String)
                                vibeDataForCache.setVersion(vibe["version"] as? String)
                                vibeDataForCache.setIsSender(vibe["isSender"] as! Bool)
                                vibeDataForCache.setVibeName(vibe["vibeName"] as? String)
                                vibeDataForCache.setProfileId(vibe["profileId"] as? String)
                                vibeDataForCache.setIsAnonymous(vibe["isAnonymous"] as! Bool)
                                vibeDataForCache.setUpdatedTime(vibe["updatedTime"] as! Int)
                                vibeDataForCache.setVibeTypeGsiPK(vibe["vibeTypeGsiPk"] as? String)
                                vibeDataForCache.setVibeTypeTagGsiPK(vibe["vibeTypeTagGsiPk"] as? String)
                                CacheHelper.shared.writeVibeToCache(vibeDataForCache)
                            }
                        }
                    }
                    print("=======> nextToken: \(nextToken)")
                    if nextToken != nil {
                        self?.getUserVibesPaginated(requestedVibeTag: requestedVibeTag, requestedVibeType: requestedVibeType, first: first, after: nextToken!)
                    }
                }
            }
        })
    }

    /// Deletes the profiles and vibe updates from the User Channel.
    /// - Parameters:
    ///     - liveBucketVibeIds: The vibe IDs in the channel.
    ///     - liveBucketProfileIds: The profile IDs in the channel.
    func deleteUserChannelUpdates(liveBucketVibeIds: [GraphQLID], liveBucketProfileIds: [GraphQLID]) {
        let query = DeleteUserChannelUpdatesMutation(liveVibeBucketIds: liveBucketVibeIds.count > 0 ? liveBucketVibeIds : nil, liveProfileBucketIds: liveBucketProfileIds.count > 0 ? liveBucketProfileIds : nil)
        appSyncClient?.perform(mutation: query)
    }

    /// Create Vibe with the Vibe Model Data.
    /// - Parameters:
    ///     - vibe: VibeModel.
    ///     - success: Success Closure which will be invoked if the CreateVibe query succeeds.
    ///     - failure: Failure Closure which will be invoked if the CreateVibe fails.
    public func createVibe(vibe: VibeModel, success: @escaping (Bool) -> Void, failure: @escaping (NSError) -> Void) {
        print("vibe: \(vibe)")
        let senderFsmComponentInput = FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: vibe.from, id: nil, author: nil)
        let receiverFsmComponentnput = FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: vibe.to, id: nil, author: nil)
        var userInputList = [FsmComponentInput]()
        userInputList.append(senderFsmComponentInput)
        userInputList.append(receiverFsmComponentnput)
        let userComponent = FsmComponent(exists: true, list: userInputList)
        var vibeComponents = [VibeComponentInput]()
        if vibe.isLetterPresent {
            print("Letter is present")
            let letterComponent = VibeComponentInput(ids: nil, sequence: nil, texts: [vibe.letter.text!], format: Format.text, template: VibeTextBackgrounds.getLetterTemplate(index: vibe.letter.background!), globalSequence: 1)
            vibeComponents.append(letterComponent)
        }
        if vibe.isPhotosPresent {
            let imagesComponent = VibeComponentInput(ids: APPUtilites.getVibeImageIds(images: vibe.images), sequence: nil, texts: APPUtilites.getVibeImageCaptions(images: vibe.images), format: Format.image, template: VibeImagesBackdrop.getImagesBackdrop(index: vibe.imageBackdrop), globalSequence: vibe.isLetterPresent ? 2 : 1)
            vibeComponents.append(imagesComponent)
        }
        
        if vibe.isBackgroundMusicEnabled {
            let musicComponent = VibeComponentInput(ids: [BackgroundMusic.musicList[vibe.backgroundMusicIndex]], sequence: nil, texts: nil, format: Format.backgroundMusic, template: nil, globalSequence: 0)
            vibeComponents.append(musicComponent)
        }

        let vibeComponentInput = FsmComponentInput(type: VibeTypesLocal.getVibeType(index: vibe.type), tag: VibeCategories.getVibeTag(index: vibe.category), isAnonymous: vibe.isSenderAnonymous, name: vibe.vibeName, vibeComponents: vibeComponents, comment: nil, mobileNumber: nil, id: nil, author: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)
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

    /// Creates the User Profile based on the Profile Model.
    /// - Parameters:
    ///     - profile: Profile Model.
    ///     - success: Success Closure to be invoked if the Create Query succeeds.
    ///     - failure: Failure Closure to be invoked if the Create Query fails.
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
    
    /// Updates the User Profile based on the Profile Model.
    /// - Parameters:
    ///     - profile: Profile Model.
    ///     - success: Success Closure to be invoked if the Update Query succeeds.
    ///     - failure: Failure Closure to be invoked if the Update Query fails.
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
    
    /// Updates the User's Profile Picture.
    /// - Parameters:
    ///     - profilePictureId: Picture Id.
    ///     - success: Success Closure to be invoked if the Update Query succeeds.
    ///     - failure: Failure Closure to be invoked if the Update Query fails.
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
    
    /// background thread - asynchronous
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
