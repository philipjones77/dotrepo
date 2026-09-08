# Image Metadata Library

Curated image metadata is grouped by topic in BibLaTeX files:

- `matrices.bib`
- `foxh.bib`
- `jax.bib`
- `hierarchical.bib`
- `topology.bib`

The binary image files are not stored here. Processed files live under:

`C:\Users\phili\OneDrive - University of Arizona\Documents\images`

Each `@image` record has a portable `imageid` (`topic/type/filename`) and a current-machine
`usera = {image=...}` attachment. Source papers are referenced by canonical `sourcekey`, with
author/title/URL, page, PDF checksum, extraction details, and credit/licence information where
known. Keep image metadata separate from citation databases; these custom `@image` records are
not automatically a journal-compatible BibLaTeX bibliography.

Use the [image workflow](../README.md) for extraction, review, normalization, and catalog export.
The supported asset ZIP includes this metadata namespace, but never the external image binaries.
