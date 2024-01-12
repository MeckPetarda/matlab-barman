clear all;
clear obj;
clc;
delete(instrfindall);

application = gui();
commands = readtable("commands.csv");
menu = string(split(splitlines(fileread("menu.csv")), ','));
application.setMenu(menu)
application.setCommands(commands)