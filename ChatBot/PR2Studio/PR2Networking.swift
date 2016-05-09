//
//  PR2Networking.swift
//
//  Created by Pablo Roca Rozas on 22/01/2016.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation
import Alamofire

/// Networking log levels
enum PR2NetworkingLogLevel {
    /// PR2Networking log disabled
    case PR2NetworkingLogLevelOff
    /// PR2Networking log in debug mode
    case PR2NetworkingLogLevelDebug
    /// PR2Networking log with short info
    case PR2NetworkingLogLevelInfo
    /// PR2Networking log when errors
    case PR2NetworkingLogLevelError
}

/// HTTP error codes
struct PR2HTTPCode {
    // Success
    /// HTTP 200 OK
    static let c200OK = 200
    
    /// HTTP Error 304 Redirection
    static let c304NotModified = 304
    
    // Client error
    /// HTTP Error 400 Bad request
    static let c400BadRequest = 400
    /// HTTP Error 401 Unauthorised
    static let c401Unauthorised = 401
    /// HTTP Error 404 Not found
    static let c404NotFound = 404
    /// HTTP Error 405 Method not allowed
    static let c405MethodNotAllowed = 405
    
    // Server error
    /// HTTP Error 500 Internsal server error
    static let c500InternalServerError = 500
}

/// Slow Internet Notification
public struct PR2NetworkingNotifications {
    /// slow internet
    public static let slowInternet = "com.pr2studio.notifications.SlowInternet"
}

/// Main network request class (wrapper of Alamofire request)
public class PR2Networking {
    /// it converts itself as a singleton
    static let sharedInstance = PR2Networking()

    /// Networking log levels
    var logLevel: PR2NetworkingLogLevel = .PR2NetworkingLogLevelOff
    
    /// initial retry delay
    let retryDelay: Double = 1.0  // in seconds
    
    /// seconds to trigger slow internet notification
    let secondsToShowSlowConnection: Double = 3
    /// timer for slow internet
    var timerRequest = NSTimer()
    
    /// alamofire manager
    var manager: Alamofire.Manager?
    /// alamofire reachability
    var managerReachability: NetworkReachabilityManager?
    
    /// This private prevents others from using the default '()' initializer for this class.
    private init() {
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["User-Agent"] = self.userAgent()
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        self.manager = Alamofire.Manager(configuration: configuration)
        
    }

    // MARK: - request methods

