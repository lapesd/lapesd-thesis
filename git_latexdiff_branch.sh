#!/bin/sh
# This script should be placed alongside the Makefile
repo_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$repo_path"

# Guess main latex file as the .tex file starting with \documentclass.*{lapesd-thesis}. Fallback to main.tex
basename=$((grep -rE '\\documentclass.*lapesd-thesis' | cut -d : -f 1 | grep -E '.tex$' | xargs -n 1 bash -c 'echo $(echo $@ | wc -c):$@' a | sed -E 's/^([0-9]):/00\1:/' | sed -E 's/^([0-9][0-9]):/0\1:/' | sort -u | head -n 1 | sed -E 's/^[0-9]+:(.*).tex$/\1/g' > basename.make.log && test "$$(cat basename.make.log)" != "001:" && cat basename.make.log && rm -f basename.make.log)  || echo main)

# Maybe the main file changed accross commits. In that case, call me like so:
# old_main_file=old_name.tex new_main_file=new_name.tex ./git_latexdiff_branch.sh COMMIT
old_main_file=${old_main_file:-$basename.tex}
new_main_file=${new_main_file:-$basename.tex}

# Use mktemp to create a temp dir inside $repo_path. Using a random name avoids clashes and allows
# the rm -fr at the end to be safe
temporary_dir=$(mktemp -d "$repo_path/latexdiff.XXXX")

# Check the user provided an input commit. git archive will check if it is valid.
if [ -z "$1" ]; then
  echo "Usage: $0 git_brach_or_commit" >&2
  exit 1
fi

#Git archive does not compress submodules!
git archive --format=tar.gz $1 > $temporary_dir/old_project.tar.gz || exit 1
tar -xzvf $temporary_dir/old_project.tar.gz -C $temporary_dir/ || exit 1
rm $temporary_dir/old_project.tar.gz || exit 1

#These flags are for: highlight type; consider "include" files; consider
#citations spaces; consider citations marks; and put everything from every file
#into a single one.
latexdiff -t CFONT --append-safecmd=include --allow-spaces --disable-citation-markup $temporary_dir/$old_main_file $repo_path/$new_main_file --flatten > $repo_path/diff.tex

# This is specific for my project. For a different project this has to be
# CHANGED
#IMPORTANT: THIS SCRIPT DOES NOT SUPPORT SUBMODULES! As a workaround you can put the
#diff file directly into the newer version of your repository and use already
#fetched submodules.
make MAIN_FILE=diff clean; make MAIN_FILE=diff
mv $repo_path/diff.pdf $temporary_dir/
make MAIN_FILE=diff clean
mv $temporary_dir/diff.pdf $repo_path/

rm -fr $temporary_dir
rm -f diff.tex
