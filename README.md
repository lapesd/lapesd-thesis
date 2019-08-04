# lapesd-thesis

This is a template for writing thesis and dissertations (kind of) according to rules of the Federal University of Santa Catarina.

## Warning

This template is **highly opinionated** and not a prime example of flexibility. In the interest of providing a configuration-free experience, many decisions are done inside the .cls. Also, since its audience is small, the **documentation consists of comments inside the .cls file and the example**. You can get a non-opinionated and well documented class that *only provides the university formatting rules* at the upstream class [ufsc-thesis-rn46-2019](https://github.com/alexishuf/ufsc-thesis-rn46-2019).

# Usage

See the example in this repository. File structure is as follows:

- `lapesd-thesis.cls`: The class file, extends [ufsc-thesis-rn46-2019](https://github.com/alexishuf/ufsc-thesis-rn46-2019)
- `main.tex`: The main tex file, it `\input{}`s the following files:
    - `acronyms.tex`: Acronyms list
    - `glossary.tex`: Glossary entries
    - `prolog.tex`: Pre-textual elements
    - `body.tex`: Textual elements
    - `epilog.tex`: Post-textual elements
- `imgs/`: Image files. The .svg's are compiled to PDF automatically
- `Makefile`: self-descriptive

## Packages included and configured

Note that this list is of packages load in addition to those in the upstream class. It also does not include packages such as `twoopt`, used for creating macros. 

- `\usepackage[utf8]{inputenc}` is enforced
- `\usepackage[T1]{fontenc}` is enforced
- `xcolor`
- `booktabs`
- `array`
- `multirow`
- `placeins` 
- `pifont` 
- `newfloat` 
- `minted` 
- `algorithmicx` 
- `algpseudocode` 
- `glossaries` 
- `makeidx` 
- `amsmath` 
- `amssymb` 
- `amsthm` 
- `enumitem` 


## Non-trivial configurations and new macros

### New symbols

Package pifont is used to provide the following symbols
- `\cmk`: A stylish checkmark
- `\xmk`: Corresponding "x-mark"
- `\circledi`, `\circledii`, ..., `\circledix`: Numerals 1 to 9 inside circles 

### Subfigures

`memoir` (upstream of [abnTeX2](https://github.com/abntex/abntex2/) should be used to deal with subfigures. A subfigure environment for macro \subcaption is already provided. In addition the following convenience macro is defined to provide a centered figure with a `\label` of  `labelname` (for cross-referencing with `\ref` and `\autoref`) and `\caption` typeset within a top-anchored minipage of the given width:

```{latex}
\subcaptionminipage[labelname]%
                   {minipagewidth}
                   {caption text}%
                   {figure code}
```

### Listings and code with minted

Minted is configured both for use in a `\begin{listing}...\end{listing}` environment that replaces `figure` and for inlining in text. For the float usage, a `\listoflistings` macro is already configured. For inlining, there are two variants. The following macros are configured for inlining (there is always a `\mf<langcode>` version that uses `\footnotesize`) :

- `\m`: text
- `\mc`: C
- `\mjv`: Java
- `\mla`: LaTeX (how meta)
- `\mtt`: Turtle
- `\msp`: SPARQL
- `\mxm`: XML (may god have mercy on your soul)


### Algorithms (pseudo-code)

Package `algorithmicx` and `algpseudocode` are used for this. Like minted, an `\begin{algorithm}...\end{algorithm}` environment as well as a `\listofalgorithms` macro is provided.

### Indexing

Achieved through `makeidx`. Indexing is less common than it should. Check the [wikibooks section on indexing](https://en.wikibooks.org/wiki/LaTeX/Indexing) for a quick start. This class add three convenience macros to provide hyperlinks within the text to the point where index terms were defined.

```{latex}
\xindex[labelname]{index entry}
```
This macro is a replacement for `\index` that in addition calling \index, also leaves a `\label{def:labelname}` at the place of invocation. If `labelname` is omitted, `\label{def:index entry}` will be issued instead.

```{latex}
\indexterm{term}
\indexTerm{term}
```
Typesets `term` or `Term` in the case of `\indexTerm` with an hyperlink to the point where `\xindex[term]{...}` was used. If `\xindex` used a `labelname` that is not suitable for humans to read, you have to use `\hyperref` directly: `\hyperref[labelname]{text that will appear}`


### Glossaries

The `glossaries` package is used with what its manual calls "Option 1". This relies on the document author maintaining the acronym definitions and glossary entries sorted. For easier house-keeping, the template keeps the definitions in separate files. Two macros are provided by this class to generate the list of acronyms and the glossary (the * causes them to not appear in `\tableofcontents`):

```{latex}
\listadesiglas*
\imprimirglossario*
```

#### Referencing an acronym or glossary entry

If you use he custom macros to define acronyms and entries, you can use the acryonym and the entries themselves as macros. For example, supose an acronym `DHT` and a glossary entry `proxy`:

- `\DHT` produces Distributed Has Table (DHT) on first use
- `\DHT` produces DHT on subsequent uses
- `\DHTs` produces Distributed Has Tables (DHTs) on first use
- `\DHTs` produces DHTs on subsequent uses
- `\proxy` produces proxy, linking to its entry in the glossary
- `\proxys` produces proxies (as configured in the entry definition), linking to its entry in the glossary

The macros `\Glsfirst*` from glossaries are modified to enforce expansion of the acronym, even if it was already expanded before

#### Defining acronym entries

This must be done using custom macros `\tnewacronym` and `\xnewacronym`. You can directly use glossaries macros, but the referencing functionality above will not work. These macros should be used as follows:


```{latex}
\xnewacronym[CMD][kv_opts]{ACRONYM}{expansion}
```
This macro registers the acronym with `glossaries`. The acronym will appear in text as ACRONYM. Anything given in kv_opts is forwarded to the `\newacronym` macro from `glossaries`. If CMD is not given, it defaults to ACRONYM. Two new macros will be generated, with meanings presented in the previous section: \CMD and \CMDs. If you want to use glossaries macros for expanding the acronym, you should use ACRONYM as the key, not CMD.

```{latex}
\tnewacronym[kv_opts]{ACRONYM}{expansion}
```
This macro generates an acronym that will never be expanded. However it will appear in the list of acronyms.

You are are **highly encouraged to see the example acronym definitions*  at the `acronyms.tex` file.


#### Defining glossary entries

Likewise, in order to generate `\entry` macros for every entry, a macro named `\xnewglossaryentry` must be used. This macro takes the exact same arguments as its counterpart `\newglossaryentry` in the glossaries package.

```{latex}
\xnewglossaryentry{label}{kv_list}
```

This macro will generate macros \label and \labels, whose functionality was discussed earlier in the context of referencing entries. Again, you are **highly encouraged to see the example acronym definitions*  at the `glossary.tex` file.

### Makefile

The Makefile should be straightforward. It detects changes in any .tex, .bib or .svg file in order to determine a rebuild of PDF file.

The Makefile converts all PDFs inside the `imgs/` diretocry into pdfs whenever it detects changes. This is done using [inkscape](https://inkscape.org/), which must be available at the system. There is a Makefile function, svg2pdf that allows cropping the PDF generation to a named group within the SVG. This is useful from creating anymated slides from SVGs.

The  `main.robust.pdf` file is a version of the `main.pdf` file generated by pdflatex that is written in PDF 1.4 and has all fonts embedded. This is not all that is needed for PDF/A compliance, but is required by some publishers (IEEE and Elsevier). Therefore this can be considered a more portable PDF file.
