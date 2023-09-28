//
//  AuthConfiguration.swift
//  Image Feed
//
//  Created by Alexandr Seva on 20.09.2023.
//

import Foundation

enum Constants {
    static let accessKey = "wagLspRbFqO9RevhMLgjQ_SQ86FDCYV6yet9UPwQLzw"
    static let secretKey = "245FqipR1u_VV3RSkIWg5VZM3VdmBbeog-rjzZrXKoI"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = "https://api.unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let grantType = "authorization_code"
    static let pathToken = "https://unsplash.com/oauth/token"
}

struct AuthConfiguration{
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let authURLString: String
    let grantType: String
    let pathToken: String
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String,
        defaultBaseURL: String,
        grantType: String,
        pathToken: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        self.grantType = grantType
        self.pathToken = pathToken
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 grantType: Constants.grantType,
                                 pathToken: Constants.pathToken)
    }
}
