export default class StringSerice {
	static trim(str) {
		if (str === null || str === undefined || str == 'undefined') {
			return str;
		}
		if (String.prototype.trim) {
			return str.trim();
		} else {
			return str.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');
		}
	}
	static isEmpty(str) {
		var stringVal = String(str);
		if (stringVal === null || stringVal === undefined || stringVal == 'undefined') {
			return true;
		}
		if (this.trim(stringVal) == '') {
			return true;
		}
		return false;
	}
	static containsSubStr(str, substr) {
		if (!str || !substr) {
			return false;
		}
		substr = this.trim(substr);
		if (str && str.toUpperCase().includes(substr.toUpperCase() || null)) {
			return true;
		} else {
			return false;
		}
	}
	static strEqual(a, b, ignoreCase) {
		if (!a) {
			a = '';
		}
		if (!b) {
			b = '';
		}
		a = this.trim(a);
		b = this.trim(b);
		if (ignoreCase) {
			a = a.toUpperCase();
			b = b.toUpperCase();
		}
		return a === b;
	}

	static jsonToParams(json) {
		var result = '';
		for (let key in json) {
			if (json.hasOwnProperty(key)) { // 确保属性属于对象自身而非原型链上的
				result += encodeURIComponent(key) + '=' + encodeURIComponent(json[key]);
			}
		}
		return result;
	}

	static urlToJson(url) {
		// 创建一个空对象来存储键值对
		const result = {};

		// 获取URL中的查询参数部分
		const queryString = url.split('?')[1];

		// 如果没有查询参数，直接返回空对象
		if (!queryString) {
			return result;
		}

		// 将查询字符串分割成键值对数组
		const keyValuePairs = queryString.split('&');

		// 遍历键值对数组
		keyValuePairs.forEach(pair => {
			// 分割键和值
			const [key, value] = pair.split('=');

			// 解码键和值，并存储在结果对象中
			result[decodeURIComponent(key)] = decodeURIComponent(value);
		});
		console.log("链接参数转json=", result);
		// 返回结果对象
		return result;
	}
}