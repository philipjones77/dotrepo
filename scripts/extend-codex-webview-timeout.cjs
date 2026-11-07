#!/usr/bin/env node
'use strict';
// Extend the Codex (openai.chatgpt) extension's fixed 30 s "renderer ready" deadline.
//
// Codex gives its sidebar webview 30 s to post renderer_ready, then replaces it with a
// static "could not start its user interface" page and never retries. Measured on
// PhilipSecond (2026-11-07) in an isolated VS Code profile holding only Codex, the
// webview needed ~11.5 s just to reach its first React render and 13.9 s to mount its
// routes, so any contention (extension-activation burst, extension-host restart, cold
// disk cache, antivirus on-access scanning) pushes it past 30 s. This helper raises the
// deadline. It is version-agnostic but exact: the bundle must contain the known minified
// fragment exactly once, the result is re-parsed, and a backup is written first.
// scripts/repair-chat-file-links.cjs treats this edit as hash-neutral.
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const { execFileSync } = require('node:child_process');

const ORIGINAL = 'timeoutMs:3e4})},3e4)';
const ANY_EDIT = /timeoutMs:(\d+(?:e\d+)?)\}\)\},\1\)/g;
const DEFAULT_SECONDS = 180;

const args = process.argv.slice(2);
let apply = false, selfTest = false, includeWsl = true, distro = 'Ubuntu', seconds = DEFAULT_SECONDS;
const extensionDirs = [];
for (let i = 0; i < args.length; i++) {
  if (args[i] === '--apply') apply = true;
  else if (args[i] === '--check') apply = false;
  else if (args[i] === '--self-test') selfTest = true;
  else if (args[i] === '--no-wsl') includeWsl = false;
  else if (args[i] === '--wsl-distro') distro = args[++i];
  else if (args[i] === '--seconds') seconds = Number(args[++i]);
  else if (args[i] === '--extensions-dir') extensionDirs.push(args[++i]);
  else throw new Error('Usage: node scripts/extend-codex-webview-timeout.cjs [--check|--apply] [--seconds N] [--extensions-dir PATH]... [--wsl-distro Ubuntu|--no-wsl] [--self-test]');
}
assert(/^[A-Za-z0-9._-]+$/.test(distro), 'Expected a simple registered WSL distribution name.');
assert(Number.isInteger(seconds) && seconds >= 30 && seconds <= 900, 'Expected --seconds between 30 and 900.');
const patchedFragment = `timeoutMs:${seconds * 1000}})},${seconds * 1000})`;

function currentSeconds(content) {
  const matches = [...content.matchAll(ANY_EDIT)];
  if (matches.length !== 1) return null;
  return Number(matches[0][1]) / 1000;
}
function extend(content) {
  assert.equal(content.split(ORIGINAL).length - 1, 1, 'Expected exactly one known renderer-ready timeout fragment.');
  const result = content.replace(ORIGINAL, () => patchedFragment);
  new vm.Script(result);
  assert.equal(currentSeconds(result), seconds);
  return result;
}
function classify(content) {
  const current = currentSeconds(content);
  if (current === null) return { status: 'unknown-build-review-required' };
  if (content.includes(ORIGINAL)) return { status: 'repair-available', currentSeconds: 30 };
  if (current === seconds) return { status: 'already-extended', currentSeconds: current };
  return { status: 'extended-to-other-value-review-required', currentSeconds: current };
}

if (selfTest) {
  const fixture = 'var K2=class{start(){let e=Date.now();this.timeout=setTimeout(()=>{this.timeout=void 0,this.onTimeout({elapsedMs:Date.now()-e,receivedWebviewMessage:this.receivedWebviewMessage,timeoutMs:3e4})},3e4)}};';
  assert.equal(classify(fixture).status, 'repair-available');
  const patched = extend(fixture);
  assert.equal(classify(patched).status, 'already-extended');
  assert.equal(currentSeconds(patched), seconds);
  assert.throws(() => extend(patched), 'A second application must be refused.');
  assert.throws(() => extend(fixture + ORIGINAL), 'Two fragments must be refused.');
  assert.equal(classify('function x(){}').status, 'unknown-build-review-required');
  assert.equal(classify(fixture.replace(ORIGINAL, 'timeoutMs:6e4})},6e4)')).status, 'extended-to-other-value-review-required');
  assert.throws(() => new vm.Script(patched + ' ) '), 'Syntax validation must detect a broken bundle.');
  console.log('Codex webview timeout self-tests passed.');
  if (!args.includes('--check') && !apply) process.exit(0);
}

