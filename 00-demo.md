# Demo Chapter

Here's some code that'll run in a notebook and also run in CI.

```python
print("Hello world")
```

## How to Use the Setup

You can write chapters for the course using standard markdown files in a variety of ways. Here are a few approaches that we've found useful. Before getting started, you need to set up a Python environment and install the Python requirements. Once you have Python set up, run `pip install -r requirements.txt` from the root directory to install all the requirements.

### The Bare-Bones Approach

1. Use a text editor of your choice to modify the markdown. Any fenced code block starting with the `python` language identifier will be executed when you convert the markdown to html.
2. Run `make [your markdown document].ipynb.html` from the command line to execute the notebook and convert it to html.

### The Interactive Approach

Recompiling the document with `make` every time you make a small change can be cumbersome. You can get an interactive environment using Jupyter Lab.

1. Run `jupyter lab` from the command line to start a new Jupyter Lab server.
2. Once the server has loaded (it can take a few seconds), right-click on the markdown file you want to modify, hover your mouse over "Open With", and select "Notebook".
3. Make any changes in the notebook. You can execute code interactively. Hit save, and the markdown document will be updated.
4. Once your happy with the document, make sure to run `make [your markdown document].ipynb.html` from the command line to verify your changes work as expected.

### Adding Google Slide Images

To add an image from a Google Slide deck, use the following markdown syntax.

```markdown
![alternative if the image is broken](https://docs.google.com/presentation/d/<presentation identifier>/export/png?pageid=<slide identifier without the .id prefix>)
```

Here is an example.

![Data Science Process](https://docs.google.com/presentation/d/114QYFmKuJ2M5E3tlBw8Gwu2xI09tb8gnrKrNkMY9CG4/export/png?pageid=g145cde68be4_0_70)
