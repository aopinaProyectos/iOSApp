//
//  Message.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/22/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//


enum Message: String {

//   AceptOptions
    case ACCEPT
    case CANCEL

//   Buttons
    case ENTER
    case NEXT
    case RETRY
    case SEND
    case SAVE
    
//   Days
    case MONDAY
    case TUESDAY
    case WEDNESDAY
    case THURSDAY
    case FRIDAY
    case SATURDAY
    case SUNDAY
    
//   Error Alert
    case INTERNETSLOW
    case NOINTERNETCONNECTION
    
//   Greetings
    case MORNING
    case AFTERNOON
    case EVENING
    
//   Gallery
    case REQUESTIMAGE
    case PHOTOLIBRARY
    case TAKEPHOTO
    
//   Language
    case SPANISH
    case ENGLISH
    
//   MenuOptions
    case LOGOUT
    case NEEDHELP
    case TERMS
    case PRIVACITY
    case ABOUT

//   Placeholder
    case PHDEMAIL
    case PHDNAMESTORE
    case PHDWEBSITE
    case PHDPHONE
    case PHDSTOREDESCRIPTION
    case PHDSEARCHBAR
    case PHDNAME
    case PHDOLDPWD
    case PHDNEWPWD
    case PHDOTHER
    case PHDBIRTHDATE
    
//   PickerView
    case PCKCATEGORY
    case PCKCATEGORYFIRST
    
//   Tutorial
    case TUTORIAL1LABEL1
    case TUTORIAL1LABEL2
    case TUTORIAL2LABEL1
    case TUTORIAL2LABEL2
    case TUTORIAL3LABEL1
    case TUTORIAL3LABEL2
    
//    CodeView
    case INSTRUCTIONS
    case BUTTONRESEND
    case BUTTONCHANGE
    
//    LoginPasswordView
    case PASSGREETING
    
//    RecoveryPasswordView
    case BUTTONSENDRP
    case INSTRUCTIONSRP

//    PasswordRecoveryView
    case INSTRUCTIONSPR
    
//    RegisterDataHostView
    case TITLEPROFILE
    case TITLESCHEDULE
    
//    DataStoreView
    case DSHEADERPREFERENCE
    case DSHEADERNEARBY
    
//    ProfileView
    case TITLEPROFILEDATA
    case TITLEADDRESS
    case TITLECHANGEPASSWORD
    case NAMECELL
    case EMAILCELL
    case PHONECELL
    case GENDERCELL
    case BIRTHDATECELL
    case PASSWORDBEFORE
    case PASSWORDNOW
    case PERCENTPROFILE
    
//    Status
    case PENDING
    case INPLACE
    case ONWAY
    case LATE
    case ATTENDED
    
//    ShiftInformationUserView
    case INSTUCTIONSSIUVC
    
    var localized: String {
        return rawValue.localized
    }
}
