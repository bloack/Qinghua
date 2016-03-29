//
//  UrlHeaders.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-10.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#ifndef Qinghua_UrlHeaders_h
#define Qinghua_UrlHeaders_h
/**
 *  Base Url
 */
//#define URL_BASE @"http://120.131.65.210/president_club"
#define URL_BASE @"http://www.qinghuaceo.com/api.php"
/**
 *  咨询详情
 */
#define News_detail @"/api/news/news/getinfo"

#define mark--用户相关
/**
 *  登录接口
 */
#define LOGIN_URL @"/api/user/user/login"
/**
 *  更新用户信息
 */
#define UpdateProfile_URL @"/api/user/user/updateProfile"
/**
 *  更新用户主页背景
 */
#define UpdateMainImage @"/api/user/user/updatePassword"
/**
 *  更新用户头像
 */
#define UpdateAvatar_URL @"/api/user/user/UpdateAvatar"
/**
 *  更新用户密码
 */
#define UpdatePassword_URL @"/api/user/user/updatePassword"
/**
 *  获取用户详情
 */
#define UserDetail_URL @"/api/user/user/getinfo"

#define mark--用户企业相关
/**
 *  推荐企业列表
 */
#define Company_List_URL @"/api/user/company/getRecommendedList"
/**
 *  个人企业列表
 */
#define Company_me @"/api/user/company/GetList"
/**
 *  企业更新
 */
#define Company_update @"/api/user/company/update"
/**
 *  创建企业
 */
#define Company_Create @"/api/user/company/create/"
/**
 *  企业详情
 */
#define Company_detail @"/api/user/company/getinfo"
#define mark--用户搜索相关
/**
 *  搜索附近用户
 */
#define Nearby_URL @"/api/user/search/nearby"
/**
 *  位置搜索用户
 */
#define ByLocation_URL @"/api/user/search/ByLocation"
/**
 *  行业搜索用户
 */
#define Byindustry_URL @"/api/user/search/Byindustry"
/**
 *  职业搜索用户
 */
#define ByOccupation_URL @"/api/user/search/byOccupation"
/**
 *  关键字搜索用户
 */
#define ByKeywords_URL @"/api/user/search/ByKeywords"
/**
 *  推荐人脉列表
 */
#define ByRecommend_URL @"/api/user/search/recommended"
#define mark--商业相关
/**
 *  商业列表
 */
#define Business_List_URL @"/api/business/business/getList"
/**
 *  更新商业信息
 */
#define Business_Update_URL @"/api/business/business/update"
/**
 *  发布商业信息
 */
#define Business_Create_URL @"/api/business/business/create"
/**
 *  删除商业信息
 */
#define Business_Delete_URL @"/api/business/business/delete"
/**
 *  商业详情
 */
#define Business_info_URL @"/api/business/business/getInfo"
/**
 *  评论列表
 */
#define Comment_List @"/api/comment/comment/getList"
/**
 *  发布评论
 */
#define Comment_Create @"/api/comment/comment/create"
/**
 *  获取访客列表
 */
#define Visit_List_URL @"/api/user/visitor/getlist"
#define mark--公共数据接口
/**
 *  获取地区列表
 */
#define List_Area_URL @""
#define mark--招聘相关
/**
 *  获取招聘列表
 */
#define Recruitment_List_URL @"/api/recruitment/recruitment/getList"
/**
 *  招聘详情
 */
#define Recuitment_Detail @"/api/recruitment/recruitment/getInfo"
/**
 *  发布招聘
 */
#define Recruitment_Create_URL @"/api/recruitment/recruitment/create"
/**
 *  修改招聘
 */
#define Recruitment_Update_URL @"/api/recruitment/recruitment/update"
/**
 *  删除招聘
 */
#define Recruitment_Delete_URL @"/api/recruitment/recruitment/delete"
/**
 *  地区列表
 */
#define Area_URL @"/api/common/district/getList"
/**
 *  兴趣爱好列表
 */
#define Favorite_URL @"/api/common/interest/getList"
/**
 *  行业列表
 */
#define Industry_URL @"/api/common/industry/getList"
/**
 *  职业列表
 */
#define Profession_URL @"/api/common/occupation/getList"

#define mark --求助接口
/**
 *  求助列表
 */
#define Help_List_URL @"/api/help/help/getList"
/**
 *  发布求助
 */
#define Help_Create_URL @"/api/help/help/create"
/**
 *  修改求助
 */
#define Help_Update_URL @"/api/help/help/update"
/**
 *  删除求助
 */
#define Help_Delete_URL @"/api/help/help/delete"
/**
 *  求助详情
 */