function defaultExtensionDirs() {
  if (process.platform !== 'win32') return [path.join(os.homedir(), '.vscode-server', 'extensions')];
  const dirs = [path.join(os.homedir(), '.vscode', 'extensions')];
  if (includeWsl) {
    try {
      const home = execFileSync('wsl.exe', ['-d', distro, '--', 'sh', '-c', 'wslpath -w "$HOME"'], { encoding: 'utf8', timeout: 20000, stdio: ['ignore', 'pipe', 'ignore'] }).trim();
      const serverExtensions = path.join(home, '.vscode-server', 'extensions');
      if (home && fs.existsSync(serverExtensions)) dirs.push(serverExtensions);
    } catch { /* WSL absent or stopped: Windows only. */ }
  }
  return dirs;
}
const dirs = (extensionDirs.length ? extensionDirs : defaultExtensionDirs()).map(d => path.resolve(d));
const report = { mode: apply ? 'apply' : 'check', seconds, results: [] };
const planned = [];
for (const directory of dirs) {
  if (!fs.existsSync(directory)) { report.results.push({ extensionsDir: directory, status: 'missing-extensions-dir' }); continue; }
  const matches = fs.readdirSync(directory, { withFileTypes: true })
    .filter(entry => entry.isDirectory() && entry.name.toLowerCase().startsWith('openai.chatgpt-'))
    .map(entry => ({ dir: path.join(directory, entry.name), manifest: JSON.parse(fs.readFileSync(path.join(directory, entry.name, 'package.json'), 'utf8')) }))
    .sort((a, b) => b.manifest.version.localeCompare(a.manifest.version, undefined, { numeric: true }));
  if (!matches.length) { report.results.push({ extensionsDir: directory, status: 'not-installed' }); continue; }
  const { dir, manifest } = matches[0];
  const target = path.join(dir, 'out', 'extension.js');
  assert(fs.realpathSync(target).startsWith(fs.realpathSync(dir) + path.sep), 'Extension file escapes its directory.');
  const content = fs.readFileSync(target, 'utf8');
  const result = { extensionsDir: directory, version: manifest.version, target, ...classify(content) };
  if (result.status === 'repair-available') planned.push({ result, content });
  report.results.push(result);
}
if (apply && report.results.some(item => /review-required$/.test(item.status))) throw new Error(JSON.stringify(report, null, 2));
if (apply && planned.length) {
  const backup = path.join(os.homedir(), '.dotrepo-backups', new Date().toISOString().replace(/[:.]/g, '-') + '-codex-webview-timeout');
  fs.mkdirSync(backup, { recursive: true });
  report.backup = backup;
  for (const item of planned) {
    item.patched = extend(item.content);
    item.result.backup = path.join(backup, path.basename(path.dirname(path.dirname(item.result.target))) + '.js');
    fs.copyFileSync(item.result.target, item.result.backup);
  }
  for (const item of planned) {
    fs.writeFileSync(item.result.target, item.patched);
    assert.equal(fs.readFileSync(item.result.target, 'utf8'), item.patched);
    item.result.status = 'extended-reload-required';
    item.result.currentSeconds = seconds;
  }
  fs.writeFileSync(path.join(backup, 'repair.json'), JSON.stringify(report, null, 2) + '\n');
}
console.log(JSON.stringify(report, null, 2));
if (report.results.some(item => item.status === 'repair-available' || /review-required$/.test(item.status))) process.exitCode = 1;
