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
    
    public init(id: GraphQLID, mobileNumber: GraphQLID, username: String, name: Optional<String?> = nil, dob: Optional<String?> = nil, gender: Optional<Gender?> = nil, profilePicId: Optional<String?> = nil) {
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
    
    public var name: Optional<String?> {
        get {
            return graphQLMap["name"] as! Optional<String?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "name")
        }
    }
    
    public var dob: Optional<String?> {
        get {
            return graphQLMap["dob"] as! Optional<String?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "dob")
        }
    }
    
    public var gender: Optional<Gender?> {
        get {
            return graphQLMap["gender"] as! Optional<Gender?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "gender")
        }
    }
    
    public var profilePicId: Optional<String?> {
        get {
            return graphQLMap["profilePicId"] as! Optional<String?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "profilePicId")
        }
    }
}

/// #Enums
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
    
    public init(id: GraphQLID, username: Optional<String?> = nil, name: Optional<String?> = nil, dob: Optional<String?> = nil, gender: Optional<Gender?> = nil, profilePicId: Optional<String?> = nil) {
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
    
    public var username: Optional<String?> {
        get {
            return graphQLMap["username"] as! Optional<String?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "username")
        }
    }
    
    public var name: Optional<String?> {
        get {
            return graphQLMap["name"] as! Optional<String?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "name")
        }
    }
    
    public var dob: Optional<String?> {
        get {
            return graphQLMap["dob"] as! Optional<String?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "dob")
        }
    }
    
    public var gender: Optional<Gender?> {
        get {
            return graphQLMap["gender"] as! Optional<Gender?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "gender")
        }
    }
    
    public var profilePicId: Optional<String?> {
        get {
            return graphQLMap["profilePicId"] as! Optional<String?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "profilePicId")
        }
    }
}

