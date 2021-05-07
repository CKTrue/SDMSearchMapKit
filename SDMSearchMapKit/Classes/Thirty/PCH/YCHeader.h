//
//  Header.h
//  Chinaware
//

#ifndef Chinaware_Header_h
#define Chinaware_Header_h

//判断真机模拟器
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

// 获取沙盒主目录路径
#define DEF_Sandbox_HomeDir     NSHomeDirectory()
// 获取Documents目录路径
#define DEF_DocumentsDir        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
// 获取Caches目录路径
#define DEF_CachesDir           [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
// 获取当前程序包中一个图片资源（apple.png）路径
#define DEF_IMAGE_PATH(_name)   [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:_name]
//获取本地图片
#define DEF_IMAGE(_name)  [UIImage imageWithContentsOfFile:DEF_IMAGE_PATH(_name)]

#define NSEaseLocalizedString(key, comment) [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"EaseUIResource" withExtension:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]


//googleKey
#define GoogleKey @"AIzaSyAn8ePiEwRtXj1LmIQVNC5m8AZ8b3-4iuY"

#define kClientID  @"station_client"
#define kClientSecret @"PW-CbIvtbqo4ecpqtDtQuv6pEs13ogkqJBJncOfW4_FWzK5ToC_JDER2g06xgtZ2TjbjdroT8MyCdKe3VltOUg"
#define kRedirectURI  @"SDMToyotaPOISearch://callback/"


#define kAppAuthExampleAuthStateKey  @"authState"
#define FavoriteData  @"FavoiteData"
#define HistoryData  @"HistoryData"




//测试环境
//#define baseURL1(Str) @"http://192.168.1.100/musashi-search-service/" Str
//#define baseURL2 @"http://192.168.1.100/musashi-search-service/"

//POC环境
//#define baseURL1(Str) @"https://poi.stationdm.com/musashi-search-service/" Str
//#define baseURL2 @"https://poi.stationdm.com/musashi-search-service/"

//POC-V2环境
#define baseURL1(Str) @"https://poi.stationdm.com/v2/musashi-search-service/" Str
#define baseURL2 @"https://poi.stationdm.com/v2/musashi-search-service/"

//DEV
//#define baseURL1(Str) @"http://192.168.1.115:8080/musashi-search-service/" Str
//#define baseURL2 @"http://192.168.1.115:8080/musashi-search-service/"


//alertView
#define alertShow(title,msg,_tag)  UIAlertView *alert =[[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];\
[alert show];\
alert.tag =_tag
#define alertShowNOcancelBtn(title,msg)  UIAlertView *alert =[[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];\
[alert show];
//#define alertShowNOcancelBtn(title,msg) UIAlertController*alertControl=[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];\
//UIAlertAction*OKaction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];\
//[alertControl addAction:OKaction];\
//UIWindow *appDelegate =[UIApplication sharedApplication].keyWindow;\
//[[appDelegate currentViewController] presentViewController:alertControl animated:YES completion:nil];\


//断网,连接失败提示

#define NONetAlertMsg @"页面不见啦！刷新试试~~"
#define NONetAlertShow  [self.view makeToast:NONetAlertMsg duration:1 position:@"CSToastPositionCenter"];
#define NONet(_msg)  [self.view makeToast:_msg duration:3 position:@"CSToastPositionCenter"]
#define WindowShow(_msg)  [self AlertViewShowMsg:_msg];

#define WindowShow1(_msg) [[UIApplication sharedApplication].keyWindow makeToast:_msg duration:3 position:@"center"];
#define WeakNONet(_msg) [weakSelf.view makeToast:_msg duration:1 position:@"CSToastPositionCenter"]
//#define WindowShow(_msg)  [[AVSpeechVoiceManager sharedAVSpeechVoiceManager] getSpeechUtteranceString:_msg]

/**
 *  判断屏幕尺寸是否为640*1136
 *
 *	@return	判断结果（YES:是 NO:不是）
 */
#define DEF_SCREEN_IS_640_1136 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define DEF_SCREEN_IS_1242_2208 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#ifdef DEBUG
// DEBUG模式下进行调试打印

// 输出结果标记出所在类方法与行数
#define DSLog(fmt, ...)   NSLog((@"%s[Line: %d]↖️ " fmt), strrchr(__FUNCTION__,'['), __LINE__, ##__VA_ARGS__)

#else

#define DSLog(...)   {}

#endif

//字体设置
#define DEFAULT_FONTSIZE    15
#define DEFAULT_FONT(s)     [UIFont fontWithName:@"ArialMT" size:s]
/**
 *	永久存储对象
 *
 *  NSUserDefaults保存的文件在tmp文件夹里
 *
 *	@param	object      需存储的对象
 *	@param	key         对应的key
 */
#define DEF_PERSISTENT_SET_OBJECT(object, key)                                                                                                 \
({                                                                                                                                             \
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];                                                                          \
[defaults setObject:object forKey:key];                                                                                                    \
[defaults synchronize];                                                                                                                    \
})
//钥匙串数据
#define  KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
#define  KEY_USERNAME @"com.company.app.username"
#define  KEY_PASSWORD @"com.company.app.password"
#define KEY_CID @"mobile_cid"
/**
*	取出永久存储的对象
*
*	@param	key     所需对象对应的key
*	@return	key     所对应的对象
*/
#define DEF_PERSISTENT_GET_OBJECT(key)  [[NSUserDefaults standardUserDefaults] objectForKey:key]


// 根据key取出值,如不存在,就回传 0
#define YYCValeForKey(Str) [NSString stringWithFormat:@"%@", DEF_PERSISTENT_GET_OBJECT(Str)==nil ? @"0" : DEF_PERSISTENT_GET_OBJECT(Str)]


/**
 *  清除 NSUserDefaults 保存的所有数据
 */
#define DEF_PERSISTENT_REMOVE_ALLDATA   [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]]


/**
 *  清除 NSUserDefaults 保存的指定数据
 */
#define DEF_PERSISTENT_REMOVE(_key)                                         \
({                                                                          \
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];       \
[defaults removeObjectForKey:_key];                                     \
[defaults synchronize];                                                 \
})
//缓存表
#define DBCachesTabel @"user_Cachestable"
//缓存名字
#define NetworkCache @"NetworkCache"
#define NSEaseLocalizedString(key, comment) [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"EaseUIResource" withExtension:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]

//微信


#endif