    /// request: Recursive Request till delay > 30 seconds
    ///  - parameter delay:      Acumulated delay
    ///  - parameter method:     The HTTP method.
    ///  - parameter urlString:  The URL string.
    ///  - parameter parameters: The parameters. nil by default.
    ///  - parameter encoding:   The parameter encoding. .URL by default.
    ///  - parameter headers:    The HTTP headers. nil by default.
    ///  - parameter completionHandler:    Completion handler.
    public func request(
        delay: Double,
        method: Alamofire.Method,
        urlString: String,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        completionHandler: (success: Bool, Response<AnyObject, NSError>, statuscode: Int) -> Void) {
        willStartRequest(method, urlString, parameters: parameters, encoding: encoding, headers: headers)
        Alamofire.request(method, urlString, parameters: parameters, encoding: encoding, headers: headers)
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                var statusCode: Int = 0
                if let httpError = response.result.error {
                    statusCode = httpError.code
                } else { //no errors
                    statusCode = (response.response?.statusCode)!
                }
//                let cachedURLResponse = NSCachedURLResponse(response: response.response!, data: response.data!, userInfo: nil, storagePolicy: .Allowed)
//                NSURLCache.sharedURLCache().storeCachedResponse(cachedURLResponse, forRequest: response.request!)

                // success
                if (response.result.error == nil && statusCode == PR2HTTPCode.c200OK) {
                    strongSelf.didFinishRequest(true, response: response, statuscode: statusCode)
                    completionHandler(success: true, response, statuscode: statusCode)
                } else {
                    // don't repeat the network call if error not temporary
                    if (response.result.error != nil && strongSelf.shouldCancelRequestbyError(response.result.error!)) {
                        strongSelf.didFinishRequest(false, response: response, statuscode: statusCode)
                        completionHandler(success: false, response, statuscode: statusCode)
                    } else {
                        // posibble not having internet, we wait for reachability
                        if (response.result.error != nil &&
                            (response.result.error?.code == NSURLErrorNotConnectedToInternet ||
                            response.result.error?.code == NSURLErrorTimedOut ||
                             response.result.error?.code == NSURLErrorCannotFindHost ||
                             response.result.error?.code == NSURLErrorCannotConnectToHost)
                            ) {
                                let host = response.request!.URL!.host
                                strongSelf.managerReachability = NetworkReachabilityManager(host: host!)
                                
                                strongSelf.managerReachability!.listener = { status in
                                    // is again reachable? we make the request again
                                    if (strongSelf.managerReachability!.isReachable) {
                                        strongSelf.managerReachability!.stopListening()
                                        strongSelf.didFinishRequest(false, response: response, statuscode: statusCode)
                                        strongSelf.request(delay, method: method, urlString: urlString, completionHandler: { (success, response, statuscode) -> Void in
                                            completionHandler(success: success, response, statuscode: statuscode)
                                        })
                                    }
                                }
                                
                                strongSelf.managerReachability!.startListening()
                        } else {
                            strongSelf.didFinishRequest(false, response: response, statuscode: statusCode)
                            // failure then we retry request
                            let newretryDelay = delay + 1
                            if newretryDelay > 30 {
                                completionHandler(success: false, response, statuscode: statusCode)
                            } else {
                                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(newretryDelay * Double(NSEC_PER_SEC)))
                                dispatch_after(time, dispatch_get_main_queue()) {
                                    strongSelf.request(newretryDelay, method: method, urlString: urlString, completionHandler: { (success, response, statuscode) -> Void in
                                        completionHandler(success: success, response, statuscode: statuscode)
                                    })
                                }
                            }
                        }
                    }
                }
        }
    }


    // MARK: - start and finish request common functions
    
    /// willStartRequest: Executed before any request (activity indicator & console logger)
    /// - parameter method:     The HTTP method.
    /// - parameter uRLString:  The URL string.
    /// - parameter parameters: The parameters. nil by default.
    /// - parameter encoding:   The parameter encoding. .URL by default.
    /// - parameter headers:    The HTTP headers. nil by default.
    private func willStartRequest(
        method: Alamofire.Method,
        _ uRLString: String,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil
        ) {
        self.timerRequest = NSTimer.scheduledTimerWithTimeInterval(self.secondsToShowSlowConnection, target: self, selector: #selector(self.timerRequestReached), userInfo: nil, repeats: false)
        
        PR2Common().showNetworkActivityinStatusBar()
        
        /// network console logger
        let dateString  = NSDate().PR2DateFormatterForLog()

        switch self.logLevel {
        case .PR2NetworkingLogLevelOff, .PR2NetworkingLogLevelError:
            break
        case .PR2NetworkingLogLevelDebug:
            
            // headers
            var dictDefaultHeaders: Dictionary = self.manager!.session.configuration.HTTPAdditionalHeaders!
            // adds custom headers to default headers
            if let myHeaders = headers {
                for (key, value) in myHeaders {
                    dictDefaultHeaders.updateValue(value, forKey:key)
                }
            }
            // prepare dictDefaultHeaders for printing
            var stringDefaultHeaders = ""
            for (key, value) in dictDefaultHeaders {
                stringDefaultHeaders += "\(key): \(value)\n"
            }
            let index1 = stringDefaultHeaders.endIndex.advancedBy(-1)
            stringDefaultHeaders = stringDefaultHeaders.substringToIndex(index1)
            
            // parameters
            var stringParameters = ""
            if let myParameters = parameters {
                for (key, value) in myParameters {
                    stringParameters += "\(key): \(value)\n"
                }
                let index1 = stringParameters.endIndex.advancedBy(-1)
                stringParameters = stringParameters.substringToIndex(index1)
            }
            
            let logmessage = "\(dateString) \(method) \(uRLString)\n[Headers]\n\(stringDefaultHeaders)\n[Body]\(stringParameters)"
            print(logmessage)
        case .PR2NetworkingLogLevelInfo:
            let logmessage = "\(dateString) \(method) \(uRLString)"
            print(logmessage)
        }
    }

    /// didFinishRequest: Executed after any request (activity indicator & console logger)
    ///   - parameter success:    The request was succesfull?
    ///   - parameter response:   The response object
    ///   - parameter statuscode: statuscode of the request
    private func didFinishRequest(success: Bool, response: Response<AnyObject, NSError>, statuscode: Int) {
        self.timerRequest.invalidate()
        
        PR2Common().hideNetworkActivityinStatusBar()
        
        // network console logger
        var statusCode: Int = 0
        if let httpError = response.result.error {
            statusCode = httpError.code
        } else { //no errors
            statusCode = (response.response?.statusCode)!
        }

        let dateString  = NSDate().PR2DateFormatterForLog()

        switch self.logLevel {
        case .PR2NetworkingLogLevelOff:
            break
        case .PR2NetworkingLogLevelDebug:
            var dictResponseHeaders: NSDictionary? = nil
            if let httpResponse = response.response {
                dictResponseHeaders = httpResponse.allHeaderFields
                // prepare dictDefaultHeaders for printing
                var stringResponseHeaders = ""
                for (key, value) in dictResponseHeaders! {
                    stringResponseHeaders += "\(key): \(value)\n"
                }
                let index1 = stringResponseHeaders.endIndex.advancedBy(-1)
                stringResponseHeaders = stringResponseHeaders.substringToIndex(index1)
            }
            
            var logmessage: String = ""
            if response.result.error != nil {
                if let _ = response.result.value {
                    logmessage = "\(dateString) [Error] \(response.result.error!.code) \(response.request!.URLString)\n[Response Headers]\n\(dictResponseHeaders!)\n[Response Body]\n\(response.result.value!)"
                } else {
                    logmessage = "\(dateString) [Error] \(response.result.error!.code) \(response.request!.URLString)\n[Response Headers]\n[Response Body]\n"
                }
            } else {
                logmessage = "\(dateString) \(statusCode) \(response.request!.URLString)\n[Response Headers]\n\(dictResponseHeaders!)\n[Response Body]\n\(response.result.value!)"
            }
            
            print(logmessage)
        case .PR2NetworkingLogLevelInfo, .PR2NetworkingLogLevelError:
            var logmessage: String = ""
            if response.result.error != nil {
                logmessage = "\(dateString) [Error] \(response.result.error!.code) \(response.request!.URLString)"
            } else {
                logmessage = "\(dateString) \(statusCode) \(response.request!.URLString)"
            }
            
            print(logmessage)
        }
    }
    
    // MARK: - Timer (slow internet) method

    /**
    Slow internet reached
    */
    dynamic func timerRequestReached() {
        NSNotificationCenter.defaultCenter().postNotificationName(PR2NetworkingNotifications.slowInternet, object: nil)
    }
    
    // MARK: - misc functions
   
   /// userAgent: Generates user agent from Info.plist
   /// example: SkyPablo:1.0.1/IOS:9.2/x86_64
   /// - returns: String
    public func userAgent() -> String {
        var userAgent: String = "Unknown"
        if let info = NSBundle.mainBundle().infoDictionary {
            let executable: AnyObject = info[kCFBundleExecutableKey as String] ?? "Unknown"
            let version: AnyObject = info[kCFBundleVersionKey as String] ?? "Unknown"
            let osmajor: AnyObject = NSProcessInfo.processInfo().operatingSystemVersion.majorVersion ?? 0
            let osminor: AnyObject = NSProcessInfo.processInfo().operatingSystemVersion.minorVersion ?? 0
            let model: AnyObject = hardwareString() ?? "Unknown"
            
            userAgent = NSMutableString(string: "\(executable):\(version)/IOS:\(osmajor).\(osminor)/\(model)") as String
            
            }
        return userAgent
        }
    
    /// hardwareString: Generates phone model (hardware)
    /// - returns: String
    private func hardwareString() -> String {
        var name: [Int32] = [CTL_HW, HW_MACHINE]
        var size: Int = 2
        sysctl(&name, 2, nil, &size, &name, 0)
        var hw_machine = [CChar](count: Int(size), repeatedValue: 0)
        sysctl(&name, 2, &hw_machine, &size, &name, 0)
        
        let hardware: String = String.fromCString(hw_machine)!
        return hardware
    }

    /// shouldCancelRequestbyError: if the request error non temporary then we fail and cancel any further request
    /// - parameter error: Error received by the request
    /// - returns: Bool
    private func shouldCancelRequestbyError(error: NSError) -> Bool {
        if ((error.domain == "NSURLErrorDomain" && (
        error.code == NSURLErrorCancelled ||
        error.code == NSURLErrorBadURL ||
        error.code == NSURLErrorUnsupportedURL ||
        error.code == NSURLErrorDataLengthExceedsMaximum ||
        error.code == NSURLErrorHTTPTooManyRedirects ||
        error.code == NSURLErrorUserCancelledAuthentication ||
        error.code == NSURLErrorRequestBodyStreamExhausted ||
        error.code == NSURLErrorAppTransportSecurityRequiresSecureConnection ||
        error.code == NSURLErrorFileDoesNotExist ||
        error.code == NSURLErrorFileIsDirectory ||
        error.code == NSURLErrorNoPermissionsToReadFile ||
        error.code == NSURLErrorSecureConnectionFailed ||
        error.code == NSURLErrorServerCertificateHasBadDate ||
        error.code == NSURLErrorServerCertificateUntrusted ||
        error.code == NSURLErrorServerCertificateHasUnknownRoot ||
        error.code == NSURLErrorServerCertificateNotYetValid ||
        error.code == NSURLErrorClientCertificateRejected ||
        error.code == NSURLErrorClientCertificateRequired ||
        error.code == NSURLErrorCannotCreateFile ||
        error.code == NSURLErrorCannotOpenFile ||
        error.code == NSURLErrorCannotCloseFile ||
        error.code == NSURLErrorCannotWriteToFile ||
        error.code == NSURLErrorCannotRemoveFile ||
        error.code == NSURLErrorCannotMoveFile))
        ||
        (error.domain == "NSCocoaErrorDomain" && (
        error.code == 3840))
        ) {
              return true
        } else {
            return false
        }
    }
}
