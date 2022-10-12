#!/bin/bash

x=abc
case $x in
  abc)
    echo Values of x=abc
  ;;
  xyz)
    echo Value of x=xyz
  ;;
  *)
    echo x is not either xyz or abc
  ;;
esac