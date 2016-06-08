#!/bin/bash
## LaTeX Apple Emoji package  generator                     ##
## (c) DPD- (Davide Peressoni) 2016                         ##
## This script is realeased under GNU GPL 2                 ##
## Source code on: https://github.com/DPDmancul/Apple-Emoji ##
source=`cat source.html` 	#read source
mkdir -p emoji 		#create folder for result if not exist
rm -rf result/* 		#clear folder
out='apple_emoji.sty'
test='test.tex'
touch $out 		#create output if not exist
touch $test 		#create test if not exist
echo '\ProvidesPackage{apple_emoji}

%% LaTeX Apple Emoji package                                %%
%% (c) DPD- (Davide Peressoni) 2016                         %%
%% This package is realeased under GNU GPL 2                %%
%% Source code on: https://github.com/DPDmancul/Apple-Emoji %%

\usepackage{graphicx,amsmath}
\usepackage[utf8]{inputenc}
%% Do not use utf8x beause it'\''s unmaintained
\usepackage[export]{adjustbox}



\makeatletter

\def\private@AppleEmoji#1{%
 \def\private@AppleEmojibaseemoji{#1}% set the base emoji as the current utf-8 character
 \private@AppleEmojipae} % call pae macro to check modifier character

% define UTF-8 modifiers bytes
\edef\private@AppleEmojimodifierbyteone{\noexpand\UTFviii@four@octets\string^^f0}
\edef\private@AppleEmojimoifierlastthreebytesb{\string^^9f\string^^8f\string^^bb}
\edef\private@AppleEmojimoifierlastthreebytesc{\string^^9f\string^^8f\string^^bc}
\edef\private@AppleEmojimoifierlastthreebytesd{\string^^9f\string^^8f\string^^bd}
\edef\private@AppleEmojimoifierlastthreebytese{\string^^9f\string^^8f\string^^be}
\edef\private@AppleEmojimoifierlastthreebytesf{\string^^9f\string^^8f\string^^bf}

\def\private@AppleEmojipae{\futurelet\private@AppleEmojitmp\private@AppleEmojipaex}% assign to a tempory variable the next char (first byte of the modifier)

\def\private@AppleEmojipaex{%
\ifx\private@AppleEmojitmp\private@AppleEmojimodifierbyteone % if this char is the first of a modififer sequece
 \expandafter\private@AppleEmojigetnextthreebytes % get the other tree bytes
 \else
  \private@AppleEmojiprint\private@AppleEmojibaseemoji{}%else print only the base emoji
\fi
  }

\def\private@AppleEmojigetnextthreebytes#1#2#3#4{%
  \edef\private@AppleEmojitmpb{\string#2\string#3\string#4}% get the modifier
  %% SWITCH the modifier
  \ifx\private@AppleEmojitmpb\private@AppleEmojimoifierlastthreebytesb
     \private@AppleEmojiprint\private@AppleEmojibaseemoji{1F3FB}%
  \else
    \ifx\private@AppleEmojitmpb\private@AppleEmojimoifierlastthreebytesc
       \private@AppleEmojiprint\private@AppleEmojibaseemoji{1F3FC}%
    \else
      \ifx\private@AppleEmojitmpb\private@AppleEmojimoifierlastthreebytesd
         \private@AppleEmojiprint\private@AppleEmojibaseemoji{1F3FD}%
      \else
        \ifx\private@AppleEmojitmpb\private@AppleEmojimoifierlastthreebytese
           \private@AppleEmojiprint\private@AppleEmojibaseemoji{1F3FE}%
        \else
          \ifx\private@AppleEmojitmpb\private@AppleEmojimoifierlastthreebytesf
             \private@AppleEmojiprint\private@AppleEmojibaseemoji{1F3FF}%
          \else
             \private@AppleEmojiprint\private@AppleEmojibaseemoji{}\private@AppleEmojimodifierbyteone#2#3#4%
             % if the four bytes is not a modifier print the base emoji and the four bytes
          \fi
        \fi
      \fi
    \fi
  \fi}


\def\private@AppleEmojiprint#1#2% insert the pictur of the emoji
 {%
  \text{%
    \includegraphics[height=1.5em,valign=B,raise=-0.2em]{emoji/#1#2.png}%
  }%
 }
'> $out			#initialize output
echo '\documentclass [a4paper,12pt]{article}
\usepackage{apple_emoji}

\begin{document}
\section{Apple Emoji}
\subsection{Test}
\[
🐊^{🐊^{🐊}} = \int_{🎃} 🙊 \ d🍀 👍🏻
\]

\subsection{All emoji}' > $test #initialize test

regex='<a href="[^"]*" name="[^"]*">([^<]*)<\/a><\/td>
<td class="chars">[^<]*<\/td>
<td class="[^"]*"><?[^>]*>?<\/td>
<td class="[^"]*"><img alt="[^"]*" class="imga" src="([^"]*)'
regex2='U\+(\w*) ?U?\+?(\w*)?'
while [[ $source =~ $regex ]]; do #while i find emoji emoji
    #echo 'source matches'
    n=${#BASH_REMATCH[*]}
    s=${BASH_REMATCH[0]}
    name=${BASH_REMATCH[1]}
    img=${BASH_REMATCH[2]}
    img=${img#*"data:image/png;base64,"}
    [[ $name =~ $regex2  ]]  #extract the code
    first=${BASH_REMATCH[1]}
    second=${BASH_REMATCH[2]}
    echo "$first $second"
    echo "$img" | base64 -d > "emoji/$first$second.png"
    perl -C -e "print chr 0x$first" >> $test
    if [[ -z $second ]]; then
      echo "\DeclareUnicodeCharacter{$first}{\private@AppleEmoji{$first}}" >> $out
    else
      perl -C -e "print chr 0x$second" >> $test
    fi
    echo " " >> $test
    source=${source#*"$s"} #remove the extracted emoj from source string
done

echo '\makeatother' >> $out
echo '\end{document}'>> $test
pdflatex $test || echo 'error on test'