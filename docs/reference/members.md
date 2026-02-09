# Names of members of the US Congress

A dataset of the names of all members of each United States Congress,
including presidents. The `pattern` column serves as a lookup table to
match members of Congress to text supplied to
[`extractMemberName()`](extractMemberName.md).

## Usage

``` r
members
```

## Format

A data frame with 51053 rows and 10 variables:

- `congress`:

  double The Congress

- `chamber`:

  character House or Senate

- `bioname`:

  character voteview.com name formatted LAST, First

- `pattern`:

  character Regular expression pattern for matching

- `icpsr`:

  double ICPSR ID

- `state`:

  double State code from voteview.com

`state_abbrev`character State `district_code`double District
`bioguide_id`character congress.gov Bioguid ID `first_name`character
First Name `last_name`character Last Name

## Details

DETAILS
