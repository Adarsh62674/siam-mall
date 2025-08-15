import storage from './storage';
import http from './http';
const ROOT_KEY = 'security.siam.';
const TOKEN_KEY = ROOT_KEY + 'token';
const OPENID_KEY = ROOT_KEY + 'openid';
const PHONE_KEY = ROOT_KEY + 'phone';
export default class AuthService {
	static getToken() {
		return storage.getStorage(TOKEN_KEY);
	}
	static setToken(token) {
		return storage.setStorage(TOKEN_KEY, token);
	}
	static deleteToken() {
		return storage.removeStorage(TOKEN_KEY);
	}
	static setOpenId(openId) {
		return storage.setStorage(OPENID_KEY, openId);
	}
	static getOpenId() {
		return storage.getStorage(OPENID_KEY);
	}
	static deleteOpenId() {
		return storage.removeStorage(OPENID_KEY);
	}
	static setPhoneNumber(phone) {
		return storage.setStorage(PHONE_KEY, phone);
	}
	static getPhoneNumber() {
		return storage.getStorage(PHONE_KEY);
	}
	static deletePhoneNumber() {
		return storage.removeStorage(PHONE_KEY);
	}
	static setWxStorage(storageText, storageValue) {
		//console.log("setWxStorage=", ROOT_KEY + storageText);
		return storage.setStorage(ROOT_KEY + storageText, storageValue);
	}
	static getWxStorage(storageText) {
		//console.log("getWxStorage=", ROOT_KEY + storageText);
		return storage.getStorage(ROOT_KEY + storageText);
	}
	static deleteWxStorage(storageText) {
		//console.log("deleteWxStorage=", ROOT_KEY + storageText);
		return storage.removeStorage(ROOT_KEY + storageText);
	}
	static deleteOpenId(storageText) {
		return storage.removeStorage(ROOT_KEY + storageText);
	}
	static checkIsLogin() {
		return new Promise((fulfil, reject) => {
			this.getToken().then(
				(token) => {
					if (token) {
						fulfil(true);
					} else {
						fulfil(false);
					}
				},
				(err) => {
					fulfil(false);
				}
			);
		});
	}
}