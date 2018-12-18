//  This file was automatically generated and should not be edited.

import AWSAppSync

public struct DeleteUserProfileInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap
    
    public init(id: GraphQLID) {
        graphQLMap = ["id": id]
    }
    
    public var id: GraphQLID {
        get {
            return graphQLMap["id"] as! GraphQLID
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "id")
        }
    }
}

/// # UserProfile Inputs
public struct CreateUserProfileInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap
    
    public init(id: GraphQLID, mobileNumber: GraphQLID, username: String, name: String? = nil, dob: String? = nil, gender: Gender? = nil, profilePicId: String? = nil) {
        graphQLMap = ["id": id, "mobileNumber": mobileNumber, "username": username, "name": name, "dob": dob, "gender": gender, "profilePicId": profilePicId]
    }
    
    public var id: GraphQLID {
        get {
            return graphQLMap["id"] as! GraphQLID
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "id")
        }
    }
    
    public var mobileNumber: GraphQLID {
        get {
            return graphQLMap["mobileNumber"] as! GraphQLID
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "mobileNumber")
        }
    }
    
    public var username: String {
        get {
            return graphQLMap["username"] as! String
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "username")
        }
    }
    
    public var name: String? {
        get {
            return graphQLMap["name"] as! String?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "name")
        }
    }
    
    public var dob: String? {
        get {
            return graphQLMap["dob"] as! String?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "dob")
        }
    }
    
    public var gender: Gender? {
        get {
            return graphQLMap["gender"] as! Gender?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "gender")
        }
    }
    
    public var profilePicId: String? {
        get {
            return graphQLMap["profilePicId"] as! String?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "profilePicId")
        }
    }
}

public enum Gender: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
    public typealias RawValue = String
    case male
    case female
    case others
    /// Auto generated constant for unknown enum values
    case unknown(RawValue)
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "MALE": self = .male
        case "FEMALE": self = .female
        case "OTHERS": self = .others
        default: self = .unknown(rawValue)
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .male: return "MALE"
        case .female: return "FEMALE"
        case .others: return "OTHERS"
        case .unknown(let value): return value
        }
    }
    
    public static func == (lhs: Gender, rhs: Gender) -> Bool {
        switch (lhs, rhs) {
        case (.male, .male): return true
        case (.female, .female): return true
        case (.others, .others): return true
        case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
        }
    }
}

public struct UpdateUserProfileInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap
    
    public init(id: GraphQLID, username: String? = nil, name: String? = nil, dob: String? = nil, gender: Gender? = nil, profilePicId: String? = nil) {
        graphQLMap = ["id": id, "username": username, "name": name, "dob": dob, "gender": gender, "profilePicId": profilePicId]
    }
    
    public var id: GraphQLID {
        get {
            return graphQLMap["id"] as! GraphQLID
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "id")
        }
    }
    
    public var username: String? {
        get {
            return graphQLMap["username"] as! String?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "username")
        }
    }
    
    public var name: String? {
        get {
            return graphQLMap["name"] as! String?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "name")
        }
    }
    
    public var dob: String? {
        get {
            return graphQLMap["dob"] as! String?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "dob")
        }
    }
    
    public var gender: Gender? {
        get {
            return graphQLMap["gender"] as! Gender?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "gender")
        }
    }
    
    public var profilePicId: String? {
        get {
            return graphQLMap["profilePicId"] as! String?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "profilePicId")
        }
    }
}

public struct FsmInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap
    
    public init(action: Action, users: FsmComponent? = nil, vibes: FsmComponent? = nil, hails: FsmComponent? = nil) {
        graphQLMap = ["action": action, "users": users, "vibes": vibes, "hails": hails]
    }
    
    public var action: Action {
        get {
            return graphQLMap["action"] as! Action
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "action")
        }
    }
    
    public var users: FsmComponent? {
        get {
            return graphQLMap["users"] as! FsmComponent?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "users")
        }
    }
    
    public var vibes: FsmComponent? {
        get {
            return graphQLMap["vibes"] as! FsmComponent?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "vibes")
        }
    }
    
    public var hails: FsmComponent? {
        get {
            return graphQLMap["hails"] as! FsmComponent?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "hails")
        }
    }
}

public enum Action: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
    public typealias RawValue = String
    case createVibe
    case updateStatus
    case revokeVibeAccess
    case addHail
    case addReach
    case updateProfile
    /// Auto generated constant for unknown enum values
    case unknown(RawValue)
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "CREATE_VIBE": self = .createVibe
        case "UPDATE_STATUS": self = .updateStatus
        case "REVOKE_VIBE_ACCESS": self = .revokeVibeAccess
        case "ADD_HAIL": self = .addHail
        case "ADD_REACH": self = .addReach
        case "UPDATE_PROFILE": self = .updateProfile
        default: self = .unknown(rawValue)
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .createVibe: return "CREATE_VIBE"
        case .updateStatus: return "UPDATE_STATUS"
        case .revokeVibeAccess: return "REVOKE_VIBE_ACCESS"
        case .addHail: return "ADD_HAIL"
        case .addReach: return "ADD_REACH"
        case .updateProfile: return "UPDATE_PROFILE"
        case .unknown(let value): return value
        }
    }
    
    public static func == (lhs: Action, rhs: Action) -> Bool {
        switch (lhs, rhs) {
        case (.createVibe, .createVibe): return true
        case (.updateStatus, .updateStatus): return true
        case (.revokeVibeAccess, .revokeVibeAccess): return true
        case (.addHail, .addHail): return true
        case (.addReach, .addReach): return true
        case (.updateProfile, .updateProfile): return true
        case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
        }
    }
}

public struct FsmComponent: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap
    
    public init(exists: Bool, list: [FsmComponentInput]? = nil) {
        graphQLMap = ["exists": exists, "list": list]
    }
    
    public var exists: Bool {
        get {
            return graphQLMap["exists"] as! Bool
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "exists")
        }
    }
    
    public var list: [FsmComponentInput]? {
        get {
            return graphQLMap["list"] as! [FsmComponentInput]?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "list")
        }
    }
}

public struct FsmComponentInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap
    
    public init(type: VibeType? = nil, tag: VibeTag? = nil, isAnonymous: Bool? = nil, name: String? = nil, vibeComponents: [VibeComponentInput]? = nil, comment: String? = nil, mobileNumber: GraphQLID? = nil, id: GraphQLID? = nil, author: GraphQLID? = nil) {
        graphQLMap = ["type": type, "tag": tag, "isAnonymous": isAnonymous, "name": name, "vibeComponents": vibeComponents, "comment": comment, "mobileNumber": mobileNumber, "id": id, "author": author]
    }
    
    /// # Vibe Input
    public var type: VibeType? {
        get {
            return graphQLMap["type"] as! VibeType?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "type")
        }
    }
    
    public var tag: VibeTag? {
        get {
            return graphQLMap["tag"] as! VibeTag?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "tag")
        }
    }
    
    public var isAnonymous: Bool? {
        get {
            return graphQLMap["isAnonymous"] as! Bool?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "isAnonymous")
        }
    }
    
    public var name: String? {
        get {
            return graphQLMap["name"] as! String?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "name")
        }
    }
    
    public var vibeComponents: [VibeComponentInput]? {
        get {
            return graphQLMap["vibeComponents"] as! [VibeComponentInput]?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "vibeComponents")
        }
    }
    
    /// # Hail Input
    public var comment: String? {
        get {
            return graphQLMap["comment"] as! String?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "comment")
        }
    }
    
    /// # Profile Input
    public var mobileNumber: GraphQLID? {
        get {
            return graphQLMap["mobileNumber"] as! GraphQLID?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "mobileNumber")
        }
    }
    
    /// # Common Input
    public var id: GraphQLID? {
        get {
            return graphQLMap["id"] as! GraphQLID?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "id")
        }
    }
    
    public var author: GraphQLID? {
        get {
            return graphQLMap["author"] as! GraphQLID?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "author")
        }
    }
}

