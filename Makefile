CHAPTERS = 05-cleaning-data
MARKDOWNS = $(foreach c,${CHAPTERS},$(wildcard ${c}/*.md))
HTMLS = ${MARKDOWNS:.md=.ipynb.html}

html : ${HTMLS}

${HTMLS} : %.ipynb.html : %.md
	jupytext $< --output $*.ipynb
	jupyter nbconvert --execute --to html --output $(notdir $@) $*.ipynb
	rm -f $*.ipynb
