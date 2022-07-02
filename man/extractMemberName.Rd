\name{extractMemberName}
\alias{extractMemberName}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Detect legislator names in messy text
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
extractMemberName(data, members = members, col_name, congresses = unique(data$congress))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{
%%     ~~Describe \code{data} here~~
}
  \item{members}{
%%     ~~Describe \code{members} here~~
}
  \item{col_name}{
%%     ~~Describe \code{col_name} here~~
}
  \item{congresses}{
%%     ~~Describe \code{congresses} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (data, members = members, col_name, congresses = unique(data$congress))
{
    data \%<>\% mutate(string = data[[col_name]])
    if ("chamber" \%in\% names(data)) {
        data \%<>\% mutate(string = ifelse(!is.na(chamber), paste(chamber,
            string) \%>\% str_replace("House", "Represenative") \%>\%
            str_replace("Senate", "Senator"), string))
        data \%<>\% select(-chamber)
    }
    if ("state" \%in\% names(data)) {
        data \%<>\% mutate(string = ifelse(!is.na(state), paste(string,
            "-", stateFromFull(state)), string))
        data \%<>\% select(-state)
    }
    t <- Sys.time()
    if (!"data_id" \%in\% names(data)) {
        data$data_id <- 1:nrow(data)
    }
    data$data_id \%<>\% str_squish() \%>\% as.numeric()
    data$ID <- 1:nrow(data)
    data \%<>\% mutate(data_id = coalesce(data_id, ID) \%>\% as.numeric())
    data$data_id \%<>\% formatC(width = 6, flag = "0", format = "fg")
    data$congress \%<>\% replace_na(0) \%>\% as.numeric() \%>\% replace_na(0) \%>\%
        as.numeric()
    data \%<>\% mutate(last_name = NA, first_name = NA, pattern = NA) \%>\%
        select(-first_name, -last_name, -pattern)
    data$string \%<>\% cleanFROMcolumn()
    data$string \%<>\% ocr.errors()
    data$string \%<>\% tolower() \%>\% str_replace("senator senator",
        "senator") \%>\% str_replace("represenative representative",
        "representative")
    data$string \%<>\% str_replace("na politano", "napolitano")
    data$string \%<>\% str_remove("^na ")
    data$string \%<>\% str_remove("^na ")
    data$string \%<>\% str_replace("han na\\b", "hanna")
    data$string \%<>\% str_remove_all("\\bna\\b")
    data$string \%<>\% str_squish()
    data$string \%<>\% str_replace(" ,", ", ")
    data$string \%<>\% str_squish()
    data$string \%<>\% replace_na("")
    for (i in 1:dim(typos)[1]) {
        r <- typos$correct[i]
        p <- typos$typos[i]
        data \%<>\% mutate(string = string \%>\% purrr::map_chr(str_replace,
            pattern = p, replacement = r \%>\% paste("")))
    }
    data$string \%<>\% str_replace(" ,", ", ") \%>\% str_squish()
    base::message(paste("Typos fixed in", round(Sys.time() -
        t), "seconds"))
    t <- Sys.time()
    data <- map_dfr(congresses, extractNamesPerCongress, data = data,
        members = members)
    base::message(paste("Names matched in", round(Sys.time() -
        t), "seconds"))
    data \%<>\% distinct()
    data$ID <- 1:nrow(data) \%>\% formatC(width = 6, flag = "0")
    data \%<>\% left_join(members \%>\% select(icpsr, pattern, bioname,
        first_name, last_name, congress, chamber, state) \%>\%
        distinct()) \%>\% distinct()
    data$icpsr \%<>\% as.numeric()
    data \%<>\% select(data_row_id = data_id, match_id = ID, icpsr,
        bioname, string, pattern, chamber, congress, everything())
    return(data)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
