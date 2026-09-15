With[{scratch = FileNameJoin[{$HomeDirectory, ".local", "state", "dotrepo", "repo-oracles-20260914", "ifj"}]}, If[!DirectoryQ[scratch], CreateDirectory[scratch, CreateIntermediateDirectories -> True]]; SetDirectory[scratch]];
Get[FileNameJoin[{$HomeDirectory, ".local", "opt", "repo-oracles", "MBConicHulls", "MultivariateResidues.m"}]];
Get[FileNameJoin[{$HomeDirectory, ".local", "opt", "repo-oracles", "MBConicHulls-ifj.wl"}]];
rep = MBRep[1, {s,t}, {x,y}, {{-s,-t,1+s,2+t}, {}}];
If[!ListQ[rep], Print["FAILED: MBRep did not produce a list"]; CloseKernels[]; Exit[4]];
tri = TriangulateMB[rep, MaxSolutions->1, MasterSeries->False, PrintSolutions->False, QuickSolve->True, RunInParallel->False, TopComParallel->False];
If[!ListQ[tri], Print["FAILED: TriangulateMB did not produce a list"]; CloseKernels[]; Exit[5]];
Print["IFJ_ORACLE_JSON=" <> ExportString[<|"status"->"pass","operation"->"MBRep and TOPCOM TriangulateMB","representation_length"->Length[rep],"triangulation_length"->Length[tri],"auxiliary_kernels"->$KernelCount|>, "RawJSON"]];
CloseKernels[];