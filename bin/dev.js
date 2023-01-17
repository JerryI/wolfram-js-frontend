#!/usr/bin/env node

// NOTE: Don't require anything from node_modules here, since the
// install script has to be able to run _before_ that exists.
const child = require("child_process"), fs = require("fs"), path = require("path"), {join} = path
const chokidar = require('chokidar');

let root = join(__dirname, "..")

function start() {
  let command = process.argv[2]

  let args = process.argv.slice(3)
  let cmdFn = {
    devserver,
    run: runCmd,
    "--help": () => help(0)
  }[command]
  if (!cmdFn || cmdFn.length > args.length) help(1)
  new Promise(r => r(cmdFn.apply(null, args))).catch(e => error(e))
}

function error(err) {
  console.error(err)
  process.exit(1)
}

function run(cmd, args, wd = root, { shell = false } = {}) {
  return child.execFileSync(cmd, args, {shell, cwd: wd, encoding: "utf8", stdio: ["ignore", "pipe", process.stderr]})
}

function replace(file, f) {
  fs.writeFileSync(file, f(fs.readFileSync(file, "utf8")))
}

function build() {
  runCmd("./node_modules/.bin/rollup","--config", "rollup.config.mjs");
}

function startServer() {

  var finalhandler = require('finalhandler')
  var http = require('http')
  var serveStatic = require('serve-static')
  
  // Serve up public/ftp folder
  var serve = serveStatic(root, { index: ['index.html', 'index.htm'] })
  
  // Create server
  var server = http.createServer(function onRequest (req, res) {
    serve(req, res, finalhandler(req, res))
  })
  
  // Listen
  server.listen(8090, process.env.OPEN ? undefined : "0.0.0.0")  
  console.log("Dev server listening on 8090");
}

function devserver(...args) {
  startServer()
}

function runCmd(cmd, ...args) {


    try {
      console.log(run(cmd, args))
    } catch (e) {
      console.log(e.toString())
      process.exit(1)
    }
  
}

function rebuildAndRestart() {
  console.log("rebuilding...");
  build();
}

const watcher = chokidar.watch(join(root, '/src'), {
  ignored: /(^|[\/\\])\../,
  persistent: true
});

watcher
  .on('change', rebuildAndRestart);

//start()
