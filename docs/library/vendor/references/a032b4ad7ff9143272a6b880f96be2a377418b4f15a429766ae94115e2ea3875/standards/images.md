# Image And Figure Standards

The detailed operator workflow lives in `images/README.md` and `src/automation/images/README.md`.
This standard defines the reusable storage, classification, provenance, and deduplication rules.

## Authority And Storage

- `images/library/<topic>.bib` is the source of truth for curated image metadata.
- New or uncertain files start in `images/inbox/`.
- Generated reports and contact sheets belong in `images/status/`.
- Binary assets live in the configured external image store as `<topic>/<assettype>/<filename>`.
- A metadata record must have a portable `imageid` using that relative layout. `usera` may
  additionally record the current machine's absolute attachment path, but it is not the portable
  identity.

## Two-Facet Classification

Classify every image independently by subject and by visual form:

- `topic`: the subject collection, normally inherited from the source paper's bibliography library;
  examples include `random_fields`, `statistics`, `probability`, `mathematics`, `computational`, and
  `biostatistics`.
- `assettype`: the visual form. Canonical values are `diagram`, `equation`, `geometry_mesh`,
  `graph_network`, `icon_logo`, `map_geospatial`, `matrix_visualization`, `photograph`, `plot`,
  `screenshot`, `table`, `workflow`, `page_render`, and `unclassified_figure`.

An explicit topic hint may override inference. An unclassified visual remains usable for review but
must use `reviewstatus = {needs_review}`.

## Metadata Fields

Every new `@image` record must include:

- `title`
- `usera` with the local `image=` attachment
- `imageid`
- `imageformat`
- `imagesize`
- `checksum` using SHA-256
- `topic`
- `assettype`
- `reviewstatus`
- `rightsstatus`; unknown permissions stay `unverified`

Include width and height when the format exposes them. For figures extracted from a paper, also
retain as many of these as are known:

- `sourcekey`: canonical bibliography key
- `sourcetitle`
- `sourceauthor`: authors of the source work; use `author` only for a known image creator
- `sourcepdf`
- `sourcepage`: one-based PDF page
- `sourcefigure`: printed figure or plate label
- `sourceimage`: internal image index reported by the PDF extractor
- `sourcecaption`
- `alttext`
- `sourcepdfchecksum`, `sourcebbox`, `extractionmethod`, and `extractionid` for extracted assets
- `captionstatus` to distinguish inferred candidates from supplied descriptions
- `credit`, verified `license`, and `rightsstatus` (default `unverified`)

Do not confuse `sourcefigure` with the PDF's internal image index.

## Processing And Review

Use the maintained PDF workflow rather than ad hoc extraction:

```powershell
powershell -ExecutionPolicy Bypass -File src/automation/images/run_process_pdf_images.ps1 path\to\paper.pdf -Apply
```

The workflow must restrict routing to images in the current run manifest, deduplicate by SHA-256,
retain provenance, and create a contact sheet. Review the contact sheet and all `needs_review`
records before treating the results as curated.

Use explicit region plans for vector crops; full-page renders must use `page_render` and must not be
presented as automatically segmented figures. Embedded extraction alone omits vector figures. See
the [operator guide](../../images/README.md) for extraction, review, catalog validation, and
normalization commands. All automatically created records require review, even when a classifier
assigns a visual type. Credit and licence evidence are independent of that classification.

## Deduplication

- Use SHA-256 as the exact-duplicate test.
- Do not create a second binary when the same checksum already exists.
- Multiple source/provenance records may refer to one binary when genuinely useful, but each record
  must retain its own source metadata.
- Similar-looking but byte-distinct images require review; do not delete them based on filenames
  alone.
