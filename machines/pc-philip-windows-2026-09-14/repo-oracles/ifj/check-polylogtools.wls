Get[FileNameJoin[{$HomeDirectory, ".local", "opt", "repo-oracles", "PolyLogTools-ifj.wl"}]];
With[{scratch = FileNameJoin[{$HomeDirectory, ".local", "state", "dotrepo", "repo-oracles-20260914", "ifj"}]}, If[!DirectoryQ[scratch], CreateDirectory[scratch, CreateIntermediateDirectories -> True]]; SetDirectory[scratch]];
PolyLogTools`GiNaC$InterfacePath = Directory[] <> "/";
actual = PolyLogTools`Ginsh[PolyLog[2, x], {x -> 1/3}, PolyLogTools`PrecisionGoal -> 30, PolyLogTools`Debug -> True];
expected = N[PolyLog[2, 1/3], 30];
hpl = N[HPL`HPL[{2}, 1/3], 30];
err = Max[Abs[actual - expected], Abs[hpl - expected]];
If[!NumberQ[err] || !TrueQ[err < 10^-20], Print[{actual, hpl, expected, err}]; Exit[5]];
Print["IFJ_ORACLE_JSON=" <> ExportString[<|"status"->"pass", "operation"->"PolyLogTools Ginsh Li2 and HPL against Wolfram PolyLog", "value"->N[actual], "hpl_value"->N[hpl], "absolute_error"->N[err], "limitation"->"legacy LiNumericalValueFromGiNaC C++ emitter uses removed GiNaC lst constructors; Ginsh interface is used"|>, "RawJSON"]];
