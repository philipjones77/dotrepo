'use strict';
const vscode = require('vscode');
const fs = require('node:fs');
const { spawn } = require('node:child_process');
const { windowsPdfPath, sumatraCandidates } = require('./pdf-path');

function activate(context) {
    if (process.platform !== 'win32') return;
    const output = vscode.window.createOutputChannel('SumatraPDF');
    context.subscriptions.push(output);
    const launches = new Map();
    async function openPdf(uri) {
        const pdf = windowsPdfPath(uri);
        if (!pdf) return false;
        if (!(await fs.promises.stat(pdf)).isFile()) throw new Error('PDF file does not exist: ' + pdf);
        const exe = sumatraCandidates(process.env).find(candidate => fs.existsSync(candidate));
        if (!exe) throw new Error('SumatraPDF is not installed in a standard location.');
        const key = pdf.toLowerCase();
        if (launches.has(key)) return launches.get(key);
        const launch = new Promise((resolve, reject) => {
            const child = spawn(exe, ['-reuse-instance', pdf], {
                shell: false, detached: true, stdio: 'ignore', windowsHide: false
            });
            child.once('error', reject);
            child.once('spawn', () => {
                output.appendLine('Opened in SumatraPDF: ' + pdf);
                child.unref();
                resolve(true);
            });
        });
        launches.set(key, launch);
        try { return await launch; }
        finally { setTimeout(() => launches.delete(key), 1000); }
    }
    function report(error) {
        output.appendLine(String(error));
        void vscode.window.showErrorMessage('SumatraPDF: ' + error.message);
    }
    async function routeTab(tab) {
        // Handle only newly opened, clean PDF tabs. Leave diffs and dirty text alone.
        if (tab.isDirty || !windowsPdfPath(tab.input?.uri)) return;
        try {
            if (await openPdf(tab.input.uri)) await vscode.window.tabGroups.close(tab, true);
        } catch (error) { report(error); }
    }
    context.subscriptions.push(vscode.commands.registerCommand('dotrepo.openPdfInSumatra', async uri => {
        try { await openPdf(uri || vscode.window.activeTextEditor?.document.uri); }
        catch (error) { report(error); }
    }));
    context.subscriptions.push(vscode.window.registerCustomEditorProvider('dotrepo.sumatraPdf', {
        openCustomDocument(uri) { return { uri, dispose() {} }; },
        async resolveCustomEditor(document, panel) {
            try {
                if (await openPdf(document.uri)) panel.dispose();
                else panel.webview.html = '<p>This PDF is not accessible to the Windows SumatraPDF viewer.</p>';
            } catch (error) {
                panel.webview.html = '<p>SumatraPDF could not open this file. See the SumatraPDF output channel.</p>';
                report(error);
            }
        }
    }));
    // Chat extensions that force a text editor bypass editor associations.
    // Observe the resulting PDF tab using the public tab API and route it too.
    context.subscriptions.push(vscode.window.tabGroups.onDidChangeTabs(event => {
        for (const tab of event.opened) {
            if (tab.input?.viewType !== 'dotrepo.sumatraPdf') void routeTab(tab);
        }
    }));
}

exports.activate = activate;
