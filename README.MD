
## Main specs:

* Developed in SWIFT 2.3
* iOS 9.0 compatible
* CocoaPods
* using VIPER architecture
* Network requests in the background
* Network requests recursively repeated if temporary error (increasing delay till 30 second)
* Network requests applied Apple recommendations (see "Network requests failures" below)
* Network Log network requests/responses to console with different logs levels
* Network using HTTPS (see below)
* Network requests cached (for 10 minutes)
* Image downloading in the background
* Unit tests
* plist with NSAppTransportSecurity
* plist with UIRequiresPersistentWiFi (like Apple's mail app)
* Unit tests for Network requests (stubbed with OHHTTPStubs and not stubbed)
* Pull to refresh
* AutoLayout
* waiting indicators in status bar / webview
* showing slow internet connectivity
* HeaderDoc HTML based documentation. Generated using jazzy. in docs/swift_output/index.html
* using SwiftLint to enforce Swift style and conventions
* using SwiftGen to generate string enums
* Maximized Xcode Warnings (XcodeWarnings.xcconfig) (http://qualitycoding.org/xcode-warnings)
* Using as few external libraries as possible:

* Alamofire
* AlamofireImage
* SwiftyJSON
* SCLAlertView
* OHHTTPStubs

## PR2Studio classes

I applied some of my own classes I use to develop in Swift.

## Storyboards

I much prefer to use NIBs than storyboards, storyboards are really a problem in team 
development (because git conflicts) and with NIBs you have more flexibility to enable different behaviors. But cause the sample provide has Storyboards, I will use them.

I am splitting this in two storyboards (Login and Chat), so this would help in avoiding git merge conflicts and each one will be a VIPER module

## SOLID principles

Trying to apply SOLID principles and Clean Code, specially the Single Responsability. Classes must be lightewigth and perform only one task inside his abstraction layer. So it's better to have more classes that one big bloated class


## VIPER

This is the first project I do with VIPER, so maybe some things does not follow at full VIPER architecture. Anyhow I understand VIPER as a guideline or concepts to understand, but not to follow at full.

Reference material:

(Base doc) Architecting iOS Apps with VIPER
https://www.objc.io/issues/13-architecture/viper

(I follow this variant) Brigade’s Experience Using an MVC Alternative
https://medium.com/brigade-engineering/brigades-experience-using-an-mvc-alternative-36ef1601a41f#.ik6unq2bl

## CACHE

I cache network requests, just for showing how can this be done. In a chat is not realistic at all to cache by 10 minutes.

For a chat, network layer should be done in realtime (NodeJS, SignalR, downloadTaskWithRequest of NSURLSession with background session) and also having PushNotifications as failover

## Network logger

Logs into the console the network requests and responses. It's instantiated in AppDelegate.swift, here:

    PR2Networking.sharedInstance.logLevel = PR2NetworkingLogLevel.PR2NetworkingLogLevelInfo

logLevel can be:

* PR2NetworkingLogLevelOff - log disabled
* PR2NetworkingLogLevelDebug - logs full requests and responses
* PR2NetworkingLogLevelInfo - log with short info
* PR2NetworkingLogLevelError - logs only when errors

## SwiftLint
https://github.com/realm/SwiftLint

A tool for enforcing good code style.

Install: brew install swiftlint

If you don't want to use or install it, just remove Run Script Phase we have in the ChatBot target

## SwiftGen
https://github.com/AliSoftware/SwiftGen

It is used for generating strings enums, so we can avoid the risk of using an non-existing string

Its generated doing this in the console and in the project root folder

    swiftgen strings ./ChatBot/Resources/Strings/Localizable.strings --output ./ChatBot/Application/Strings.swift

## jazzy (Doc generation)
https://github.com/realm/jazzy

    jazzy \
      --clean \
      --author PabloRoca \
      --author_url https://pr2studio.com \
      --module-version 1.00 \
      --xcodebuild-arguments -scheme,ChatBotDoc \
      --module ChatBot \
      --output docs/swift_output \
      --min-acl internal 
  


## Issues with data

JSON response has no date for every message, so I will put the date when we retrieve the data

## Database

I have created this CoreData entities (sqlite tables):

* CDEUser
* CDEMessage

They have relationships between then also defined delete rules for them.

## Network using HTTPS

Main reasons for using HTTPS is for now, a bit (just a bit more security in network comms) and better speed. See article by Scott Helme why to use HTTPS (https://scotthelme.co.uk/still-think-you-dont-need-https/)

The server is not properly configured for HTTPS (Qualys SSL Test grade B, key exchange using weak Diffie-Hellman (DH), no CSP, no Strict Transport Security (HSTS), Public Key Pins not configured and other security flaws).

If HPKP were configured, I would use SSL Public Key Pinning inestead certificate pinning. I would be using TrustKit (https://github.com/datatheorem/TrustKit) for it. With TrustKit it's easy to enable and avoid a man in the middle attack.

## Network requests failures

This is not a trivial issue, some debate ongoing and as per this docs

Networking Overview
https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/WhyNetworkingIsHard/WhyNetworkingIsHard.html#//apple_ref/doc/uid/TP40010220-CH13-SW8

WWDC 2012 Session 706, "Networking Best Practices"
https://developer.apple.com/videos/play/wwdc2012-706/

Almofire documentation
https://github.com/Alamofire/Alamofire

So we conclude with this (and it is applied in the exercise):

* Don't use Rechability to determine if a network request should be sent. You should always send the request.
* Analize Reachability if failures. When Reachability is restored, use the event to retry failed network requests. (Even though the network requests may still fail, this is a good moment to retry them.)
* Don't timeout, let the system to do it. There is no good timeout value

## TODO (out of time)

* diverse orientations

* complete HeaderDoc documentation.

* create secondary target for slow connectivity tests using OHHTTPStubs

## To enhance

* more use of protocols
* simplify CDE objects
* Better CoreData stack
* Entities as PONSOs? Now they are NSManaged objects
* move more view logic to presenter? Investigate more View <> Presenter boundaries
* Better Autolayout
*



