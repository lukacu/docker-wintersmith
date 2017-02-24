var execFile = require('child_process').execFile;
var repository = process.env.GITHUB_USERNAME + "/" + process.env.GITHUB_REPOSITORY;

var http = require('http')
var createHandler = require('github-webhook-handler')

var handler = createHandler({ path: '/', secret: process.env.GITHUB_SECRET });

http.createServer(function (req, res) {
  handler(req, res, function (err) {
    res.statusCode = 404
    res.end('no such location')
  })
}).listen(9001)

handler.on('ping', function (event) {
            // Exec a shell script
            execFile('/scripts/build.sh', function(error, stdout, stderr) {
            });
}).on('push', function (event) {
    if( event.payload.branch === process.env.GITHUB_BRANCH )
    {
            // Exec a shell script
            execFile('/scripts/build.sh', function(error, stdout, stderr) { console.log(error); });
    }
});

