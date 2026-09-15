(* IFJ oracle setup: preserve upstream package files and select bounded local defaults. *)
With[{ifjOracleRoot = DirectoryName[$InputFileName]},
  If[$KernelCount === 0, Quiet[LaunchKernels[1]]];
  If[$KernelCount === 0,
    Print["IFJ MBConicHulls setup could not start one local auxiliary kernel."];
    Abort[]
  ];
  Get[FileNameJoin[{ifjOracleRoot, "MBConicHulls", "MBConicHulls.wl"}]];
  SetOptions[MBConicHulls`ResolveMB, MBConicHulls`RunInParallel -> False];
  SetOptions[MBConicHulls`TriangulateMB,
    MBConicHulls`TopComPath -> FileNameJoin[{ifjOracleRoot, "topcom-bin"}] <> "/",
    MBConicHulls`TopComParallel -> False,
    MBConicHulls`RunInParallel -> False
  ];
  SetOptions[MBConicHulls`EvaluateSeries, MBConicHulls`RunInParallel -> False];
  SetOptions[MBConicHulls`SumAllSeries, MBConicHulls`RunInParallel -> False];
];

(* Headless TOPCOM: adapt only temporary-file IO after loading unmodified source. *)
If[$FrontEnd === Null,
  DownValues[MBConicHulls`Private`FindTriangulations] =
    DownValues[MBConicHulls`Private`FindTriangulations] /. {
      HoldPattern[NotebookDirectory[]] :> (Directory[] <> "/"),
      HoldPattern[Export[file_, contents_, options___]] :> Export[file, contents, "Text"]
    };
];
