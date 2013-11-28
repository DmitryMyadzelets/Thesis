%% This is tesi.cls, to write thesis with LaTeX
%% by Daniele Arduini <d.arduini@rn.nettuno.it>
%%
%% $Id: itthesis.cls,v 1.6 1997/11/30 17:53:36 daniele Exp $
%%
\NeedsTeXFormat{LaTeX2e}[1994/12/01]
\ProvidesClass{itthesis}[1997/07/04 Italian Thesis Style class]

%\typeout{Tesi Style, version 0.1 <02 Jul 97>}
\newif\if@noindent       \@noindenttrue
\DeclareOption{indent}  {\@noindentfalse}
\DeclareOption{noindent}{\@noindenttrue}
\DeclareOption{a4paper}{%
  \setlength\paperheight {297mm}%
  \setlength\paperwidth  {210mm}}
\DeclareOption{a5paper}{%
  \setlength\paperheight {210mm}%
  \setlength\paperwidth  {148mm}}
\DeclareOption{b5paper}{%
  \setlength\paperheight {250mm}%
  \setlength\paperwidth  {176mm}}
\DeclareOption{letterpaper}{%
  \setlength\paperheight {11in}%
  \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}{%
  \setlength\paperheight {14in}%
  \setlength\paperwidth  {8.5in}}
\DeclareOption{executivepaper}{%
  \setlength\paperheight {10.5in}%
  \setlength\paperwidth  {7.25in}}
\DeclareOption{landscape}{%
  \setlength\@tempdima   {\paperheight}%
  \setlength\paperheight {\paperwidth}%
  \setlength\paperwidth  {\@tempdima}}
\newif\if@is@draft
\DeclareOption{draft}{\@is@drafttrue\setlength\overfullrule{5pt}}
\DeclareOption{final}{\@is@draftfalse\setlength\overfullrule{0pt}}
%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ExecuteOptions{final, a4paper, noindent}
\ProcessOptions

%%%
%%% Caricamento della classe base
%%%
\LoadClass{book}


%%%
%%% Impostazione dei margini
%%%
\RequirePackage{anysize}
\def\SetFirstPageMargins{%
  % margini: left right top    bottom
  \marginsize{3cm}{2cm}{2.54cm}{2.54cm}
}
\def\SetPageMargins{%
  % margini: left right top    bottom
  \marginsize{4cm}{3cm}{2.54cm}{2.54cm}
}
\SetPageMargins

\if@noindent
   \RequirePackage{parskip}
\fi

%%%
%%% Distanza tra le linee
%%%
%\renewcommand{\baselinestretch}{1.1}\normalsize
\RequirePackage{setspace}
\setstretch{1.1}


%%%
%%% Questo per evitare i noiosi Warnings sui Underfull boxes
%%%
\if@is@draft\else\hbadness=10000\fi


