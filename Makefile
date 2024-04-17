MARKDOWNS = $(wildcard *.md)
HTMLS = ${MARKDOWNS:.md=.ipynb.html}

html : ${HTMLS}

${HTMLS} : %.ipynb.html : %.md
	# Create an intermediate .ipynb file that we execute.
	jupytext $< --output $*.ipynb
	# Execute and convert to HTML. We use the .ipynb.html extension so we can git-ignore
	# the generated files without affecting other .html files.
	jupyter nbconvert --execute --to html --output $(notdir $@) $*.ipynb
	# Delete the intermediate .ipynb file again.
	rm -f $*.ipynb
