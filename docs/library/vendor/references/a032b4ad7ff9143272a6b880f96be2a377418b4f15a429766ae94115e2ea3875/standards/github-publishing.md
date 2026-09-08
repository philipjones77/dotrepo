# GitHub Documentation and Publishing

This standard governs public-facing documentation, math rendering, and release evidence. It
supplements [documentation ownership](documentation.md), [Markdown](markdown.md), and
[validation](validation.md). Defining a workflow does not authorize publishing private materials or
enabling a public site.

## Source and Publication Boundaries

Maintain documentation in its canonical source location. The root README provides orientation and
links, not a copy of every standard. Publish reusable standards from `docs/standards/`; keep
workflows in guides and dated evidence in status reports. Generated pages must identify their source
revision. Do not fix generated HTML while leaving its source wrong.

Use relative repository links with correct filename case. For citations to a specific
software/source version, use a tag or commit permalink rather than a moving branch. Record licenses,
attribution, and redistribution rights. Never publish private PDFs, signed approval pages,
credentials, personal paths, or inbox contents just because they are present locally. Shared
references and software metadata do not grant redistribution rights to their attachments.

## Mathematics on GitHub

GitHub's Markdown renderer uses MathJax. Use `$...$` for ordinary inline mathematics and a fenced
`math` block for displays. For inline expressions conflicting with Markdown syntax, GitHub also
supports its dollar/backtick form. These are platform conventions, not changes to the `.tex` rule.
[GitHub mathematical expressions](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/writing-mathematical-expressions)

````markdown
For $x > 0$, the logarithm is defined.

```math
g(x) = \log x.
```
````

Use a fenced `tex` block when showing literal LaTeX source rather than requesting rendered math. Do
not paste `\documentclass`, `\usepackage`, or a whole document preamble into a math block. Avoid
depending on repository `.sty` files or cross-page macros: the renderer does not compile the
project. Use self-contained supported expressions and verify their rendered result. Do not assume
LaTeX labels, equation numbers, bibliography commands, or glossary first-use state work across
Markdown pages.

Do not rely on raw MathML/OpenMath embedded in a README being rendered or preserved. Show XML
examples in `xml` code fences and link semantic artifacts explicitly. A separately configured
website can use MathML; its renderer, sanitization, and accessibility need independent tests. The
GitHub repository viewer and GitHub Pages are different publishing targets.

## Review and Release Workflow

1. Edit canonical sources and record the reason for changes to policy or schemas.
1. Run `python tools/lint_repo.py` in the configured development environment, local-link validation,
   relevant regression tests, and asset validation. Inspect actual math/table rendering as well.
1. Review the diff for accidental formatting of imported material, formula changes, broken anchors,
   private content, and duplicate documentation. The current local-link checker does not validate
   heading anchors, web links, or all Markdown link forms.
1. Build reproducible artifacts from the reviewed revision and retain manifests/checksums and logs.
   Distinguish source bundles, consumer assets, documentation previews, and final document
   deliverables.
1. Publish only through the agreed release process. Associate the artifact with a revision/tag and
   list known limitations. A passing CI badge does not establish scientific correctness or
   publication identity.

See `docs/guides/assets.md` in the source repository for the maintained asset release commands. The
existing workflow runs checks and uploads Actions artifacts; it is not a configured GitHub Pages
deployment or proof that artifacts were released publicly.

## Optional GitHub Pages Site

If a site is adopted, select one documented generator and pin its toolchain. Build a preview in CI,
test project-site base paths and links, and deploy reviewed static output with the official Pages
artifact/deployment workflow. Give deployment permissions only to the deployment job and use the
`github-pages` environment. Untrusted pull requests may be checked but must not receive deployment
credentials. Do not add custom scripts merely to render ordinary README math.
[GitHub Pages workflows](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages)

Pages enablement, site/theme selection, deployment credentials, and public release are not
implemented by this policy update. A site must also pass its own dependency, accessibility, and
rendering checks.

## Research and Thesis Methodology

The following is a provisional documentation contract, not an assertion about an unidentified
thesis:

- State the research question, scope, assumptions, and limitations before implementation details.
- Link every definition, symbol, method, and external result to its canonical record or supporting
  source.
- Separate mathematical specification, algorithm, software implementation, and experimental
  protocol.
- Record datasets and preprocessing, software versions, configurations, seeds, hardware, tolerances,
  metrics, and commands needed to reproduce reported results.
- Connect claims and figures to actual outputs and validation evidence. Distinguish exploratory
  runs, confirmed results, negative results, and unresolved work.
- Keep PDF and web presentations traceable to the same source revision; document conversion losses,
  especially citations, notation, equation numbering, and accessibility.
- Record project-specific institutional/publisher overrides and review them against current
  requirements.

The local UA template is historical formatting material, not evidence of the user's research
methodology. Its natbib setup and institution-specific comments must not override the modern house
standard by accident. Alignment with the intended thesis remains pending its path/link and an actual
review.