/// #Enums
public enum VibeType: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
    public typealias RawValue = String
    case `public`
    case `private`
    /// Auto generated constant for unknown enum values
    case unknown(RawValue)
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "PUBLIC": self = .public
        case "PRIVATE": self = .private
        default: self = .unknown(rawValue)
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .public: return "PUBLIC"
        case .private: return "PRIVATE"
        case .unknown(let value): return value
        }
    }
    
    public static func == (lhs: VibeType, rhs: VibeType) -> Bool {
        switch (lhs, rhs) {
        case (.public, .public): return true
        case (.private, .private): return true
        case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
        }
    }
}

public enum VibeTag: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
    public typealias RawValue = String
    case love
    case travel
    case good
    case party
    case nostalgic
    case occasion
    /// Auto generated constant for unknown enum values
    case unknown(RawValue)
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "LOVE": self = .love
        case "TRAVEL": self = .travel
        case "GOOD": self = .good
        case "PARTY": self = .party
        case "NOSTALGIC": self = .nostalgic
        case "OCCASION": self = .occasion
        default: self = .unknown(rawValue)
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .love: return "LOVE"
        case .travel: return "TRAVEL"
        case .good: return "GOOD"
        case .party: return "PARTY"
        case .nostalgic: return "NOSTALGIC"
        case .occasion: return "OCCASION"
        case .unknown(let value): return value
        }
    }
    
    public static func == (lhs: VibeTag, rhs: VibeTag) -> Bool {
        switch (lhs, rhs) {
        case (.love, .love): return true
        case (.travel, .travel): return true
        case (.good, .good): return true
        case (.party, .party): return true
        case (.nostalgic, .nostalgic): return true
        case (.occasion, .occasion): return true
        case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
        }
    }
}

/// # Fsm Input Data
public struct VibeComponentInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap
    
    public init(ids: [GraphQLID]? = nil, sequence: [Int]? = nil, texts: [String]? = nil, format: Format, template: VibeComponentTemplate? = nil, globalSequence: Int) {
        graphQLMap = ["ids": ids, "sequence": sequence, "texts": texts, "format": format, "template": template, "globalSequence": globalSequence]
    }
    
    public var ids: [GraphQLID]? {
        get {
            return graphQLMap["ids"] as! [GraphQLID]?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "ids")
        }
    }
    
    public var sequence: [Int]? {
        get {
            return graphQLMap["sequence"] as! [Int]?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "sequence")
        }
    }
    
    public var texts: [String]? {
        get {
            return graphQLMap["texts"] as! [String]?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "texts")
        }
    }
    
    public var format: Format {
        get {
            return graphQLMap["format"] as! Format
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "format")
        }
    }
    
    public var template: VibeComponentTemplate? {
        get {
            return graphQLMap["template"] as! VibeComponentTemplate?
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "template")
        }
    }
    
    public var globalSequence: Int {
        get {
            return graphQLMap["globalSequence"] as! Int
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "globalSequence")
        }
    }
}

public enum Format: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
    public typealias RawValue = String
    case text
    case image
    case video
    case audio
    case backgroundMusic
    /// Auto generated constant for unknown enum values
    case unknown(RawValue)
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "TEXT": self = .text
        case "IMAGE": self = .image
        case "VIDEO": self = .video
        case "AUDIO": self = .audio
        case "BACKGROUND_MUSIC": self = .backgroundMusic
        default: self = .unknown(rawValue)
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .text: return "TEXT"
        case .image: return "IMAGE"
        case .video: return "VIDEO"
        case .audio: return "AUDIO"
        case .backgroundMusic: return "BACKGROUND_MUSIC"
        case .unknown(let value): return value
        }
    }
    
    public static func == (lhs: Format, rhs: Format) -> Bool {
        switch (lhs, rhs) {
        case (.text, .text): return true
        case (.image, .image): return true
        case (.video, .video): return true
        case (.audio, .audio): return true
        case (.backgroundMusic, .backgroundMusic): return true
        case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
        }
    }
}

public enum VibeComponentTemplate: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
    public typealias RawValue = String
    case love
    case royal
    case parchment
    case basic
    case dreamy
    case polaroid
    case tuner
    /// Auto generated constant for unknown enum values
    case unknown(RawValue)
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "LOVE": self = .love
        case "ROYAL": self = .royal
        case "PARCHMENT": self = .parchment
        case "BASIC": self = .basic
        case "DREAMY": self = .dreamy
        case "POLAROID": self = .polaroid
        case "TUNER": self = .tuner
        default: self = .unknown(rawValue)
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .love: return "LOVE"
        case .royal: return "ROYAL"
        case .parchment: return "PARCHMENT"
        case .basic: return "BASIC"
        case .dreamy: return "DREAMY"
        case .polaroid: return "POLAROID"
        case .tuner: return "TUNER"
        case .unknown(let value): return value
        }
    }
    
    public static func == (lhs: VibeComponentTemplate, rhs: VibeComponentTemplate) -> Bool {
        switch (lhs, rhs) {
        case (.love, .love): return true
        case (.royal, .royal): return true
        case (.parchment, .parchment): return true
        case (.basic, .basic): return true
        case (.dreamy, .dreamy): return true
        case (.polaroid, .polaroid): return true
        case (.tuner, .tuner): return true
        case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
        }
    }
}

public final class DeleteUserProfileMutation: GraphQLMutation {
    public static let operationString =
    "mutation DeleteUserProfile($input: DeleteUserProfileInput!) {\n  deleteUserProfile(input: $input) {\n    __typename\n    id\n    mobileNumber\n    name\n  }\n}"
    
    public var input: DeleteUserProfileInput
    
    public init(input: DeleteUserProfileInput) {
        self.input = input
    }
    
    public var variables: GraphQLMap? {
        return ["input": input]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Mutation"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("deleteUserProfile", arguments: ["input": GraphQLVariable("input")], type: .object(DeleteUserProfile.selections)),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(deleteUserProfile: DeleteUserProfile? = nil) {
            self.init(snapshot: ["__typename": "Mutation", "deleteUserProfile": deleteUserProfile.flatMap { $0.snapshot }])
        }
        
        public var deleteUserProfile: DeleteUserProfile? {
            get {
                return (snapshot["deleteUserProfile"] as? Snapshot).flatMap { DeleteUserProfile(snapshot: $0) }
            }
            set {
                snapshot.updateValue(newValue?.snapshot, forKey: "deleteUserProfile")
            }
        }
        
