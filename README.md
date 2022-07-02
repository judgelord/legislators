
<!-- README.md is generated from README.Rmd. Please edit that file -->

# legislators <img src="man/figures/logo.png" width="50" />

### A package to detect U.S. legislator names in messy text with typos and inconsistent name formats

Install this package with

    devtools::install_github("judgelord/legislators")

``` r
library(legislators)
```

## Data

This package relies on a dataframe (`members`) of permutations of the
names of members of Congress. This dataframe builds on the basic
structure of voteview.com data, especially the `bioname` field. From
this and other corrections, it constructs a regular expression search
`pattern` and conditions under which this pattern should yield a match
(e.g. when that pattern has a unique match to a member of Congress in a
given Congress). `pattern` differs from Congress to Congress because
some member move from the House to the Senate and because members with
similar names join or leave Congress. Users can customize the provided
`members` data and supply their updted version to
`extractMemberNames()`.

``` r
data("members")

members[c("chamber", "congress", "bioname", "pattern")] 
```

    #> # A tibble: 6,566 × 4
    #>    chamber   congress bioname                        pattern                                                                                                                                            
    #>    <chr>        <int> <chr>                          <chr>                                                                                                                                              
    #>  1 President      108 BUSH, George Walker            "george bush|george walker bush|\\bg bush|george w bush|\\bna bush|(^|senator |representative )bush\\b|bush, george|bush george|bush, g\\b|preside…
    #>  2 House          108 DEAL, John Nathan              "john deal|john nathan deal|\\bj deal|john n deal|nathan deal|nathan nathan deal|nathan n deal|\\bn deal|(^|senator |representative )deal\\b|deal,…
    #>  3 Senate         108 CAMPBELL, Ben Nighthorse       "ben campbell|ben nighthorse campbell|\\bb campbell|ben n campbell|benjamin campbell|benjamin nighthorse campbell|benjamin n campbell|(^|senator |…
    #>  4 House          108 HALL, Ralph Moody              "ralph hall|ralph moody hall|\\br hall|ralph m hall|\\bna hall|(^|senator |representative )hall\\b|hall, ralph|hall ralph|hall, r\\b|representativ…
    #>  5 House          108 TAUZIN, Wilbert Joseph (Billy) "wilbert tauzin|wilbert joseph tauzin|\\bw tauzin|wilbert j tauzin|billy tauzin|billy joseph tauzin|billy j tauzin|\\bb tauzin|(^|senator |represe…
    #>  6 Senate         108 SHELBY, Richard C.             "richard shelby|richard c shelby|\\br shelby|rich shelby|rich c shelby|(^|senator |representative )shelby\\b|shelby, rich|shelby, richard|shelby r…
    #>  7 Senate         108 JEFFORDS, James Merrill        "james jeffords|james merrill jeffords|\\bj jeffords|james m jeffords|jim jeffords|jim merrill jeffords|jim m jeffords|(^|senator |representative …
    #>  8 House          108 GOODE, Virgil H., Jr.          "virgil goode|virgil h goode|\\bv goode|\\bna goode|(^|senator |representative )goode\\b|goode, virgil|goode virgil|goode, v\\b|representative goo…
    #>  9 Senate         108 CHAFEE, Lincoln Davenport      "lincoln chafee|lincoln davenport chafee|\\bl chafee|lincoln d chafee|\\bna chafee|(^|senator |representative )chafee\\b|chafee, lincoln|chafee li…
    #> 10 Senate         108 MILLER, Zell Bryan             "zell miller|zell bryan miller|\\bz miller|zell b miller|(^|senator |representative )miller\\b.{1,4}ga|miller, zell|miller zell|miller, z\\b|senat…
    #> # … with 6,556 more rows

Before searching the text, several functions clean it and “fix” common
human typos and OCR errors that frustrate matching. Some of these
corrections are currently supplied by `MemberNameTypos.R`. In future
versions, `typos` will be supplied as a dataframe instead, and all types
of corrections (cleaning, typos, OCR erros) will be optional.
Additionally, users will be able to customize the `typos` dataframe and
provide it as an argument to `extractMemberNames()`.

