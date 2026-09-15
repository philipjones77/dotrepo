"""Run tiny IFJ accuracy-ladder adapter checks; select repository and backend."""
import argparse, importlib.util, json, math, pathlib, sys
parser=argparse.ArgumentParser()
parser.add_argument("repo",type=pathlib.Path)
parser.add_argument("backend",choices=["mpmath","flint","arbplusjax","scirs2","meijergjl"])
args=parser.parse_args()
p=args.repo/"experiments/foxh_accuracy_ladder/run_foxh_accuracy_ladder.py"
spec=importlib.util.spec_from_file_location("ifj_accuracy_audit",p)
m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
cases=[m._exp_case((.3,)),m._rational_power_case(2.2,(.3,)),m._meijerg_besselk_case(.5,(.3,))]
rows=[]
for case in cases:
 if args.backend=="scirs2" and case.name!="rational_power":
  rows.append({"case":case.name,"status":"unsupported","reason":"Current IFJ SciRS2 adapter only supports gamma-based rational-power for these standard rungs; no scalar exp/Fox-H or general-order kv binding."});continue
 try:
  if args.backend=="mpmath":v=m._mpmath_reference(case,.3,dps=50)
  elif args.backend=="flint":v=m._flint_reference(case,.3,dps=50)
  elif args.backend=="arbplusjax":v=m._arbplusjax_reference(case,.3)
  elif args.backend=="scirs2":v=m._scirs2_reference(case,.3)
  else:v=m._meijergjl_reference(case,.3,precision=192,timeout=240)
  expected=case.reference(.3)
  error=abs(v-expected)
  assert math.isfinite(v.real) and math.isfinite(v.imag)
  assert error<=1e-10*max(1,abs(expected)), (v,expected,error)
  rows.append({"case":case.name,"status":"pass","value":[v.real,v.imag],"absolute_error":error})
 except Exception as exc:rows.append({"case":case.name,"status":"failed","exception":type(exc).__name__,"detail":str(exc)})
print(json.dumps({"backend":args.backend,"z":.3,"scope":"three scalar reference-adapter calls; no model, contour or benchmark workloads","checks":rows},indent=2))
sys.exit(any(r["status"]=="failed" for r in rows))