        public struct DeleteUserProfile: GraphQLSelectionSet {
            public static let possibleTypes = ["UserProfile"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("mobileNumber", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("name", type: .scalar(String.self)),
                ]
            
            public var snapshot: Snapshot
            
            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }
            
            public init(id: GraphQLID, mobileNumber: GraphQLID, name: String? = nil) {
                self.init(snapshot: ["__typename": "UserProfile", "id": id, "mobileNumber": mobileNumber, "name": name])
            }
            
            public var __typename: String {
                get {
                    return snapshot["__typename"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                }
            }
            
            public var id: GraphQLID {
                get {
                    return snapshot["id"]! as! GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "id")
                }
            }
            
            public var mobileNumber: GraphQLID {
                get {
                    return snapshot["mobileNumber"]! as! GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "mobileNumber")
                }
            }
            
            public var name: String? {
                get {
                    return snapshot["name"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "name")
                }
            }
        }
    }
}

public final class CreateUserProfileMutation: GraphQLMutation {
    public static let operationString =
    "mutation CreateUserProfile($input: CreateUserProfileInput!) {\n  createUserProfile(input: $input) {\n    __typename\n    id\n    mobileNumber\n    username\n    name\n    profilePicId\n  }\n}"
    
    public var input: CreateUserProfileInput
    
    public init(input: CreateUserProfileInput) {
        self.input = input
    }
    
    public var variables: GraphQLMap? {
        return ["input": input]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Mutation"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("createUserProfile", arguments: ["input": GraphQLVariable("input")], type: .object(CreateUserProfile.selections)),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(createUserProfile: CreateUserProfile? = nil) {
            self.init(snapshot: ["__typename": "Mutation", "createUserProfile": createUserProfile.flatMap { $0.snapshot }])
        }
        
        public var createUserProfile: CreateUserProfile? {
            get {
                return (snapshot["createUserProfile"] as? Snapshot).flatMap { CreateUserProfile(snapshot: $0) }
            }
            set {
                snapshot.updateValue(newValue?.snapshot, forKey: "createUserProfile")
            }
        }
        
        public struct CreateUserProfile: GraphQLSelectionSet {
            public static let possibleTypes = ["UserProfile"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("mobileNumber", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("username", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("profilePicId", type: .scalar(String.self)),
                ]
            
            public var snapshot: Snapshot
            
            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }
            
            public init(id: GraphQLID, mobileNumber: GraphQLID, username: String, name: String? = nil, profilePicId: String? = nil) {
                self.init(snapshot: ["__typename": "UserProfile", "id": id, "mobileNumber": mobileNumber, "username": username, "name": name, "profilePicId": profilePicId])
            }
            
            public var __typename: String {
                get {
                    return snapshot["__typename"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                }
            }
            
            public var id: GraphQLID {
                get {
                    return snapshot["id"]! as! GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "id")
                }
            }
            
            public var mobileNumber: GraphQLID {
                get {
                    return snapshot["mobileNumber"]! as! GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "mobileNumber")
                }
            }
            
            public var username: String {
                get {
                    return snapshot["username"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "username")
                }
            }
            
            public var name: String? {
                get {
                    return snapshot["name"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "name")
                }
            }
            
            public var profilePicId: String? {
                get {
                    return snapshot["profilePicId"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "profilePicId")
                }
            }
        }
    }
}

public final class UpdateUserProfileMutation: GraphQLMutation {
    public static let operationString =
    "mutation UpdateUserProfile($input: UpdateUserProfileInput!) {\n  updateUserProfile(input: $input) {\n    __typename\n    id\n    mobileNumber\n    username\n    name\n    gender\n    profilePicId\n    dob\n  }\n}"
    
    public var input: UpdateUserProfileInput
    
    public init(input: UpdateUserProfileInput) {
        self.input = input
    }
    
    public var variables: GraphQLMap? {
        return ["input": input]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Mutation"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("updateUserProfile", arguments: ["input": GraphQLVariable("input")], type: .object(UpdateUserProfile.selections)),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(updateUserProfile: UpdateUserProfile? = nil) {
            self.init(snapshot: ["__typename": "Mutation", "updateUserProfile": updateUserProfile.flatMap { $0.snapshot }])
        }
        
        public var updateUserProfile: UpdateUserProfile? {
            get {
                return (snapshot["updateUserProfile"] as? Snapshot).flatMap { UpdateUserProfile(snapshot: $0) }
            }
            set {
                snapshot.updateValue(newValue?.snapshot, forKey: "updateUserProfile")
            }
        }
        
        public struct UpdateUserProfile: GraphQLSelectionSet {
            public static let possibleTypes = ["UserProfile"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("mobileNumber", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("username", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("gender", type: .scalar(Gender.self)),
                GraphQLField("profilePicId", type: .scalar(String.self)),
                GraphQLField("dob", type: .scalar(String.self)),
                ]
            
            public var snapshot: Snapshot
            
            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }
            
            public init(id: GraphQLID, mobileNumber: GraphQLID, username: String, name: String? = nil, gender: Gender? = nil, profilePicId: String? = nil, dob: String? = nil) {
                self.init(snapshot: ["__typename": "UserProfile", "id": id, "mobileNumber": mobileNumber, "username": username, "name": name, "gender": gender, "profilePicId": profilePicId, "dob": dob])
            }
            
            public var __typename: String {
                get {
                    return snapshot["__typename"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                }
            }
            
            public var id: GraphQLID {
                get {
                    return snapshot["id"]! as! GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "id")
                }
            }
            
            public var mobileNumber: GraphQLID {
                get {
                    return snapshot["mobileNumber"]! as! GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "mobileNumber")
                }
            }
            
            public var username: String {
                get {
                    return snapshot["username"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "username")
                }
            }
            
            public var name: String? {
                get {
                    return snapshot["name"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "name")
                }
            }
            
            public var gender: Gender? {
                get {
                    return snapshot["gender"] as? Gender
                }
                set {
                    snapshot.updateValue(newValue, forKey: "gender")
                }
            }
            
            public var profilePicId: String? {
                get {
                    return snapshot["profilePicId"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "profilePicId")
                }
            }
            
            public var dob: String? {
                get {
                    return snapshot["dob"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "dob")
                }
            }
        }
    }
}

public final class GetUserProfileQuery: GraphQLQuery {
    public static let operationString =
    "query GetUserProfile($id: ID!) {\n  getUserProfile(id: $id) {\n    __typename\n    id\n    mobileNumber\n    username\n    name\n    gender\n    profilePicId\n    dob\n  }\n}"
    
    public var id: GraphQLID
    
    public init(id: GraphQLID) {
        self.id = id
    }
    
    public var variables: GraphQLMap? {
        return ["id": id]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Query"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("getUserProfile", arguments: ["id": GraphQLVariable("id")], type: .object(GetUserProfile.selections)),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(getUserProfile: GetUserProfile? = nil) {
            self.init(snapshot: ["__typename": "Query", "getUserProfile": getUserProfile.flatMap { $0.snapshot }])
        }
        
        public var getUserProfile: GetUserProfile? {
            get {
                return (snapshot["getUserProfile"] as? Snapshot).flatMap { GetUserProfile(snapshot: $0) }
            }
            set {
                snapshot.updateValue(newValue?.snapshot, forKey: "getUserProfile")
            }
        }
        
