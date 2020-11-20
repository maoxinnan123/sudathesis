%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\newcommand*\@iflatexlater{\@ifl@t@r\fmtversion}%
\@iflatexlater{2017/01/01}{}{%
    \ClassError{ucasthesis}{TeXLive/MikTex >= 2017 is required ...}{}%
}
\ProvidesClass{ucasthesis}[2014/10/01 v1.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\DeclareOption{oneside}{%
    \PassOptionsToClass{oneside}{ctexbook}%
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{twoside}{ctexbook}%
}
\newif\ifucas@print \ucas@printfalse
\DeclareOption{print}{%
    \PassOptionsToClass{twoside}{ctexbook}%
    \ucas@printtrue%
}
%-
%-> Language
%-
\newif\ifucas@plain \ucas@plainfalse
\DeclareOption{scheme=plain}{% enable plain writing style
    \PassOptionsToClass{scheme=plain}{ctexbook}%
    \ucas@plaintrue%
}
%-
%-> Draft version info
%-
\newif\ifucas@versioninfo \ucas@versioninfofalse
\DeclareOption{draftversion}{%
    \ucas@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexbook}%
\@ifclasslater{ctexbook}{2017/01/01}{}{%
    \ClassError{ucasthesis}{ctex >= 2017/01/01 is required ...}{}%
}
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{etoolbox}% a toolbox of programming facilities
\newcommand{\ucasifstreq}{\expandafter\ifstrequal\expandafter}% expansion control
\newcommand{\ucasifstrbk}{\expandafter\ifblank\expandafter}% expansion control
\RequirePackage{expl3}% LaTeX3 programming environment
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/ucasthesis.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- use \topmargin insead of \voffset to shift the complete text vertically
%- use \<odd|even>sidemargin insead of \hoffset to shift text horizontally
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- binding side width + textwidth + nonbinding side width = paperwidth
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{146.6mm}% set required text width first
\setlength{\hoffset}{0mm}% set horizontal offset
\ifucas@print% if print layout enabled
    \setlength{\oddsidemargin}{12.6mm}% binding side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{6.3mm}% left side margin
    \setlength{\evensidemargin}{6.3mm}% ensure uniform left side width for EThesis
\fi
\setlength{\marginparwidth}{35pt}% width of margin notes
\setlength{\marginparsep}{10pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{246.2mm}% set required text height first
\setlength{\voffset}{0mm}% set vertical offset
\setlength{\topmargin}{-10.4mm}% vertical margin above header
\setlength{\headheight}{12pt}% header height
\setlength{\headsep}{17.5pt}% vertical margin between header and body text
\setlength{\footskip}{10.4mm}% vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.6}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}
%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex%
    \RequirePackage{ulem}%
\else%
    \RequirePackage{ulem}%
