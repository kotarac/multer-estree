# multer-estree

Simple streaming multer storage engine for S3.


## Install

```sh
npm i -S multer-estree
```


## Usage

```js
var express = require('express');
var app = express();
var multer = require('multer');
var estree = require('multer-estree');

var upload = multer({
	storage: estree({
		bucket: 'bukkit',
		accessKeyId: 'key',
		secretAccessKey: 'secret',
		region: 'eu-west-1',
		key: function (req, file, cb) {
			cb(null, Math.random().toString(36).slice(2, 8))
		}
  	})
})

app.post('/upload', upload.single('file'), function (req, res, next) {
	res.sendStatus(200);
});
```


## License

MIT © Stipe Kotarac (https://github.com/kotarac)