        public struct GetUserProfile: GraphQLSelectionSet {
            public static let possibleTypes = ["UserProfile"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("mobileNumber", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("username", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("gender", type: .scalar(Gender.self)),
                GraphQLField("profilePicId", type: .scalar(String.self)),
                GraphQLField("dob", type: .scalar(String.self)),
                ]
            
            public var snapshot: Snapshot
            
            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }
            
            public init(id: GraphQLID, mobileNumber: GraphQLID, username: String, name: String? = nil, gender: Gender? = nil, profilePicId: String? = nil, dob: String? = nil) {
                self.init(snapshot: ["__typename": "UserProfile", "id": id, "mobileNumber": mobileNumber, "username": username, "name": name, "gender": gender, "profilePicId": profilePicId, "dob": dob])
            }
            
            public var __typename: String {
                get {
                    return snapshot["__typename"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                }
            }
            
            public var id: GraphQLID {
                get {
                    return snapshot["id"]! as! GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "id")
                }
            }
            
            public var mobileNumber: GraphQLID {
                get {
                    return snapshot["mobileNumber"]! as! GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "mobileNumber")
                }
            }
            
            public var username: String {
                get {
                    return snapshot["username"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "username")
                }
            }
            
            public var name: String? {
                get {
                    return snapshot["name"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "name")
                }
            }
            
            public var gender: Gender? {
                get {
                    return snapshot["gender"] as? Gender
                }
                set {
                    snapshot.updateValue(newValue, forKey: "gender")
                }
            }
            
            public var profilePicId: String? {
                get {
                    return snapshot["profilePicId"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "profilePicId")
                }
            }
            
            public var dob: String? {
                get {
                    return snapshot["dob"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "dob")
                }
            }
        }
    }
}

public final class GetUserProfileByUsernameQuery: GraphQLQuery {
    public static let operationString =
    "query GetUserProfileByUsername($username: String!) {\n  getUserProfileByUsername(username: $username) {\n    __typename\n    mobileNumber\n    username\n    name\n    gender\n    profilePicId\n    dob\n  }\n}"
    
    public var username: String
    
    public init(username: String) {
        self.username = username
    }
    
    public var variables: GraphQLMap? {
        return ["username": username]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Query"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("getUserProfileByUsername", arguments: ["username": GraphQLVariable("username")], type: .list(.object(GetUserProfileByUsername.selections))),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(getUserProfileByUsername: [GetUserProfileByUsername?]? = nil) {
            self.init(snapshot: ["__typename": "Query", "getUserProfileByUsername": getUserProfileByUsername.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
        }
        
        public var getUserProfileByUsername: [GetUserProfileByUsername?]? {
            get {
                return (snapshot["getUserProfileByUsername"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { GetUserProfileByUsername(snapshot: $0) } } }
            }
            set {
                snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "getUserProfileByUsername")
            }
        }
        
        public struct GetUserProfileByUsername: GraphQLSelectionSet {
            public static let possibleTypes = ["UserProfile"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("mobileNumber", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("username", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("gender", type: .scalar(Gender.self)),
                GraphQLField("profilePicId", type: .scalar(String.self)),
                GraphQLField("dob", type: .scalar(String.self)),
                ]
            
            public var snapshot: Snapshot
            
            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }
            
            public init(mobileNumber: GraphQLID, username: String, name: String? = nil, gender: Gender? = nil, profilePicId: String? = nil, dob: String? = nil) {
                self.init(snapshot: ["__typename": "UserProfile", "mobileNumber": mobileNumber, "username": username, "name": name, "gender": gender, "profilePicId": profilePicId, "dob": dob])
            }
            
            public var __typename: String {
                get {
                    return snapshot["__typename"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                }
            }
            
            public var mobileNumber: GraphQLID {
                get {
                    return snapshot["mobileNumber"]! as! GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "mobileNumber")
                }
            }
            
            public var username: String {
                get {
                    return snapshot["username"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "username")
                }
            }
            
            public var name: String? {
                get {
                    return snapshot["name"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "name")
                }
            }
            
            public var gender: Gender? {
                get {
                    return snapshot["gender"] as? Gender
                }
                set {
                    snapshot.updateValue(newValue, forKey: "gender")
                }
            }
            
            public var profilePicId: String? {
                get {
                    return snapshot["profilePicId"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "profilePicId")
                }
            }
            
            public var dob: String? {
                get {
                    return snapshot["dob"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "dob")
                }
            }
        }
    }
}

public final class GetUserProfileByMobileNumberQuery: GraphQLQuery {
    public static let operationString =
    "query GetUserProfileByMobileNumber($mobileNumber: ID!) {\n  getUserProfileByMobileNumber(mobileNumber: $mobileNumber) {\n    __typename\n    mobileNumber\n    username\n    name\n    gender\n    profilePicId\n    dob\n  }\n}"
    
    public var mobileNumber: GraphQLID
    
    public init(mobileNumber: GraphQLID) {
        self.mobileNumber = mobileNumber
    }
    
    public var variables: GraphQLMap? {
        return ["mobileNumber": mobileNumber]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Query"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("getUserProfileByMobileNumber", arguments: ["mobileNumber": GraphQLVariable("mobileNumber")], type: .list(.object(GetUserProfileByMobileNumber.selections))),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(getUserProfileByMobileNumber: [GetUserProfileByMobileNumber?]? = nil) {
            self.init(snapshot: ["__typename": "Query", "getUserProfileByMobileNumber": getUserProfileByMobileNumber.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
        }
        
        public var getUserProfileByMobileNumber: [GetUserProfileByMobileNumber?]? {
            get {
                return (snapshot["getUserProfileByMobileNumber"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { GetUserProfileByMobileNumber(snapshot: $0) } } }
            }
            set {
                snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "getUserProfileByMobileNumber")
            }
        }
        
        public struct GetUserProfileByMobileNumber: GraphQLSelectionSet {
            public static let possibleTypes = ["UserProfile"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("mobileNumber", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("username", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("gender", type: .scalar(Gender.self)),
                GraphQLField("profilePicId", type: .scalar(String.self)),
                GraphQLField("dob", type: .scalar(String.self)),
                ]
            
            public var snapshot: Snapshot
            
            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }
            
            public init(mobileNumber: GraphQLID, username: String, name: String? = nil, gender: Gender? = nil, profilePicId: String? = nil, dob: String? = nil) {
                self.init(snapshot: ["__typename": "UserProfile", "mobileNumber": mobileNumber, "username": username, "name": name, "gender": gender, "profilePicId": profilePicId, "dob": dob])
            }
            
            public var __typename: String {
                get {
                    return snapshot["__typename"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                }
            }
            
            public var mobileNumber: GraphQLID {
                get {
                    return snapshot["mobileNumber"]! as! GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "mobileNumber")
                }
            }
            
            public var username: String {
                get {
                    return snapshot["username"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "username")
                }
            }
            
            public var name: String? {
                get {
                    return snapshot["name"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "name")
                }
            }
            
            public var gender: Gender? {
                get {
                    return snapshot["gender"] as? Gender
                }
                set {
                    snapshot.updateValue(newValue, forKey: "gender")
                }
            }
            
            public var profilePicId: String? {
                get {
                    return snapshot["profilePicId"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "profilePicId")
                }
            }
            
            public var dob: String? {
                get {
                    return snapshot["dob"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "dob")
                }
            }
        }
    }
}

public final class TriggerFsmMutation: GraphQLMutation {
    public static let operationString =
    "mutation TriggerFsm($input: FsmInput!, $userId: ID!) {\n  triggerFsm(input: $input, userId: $userId)\n}"
    