\fi
\newcommand{\ulunify}[1]{\uline{#1}}% unified name
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \setlength{\ULdepth}{0.3em}% set depth
    \expandafter\ulunify\expandafter{#2}% linebreak fix
}
\newcommand{\ulhshift}{-4em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> 中文项目命令
%-
\def\ucas@value@ch@universitycode{}
\newcommand{\universitycode}[1]{\def\ucas@value@ch@universitycode{#1}}
\def\ucas@value@ch@sid{}
\newcommand{\sid}[1]{\def\ucas@value@ch@sid{#1}}
\def\ucas@value@ch@schooltitle{}
\newcommand{\schooltitle}[2][]{\def\ucas@value@ch@schooltitle{\ucasifstrbk{#1}{\zihao{-2}\bfseries\sffamily #2}{\includegraphics[#1]{#2}}}}
\def\ucas@value@ch@schoollogo{}
\newcommand{\schoollogo}[2][]{\def\ucas@value@ch@schoollogo{\ucasifstrbk{#1}{\zihao{-2}\bfseries\sffamily #2}{\includegraphics[#1]{#2}}}}
\def\ucas@value@ch@title{}
\def\ucas@value@ch@titlemark{}
\renewcommand{\title}[2][\ucas@value@ch@title]{%
    \def\ucas@value@ch@title{#2}
    %\def\ucas@value@ch@titlemark{\MakeUppercase{#1}}}
    \def\ucas@value@ch@titlemark{#1}}
\def\ucas@value@ch@author{}
\renewcommand{\author}[1]{\def\ucas@value@ch@author{#1}}
\def\ucas@value@ch@advisor{}
\newcommand{\advisor}[1]{\long\def\ucas@value@ch@advisor{#1}}
\def\ucas@value@ch@degree{}
\newcommand{\degree}[1]{\def\ucas@value@ch@degree{#1}}
\def\ucas@value@ch@major{}
\newcommand{\major}[1]{\def\ucas@value@ch@major{#1}}
\def\ucas@value@ch@field{}
\newcommand{\field}[1]{\def\ucas@value@ch@field{#1}}
\def\ucas@value@ch@institute{}
\newcommand{\institute}[1]{\long\def\ucas@value@ch@institute{#1}}
\def\ucas@value@ch@school{}
\newcommand{\school}[1]{\def\ucas@value@ch@school{#1}}
\def\ucas@value@ch@submitdate{}
\newcommand{\submitdate}[1]{\def\ucas@value@ch@submitdate{#1}}
\def\ucas@value@ch@date{}
\renewcommand{\date}[1]{\def\ucas@value@ch@date{#1}}
%-
%-> English item commands
%-
\def\ucas@value@en@title{}
\def\ucas@value@en@titlemark{}
\newcommand{\TITLE}[2][\ucas@value@en@title]{%
    \def\ucas@value@en@title{#2}
    %\def\ucas@value@en@titlemark{\MakeUppercase{#1}}}
    \def\ucas@value@en@titlemark{#1}}
\def\ucas@value@en@degree{}
\newcommand{\DEGREE}[1]{\edef\ucas@value@en@degree{\zap@space#1 \@empty}}% expand and remove space
\def\ucas@value@en@school{}
\newcommand{\SCHOOL}[1]{\def\ucas@value@en@school{#1}}
%-
%-> Detect and adjust items
%-
\AtEndPreamble{%
    \ucasifstreq{\ucas@value@en@degree}{Bachelor}{%
        \def\ucas@label@ch@thesis{\ucas@label@ch@thesis@bac}%
        \def\ucas@label@ch@author{\ucas@label@ch@author@bac}%
        \def\ucas@label@ch@major{\ucas@label@ch@major@bac}%
        \def\ucas@label@ch@institute{\ucas@label@ch@institute@bac}%
    }{%
    \ucasifstreq{\ucas@value@en@degree}{Master}{%
        \def\ucas@label@ch@thesis{\ucas@label@ch@thesis@mas}%
        \def\ucas@label@ch@author{\ucas@label@ch@author@mas}%
        \def\ucas@label@ch@major{\ucas@label@ch@major@mas}%
        \def\ucas@label@ch@institute{\ucas@label@ch@institute@mas}%
    }{%
    \ucasifstreq{\ucas@value@en@degree}{Doctor}{%
        \def\ucas@label@ch@thesis{\ucas@label@ch@thesis@doc}%
        \def\ucas@label@ch@author{\ucas@label@ch@author@doc}%
        \def\ucas@label@ch@major{\ucas@label@ch@major@doc}%
        \def\ucas@label@ch@institute{\ucas@label@ch@institute@doc}%
    }{%
        \ClassWarning{ucasthesis}{Invalid value of '\string\DEGREE', please check the spelling}%
    }}}%
}
%-
%-> 封面
%-
\def\maketitle{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.6}
        \zihao{-4}\bfseries% 封面字体

        \hfill{}\begin{tabular}{lc}% 封面右上角创建表格
            \ucasifstrbk{\ucas@value@ch@universitycode}{}{\zihao{5}\makebox[4em][s]{\ucas@label@ch@universitycode}：&\ucas@value@ch@universitycode}\\
            \ucasifstrbk{\ucas@value@ch@sid}{}{\zihao{5}\makebox[4em][s]{\ucas@label@ch@sid}：&\ucas@value@ch@sid}
        \end{tabular}

        \vspace*{\stretch{4}}

        {\ucas@value@ch@schooltitle}

        {\zihao{3}\ucas@value@en@school}% 英文校名

        \vspace*{\stretch{2}}

        {\zihao{1}\bfseries\sffamily {\ucas@label@ch@thesis}}

        {\zihao{-2}\bfseries\sffamily (\ucas@value@ch@degree\ucas@label@ch@degree)}

        \vspace*{\stretch{2}}

        {\ucas@value@ch@schoollogo}

        \vspace*{\stretch{3}}

        {\zihao{3}\bfseries\sffamily \ulenhance[0.5pt]{\ucas@value@ch@title}}

        {\zihao{3}\bfseries \ulenhance[0.5pt]{\ucas@value@en@title}}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{lc}
            \makebox[6em][s]{\ucas@label@ch@author} & \ulenhance[0.5pt]{\ulextend{\ucas@value@ch@author}}\\
            \makebox[6em][s]{\ucas@label@ch@advisor} & \ulenhance[0.5pt]{\ulextend{\ucas@value@ch@advisor}}\\
            \makebox[6em][s]{\ucas@label@ch@major} & \ulenhance[0.5pt]{\ulextend{\ucas@value@ch@major}}\\
            \makebox[6em][s]{\ucas@label@ch@field} & \ulenhance[0.5pt]{\ulextend{\ucas@value@ch@field}}\\
            \makebox[6em][s]{\ucas@label@ch@institute} & \ulenhance[0.5pt]{\ulextend{\ucas@value@ch@institute}}\\
            \makebox[6em][s]{\ucas@label@ch@submitdate} & \ulenhance[0.5pt]{\ulextend{\ucas@value@ch@submitdate}}\\
        \end{tabular}

        \vspace*{\stretch{4}}

        {\ucas@value@ch@date}

        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifucas@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifucas@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
    \ifucas@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
%---------------------------------------------------------------------------%
%->> New environments
%---------------------------------------------------------------------------%
%- define chinese keywords
\newcommand{\keywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \ucas@label@ch@keywords} #1}
%- define engish keywords
\newcommand{\KEYWORDS}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \ucas@label@en@keywords} #1}
%---------------------------------------------------------------------------%
%->> Structure elements
%---------------------------------------------------------------------------%
\ifucas@plain%
    \def\contentsname{\ucas@label@en@tocname}
    \def\listfigurename{\ucas@label@en@lsfigname}
    \def\listtablename{\ucas@label@en@lstabname}
    \def\bibname{\ucas@label@en@bibname}
    \def\refname{\ucas@label@en@bibname}
    \def\algname{\ucas@label@en@algname}
    \def\bibetal{\ucas@label@en@bibetal}
    \def\biband{\ucas@label@en@biband}
    \def\axiomname{\ucas@label@en@axiomname}
    \def\theoremname{\ucas@label@en@theoremname}
    \def\lemmaname{\ucas@label@en@lemmaname}
    \def\corollaryname{\ucas@label@en@corollaryname}
    \def\assertionname{\ucas@label@en@assertionname}
    \def\propositionname{\ucas@label@en@propositionname}
    \def\conjecturename{\ucas@label@en@conjecturename}
    \def\definitionname{\ucas@label@en@definitionname}
    \def\examplename{\ucas@label@en@examplename}
    \def\remarkname{\ucas@label@en@remarkname}
    \def\proofname{\ucas@label@en@proofname}
    \def\@title{\ucas@value@en@titlemark}
    \def\@author{\ucas@value@en@author}
\else
    \def\contentsname{\ucas@label@ch@tocname}
    \def\listfigurename{\ucas@label@ch@lsfigname}
    \def\listtablename{\ucas@label@ch@lstabname}
    \def\algname{\ucas@label@ch@algname}
    \def\bibname{\ucas@label@ch@bibname}
    \def\refname{\ucas@label@ch@bibname}
    \def\bibetal{\ucas@label@ch@bibetal}
    \def\biband{\ucas@label@ch@biband}
    \def\axiomname{\ucas@label@ch@axiomname}
    \def\theoremname{\ucas@label@ch@theoremname}
    \def\lemmaname{\ucas@label@ch@lemmaname}
    \def\corollaryname{\ucas@label@ch@corollaryname}
    \def\assertionname{\ucas@label@ch@assertionname}
    \def\propositionname{\ucas@label@ch@propositionname}
    \def\conjecturename{\ucas@label@ch@conjecturename}
    \def\definitionname{\ucas@label@ch@definitionname}
    \def\examplename{\ucas@label@ch@examplename}
    \def\remarkname{\ucas@label@ch@remarkname}
    \def\proofname{\ucas@label@ch@proofname}
    \def\@title{\ucas@value@ch@titlemark}
    \def\@author{\ucas@value@ch@author}
\fi
%---------------------------------------------------------------------------%
%->> Structure layout
%---------------------------------------------------------------------------%
%- chapter
\ctexset {
    chapter = {
        format = \linespread{1.0}\zihao{4}\bfseries\sffamily\centering,
        nameformat = {},
        titleformat = {},
        number = \zhnum{chapter},
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {7pt},
        afterskip = {18pt},
        pagestyle = plain,
    }
}
%- section
\ctexset {
    section = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {24pt},
        afterskip = {6pt},
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- appendix
\ctexset {
    appendix = {
        %numbering = true|false,
        %number = \rmfamily\Alph{chapter},
    }
}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- the table of contents is specified by defining \l@chapter, \l@section, ...
%- most commands are then defined with the \@dottedtocline:
%- \@dottedtocline{⟨level⟩}{⟨indent⟩}{⟨numwidth⟩}{⟨title⟩}{⟨page⟩}
%- ⟨level⟩    an entry is produced only if ⟨level⟩ <= value of the tocdepth counter
%-            note, \chapter is level 0, \section is level 1, etc
%- ⟨indent⟩   indentation from the outer left margin of the start of the contents line
%- ⟨numwidth⟩ width of a box in which the section number is to go
%- <title>    title
%- <page>     page number

%- parameters for spacing and length in toc
\def\@dotsep{1.5mu}% separation between dots in mu units
\def\@pnumwidth{2em}% width of a box in which the page number is put
\def\@tocrmarg{2em}% right margin for multiple line entries, \@tocrmarg ≥ \@pnumwidth
\def\@chaptervspace{1ex}% vertical space between chapter titles

%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from book.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty{-\@highpenalty}%
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{4}\sffamily #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \global\@nobreaktrue
            \everypar{\global\@nobreakfalse\everypar{}}%
        \endgroup
    \fi
}
%- redefine l@chapter from book.cls to add dotted toc line
\renewcommand*{\l@chapter}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{4}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}
%- redefine indentation for others
\renewcommand*\l@section{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2em}{2.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{3em}{3.8em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{4em}{4.8em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{5em}{5.8em}}
\renewcommand*\l@figure{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@table{\@dottedtocline{1}{1em}{1.8em}}
%---------------------------------------------------------------------------%
\endinput
