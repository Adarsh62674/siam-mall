export default class WXStorage {
    static getStorage(key) {
        return new Promise((fulfill, reject) => {
			//console.log("Promise=",key)
            uni.getStorage({
                key: key,
                success: (res) => {
					//console.log("success=",res)
                    fulfill(res.data);
                },
                fail: (res) => {
					console.log("fail=",res)
                    fulfill();
                }
            });
        });
    }
    static setStorage(key, data) {
        return new Promise((fulfill, reject) => {
            uni.setStorage({
                key: key,
                data: data,
                success: (res) => {
                    fulfill();
                },
                fail: (res) => {
                    fulfill();
                }
            });
        });
    }
    static removeStorage(key) {
        return new Promise((fulfill, reject) => {
            uni.removeStorage({
                key: key,
                success: (res) => {
                    fulfill(res.data);
                },
                fail: (res) => {
                    fulfill();
                }
            });
        });
    }
}
