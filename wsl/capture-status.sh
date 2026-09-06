#!/usr/bin/env bash
set -euo pipefail
out=${1:?Pass the snapshot output directory}
mkdir -p "$out"
cp /etc/os-release "$out/os-release"
cp /etc/wsl.conf "$out/wsl.conf"
dpkg-query -W -f='${binary:Package}\t${Version}\t${Architecture}\t${db:Status-Status}\n' > "$out/apt-packages.tsv"
apt-mark showmanual | sort > "$out/apt-manual.txt"
apt-mark showhold > "$out/apt-holds.txt"
tar -cf "$out/apt-configuration.tar" -C /etc/apt sources.list.d trusted.gpg.d \
    $(test ! -f /etc/apt/sources.list || echo sources.list) \
    $(test ! -d /etc/apt/keyrings || echo keyrings)
if [ -f /usr/share/keyrings/githubcli-archive-keyring.gpg ]; then
    cp /usr/share/keyrings/githubcli-archive-keyring.gpg "$out/"
fi
{
    date --iso-8601=seconds
    uname -a
    id
    uptime
    free -h
    df -h /
    systemctl --failed --no-pager
    ps -eo pid,comm,rss --sort=-rss | head -25 || true
} > "$out/linux-status.txt" 2>&1
systemctl list-unit-files --state=enabled --no-pager > "$out/enabled-services.txt"
journalctl -k -b --no-pager > "$out/kernel-current.txt" 2>&1 || true
journalctl -k -b -1 --no-pager > "$out/kernel-previous.txt" 2>&1 || true
if command -v snap >/dev/null; then timeout 30 snap list > "$out/snaps.txt" 2>&1 || true; fi
if command -v npm >/dev/null; then npm list -g --depth=0 --json > "$out/npm-globals.json" 2>&1 || true; fi
for conda in "$HOME/miniforge3/bin/conda" "$HOME/miniconda3/bin/conda"; do
    [ -x "$conda" ] || continue
    "$conda" env list --json > "$out/conda-environments.json"
    "$(dirname "$conda")/python" -c 'import json,sys; print("\n".join(json.load(open(sys.argv[1]))["envs"]))' "$out/conda-environments.json" |
    while IFS= read -r prefix; do
        [ -d "$prefix/conda-meta" ] || continue
        name=$(basename "$prefix")
        "$conda" env export -p "$prefix" > "$out/conda-$name.yml" 2> "$out/conda-$name-export-warnings.txt"
        "$conda" list -p "$prefix" --explicit > "$out/conda-$name-explicit.txt"
        "$prefix/bin/python" -m pip freeze --all > "$out/pip-$name.txt" 2>&1 || true
        "$prefix/bin/python" -m pip check > "$out/pip-check-$name.txt" 2>&1 || true
    done
    break
done
python3 "$(dirname "$0")/inventory-software.py" "$out"
if command -v Rscript >/dev/null; then
    Rscript --vanilla -e 'a <- installed.packages(); write.table(a[,c("Package","Version","LibPath","Built")], file=commandArgs(TRUE)[1], sep="\t", row.names=FALSE, quote=FALSE); sessionInfo()' "$out/r-packages.tsv" > "$out/r-session.txt" 2>&1
fi
printf 'Capture complete: %s\n' "$out"
