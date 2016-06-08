Apple Emoji
===========
apple_emoji.sty
---------------
### © DPD- 2016
#### version 1.0.0
##### This package is realeased under GNU GPL 2
##### Source code on: https://github.com/DPDmancul/Apple-Emoji

Style package for directly including color emojis in LaTeX documents with support of color modifiers

### Installation

    # mkdir -p /usr/share/texlive/texmf-dist/tex/latex
    # cd /usr/share/texlive/texmf-dist/tex/latex
    # git clone git@github.com:DPDmancul/Apple-Emoji.git
    # texhash

## Examples TODO

The following LaTeX code:

    \documentclass{article}
    \usepackage{apple_emoji}
    \begin{document}
      Hello, 🌎 👋🏽.
    \end{document}

produces something like:

![Hello, world.](hello.png)

You can even use emojis in math. The following LaTeX code:

    \[
      🐊^{🐊^{🐊}} = \int_{🎃} 🙊 \ d🍀 👍🏻
    \]

produces something like:

![Emojis in math
mode.](math.png)

## Important
The encoding of the `.tex` must support emoji's, that is unicode characters. So switch your encoding to something like UTF-8.
Example:

    \usepackage[utf8]{inputenc}

Do not use `utf8x` because it's unmaintained

## Known issues

- This style sheet creates a PDF where each emoji is actually an embedded _image_
rather than a character using the [Apple Color Emoji
typeface](http://en.wikipedia.org/wiki/Apple_Color_Emoji). This means you won't
be able to correctly copy and paste emjois from the resulting .pdf files.
- Only color modifiers are actually supported
