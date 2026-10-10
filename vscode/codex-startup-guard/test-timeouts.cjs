'use strict';
const assert = require('node:assert/strict');
const path = require('node:path');
const { codexLogPath, findNewTimeouts } = require('./timeouts');

const windowsLog = codexLogPath(path.join('logs', 'window4', 'exthost', 'dotrepo.codex-startup-guard'));
assert.equal(windowsLog, path.join('logs', 'window4', 'exthost', 'openai.chatgpt', 'Codex.log'));
const remoteLog = codexLogPath(path.join('logs', 's', 'exthost3', 'dotrepo.codex-startup-guard'));
assert.equal(remoteLog, path.join('logs', 's', 'exthost3', 'openai.chatgpt', 'Codex.log'));

const first = '2026-10-10 07:02:31.688 [error] [CodexWebviewProvider] Webview renderer did not become ready reason=renderer_ready_timeout';
const second = '2026-10-10 08:00:00.000 [error] [CodexWebviewProvider] Webview renderer did not become ready reason=renderer_ready_timeout';
const log = ['2026-10-10 07:02:00.424 [info] Activating Codex extension', first, ''].join('\r\n');
assert.deepEqual(findNewTimeouts(log, []), [first]);
assert.deepEqual(findNewTimeouts(log, [first]), [], 'A handled timeout must not trigger again after a restart.');
assert.deepEqual(findNewTimeouts(log + second + '\n', [first]), [second]);
assert.deepEqual(findNewTimeouts('[error] something else\n', []), []);
console.log('Codex startup guard tests passed.');
