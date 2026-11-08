'use strict';
const vscode = require('vscode');
const fs = require('node:fs/promises');
const path = require('node:path');
const os = require('node:os');
const crypto = require('node:crypto');

async function activate(context) {
  if (process.platform !== 'linux' || !process.env.WSL_DISTRO_NAME) return;
  const output = vscode.window.createOutputChannel('WSL Python defaults');
  context.subscriptions.push(output);
  const production = new Set(['arbplusjax', 'integralfunctionsjax', 'randomfields77', 'toposmpljax', 'petsjax', 'data77']);
  let queue = Promise.resolve();
  async function migrate() {
    const extension = vscode.extensions.getExtension('ms-python.python');
    if (!extension) throw new Error('Microsoft Python extension is unavailable.');
    const api = await extension.activate();
    await api.ready;
    for (const folder of vscode.workspace.workspaceFolders || []) {
      if (folder.uri.scheme !== 'file') continue;
      const key = 'wsl-defaults-20261108:' + folder.uri.toString();
      if (context.workspaceState.get(key)) continue;
      const name = production.has(path.basename(folder.uri.fsPath).toLowerCase()) ? 'jax314' : 'py314';
      const target = path.join(os.homedir(), '.virtualenvs', name, 'bin', 'python');
      await fs.access(target);
      const before = api.environments.getActiveEnvironmentPath(folder.uri);
      await api.environments.updateActiveEnvironmentPath(target, folder.uri);
      const after = api.environments.getActiveEnvironmentPath(folder.uri);
      if (!after || path.resolve(after.path) !== target) throw new Error('Interpreter readback failed: ' + folder.name);
      const report = { time: new Date().toISOString(), folder: folder.uri.fsPath, before, after, status: 'passed' };
      const root = path.join(os.homedir(), '.local', 'state', 'dotrepo', 'wsl-python-default');
      await fs.mkdir(root, { recursive: true });
      const id = crypto.createHash('sha256').update(folder.uri.toString()).digest('hex').slice(0, 16);
      await fs.writeFile(path.join(root, id + '.json'), JSON.stringify(report, null, 2) + '\n');
      await context.workspaceState.update(key, true);
      output.appendLine(JSON.stringify(report));
    }
  }
  const schedule = () => { queue = queue.then(migrate).catch(e => output.appendLine(String(e.stack || e))); return queue; };
  context.subscriptions.push(vscode.workspace.onDidChangeWorkspaceFolders(schedule));
  await schedule();
}
module.exports = { activate };