    public var input: FsmInput
    public var userId: GraphQLID
    
    public init(input: FsmInput, userId: GraphQLID) {
        self.input = input
        self.userId = userId
    }
    
    public var variables: GraphQLMap? {
        return ["input": input, "userId": userId]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Mutation"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("triggerFsm", arguments: ["input": GraphQLVariable("input"), "userId": GraphQLVariable("userId")], type: .nonNull(.scalar(String.self))),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(triggerFsm: String) {
            self.init(snapshot: ["__typename": "Mutation", "triggerFsm": triggerFsm])
        }
        
        public var triggerFsm: String {
            get {
                return snapshot["triggerFsm"]! as! String
            }
            set {
                snapshot.updateValue(newValue, forKey: "triggerFsm")
            }
        }
    }
}

public final class GetUserChannelViewQuery: GraphQLQuery {
    public static let operationString =
    "query GetUserChannelView {\n  getUserChannel {\n    __typename\n    userVibes {\n      __typename\n      nextToken\n      userVibes {\n        __typename\n        vibeId\n        vibeTypeTagGsiPk\n        vibeTypeGsiPk\n        version\n        updatedTime\n        vibeName\n        isSender\n        isAnonymous\n        seen\n        reach\n        profileId\n        hailIds\n      }\n      profiles {\n        __typename\n        id\n        mobileNumber\n        username\n        name\n        profilePicId\n      }\n      hails {\n        __typename\n        id\n        vibeId\n        author\n        comment\n        createdAt\n      }\n    }\n    profiles {\n      __typename\n      id\n      mobileNumber\n      username\n      name\n      profilePicId\n    }\n    lastPublicVibeFetchTime\n  }\n}"
    
    public init() {
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Query"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("getUserChannel", type: .object(GetUserChannel.selections)),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(getUserChannel: GetUserChannel? = nil) {
            self.init(snapshot: ["__typename": "Query", "getUserChannel": getUserChannel.flatMap { $0.snapshot }])
        }
        
        public var getUserChannel: GetUserChannel? {
            get {
                return (snapshot["getUserChannel"] as? Snapshot).flatMap { GetUserChannel(snapshot: $0) }
            }
            set {
                snapshot.updateValue(newValue?.snapshot, forKey: "getUserChannel")
            }
        }
        
        public struct GetUserChannel: GraphQLSelectionSet {
            public static let possibleTypes = ["UserChannelView"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("userVibes", type: .object(UserVibe.selections)),
                GraphQLField("profiles", type: .list(.nonNull(.object(Profile.selections)))),
                GraphQLField("lastPublicVibeFetchTime", type: .scalar(Int.self)),
                ]
            
            public var snapshot: Snapshot
            
            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }
            
            public init(userVibes: UserVibe? = nil, profiles: [Profile]? = nil, lastPublicVibeFetchTime: Int? = nil) {
                self.init(snapshot: ["__typename": "UserChannelView", "userVibes": userVibes.flatMap { $0.snapshot }, "profiles": profiles.flatMap { $0.map { $0.snapshot } }, "lastPublicVibeFetchTime": lastPublicVibeFetchTime])
            }
            
            public var __typename: String {
                get {
                    return snapshot["__typename"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                }
            }
            
            public var userVibes: UserVibe? {
                get {
                    return (snapshot["userVibes"] as? Snapshot).flatMap { UserVibe(snapshot: $0) }
                }
                set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "userVibes")
                }
            }
            
