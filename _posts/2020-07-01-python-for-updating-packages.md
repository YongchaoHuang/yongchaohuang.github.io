---
layout: post
title: Update Packages via UI
subtitle: A Python programme for updating libraries
cover-img: /assets/img/ox5.jpg
gh-repo: YongchaoHuang/yongchaohuang.github.io
gh-badge: [UI, python]
tags: [engineering]
comments: true
---

Notes collected from: [Building a Python UI to Keep Your Libraries up to Date](https://towardsdatascience.com/building-a-python-ui-to-keep-your-libraries-up-to-date-6d3465d1b652).

![Image](https://miro.medium.com/max/1400/1*NPSOR5poCFWhTJgkmyjB5g.gif)
<div style="text-align: right">Photo by Costas Andreou </div>

# Motivation
There is a frequent need to update your Python packages once new versions (functionalities) are released. <br />
For example, to obtain the latest bug fixes, or to enhance performance. 
You can manage your packages through pip, so upgrading a library at a time was really simple. Unfortunately, that’s not the case if you want to upgrade all of them. There is no built-in functionality to let you upgrade all of your packages at once.  
If you loop through my packages and upgrade them - sometimes you have packages you don't want to upgrade. 


# The task  
Build an UI that picks up the packages you want and upgrade them.  

# Solution
Four libraries to use:  
1. Subprocess
This library allows us to interface with the command line and passes in any commands we would like. This is how I will be figuring out which libraries are outdated and then upgrading them.  
2. Pandas
Pandas is famous for working with data. In this instance, we will use it to read a CSV file into data frames, which also plays nice with our UI library of choice: PySimpleGUI  
3. Re
Re is the Python Regex library that allows us to easily match patterns. In this instance, we will use it to strip out any unnecessary information and only display what is useful.  
4. PySimpleGUI
Finally, PySimpleGUI will be the library we will use for the UI. We will define the UI, and then the events.  

# Full Code
```javascript
import subprocess
import pandas as pd
import re, threading
import PySimpleGUI as sg
#Create a file to save the output of the pip command of the packages needing upgrade
fhandle = open(r'C:\temp\update.txt', 'w')
#Using Mike's suggestion, I am commenting this line from the original script, and introduce a loading gif while the script is sourcing all the necessary libraries
#subprocess.run('pip list --outdated', shell = True, stdout = fhandle)
thread = threading.Thread(target=lambda: subprocess.run('pip list --outdated', shell=True, stdout=fhandle), daemon=True)
thread.start()
while True:
    sg.popup_animated(sg.DEFAULT_BASE64_LOADING_GIF, 'Loading list of packages', time_between_frames=100)
    thread.join(timeout=.1)
    if not thread.is_alive():
        break
sg.popup_animated(None)
fhandle.close()
#All the packages from pip needing updating have been saved in the file
#Create a data frame, and then massage and load the output data in the file to the expected format
df1 = pd.DataFrame(columns=['Package', 'Version', 'Latest', 'Type'])
fhandle = open(r'C:\temp\update.txt', 'r')
AnyPackagesToUpgrade = 0
for i, line in enumerate(fhandle):
    if i not in (0, 1): #first two lines have no packages
        df1 = df1.append({
                'Package': re.findall('(.+?)\s', line)[0],
                'Version': re.findall('([0-9].+?)\s', line)[0],
                'Latest': re.findall('([0-9].+?)\s', line)[1], 
                'Type': re.findall('\s([a-zA-Z]+)', line)[0]
                }, ignore_index=True)
        AnyPackagesToUpgrade = 1 #if no packages, then don't bring up full UI later on
#We now have a dataframe with all the relevant packages to update
#Moving onto the UI
formlists = []  #This will be the list to be displayed on the UI
i = 0
while i < len(df1): #this is the checkbox magic that will show up on the UI
    formlists.append([sg.Checkbox(df1.iloc[i, :])])
    formlists.append([sg.Text('-'*50)])
    i += 1
layout = [
    [sg.Column(layout=[
        *formlists], vertical_scroll_only=True, scrollable=True, size=(704, 400)
    )],
    [sg.Output(size=(100, 10))],
    [sg.Submit('Upgrade'), sg.Cancel('Exit')]
]
window = sg.Window('Choose Package to Upgrade', layout, size=(800, 650))
if AnyPackagesToUpgrade == 0:
    sg.Popup('No Packages requiring upgrade found')
    quit()
#The login executed when clicking things on the UI
definedkey = []
while True:  # The Event Loop
    event, values = window.read()
    # print(event, values)  # debug
    if event in (None, 'Exit', 'Cancel'):
        break
    elif event == 'Upgrade':
        for index, value in enumerate(values):
            if values[index] == True:
                #print(df1.iloc[index][0])
                sg.popup_animated(sg.DEFAULT_BASE64_LOADING_GIF, 'Installing Updates', time_between_frames=100)
                subprocess.run('pip install --upgrade ' + df1.iloc[index][0])
                sg.popup_animated(None)
                print('Upgrading', df1.iloc[index][0])
        print('Upgrading process finished.')
```