#define Help_Detail @"/api/help/help/getInfo"

/**
 *  商业资讯
 */
#define Info_URL @"/api/news/news/getlist"
/**
 *  咨询详情
 */
#define InfoDetail_URL @"/api/news/news/getinfo"
/**
 *  赞
 */
#define Like_Url @"/api/like/like/create"
/**
 *  创建活动
 */

#define Group_active_Create @"/api/group/activity/create"

/**
 *  我的活动
 */
#define Activity_My @"/api/group/activity/getMyList"

#define mark-- 群组活动
/**
 *  活动详情
 */
#define Group_active_detail @"/api/group/activity/GetInfo"
/**
 *  精彩回放详情
 */
#define Group_BackLook_Detail @"/api/group/activity/gethighlight"
/**
 *  参加活动用户列表
 */
#define Group_Acticve_UserList @"/api/group/activity/GetUserList"
/**
 *  报名参加活动
 */
#define Group_Active_Join @"/api/group/activity/Apply"
/**
 *  更新精彩回放
 */
#define Activity_LookBack_Update @"/api/group/activity/updatehighlight"

/**
 *  更新活动
 */
#define Group_active_update @"/api/group/activity/update"
/**
 *  删除活动
 */
#define Group_active_delete @"/api/group/activity/delete"
#define mark --群组信息
/**
 *  获取群组信息列表
 */
#define GroupInfo_List @"/api/group/information/getlist"
/**
 *  发布群组信息
 */
#define GroupInfo_Create @"/api/group/information/create"
/**
 *  更新群组信息
 */
#define GroupInfo_Update @"/api/group/information/update"
/**
 *  删除群组信息
 */
#define GroupInfo_delete @"/api/group/information/delete"
/**
 *  群组列表
 */
#define Group_List @"/api/group/group/GetList"
/**
 *  群组资料
 */
#define Group_Info @"/api/group/group/getinfo"

/**
 *  群组成员
 */
#define Group_Member @"/api/group/user/GetList"
/**
 *  删除群成员
 */
#define Group_Member_Delete @"/api/group/user/delete"
/**
 *  邀请成员
 */
#define Group_Member_Invod @"/api/group/user/Invate"
/**
 *  群活动
 */
#define Group_Activity @"/api/group/activity/GetList"
/**
 *  申请加入群组
 */
#define Group_Apply @"/api/group/user/Apply"
/**
 *  群组信息详情
 */
#define Group_TAD_Detail @"/api/group/information/getInfo"
#define mark--产品相关
/**
 *  产品列表
 */
#define Product_List @"/api/product/product/getList"
/**
 *  创建产品
 */
#define Product_Create @"/api/product/product/create"
/**
 *  更新产品
 */
#define Product_Update @"/api/product/product/update"
/**
 *  产品详情
 */
#define Product_Detail @"/api/product/product/getInfo"
/**
 *  删除产品
 */
#define Product_Delete @"/api/product/product/delete"
/**
 *  获取验证码
 */
#define GetCode @"/api/user/forget/getcode"
/**
 *  重置密码
 */
#define GetNewKy @"user/forget/updatePassword"
/**
 *  IM图片语音
 */
#define IM_Upload @"/api/common/im/upload"

/**
 *  反馈
 */
#define Feed_Url @"/api/feedback/Feedback/Suggest"
/**
 *  广告栏
 */
#define AD_List @"/api/ad/ad/getList"
/**
 *  发送私信
 */
#define MessageTalk_Url @"/api/message/message/create"
#define mark --班级
/**
 *  班级列表
 */
#define Class_List @"/api/class/class/GetList"
/**
 *  班级人脉
 */
#define Class_Friend @"/api/user/friend/GetListByClass/"
/**
 *  群组好友列表
 */
#define Group_friends @"/api/user/friend/GetListByGroup"
/**
 *  好友列表
 */
#define Friends_Url @"/api/user/friend/GetList/"
/**
 *  版本检测
 */
#define Version_Check @"/api/system/version/check"
#define mark ---收藏
/**
 *  收藏
 */
#define favorites_Create @"/api/favorites/favorites/create"
/**
 *  删除收藏
 */
#define favorites_delete @"/api/favorites/favorites/delete"
/**
 *  收藏列表
 */
#define favorites_List @"/api/favorites/favorites/getList"
/**
 *  引荐
 */
#define Introduce_URL @"/api/user/Introduction/create"
/**
 *  系统通知
 */
#define SystemAlert_url @"/api/system/message/getList"
/**
 *  群组申请管理
 */
#define Group_Agree @"/api/group/user/verify"
/**
 *  积分
 */
#define Credit_URL @"/api/user/credit/getList"

#endif