``` r
data("typos")

typos
```

    #> # A tibble: 480 × 2
    #>    typos                                                                                                  correct             
    #>    <chr>                                                                                                  <chr>               
    #>  1 ( 0 | 0, )                                                                                             " o "               
    #>  2 aaron( | [a-z]* )s chock($| |,|;)|s chock, aaron                                                       "aaron schock"      
    #>  3 adam( | [a-z]* )(schif|sdxiff)($| |,|;)|(schif|sdxiff), adam                                           "adam schiff"       
    #>  4 adrian( | [a-z]* )espaillat|espaillat, adrian|adriano( | [a-z]* )espaillet($| |,|;)|espaillet, adriano "adriano espaillat" 
    #>  5 al( | [a-z]* )fianken($| |,|;)|fianken, al                                                             "al franken"        
    #>  6 (alccc|ateee)( | [a-z]* )hastings|hastings, (alccc|ateee)                                              "alcee hastings"    
    #>  7 allyson( | [a-z]* )schwaltz($| |,|;)|schwaltz, allyson                                                 "allyson schwartz"  
    #>  8 allyson d schwartz|schwartz, allyson d                                                                 "allyson y schwartz"
    #>  9 ami( | [a-z]* )(beta|gera)($| |,|;)|(beta|gera), ami                                                   "ami bera"          
    #> 10 amy( | [a-z]* )klobachur|klobachar($| |,|;)|klobachur|klobachar, amy                                   "amy klobuchar"     
    #> # … with 470 more rows

## Basic Usage

The main function is `extractMemberName()` returns a dataframe of the
names and ICPSR ID numbers of members of Congress in a supplied vector
of text.

-   in the future, `extractMemberName()` may default to returning a list
    of dataframes the same length of the supplied data

