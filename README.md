
<!-- README.md is generated from README.Rmd. Please edit that file -->

## legislators: Find legislator names in messy text <img src="man/figures/logo.png" align="right" width="150"/> [![CRAN status](https://www.r-pkg.org/badges/version/legislators)](https://CRAN.R-project.org/package=legislators)

### Installation

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
(e.g., when that pattern has a unique match to a member of Congress in a
given Congress). `pattern` differs from Congress to Congress because
some member move from the House to the Senate and because members with
similar names join or leave Congress. Users can customize the provided
`members` data and supply their updated version to
`extractMemberName()`.

``` r
data("members")

members
```

    #> # A tibble: 49,938 × 9
    #>    congress chamber   bioname                      pattern                                                                                         icpsr state_abbrev district_code first_name last_name
    #>       <dbl> <chr>     <chr>                        <chr>                                                                                           <dbl> <chr>                <dbl> <chr>      <chr>    
    #>  1      117 President TRUMP, Donald John           "donald trump|donald john trump|\\bd trump|donald j trump|don trump|don john trump|don j trump… 99912 USA                      0 Donald     TRUMP    
    #>  2      117 President BIDEN, Joseph Robinette, Jr. "joseph biden|joseph robinette biden|\\bj biden|joseph r biden|joe biden|joe robinette biden|j… 99913 USA                      0 Joseph     BIDEN    
    #>  3      117 House     ROGERS, Mike Dennis          "mike rogers|mike dennis rogers|\\bm rogers|mike d rogers|michael rogers|michael dennis rogers… 20301 AL                       3 Mike       ROGERS   
    #>  4      117 House     SEWELL, Terri                "terri sewell|\\bt sewell|terri a sewell|\\bna sewell|(^|senator |representative )sewell\\b|se… 21102 AL                       7 Terri      SEWELL   
    #>  5      117 House     BROOKS, Mo                   "mo brooks|\\bm brooks|\\bna brooks|(^|senator |representative )brooks\\b|brooks, mo|brooks mo… 21193 AL                       5 Mo         BROOKS   
    #>  6      117 House     PALMER, Gary James           "gary palmer|gary james palmer|\\bg palmer|gary j palmer|\\bna palmer|(^|senator |representati… 21500 AL                       6 Gary       PALMER   
    #>  7      117 House     CARL, Jerry L.               "jerry carl|jerry l carl|\\bj carl|\\bna carl|(^|senator |representative )carl\\b.{1,4}al|carl… 22108 AL                       1 Jerry      CARL     
    #>  8      117 House     MOORE, Barry                 "barry moore|\\bb moore.{1,4}al|(^|senator |representative )moore\\b.{1,4}al|moore, barry|moor… 22140 AL                       2 Barry      MOORE    
    #>  9      117 House     ADERHOLT, Robert             "robert aderholt|\\br aderholt|robert b aderholt|bob aderholt|bob b aderholt|\\bb aderholt|(^|… 29701 AL                       4 Robert     ADERHOLT 
    #> 10      117 House     YOUNG, Donald Edwin          "donald young|donald edwin young|\\bd young|donald e young|don young|don edwin young|don e you… 14066 AK                       1 Donald     YOUNG    
    #> # … with 49,928 more rows

------------------------------------------------------------------------

Before searching the text, several functions clean it and “fix” common
human typos and OCR errors that frustrate matching. Some of these
corrections are currently supplied by `MemberNameTypos.R`. In future
versions, `typos` will be supplied as a dataframe instead, and all types
of corrections (cleaning, typos, OCR errors) will be optional.
Additionally, users can customize the `typos` dataframe and provide it
as an argument to `extractMemberName()`.

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

------------------------------------------------------------------------

# Find U.S. legislator names in messy text with typos and inconsistent name formats

## Basic Usage

The main function is `extractMemberName()` returns a dataframe of the
names and ICPSR ID numbers of members of Congress in a supplied vector
of text.

-   in the future, `extractMemberName()` may default to returning a list
    of dataframes the same length as the supplied data

