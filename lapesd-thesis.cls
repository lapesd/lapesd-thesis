% vim:et:sw=2

%% lapesd-thesis.cls, a batteries-included and opinionated extension to ufsc-thesis-rn46-2019

% Versão  do LaTeX
\NeedsTeXFormat{LaTeX2e}
% Declara a classe (e versão)
\ProvidesClass{lapesd-thesis}[2021/08/10 v0.3.1 lapesd-thesis]

% Não há razão para tolerar qualquer coisa além de UTF-8
\RequirePackage[utf8]{inputenc}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Suppressão de warnings                                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                     Judge not, that ye be not judged
\RequirePackage{silence}
% Mytesrious harmless warnings from glossaries
\WarningFilter{glossaries}{Overriding \printglossary}
\WarningFilter{glossaries}{Overriding `theglossary'}
% https://tex.stackexchange.com/a/78020
\pdfsuppresswarningpagegroup=1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Declarações e tratamento inicial de opções                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{kvoptions} %key=value class options
\SetupKeyvalOptions{
  family=lapesdthesis,
  prefix=lapesdthesis@
}

% Nossa fonte padrão é lmodern
\def\lapesdthesis@font{lmodern}
\DeclareVoidOption{times}{\def\lapesdthesis@font{times}}
\DeclareVoidOption{arial}{\def\lapesdthesis@font{arial}}

% O nosso padrão é usar o logo embarcado, direnteo do upstream
\DeclareBoolOption[true]{embeddlogo}
\DeclareComplementaryOption{noembeddlogo}{embeddlogo}

% O template da BU não inclui a página do primeiro uso da sigla na lista de
% siglas. Muito provavelmente pois tal funcionalidade no word não existe e seria
% um pesadelo fazer isso manualmente. Não há motivo para o bibliotecário achar
% tal conveniência ruim, mas em caso de ergencia essa opção existe.
\DeclareBoolOption[true]{glossariespages}
\DeclareComplementaryOption{noglossariespages}{glossariespages}

% Todas as opções que não foram listadas anteriormente são redirecionadas 
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{ufsc-thesis-rn46-2019}}

% Faz a mágica acontecer
\ProcessKeyvalOptions*

% Carrega como base a classe ufsc-thesis-rn46-2019
\iflapesdthesis@embeddlogo
  \PassOptionsToClass{embeddedlogo}{ufsc-thesis-rn46-2019}
\fi
\PassOptionsToClass{inline}{enumitem}
\LoadClass[%
  \lapesdthesis@font
]{ufsc-thesis-rn46-2019}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Configurações/pacotes/macros básicos                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Defaults para meta-dados
\instituicao{Universidade Federal de Santa Catarina}
\centro{Centro Tecnológico}
\local{Florianópolis}
\programa{Programa de Pós-Graduação em Ciência da Computação}
\data{\today}

% Fontes T1
\RequirePackage[T1]{fontenc}

% Inofensivo
\RequirePackage{lipsum}

% xspace arruma ocorrências de comandos que "comem" o espaço subsequente
\RequirePackage{xspace}

% uso interno: macros com 2 argumentos opcionais
\RequirePackage{twoopt}

% Ativa cores (tambem carrega color)
\RequirePackage{xcolor}

% Pacotes para tabelas bonitas
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{multirow}

% Search path padrão do \includegraphics
\graphicspath{%
  {.}%
  {imgs/}%
  {plots/}%
  {ufsc-thesis-rn46-2019/}%
}

% Fornece \FloatBarrier que impede diagramação de texto até todos os floats
% terem sido "assentados"
\RequirePackage{placeins}
% TODO fix
% \apptocmd{\chapter}{\protect\FloatBarrier}{}{}
% \apptocmd{\section}{\protect\FloatBarrier}{}{}
% \apptocmd{\subsection}{\protect\FloatBarrier}{}{}

% metadados do PDF
% \AtBeginDocument{
%   \hypersetup{%
%     pdftitle={\imprimirtitulo},%
%     pdfauthor={\imprimirautor},%
%     pdfsubject={\imprimirpreambulo},%
%     pdfcreator={LaTeX}%
%   }%
% }

% Suporte para definição de comandos
\RequirePackage{suffix}

% Shorthands para conveniência
\providecommand{\citep}[2][]{\cite[#1]{#2}}
\providecommand{\citet}[2][]{\citeonline[#1]{#2}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% i18n                                                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\addto\extrasenglish{%
  \def\lapesdthesislistingname{Listing}%
  \def\lapesdthesislistoflistingsname{List of Listings}%
  \def\lapesdthesisalgorithmname{Algorithm}%
  \def\lapesdthesislistofalgorithmsname{List of Algorithms}%
  \def\lapesdthesisdefinitionname{Definition}%
  \def\lapesdthesislemmaname{Lemma}%
  \def\lapesdthesistheoremname{Theorem}%
  \def\lapesdthesisproofname{Proof}%
  \def\definitionautorefname{\lapesdthesisdefinitionname}%
  \def\lemmaautorefname{\lapesdthesislemmaname}%
  \def\theoremautorefname{\lapesdthesistheoremname}%
  \def\theoremproofautorefname{\lapesdthesisproofname}%
}
\addto\extrasbrazil{%
  \def\lapesdthesislistingname{Listagem}%
  \def\lapesdthesislistoflistingsname{Lista de Listagens}%
  \def\lapesdthesisalgorithmname{Algoritmo}%
  \def\lapesdthesislistofalgorithmsname{Lista de Algoritmos}%
  \def\lapesdthesisdefinitionname{Definição}%
  \def\lapesdthesislemmaname{Lema}%
  \def\lapesdthesistheoremname{Teorema}%
  \def\lapesdthesisproofname{Prova}%
  \def\definitionautorefname{\lapesdthesisdefinitionname}%
  \def\lemmaautorefname{\lapesdthesislemmaname}%
  \def\theoremautorefname{\lapesdthesistheoremname}%
  \def\theoremproofautorefname{\lapesdthesisproofname}%
}
% Carrega as modificações
\RequirePackage{iflang}
\IfLanguageName{english}%
  {\captionsenglish\extrasenglish}%
  {\captionsbrazil\extrasbrazil}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Símbolos                                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{pifont} 
\newcommand{\cmk}{\ding{51}}                 % checkmark
\newcommand{\xmk}{\ding{55}}                 % x no mesmo estilo que checkmark
\newcommand{\circledi}{\ding{192}\xspace}    % 1 dentro de círculo
\newcommand{\circledii}{\ding{193}\xspace}   % 2 ...
\newcommand{\circlediii}{\ding{194}\xspace}  % 3 ...
\newcommand{\circlediv}{\ding{195}\xspace}   % 4 ...
\newcommand{\circledv}{\ding{196}\xspace}    % 5 ...
\newcommand{\circledvi}{\ding{197}\xspace}   % 6 ...
\newcommand{\circledvii}{\ding{198}\xspace}  % 7 ...
\newcommand{\circledviii}{\ding{199}\xspace} % 8 ...
\newcommand{\circledix}{\ding{200}\xspace}   % 9 ...



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Subcaptions (subfigura)                                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\RequirePackage{subcaption}
%\renewcommand{\thesubfigure}{\alph{subfigure}}
\newsubfloat{figure}

% \subcaptionminipage[labelname]{<largura>}{<legenda>}{<figura>}
%
% Cria um minipage com a largura fornecida, contendo um \subcaption
% acima da figura que ficará centralizada dentro do minipage
\newcommand{\subcaptionminipage}[4][]{%
  \begin{minipage}[t]{#2}%
    \centering%
    \subcaption{#3\ifstrempty{#1}{}{\label{#1}}}%
    \vspace{0.5em}%
    #4%
    \vspace{1.5em}%
  \end{minipage}%
}

% Sem essa gambiarra, um \autoref{fig:sf} onde fig:sf se refere à um
% \subcaptionminipage[fig:sf]{}{}{} dentro de um figure com
% \contcaption{(continua)} (fazendo com que o caption não incremente o contador
% da Figura) gerará Figure i+1(c) ao invés de Figure i(c).
\newtoggle{lapesdthesis@inccaptioncounter}
\let\lapesdthesis@contcaption\contcaption
\renewcommand{\contcaption}[1]{%
  \lapesdthesis@contcaption{#1}%
  \toggletrue{lapesdthesis@inccaptioncounter}
  \addtocounter{\@captype}{-1}%
}

% Antes de sair de um figure com \contcaption, desfaz o decremento no counter
% (que era necessário para que o \subcaption funcionasse corretamente). Não
% fazer isso pode fazer com que o caption de figuras subsequentes sejam
% numeradas como i-1 ao invés de i.
\AtEndEnvironment{figure}{%
  \iftoggle{lapesdthesis@inccaptioncounter}
    {\addtocounter{\@captype}{1}}%
    {}%
  \togglefalse{lapesdthesis@inccaptioncounter}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Configura o minted                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{newfloat}
\RequirePackage[newfloat]{minted}
% Cria um novo float, incluindo \listoflistings
\SetupFloatingEnvironment{listing}{%
  within=none,%
  listname=\lapesdthesislistoflistingsname,%
  name=\lapesdthesislistingname%
}
\newsubfloat{listing}

\pretocmd{\listoflistings}{%
  \begingroup%
  \renewcommand{\figurename}{\lapesdthesislistingname}%
}{}{}
\apptocmd{\listoflistings}{\endgroup}{}{}
% Cria versão * que não adiciona no \tableofcontents
\WithSuffix\newcommand\listoflistings*{%
  \begin{KeepFromToc}%
    \listoflistings%
  \end{KeepFromToc}%
}

% Define ambientes inline:
  % quebras de linhas são necessárias
  \setmintedinline{breaklines,breakbytokenanywhere}
  % {text} e {c} são usados por todos, então são mais curtos
  \newmintinline[mt]{text}{fontsize=\normalsize}
  \newmintinline[mc]{c}{fontsize=\normalsize}
  % demais linguagens usam mnemonicos de 2 letras
  \newmintinline[mjv]{java}{fontsize=\normalsize,escapeinside=@@}
  \newmintinline[mla]{latex}{fontsize=\footnotesize}
  \newmintinline[mtt]{turtle}{fontsize=\normalsize,escapeinside=||}
  \newmintinline[msp]{sparql}{fontsize=\normalsize,escapeinside=||}
  \newmintinline[mxm]{xml}{fontsize=\normalsize}
  % Todos os ambientes anteriores, agora para uso em footnotes (m* -> mf*):
  \newmintinline[mft]{text}{fontsize=\normalsize}
  \newmintinline[mfc]{c}{fontsize=\normalsize}
  \newmintinline[mfjv]{java}{fontsize=\normalsize,escapeinside=@@}
  \newmintinline[mfla]{latex}{fontsize=\footnotesize}
  \newmintinline[mftt]{turtle}{fontsize=\normalsize,escapeinside=||}
  \newmintinline[mfsp]{sparql}{fontsize=\normalsize,escapeinside=||}
  \newmintinline[mfxm]{xml}{fontsize=\normalsize}

% Ambiente minted (em floats) deve usar \footnotesize por dois motivos:
% - Regras da BU (10 pt em floats)
% - Faz o código caber
\setminted{%
  fontsize=\footnotesize,%
  linenos,%
  xleftmargin=2em%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Configura o algorithmicx                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{algorithmicx}
\RequirePackage[noend]{algpseudocode}

% Ambiente algorithm e \listofalgorithms agora são configurados no 
% ufsc-thesis-rn46-2019.cls


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Configura o glossaries (incluindo macros de conveniencia)      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Atenção: a opção de configuração (Option 1 no manual) é uma que
%%% não necessita de programas externos, e pode ser usada no
%%% overleaf. No entanto, as definições de acronimos e termos do
%%% glossário PRECISAM SER MANTIDAS EM ORDEM ALFABÉTICA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\let\su@ExpandTwoArgs\relax
\let\IfSubStringInString\relax
\let\su@IfSubStringInString\relax
\RequirePackage[acronym]{glossaries}

% Define a forma como irá acontecer o build dos glossarios. Essa é a forma mais
% rústica: exige que as listas sejam mantidas em ordem pelo autor
\makenoidxglossaries

% Estilo da lista de siglas
\newglossarystyle{longdotted}{%
  \setglossarystyle{long}%
  \renewcommand{\glossentry}[2]{%
    \glsentryitem{##1}\glstarget{##1}{\glossentryname{##1}}% 
    & \glossentrydesc{##1}%
      \iflapesdthesis@glossariespages%
        \glspostdescription\cftdotfill{\cftdotsep} ##2%
      \fi%
      \tabularnewline%
  }%
  \addtocounter{table}{-1}
}

% Sempre expande se o usuário pedir
\renewrobustcmd*{\glsfirst}[2][]{\glsreset{#2}\gls[#1]{#2}}
\renewrobustcmd*{\Glsfirst}[2][]{\glsreset{#2}\Gls[#1]{#2}}
\renewrobustcmd*{\GLSfirst}[2][]{\glsreset{#2}\GLS[#1]{#2}}
\renewrobustcmd*{\glsfirstplural}[2][]{\glsreset{#2}\glspl[#1]{#2}}
\renewrobustcmd*{\Glsfirstplural}[2][]{\glsreset{#2}\Glspl[#1]{#2}}
\renewrobustcmd*{\GLSfirstplural}[2][]{\glsreset{#2}\GLSpl[#1]{#2}}

% Comandos para criação de acronimos

% \xnreacronym[kv_opts]{SIGLA}{expansão} 
%
% registra um novo acronimo. Se o argumento opcional for omitido, a própria
% SIGLA é usada na exibição. As opções permitidas no kv_opts são detalhadas na
% seção 4 do manual do glossaries.
%
% Serão também gerados comandos \SIGLA e \SIGLAs (que expando o acronimo no
% plural). Para customizar a expansão no plural, use a opção longplural. Ex:
% longplural={Square Matrices}
\newcommandtwoopt{\xnewacronym}[4][][]{%
  % #1: CMD para gerar \CMD, tipicamente CMD=SIGLA
  % #2: opções chave-valor repassadas para o \newacronym
  % #3: SIGLA, como deve aparecer no texto
  % #4: expansão
  \newacronym[#2]{#3}{#3}{#4}%
  \ifstrempty{#1}{%
    \@namedef{#3}{\gls{#3}\xspace}%
    \@namedef{#3s}{\glspl{#3}\xspace}%
  }{%
    \@namedef{#1}{\gls{#3}\xspace}%
    \@namedef{#1s}{\glspl{#3}\xspace}%
  }
}
% \tnewacronym[kv_opts]{SIGLA}{expansão}
%
% Cria um acronimo que pode ser usado com o comando \SIGLA, mas que nunca será
% expandido. Ainda assim ele irá aparecer na lista de siglas. Casos de uso para
% essa macro são acrônimos triviais, como API e HTTP que iriam expandir
% loucamente na introdução. Use com parcimônia
\newcommand{\tnewacronym}[3][]{%
  \newacronym[#1]{#2}{#2}{#3}%
  \@namedef{#2}{\glstext{#2}\xspace}%
  \@namedef{#2s}{\glstext{#2}s\xspace}%
}

% \listadesiglas
% \listadesiglas*
% 
% Gera a lista de siglas. A versão com * não gera entrada no \tableofcontents
\newcommand{\listadesiglas}[1][5em]{%
  \cleardoublepage%
  \setlength{\glsdescwidth}{\dimexpr 16cm-#1-\tabcolsep\relax}
  \printnoidxglossary[%
    title=\listadesiglasname,% definido no abntex2
    type=\acronymtype,%
    style=longdotted]%
  \clearpage%
}
\WithSuffix\newcommand\listadesiglas*[1][5em]{%
  \begin{KeepFromToc}%
    \listadesiglas[#1]%
  \end{KeepFromToc}%
}

% \xnewglossaryentry{label}{kv_list}
%
% Equivalente ao comando \newglossaryentry do pacote glossaries. No entanto gera
% novos comandos \label e \labels que expandem para \gls{label} e \glspl{label}
\newcommand{\xnewglossaryentry}[2]{%
  \newglossaryentry{#1}{#2}%
  \@namedef{#1}{\gls{#1}\xspace}%
  \@namedef{#1s}{\glspl{#1}\xspace}%
}

% Iprime o glossário, deixa um label para referência ao capítulo
\newcommand{\imprimirglossario}[0]{%
  \cleardoublepage
  \label{glossario}
  \PRIVATEbookmarkthis{\glossaryname} % from abntex2.cls (not so private)
  \printnoidxglossary[type=main]
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Configurações e comandos para index                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{makeidx}

% \xindex[labelname]{<entry>}
%
% Faz \index{<entry>} e deixa um \label{def:labelname} para uso futuro via
% \hyperref[def:labelname]{Texto}, \indexterm{labelname} ou
% \indexTerm{labelname}. Se labelname não for fornecido, <entry será usado>.
%
% Veja https://en.wikibooks.org/wiki/LaTeX/Indexing para detalhes sobre o uso de
% \index{}
\newcommand{\xindex}[2][]{%
  \index{#2}%
  \ifstrempty{#1}{\label{def:#2}}{\label{def:#1}}%
  \ignorespaces%
}

% \indexterm{labelname}
% \indexTerm{labelname}
%
% Cria um link para o ponto onde \index[labelname]{entry} foi usado (lembre que
% entry é usado como labelname se o argumento opcional não for fornecido ao
% \xindex). O comando indexTerm Capitaliza a primeira palavra de labelname
\newcommand{\indexterm}[1]{\hyperref[def:#1]{#1}}
\newcommand{\indexTerm}[1]{\hyperref[def:#1]{\MakeUppercase #1}}

\newcommand{\imprimirindice}[0]{%
  \cleardoublepage
  \label{indice}
  \printindex
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Configura Definições e Teoremas                                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\theoremstyle{definition}
\newtheorem{definition}{\lapesdthesisdefinitionname}[chapter]
\newenvironment{defn}{\begin{definition}}{\end{definition}}
\newtheorem{lemma}{\lapesdthesislemmaname}[chapter]
\newtheorem{theorem}{\lapesdthesistheoremname}[chapter]
\newtheorem{theoremproof}{\lapesdthesisproofname}[chapter]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Patches para formatação                                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% remove espaços gigantes entre \item's
\RequirePackage{enumitem}
\setlist{noitemsep} 

% Altera comandos definidos em outros lugares para lidar com espaços
\appto{\footnotemark}{\xspace} 
\apptocmd{\index}{\ignorespaces}{}{} 

\endinput
