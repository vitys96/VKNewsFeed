//
//  AuthService.swift
//  VKFeedNews
//
//  Created by Виталий Охрименко on 22/05/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit
import VKSdkFramework

protocol AuthServiceDelegate: class {
    func authServiceShouldShow(_ viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInFailed()
}

final class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    private let appID = "6993438"
    private let vkSDK: VKSdk
    
    weak var delegate: AuthServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    override init() {
        vkSDK = VKSdk.initialize(withAppId: appID)
        super.init()
        print ("initialized")
        vkSDK.register(self)
        vkSDK.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["wall, friends"]
        
        VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
            if state == VKAuthorizationState.authorized {
                delegate?.authServiceSignIn()
            } else if state == VKAuthorizationState.initialized {
                VKSdk.authorize(scope)
            } else {
                delegate?.authServiceSignInFailed()
            }
        }
    }
    
    //MARK: VKSdkDelegate
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            self.delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print (#function)
    }
    
    //MARK: VKSdkUIDelegate
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.delegate?.authServiceShouldShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print (#function)
    }
}
