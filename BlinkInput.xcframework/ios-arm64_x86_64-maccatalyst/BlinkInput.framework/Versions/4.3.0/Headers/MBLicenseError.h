//
//  MBLicenseError.h
//  MicroblinkDev
//
//  Created by Mijo Gracanin on 23/09/2020.
//

#ifndef MBLicenseError_h
#define MBLicenseError_h

#import <Foundation/Foundation.h>

extern NSString * const MBINLicenseErrorNotification;

typedef NS_ENUM(NSInteger, MBINLicenseError) {
    MBINLicenseErrorNetworkRequired,
    MBINLicenseErrorUnableToDoRemoteLicenceCheck,
    MBINLicenseErrorLicenseIsLocked,
    MBINLicenseErrorLicenseCheckFailed,
    MBINLicenseErrorInvalidLicense
};

typedef void(^MBINLicenseErrorBlock)(MBINLicenseError licenseError);

#endif /* MBLicenseError_h */
