'use strict';
const path = require('node:path');

function windowsPdfPath(uri) {
    if (!uri || !/\.pdf$/i.test(uri.path || '')) return undefined;
    if (uri.scheme === 'file') return uri.fsPath;
    if (uri.scheme === 'vscode-remote' && /^wsl\+[A-Za-z0-9._-]+$/.test(uri.authority)) {
        const distro = uri.authority.slice(4);
        if (/^\/mnt\/[A-Za-z]\//.test(uri.path)) {
            return uri.path[5] + ':' + uri.path.slice(6).replace(/\//g, '\\');
        }
        return '\\\\wsl.localhost\\' + distro + uri.path.replace(/\//g, '\\');
    }
    return undefined;
}

function sumatraCandidates(env) {
    return [env.LOCALAPPDATA, env.ProgramFiles, env['ProgramFiles(x86)']]
        .filter(Boolean).map(base => path.win32.join(base, 'SumatraPDF', 'SumatraPDF.exe'));
}

module.exports = { windowsPdfPath, sumatraCandidates };
