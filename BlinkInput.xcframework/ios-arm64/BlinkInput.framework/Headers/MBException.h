//
//  MBException.h
//  Pdf417MobiDev
//
//  Created by Jura Skrlec on 07/02/2018.
//

#ifndef MBException_h
#define MBException_h

typedef NSString * MBIExceptionName NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXPORT MBIExceptionName const MBIIllegalModificationException;
FOUNDATION_EXPORT MBIExceptionName const MBIInvalidLicenseKeyException;
FOUNDATION_EXPORT MBIExceptionName const MBIInvalidLicenseeKeyException;
FOUNDATION_EXPORT MBIExceptionName const MBIInvalidLicenseResourceException;
FOUNDATION_EXPORT MBIExceptionName const MBIInvalidBundleException;
FOUNDATION_EXPORT MBIExceptionName const MBIMissingSettingsException;
FOUNDATION_EXPORT MBIExceptionName const MBIInvalidArgumentException;

#endif /* MBException_h */