            public var profiles: [Profile]? {
                get {
                    return (snapshot["profiles"] as? [Snapshot]).flatMap { $0.map { Profile(snapshot: $0) } }
                }
                set {
                    snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "profiles")
                }
            }
            
            public var lastPublicVibeFetchTime: Int? {
                get {
                    return snapshot["lastPublicVibeFetchTime"] as? Int
                }
                set {
                    snapshot.updateValue(newValue, forKey: "lastPublicVibeFetchTime")
                }
            }
            
            public struct UserVibe: GraphQLSelectionSet {
                public static let possibleTypes = ["UserVibeConnection"]
                
                public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("nextToken", type: .scalar(String.self)),
                    GraphQLField("userVibes", type: .list(.nonNull(.object(UserVibe.selections)))),
                    GraphQLField("profiles", type: .list(.nonNull(.object(Profile.selections)))),
                    GraphQLField("hails", type: .list(.nonNull(.object(Hail.selections)))),
                    ]
                
                public var snapshot: Snapshot
                
                public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                }
                
                public init(nextToken: String? = nil, userVibes: [UserVibe]? = nil, profiles: [Profile]? = nil, hails: [Hail]? = nil) {
                    self.init(snapshot: ["__typename": "UserVibeConnection", "nextToken": nextToken, "userVibes": userVibes.flatMap { $0.map { $0.snapshot } }, "profiles": profiles.flatMap { $0.map { $0.snapshot } }, "hails": hails.flatMap { $0.map { $0.snapshot } }])
                }
                
                public var __typename: String {
                    get {
                        return snapshot["__typename"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                    }
                }
                
                public var nextToken: String? {
                    get {
                        return snapshot["nextToken"] as? String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "nextToken")
                    }
                }
                
                public var userVibes: [UserVibe]? {
                    get {
                        return (snapshot["userVibes"] as? [Snapshot]).flatMap { $0.map { UserVibe(snapshot: $0) } }
                    }
                    set {
                        snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "userVibes")
                    }
                }
                
                public var profiles: [Profile]? {
                    get {
                        return (snapshot["profiles"] as? [Snapshot]).flatMap { $0.map { Profile(snapshot: $0) } }
                    }
                    set {
                        snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "profiles")
                    }
                }
                
                public var hails: [Hail]? {
                    get {
                        return (snapshot["hails"] as? [Snapshot]).flatMap { $0.map { Hail(snapshot: $0) } }
                    }
                    set {
                        snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "hails")
                    }
                }
                
                public struct UserVibe: GraphQLSelectionSet {
                    public static let possibleTypes = ["UserVibe"]
                    
                    public static let selections: [GraphQLSelection] = [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("vibeId", type: .nonNull(.scalar(GraphQLID.self))),
                        GraphQLField("vibeTypeTagGsiPk", type: .nonNull(.scalar(GraphQLID.self))),
                        GraphQLField("vibeTypeGsiPk", type: .nonNull(.scalar(GraphQLID.self))),
                        GraphQLField("version", type: .nonNull(.scalar(Int.self))),
                        GraphQLField("updatedTime", type: .nonNull(.scalar(Int.self))),
                        GraphQLField("vibeName", type: .nonNull(.scalar(String.self))),
                        GraphQLField("isSender", type: .nonNull(.scalar(Bool.self))),
                        GraphQLField("isAnonymous", type: .nonNull(.scalar(Bool.self))),
                        GraphQLField("seen", type: .nonNull(.scalar(Bool.self))),
                        GraphQLField("reach", type: .nonNull(.scalar(Int.self))),
                        GraphQLField("profileId", type: .scalar(GraphQLID.self)),
                        GraphQLField("hailIds", type: .list(.nonNull(.scalar(GraphQLID.self)))),
                        ]
                    
                    public var snapshot: Snapshot
                    
                    public init(snapshot: Snapshot) {
                        self.snapshot = snapshot
                    }
                    
                    public init(vibeId: GraphQLID, vibeTypeTagGsiPk: GraphQLID, vibeTypeGsiPk: GraphQLID, version: Int, updatedTime: Int, vibeName: String, isSender: Bool, isAnonymous: Bool, seen: Bool, reach: Int, profileId: GraphQLID? = nil, hailIds: [GraphQLID]? = nil) {
                        self.init(snapshot: ["__typename": "UserVibe", "vibeId": vibeId, "vibeTypeTagGsiPk": vibeTypeTagGsiPk, "vibeTypeGsiPk": vibeTypeGsiPk, "version": version, "updatedTime": updatedTime, "vibeName": vibeName, "isSender": isSender, "isAnonymous": isAnonymous, "seen": seen, "reach": reach, "profileId": profileId, "hailIds": hailIds])
                    }
                    
                    public var __typename: String {
                        get {
                            return snapshot["__typename"]! as! String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "__typename")
                        }
                    }
                    
                    public var vibeId: GraphQLID {
                        get {
                            return snapshot["vibeId"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "vibeId")
                        }
                    }
                    
                    /// # GSI PK (userId_tag_type)
                    public var vibeTypeTagGsiPk: GraphQLID {
                        get {
                            return snapshot["vibeTypeTagGsiPk"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "vibeTypeTagGsiPk")
                        }
                    }
                    
                    /// # GSI PK (userId_type)
                    public var vibeTypeGsiPk: GraphQLID {
                        get {
                            return snapshot["vibeTypeGsiPk"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "vibeTypeGsiPk")
                        }
                    }
                    
                    public var version: Int {
                        get {
                            return snapshot["version"]! as! Int
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "version")
                        }
                    }
                    
                    public var updatedTime: Int {
                        get {
                            return snapshot["updatedTime"]! as! Int
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "updatedTime")
                        }
                    }
                    
                    /// # Vibe Info
                    public var vibeName: String {
                        get {
                            return snapshot["vibeName"]! as! String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "vibeName")
                        }
                    }
                    
                    public var isSender: Bool {
                        get {
                            return snapshot["isSender"]! as! Bool
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "isSender")
                        }
                    }
                    
                    public var isAnonymous: Bool {
                        get {
                            return snapshot["isAnonymous"]! as! Bool
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "isAnonymous")
                        }
                    }
                    
                    public var seen: Bool {
                        get {
                            return snapshot["seen"]! as! Bool
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "seen")
                        }
                    }
                    
                    public var reach: Int {
                        get {
                            return snapshot["reach"]! as! Int
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "reach")
                        }
                    }
                    
                    /// # Profile Info
                    public var profileId: GraphQLID? {
                        get {
                            return snapshot["profileId"] as? GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "profileId")
                        }
                    }
                    
                    /// # Hail Info
                    public var hailIds: [GraphQLID]? {
                        get {
                            return snapshot["hailIds"] as? [GraphQLID]
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "hailIds")
                        }
                    }
                }
                
                public struct Profile: GraphQLSelectionSet {
                    public static let possibleTypes = ["UserProfile"]
                    
                    public static let selections: [GraphQLSelection] = [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                        GraphQLField("mobileNumber", type: .nonNull(.scalar(GraphQLID.self))),
                        GraphQLField("username", type: .nonNull(.scalar(String.self))),
                        GraphQLField("name", type: .scalar(String.self)),
                        GraphQLField("profilePicId", type: .scalar(String.self)),
                        ]
                    
                    public var snapshot: Snapshot
                    
                    public init(snapshot: Snapshot) {
                        self.snapshot = snapshot
                    }
                    
                    public init(id: GraphQLID, mobileNumber: GraphQLID, username: String, name: String? = nil, profilePicId: String? = nil) {
                        self.init(snapshot: ["__typename": "UserProfile", "id": id, "mobileNumber": mobileNumber, "username": username, "name": name, "profilePicId": profilePicId])
                    }
                    
                    public var __typename: String {
                        get {
                            return snapshot["__typename"]! as! String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "__typename")
                        }
                    }
                    
                    public var id: GraphQLID {
                        get {
                            return snapshot["id"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "id")
                        }
                    }
                    
                    public var mobileNumber: GraphQLID {
                        get {
                            return snapshot["mobileNumber"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "mobileNumber")
                        }
                    }
                    
                    public var username: String {
                        get {
                            return snapshot["username"]! as! String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "username")
                        }
                    }
                    
                    public var name: String? {
                        get {
                            return snapshot["name"] as? String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "name")
                        }
                    }
                    
                    public var profilePicId: String? {
                        get {
                            return snapshot["profilePicId"] as? String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "profilePicId")
                        }
                    }
                }
                
                public struct Hail: GraphQLSelectionSet {
                    public static let possibleTypes = ["Hail"]
                    
                    public static let selections: [GraphQLSelection] = [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                        GraphQLField("vibeId", type: .nonNull(.scalar(GraphQLID.self))),
                        GraphQLField("author", type: .nonNull(.scalar(GraphQLID.self))),
                        GraphQLField("comment", type: .nonNull(.scalar(String.self))),
                        GraphQLField("createdAt", type: .nonNull(.scalar(Int.self))),
                        ]
                    
                    public var snapshot: Snapshot
                    
                    public init(snapshot: Snapshot) {
                        self.snapshot = snapshot
                    }
                    
                    public init(id: GraphQLID, vibeId: GraphQLID, author: GraphQLID, comment: String, createdAt: Int) {
                        self.init(snapshot: ["__typename": "Hail", "id": id, "vibeId": vibeId, "author": author, "comment": comment, "createdAt": createdAt])
                    }
                    
                    public var __typename: String {
                        get {
                            return snapshot["__typename"]! as! String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "__typename")
                        }
                    }
                    
                    public var id: GraphQLID {
                        get {
                            return snapshot["id"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "id")
                        }
                    }
                    
                    public var vibeId: GraphQLID {
                        get {
                            return snapshot["vibeId"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "vibeId")
                        }
                    }
                    
                    public var author: GraphQLID {
                        get {
                            return snapshot["author"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "author")
                        }
                    }
                    
                    public var comment: String {
                        get {
                            return snapshot["comment"]! as! String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "comment")
                        }
                    }
                    
                    public var createdAt: Int {
                        get {
                            return snapshot["createdAt"]! as! Int
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "createdAt")
                        }
                    }
                }
            }
            
            public struct Profile: GraphQLSelectionSet {
                public static let possibleTypes = ["UserProfile"]
                
                public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                    GraphQLField("mobileNumber", type: .nonNull(.scalar(GraphQLID.self))),
                    GraphQLField("username", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .scalar(String.self)),
                    GraphQLField("profilePicId", type: .scalar(String.self)),
                    ]
                
                public var snapshot: Snapshot
                
                public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                }
                
                public init(id: GraphQLID, mobileNumber: GraphQLID, username: String, name: String? = nil, profilePicId: String? = nil) {
                    self.init(snapshot: ["__typename": "UserProfile", "id": id, "mobileNumber": mobileNumber, "username": username, "name": name, "profilePicId": profilePicId])
                }
                
                public var __typename: String {
                    get {
                        return snapshot["__typename"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                    }
                }
                
                public var id: GraphQLID {
                    get {
                        return snapshot["id"]! as! GraphQLID
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "id")
                    }
                }
                
                public var mobileNumber: GraphQLID {
                    get {
                        return snapshot["mobileNumber"]! as! GraphQLID
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "mobileNumber")
                    }
                }
                
                public var username: String {
                    get {
                        return snapshot["username"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "username")
                    }
                }
                
                public var name: String? {
                    get {
                        return snapshot["name"] as? String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "name")
                    }
                }
                
                public var profilePicId: String? {
                    get {
                        return snapshot["profilePicId"] as? String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "profilePicId")
                    }
                }
            }
        }
    }
}

