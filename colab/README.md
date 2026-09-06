# Validate a live Colab runtime

Open [the validation notebook in Colab](https://colab.research.google.com/github/philipjones77/dotrepo/blob/main/colab/validate.ipynb). Select a standard CPU runtime and run the cells in order. Sign in to Google and authorize Drive mounting when prompted.

The notebook checks out dotrepo in `/content/dotrepo`, mounts Google Drive, captures package versions, tests a temporary local file and a small NumPy calculation, and runs `pip check`. It writes `/content/dotrepo-colab-validation.json`, including the repository revision and explicit pass/fail checks. The last cell downloads the report for comparison.

This validates basic runtime/Drive readiness; it does not test full project workloads or GPU computation. Colab's preinstalled packages can have dependency conflicts, which are reported rather than silently changed. No personal Drive files are modified and no packages are upgraded by this notebook.

Local notebook syntax tests and GitHub Actions are not proof that a live Colab runtime passed. Only the report produced inside Colab establishes that result.
