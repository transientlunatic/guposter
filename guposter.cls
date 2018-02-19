\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{guposter}[2017/09/06 v.0.1 A document class for making posters which approximately conform to UoG branding guidelines.]

\PassOptionsToClass{\CurrentOption}{kentigern}
%\documentclass{article}
\LoadClass[final, t, mathserif]{beamer}
\mode<presentation> {  %% check http://www-i6.informatik.rwth-aachen.de/~dreuw/latexbeamerposter.php for examples
    \usetheme{boxes}    %% you should define your own theme e.g. for big headlines using your own logos 
  }
\setbeamertemplate{bibliography item}{}
\beamertemplatenavigationsymbolsempty
\usepackage[orientation=portrait,size=a1,scale=0.7]{beamerposter}                       % e.g. for DIN-A0 poster
%\usepackage[orientation=portrait,size=a1,scale=0.7]{beamerposter}                       % e.g. for DIN-A0 poster
\usepackage{amsthm, amsmath}
\usepackage{natbib}
\usepackage[T1]{fontenc}
\usepackage{garamondx}
\usepackage[default]{gillius}
%\usepackage{tgadventor}
\renewcommand*\familydefault{\rmdefault} %% Only if the base font of the document is to be sans serif
\usepackage{xparse, xstring}
\usepackage{environ}
\usepackage{hyphenat}
\usepackage{microtype}
\usepackage{exscale}
\usepackage{pgf, tikz}
\usepackage{physicsplus}
\usepackage{listings}

\usetikzlibrary{shapes,snakes}
\usetikzlibrary{arrows,chains,matrix,positioning,scopes}
\tikzstyle{every picture}+=[remember picture]

\input{uog_colour}


