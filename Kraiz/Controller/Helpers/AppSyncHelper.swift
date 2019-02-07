//
//  DbHelper.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 09/09/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import AWSAppSync
import RealmSwift

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

    public func getUserProfileByMobileNumber(mobileNumber: String, completionHandler: @escaping (Error?, ProfileModel?) -> Void) {
        let query = GetUserProfileByMobileNumberQuery(mobileNumber: mobileNumber)
        let cachePolicy = CachePolicy.fetchIgnoringCacheData
        
        if appSyncClient != nil {
            setAppSyncClient()
        }

        appSyncClient?.fetch(query: query, cachePolicy: cachePolicy, queue: DispatchQueue.global(qos: .userInitiated), resultHandler: { (result, error) in
            if error != nil {
                print("error in getUserProfileByMobileNumber: \(error)")
                completionHandler(error, nil)
            } else if result?.errors != nil {
                print("error in result of getUserProfileByMobileNumber: \(result?.errors)")
                completionHandler(result?.errors?.first, nil)
            } else {
                var profileModel = ProfileModel()
                if let data = result?.data {
                    if let snapshot = data.snapshot["getUserProfileByMobileNumber"] as? [Any?] {
                        if snapshot.count > 0 {
                            if let userProfile = snapshot[0] as? [String : Any?] {
                                profileModel = ProfileModel(id: nil, username: userProfile["username"] as? String, mobileNumber: userProfile["mobileNumber"] as? String, name: userProfile["name"] as? String, gender: (userProfile["gender"] as? Gender).map { $0.rawValue }, dob: userProfile["dob"] as? String, profilePicId: userProfile["profilePicId"] as? String)
                            }
                        }
                    }
                }
                completionHandler(nil, profileModel)
            }
        })
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
                        failure(error[0] as NSError)
                        return
                    }
                    if let data = result?.data {
                        if let snapshot = data.snapshot["getUserProfileByUsername"] as? [Any?] {
                            if snapshot.count > 0 {
                                if let userProfile = snapshot[0] as? [String : Any?] {
                                    profileModel = ProfileModel(id: nil, username: userProfile["username"] as? String, mobileNumber: userProfile["mobileNumber"] as? String, name: userProfile["name"] as? String, gender: (userProfile["gender"] as? Gender).map { $0.rawValue }, dob: userProfile["dob"] as? String, profilePicId: userProfile["profilePicId"] as? String)
                                }
                            }
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
        var cachePolicy = CachePolicy.returnCacheDataElseFetch
        if !APPUtilites.isInternetConnectionAvailable() {
            cachePolicy = .returnCacheDataDontFetch
        }
        if appSyncClient != nil {
                appSyncClient?.fetch(query: getQuery, cachePolicy: cachePolicy, queue: DispatchQueue.global(qos: .background), resultHandler: { (result, error) in
                if error != nil {
                    failure(error! as NSError)
                } else {
                    var profileModel = ProfileModel()
                        if let data = result?.data {
                            if let userProfile = data.snapshot["getUserProfile"] as? [String: Any?] {
                                profileModel = ProfileModel(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID), username: userProfile["username"] as? String, mobileNumber: userProfile["mobileNumber"] as? String, name: userProfile["name"] as? String, gender: (userProfile["gender"] as? Gender).map { $0.rawValue }, dob: userProfile["dob"] as? String, profilePicId: userProfile["profilePicId"] as? String)
                                success(profileModel)
                            } else {
                                self.appSyncClient?.fetch(query: getQuery, cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: DispatchQueue.global(qos: .background), resultHandler: { (result, error) in
                                    if error != nil {
                                        failure(error as! NSError)
                                        return
                                    } else {
                                        var profileModel = ProfileModel()
                                        if let data = result?.data {
                                            if let userProfile = data.snapshot["getUserProfile"] as? [String: Any?] {
                                                profileModel = ProfileModel(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID), username: userProfile["username"] as? String, mobileNumber: userProfile["mobileNumber"] as? String, name: userProfile["name"] as? String, gender: (userProfile["gender"] as? Gender).map { $0.rawValue }, dob: userProfile["dob"] as? String, profilePicId: userProfile["profilePicId"] as? String)
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

    /// Updates the FCM Token
    func updateFcmToken() {
        print("inside the updateFcmTokenIfRequired")
        let userQuery = UpdateUserProfileInput(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, username: nil, name: nil, dob: nil, gender: nil, profilePicId: nil, token: UserDefaults.standard.string(forKey: DeviceConstants.FCM_TOKEN))
        if appSyncClient == nil {
            setAppSyncClient()
        }
        appSyncClient?.perform(mutation: UpdateUserProfileMutation(input: userQuery), queue: DispatchQueue.global(qos: .userInitiated), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
            if let error = error {
                print("error in updateProfileQuery")
                print(error)
                return
            }
            if let result = result {
                if let errors = result.errors {
                    print("Error in the result of updateProfileQuery")
                    print(errors)
                    return
                }
                print("Token has been updated in the server.")
                UserDefaults.standard.set(false, forKey: DeviceConstants.IS_FCM_TOKEN_UPDATE_REQUIRED)
            }
        })
    }

    /// Gets the User Channel.
    /// The channel will contain the following:
    ///     1. New Vibes which have been sent to the user.
    ///     2. Profiles which have been updated by other Users.
    public func getUserChannel() {
        let getChannelQuery = GetUserChannelViewQuery()
        let cachePolicy = CachePolicy.fetchIgnoringCacheData

        if appSyncClient != nil {
            appSyncClient?.fetch(query: getChannelQuery, cachePolicy: cachePolicy, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated), resultHandler: { [weak self] (result, error) in
                if error != nil {
                } else if let data = result?.data {
                    if let userChannel = data.snapshot["getUserChannel"] as? [String: Any] {
                        var liveBucketVibeIds = [GraphQLID]()
                        var liveBucketProfileIds = [GraphQLID]()
                        let nonVibeProfiles = userChannel["profiles"] as? [Any]
                        if nonVibeProfiles != nil && nonVibeProfiles!.count > 0 {
                            print("nonVibeProfiles count is greater than 0")
                            for i in 0 ..< nonVibeProfiles!.count {
                                if let profile = nonVibeProfiles![i] as? [String : Any] {
                                    print("inside the profile.")
                                    let profileForCache = ProfileEntity()
                                    liveBucketProfileIds.append(profile["id"] as! String)
                                    profileForCache.setMobileNumber(profile["mobileNumber"] as? String)
                                    profileForCache.setUsername(profile["username"] as? String)
                                    profileForCache.setId(profile["id"] as? String)
                                    profileForCache.setName(profile["name"] as? String)
                                    profileForCache.setProfilePicId(profile["profilePicId"] as? String)
                                    CacheHelper.shared.writeProfileToCache(profileForCache)
                                }
                                
                            }
                        }
                        let lastPublicVibeFetchTimeOptional = userChannel["lastPublicVibeFetchTime"] as? Int
                        print("lastPublicVibeFetchTime: \(lastPublicVibeFetchTimeOptional)")
                        if let lastPublicFetchTime = lastPublicVibeFetchTimeOptional {
                            CacheHelper.shared.setPublicVibeLastAccessedime(lastVibeFetchTime: lastPublicFetchTime)
                        } else {
                            CacheHelper.shared.setPublicVibeLastAccessedime(lastVibeFetchTime: 0)
                        }
                        if let userVibesOuter = userChannel["userVibes"] as? [String: Any] {
                            if let vibesInner = userVibesOuter["userVibes"] {
                                let allVibes = vibesInner as! [Any?]
                                for i in 0 ..< allVibes.count {
                                    if let vibe = allVibes[i] as? [String : Any] {
                                        liveBucketVibeIds.append((vibe["vibeId"] as? String)!)
                                        let vibeDataForCache = VibeDataEntity()
                                        print("vibeId inside getUserChannel: \(vibe["vibeId"] as? String)")
                                        print("profileId inside getUserChannel: \(vibe["profileId"] as? String)")
                                        vibeDataForCache.setHails(hails: List<HailsEntity>())
                                        vibeDataForCache.setIsSeen(vibe["seen"] as! Bool)
                                        vibeDataForCache.setReach(vibe["reach"] as! Int)
                                        vibeDataForCache.setCreatedAt(vibe["createdAt"] as! Int)
                                        vibeDataForCache.setVibeId(vibe["vibeId"] as? String)
                                        vibeDataForCache.setVersion(vibe["version"] as! Int)
                                        vibeDataForCache.setIsSender(vibe["isSender"] as! Bool)
                                        vibeDataForCache.setVibeName(vibe["vibeName"] as? String)
                                        vibeDataForCache.setProfileId(vibe["profileId"] as? String)
                                        vibeDataForCache.setIsAnonymous(vibe["isAnonymous"] as! Bool)
                                        vibeDataForCache.setUpdatedTime(vibe["updatedTime"] as! Int)
                                        vibeDataForCache.setVibeTypeGsiPK(vibe["vibeTypeGsiPk"] as? String)
                                        vibeDataForCache.setVibeTypeTagGsiPK(vibe["vibeTypeTagGsiPk"] as? String)
                                        CacheHelper.shared.writeVibeToCache(vibeDataForCache, checkVersion: true)
                                        let hailIds = vibe["hailIds"] as? [Any]
                                        if hailIds != nil && hailIds!.count > 0 {
                                            if hailIds!.count != CacheHelper.shared.getHailsCountForVibe(vibeId: vibe["vibeId"] as! String) {
                                                CacheHelper.shared.setHasNewHailsInVibe(hasNewHails: true, vibeId: vibe["vibeId"] as! String)
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            if let hailsOuter = userVibesOuter["hails"] {
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
                                        CacheHelper.shared.addHailToVibe(hail: hailForCache, vibeId: hailForCache.getVibeId())
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
    func getUserVibesPaginated(requestedVibeTag: VibeTag?, requestedVibeType: VibeType, first: Int, after: String?, completionHandler: (() -> Void)?) {
        let query = GetPaginatedUserVibesQuery(vibeTag: requestedVibeTag != nil ? requestedVibeTag! : nil, vibeType: requestedVibeType, first: first, after: after != nil ? after! : nil)
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
                if let userVibesOuter = data.snapshot["getUserVibes"] as? [String : Any] {
                    let nextToken = userVibesOuter["nextToken"] as? String

                    if let vibesOuter = userVibesOuter["userVibes"] {
                        let allVibes = vibesOuter as! [Any?]
                        for i in 0 ..< allVibes.count {
                            if let vibe = allVibes[i] as? [String : Any] {
                                let vibeDataForCache = VibeDataEntity()
                                vibeDataForCache.setHails(hails: List<HailsEntity>())
                                vibeDataForCache.setIsSeen(vibe["seen"] as! Bool)
                                vibeDataForCache.setReach(vibe["reach"] as! Int)
                                vibeDataForCache.setVibeId(vibe["vibeId"] as? String)
                                vibeDataForCache.setVersion(vibe["version"] as! Int)
                                vibeDataForCache.setIsSender(vibe["isSender"] as! Bool)
                                vibeDataForCache.setVibeName(vibe["vibeName"] as? String)
                                vibeDataForCache.setProfileId(vibe["profileId"] as? String)
                                vibeDataForCache.setIsAnonymous(vibe["isAnonymous"] as! Bool)
                                vibeDataForCache.setUpdatedTime(vibe["updatedTime"] as! Int)
                                vibeDataForCache.setCreatedAt(vibe["createdAt"] as! Int)
                                vibeDataForCache.setVibeTypeGsiPK(vibe["vibeTypeGsiPk"] as? String)
                                vibeDataForCache.setVibeTypeTagGsiPK(vibe["vibeTypeTagGsiPk"] as? String)
                                CacheHelper.shared.writeVibeToCache(vibeDataForCache, checkVersion: true)
                            }
                        }
                    }

                    if let profilesOuter = userVibesOuter["profiles"] {
                        let profiles = profilesOuter as! [Any]
                        for i in 0 ..< profiles.count {
                            if let profile = profiles[i] as? [String : Any] {
                                let profileForCache = ProfileEntity()
                                profileForCache.setMobileNumber(profile["mobileNumber"] as? String)
                                profileForCache.setUsername(profile["username"] as? String)
                                profileForCache.setId(profile["id"] as? String)
                                profileForCache.setName(profile["name"] as? String)
                                profileForCache.setProfilePicId(profile["profilePicId"] as? String)
                                CacheHelper.shared.writeProfileToCache(profileForCache)
                            }
                        }
                    }
                    
                    if let hailsOuter = userVibesOuter["hails"] {
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
                                CacheHelper.shared.addHailToVibe(hail: hailForCache, vibeId: hailForCache.getVibeId())
                            }
                        }
                    }
                    if nextToken != nil {
                        self?.getUserVibesPaginated(requestedVibeTag: requestedVibeTag, requestedVibeType: requestedVibeType, first: first, after: nextToken!, completionHandler: completionHandler)
                    } else if completionHandler != nil {
                        completionHandler!()
                    }
                }
            }
        })
    }

    func getUserVibe(vibeId: String, vibeType: Int, vibeTag: Int, completionHandler: ((Error?, VibeModel?) -> Void)?) {
        let query = FetchVibeDataQuery(vibeId: vibeId)
        let cachePolicy = CachePolicy.returnCacheDataElseFetch

        if appSyncClient == nil {
            setAppSyncClient()
        }
        appSyncClient?.fetch(query: query, cachePolicy: cachePolicy, queue: DispatchQueue.global(qos: .userInitiated), resultHandler: { (result, error) in
            if error != nil {
                print("error in fetch vibe data: \(error)")
                if completionHandler != nil {
                    completionHandler!(error, nil)
                }
                return
            }
            print("result: \(result)")
            if result?.errors != nil {
                print("error in the result of fetch vibe data: \(result?.errors?.first)")
                if completionHandler != nil {
                    completionHandler!(result?.errors?.first, nil)
                }
                return
            }
            if let data = result?.data {
                var vibeModel = VibeModel()
                if let vibeData = data.snapshot["fetchVibeData"] as? [String: Any?] {
                    vibeModel = self.getVibeModelFromVibeDataSnapshot(vibeData: vibeData, vibeType: vibeType, vibeTag: vibeTag)
                    if vibeType == 0 && vibeModel.isPhotosPresent && vibeModel.imageBackdrop == 1 && vibeModel.getSeenIds().count == 0 {
                        self.appSyncClient?.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: DispatchQueue.global(qos: .userInitiated), resultHandler: { (result, error) in
                            if error != nil {
                                print("error in fetch vibe data: \(error)")
                                if completionHandler != nil {
                                    completionHandler!(error, nil)
                                }
                                return
                            }
                            print("result: \(result)")
                            if result?.errors != nil {
                                print("error in the result of fetch vibe data: \(result?.errors?.first)")
                                if completionHandler != nil {
                                    completionHandler!(result?.errors?.first, nil)
                                }
                                return
                            }
                            if let data = result?.data {
                                var vibeModel = VibeModel()
                                if let vibeData = data.snapshot["fetchVibeData"] as? [String : Any?] {
                                    vibeModel = self.getVibeModelFromVibeDataSnapshot(vibeData: vibeData, vibeType: vibeType, vibeTag: vibeTag)
                                    if completionHandler != nil {
                                        completionHandler!(nil, vibeModel)
                                    }
                                }
                            }
                        })
                    } else {
                        if completionHandler != nil {
                            completionHandler!(nil, vibeModel)
                        }
                    }
                } else if !APPUtilites.isInternetConnectionAvailable() {
                    if completionHandler != nil {
                        let noInternetError = NSError(domain: "NoInternetConnection", code: 503, userInfo: nil)
                        completionHandler!(noInternetError as Error, nil)
                    }
                } else {
                    self.appSyncClient?.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: DispatchQueue.global(qos: .userInitiated), resultHandler: { (result, error) in
                        if let error = error {
                            print("error in fetching the vibe from the server: \(error)")
                            if completionHandler != nil {
                                completionHandler!(error, nil)
                            }
                        }
                        if let result = result {
                            if let errors = result.errors {
                                print("errors in the result of vibe from the server: \(error)")
                                if completionHandler != nil {
                                    completionHandler!(errors.first, nil)
                                }
                            }
                            if let data = result.data {
                                var vibeModel = VibeModel()
                                if let vibeData = data.snapshot["fetchVibeData"] as? [String: Any?] {
                                    vibeModel = self.getVibeModelFromVibeDataSnapshot(vibeData: vibeData, vibeType: vibeType, vibeTag: vibeTag)
                                    if vibeType == 0 && vibeModel.isPhotosPresent && vibeModel.imageBackdrop == 1 && vibeModel.getSeenIds().count == 0 {
                                        self.appSyncClient?.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: DispatchQueue.global(qos: .userInitiated), resultHandler: { (result, error) in
                                            if error != nil {
                                                print("error in fetch vibe data: \(error)")
                                                if completionHandler != nil {
                                                    completionHandler!(error, nil)
                                                }
                                                return
                                            }
                                            print("result: \(result)")
                                            if result?.errors != nil {
                                                print("error in the result of fetch vibe data: \(result?.errors?.first)")
                                                if completionHandler != nil {
                                                    completionHandler!(result?.errors?.first, nil)
                                                }
                                                return
                                            }
                                            if let data = result?.data {
                                                var vibeModel = VibeModel()
                                                if let vibeData = data.snapshot["fetchVibeData"] as? [String : Any?] {
                                                    vibeModel = self.getVibeModelFromVibeDataSnapshot(vibeData: vibeData, vibeType: vibeType, vibeTag: vibeTag)
                                                    if completionHandler != nil {
                                                        completionHandler!(nil, vibeModel)
                                                    }
                                                }
                                            }
                                        })
                                    } else {
                                        if completionHandler != nil {
                                            completionHandler!(nil, vibeModel)
                                        }
                                    }
                                }
                            }
                        }
                    })
                }
            }
        })
    }

    /// Sets the Seen Ids when the user sees the Up Your Caption Game Vibe for the first time.
    /// - Parameters:
    ///     - vibeId: Vibe ID.
    ///     - seenIds: All the image Ids. which the user has selected in the Up Your Caption Game.
    func setImagesSeenIdsInPrivateVibe(vibeId: String, seenIds: [String], completionHandler: ((Bool) -> Void)?) {
        print("vibeId inside setImagesSeenIdsInPrivateVibe: \(vibeId)")
        var seenIdsComponents = [VibeComponentInput]()
        seenIdsComponents.append(VibeComponentInput(ids: nil, seenIds: seenIds, sequence: nil, texts: nil, format: .image, template: .upYourCaptionGame, globalSequence: 0))
        var seenIdComponents = [FsmComponentInput]()
        seenIdComponents.append(FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: seenIdsComponents, comment: nil, mobileNumber: nil, id: vibeId, author: nil))
        let vibeComponent = FsmComponent(exists: true, list: seenIdComponents)
        var allUsers = [FsmComponentInput]()
        allUsers.append(FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: nil, id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, author: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!))
        let usersComponent = FsmComponent(exists: true, list: allUsers)
        let fsmInput = FsmInput(action: .updateVibeImageSeenIds, users: usersComponent, vibes: vibeComponent, hails: nil)
        let query = TriggerFsmMutation(input: fsmInput, userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)
        if appSyncClient == nil {
            setAppSyncClient()
        }
        appSyncClient?.perform(mutation: query, queue: DispatchQueue.global(qos: .userInitiated), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
            if error != nil {
                print("error in query: \(error)")
                if completionHandler != nil {
                    completionHandler!(false)
                }
                return
            }
            if result?.errors != nil {
                print("error in result: \(result?.errors)")
                if completionHandler != nil {
                    completionHandler!(false)
                }
                return
            }
            if completionHandler != nil {
                completionHandler!(true)
            }
        })
    }

    /// Creates a VibeModel from the VibeData Snapshot.
    /// - Parameters:
    ///     - vibeData: Data fetched from the server.
    ///     - vibeType: Vibe Type.
    ///     - vibeTag: Vibe Tag.
    func getVibeModelFromVibeDataSnapshot(vibeData: [String : Any?], vibeType: Int, vibeTag: Int) -> VibeModel {
        var vibeModel = VibeModel()
        print("vibeData: \(vibeData)")
        vibeModel.setId(id: vibeData["id"] as! String)
        vibeModel.setVibeName(name: vibeData["name"] as! String)
        vibeModel.setVibeType(type: vibeType)
        vibeModel.setCategory(category: vibeTag)
        let sender = vibeData["author"] as! String
        vibeModel.setSenderId(sender: sender)
        vibeModel.from?.setId(id: sender)
        if sender == UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)! {
            vibeModel.from?.setMobileNumber(mobileNumber: UserDefaults.standard.string(forKey: DeviceConstants.MOBILE_NUMBER)!)
            vibeModel.from?.setUsername(username: UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME)!)
        } else {
            let profile = CacheHelper.shared.getProfileById(id: sender)
            vibeModel.from?.setUsername(username: profile?.getUsername())
            vibeModel.from?.setMobileNumber(mobileNumber: profile?.getMobileNumber())
            vibeModel.from?.setProfilePicId(profilePicId: profile?.getProfilePicId())
        }
        vibeModel.setAnonymous(isSenderAnonymous: vibeData["isAnonymous"] as! Bool)
        vibeModel.setVersion(version: vibeData["version"] as! Int)
        let vibeComponents = vibeData["vibeComponents"] as! [Any]
        for i in 0 ..< vibeComponents.count {
            if let component = vibeComponents[i] as? [String : Any] {
                let format = component["format"] as! Format
                if format == Format.text {
                    
                    let componentTexts = component["texts"] as! [Any]
                    vibeModel.setLetterPresent(isLetterPresent: true)
                    vibeModel.setLetterText(letterString: componentTexts[0] as! String)
                    vibeModel.setLetterBackground(background: VibeTextBackgrounds.getletterTemplateIndexFromTemplate(template: component["template"] as! VibeComponentTemplate))
                }
                if format == Format.backgroundMusic {
                    let componentIds = component["ids"] as! [Any]
                    vibeModel.setBackgroundMusicEnabled(isBackgroundMusicEnabled: true)
                    vibeModel.setBackgroundMusic(index: Int(componentIds[0] as! String) != nil ? Int(componentIds[0] as! String)! : 0)
                }
                if format == Format.image {
                    let componentTexts = component["texts"] as! [Any]
                    let componentIds = component["ids"] as! [Any]
                    vibeModel.setPhotosPresent(isPhotosPresent: true)
                    vibeModel.setImageBackdrop(backdrop: VibeImagesBackdrop.getImagesBackdropIndex(template: component["template"] as! VibeComponentTemplate))
                    var photos = [PhotoEntity]()
                    for j in 0 ..< componentIds.count {
                        var photo = PhotoEntity()
                        photo.caption = componentTexts[j] as? String == "NULL" ? nil : componentTexts[j] as? String
                        photo.imageLink = componentIds[j] as? String
                        photos.append(photo)
                    }
                    vibeModel.setImages(photos: photos)
                    if let seenIdsFromVibeData = component["seenIds"] as? [Any] {
                        var seenIdsForVibeModel = [String]()
                        for i in 0 ..< seenIdsFromVibeData.count {
                            seenIdsForVibeModel.append(seenIdsFromVibeData[i] as! String)
                        }
                        vibeModel.setSeenIds(seenIds: seenIdsForVibeModel)
                    }
                }
            }
        }
        return vibeModel
    }

    /// Increment the reach of a vibe.
    /// - Parameters:
    ///     - vibeId: Vibe ID.
    ///     - completionHandler: Completion Handler
    func incrementReachOfVibe(vibeId: String, completionHandler: ((Bool) -> Void)?) {
        var userInputList = [FsmComponentInput]()
        userInputList.append(FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: nil, id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, author: nil))
        let userComponent = FsmComponent(exists: true, list: userInputList)
        var vibesInputList = [FsmComponentInput]()
        vibesInputList.append(FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: nil, id: vibeId, author: nil))
        let vibesComponent = FsmComponent(exists: true, list: vibesInputList)
        let fsmInput = FsmInput(action: .addReach, users: userComponent, vibes: vibesComponent, hails: nil)
        let incrementReachMutation = TriggerFsmMutation(input: fsmInput, userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)
        if appSyncClient == nil {
            setAppSyncClient()
        }
        if completionHandler == nil {
            appSyncClient?.perform(mutation: incrementReachMutation, queue: DispatchQueue.global(qos: .userInitiated), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
                if error != nil || result?.errors != nil {
                    print("error: \(error)")
                    print("result.errors: \(result?.errors)")
                }
            })
        } else {
            appSyncClient?.perform(mutation: incrementReachMutation, queue: DispatchQueue.global(qos: .userInteractive), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
                if (error != nil) || ((result?.errors) != nil) {
                    print("error in incrementReachOfVibe")
                    completionHandler!(false)
                } else {
                    print("incrementReachOfVibe successful")
                    completionHandler!(true)
                }
            })
        }
    }

    /// Send the hail of the vibe.
    /// - Parameters:
    ///     - hailText: Hail Text.
    ///     - vibeId: Vibe ID.
    ///     - sender: User ID of the hail sender.
    func sendHail(hailText: String, vibeId: String, sender: String, completionHandler: ((Bool) -> Void)?) {
        var allHailsComponents = [FsmComponentInput]()
        allHailsComponents.append(FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: hailText, mobileNumber: nil, id: nil, author: sender))
        let hailComponent = FsmComponent(exists: true, list: allHailsComponents)
        var allVibesComponents = [FsmComponentInput]()
        allVibesComponents.append(FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: nil, id: vibeId, author: nil))
        let vibeComponent = FsmComponent(exists: true, list: allVibesComponents)
        var allUsersComponent = [FsmComponentInput]()
        allUsersComponent.append(FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: nil, id: sender, author: nil))
        let userComponent = FsmComponent(exists: true, list: allUsersComponent)
        let fsmInput = FsmInput(action: .addHail, users: userComponent, vibes: vibeComponent, hails: hailComponent)
        let mutation = TriggerFsmMutation(input: fsmInput, userId: sender)

        if appSyncClient == nil {
            setAppSyncClient()
        }

        appSyncClient?.perform(mutation: mutation, queue: DispatchQueue.global(qos: .userInitiated), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
            if error != nil {
                print("error: \(error.debugDescription)")
                if completionHandler != nil {
                    completionHandler!(false)
                    return
                }
            }
            if result?.errors != nil {
                print("errors: \(result?.errors.debugDescription)")
                print(result?.errors)
                if completionHandler != nil {
                    completionHandler!(false)
                    return
                }
            }
            if completionHandler != nil {
                completionHandler!(true)
                return
            }
        })
    }

    func updateLastSeenPublicVibeTime() {
        let mutation = UpdateLastPublicVibeFetchTimeMutation(userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID))
        if appSyncClient == nil {
            setAppSyncClient()
        }
        appSyncClient?.perform(mutation: mutation, queue: DispatchQueue.main, optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: nil)
    }

    /// Deletes the profiles and vibe updates from the User Channel.
    /// - Parameters:
    ///     - liveBucketVibeIds: The vibe IDs in the channel.
    ///     - liveBucketProfileIds: The profile IDs in the channel.
    func deleteUserChannelUpdates(liveBucketVibeIds: [GraphQLID], liveBucketProfileIds: [GraphQLID]) {
        let query = DeleteUserChannelUpdatesMutation(liveVibeBucketIds: liveBucketVibeIds.count > 0 ? liveBucketVibeIds : nil, liveProfileBucketIds: liveBucketProfileIds.count > 0 ? liveBucketProfileIds : nil)
        appSyncClient?.perform(mutation: query)
    }

    /// Updates the Seen Status of the Vibe
    /// - Parameters:
    ///     - vibeId: Vibe ID.
    ///     - seenStatus: Seen Status.
    func updateSeenStatusOfVibe(vibeId: String, seenStatus: Bool) {
        var userInputList = [FsmComponentInput]()
        userInputList.append(FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: nil, id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, author: nil))
        let userComponent = FsmComponent(exists: true, list: userInputList)
        var vibesInputList = [FsmComponentInput]()
        vibesInputList.append(FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: nil, id: vibeId, author: nil))
        let vibesComponent = FsmComponent(exists: true, list: vibesInputList)
        let fsmInput = FsmInput(action: .updateStatus, users: userComponent, vibes: vibesComponent, hails: nil)
        let updateStatusMutation = TriggerFsmMutation(input: fsmInput, userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)

        if appSyncClient == nil {
            setAppSyncClient()
        }
        appSyncClient?.perform(mutation: updateStatusMutation)
    }

    /// Gets the Random Public vibes for the user according to the Vibe Tag.
    /// - Parameters:
    ///     - vibeTag: Vibe Tag.
    ///     - completionHandler: Completion method to be executed after the query is completed.
    func getRandomPublicVibes(vibeTag: VibeTag, completionHandler: @escaping (Error?, [VibeModel]?, [String : ProfileModel]?) -> Void) {
        let query = GetRandomPublicVibesQuery(vibeTag: vibeTag)
        let cachePolicy = CachePolicy.fetchIgnoringCacheData
        
        if appSyncClient == nil {
            setAppSyncClient()
        }
        
        appSyncClient?.fetch(query: query, cachePolicy: cachePolicy, queue: DispatchQueue.global(qos: .userInteractive), resultHandler: { (result, error) in
            if error != nil {
                completionHandler(error, nil, nil)
            } else if result?.errors != nil {
                completionHandler(result?.errors?.first, nil, nil)
            } else {
                var allProfiles = [String : ProfileModel]()
                var allVibes = [VibeModel]()
                if let data = result?.data {
                    if let snapshot = data.snapshot["getRandomPublicVibes"] as? [String : Any] {
                        if let profilesOuter = snapshot["profiles"] as Any? {
                            let profiles = profilesOuter as! [Any]
                            for i in 0 ..< profiles.count {
                                let profile = profiles[i] as! [String : Any]
                                let profileModel = ProfileModel()
                                profileModel.setId(id: profile["id"] as? String)
                                profileModel.setName(name: profile["name"] as? String)
                                profileModel.setProfilePicId(profilePicId: profile["profilePicId"] as? String)
                                profileModel.setUsername(username: profile["username"] as? String)
                                allProfiles[profileModel.getId()!] = profileModel
                            }
                        }
                        if let vibesOuter = snapshot["vibes"] as Any? {
                            let vibes = vibesOuter as! [Any]
                            for i in 0 ..< vibes.count {
                                let vibeData = vibes[i] as! [String : Any]
                                let vibeModel = VibeModel()
                                vibeModel.setId(id: vibeData["id"] as! String)
                                vibeModel.setVibeName(name: vibeData["name"] as! String)
                                vibeModel.setVibeType(type: 1)
                                vibeModel.setCategory(category: VibeCategories.getVibeTagIndex(vibeTag: vibeTag))
                                let sender = vibeData["author"] as! String
                                print("UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME)!: \(UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME))")
                                if sender == UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)! {
                                    vibeModel.setSenderId(sender: UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME)!)
                                    vibeModel.from?.setUsername(username: UserDefaults.standard.string(forKey: DeviceConstants.USER_NAME))
                                } else {
                                    let profile = allProfiles[sender]
                                    vibeModel.from?.setId(id: profile?.getId())
                                    vibeModel.from?.setUsername(username: profile?.getUsername())
                                }
                                vibeModel.setAnonymous(isSenderAnonymous: vibeData["isAnonymous"] as! Bool)
                                let vibeComponents = vibeData["vibeComponents"] as! [Any]
                                for i in 0 ..< vibeComponents.count {
                                    if let component = vibeComponents[i] as? [String : Any] {
                                        let format = component["format"] as! Format
                                        if format == Format.text {
                                            let componentTexts = component["texts"] as! [Any]
                                            vibeModel.setLetterPresent(isLetterPresent: true)
                                            vibeModel.setLetterText(letterString: componentTexts[0] as! String)
                                            vibeModel.setLetterBackground(background: VibeTextBackgrounds.getletterTemplateIndexFromTemplate(template: component["template"] as! VibeComponentTemplate))
                                        }
                                        if format == Format.backgroundMusic {
                                            let componentIds = component["ids"] as! [Any]
                                            vibeModel.setBackgroundMusicEnabled(isBackgroundMusicEnabled: true)
                                            vibeModel.setBackgroundMusic(index: Int(componentIds[0] as! String) ?? 0)
                                        }
                                        if format == Format.image {
                                            let componentTexts = component["texts"] as! [Any]
                                            let componentIds = component["ids"] as! [Any]
                                            vibeModel.setPhotosPresent(isPhotosPresent: true)
                                            var photos = [PhotoEntity]()
                                            for j in 0 ..< componentIds.count {
                                                var photo = PhotoEntity()
                                                photo.caption = componentTexts[j] as? String == "NULL" ? nil : componentTexts[j] as? String
                                                photo.imageLink = componentIds[j] as? String
                                                photos.append(photo)
                                            }
                                            vibeModel.setImages(photos: photos)
                                            vibeModel.setImageBackdrop(backdrop: VibeImagesBackdrop.getImagesBackdropIndex(template: component["template"] as! VibeComponentTemplate))

                                        }
                                    }
                                }
                                allVibes.append(vibeModel)
                            }
                        }
                    }
                }
                completionHandler(nil, allVibes, allProfiles)
            }
        })
    }

    /// Create Vibe with the Vibe Model Data.
    /// - Parameters:
    ///     - vibe: VibeModel.
    ///     - success: Success Closure which will be invoked if the CreateVibe query succeeds.
    ///     - failure: Failure Closure which will be invoked if the CreateVibe fails.
    public func createVibe(vibe: VibeModel, success: @escaping (Bool) -> Void, failure: @escaping (NSError) -> Void) {
        let senderFsmComponentInput = FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: vibe.from?.getMobileNumber(), id: nil, author: nil)
        let receiverFsmComponentInput = FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: vibe.to?.getMobileNumber(), id: nil, author: nil)
        var userInputList = [FsmComponentInput]()
        userInputList.append(senderFsmComponentInput)
        userInputList.append(receiverFsmComponentInput)
        let userComponent = FsmComponent(exists: true, list: userInputList)
        var vibeComponents = [VibeComponentInput]()
        if vibe.isLetterPresent {
            let letterComponent = VibeComponentInput(ids: nil, sequence: nil, texts: [vibe.letter.text!], format: Format.text, template: VibeTextBackgrounds.getLetterTemplate(index: vibe.letter.background!), globalSequence: 1)
            vibeComponents.append(letterComponent)
        }
        if vibe.isPhotosPresent {
            let imagesComponent = VibeComponentInput(ids: APPUtilites.getVibeImageIds(images: vibe.images), sequence: nil, texts: APPUtilites.getVibeImageCaptions(images: vibe.images), format: Format.image, template: VibeImagesBackdrop.getImagesBackdrop(index: vibe.imageBackdrop), globalSequence: vibe.isLetterPresent ? 2 : 1)
            vibeComponents.append(imagesComponent)
        }
        
        if vibe.isBackgroundMusicEnabled {
            let musicComponent = VibeComponentInput(ids: [String(vibe.backgroundMusicIndex)], sequence: nil, texts: nil, format: Format.backgroundMusic, template: nil, globalSequence: 0)
            vibeComponents.append(musicComponent)
        }

        let vibeComponentInput = FsmComponentInput(type: VibeTypesLocal.getVibeType(index: vibe.type), tag: VibeCategories.getVibeTag(index: vibe.category), isAnonymous: vibe.isSenderAnonymous, name: vibe.vibeName, vibeComponents: vibeComponents, comment: nil, mobileNumber: nil, id: nil, author: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)
        var list = [FsmComponentInput]()
        list.append(vibeComponentInput)
        let fsmInput = FsmInput(action: Action.createVibe, users: userComponent, vibes: FsmComponent(exists: true, list: list), hails: FsmComponent(exists: false))
        let mutation = TriggerFsmMutation(input: fsmInput, userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)

        if appSyncClient != nil {
            appSyncClient?.perform(mutation: mutation, queue: DispatchQueue.global(qos: .background), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
                if error != nil {
                    failure(error! as NSError)
                    success(false)
                } else if result?.errors == nil {
                    success(true)
                } else {
                    print(result?.errors)
                    success(false)
                }
            })
        } else {
            success(false)
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
        let profileInput = CreateUserProfileInput.init(id: profile.getId()!, mobileNumber: profile.getMobileNumber()!, username: profile.getUsername()!, name: profile.getName(), dob: profile.getDob()?.description, gender: profile.getGender().map { Gender(rawValue: $0) } != nil ? profile.getGender().map { Gender(rawValue: $0) }! : nil, profilePicId: profile.getProfilePicId())
        
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
        
        let updateInput = UpdateUserProfileInput(id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, username: profile.getUsername(), name: profile.getName(), dob: profile.getDob(), gender: profile.getGender().map { Gender(rawValue: $0) } ?? nil, profilePicId: profile.getProfilePicId())
        let updateQuery = UpdateUserProfileMutation(input: updateInput)
        
        appSyncClient?.perform(mutation: updateQuery, queue: DispatchQueue.global(qos: .background), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
            if error != nil {
                failure(error! as NSError)
            } else {
                if result?.errors == nil {
                    self.performUpdateProfileForAllUsers(completionHandler: nil)
                    success(true)
                } else {
                    print("result.errors in updateUserProfile: \(result?.errors)")
                    success(false)
                }
            }
        })
    }

    /// Triggers the update profile Action of the FSM to update the profile in all the connected users.
    /// - Parameters:
    ///     - completionHandler: (Optional) Closure after the FSM has been triggered.
    func performUpdateProfileForAllUsers(completionHandler: ((Bool) -> Void)?) {
        var userInputList = [FsmComponentInput]()
        userInputList.append(FsmComponentInput(type: nil, tag: nil, isAnonymous: nil, name: nil, vibeComponents: nil, comment: nil, mobileNumber: nil, id: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!, author: nil))
        let userComponent = FsmComponent(exists: true, list: userInputList)
        let fsmInput = FsmInput(action: .updateProfile, users: userComponent, vibes: nil, hails: nil)
        let updateProfileTriggerFsmMutation = TriggerFsmMutation(input: fsmInput, userId: UserDefaults.standard.string(forKey: DeviceConstants.USER_ID)!)
        if appSyncClient == nil {
            setAppSyncClient()
        }
        if completionHandler == nil {
            appSyncClient?.perform(mutation: updateProfileTriggerFsmMutation)
        } else {
            appSyncClient?.perform(mutation: updateProfileTriggerFsmMutation, queue: DispatchQueue.global(qos: .userInteractive), optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, error) in
                if (error != nil) || ((result?.errors) != nil) {
                    completionHandler!(false)
                } else {
                    completionHandler!(true)
                }
            })
        }
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
        var token: String? = nil
        if let tokenString = UserDefaults.standard.string(forKey: DeviceConstants.ID_TOKEN) {
            token = tokenString
            return token!
        }
        return token!
    }
}