public final class DeleteUserChannelUpdatesMutation: GraphQLMutation {
    public static let operationString =
    "mutation DeleteUserChannelUpdates($liveVibeBucketIds: [ID!], $liveProfileBucketIds: [ID!]) {\n  deleteUserChannelUpdates(liveVibeBucketIds: $liveVibeBucketIds, liveProfileBucketIds: $liveProfileBucketIds)\n}"
    
    public var liveVibeBucketIds: [GraphQLID]?
    public var liveProfileBucketIds: [GraphQLID]?
    
    public init(liveVibeBucketIds: [GraphQLID]?, liveProfileBucketIds: [GraphQLID]?) {
        self.liveVibeBucketIds = liveVibeBucketIds
        self.liveProfileBucketIds = liveProfileBucketIds
    }
    
    public var variables: GraphQLMap? {
        return ["liveVibeBucketIds": liveVibeBucketIds, "liveProfileBucketIds": liveProfileBucketIds]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Mutation"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("deleteUserChannelUpdates", arguments: ["liveVibeBucketIds": GraphQLVariable("liveVibeBucketIds"), "liveProfileBucketIds": GraphQLVariable("liveProfileBucketIds")], type: .nonNull(.scalar(String.self))),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(deleteUserChannelUpdates: String) {
            self.init(snapshot: ["__typename": "Mutation", "deleteUserChannelUpdates": deleteUserChannelUpdates])
        }
        
        public var deleteUserChannelUpdates: String {
            get {
                return snapshot["deleteUserChannelUpdates"]! as! String
            }
            set {
                snapshot.updateValue(newValue, forKey: "deleteUserChannelUpdates")
            }
        }
    }
}

public final class GetPaginatedUserVibesQuery: GraphQLQuery {
    public static let operationString =
    "query GetPaginatedUserVibes($vibeTag: VibeTag!, $vibeType: VibeType!, $first: Int, $after: String) {\n  getUserVibes(vibeTag: $vibeTag, vibeType: $vibeType, first: $first, after: $after) {\n    __typename\n    nextToken\n    userVibes {\n      __typename\n      vibeId\n      vibeTypeTagGsiPk\n      vibeTypeGsiPk\n      version\n      updatedTime\n      vibeName\n      isSender\n      isAnonymous\n      seen\n      reach\n      profileId\n      hailIds\n      hailProfileIds\n    }\n    profiles {\n      __typename\n      id\n      mobileNumber\n      username\n      name\n      profilePicId\n    }\n    hails {\n      __typename\n      id\n      vibeId\n      author\n      comment\n      createdAt\n    }\n  }\n}"
    
    public var vibeTag: VibeTag
    public var vibeType: VibeType
    public var first: Int?
    public var after: String?
    
    public init(vibeTag: VibeTag, vibeType: VibeType, first: Int? = nil, after: String? = nil) {
        self.vibeTag = vibeTag
        self.vibeType = vibeType
        self.first = first
        self.after = after
    }
    
    public var variables: GraphQLMap? {
        return ["vibeTag": vibeTag, "vibeType": vibeType, "first": first, "after": after]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Query"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("getUserVibes", arguments: ["vibeTag": GraphQLVariable("vibeTag"), "vibeType": GraphQLVariable("vibeType"), "first": GraphQLVariable("first"), "after": GraphQLVariable("after")], type: .object(GetUserVibe.selections)),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(getUserVibes: GetUserVibe? = nil) {
            self.init(snapshot: ["__typename": "Query", "getUserVibes": getUserVibes.flatMap { $0.snapshot }])
        }
        
        public var getUserVibes: GetUserVibe? {
            get {
                return (snapshot["getUserVibes"] as? Snapshot).flatMap { GetUserVibe(snapshot: $0) }
            }
            set {
                snapshot.updateValue(newValue?.snapshot, forKey: "getUserVibes")
            }
        }
        
        public struct GetUserVibe: GraphQLSelectionSet {
            public static let possibleTypes = ["UserVibeConnection"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("nextToken", type: .scalar(String.self)),
                GraphQLField("userVibes", type: .list(.nonNull(.object(UserVibe.selections)))),
                GraphQLField("profiles", type: .list(.nonNull(.object(Profile.selections)))),
                GraphQLField("hails", type: .list(.nonNull(.object(Hail.selections)))),
                ]
            
            public var snapshot: Snapshot
            
            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }
            
            public init(nextToken: String? = nil, userVibes: [UserVibe]? = nil, profiles: [Profile]? = nil, hails: [Hail]? = nil) {
                self.init(snapshot: ["__typename": "UserVibeConnection", "nextToken": nextToken, "userVibes": userVibes.flatMap { $0.map { $0.snapshot } }, "profiles": profiles.flatMap { $0.map { $0.snapshot } }, "hails": hails.flatMap { $0.map { $0.snapshot } }])
            }
            
            public var __typename: String {
                get {
                    return snapshot["__typename"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                }
            }
            
            public var nextToken: String? {
                get {
                    return snapshot["nextToken"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "nextToken")
                }
            }
            
            public var userVibes: [UserVibe]? {
                get {
                    return (snapshot["userVibes"] as? [Snapshot]).flatMap { $0.map { UserVibe(snapshot: $0) } }
                }
                set {
                    snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "userVibes")
                }
            }
            
