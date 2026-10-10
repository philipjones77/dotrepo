'use strict';
// Recover Codex when its sidebar webview misses the extension's fixed 30 s
// "renderer ready" deadline. Codex then shows a static "could not start" page
// and never retries; only a new extension host rebuilds the webview.
const fs = require('node:fs');
const vscode = require('vscode');
const { codexLogPath, findNewTimeouts } = require('./timeouts');

const HANDLED_KEY = 'handledTimeouts';
const LAST_AUTO_KEY = 'lastAutomaticRestart';
const POLL_MS = 3000;
const AUTO_RESTART_COOLDOWN_MS = 10 * 60 * 1000;

function activate(context) {
  const output = vscode.window.createOutputChannel('Codex Startup Guard', { log: true });
  const logFile = codexLogPath(context.logUri.fsPath);
  output.info(`Watching ${logFile}`);
  let size = -1, busy = false;

  async function check() {
    if (busy) return;
    busy = true;
    try {
      let stat;
      try { stat = fs.statSync(logFile); } catch { return; }
      if (stat.size === size) return;
      size = stat.size;
      const handled = context.globalState.get(HANDLED_KEY, []);
      const fresh = findNewTimeouts(fs.readFileSync(logFile, 'utf8'), handled);
      if (!fresh.length) return;
      await context.globalState.update(HANDLED_KEY, handled.concat(fresh).slice(-50));
      fresh.forEach(line => output.warn(line));
      await recover(context, output);
    } catch (error) {
      output.error(String(error));
    } finally {
      busy = false;
    }
  }

  const timer = setInterval(check, POLL_MS);
  context.subscriptions.push(output, { dispose: () => clearInterval(timer) });
  check();
}

async function recover(context, output) {
  const mode = vscode.workspace.getConfiguration('dotrepo.codexStartupGuard').get('recovery', 'prompt');
  if (mode === 'off') return;
  if (mode === 'restartExtensionHost') {
    const last = context.globalState.get(LAST_AUTO_KEY, 0);
    if (Date.now() - last > AUTO_RESTART_COOLDOWN_MS) {
      await context.globalState.update(LAST_AUTO_KEY, Date.now());
      output.info('Restarting the extension host automatically.');
      await vscode.commands.executeCommand('workbench.action.restartExtensionHost');
      return;
    }
    output.warn('Automatic restart skipped: another one ran within 10 minutes.');
  }
  const restart = 'Restart Extension Host', reload = 'Reload Window';
  const choice = await vscode.window.showWarningMessage(
    'Codex timed out loading its interface while VS Code was busy starting extensions. Restart extensions to load it again?',
    restart, reload);
  if (choice === restart) await vscode.commands.executeCommand('workbench.action.restartExtensionHost');
  else if (choice === reload) await vscode.commands.executeCommand('workbench.action.reloadWindow');
}

function deactivate() {}

module.exports = { activate, deactivate };
