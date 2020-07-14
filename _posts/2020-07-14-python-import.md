---
layout: post
title: Create a Python Package with __init__.py
subtitle: A practical hint on Pythonn import implementation
cover-img: /assets/img/ox3.jpg
gh-repo: YongchaoHuang/yongchaohuang.github.io
gh-badge: [python]
tags: [engineering]
comments: true
---

References: <br />
  * [How to create a Python Package with __init__.py](https://timothybramlett.com/How_to_create_a_Python_Package_with___init__py.html).


# Motivation
If you are running a script (module) which incokes another module form command line (e.g. unit testing), without a \__init__.py\ file (even empty) defined in the same directory, most likely it's gonna raise 'no module named...' error. <br />
Or when you are running a script with 'import xx from x', it's gonna be a long prefix. <br />
These functionalities can be packed into the \__init__.py\ file.  <br />

# Implementation
Python 'import' function internally invokes '__import__' method. You can directly use it as well. 
I am lazy taking notes today, so pls go to following link for details. <br />
* [How to create a Python Package with __init__.py](https://timothybramlett.com/How_to_create_a_Python_Package_with___init__py.html).

