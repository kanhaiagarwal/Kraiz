//
//  Cognito.swift
//  Kraiz
//
//  Created by Kumar Agarwal, Kanhai on 27/08/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider
import Reachability

class CognitoHelper {
    
    static let shared = CognitoHelper()
    
    private init() {}
    
    /// Sign In Helper Method.
    /// - Parameters
    ///     - pool: AWS Cognito Pool.
    ///     - usernameText: Input Username.
    ///     - passwordText: Input Password.
    ///     - success: Closure to execute if the sign in is successful.
    ///     - failure: Closure to execute if the sign in failed.
    func signIn(pool: AWSCognitoIdentityUserPool, usernameText: String, passwordText: String, success: @escaping () -> Void, failure: @escaping (NSError) -> Void) {
        
        let reachability = Reachability()
        if reachability?.connection == Reachability.Connection.none {
            failure(DeviceConstants.NO_INTERNET_ERROR)
            return
        }
        
        let user = pool.getUser()
        user.getSession(usernameText, password: passwordText, validationData: nil)
            .continueOnSuccessWith { (task: AWSTask<AWSCognitoIdentityUserSession>) -> Any? in
                DispatchQueue.main.async(execute: {
                    if let result = task.result {
                        print("access token: \(result.accessToken?.tokenString)")
                        print("expiration time: \(result.expirationTime)")
                        print("id token: \(result.idToken?.tokenString)")
                        print(result.debugDescription)
                        success()
                    }
                })
                return nil
            }.continueWith { (task: AWSTask<AnyObject>) -> Any? in
                DispatchQueue.main.async(execute: {
                    if let error = task.error as? NSError {
                        print("Error")
                        print(error)
                        failure(error)
                    }
                })
                return nil
        }
    }
    
    /// Generate OTP For Sign Up.
    /// - Parameters
    ///     - pool: AWS Cognito Pool.
    ///     - usernameText: Input Username.
    ///     - passwordText: Input Password.
    ///     - success: Closure to execute if the OTP generation for Sign UP is successful.
    ///     - failure: Closure to execute if the OTP generation for Sign UP has failed.
    func generateOTPForSignUp(pool: AWSCognitoIdentityUserPool, usernameText: String, passwordText: String, success: @escaping (AWSCognitoIdentityUser) -> Void, failure: @escaping (NSError) -> Void) {
        
        let reachability = Reachability()
        if reachability?.connection == Reachability.Connection.none {
            failure(DeviceConstants.NO_INTERNET_ERROR)
            return
        }
        
        pool.signUp(usernameText, password: passwordText, userAttributes: nil, validationData: nil)
            .continueOnSuccessWith { (task: AWSTask<AWSCognitoIdentityUserPoolSignUpResponse>) -> Any? in
                DispatchQueue.main.async(execute: {
                    if let result = task.result {
                        success(result.user)
                    }
                })
                return nil
            }.continueWith { (task: AWSTask<AnyObject>) -> Any? in
                DispatchQueue.main.async(execute: {
                    if let error = task.error as? NSError {
                        failure(error)
                    }
                })
                return nil
        }
    }
    
    /// Verify OTP for Sign Up.
    /// - Parameters
    ///     - pool: AWS Cognito Pool.
    ///     - otp: Input OTP.
    ///     - success: Closure to execute if the OTP is verified successfully
    ///     - failure: Closure to execute if the OTP verification fails.
    func verifyOTPForSignUp(pool: AWSCognitoIdentityUserPool, user: AWSCognitoIdentityUser, otp: String, success: @escaping () -> Void, failure: @escaping (NSError) -> Void) {
        
        let reachability = Reachability()
        if reachability?.connection == Reachability.Connection.none {
            failure(DeviceConstants.NO_INTERNET_ERROR)
            return
        }
        
        user.confirmSignUp(otp)
            .continueOnSuccessWith { (task: AWSTask<AWSCognitoIdentityUserConfirmSignUpResponse>) -> Any? in
                DispatchQueue.main.async(execute: {
                    success()
                })
                return nil
            }.continueWith { (task: AWSTask<AnyObject>) -> Any? in
                DispatchQueue.main.async(execute: {
                    if let error = task.error as? NSError {
                        failure(error)
                    }
                })
                return nil
        }
    }
    