%%%
%%% Comando per l'inserimento delle figure. Le figure vengono scalate
%%% orizzontalmente se risultano di dimensioni maggiori della
%%% lunghezza impostata con il comando \SetFigureWidth.
%%% (graphicx)
%\setkeys{Gin}{width=0.75\textwidth}
\RequirePackage{graphicx}
\newbox \IT@box
\newdimen \IT@boxwidth
\newdimen \IT@figurewidth
\newcommand{\IncludeGraphics}[2][]{%
  \setbox\IT@box\hbox{%
    \if>#1> \includegraphics{#2} \else \includegraphics[#1]{#2} \fi}
  \IT@boxwidth \wd \IT@box
  \if@is@draft
     \typeout{#2 width: \the\IT@boxwidth} % this is for debug
  \fi                                     % purpose
  \ifdim \IT@boxwidth > \IT@figurewidth
      \resizebox{\IT@figurewidth}{!}{\usebox{\IT@box}}
  \else
      \usebox{\IT@box}
  \fi
}
%%%
%%% Comando per l'impostazione della larghezza delle figure.
%%% (default: 75% della larghezza del testo)
%%%
\def\SetFigureWidth#1{%
  \setlength{\IT@figurewidth}{#1}
}
\SetFigureWidth{0.75\textwidth}


%%%
%%% Ambiente per gli esempi
%%%
%\RequirePackage{verbatim}       % per l'environment ``example''
%\newenvironment{example}%
%   {\@verbatim \frenchspacing\@vobeyspaces\verbatim@start}%
%   {\endtrivlist}
%\def\verbatim@font{\normalfont\footnotesize\ttfamily}
%\def\verbatim@font{\normalfont\small\ttfamily}

\newenvironment{example}%
    {\begin{quote}\bgroup\small\tt}%
    {\egroup\end{quote}}


%%%
%%% Ambiente per l'inserimento di testo indentato
%%%
\newenvironment{indentify}[1][\parindent]%
   {\begin{list}{}{%
       \setlength{\labelwidth}{#1}
       \setlength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}}
       \item[]
   }%
   {\end{list}}


%%%
%%% \NDR: Nota Del Redattore; visibile soltanto con l'opzione di
%%% documento ``draft''.
%%%
\newcommand{\NDR}[1]{\if@is@draft\textbf{[ndr: #1]}\fi}


%%%
%%% Ridefinizione del comando '\chapter'.
%%% Rispetto a quello standard ha lo stile pagina 'empty'.
%%%
\renewcommand\chapter{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \thispagestyle{empty}%
  \global\@topnum\z@
  \@afterindentfalse
  \secdef\@chapter\@schapter}

%
%\newcommand{\clearemptydoublepage}{%
%       \newpage{\pagestyle{empty}\cleardoublepage}}
%


%%%
%%% Impostazioni dipendenti dal formato singola/doppia facciata.
%%%
\if@twoside
  \def\ps@headings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\protect\rule[-4pt]{\textwidth}{.5pt}\kern-\textwidth%
      \rm \thepage\hfil \bf \leftmark}%
    \def\@oddhead{\protect\rule[-4pt]{\textwidth}{.5pt}%
      \kern-\textwidth{\bf \rightmark}\hfil \rm\thepage}%
    \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markboth {%
        \ifnum \c@secnumdepth >\m@ne
          \if@mainmatter
             % \@chapapp\ \thechapter. \ %
          \fi
        \fi
        ##1}{}}%
    \def\sectionmark##1{%
      \markright {%
        \ifnum \c@secnumdepth >\z@
          \thesection. \ %
        \fi
        ##1}}}
\else
  \def\ps@headings{%
    \let\@oddfoot\@empty
    \def\@oddhead{\protect\rule[-4pt]{\textwidth}{.5pt}\kern-\textwidth
      {\bf \rightmark}\hfil \rm\thepage}%
    \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markright {%
        \ifnum \c@secnumdepth >\m@ne
          \if@mainmatter
            \@chapapp\ \thechapter. \ %
          \fi
        \fi
        ##1}}}
\fi

%%%
%%% Titlepage stuff
%%%
\newif\if@CoChairPerson \@CoChairPersonfalse
\gdef\University#1{\gdef\@University{#1}}
\gdef\Faculty#1{\gdef\@Faculty{#1}}
\gdef\LCourse#1{\gdef\@LCourse{#1}}
\gdef\Course#1{\gdef\@Course{#1}}
\gdef\Title#1{\gdef\@Title{#1}}
\gdef\Author#1{\gdef\@Author{#1}}
\gdef\ChairPerson#1{\gdef\@ChairPerson{#1}}
\gdef\CoChairPerson#1{\gdef\@CoChairPerson{#1}\@CoChairPersontrue}
\gdef\Session#1{\gdef\@Session{#1}}
\gdef\Years#1{\gdef\@Years{#1}}

\University{?}\Faculty{?}\LCourse{?}\Course{?}\Title{?}
\Author{?}\ChairPerson{?}\Session{?}\Years{?}

\renewcommand{\maketitle}{%
  %
  % La prima pagina ha i margini più piccoli
  %
  \SetFirstPageMargins
  \addtolength{\topmargin}{-2cm}
  \enlargethispage{4cm}
  \thispagestyle{empty}
  %
  % Intestazione
  %
  \begin{minipage}{\textwidth}
      \begin{center}
          {\huge Universit\`a degli Studi di \@University}\\
          \hrulefill\\
          \bigskip
          {\large\bfseries\scshape Facolt\`a di \@Faculty}\\
          {Corso di Laurea in \@LCourse}\\
          {\scshape\@Course}\\
          \mbox{}\\
          \mbox{}\\
          %\vspace{3.5cm}
         % \includegraphics[width=3.5cm]{unibo-logo}
      \end{center}
  \end{minipage}
  \vfill
  %
  % Titolo
  %
  \begin{minipage}{\textwidth}
      \begin{center}
          \huge\scshape\@Title
      \end{center}
  \end{minipage}
  \vfill
 \vspace{3.5cm}
  \begin{minipage}{\textwidth}
      %
      % Autore
      %
      \parbox[t]{0.45\linewidth}{%
        \raggedright
        {\large Tesi di Laurea di:}\par
        \medskip
        {\large\bfseries\scshape\@Author}}
      \hfill
      %
      % Relatore & correlatori
      %
      \parbox[t]{0.5\linewidth}{%
        \raggedleft
        {\large Relatore:}\par
        \medskip
        {\large\bfseries\scshape\@ChairPerson}
        \if@CoChairPerson
           \par\bigskip
           {\large Correlatori:}\par
           \medskip
           {\large\bfseries\scshape\@CoChairPerson}
        \fi}
  \end{minipage}
  \vfill
  %
  % Pie' pagina
  %
  \begin{minipage}{\textwidth}
      \begin{center}
          Sessione \@Session\\
          \hrulefill\\
          Anno Accademico \@Years
      \end{center}
  \end{minipage}
  \University{}\Faculty{}\LCourse{}\Course{}\Title{}
  \Author{}\ChairPerson{}\CoChairPerson{}\Session{}\Years{}
  \let\maketitle\relax
  \clearpage
  %
  % rimettiamo a posto i margini
  %
  \addtolength{\topmargin}{2cm}
  \SetPageMargins
}

%%%
%%% Needs to be here for the previous ps@headings defs to work.
%%%
\pagestyle{headings}

%%%
%%% USEFUL MACROS
%%%
\newcommand{\key}[1]{{\fbox{\small\tt #1}}}   % Use this to mark keys, like
                                              % \key{del} for the delete key.
\newcommand{\ret}{\fbox{\sf return}}    % Special case for the return key.
\newcommand{\st}{\small\tt}             % Small typewriter -- comes in handy.
\newcommand{\lbr}{\textless}            % Left Bracket '<'
\newcommand{\rbr}{\textgreater}         % Right Bracket '>'
\newcommand{\bs}{\textbackslash}       % BackSlash '\'

\newcommand{\Dedication}[1]{%
  \clearpage
  \thispagestyle{empty}
  \vspace*{\stretch{1}}
  \begin{flushright}
      \large\itshape #1
  \end{flushright}
  \vspace*{\stretch{2}}
  \clearpage
}


%% define URL macro to handle the optional name argument
\def\email#1{\textless #1\textgreater}
\def\url#1#2{\emph{#2} \texttt{<#1>}}


%
%   Gratis definition of a glossary environment
%
%\renewenvironment{glossary}
%  {\begin{list}{}{\setlength\itemindent{\parindent}
%   \def\makelabel##1{\footnotesize\uppercase{##1:}\hfill}}}
%  {\end{list}}

\endinput
