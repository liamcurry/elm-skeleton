module.exports = {
	files: ['dist/*.(html|css|js)'],
	server: {
		baseDir: 'dist',
		middleware: [
			require('connect-history-api-fallback')()
		]
	}
}
