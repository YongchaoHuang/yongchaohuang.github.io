---
layout: post
title: Python UI Design
subtitle: A Python programme for UI design
cover-img: /assets/img/ox3.jpg
gh-repo: YongchaoHuang/yongchaohuang.github.io
gh-badge: [UI, python]
tags: [engineering]
comments: true
---

## Python UI design
Notes collected from: [Learn How to Quickly Create UIs in Python](https://towardsdatascience.com/learn-how-to-quickly-create-uis-in-python-a97ae1394d5).

![Image](https://miro.medium.com/max/1400/0*ZgU5krrr16l8eV3m)
<div style="text-align: right">Photo by Eftakher Alam on Unsplash</div>

### Motivation
Sometimes, however, your target audience is not technical enough.\\
They’d love to use your python scripts but only as long as they didn’t have to look at a single line of code.<br />
They need a Uer Interface (UI) in such a case.\\
\* years ago, I used to code UIs using Java/Python/Matlab. They are good, but time-consuming in some cases. Some environments also provide graphical operations for UI design, which is essentially UI for UI designers :)



### The task: UI to check if two files are identical
Design a UI to check if two files are identical, without mannually referecing to the Python scripts.<br />
\* for file compare algorithms, pls check a previous post: [Beyond Compare](yongchaohuang/github.io/beyond_compare) <br />
We essentially need a way to load up two files, and then choose the encryption we would like to use to do the file comparison.

## Python Libraries Available for UI usage
There are essentially 3 big Python UI libraries; Tkinter, wxPython and PyQT.

## Code the UI
To build that UI, we can use the following code:
```javascript
import PySimpleGUI as sg
layout = [
    [sg.Text('File 1'), sg.InputText(), sg.FileBrowse(),
     sg.Checkbox('MD5'), sg.Checkbox('SHA1')
     ],
    [sg.Text('File 2'), sg.InputText(), sg.FileBrowse(),
     sg.Checkbox('SHA256')
     ],
    [sg.Output(size=(88, 20))],
    [sg.Submit(), sg.Cancel()]
]
window = sg.Window('File Compare', layout)
while True:                             # The Event Loop
    event, values = window.read()
    # print(event, values) #debug
    if event in (None, 'Exit', 'Cancel'):
        break
```
which results in:
![Image](https://miro.medium.com/max/1400/1*HvmUi_7Bx_Oq1kMtYr8gkw.png)

## Plugging in the logic
We simply need to monitor for what the user inputs and then act accordingly. <br />

~~~
import PySimpleGUI as sg
import re
import hashlib
def hash(fname, algo):
    if algo == 'MD5':
        hash = hashlib.md5()
    elif algo == 'SHA1':
        hash = hashlib.sha1()
    elif algo == 'SHA256':
        hash = hashlib.sha256()
    with open(fname) as handle: #opening the file one line at a time for memory considerations
        for line in handle:
            hash.update(line.encode(encoding = 'utf-8'))
    return(hash.hexdigest())
layout = [
    [sg.Text('File 1'), sg.InputText(), sg.FileBrowse(),
     sg.Checkbox('MD5'), sg.Checkbox('SHA1')
     ],
    [sg.Text('File 2'), sg.InputText(), sg.FileBrowse(),
     sg.Checkbox('SHA256')
     ],
    [sg.Output(size=(88, 20))],
    [sg.Submit(), sg.Cancel()]
]
window = sg.Window('File Compare', layout)
while True:                             # The Event Loop
    event, values = window.read()
    # print(event, values) #debug
    if event in (None, 'Exit', 'Cancel'):
        break
    if event == 'Submit':
        file1 = file2 = isitago = None
        # print(values[0],values[3])
        if values[0] and values[3]:
            file1 = re.findall('.+:\/.+\.+.', values[0])
            file2 = re.findall('.+:\/.+\.+.', values[3])
            isitago = 1
            if not file1 and file1 is not None:
                print('Error: File 1 path not valid.')
                isitago = 0
            elif not file2 and file2 is not None:
                print('Error: File 2 path not valid.')
                isitago = 0
            elif values[1] is not True and values[2] is not True and values[4] is not True:
                print('Error: Choose at least one type of Encryption Algorithm')
            elif isitago == 1:
                print('Info: Filepaths correctly defined.')
                algos = [] #algos to compare
                if values[1] == True: algos.append('MD5')
                if values[2] == True: algos.append('SHA1')
                if values[4] == True: algos.append('SHA256')
                filepaths = [] #files
                filepaths.append(values[0])
                filepaths.append(values[3])
                print('Info: File Comparison using:', algos)
                for algo in algos:
                    print(algo, ':')
                    print(filepaths[0], ':', hash(filepaths[0], algo))
                    print(filepaths[1], ':', hash(filepaths[1], algo))
                    if hash(filepaths[0],algo) == hash(filepaths[1],algo):
                        print('Files match for ', algo)
                    else:
                        print('Files do NOT match for ', algo)
        else:
            print('Please choose 2 files.')
window.close()
~~~
Running the above code will give you the following outcome:  
![Image](https://miro.medium.com/max/1400/1*fVWBk7vx3-QviSOK87F9qw.png)

### Remarks 
- this library allows you to quickly spin up simple python UIs and share them
- You will still have the problem of having to run the code to get the UI
- but you can consider using something like PyInstaller which will turn your python script into a .exe that people can simply double click.


