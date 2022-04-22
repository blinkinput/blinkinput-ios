//
//  MBLicenseError.h
//  MicroblinkDev
//
//  Created by Mijo Gracanin on 23/09/2020.
//

#ifndef MBLicenseError_h
#define MBLicenseError_h

#import <Foundation/Foundation.h>

extern NSString * const MBILicenseErrorNotification;

typedef NS_ENUM(NSInteger, MBILicenseError) {
    MBILicenseErrorNetworkRequired,
    MBILicenseErrorUnableToDoRemoteLicenceCheck,
    MBILicenseErrorLicenseIsLocked,
    MBILicenseErrorLicenseCheckFailed,
    MBILicenseErrorInvalidLicense,
    MBILicenseErrorPermissionExpired,
    MBILicenseErrorPayloadCorrupted,
    MBILicenseErrorPayloadSignatureVerificationFailed,
    MBILicenseErrorIncorrectTokenState
};

typedef void(^MBILicenseErrorBlock)(MBILicenseError licenseError);

#endif /* MBLicenseError_h */
