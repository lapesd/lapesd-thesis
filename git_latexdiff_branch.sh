#!/bin/sh
repo_path=.
old_main_file=main.tex
new_main_file=main.tex
temporary_dir=$repo_path/tmp
mkdir $temporary_dir

#Git archive does not compress submodules!
git archive --format=tar.gz $1 > $temporary_dir/old_project.tar.gz
tar -xzvf $temporary_dir/old_project.tar.gz -C $temporary_dir/
rm $temporary_dir/old_project.tar.gz

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

rm -r $temporary_dir
rm diff.tex