\def\cw{\paperwidth/13}
\def\rh{(\paperheight/26}
\def\margin{1.3cm}
  
\makeatletter

% This works both with inline lists and with macros

\DeclareDocumentCommand \GetListMember {m m}{%
    \edef\dotheloop{%
      \noexpand\foreach \noexpand\a [count=\noexpand\i] in {#1} {%
        \noexpand\IfEq{\noexpand\i}{#2}{\noexpand\a\noexpand\breakforeach}{}%
    }}%
    \dotheloop
    \par%
}%



\DeclareDocumentCommand \colbox { m }
{
  \begin{tikzpicture}[scale=2]
    \fill [#1] (0,0) circle (.3);
    \draw (.4, 0) node [right] {\large #1};
  \end{tikzpicture}
}

\DeclareDocumentCommand \section {m}
{%
  \newline\mbox{%
    \huge{\textrm{\textcolor{university-burgundy}{#1}} }
  }\newline%
}

\DeclareDocumentCommand \title {m}
{
  \def\@title{#1}
}
\DeclareDocumentCommand \subtitle {m}
{
  \def\@subtitle{#1}
}
\def\@subtitle{\relax}
\DeclareDocumentCommand \eachauthor {m}
{
  \draw node (authors) {};
  \draw node (a) [right = 1cm of a, right, white, text width=8cm,] {
    {\large 
      \textsc{\GetListMember{#1}{1}}
    } 
    {\small
      \textcolor{muted-cream}{\GetListMember{#1}{2}}
      \textcolor{muted-cream}{\GetListMember{#1}{3}} 
    }
  };
  \node (authors) [
    circle,
    draw,
    ultra thick,
    white,
    left = .5cm of a,
    text=white,
    path picture={
      \node
      [text width=1.5cm, xshift=1.8cm]
      {%
        % Note that there are probably better ways of doing this...
        \foreach \x [count=\i] in {#1} {\IfEq{\noexpand\i}{4}{\includegraphics [width = 1.5cm] {\x}}{}}
      %\includegraphics{#1}%
      };%
      }%
    ]%
        {\phantom{hello}};%

}

\DeclareDocumentCommand \eachlogo {m}
{
  \draw node (footer-a) [right = of footer-a] { \includegraphics[height=3cm]{#1} };
}




\DeclareDocumentCommand \authors {>{\SplitList{;}}m}
{
\def\@authors{
  \ProcessList{#1}{\eachauthor}
}
}
\DeclareDocumentCommand \listauthors {}
{ 
  \ProcessList{\@authors}{\eachauthor}
}

\DeclareDocumentCommand \logos {>{\SplitList{,}}m}
{
  \def\@logos{
    \ProcessList{#1}{\eachlogo}
  }
}


\DeclareDocumentCommand \maketitle {}
{
\begin{tikzpicture}[overlay, scale=1, remember picture]
  \coordinate (A) at (-1,2);
  \coordinate (B) at (\paperwidth,2);
  \coordinate (C) at (-1, -\paperheight);
  \coordinate (D) at (\paperwidth, -\paperheight);
  %\draw[help lines,step=20mm,gray!10] (A)+(0,-7.5) grid (D);
  % Draw the header box
  \fill[university-blue] (A) -- +(0, -8.5) -- +(\paperwidth, -8.5) -- (B) -- cycle; 
  \fill[university-blue!82] (A)+(0, -8.4) -- +(0, -9) -- +(\paperwidth, -9) -- (\paperwidth, -6.4) -- cycle; 
  % Draw the titles
  \draw node (title) [yshift=-2.5cm, xshift=2cm, right, white]{\fontsize{85}{60}\selectfont{\@title}} 
        node (subtitle) [right = 1cm of title, yshift=-7.5mm, muted-cream, text width=30cm] {\fontsize{30}{60}\selectfont \@subtitle};
  % Insert the author list
  % the (a) node determines the location of the first name
  \node (a) at (3.5, -5) {}; 
  \@authors
  % Insert the university logo
  % guidelines suggest this should be the colour keyline version.
  \draw node (unilogo) at (\paperwidth-8.5cm, -3.0) [] {\includegraphics[width=10cm]{figures/UoG_keyline.pdf}};
  % Draw the footer box
  \node (footer-a) at (1, -\paperheight*0.95) {};
  \@logos
\end{tikzpicture}
\makeatother
\begin{tikzpicture}[remember picture]

  \foreach \x in {0, ..., 13}{
    \foreach \y [count=\i] in {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v}{
      \coordinate (\y\x) at (\margin+\cw*\x, -6.0cm - \rh*\i);
      }
  }
\end{tikzpicture}
}
%
\NewEnviron{AbstractEnv}[1]
           {
             \begin{tikzpicture}[overlay, remember picture]
               \node at (#1)
                     [below right, text width=0.5\paperwidth]
                     {
                       \begin{tikzpicture}
                         \node at (0,0) {\Large\BODY};
                         \draw [line width=0.2cm, draw = university-pumpkin]
                         (current bounding box.north west)+(-0.4cm, 0.2cm) --
                         (current bounding box.south west)+(-0.4cm, 0.5cm);
                       \end{tikzpicture}
                     };
             \end{tikzpicture}
           }%

\NewEnviron{PanelEnv}[3]
           {
             \begin{tikzpicture}[overlay, remember picture]
               \node at (#1)
                     [below right, text width = \cw*#2]
                     {
                       \begin{tikzpicture}
                         \node at (0,0) {\Large\BODY};
                         \draw [line width=0.2cm, draw = #3]
                         (current bounding box.north west)+(-0.4cm, 0.2cm) --
                         (current bounding box.south west)+(-0.4cm, 0.5cm);
                       \end{tikzpicture}
                     };
             \end{tikzpicture}
           }%
           
\DeclareDocumentEnvironment{abstract}{O{a0}}{\AbstractEnv{#1}}{\endAbstractEnv}                          

\DeclareDocumentEnvironment{panel}{m m O{university-blue}}{%
  %
  % Make a panel element
  %
  % Arguments
  % ---------
  % #1 : mandatory
  %    The location of the upper-left corner
  % #2 : mandatory
  %    The width of the element, in columns
  % #3 : optional
  %    The colour of the panel, defaults to blue.
  \PanelEnv{#1}{#2}{#3}
  }{\endPanelEnv}

\newcommand{\drawgrid}{
  \begin{tikzpicture}[remember picture, overlay]
     \foreach \x in {0,...,13}{
       \foreach \y in {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v}{
         \node (\y\x) [white, fill=university-slate, opacity=0.0, circle] at (\y\x) {\y\x};
       }
     }
  \end{tikzpicture}
}