/// # UserConnection Inputs
public struct CreateUserConnectionInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap
    
    public init(mobileNumber: GraphQLID, userId: Optional<GraphQLID?> = nil, managedChannelIds: Optional<String?> = nil, queuedChannelIds: Optional<String?> = nil, pendingVibeAccessIds: Optional<String?> = nil, pendingVibeDeleteIds: Optional<String?> = nil) {
        graphQLMap = ["mobileNumber": mobileNumber, "userId": userId, "managedChannelIds": managedChannelIds, "queuedChannelIds": queuedChannelIds, "pendingVibeAccessIds": pendingVibeAccessIds, "pendingVibeDeleteIds": pendingVibeDeleteIds]
    }
    
    public var mobileNumber: GraphQLID {
        get {
            return graphQLMap["mobileNumber"] as! GraphQLID
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "mobileNumber")
        }
    }
    
    public var userId: Optional<GraphQLID?> {
        get {
            return graphQLMap["userId"] as! Optional<GraphQLID?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "userId")
        }
    }
    
    public var managedChannelIds: Optional<String?> {
        get {
            return graphQLMap["managedChannelIds"] as! Optional<String?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "managedChannelIds")
        }
    }
    
    public var queuedChannelIds: Optional<String?> {
        get {
            return graphQLMap["queuedChannelIds"] as! Optional<String?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "queuedChannelIds")
        }
    }
    
    public var pendingVibeAccessIds: Optional<String?> {
        get {
            return graphQLMap["pendingVibeAccessIds"] as! Optional<String?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "pendingVibeAccessIds")
        }
    }
    
    public var pendingVibeDeleteIds: Optional<String?> {
        get {
            return graphQLMap["pendingVibeDeleteIds"] as! Optional<String?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "pendingVibeDeleteIds")
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

public final class CreateUserConnectionMutation: GraphQLMutation {
    public static let operationString =
    "mutation CreateUserConnection($input: CreateUserConnectionInput!) {\n  createUserConnection(input: $input) {\n    __typename\n    mobileNumber\n    userId\n    pendingVibeAccessIds\n    pendingVibeDeleteIds\n    managedChannelIds\n    queuedChannelIds\n  }\n}"
    
    public var input: CreateUserConnectionInput
    
    public init(input: CreateUserConnectionInput) {
        self.input = input
    }
    
    public var variables: GraphQLMap? {
        return ["input": input]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Mutation"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("createUserConnection", arguments: ["input": GraphQLVariable("input")], type: .object(CreateUserConnection.selections)),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(createUserConnection: CreateUserConnection? = nil) {
            self.init(snapshot: ["__typename": "Mutation", "createUserConnection": createUserConnection.flatMap { $0.snapshot }])
        }
        
        public var createUserConnection: CreateUserConnection? {
            get {
                return (snapshot["createUserConnection"] as? Snapshot).flatMap { CreateUserConnection(snapshot: $0) }
            }
            set {
                snapshot.updateValue(newValue?.snapshot, forKey: "createUserConnection")
            }
        }
        
        public struct CreateUserConnection: GraphQLSelectionSet {
            public static let possibleTypes = ["UserConnection"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("mobileNumber", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("userId", type: .scalar(GraphQLID.self)),
                GraphQLField("pendingVibeAccessIds", type: .list(.nonNull(.scalar(GraphQLID.self)))),
                GraphQLField("pendingVibeDeleteIds", type: .list(.nonNull(.scalar(GraphQLID.self)))),
                GraphQLField("managedChannelIds", type: .scalar(String.self)),
                GraphQLField("queuedChannelIds", type: .scalar(String.self)),
                ]
            
            public var snapshot: Snapshot
            
            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }
            
            public init(mobileNumber: GraphQLID, userId: GraphQLID? = nil, pendingVibeAccessIds: [GraphQLID]? = nil, pendingVibeDeleteIds: [GraphQLID]? = nil, managedChannelIds: String? = nil, queuedChannelIds: String? = nil) {
                self.init(snapshot: ["__typename": "UserConnection", "mobileNumber": mobileNumber, "userId": userId, "pendingVibeAccessIds": pendingVibeAccessIds, "pendingVibeDeleteIds": pendingVibeDeleteIds, "managedChannelIds": managedChannelIds, "queuedChannelIds": queuedChannelIds])
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
            
            public var userId: GraphQLID? {
                get {
                    return snapshot["userId"] as? GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "userId")
                }
            }
            
            public var pendingVibeAccessIds: [GraphQLID]? {
                get {
                    return snapshot["pendingVibeAccessIds"] as? [GraphQLID]
                }
                set {
                    snapshot.updateValue(newValue, forKey: "pendingVibeAccessIds")
                }
            }
            
            public var pendingVibeDeleteIds: [GraphQLID]? {
                get {
                    return snapshot["pendingVibeDeleteIds"] as? [GraphQLID]
                }
                set {
                    snapshot.updateValue(newValue, forKey: "pendingVibeDeleteIds")
                }
            }
            
            public var managedChannelIds: String? {
                get {
                    return snapshot["managedChannelIds"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "managedChannelIds")
                }
            }
            
            public var queuedChannelIds: String? {
                get {
                    return snapshot["queuedChannelIds"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "queuedChannelIds")
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

public final class GetUserConnectionQuery: GraphQLQuery {
    public static let operationString =
    "query GetUserConnection($mobileNumber: ID!, $userId: ID!) {\n  getUserConnection(mobileNumber: $mobileNumber, userId: $userId) {\n    __typename\n    userId\n    mobileNumber\n    managedChannelIds\n    queuedChannelIds\n    pendingVibeAccessIds\n    pendingVibeDeleteIds\n  }\n}"
    
    public var mobileNumber: GraphQLID
    public var userId: GraphQLID
    
    public init(mobileNumber: GraphQLID, userId: GraphQLID) {
        self.mobileNumber = mobileNumber
        self.userId = userId
    }
    
    public var variables: GraphQLMap? {
        return ["mobileNumber": mobileNumber, "userId": userId]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Query"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("getUserConnection", arguments: ["mobileNumber": GraphQLVariable("mobileNumber"), "userId": GraphQLVariable("userId")], type: .object(GetUserConnection.selections)),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(getUserConnection: GetUserConnection? = nil) {
            self.init(snapshot: ["__typename": "Query", "getUserConnection": getUserConnection.flatMap { $0.snapshot }])
        }
        
        public var getUserConnection: GetUserConnection? {
            get {
                return (snapshot["getUserConnection"] as? Snapshot).flatMap { GetUserConnection(snapshot: $0) }
            }
            set {
                snapshot.updateValue(newValue?.snapshot, forKey: "getUserConnection")
            }
        }
        
        public struct GetUserConnection: GraphQLSelectionSet {
            public static let possibleTypes = ["UserConnection"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("userId", type: .scalar(GraphQLID.self)),
                GraphQLField("mobileNumber", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("managedChannelIds", type: .scalar(String.self)),
                GraphQLField("queuedChannelIds", type: .scalar(String.self)),
                GraphQLField("pendingVibeAccessIds", type: .list(.nonNull(.scalar(GraphQLID.self)))),
                GraphQLField("pendingVibeDeleteIds", type: .list(.nonNull(.scalar(GraphQLID.self)))),
                ]
            
            public var snapshot: Snapshot
            
            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }
            
            public init(userId: GraphQLID? = nil, mobileNumber: GraphQLID, managedChannelIds: String? = nil, queuedChannelIds: String? = nil, pendingVibeAccessIds: [GraphQLID]? = nil, pendingVibeDeleteIds: [GraphQLID]? = nil) {
                self.init(snapshot: ["__typename": "UserConnection", "userId": userId, "mobileNumber": mobileNumber, "managedChannelIds": managedChannelIds, "queuedChannelIds": queuedChannelIds, "pendingVibeAccessIds": pendingVibeAccessIds, "pendingVibeDeleteIds": pendingVibeDeleteIds])
            }
            
            public var __typename: String {
                get {
                    return snapshot["__typename"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                }
            }
            
            public var userId: GraphQLID? {
                get {
                    return snapshot["userId"] as? GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "userId")
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
            
            public var managedChannelIds: String? {
                get {
                    return snapshot["managedChannelIds"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "managedChannelIds")
                }
            }
            
            public var queuedChannelIds: String? {
                get {
                    return snapshot["queuedChannelIds"] as? String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "queuedChannelIds")
                }
            }
            
            public var pendingVibeAccessIds: [GraphQLID]? {
                get {
                    return snapshot["pendingVibeAccessIds"] as? [GraphQLID]
                }
                set {
                    snapshot.updateValue(newValue, forKey: "pendingVibeAccessIds")
                }
            }
            
            public var pendingVibeDeleteIds: [GraphQLID]? {
                get {
                    return snapshot["pendingVibeDeleteIds"] as? [GraphQLID]
                }
                set {
                    snapshot.updateValue(newValue, forKey: "pendingVibeDeleteIds")
                }
            }
        }
    }
}