    /// Resend OTP for the Sign Up
    /// - Parameters
    ///     - pool: AWS Cognito Pool.
    ///     - otp: AWS Cognito Identity User.
    ///     - success: Closure to execute if the OTP resend action is successful.
    ///     - failure: Closure to execute if the OTP resend action fails.
    func resendOTPForSignUp(pool: AWSCognitoIdentityUserPool, user: AWSCognitoIdentityUser, success: @escaping () -> Void, failure: @escaping (NSError) -> Void) {
        
        let reachability = Reachability()
        if reachability?.connection == Reachability.Connection.none {
            failure(DeviceConstants.NO_INTERNET_ERROR)
            return
        }
        
        user.resendConfirmationCode().continueOnSuccessWith(block: { (task: AWSTask<AWSCognitoIdentityUserResendConfirmationCodeResponse>) -> Any? in
            DispatchQueue.main.async(execute: {
                success()
            })
            return nil
        }).continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
            DispatchQueue.main.async(execute: {
                if let error = task.error as? NSError {
                    failure(error)
                }
            })
            return nil
        })
    }
    
    /// Forgot Password Helper.
    /// - Parameters
    ///     - user: AWS Cognito Identity User of the input username.
    ///     - success: Closure to execute if the OTP send action is successful.
    ///     - failure: Closure to execute if the OTP send action fails.
    func forgotPassword(user: AWSCognitoIdentityUser, success: @escaping () -> Void, failure: @escaping (NSError) -> Void) {
        
        let reachability = Reachability()
        if reachability?.connection == Reachability.Connection.none {
            failure(DeviceConstants.NO_INTERNET_ERROR)
            return
        }
        
        user.forgotPassword()
        .continueOnSuccessWith(block: { (task: AWSTask<AWSCognitoIdentityUserForgotPasswordResponse>) -> Any? in
            DispatchQueue.main.async(execute: {
                success()
            })
            return nil
        })
        .continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
            DispatchQueue.main.async(execute: {
                if let error = task.error as? NSError {
                    failure(error)
                }
            })
            return nil
        })
    }
    
    /// Confirmation for Forgot Password Helper.
    /// - Parameters
    ///     - user: AWS Cognito Identity User of the input username.
    ///     - otp: Input OTP for changing the Password
    ///     - newPassword: Input New Password.
    ///     - success: Closure to execute if change password action is successful.
    ///     - failure: Closure to execute if change password action fails.
    func confirmForgotPassword(user: AWSCognitoIdentityUser, otp: String, newPassword: String, success: @escaping () -> Void, failure: @escaping (NSError) -> Void) {
        
        let reachability = Reachability()
        if reachability?.connection == Reachability.Connection.none {
            failure(DeviceConstants.NO_INTERNET_ERROR)
            return
        }
        
        user.confirmForgotPassword(otp, password: newPassword)
        .continueOnSuccessWith(block: { (task: AWSTask<AWSCognitoIdentityUserConfirmForgotPasswordResponse>) -> Any? in
            DispatchQueue.main.async(execute: {
                success()
            })
        })
        .continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
            DispatchQueue.main.async(execute: {
                if let error = task.error as? NSError {
                    failure(error)
                }
            })
            return nil
        })
    }
    
    /// Resend OTP for Forgot Password Helper.
    ///     - user: Cognito User whose changing the password.
    ///     - success: Closure to execute if resend OTP action is successful.
    ///     - failure: Closure to execute if resend OTP action fails.
    func resendOTPForForgotPassword(user: AWSCognitoIdentityUser, success: @escaping () -> Void, failure: @escaping (NSError) -> Void) {
        
        let reachability = Reachability()
        if reachability?.connection == Reachability.Connection.none {
            failure(DeviceConstants.NO_INTERNET_ERROR)
            return
        }
        
        user.forgotPassword()
        .continueOnSuccessWith(block: { (task: AWSTask<AWSCognitoIdentityUserForgotPasswordResponse>) -> Any? in
            DispatchQueue.main.async {
                success()
            }
        })
        .continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
            if let error = task.error as? NSError {
                failure(error)
            }
            return nil
        })
    }
}
