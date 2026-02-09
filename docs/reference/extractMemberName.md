# Extract congress member names from text

`extractMemberName()` uses a regular expressions lookup to extract names
of congress members from supplied text.

## Usage

``` r
extractMemberName(
  data,
  col_name,
  members = legislators::members,
  typos = legislators::typos,
  congress,
  chamber = NULL,
  state = NULL,
  fix_ocr = TRUE,
  verbose = TRUE,
  cl = NULL
)
```

## Arguments

- data:

  a data frame with a variable (specified in `col_name`) containing the
  text from which members of congress are to be extracted. Can also be a
  character vector containing the text, which will be converted to a
  data frame.

- col_name:

  `character`; when `data` is a data frame, the name of the variable
  containing congress members' names. When `data` is a character vector,
  the name given to the variable containing the original text in the
  output (if unspecified, `"speaker"` will be used).

- members:

  a regex table containing variations of congress member names. By
  default, the [members](members.md) dataset accompanying the package is
  used. This table must have the following columns:

- typos:

  a dataset from which to extract typos. By default, the
  [typos](typos.md) dataset accompanying the package is used. This table
  must have the following columns:

- congress:

  the name of a variable in `data` containing the congress for each row,
  or a vector of congress numbers for each row. If a single value is
  supplied, it will be applied to all rows. The argument is required.

- chamber:

  the name of a variable in `data` containing the chamber for each row,
  or a character vector containing the chamber for each row. If a single
  value is supplied, it will be applied to all rows. Allowable values
  include the values in `members`, which, by default, are `"Senate"`,
  `"House"`, and `"President"`. `NA` values are allowed and will not be
  incorporated into the match. This argument is optional. See Details.

- state:

  the name of a variable in `data` containing the state for each row, or
  a character vector containing the state for each row. If a single
  value is supplied, it will be applied to all rows. Allowable values
  include the two-letter abbreviations for each state (e.g., `"MA"`) as
  well as `"USA"` for rows corresponding to presidents, or the full
  names of the states (e.g., `"Massachusetts"`). `NA` values are allowed
  and will not be incorporated into the match. This argument is
  optional. See Details.

- fix_ocr:

  `logical`; whether to fix OCR errors. Passed to
  [`fix_typos()`](fix_typos.md).

- verbose:

  `logical`; whether to display information about the process of
  extracting names, including progress bars.

- cl:

  a cluster object created by
  [`parallel::makeCluster()`](https://rdrr.io/r/parallel/makeCluster.html),
  or an integer to indicate number of child-processes (integer values
  are ignored on Windows) for parallel evaluations. Passed to
  [`pbapply::pblapply()`](https://peter.solymos.org/pbapply/reference/pbapply.html).

## Value

A tibble (data frame) with a row for each match containing the following
variables:

- data_id:

  the row number in `data` corresponding to the given match

- icpsr:

  the ICPSR ID associated with the matched member

- bioname:

  the ICSPR-assigned name of the matched member

- speaker:

  the original value used to find matches after processing

- congress:

  the congress associated with the matched member

- chamber:

  the chamber associated with the matched member

- state_abbrev:

  the state (abbreviated) associated with the matched member

- district_code:

  the district code associated with the matched member

In addition, all other variable in `data`, including that named in
`col_name`, will be included in the output.

## Details

`extractMemberName()` processes the variable named in `col_name`
containing the text from which congress members' names are to be
extracted. First, it passes the variable to
[`fix_typos()`](fix_typos.md) to apply some heuristic processing, and,
if `typos` is supplied, it fixes any found typos. Finally, it performs a
regular expressions lookup to match congress members listed in `members`
to the text. For each member in `members`, a regular expression match is
performed to determine whether the text in the given row contains that
member. This is done one congress at a time.

When `chamber` or `state` are specified, the lookup for each member is
restricted to the chamber or state of the member in `members`,
respectively, which can increase speed and avoid duplicates (e.g.,
members of a given congress who appear in more than one chamber). These
arguments are optional; when not supplied, only the variable named in
`col_name` and congress are used to identify members. It is possible for
a single row in `data` to contain multiple members belonging to
different states or chambers. In these cases, `chambers` or `state` can
be set to `NA` for those rows to avoid using them in their lookup.
