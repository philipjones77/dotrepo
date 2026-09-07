"""Capture shareable software inventories; never export credentials or user files."""
import argparse
import importlib.metadata
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
from urllib.parse import urlsplit, unquote
from datetime import datetime, timezone


def command(args, timeout=120):
    result = subprocess.run(list(map(str, args)), capture_output=True, text=True,
                            encoding='utf-8', errors='replace', timeout=timeout)
    if result.returncode:
        raise RuntimeError(f'{Path(str(args[0])).name} exited {result.returncode}')
    return result.stdout.strip()


def save(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


def key(name):
    return re.sub(r'[-_.]+', '-', name).lower()


def safe_repo_url(url):
    """Allow GitHub repository identities only, stripping credentials and query data."""
    if re.fullmatch(r'git@github\.com:[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+', url):
        return url
    parsed = urlsplit(url)
    if parsed.scheme == 'https' and parsed.hostname == 'github.com' and re.fullmatch(r'/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+', parsed.path):
        return 'https://github.com' + parsed.path
    return None


def source_details(data):
    result = {}
    url = data.get('url', '')
    if url.startswith('file:'):
        raw = unquote(urlsplit(url).path)
        if os.name == 'nt' and re.match(r'^/[A-Za-z]:', raw):
            raw = raw[1:]
        root = Path(raw)
        if root.is_dir():
            try:
                remote = safe_repo_url(command(['git', '-C', root, 'remote', 'get-url', 'origin']))
                if remote:
                    result['repository'] = remote
                    result['commit'] = command(['git', '-C', root, 'rev-parse', 'HEAD'])
                    result['uncommitted_changes'] = bool(command(['git', '-C', root, 'status', '--porcelain']))
            except (OSError, RuntimeError, subprocess.TimeoutExpired):
                pass
    elif data.get('vcs_info'):
        remote = safe_repo_url(url)
        if remote:
            result['repository'] = remote
            result['commit'] = data['vcs_info'].get('commit_id', '')
    return result


def environment(prefix, conda, output, name):
    records = json.loads(command([conda, 'list', '-p', prefix, '--json']))
    sites = [prefix / 'Lib/site-packages', *prefix.glob('lib/python*/site-packages')]
    direct = {}
    for dist in importlib.metadata.distributions(path=[str(p) for p in sites if p.is_dir()]):
        data = dist.read_text('direct_url.json')
        if data:
            data = json.loads(data)
            # Direct URLs may contain tokens, private paths or private repository names.
            # Record only the package identity and source category for manual recovery.
            direct[key(dist.metadata['Name'])] = {
                'name': dist.metadata['Name'], 'version': dist.version,
                'source': 'editable/local' if data.get('dir_info') else 'direct-url/vcs',
                **source_details(data),
            }
    dependencies, pip, manual, observed = [], [], [], []
    channels = set()
    for item in records:
        pkg, version = item['name'], item['version']
        channel = item.get('channel', '')
        observed.append({'name': pkg, 'version': version, 'build': item.get('build_string', ''),
                         'manager': 'pip' if channel == 'pypi' else 'conda'})
        if channel == 'pypi' and key(pkg) in direct:
            manual.append(direct[key(pkg)])
        elif channel == 'pypi':
            pip.append(f'{pkg}=={version}')
        else:
            if channel in ('conda-forge', 'defaults', 'pkgs/main', 'pkgs/r', 'pkgs/msys2'):
                channels.add('defaults' if channel.startswith('pkgs/') else channel)
                dependencies.append(f"{pkg}={version}={item['build_string']}")
            else:
                manual.append({'name': pkg, 'version': version, 'source': 'review-unrecognized-conda-channel'})
    if pip:
        dependencies.append({'pip': sorted(pip)})
    # JSON is valid YAML, so Conda can consume this without a YAML-writing dependency.
    save(output / f'{name}.yml', {'name': name, 'channels': sorted(channels), 'dependencies': dependencies})
    save(output / f'{name}-packages.json', sorted(observed, key=lambda p: p['name']))
    save(output / f'{name}-manual.json', sorted(manual, key=lambda p: p['name']))
    return {'name': name, 'packages': len(records), 'manual_sources': len(manual)}


def extensions(folder):
    found = {}
    active = folder / 'extensions.json'
    if active.is_file():
        # VS Code's active-extension registry excludes stale version directories.
        for item in json.loads(active.read_text(encoding='utf-8-sig')):
            identifier = item.get('identifier', {}).get('id')
            version = item.get('version')
            if identifier and version:
                found[identifier.lower()] = version
    else:
        for manifest in folder.glob('*/package.json'):
            data = json.loads(manifest.read_text(encoding='utf-8-sig'))
            if data.get('publisher') and data.get('name') and data.get('version'):
                found[f"{data['publisher']}.{data['name']}".lower()] = data['version']
    return [{'id': ident, 'version': version} for ident, version in sorted(found.items())]


def windows(output):
    import winreg
    apps = []
    for hive, scope in ((winreg.HKEY_LOCAL_MACHINE, 'machine'), (winreg.HKEY_CURRENT_USER, 'user')):
        for view, architecture in ((winreg.KEY_WOW64_64KEY, 'x64'), (winreg.KEY_WOW64_32KEY, 'x86')):
            try:
                root = winreg.OpenKey(hive, r'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall', 0, winreg.KEY_READ | view)
            except OSError:
                continue
            with root:
                for index in range(winreg.QueryInfoKey(root)[0]):
                    try:
                        with winreg.OpenKey(root, winreg.EnumKey(root, index)) as app:
                            def value(name):
                                try:
                                    return str(winreg.QueryValueEx(app, name)[0])
                                except OSError:
                                    return ''
                            if value('DisplayName'):
                                apps.append({'name': value('DisplayName'), 'version': value('DisplayVersion'),
                                             'publisher': value('Publisher'), 'scope': scope, 'architecture': architecture})
                    except OSError:
                        continue
    unique = {json.dumps(app, sort_keys=True): app for app in apps}
    save(output / 'installed-desktop-apps.json', sorted(unique.values(), key=lambda a: (a['name'], a['architecture'])))
    command(['winget', 'export', '--output', output / 'winget-source.json', '--include-versions',
             '--source', 'winget', '--accept-source-agreements', '--disable-interactivity'])
    source = json.loads((output / 'winget-source.json').read_text(encoding='utf-8-sig'))
    source.pop('CreationDate', None)
    for entry in source['Sources']:
        entry['Packages'].sort(key=lambda p: p['PackageIdentifier'])
    save(output / 'winget-source.json', source)
    ps = shutil.which('pwsh') or shutil.which('powershell')
    appx = json.loads(command([ps, '-NoProfile', '-Command',
        'Get-AppxPackage | Select-Object Name,Version,PackageFamilyName | ConvertTo-Json -Depth 4']))
    save(output / 'installed-store-apps.json', sorted(appx, key=lambda p: p['Name']))
    save(output / 'vscode-extensions.json', extensions(Path.home() / '.vscode/extensions'))
    conda = Path.home() / 'miniconda3/Scripts/conda.exe'
    if not conda.is_file():
        conda = Path.home() / 'anaconda3/Scripts/conda.exe'
    envs = []
    if conda.is_file():
        for index, prefix in enumerate(json.loads(command([conda, 'env', 'list', '--json']))['envs']):
            name = 'base' if Path(prefix) == conda.parent.parent else Path(prefix).name
            envs.append(environment(Path(prefix), conda, output / 'conda', name))
    venvs = []
    for config in sorted((Path.home() / '.virtualenvs').glob('*/pyvenv.cfg')):
        prefix = config.parent
        interpreter = prefix / 'Scripts/python.exe'
        if not interpreter.is_file():
            continue
        packages = json.loads(command([interpreter, '-m', 'pip', 'list', '--format=json']))
        version = command([interpreter, '-c', 'import platform; print(platform.python_version())'])
        save(output / 'venv' / f'{prefix.name}-packages.json', packages)
        venvs.append({'name': prefix.name, 'python': version, 'packages': len(packages)})
    save(output / 'venv/environments.json', venvs)
    return {'desktop_records': len(unique), 'store_records': len(appx), 'conda': envs, 'venv': venvs}


def linux(output):
    manual = command(['apt-mark', 'showmanual']).splitlines()
    (output / 'apt-manual.txt').write_text('\n'.join(sorted(manual)) + '\n')
    installed = command(['dpkg-query', '-W', '-f=${binary:Package}\t${Version}\t${Architecture}\t${db:Status-Status}\n'])
    packages = []
    for line in installed.splitlines():
        parts = line.split('\t')
        if len(parts) == 4 and parts[3] == 'installed':
            packages.append(dict(zip(('name', 'version', 'architecture'), parts[:3])))
    save(output / 'apt-installed.json', sorted(packages, key=lambda p: p['name']))
    (output / 'apt-holds.txt').write_text(command(['apt-mark', 'showhold']) + '\n')
    os_info = dict(line.split('=', 1) for line in Path('/etc/os-release').read_text().splitlines() if '=' in line)
    save(output / 'distribution.json', {k: os_info[k].strip('"') for k in ('ID', 'VERSION_ID', 'VERSION_CODENAME')})
    save(output / 'vscode-extensions.json', extensions(Path.home() / '.vscode-server/extensions'))
    conda = next((p for p in (Path.home() / 'miniforge3/bin/conda', Path.home() / 'miniconda3/bin/conda') if p.is_file()), None)
    envs = []
    if conda:
        for prefix in json.loads(command([conda, 'env', 'list', '--json']))['envs']:
            name = 'base' if Path(prefix) == conda.parent.parent else Path(prefix).name
            envs.append(environment(Path(prefix), conda, output / 'conda', name))
    r = shutil.which('Rscript')
    if r:
        script = 'x<-installed.packages(); write.table(x[,c("Package","Version","Priority")],row.names=FALSE,quote=FALSE,sep="\\t",na="NA")'
        (output / 'r-packages.tsv').write_text(command([r, '--vanilla', '-e', script]) + '\n')
    return {'apt_manual': len(manual), 'apt_installed': len(packages), 'conda': envs}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--platform', choices=['windows', 'wsl'], required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    counts = windows(args.output) if args.platform == 'windows' else linux(args.output)
    save(args.output / 'capture.json', {'captured_at': datetime.now(timezone.utc).isoformat(),
         'platform': args.platform, 'counts': counts,
         'coverage': 'Current user and standard Conda installations; review manual sources and other project-local environments separately.'})
    print(json.dumps(counts))


if __name__ == '__main__':
    main()
