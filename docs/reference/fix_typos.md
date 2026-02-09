# Fix common typos

`fix_typos()` standardizes a character vector for use in
[`extractMemberName()`](extractMemberName.md) by applying some heuristic
processing, setting all text to lowercase and, optionally, removing
common typos if a list of such is supplied.

## Usage

``` r
fix_typos(x, typos = legislators::typos, fix_ocr = TRUE, verbose = TRUE)
```

## Arguments

- x:

  a character vector containing the names of congress members.

- typos:

  a matrix or data frame containing common typos and their corrections.
  Should be a 2-column matrix where the first column contains regular
  expressions corresponding to typos and the second column contain the
  values that should replace them. These are passed to the `pattern` and
  `replacement` arguments of
  [`stringr::str_replace_all()`](https://stringr.tidyverse.org/reference/str_replace.html).
  By default, the [typos](typos.md) dataset that accompanies the package
  is used. If `NULL`, no typos will be fixed.

- fix_ocr:

  `logical`; whether to fix OCR errors.

- verbose:

  `logical`; whether to display information about the process of fixing
  typos, including a progress bar.

## Value

A character vector with typos replaced by their corrections.

## Details

DETAILS \#Explain processing

## See also

[`extractMemberName()`](extractMemberName.md),
[`stringr::str_replace_all()`](https://stringr.tidyverse.org/reference/str_replace.html)