            public var profiles: [Profile]? {
                get {
                    return (snapshot["profiles"] as? [Snapshot]).flatMap { $0.map { Profile(snapshot: $0) } }
                }
                set {
                    snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "profiles")
                }
            }
            
            public var hails: [Hail]? {
                get {
                    return (snapshot["hails"] as? [Snapshot]).flatMap { $0.map { Hail(snapshot: $0) } }
                }
                set {
                    snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "hails")
                }
            }
            
            public struct UserVibe: GraphQLSelectionSet {
                public static let possibleTypes = ["UserVibe"]
                
                public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("vibeId", type: .nonNull(.scalar(GraphQLID.self))),
                    GraphQLField("vibeTypeTagGsiPk", type: .nonNull(.scalar(GraphQLID.self))),
                    GraphQLField("vibeTypeGsiPk", type: .nonNull(.scalar(GraphQLID.self))),
                    GraphQLField("version", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("updatedTime", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("vibeName", type: .nonNull(.scalar(String.self))),
                    GraphQLField("isSender", type: .nonNull(.scalar(Bool.self))),
                    GraphQLField("isAnonymous", type: .nonNull(.scalar(Bool.self))),
                    GraphQLField("seen", type: .nonNull(.scalar(Bool.self))),
                    GraphQLField("reach", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("profileId", type: .scalar(GraphQLID.self)),
                    GraphQLField("hailIds", type: .list(.nonNull(.scalar(GraphQLID.self)))),
                    GraphQLField("hailProfileIds", type: .list(.nonNull(.scalar(GraphQLID.self)))),
                    ]
                
                public var snapshot: Snapshot
                
                public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                }
                
                public init(vibeId: GraphQLID, vibeTypeTagGsiPk: GraphQLID, vibeTypeGsiPk: GraphQLID, version: Int, updatedTime: Int, vibeName: String, isSender: Bool, isAnonymous: Bool, seen: Bool, reach: Int, profileId: GraphQLID? = nil, hailIds: [GraphQLID]? = nil, hailProfileIds: [GraphQLID]? = nil) {
                    self.init(snapshot: ["__typename": "UserVibe", "vibeId": vibeId, "vibeTypeTagGsiPk": vibeTypeTagGsiPk, "vibeTypeGsiPk": vibeTypeGsiPk, "version": version, "updatedTime": updatedTime, "vibeName": vibeName, "isSender": isSender, "isAnonymous": isAnonymous, "seen": seen, "reach": reach, "profileId": profileId, "hailIds": hailIds, "hailProfileIds": hailProfileIds])
                }
                
                public var __typename: String {
                    get {
                        return snapshot["__typename"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                    }
                }
                
                public var vibeId: GraphQLID {
                    get {
                        return snapshot["vibeId"]! as! GraphQLID
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "vibeId")
                    }
                }
                
                /// # GSI PK (userId_tag_type)
                public var vibeTypeTagGsiPk: GraphQLID {
                    get {
                        return snapshot["vibeTypeTagGsiPk"]! as! GraphQLID
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "vibeTypeTagGsiPk")
                    }
                }
                
                /// # GSI PK (userId_type)
                public var vibeTypeGsiPk: GraphQLID {
                    get {
                        return snapshot["vibeTypeGsiPk"]! as! GraphQLID
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "vibeTypeGsiPk")
                    }
                }
                
                public var version: Int {
                    get {
                        return snapshot["version"]! as! Int
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "version")
                    }
                }
                
                public var updatedTime: Int {
                    get {
                        return snapshot["updatedTime"]! as! Int
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "updatedTime")
                    }
                }
                
                /// # Vibe Info
                public var vibeName: String {
                    get {
                        return snapshot["vibeName"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "vibeName")
                    }
                }
                
                public var isSender: Bool {
                    get {
                        return snapshot["isSender"]! as! Bool
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "isSender")
                    }
                }
                
                public var isAnonymous: Bool {
                    get {
                        return snapshot["isAnonymous"]! as! Bool
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "isAnonymous")
                    }
                }
                
                public var seen: Bool {
                    get {
                        return snapshot["seen"]! as! Bool
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "seen")
                    }
                }
                
                public var reach: Int {
                    get {
                        return snapshot["reach"]! as! Int
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "reach")
                    }
                }
                
                /// # Profile Info
                public var profileId: GraphQLID? {
                    get {
                        return snapshot["profileId"] as? GraphQLID
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "profileId")
                    }
                }
                
                /// # Hail Info
                public var hailIds: [GraphQLID]? {
                    get {
                        return snapshot["hailIds"] as? [GraphQLID]
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "hailIds")
                    }
                }
                
                public var hailProfileIds: [GraphQLID]? {
                    get {
                        return snapshot["hailProfileIds"] as? [GraphQLID]
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "hailProfileIds")
                    }
                }
            }
            
            public struct Profile: GraphQLSelectionSet {
                public static let possibleTypes = ["UserProfile"]
                
                public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                    GraphQLField("mobileNumber", type: .nonNull(.scalar(GraphQLID.self))),
                    GraphQLField("username", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .scalar(String.self)),
                    GraphQLField("profilePicId", type: .scalar(String.self)),
                    ]
                
                public var snapshot: Snapshot
                
                public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                }
                
                public init(id: GraphQLID, mobileNumber: GraphQLID, username: String, name: String? = nil, profilePicId: String? = nil) {
                    self.init(snapshot: ["__typename": "UserProfile", "id": id, "mobileNumber": mobileNumber, "username": username, "name": name, "profilePicId": profilePicId])
                }
                
                public var __typename: String {
                    get {
                        return snapshot["__typename"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                    }
                }
                
                public var id: GraphQLID {
                    get {
                        return snapshot["id"]! as! GraphQLID
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "id")
                    }
                }
                
                public var mobileNumber: GraphQLID {
                    get {
                        return snapshot["mobileNumber"]! as! GraphQLID
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "mobileNumber")
                    }
                }
                
                public var username: String {
                    get {
                        return snapshot["username"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "username")
                    }
                }
                
                public var name: String? {
                    get {
                        return snapshot["name"] as? String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "name")
                    }
                }
                
                public var profilePicId: String? {
                    get {
                        return snapshot["profilePicId"] as? String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "profilePicId")
                    }
                }
            }
            
            public struct Hail: GraphQLSelectionSet {
                public static let possibleTypes = ["Hail"]
                
                public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                    GraphQLField("vibeId", type: .nonNull(.scalar(GraphQLID.self))),
                    GraphQLField("author", type: .nonNull(.scalar(GraphQLID.self))),
                    GraphQLField("comment", type: .nonNull(.scalar(String.self))),
                    GraphQLField("createdAt", type: .nonNull(.scalar(Int.self))),
                    ]
                
                public var snapshot: Snapshot
                
                public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                }
                
                public init(id: GraphQLID, vibeId: GraphQLID, author: GraphQLID, comment: String, createdAt: Int) {
                    self.init(snapshot: ["__typename": "Hail", "id": id, "vibeId": vibeId, "author": author, "comment": comment, "createdAt": createdAt])
                }
                
                public var __typename: String {
                    get {
                        return snapshot["__typename"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                    }
                }
                
                public var id: GraphQLID {
                    get {
                        return snapshot["id"]! as! GraphQLID
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "id")
                    }
                }
                
                public var vibeId: GraphQLID {
                    get {
                        return snapshot["vibeId"]! as! GraphQLID
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "vibeId")
                    }
                }
                
                public var author: GraphQLID {
                    get {
                        return snapshot["author"]! as! GraphQLID
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "author")
                    }
                }
                
                public var comment: String {
                    get {
                        return snapshot["comment"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "comment")
                    }
                }
                
                public var createdAt: Int {
                    get {
                        return snapshot["createdAt"]! as! Int
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "createdAt")
                    }
                }
            }
        }
    }
}
