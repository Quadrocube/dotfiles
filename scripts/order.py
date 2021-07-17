#!/usr/bin/env python3
# Author: Vlad Sterzhanov - @spolakh - 2021

from pprint import pprint
import subprocess
import json
import os

home_dir = os.getenv("HOME")
yabai_trait_path = os.path.join(home_dir, "dots", "yabairc-trait")
goku_trait_path = os.path.join(home_dir, "dots", "karabiner", "karabiner-trait")

class WindowManager:
    def __init__(self):
        self.cache = {}

    def GetDisplaysInfo(self):
        if "displays" in self.cache:
            return self.cache["displays"]
        proc = subprocess.run(['/usr/local/bin/yabai','-m', 'query', '--displays'], check=True, stdout=subprocess.PIPE, universal_newlines=True)
        result = json.loads(proc.stdout)
        self.cache["displays"] = result
        return result

    def DestroySpace(self, n):
        proc = subprocess.run(['/usr/local/bin/yabai','-m', 'space', '--destroy', str(n)], check=False)

    def CreateSpace(self):
        proc = subprocess.run(['/usr/local/bin/yabai','-m', 'space', '--create'], check=False)

    def FocusDisplay(self, n):
        proc = subprocess.run(['/usr/local/bin/yabai','-m', 'display', '--focus', str(n)], check=False)

    def RestartDaemon(self):
        proc = subprocess.run(['/usr/local/bin/brew','services', 'restart', 'koekeishiya/formulae/yabai'], check=False)

wm = WindowManager()

class App:
    def __init__(self, name, space_id):
        self.name = name
        self.space_id = space_id

    def GenYabaiConfig(self):
        # TODO add the name= rule as well - eg for Chromes with different accounts
        return "yabai -m rule --add app=\"^{}$\" space={}".format(self.name, self.space_id)

    def GenYabaiConfig(self):
        # XCXC
        return "".format(self.name, self.space_id)

class Display:
    def __init__(self, app_names, index, leading_space_id):
        self.leading_space_id = leading_space_id
        self.index = index
        self.apps = []
        for i, name in enumerate(app_names):
            app = App(name, self.leading_space_id + i + 1)
            self.apps += [app]

    def GetSpaces(self):
        info = wm.GetDisplaysInfo()[self.index]
        return info["spaces"]

    def DropSpaces(self):
        spaces = self.GetSpaces()
        for s in spaces:
            wm.DestroySpace(s)

    def CreateSpaces(self):
        wm.FocusDisplay(self.index)
        # this creates n spaces in addition to the first one
        # we dont assign anything to the first space on each display bc when display
        #   configuration changes, the windows from first spaces of each display get
        #   merged together
        for i in range(len(self.apps)):
            wm.CreateSpace()

    def GenYabaiConfig(self):
        conf = ""
        for a in self.apps:
            conf += a.GenYabaiConfig() +  "\n"
        return conf

    def GenGokuConfig(self):
        conf = ""
        for a in self.apps:
            conf += a.GenGokuConfig() +  "\n"
        return conf

class Layout:
    def __init__(self, conf, name):
        displays = []
        leading_space_id = 1
        for i, d in enumerate(conf):
            display = Display(d, i, leading_space_id)
            leading_space_id += len(display.apps) + 1
            displays += [display]
        self.displays = displays
        self.name = name

    def GenYabaiConfig(self):
        y_conf = ""
        for d in self.displays:
            y_conf += d.GenYabaiConfig() + "\n"
        return y_conf

    def GenGokuConfig(self):
        g_conf = ""
        for d in self.displays:
            g_conf += d.GenGokuConfig() + "\n"
        return g_conf

    def MaterializeGokuConfig(self):
        # this is a little tricky since .edn doesnt seem to support imports
        #  and goku doesnt support specifying a config directory
        # so instead we load the current base file (under git), append the
        #  generated one, and write the result out to the gitignored file that goku loads

    def Apply(self):
        # 1. delete all spaces from all displays
        for d in self.displays:
            d.DropSpaces()
        # 2. create as many spaces on each display as needed
        for d in self.displays:
            d.CreateSpaces()
        # 3. update yabairc-trait and reload
        y_conf = self.GenYabaiConfig()
        with open(yabai_trait_path, "w") as yf:
            yf.write(y_conf)
        wm.RestartDaemon()
        # 4. update goku-trait (autoreloads)
        g_conf = self.GenGokuConfig()
        self.MaterializeGokuConfig()

# apps we care about
# TODO treat sublists as "put all of these apps in one space"
app_sets = {}
app_sets["messengers"] = ["Slack", "Skype", "Telegram", "Discord", "Messenger", "zoom.us"]
app_sets["editors"] = ["Emacs", "GoLand"]
app_sets["browsers"] = ["Google Chrome", "Finder", "MySQLWorkbench", "Todoist", "Firefox", "DataGrip"]
app_sets["media"] = ["Spotify"]
app_sets["reference_docs"] = ["SnippetsLab", "Dash"]
app_sets["terminals"] = ["kitty"]

# define Layouts
layouts = {}
layouts["solo"] = Layout([v for v in app_sets.values()], "solo")

layouts["duoWithIpad"] = Layout([
sum([app_sets["editors"], app_sets["browsers"]], []),
sum([app_sets["messengers"], app_sets["media"], app_sets["reference_docs"], app_sets["terminals"]], [])
], "ipad-duo")

layouts["duoWithScreen"] = Layout([
sum([app_sets["messengers"], app_sets["media"], app_sets["reference_docs"], app_sets["terminals"]], []),
sum([app_sets["editors"], app_sets["browsers"]], [])
], "screen-duo")

layouts["trio"] = Layout([
sum([app_sets["browsers"]], []),
sum([app_sets["editors"]], []),
sum([app_sets["messengers"], app_sets["media"], app_sets["reference_docs"], app_sets["terminals"]], [])
], "trio")

# parse arguments and apply the chosen layout - ideally add some incantation to autodetect an irl layout

targetLayout = layouts["trio"]
