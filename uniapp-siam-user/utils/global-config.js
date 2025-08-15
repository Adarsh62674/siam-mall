export default class GlabalConfig {
    // static baseUrl = 'https://api.dailyfruitbliss.cn/siam-mall';
	// #ifdef H5
	static baseUrl = 'siam-mall';
	// #endif
	// #ifdef APP-PLUS||MP-WEIXIN||MP-ALIPAY
	static baseUrl = 'http://localhost:9630/siam-mall';
	//static baseUrl = 'http://localhost:9200/siam-mall';
	// #endif
    
    // static baseUrl = 'http://localhost:9020';
    static ossUrl = 'https://siam.oss-cn-hangzhou.aliyuncs.com/';
	static gaodeMapKey = '484eda1376edf1af886e6622b993aaa3';
}
