'use strict';
const vscode = require('vscode');
const fs = require('node:fs/promises');
const os = require('node:os');
const path = require('node:path');
const crypto = require('node:crypto');

async function activate(context) {
  if (process.platform !== 'win32' || vscode.env.remoteName) return;
  const output = vscode.window.createOutputChannel('Windows Python 3.14 migration');
  context.subscriptions.push(output);
  const target = path.join(os.homedir(), '.virtualenvs', 'py314', 'Scripts', 'python.exe');
  const normalize = value => path.resolve(value).toLowerCase();
  const reportRoot = path.join(os.homedir(), '.local', 'state', 'dotrepo', 'windows-python-default');
  let queue = Promise.resolve();
  async function migrate() {
    await fs.access(target);
    const extension = vscode.extensions.getExtension('ms-python.python');
    if (!extension) throw new Error('Microsoft Python extension is unavailable.');
    const api = await extension.activate();
    await api.ready;
    for (const folder of vscode.workspace.workspaceFolders || []) {
      if (folder.uri.scheme !== 'file' || !/^c:\\dev\\[^\\]+$/i.test(folder.uri.fsPath)) continue;
      const configured = vscode.workspace.getConfiguration('python', folder.uri).get('defaultInterpreterPath');
      if (typeof configured !== 'string') continue;
      const expanded = configured.replace(/\$\{env:USERPROFILE\}/gi, os.homedir()).replace(/\$\{userHome\}/g, os.homedir());
      if (normalize(expanded) !== normalize(target)) continue;
      const key = 'py314-migration-v1:' + folder.uri.toString();
      if (context.workspaceState.get(key)) continue;
      const before = api.environments.getActiveEnvironmentPath(folder.uri);
      await api.environments.updateActiveEnvironmentPath(target, folder.uri);
      const after = api.environments.getActiveEnvironmentPath(folder.uri);
      if (!after || normalize(after.path) !== normalize(target)) throw new Error('Interpreter readback failed for ' + folder.name);
      const report = { time: new Date().toISOString(), folder: folder.uri.fsPath, before, after, status: 'passed' };
      await fs.mkdir(reportRoot, { recursive: true });
      const identity = crypto.createHash('sha256').update((vscode.workspace.workspaceFile?.toString() || '') + folder.uri.toString()).digest('hex').slice(0, 16);
      await fs.writeFile(path.join(reportRoot, identity + '.json'), JSON.stringify(report, null, 2) + '\n');
      await context.workspaceState.update(key, true);
      output.appendLine(JSON.stringify(report));
    }
  }
  function schedule() {
    queue = queue.then(migrate).catch(error => output.appendLine(String(error.stack || error)));
    return queue;
  }
  context.subscriptions.push(vscode.workspace.onDidChangeWorkspaceFolders(schedule));
  context.subscriptions.push(vscode.workspace.onDidChangeConfiguration(event => {
    if (event.affectsConfiguration('python.defaultInterpreterPath')) schedule();
  }));
  await schedule();
}
module.exports = { activate };