For example, we can use `extractMemberName()` to detect the names of
members of Congress in the text of the Congressional Record. Let’s start
with text of the Congressional Record from 3/1/2007, scraped and parsed
using methods described [here](https://github.com/judgelord/cr).

``` r
data("cr2007_03_01")

cr2007_03_01
```

    #> # A tibble: 154 × 5
    #>    date       speaker                             header                                                            url                                          url_txt                                
    #>    <date>     <chr>                               <chr>                                                             <chr>                                        <chr>                                  
    #>  1 2007-03-01 HON. SAM GRAVES;Mr. GRAVES          RECOGNIZING JARRETT MUCK FOR ACHIEVING THE RANK OF EAGLE SCOUT; … https://www.congress.gov/congressional-reco… https://www.congress.gov/117/crec/2007…
    #>  2 2007-03-01 HON. MARK UDALL;Mr. UDALL           INTRODUCING A CONCURRENT RESOLUTION HONORING THE 50TH ANNIVERSAR… https://www.congress.gov/congressional-reco… https://www.congress.gov/117/crec/2007…
    #>  3 2007-03-01 HON. JAMES R. LANGEVIN;Mr. LANGEVIN BIOSURVEILLANCE ENHANCEMENT ACT OF 2007; Congressional Record Vo… https://www.congress.gov/congressional-reco… https://www.congress.gov/117/crec/2007…
    #>  4 2007-03-01 HON. JIM COSTA;Mr. COSTA            A TRIBUTE TO THE LIFE OF MRS. VERNA DUTY; Congressional Record V… https://www.congress.gov/congressional-reco… https://www.congress.gov/117/crec/2007…
    #>  5 2007-03-01 HON. SAM GRAVES;Mr. GRAVES          RECOGNIZING JARRETT MUCK FOR ACHIEVING THE RANK OF EAGLE SCOUT    https://www.congress.gov/congressional-reco… https://www.congress.gov/117/crec/2007…
    #>  6 2007-03-01 HON. SANFORD D. BISHOP;Mr. BISHOP   IN HONOR OF SYNOVUS BEING NAMED ONE OF THE BEST COMPANIES IN AME… https://www.congress.gov/congressional-reco… https://www.congress.gov/117/crec/2007…
    #>  7 2007-03-01 HON. EDOLPHUS TOWNS;Mr. TOWNS       NEW PUNJAB CHIEF MINISTER URGED TO WORK FOR SIKH SOVEREIGNTY; Co… https://www.congress.gov/congressional-reco… https://www.congress.gov/117/crec/2007…
    #>  8 2007-03-01 HON. TOM DAVIS;Mr. TOM DAVIS        HONORING THE 30TH ANNIVERSARY OF THE BAILEY'S CROSSROADS ROTARY … https://www.congress.gov/congressional-reco… https://www.congress.gov/117/crec/2007…
    #>  9 2007-03-01 HON. SAM GRAVES;Mr. GRAVES          RECOGNIZING BRIAN PATRICK WESSLING FOR ACHIEVING THE RANK OF EAG… https://www.congress.gov/congressional-reco… https://www.congress.gov/117/crec/2007…
    #> 10 2007-03-01 HON. MARK UDALL;Mr. UDALL           INTRODUCTION OF ROYALTY-IN-KIND FOR ENERGY ASSISTANCE LEGISLATIO… https://www.congress.gov/congressional-reco… https://www.congress.gov/117/crec/2007…
    #> # … with 144 more rows

``` r
head(cr2007_03_01$url)
```

    #> [1] "https://www.congress.gov/congressional-record/2007/03/01/extensions-of-remarks-section/article/E431-2"
    #> [2] "https://www.congress.gov/congressional-record/2007/03/01/extensions-of-remarks-section/article/E431-3"
    #> [3] "https://www.congress.gov/congressional-record/2007/03/01/extensions-of-remarks-section/article/E431-4"
    #> [4] "https://www.congress.gov/congressional-record/2007/03/01/extensions-of-remarks-section/article/E431-5"
    #> [5] "https://www.congress.gov/congressional-record/2007/03/01/extensions-of-remarks-section/article/E431-1"
    #> [6] "https://www.congress.gov/congressional-record/2007/03/01/extensions-of-remarks-section/article/E432-2"

``` r
head(cr2007_03_01$speaker)
```

    #> [1] "HON. SAM GRAVES;Mr. GRAVES"          "HON. MARK UDALL;Mr. UDALL"           "HON. JAMES R. LANGEVIN;Mr. LANGEVIN" "HON. JIM COSTA;Mr. COSTA"            "HON. SAM GRAVES;Mr. GRAVES"         
    #> [6] "HON. SANFORD D. BISHOP;Mr. BISHOP"

This is an extremely simple example because the text strings containing
the names of the members of Congress (`speaker`) are short and do not
contain much other text. However, `extractMemberName()` is also capable
of searching longer and much messier texts, including text where names
are not consistently formatted or where they contain common typos
introduced by humans or common OCR errors. Indeed, these functions were
developed to identify members of Congress in ugly text data like
[this](https://judgelord.github.io/corr/corr_pres.html#22).

To better match member names, this function currently requires either

-   a column “congress” (this can be created from a date) or
-   a vector of congresses to limit the search to (`congresses`)

### `extractMemberName()`

``` r
cr2007_03_01$congress <- 110

# extract legislator names and match to voteview ICPSR numbers
cr <- extractMemberName(data = cr2007_03_01, 
                        col_name = "speaker", # The text strings to search
                        congresses = 110, # This argument is not required in this case because the data contain a "congress" column
                        members = members # Member names augmented from voteview come with this package, but users can also supply a customised data frame
                        )
```

    #> Typos fixed in 5 seconds

    #> Searching  data for members of the 110th, n = 154 (123 distinct strings).

    #> Names matched in 7 seconds

    #> Joining, by = c("congress", "pattern", "first_name", "last_name")

``` r
cr
```

    #> # A tibble: 194 × 16
    #>    data_row_id match_id icpsr bioname                    string                           pattern        chamber congress date       speaker  header      url       url_txt   first_name last_name state
    #>    <chr>       <chr>    <dbl> <chr>                      <chr>                            <chr>          <chr>      <dbl> <date>     <chr>    <chr>       <chr>     <chr>     <chr>      <chr>     <chr>
    #>  1 000001      000001   20124 GRAVES, Samuel             hon sam graves;mr graves         "samuel grave… House        110 2007-03-01 HON. SA… RECOGNIZIN… https://… https://… Samuel     GRAVES    miss…
    #>  2 000002      000002   29906 UDALL, Mark                hon mark udall;mr udall          "mark udall|\… House        110 2007-03-01 HON. MA… INTRODUCIN… https://… https://… Mark       UDALL     colo…
    #>  3 000003      000003   20136 LANGEVIN, James            hon james r langevin;mr langevin "james langev… House        110 2007-03-01 HON. JA… BIOSURVEIL… https://… https://… James      LANGEVIN  rhod…
    #>  4 000004      000004   20501 COSTA, Jim                 hon jim costa;mr costa           "jim costa|\\… House        110 2007-03-01 HON. JI… A TRIBUTE … https://… https://… Jim        COSTA     cali…
    #>  5 000005      000005   20124 GRAVES, Samuel             hon sam graves;mr graves         "samuel grave… House        110 2007-03-01 HON. SA… RECOGNIZIN… https://… https://… Samuel     GRAVES    miss…
    #>  6 000006      000006   29339 BISHOP, Sanford Dixon, Jr. hon sanford d bishop;mr bishop   "sanford bish… House        110 2007-03-01 HON. SA… IN HONOR O… https://… https://… Sanford    BISHOP    geor…
    #>  7 000007      000007   15072 TOWNS, Edolphus            hon edolphus towns;mr towns      "edolphus tow… House        110 2007-03-01 HON. ED… NEW PUNJAB… https://… https://… Edolphus   TOWNS     new …
    #>  8 000008      000008   29576 DAVIS, Thomas M., III      hon tom davis;mr tom davis       "thomas davis… House        110 2007-03-01 HON. TO… HONORING T… https://… https://… Thomas     DAVIS     virg…
    #>  9 000009      000009   20124 GRAVES, Samuel             hon sam graves;mr graves         "samuel grave… House        110 2007-03-01 HON. SA… RECOGNIZIN… https://… https://… Samuel     GRAVES    miss…
    #> 10 000010      000010   29906 UDALL, Mark                hon mark udall;mr udall          "mark udall|\… House        110 2007-03-01 HON. MA… INTRODUCTI… https://… https://… Mark       UDALL     colo…
    #> # … with 184 more rows

In this example, all observations are in the 110th Congress, so we only
search for members who served in the 110th. Because each row’s `speaker`
text contains only one member in this case, `data_row_id` and `match_id`
are the same. Where multiple members are detected, there may be multiple
matches per `data_row_id`.

# TODO

### `augmentCongress()`

`augmentCongress()` will augments a dataframe that includes at least one
unique identifier to include a suite of other common identifiers.

Because `extractMemberName` links each detected name to ICPSR IDs from
voteview.com, we already have some information, like party
(`party_name`), state, district, and ideology scores (`nominate.dim1`)
for each legislator detected in the text.

``` r
library(dplyr)
```

    #> 
    #> Attaching package: 'dplyr'

    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag

    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union

``` r
full_join(cr, members) |> select(data_row_id, match_id, bioname, icpsr, congress, state, district_code, party_name, nominate.dim1, url)
```

    #> Joining, by = c("icpsr", "bioname", "pattern", "chamber", "congress", "first_name", "last_name", "state")

    #> # A tibble: 6,667 × 10
    #>    data_row_id match_id bioname                    icpsr congress state        district_code party_name       nominate.dim1 url                                                                         
    #>    <chr>       <chr>    <chr>                      <dbl>    <dbl> <chr>                <int> <chr>                    <dbl> <chr>                                                                       
    #>  1 000001      000001   GRAVES, Samuel             20124      110 missouri                 6 Republican Party         0.442 https://www.congress.gov/congressional-record/2007/03/01/extensions-of-rema…
    #>  2 000002      000002   UDALL, Mark                29906      110 colorado                 2 Democratic Party        -0.353 https://www.congress.gov/congressional-record/2007/03/01/extensions-of-rema…
    #>  3 000003      000003   LANGEVIN, James            20136      110 rhode island             2 Democratic Party        -0.375 https://www.congress.gov/congressional-record/2007/03/01/extensions-of-rema…
    #>  4 000004      000004   COSTA, Jim                 20501      110 california              20 Democratic Party        -0.191 https://www.congress.gov/congressional-record/2007/03/01/extensions-of-rema…
    #>  5 000005      000005   GRAVES, Samuel             20124      110 missouri                 6 Republican Party         0.442 https://www.congress.gov/congressional-record/2007/03/01/extensions-of-rema…
    #>  6 000006      000006   BISHOP, Sanford Dixon, Jr. 29339      110 georgia                  2 Democratic Party        -0.282 https://www.congress.gov/congressional-record/2007/03/01/extensions-of-rema…
    #>  7 000007      000007   TOWNS, Edolphus            15072      110 new york                10 Democratic Party        -0.519 https://www.congress.gov/congressional-record/2007/03/01/extensions-of-rema…
    #>  8 000008      000008   DAVIS, Thomas M., III      29576      110 virginia                11 Republican Party         0.282 https://www.congress.gov/congressional-record/2007/03/01/extensions-of-rema…
    #>  9 000009      000009   GRAVES, Samuel             20124      110 missouri                 6 Republican Party         0.442 https://www.congress.gov/congressional-record/2007/03/01/extensions-of-rema…
    #> 10 000010      000010   UDALL, Mark                29906      110 colorado                 2 Democratic Party        -0.353 https://www.congress.gov/congressional-record/2007/03/01/extensions-of-rema…
    #> # … with 6,657 more rows

-   [ ] integrate with the
    [`congress`](https://github.com/ippsr/congress) and/or
    `congressData` packages. For example, we may want a function,
    `augmentCongress` to simply join in identifiers for other datasets
    on ICPSR numbers. Perhaps this is best left to `congress`.

<!-- -->

    # add other common unique identifiers
    cr_augmented <- augmentCongress(cr)
