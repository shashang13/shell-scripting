#!/bin/bash

x=abc
case $x in
  abc)
    echo x=abc
  ;;
  xyz)
    echo x=xyz
  ;;
  *)
    echo x is not either xyz or abc
  ;;
esac