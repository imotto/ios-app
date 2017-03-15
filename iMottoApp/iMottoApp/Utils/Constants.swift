//
//  Constants.swift
//  iMottoApp
//
//  Created by sunht on 16/5/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation
import UIKit

let APP_ID = ""

// 开发环境
//let API_SCHEME = "http://"
//let API_DOMAIN = "app.imotto.net"

//let API_DOMAIN = "192.168.1.104"
let BUNDLE_IDENTIFIER = "net.imotto.iMottoApp"
let URL_HELP_CENTER = "https://www.imotto.net/about.html"
let URL_EULA = "https://www.imotto.net/agreement.html"
let CALENDAR_START="2017-01-01"


let KEYCHAIN_UUID_KEY = "uuid"
let KEYCHAIN_SIGNATURE_KEY = "signature"
let KEYCHAIN_USERTOKEN_KEY = "usertoken"
let KEYCHAIN_USERID_KEY = "user"
let KEYCHAIN_MOBILE_KEY = "mobile"
let KEYCHAIN_PASSWORD_KEY = "password"

let UserDefaultsKeyAppInit = "AppInitialized"
let UserDefaultsKeyDeviceToken = "DeviceToken"
let UserDefaultsKeyUser = "CurrentUser"
let UserDefaultsKeyUserThumb = "CurrentUserThumb"

// 2016/12/31 23:00:00
let interval = 1483196400
let DATE_VERY_BEGINING = Date(timeIntervalSince1970: TimeInterval(interval))

let DEFAULT_PAGE_SIZE = 10

let MSG_SERVER_ERROR="服务器偶尔停顿是CPU需要降温，就像人要不时驻足等等灵魂"

//WHITE_STYLE
//let COLOR_NAV_BG = UIColor.whiteColor()
//let COLOR_NAV_TINT = UIColor(red: 28.0/255.0, green: 168.0/255.0, blue: 221.0/255.0, alpha: 1)

// BLUE STYLE
let NAV_BG_IMG = "navbar_bg"
let COLOR_NAV_BG = UIColor(red: 28.0/255.0, green: 168.0/255.0, blue: 221.0/255.0, alpha: 1)
let COLOR_NAV_TINT = UIColor.white
let COLOR_TAB_BG = COLOR_NAV_TINT
let COLOR_TAB_TINT = COLOR_NAV_BG

let COLOR_BTN_TINT = UIColor.lightGray
let COLOR_BTN_TINT_ACTIVED = COLOR_NAV_BG

let COLOR_SCORE_GREEN = UIColor(red: 0, green: 128.0/255.0, blue: 0, alpha: 1)
let COLOR_SCORE_RED = UIColor.red

let TABLEVIEW_NO_DATA_HINT = "没有可以显示的数据"


let ACQUIRE_VCODE_FOR_REGISTER = 1
let ACQUIRE_VCODE_FOR_FINDPASS = 2

//table reuse identifiers
let keyAlbumDisplayCell = "AlbumDisplayCell"
let keyMottoRankingCell = "MottoRankingCell"
let keyMottoDisplayCell = "MottoDisplayCell"
let keyMyMottoDisplayCell = "MyMottoDisplayCell"
let keyProfileDisplayCell = "ProfileDisplayCell"
let keyScoreDisplayCell = "ScoreDisplayCell"
let keyBillDisplayCell = "RevenueDisplayCell"
let keyRelateduserDisplayCell = "keyRelateduserDisplayCell"
let keyRecentTalkCell = "RecentTalkCell"
let keyNoticeCell = "NoticeCell"
let keyTalkMsgCell = "TalkMsgCell"
let keyGiftDisplayCell = "GiftDisplayCell"
let keySelExchangeInfoCell = "SelExchangeInfoCell"

let NotificationNameUpdateCollection = NSNotification.Name(rawValue: "UpdateCollection")

let CellBtnImgSize:CGFloat = 26

let ImgHeart = FAKMaterialDesignIcons.heartIcon(withSize: 24).image(with: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate)
let ImgHeartOutLine = FAKMaterialDesignIcons.heartOutlineIcon(withSize: 24).image(with: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate)
let ImgHeartPulse = FAKMaterialDesignIcons.heartPulseIcon(withSize: 24).image(with: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate)
let ImgHeartBroken = FAKMaterialDesignIcons.heartBrokenIcon(withSize: 24).image(with: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate)

let ImgThumbPlaceholder = FAKIonIcons.iosPersonIcon(withSize: 64).image(with: CGSize(width: 64, height: 64)).withRenderingMode(.alwaysTemplate)
let ImgGiftPlaceholder = FAKMaterialIcons.cardGiftcardIcon(withSize: 64).image(with: CGSize(width: 64, height: 64)).withRenderingMode(.alwaysTemplate)

let ImgGoBack = FAKIonIcons.iosArrowBackIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
let ImgEmail = FAKMaterialDesignIcons.emailIcon(withSize: 36).image(with: CGSize(width: 36, height: 36)).withRenderingMode(.alwaysTemplate)
let ImgEmailOpen = FAKMaterialDesignIcons.emailOpenIcon(withSize: 36).image(with: CGSize(width: 36, height: 36)).withRenderingMode(.alwaysTemplate)

let ImgIosHeart = FAKIonIcons.iosHeartIcon(withSize: CellBtnImgSize).image(with: CGSize(width: CellBtnImgSize, height: CellBtnImgSize)).withRenderingMode(.alwaysTemplate)
let ImgIosHeartOutLine = FAKIonIcons.iosHeartOutlineIcon(withSize: CellBtnImgSize).image(with: CGSize(width: CellBtnImgSize, height: CellBtnImgSize)).withRenderingMode(.alwaysTemplate)
let ImgIosBookmark = FAKIonIcons.iosBookmarksIcon(withSize: CellBtnImgSize).image(with: CGSize(width: CellBtnImgSize, height: CellBtnImgSize)).withRenderingMode(.alwaysTemplate)
let ImgIosBookmarkOutLine = FAKIonIcons.iosBookmarksOutlineIcon(withSize: CellBtnImgSize).image(with: CGSize(width: CellBtnImgSize, height: CellBtnImgSize)).withRenderingMode(.alwaysTemplate)
let ImgIosChatboxesOutLine = FAKIonIcons.iosChatbubbleOutlineIcon(withSize: CellBtnImgSize).image(with: CGSize(width: CellBtnImgSize, height: CellBtnImgSize)).withRenderingMode(.alwaysTemplate)
let ImgIosChatboxes = FAKIonIcons.iosChatbubbleIcon(withSize: CellBtnImgSize).image(with: CGSize(width: CellBtnImgSize, height: CellBtnImgSize)).withRenderingMode(.alwaysTemplate)
let ImgIosMoreOutLine = FAKIonIcons.iosMoreOutlineIcon(withSize: CellBtnImgSize).image(with: CGSize(width: CellBtnImgSize, height: CellBtnImgSize)).withRenderingMode(.alwaysTemplate)
let ImgIosPlusEmpty = FAKIonIcons.iosPlusEmptyIcon(withSize: 32).image(with: CGSize(width: 32, height: 32))
let ImgIosMinusEmpty = FAKIonIcons.iosMinusEmptyIcon(withSize: 32).image(with: CGSize(width: 32, height: 32))
let ImgThumbUpOutLine = FAKMaterialDesignIcons.thumbUpOutlineIcon(withSize: 22).image(with: CGSize(width: 22, height: 22))
let ImgThumbUp = FAKMaterialDesignIcons.thumbUpIcon(withSize: 22).image(with: CGSize(width: 22, height: 22))




