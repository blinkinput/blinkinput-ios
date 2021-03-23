//
//  MBException.h
//  Pdf417MobiDev
//
//  Created by Jura Skrlec on 07/02/2018.
//

#ifndef MBException_h
#define MBException_h

typedef NSString * MBINExceptionName NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXPORT MBINExceptionName const MBINIllegalModificationException;
FOUNDATION_EXPORT MBINExceptionName const MBINInvalidLicenseKeyException;
FOUNDATION_EXPORT MBINExceptionName const MBINInvalidLicenseeKeyException;
FOUNDATION_EXPORT MBINExceptionName const MBINInvalidLicenseResourceException;
FOUNDATION_EXPORT MBINExceptionName const MBINInvalidBundleException;
FOUNDATION_EXPORT MBINExceptionName const MBINMissingSettingsException;
FOUNDATION_EXPORT MBINExceptionName const MBINInvalidArgumentException;

#endif /* MBException_h */
