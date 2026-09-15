# Optional oracle locations. Sourcing starts no process and preserves explicit choices.
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) PATH="$HOME/.local/bin:$PATH" ;; esac
export PATH
export JULIA_PROJECT="${JULIA_PROJECT:-@repo-oracles}"
export JULIA_NUM_THREADS="${JULIA_NUM_THREADS:-1}"
export JULIA_NUM_PRECOMPILE_TASKS="${JULIA_NUM_PRECOMPILE_TASKS:-1}"
export JULIA_PKG_PRECOMPILE_AUTO="${JULIA_PKG_PRECOMPILE_AUTO:-0}"
export IFJ_MBCONICHULLS_WL="${IFJ_MBCONICHULLS_WL:-$HOME/.local/opt/repo-oracles/MBConicHulls-ifj.wl}"
export IFJ_MULTIVARIATE_RESIDUES_M="${IFJ_MULTIVARIATE_RESIDUES_M:-$HOME/.local/opt/repo-oracles/MBConicHulls/MultivariateResidues.m}"
export IFJ_POLYLOGTOOLS_WL="${IFJ_POLYLOGTOOLS_WL:-$HOME/.local/opt/repo-oracles/PolyLogTools-ifj.wl}"
if [ -z "${WOLFRAMSCRIPT_KERNELPATH:-}" ] && [ -z "${WolframKernel:-}" ]; then
    for ifj_oracle_kernel in "$HOME"/Wolfram/*/Executables/WolframKernel /usr/local/Wolfram/Wolfram/*/Executables/WolframKernel /usr/local/Wolfram/Mathematica/*/Executables/WolframKernel /opt/Wolfram/*/Executables/WolframKernel; do
        if [ -x "$ifj_oracle_kernel" ]; then
            export WOLFRAMSCRIPT_KERNELPATH="$ifj_oracle_kernel"
            export WolframKernel="$ifj_oracle_kernel"
            break
        fi
    done
    unset ifj_oracle_kernel
fi
