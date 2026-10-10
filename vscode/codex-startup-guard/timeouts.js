'use strict';
// Pure helpers so the detection logic can be tested without VS Code.
const path = require('node:path');

const MARKER = 'renderer_ready_timeout';

// VS Code gives each extension a log folder beside every other extension's
// folder for the same extension host: .../exthost[N]/<extension id>/.
function codexLogPath(guardLogDirectory) {
  return path.join(path.dirname(guardLogDirectory), 'openai.chatgpt', 'Codex.log');
}

// Timestamped log lines are unique, so they identify a timeout across
// extension-host restarts that append to the same log file.
function findNewTimeouts(text, handled) {
  return text.split(/\r?\n/).filter(line => line.includes(MARKER) && !handled.includes(line));
}

module.exports = { MARKER, codexLogPath, findNewTimeouts };
