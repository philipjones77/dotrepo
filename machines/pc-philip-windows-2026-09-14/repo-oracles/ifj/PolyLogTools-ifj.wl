(* External setup; upstream package files remain unchanged. *)
With[{root = DirectoryName[$InputFileName]},
  Global`$HPLPath = FileNameJoin[{root, "HPL-2.0"}];
  Global`$PolyLogPath = FileNameJoin[{root, "PolyLogTools"}];
  $Path = DeleteDuplicates[Join[$Path, {Global`$HPLPath, Global`$PolyLogPath}]];
  Needs["HPL`"];
  Get[FileNameJoin[{Global`$PolyLogPath, "PolyLogTools.m"}]];
];
