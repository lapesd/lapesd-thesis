# lapesd-thesis

This is a template for writing theses and dissertations (kind of) according to rules of the Federal University of Santa Catarina adopted after Resolution 46/2019/CPG. This is a customization of the [ufsc-thesis-rn46-2019](https://github.com/alexishuf/ufsc-thesis-rn46-2019) class.

## Warning

This template is **highly opinionated** and not a prime example of flexibility. In the interest of providing a configuration-free experience, many decisions are done inside the .cls. Also, since its audience is small, the **documentation consists of comments inside the .cls file and the example**. You can get a non-opinionated and well-documented class that *only provides the university formatting rules* at the upstream class [ufsc-thesis-rn46-2019](https://github.com/alexishuf/ufsc-thesis-rn46-2019).

# Usage

## Provisioning the lapesd-thesis class

There are 3 options to get/update the class file:

1. `git clone` this repository, create a branch and update by `git merge`ing `master` into your branch
    - This workflow is not compatible with overleaf users, and may cause unecessary conflicts with non-`.cls` files.
2.  Copy contents of this repository and update by manually downloading the [lapesd-thesis.cls](https://raw.githubusercontent.com/lapesd/lapesd-thesis/master/lapesd-thesis.cls)  and [ufsc-thesis-rn46-2019.cls](https://raw.githubusercontent.com/alexishuf/ufsc-thesis-rn46-2019/master/ufsc-thesis-rn46-2019.cls) files from github.
3. Use a submodule (easier updating only the class files):

The submodule approach requires creating two symbolic links:
```bash
git submodule add https://github.com/lapesd/lapesd-thesis.git
git submodule update --init --recursive 
ln -s lapesd-thesis/lapesd-thesis.cls
ln -s lapesd-thesis/ufsc-thesis-rn46-2019/ufsc-thesis-rn46-2019.cls
```

After setup, the `.cls` files can be updated with a single `git submodule update --recursive` call.

## Project layout

**See the example** in this repository, starting from [main.tex](https://github.com/lapesd/lapesd-thesis/blob/master/main.tex). File structure is as follows:

- `lapesd-thesis.cls`: The class file, extends [ufsc-thesis-rn46-2019](https://github.com/alexishuf/ufsc-thesis-rn46-2019)
- `main.tex`: The main tex file, it `\input{}`s the following files:
    - `acronyms.tex`: Acronyms list
    - `glossary.tex`: Glossary entries
    - `prolog.tex`: Pre-textual elements
    - `body.tex`: Textual elements
    - `epilog.tex`: Post-textual elements
- `imgs/`: Image files. The .svg's are compiled to PDF by the Makefile
- `Makefile`: self-descriptive

## Packages included and configured

There is a list of packages loaded in addition to those in the upstream class. It does not include packages such as `twoopt`, used for creating macros.

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

### Dependencies

These packages should be present in nearly all texlive instalations. In case of missing package errors, check the list of available and installed `texlive-*` packages on your system.

The `minted` package requires pygments, a python module that has a pygmentize command line utility. Check installation instructions for your particular system/package manager. On MacOS one must do `sudo easy_install Pygments`. On arch linux, the `pacman` package is `community/pygmentize`.

## Non-trivial configurations and new macros

### amsthm

Four environments are defined using the style Definition (formated as **Name Chapter.Sequence.**):

- `definition`
- `defn` (as an alias to `definition`, retaining the same counter)
- `lemma`
- `theoremproof`
   - This is a new environment, to prove a theorem you can do it from within the theorem itself, using the `proof` environment

`\autoref`, from the `hyperref` package is configured (in english or portuguese) with appropriate labels for each of these environments (`proof` is not numbered, only `theoremproof` is). 

### New symbols

Package pifont is used to provide the following symbols
- `\cmk`: A stylish checkmark
- `\xmk`: Corresponding "x-mark"
- `\circledi`, `\circledii`, ..., `\circledix`: Numerals 1 to 9 inside circles 

### Subfigures

`memoir` (upstream of [abnTeX2](https://github.com/abntex/abntex2/)) should be used to deal with subfigures. A subfigure environment for macro \subcaption is already provided. In addition, the following convenience macro is defined to provide a centered figure with a `\label` of  `labelname` (for cross-referencing with `\ref` and `\autoref`) and `\caption` typeset within a top-anchored minipage of the given width:

```{latex}
\subcaptionminipage[labelname]%
                   {minipagewidth}
                   {caption text}%
                   {figure code}
```

### Listings and code with minted

Minted is configured both for use in a `\begin{listing}...\end{listing}` environment that replaces `figure` and for inlining in text. For the float usage, a `\listoflistings` macro is already configured. For inlining, there are two variants. The following macros are configured for inlining (there is always a `\mf<langcode>` version that uses `\footnotesize`):

- `\mt`: text
- `\mc`: C
- `\mjv`: Java
- `\mla`: LaTeX (how meta)
- `\mtt`: Turtle
- `\msp`: SPARQL
- `\mxm`: XML (may god have mercy on your soul)


### Algorithms (pseudo-code)

Package `algorithmicx` and `algpseudocode` are used for this. Like minted, an `\begin{algorithm}...\end{algorithm}` environment as well as a `\listofalgorithms` macro are provided.

### Indexing

Achieved through `makeidx`. Indexing is less common than it should. Check the [wikibooks section on indexing](https://en.wikibooks.org/wiki/LaTeX/Indexing) for a quick start. This class adds three convenience macros to provide hyperlinks within the text to the point where index terms were defined.

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

The `glossaries` package is used with what its manual calls "Option 1". This relies on the document author maintaining the acronym definitions and glossary entries sorted. For easier house-keeping, the template keeps the definitions in separate files. Two macros are provided by this class to generate the list of acronyms and the glossary (the * causes them not to appear in `\tableofcontents`):

```{latex}
\listadesiglas*
\imprimirglossario*
```

In the presence of large acronyms, the table may overflow into the right margin or even exceed the page border. This happens due to a miscalculation of the width of the description (rightmost) column while the acronyms (leftmost) column. By default, \listadesiglas guesses the largest acronym will have a width of 5em (1em == width of one uppercase 'M'). You can override this using the optional argument:

```{latex}
\listadesiglas[10em]* % large acronyms -- will shrink description
\listadesiglas[2em]*  % small acronyms -- will widen description
```

#### Referencing an acronym or glossary entry

If you use the custom macros to define acronyms and entries, you can use the acryonym and the entries themselves as macros. For example, supose an acronym `DHT` and a glossary entry `proxy`:

- `\DHT` produces Distributed Has Table (DHT) on first use
- `\DHT` produces DHT on subsequent uses
- `\DHTs` produces Distributed Has Tables (DHTs) on first use
- `\DHTs` produces DHTs on subsequent uses
- `\proxy` produces proxy, linking to its entry in the glossary
- `\proxys` produces proxies (as configured in the entry definition), linking to its entry in the glossary

The macros `\Glsfirst*` from glossaries are modified to enforce expansion of the acronym, even if it was already expanded before.

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

You are **highly encouraged to see the example acronym definitions* at the `acronyms.tex` file.


#### Defining glossary entries

Likewise, in order to generate `\entry` macros for every entry, a macro named `\xnewglossaryentry` must be used. This macro takes the exact same arguments as its counterpart `\newglossaryentry` in the glossaries package.

```{latex}
\xnewglossaryentry{label}{kv_list}
```

This macro will generate macros \label and \labels, whose functionality was discussed earlier in the context of referencing entries. Again, you are **highly encouraged to see the example acronym definitions* at the `glossary.tex` file.

## Makefile

The Makefile should be straightforward. It detects changes in any `.tex`,  `.bib` or `.svg` file in order to determine a rebuild of PDF file.

The Makefile converts all PDFs inside the `imgs/` directory into PDFs whenever it detects changes. This is done using [inkscape](https://inkscape.org/), which must be available at the system. There is a Makefile function (`svg2pdf`) that allows cropping the PDF generation to a named group within the SVG. This is useful from creating anymated slides from SVGs.

The  `main.pdfa.pdf` file is a version of the `main.pdf` file that complies with PDF/A 1-b. Conversion to PDF/A is done by GhostScript and text/image quality should be preserved. Note that the converted file will be large as PDF/A requires font and color embedding and it preffers rendering on PDF/A generation time than rendering on display time (for long-time consistent archival). To verify PDF/A compliance, use VeraPDF:

```bash
verapdf -f 1b main.pdfa.pdf
```