For example, we can use `extractMemberName()` to detect the names of
members of Congress in the text of the Congressional Record. Let’s start
with text from the Congressional Record from 3/1/2007, scraped and
parsed using methods described [here](https://github.com/judgelord/cr).

``` r
data("cr2007_03_01")

cr2007_03_01
```

    #> # A tibble: 154 × 5
    #>    date       speaker                             header                                                                                                                                   url   url_txt
    #>    <date>     <chr>                               <chr>                                                                                                                                    <chr> <chr>  
    #>  1 2007-03-01 HON. SAM GRAVES;Mr. GRAVES          RECOGNIZING JARRETT MUCK FOR ACHIEVING THE RANK OF EAGLE SCOUT; Congressional Record Vol. 153, No. 35                                    http… https:…
    #>  2 2007-03-01 HON. MARK UDALL;Mr. UDALL           INTRODUCING A CONCURRENT RESOLUTION HONORING THE 50TH ANNIVERSARY OF THE INTERNATIONAL GEOPHYSICAL YEAR (IGY); Congressional Record Vol… http… https:…
    #>  3 2007-03-01 HON. JAMES R. LANGEVIN;Mr. LANGEVIN BIOSURVEILLANCE ENHANCEMENT ACT OF 2007; Congressional Record Vol. 153, No. 35                                                           http… https:…
    #>  4 2007-03-01 HON. JIM COSTA;Mr. COSTA            A TRIBUTE TO THE LIFE OF MRS. VERNA DUTY; Congressional Record Vol. 153, No. 35                                                          http… https:…
    #>  5 2007-03-01 HON. SAM GRAVES;Mr. GRAVES          RECOGNIZING JARRETT MUCK FOR ACHIEVING THE RANK OF EAGLE SCOUT                                                                           http… https:…
    #>  6 2007-03-01 HON. SANFORD D. BISHOP;Mr. BISHOP   IN HONOR OF SYNOVUS BEING NAMED ONE OF THE BEST COMPANIES IN AMERICA; Congressional Record Vol. 153, No. 35                              http… https:…
    #>  7 2007-03-01 HON. EDOLPHUS TOWNS;Mr. TOWNS       NEW PUNJAB CHIEF MINISTER URGED TO WORK FOR SIKH SOVEREIGNTY; Congressional Record Vol. 153, No. 35                                      http… https:…
    #>  8 2007-03-01 HON. TOM DAVIS;Mr. TOM DAVIS        HONORING THE 30TH ANNIVERSARY OF THE BAILEY'S CROSSROADS ROTARY CLUB; Congressional Record Vol. 153, No. 35                              http… https:…
    #>  9 2007-03-01 HON. SAM GRAVES;Mr. GRAVES          RECOGNIZING BRIAN PATRICK WESSLING FOR ACHIEVING THE RANK OF EAGLE SCOUT; Congressional Record Vol. 153, No. 35                          http… https:…
    #> 10 2007-03-01 HON. MARK UDALL;Mr. UDALL           INTRODUCTION OF ROYALTY-IN-KIND FOR ENERGY ASSISTANCE LEGISLATION; Congressional Record Vol. 153, No. 35                                 http… https:…
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

This is an extremely simple example because the text strings containing
the names of the members of Congress (`speaker`) are short and do not
contain much other text. However, `extractMemberName()` can also search
longer and much messier texts, including text where names are not
consistently formatted or where they contain common typos introduced by
humans or common OCR errors. Indeed, these functions were developed to
identify members of Congress in ugly text data like
[this](https://judgelord.github.io/corr/corr_pres.html#22).

To better match member names, this function currently requires either:

-   a column “congress” (this can be created from a date) or
-   a vector of congresses to limit the search to (`congresses`)

### `extractMemberName()`

``` r
cr2007_03_01$congress <- 110

# extract legislator names and match to voteview ICPSR numbers
cr <- extractMemberName(data = cr2007_03_01, 
                        col_name = "speaker", # The text strings to search
                        congresses = 110, # This argument is not required in this case because the data contain a "congress" column
                        members = members # Member names augmented from voteview come with this package, but users can also supply a customized data frame
                        )
```

    #> Typos fixed in 5 seconds

    #> Searching  data for members of the 110th, n = 154 (123 distinct strings).

    #> Names matched in 7 seconds

    #> Joining, by = c("congress", "pattern", "first_name", "last_name")

``` r
cr
```

    #> # A tibble: 193 × 17
    #>    data_row_id match_id icpsr bioname                    string                         pattern chamber congress date       speaker header url   url_txt first_name last_name state_abbrev district_code
    #>    <chr>       <chr>    <dbl> <chr>                      <chr>                          <chr>   <chr>      <dbl> <date>     <chr>   <chr>  <chr> <chr>   <chr>      <chr>     <chr>                <dbl>
    #>  1 000001      000001   20124 GRAVES, Samuel             hon sam graves;mr graves       "samue… House        110 2007-03-01 HON. S… RECOG… http… https:… Samuel     GRAVES    MO                       6
    #>  2 000002      000002   29906 UDALL, Mark                hon mark udall;mr udall        "mark … House        110 2007-03-01 HON. M… INTRO… http… https:… Mark       UDALL     CO                       2
    #>  3 000003      000003   20136 LANGEVIN, James            hon james r langevin;mr lange… "james… House        110 2007-03-01 HON. J… BIOSU… http… https:… James      LANGEVIN  RI                       2
    #>  4 000004      000004   20501 COSTA, Jim                 hon jim costa;mr costa         "jim c… House        110 2007-03-01 HON. J… A TRI… http… https:… Jim        COSTA     CA                      20
    #>  5 000005      000005   20124 GRAVES, Samuel             hon sam graves;mr graves       "samue… House        110 2007-03-01 HON. S… RECOG… http… https:… Samuel     GRAVES    MO                       6
    #>  6 000006      000006   29339 BISHOP, Sanford Dixon, Jr. hon sanford d bishop;mr bishop "sanfo… House        110 2007-03-01 HON. S… IN HO… http… https:… Sanford    BISHOP    GA                       2
    #>  7 000007      000007   15072 TOWNS, Edolphus            hon edolphus towns;mr towns    "edolp… House        110 2007-03-01 HON. E… NEW P… http… https:… Edolphus   TOWNS     NY                      10
    #>  8 000008      000008   29576 DAVIS, Thomas M., III      hon tom davis;mr tom davis     "thoma… House        110 2007-03-01 HON. T… HONOR… http… https:… Thomas     DAVIS     VA                      11
    #>  9 000009      000009   20124 GRAVES, Samuel             hon sam graves;mr graves       "samue… House        110 2007-03-01 HON. S… RECOG… http… https:… Samuel     GRAVES    MO                       6
    #> 10 000010      000010   29906 UDALL, Mark                hon mark udall;mr udall        "mark … House        110 2007-03-01 HON. M… INTRO… http… https:… Mark       UDALL     CO                       2
    #> # … with 183 more rows

In this example, all observations are in the 110th Congress, so we only
search for members who served in the 110th. Because each row’s `speaker`
text contains only one member in this case, `data_row_id` and `match_id`
are the same. Where multiple members are detected, there may be multiple
matches per `data_row_id`.

Because `extractMemberName` links each detected name to ICPSR IDs from
voteview.com, we already have some information, like state and district
for each legislator detected in the text (scroll to the right).

## TODO

### Dynamic data

-   [ ] make some kind of version-controlled spreadsheet where users can
    submit additional nicknames, maiden names, etc. to augment the
    voteview data. This is currently done in
    data/make_members/nameCongress.R, but it would not be easy for users
    to edit and then re-make the regex table.
-   [ ] make some sort of version-controlled spreadsheet where users can
    submit common typos they find. Currently, typos.R generates
    typos.rda, which is loaded with the package.

### Vignettes

-   [ ] Add a vignette using messy OCRed legislator letters to FERC from
    replication data for [“Legislator Advocacy on Behalf of Constituents
    and Corporate Donors”](https://judgelord.github.io/research/ferc/)
-   [ ] Add a vignette using [public comment
    data](https://github.com/judgelord/rulemaking) (sparse legislator
    names)

### Functions

-   [ ] `extractMemberName()` needs options to supply custom typos and
    additions to the main regex table
-   [ ] correcting OCR errors and typos should be optional in
    `extractMemberName()`
-   [ ] integrate with the
    [`congress`](https://github.com/ippsr/congress) and/or
    [`congressData`](https://github.com/IPPSR/congress) packages. For
    example, we may want a function (`augmentCongress` or
    `augment_legislators`?) to join in identifiers for other datasets on
    ICPSR numbers. Perhaps this is best left to users using the
    `congress` package.
-   [ ] Additionally, `committees.R` provides a crosswalk for Stewart
    ICPSR numbers

### Documentation

-   [ ] Document helper functions for `extractMemberName()`
-   [ ] Document additional functions that help prep text for best
    matching
-   [ ] Document example data (including FERC and public comment data
    for new vignettes)
