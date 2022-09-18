#!/bin/bash

echo -e "\e[31mHello, this is my first line in color\e[0m"

# Red - 31
# Green - 32
# Yellow - 33
# Blue - 34
# Magenta - 35
# Cyan - 36


# -e      => enables escape sequence within ""
# ""      => Mandatory for color to work
# \e[colm => Enables color of mentioned code.
# \e[0m   => Disables color of the target line

# \n      => New line character
# \t      => Tab character

echo -e "Line1\n\nLine2"
echo -e "Word1\t\tWord2"