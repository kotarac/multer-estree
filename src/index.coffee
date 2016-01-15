crypto = require 'crypto'
path = require 'path'
S3FS = require 's3fs'


fs = (bucket, config) ->
	return new S3FS bucket, config


getKey = (req, file, cb) ->
	filename = file.originalname
	ext = path.extname filename

	crypto.randomBytes 32, (err, buf) ->
		return cb err if err
		return cb null, "#{path.basename(filename, ext)}-#{buf.toString('hex')[..7]}#{ext}"


class MulterS3
	constructor: (opts) ->
		{bucket, accessKeyId, secretAccessKey, region} = opts

		@fs = fs bucket, {accessKeyId, secretAccessKey, region}
		@getKey = opts.key or getKey


	_handleFile: (req, file, cb) ->
		@getKey req, file, (err, key) =>
			return cb err if err

			f = file.stream
			o = @fs.createWriteStream key

			f.pipe(o).on 'error', cb
			o.on 'error', cb
			o.on 'finish', -> cb null,
				key: key
				size: o.bytesWritten


	_removeFile: (req, file, cb) ->
		@fs.unlink file.key, cb


module.exports = (opts = {}) ->
	throw new TypeError 'bucket not specified' unless opts.bucket
	return new MulterS3 opts
