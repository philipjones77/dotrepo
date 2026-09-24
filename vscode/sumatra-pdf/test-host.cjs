'use strict';
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vscode = require('vscode');
const pause = ms => new Promise(resolve => setTimeout(resolve, ms));
async function eventually(check, message) {
    for (let i = 0; i < 60; i++) {
        if (check()) return;
        await pause(100);
    }
    throw new Error(message);
}
exports.run = async function () {
    const extension = vscode.extensions.getExtension('dotrepo.sumatra-pdf');
    assert(extension, 'Local extension is discoverable');
    await extension.activate();
    const pdf = vscode.Uri.file(process.env.DOTREPO_TEST_PDF);
    const tabsFor = uri => vscode.window.tabGroups.all.flatMap(group => group.tabs)
        .filter(tab => tab.input?.uri?.toString() === uri.toString());
    await vscode.commands.executeCommand('vscode.openWith', pdf, 'dotrepo.sumatraPdf');
    await eventually(() => tabsFor(pdf).length === 0, 'Custom PDF editor did not route and close');
    await pause(1100);
    const document = await vscode.workspace.openTextDocument(pdf);
    await vscode.window.showTextDocument(document);
    await eventually(() => tabsFor(pdf).length === 0, 'Forced text PDF editor did not route and close');
    const ordinary = await vscode.workspace.openTextDocument({content: 'Keep ordinary text open.'});
    await vscode.window.showTextDocument(ordinary);
    await pause(200);
    assert(tabsFor(ordinary.uri).length > 0, 'Ordinary text must remain open');
    const result = {passed: ['custom PDF editor', 'forced text PDF editor', 'ordinary text preserved'], pdf: pdf.fsPath};
    fs.writeFileSync(process.env.DOTREPO_TEST_RESULT, JSON.stringify(result, null, 2));
    console.log('SumatraPDF extension host checks passed.');
};
