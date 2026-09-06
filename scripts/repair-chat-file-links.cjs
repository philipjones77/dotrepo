#!/usr/bin/env node
'use strict';
// Temporary repair for two verified extension releases; never patch unknown builds.
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const crypto = require('node:crypto');
const vm = require('node:vm');
const assert = require('node:assert/strict');

const args = process.argv.slice(2);
let apply = false, selfTest = false, distro = 'Ubuntu', extensionsDir;
for (let i = 0; i < args.length; i++) {
  if (args[i] === '--apply') apply = true;
  else if (args[i] === '--check') apply = false;
  else if (args[i] === '--self-test') selfTest = true;
  else if (args[i] === '--wsl-distro') distro = args[++i];
  else if (args[i] === '--extensions-dir') extensionsDir = args[++i];
  else throw new Error('Usage: node scripts/repair-chat-file-links.cjs [--check|--apply] [--wsl-distro Ubuntu] [--extensions-dir PATH] [--self-test]');
}
assert(typeof distro === 'string' && /^[A-Za-z0-9._-]+$/.test(distro), 'Expected a simple registered WSL distribution name.');

function normalizeLinkPath(value, platform, distribution) {
  if (platform === 'win32') {
    if (/^\/[A-Za-z]:[\\/]/.test(value)) value = value.slice(1);
    if (/^\/mnt\/[A-Za-z](?:\/|$)/.test(value)) return value[5] + ':' + (value.slice(6) || '/');
    if (/^\/(?:home|root|tmp|var|usr|opt|etc)(?:\/|$)/.test(value)) return '//wsl.localhost/' + distribution + value;
  } else if (platform === 'linux') {
    if (/^\/?[A-Za-z]:[\\/]/.test(value)) {
      value = value.replace(/^\//, '');
      return '/mnt/' + value[0].toLowerCase() + value.slice(2).replace(/\\/g, '/');
    }
    const unc = value.replace(/\\/g, '/');
    for (const host of ['wsl.localhost', 'wsl$']) {
      const prefix = '//' + host + '/' + distribution;
      if (unc.toLowerCase() === prefix.toLowerCase()) return '/';
      if (unc.toLowerCase().startsWith(prefix.toLowerCase() + '/')) return unc.slice(prefix.length);
    }
  }
  return value;
}
const viewerPattern = /\.(?:pdf|png|jpe?g|jpe|bmp|gif|ico|webp|avif|svg)$/i;
const specs = [
  { id: 'openai.chatgpt', version: '26.901.22334', relative: 'out/extension.js',
    original: 'e8d3bb57b73a1fd316fd557859aec56e540b48de3489012d1952fa4a2e371208',
    repaired: ['a22e9fc0538d46f947eb9b721b43b9dd61708ca5d55d00dab4d08c25baf69cd2', '163fd5c7ead3aa966da1d213df838ab257a0806206212bf7022e2ec9b5de5d7c'] },
  { id: 'anthropic.claude-code', version: '2.1.263', relative: 'extension.js',
    original: '0eb46198cbb1ae18578de0f7b28ba8903ac0fd4a5d213eeb7c7973f11d9bffb7',
    repaired: ['fb85f7941c4c9319352337147cb48113e50538d26bd9a3ba74e1fdb2d27d8f98', 'ff23091f2f867caa09e6997bbdceebca28c67f815ff18267da03e687394c4280'] },
];
const sha = content => crypto.createHash('sha256').update(content).digest('hex');
function replaceOnce(text, before, after) {
  assert.equal(text.split(before).length - 1, 1, 'Expected exactly one known implementation fragment.');
  return text.replace(before, () => after);
}
function repairReplacements(spec, distribution) {
  const marker = '/* dotrepo-file-links-v1:' + distribution + ' */';
  const normalize = '(' + marker + normalizeLinkPath.toString() + ')';
  if (spec.id === 'openai.chatgpt') {
    return [[
      'p=process.platform==="win32"?Sc(u):u,m=Array.from(Rn.workspace.workspaceFolders??[])',
      'p=' + normalize + '(u,process.platform,' + JSON.stringify(distribution) + '),m=Array.from(Rn.workspace.workspaceFolders??[])'], [
      'if(s)return await Rn.commands.executeCommand("revealFileInOS",b),!0;let v=await Rn.workspace.openTextDocument(b),w=new Rn.Position',
      'if(s)return await Rn.commands.executeCommand("revealFileInOS",b),!0;if(c==null||' + viewerPattern + '.test(b.path))return await Rn.commands.executeCommand("vscode.open",b,{preview:!1}),!0;let v=await Rn.workspace.openTextDocument(b),w=new Rn.Position']];
  }
  return [[
    'async openFile($,J){let Q=K6.isAbsolute($)?$:K6.join(this.cwd,$);',
    'async openFile($,J){$=' + normalize + '($,process.platform,' + JSON.stringify(distribution) + ');let Q=K6.isAbsolute($)?$:K6.join(this.cwd,$);'], [
    '}catch{}S$.window.showTextDocument(X).then((z)=>{if(J?.searchText)',
    '}catch{}if((!J?.searchText&&!J?.startLine&&!J?.endLine)||' + viewerPattern + '.test(Q))return S$.commands.executeCommand("vscode.open",X,{preview:!1});S$.window.showTextDocument(X).then((z)=>{if(J?.searchText)']];
}
function repair(original, spec, distribution) {
  let result = original;
  for (const [before, after] of repairReplacements(spec, distribution)) result = replaceOnce(result, before, after);
  new vm.Script(result);
  return result;
}
function isRecognizedRepair(content, spec, distribution, digest = sha(content)) {
  if (distribution === 'Ubuntu' && spec.repaired.includes(digest)) return true;
  // Custom distro names change the repair's hash. Reverse both exact edits and
  // authenticate the complete recovered bundle, never just its comment marker.
  try {
    let restored = content;
    for (const [before, after] of repairReplacements(spec, distribution).reverse()) restored = replaceOnce(restored, after, before);
    return sha(restored) === spec.original;
  } catch {
    return false;
  }
}

if (selfTest) {
  const cases = [
    ['win32', '/C:/dev/My Report.pdf', 'C:/dev/My Report.pdf'],
    ['win32', '/mnt/c/dev/plot.png', 'c:/dev/plot.png'],
    ['win32', '/home/phili/report.md', '//wsl.localhost/Ubuntu/home/phili/report.md'],
    ['linux', '/C:/dev/My Report.pdf', '/mnt/c/dev/My Report.pdf'],
    ['linux', 'C:\\dev\\plot.png', '/mnt/c/dev/plot.png'],
    ['linux', '//wsl.localhost/Ubuntu/home/phili/report.md', '/home/phili/report.md'],
    ['linux', '//wsl.localhost/AnotherDistro/home/file.md', '//wsl.localhost/AnotherDistro/home/file.md'],
    ['linux', 'docs/report.md', 'docs/report.md'],
  ];
  cases.forEach(([platform, input, expected]) => assert.equal(normalizeLinkPath(input, platform, 'Ubuntu'), expected));
  for (const ext of ['pdf', 'png', 'jpeg', 'gif', 'svg', 'avif']) assert(viewerPattern.test('sample.' + ext));
  for (const ext of ['js', 'py', 'ps1', 'sh', 'exe']) assert(!viewerPattern.test('sample.' + ext));
  const fixtures = [
    'async function fixture(){let p=process.platform==="win32"?Sc(u):u,m=Array.from(Rn.workspace.workspaceFolders??[]);if(s)return await Rn.commands.executeCommand("revealFileInOS",b),!0;let v=await Rn.workspace.openTextDocument(b),w=new Rn.Position();}',
    'class Fixture{async openFile($,J){let Q=K6.isAbsolute($)?$:K6.join(this.cwd,$);let X;try{}catch{}S$.window.showTextDocument(X).then((z)=>{if(J?.searchText){}});}}',
  ];
  specs.forEach((spec, index) => {
    const fixture = fixtures[index];
    const fixtureSpec = {...spec, original: sha(fixture), repaired: []};
    for (const distribution of ['Ubuntu', 'Ubuntu-Dev']) {
      const patched = repair(fixture, fixtureSpec, distribution);
      assert(isRecognizedRepair(patched, fixtureSpec, distribution), 'An exact repair must remain idempotent for custom distributions.');
      assert(!isRecognizedRepair(patched + '\n// unexpected modification', fixtureSpec, distribution), 'A retained marker must not authenticate changed bundle content.');
      assert(!isRecognizedRepair(patched.replace('vscode.open', 'unexpected.open'), fixtureSpec, distribution), 'A retained marker must not authenticate a corrupted repair.');
      assert(!isRecognizedRepair('/* dotrepo-file-links-v1:' + distribution + ' */' + fixture, fixtureSpec, distribution), 'A marker alone is not a repair.');
      assert(!isRecognizedRepair(patched, fixtureSpec, 'AnotherDistro'), 'A repair for another distribution must be refused.');
    }
  });
  console.log('Path, viewer routing, and repair integrity self-tests passed.');
  if (!apply && !args.includes('--check')) process.exit(0);
}

extensionsDir = path.resolve(extensionsDir || path.join(os.homedir(), process.platform === 'win32' ? '.vscode' : '.vscode-server', 'extensions'));
const entries = fs.readdirSync(extensionsDir, {withFileTypes: true});
const report = { mode: apply ? 'apply' : 'check', extensionsDir, wslDistribution: distro, results: [] };
const planned = [];
for (const spec of specs) {
  const matches = entries.filter(entry => entry.isDirectory() && entry.name.toLowerCase().startsWith(spec.id + '-')).map(entry => {
    const directory = path.join(extensionsDir, entry.name);
    return {directory, manifest: JSON.parse(fs.readFileSync(path.join(directory, 'package.json'), 'utf8'))};
  }).sort((a, b) => b.manifest.version.localeCompare(a.manifest.version, undefined, {numeric: true}));
  if (!matches.length) { report.results.push({id: spec.id, status: 'not-installed'}); continue; }
  const {directory, manifest} = matches[0];
  const target = path.join(directory, spec.relative);
  assert(fs.realpathSync(target).startsWith(fs.realpathSync(directory) + path.sep), 'Extension file escapes its directory.');
  const original = fs.readFileSync(target, 'utf8');
  const digest = sha(original);
  const result = {id: spec.id, version: manifest.version, target, beforeSha256: digest};
  if (manifest.version !== spec.version) result.status = 'unsupported-version-review-required';
  else if (isRecognizedRepair(original, spec, distro, digest)) result.status = 'already-repaired';
  else if (digest !== spec.original) result.status = 'unknown-build-review-required';
  else {
    result.status = 'repair-available';
    planned.push({result, original, patched: repair(original, spec, distro)});
  }
  report.results.push(result);
}
// Complete every preflight before touching either extension.
if (apply && report.results.some(item => /review-required$/.test(item.status))) throw new Error(JSON.stringify(report, null, 2));
if (apply && planned.length) {
  const backup = path.join(os.homedir(), '.dotrepo-backups', new Date().toISOString().replace(/[:.]/g, '-') + '-chat-file-links');
  fs.mkdirSync(backup, {recursive: true});
  report.backup = backup;
  for (const item of planned) {
    item.result.backup = path.join(backup, item.result.id + '.js');
    fs.copyFileSync(item.result.target, item.result.backup);
  }
  for (const item of planned) {
    fs.writeFileSync(item.result.target, item.patched);
    item.result.afterSha256 = sha(fs.readFileSync(item.result.target));
    assert.equal(item.result.afterSha256, sha(item.patched));
    item.result.status = 'repaired-reload-required';
  }
  fs.writeFileSync(path.join(backup, 'repair.json'), JSON.stringify(report, null, 2) + '\n');
}
console.log(JSON.stringify(report, null, 2));
if (report.results.some(item => item.status === 'repair-available' || /review-required$/.test(item.status))) process.exitCode = 1;
