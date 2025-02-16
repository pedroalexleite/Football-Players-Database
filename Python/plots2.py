#INTRODUCTION------------------------------------------------------------------------------#


#cd Desktop/FPD/Python
#Python3 plots2.py
import time
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.patches import Arc, Arrow, FancyBboxPatch, Rectangle
from matplotlib import pyplot, transforms
from matplotlib.colors import LinearSegmentedColormap
import matplotlib.transforms as mtransforms
from PIL import Image, ImageDraw
import requests
import shutil
from rembg import remove
import cv2

start_time = time.time()

#load the DataFrame
players = pd.read_csv('/Users/pedroalexleite/Desktop/FPD/Dataframes/players.csv')
players.sort_values(by='Rating', ascending=False, inplace=True)


#BAR PLOT----------------------------------------------------------------------------------#


def bar_plots(players):
    for index, player in players.iterrows():
        #columns to plot based on position
        position = str(player['Position']).strip()
        if position=='Goalkeeper':
            columns_to_plot = ['Passing', 'Exiting', 'Cross-Stopping', 'Shot-Defending',
                               'Goal-Defending', 'Penalty-Defending',]
            columns_to_plot_labels = ['Passing', 'Exiting', 'Cross-Stop', 'Shot-Def',
                                      'Goal-Def', 'Penalty-Def']
        elif position=='Left Centre Back' or position=='Right Centre Back':
            columns_to_plot = ['Possession', 'Passing', 'Carrying', 'Heading', 'Intercepting',
                               'Tackling']
            columns_to_plot_labels = columns_to_plot
        elif position=='Right Back' or position=='Left Back':
            columns_to_plot = ['Assisting', 'Creating', 'Passing', 'Carrying', 'Intercepting',
                               'Tackling']
            columns_to_plot_labels = columns_to_plot
        elif position=='Defensive Midfielder' or position=='Central Midfielder':
            columns_to_plot = ['Possession', 'Creating', 'Passing', 'Carrying', 'Intercepting',
                               'Tackling']
            columns_to_plot_labels = columns_to_plot
        elif position=='Attacking Midfielder' or position=='Right Winger' or position=='Left Winger':
            columns_to_plot = ['Scoring', 'Assisting', 'Creating', 'Passing', 'Dribbling',
                               'Carrying']
            columns_to_plot_labels = columns_to_plot
        elif position=='Striker':
            columns_to_plot = ['Scoring', 'Assisting', 'Creating', 'Passing', 'Receiving',
                               'Heading']
            columns_to_plot_labels = columns_to_plot

        #extract the values for selected columns
        player_values = player[columns_to_plot]

        #create a dark grey figure
        fig, ax = plt.subplots(figsize=(39, 26), constrained_layout=True)
        fig.set_facecolor('#1D1D1D')

        #set the colors for each range
        colors = ['#FF6666', '#FFA366', '#FFFF99', '#99FF99']
        color_thresholds = [1, 25, 50, 75]

        #adjust the width of the bars and separation
        bar_width = 1.5
        bar_separation = 1.5

        #add labels on top of each bar with color coding
        for i, (col, value) in enumerate(zip(columns_to_plot_labels, player_values)):
            color_index = np.digitize(value, color_thresholds)-1
            rect = ax.bar(i*(bar_width+bar_separation), value, color=colors[color_index],
                          width=bar_width, capstyle='round', alpha=0.80)

            if not np.isnan(value):
                ax.text(i*(bar_width+bar_separation), value+0.75, str(int(value)),
                        ha='center', va='bottom', color='white', fontsize=75)

        #customize x-axis
        ax.tick_params(axis='x', labelcolor='white', labelsize=75, pad=14)
        ax.set_xticks(np.arange(len(columns_to_plot))*(bar_width+bar_separation))
        ax.set_xticklabels(columns_to_plot_labels, fontweight='bold')

        #customize y-axis
        ax.set_ylim(0, 100)
        plt.yticks([])
        plt.box(False)

        #save as an image
        save_directory = '/Users/pedroalexleite/Desktop/FPD/Generated/BarPLots'
        os.makedirs(save_directory, exist_ok=True)
        player_name = player['Name'].replace(" ", "")
        plt.savefig(os.path.join(save_directory, f'{player_name}BarPlot.png'))
        plt.close()

#bar_plots(players)


#HEAT MAP----------------------------------------------------------------------------------#


def heat_maps(players):
    for index, player in players.iterrows():
        #draw the pitch
        fig = plt.figure(figsize=(26, 18))
        fig.set_facecolor('#1D1D1D')
        ax = fig.add_subplot(1,1,1)

        #first part and the middle line
        plt.plot([0,0], [0,90], color='white', alpha=0.5, linewidth=5)
        plt.plot([0,130], [90,90], color='white', alpha=0.5, linewidth=5)
        plt.plot([130,130], [90,0], color='white', alpha=0.5, linewidth=5)
        plt.plot([130,0], [0,0], color='white', alpha=0.5, linewidth=5)
        #plt.plot([65,65],[0,90], color='white')

        #first big box
        plt.plot([16.5,16.5], [65,25], color='white', alpha=0.5, linewidth=5)
        plt.plot([0,16.5], [65,65], color='white', alpha=0.5, linewidth=5)
        plt.plot([16.5,0], [25,25], color='white', alpha=0.5, linewidth=5)

        #second big box
        plt.plot([130,113.5], [65,65], color='white', alpha=0.5, linewidth=5)
        plt.plot([113.5,113.5], [65,25], color='white', alpha=0.5, linewidth=5)
        plt.plot([113.5,130], [25,25], color='white', alpha=0.5, linewidth=5)

        #first pen box
        plt.plot([5.5,0.5], [36,36], color='white', alpha=0.5, linewidth=5)
        plt.plot([0,5.5], [54,54], color='white', alpha=0.5, linewidth=5)
        plt.plot([5.5,5.5], [54,36], color='white', alpha=0.5, linewidth=5)
        plt.plot([5.5,0.5], [36,36], color='white', alpha=0.5, linewidth=5)

        #second pen box
        plt.plot([130,124.5], [54,54], color='white', alpha=0.5, linewidth=5)
        plt.plot([124.5,124.5], [54,36], color='white', alpha=0.5, linewidth=5)
        plt.plot([124.5,130], [36,36], color='white', alpha=0.5, linewidth=5)
        '''
        #middle circle
        centreCircle = plt.Circle((65, 45), 9.15, color='white', fill=False)
        ax.add_patch(centreCircle)
        centreSpot = plt.Circle((65, 45), 0.8, color='white')
        ax.add_patch(centreSpot)

        #midle point
        leftPenSpot = plt.Circle((11, 45), 0.8, color='white)
        ax.add_patch(leftPenSpot)
        rightPenSpot = plt.Circle((119, 45), 0.8, color='white')
        ax.add_patch(rightPenSpot)
        '''
        #first arch
        leftArc = Arc((11, 45), height=18.3, width=18.3, angle=0, theta1=310, theta2=50,
                      color='white', linewidth=5)
        ax.add_patch(leftArc)

        #second arch
        rightArc = Arc((119, 45), height=18.3, width=18.3, angle=0, theta1=130, theta2=230,
                       color='white', linewidth=5)
        ax.add_patch(rightArc)

        #divide the pitch in 5 equal parts
        for i in range(1, 5):
            x_coord = i*(130/5)
            plt.plot([x_coord, x_coord], [0, 90], color='white', alpha=0.5, linewidth=5)

        #draw an arrow
        arrow = Arrow(55, 45, 20, 0, color='white', alpha=0.5, width=15)
        ax.add_patch(arrow)

        #fil each part
        position = str(player['Position']).strip()
        if position=='Goalkeeper':
            plt.fill_between([(1-1)*(130/5), 1*(130/5)], 0, 90, color='#99FF99', alpha=0.75)
            plt.fill_between([(2-1)*(130/5), 2*(130/5)], 0, 90, color='#FF6666', alpha=0.75)
            plt.fill_between([(3-1)*(130/5), 3*(130/5)], 0, 90, color='#FF6666', alpha=0.75)
            plt.fill_between([(4-1)*(130/5), 4*(130/5)], 0, 90, color='#FF6666', alpha=0.75)
            plt.fill_between([(5-1)*(130/5), 5*(130/5)], 0, 90, color='#FF6666', alpha=0.75)
        else:
            first = str(player['1st']).strip()
            if float(first)>=40:
                plt.fill_between([(1-1)*(130/5), 1*(130/5)], 0, 90, color='#99FF99', alpha=0.75)
            elif float(first)>=25 and float(first)<40:
                plt.fill_between([(1-1)*(130/5), 1*(130/5)], 0, 90, color='#FFFF99', alpha=0.75)
            elif float(first)>=10 and float(first)<25:
                plt.fill_between([(1-1)*(130/5), 1*(130/5)], 0, 90, color='#FFA366', alpha=0.75)
            else:
                plt.fill_between([(1-1)*(130/5), 1*(130/5)], 0, 90, color='#FF6666', alpha=0.75)

            second = str(player['2nd']).strip()
            if float(second)>=40:
                plt.fill_between([(2-1)*(130/5),2*(130/5)], 0, 90, color='#99FF99', alpha=0.75)
            elif float(second)>=25 and float(second)<40:
                plt.fill_between([(2-1)*(130/5),2*(130/5)], 0, 90, color='#FFFF99', alpha=0.75)
            elif float(second)>=10 and float(second)<25:
                plt.fill_between([(2-1)*(130/5),2*(130/5)], 0, 90, color='#FFA366', alpha=0.75)
            else:
                plt.fill_between([(2-1)*(130/5),2*(130/5)], 0, 90, color='#FF6666', alpha=0.75)

            third = str(player['3rd']).strip()
            if float(third)>=40:
                plt.fill_between([(3-1)*(130/5), 3*(130/5)], 0, 90, color='#99FF99', alpha=0.75)
            elif float(third)>=25 and float(third)<40:
                plt.fill_between([(3-1)*(130/5), 3*(130/5)], 0, 90, color='#FFFF99', alpha=0.75)
            elif float(third)>=10 and float(third)<25:
                plt.fill_between([(3-1)*(130/5), 3*(130/5)], 0, 90, color='#FFA366', alpha=0.75)
            else:
                plt.fill_between([(3-1)*(130/5), 3*(130/5)], 0, 90, color='#FF6666', alpha=0.75)

            fourth = str(player['4th']).strip()
            if float(fourth)>=40:
                plt.fill_between([(4-1)*(130/5), 4*(130/5)], 0, 90, color='#99FF99', alpha=0.75)
            elif float(fourth)>=25 and float(fourth)<40:
                plt.fill_between([(4-1)*(130/5), 4*(130/5)], 0, 90, color='#FFFF99', alpha=0.75)
            elif float(fourth)>=10 and float(fourth)<25:
                plt.fill_between([(4-1)*(130/5), 4*(130/5)], 0, 90, color='#FFA366', alpha=0.75)
            else:
                plt.fill_between([(4-1)*(130/5), 4*(130/5)], 0, 90, color='#FF6666', alpha=0.75)

            fifth = str(player['5th']).strip()
            if float(fifth)>=40:
                plt.fill_between([(5-1)*(130/5), 5*(130/5)], 0, 90, color='#99FF99', alpha=0.75)
            elif float(fifth)>=25 and float(fifth)<40:
                plt.fill_between([(5-1)*(130/5), 5*(130/5)], 0, 90, color='#FFFF99', alpha=0.75)
            elif float(fifth)>=10 and float(fifth)<25:
                plt.fill_between([(5-1)*(130/5), 5*(130/5)], 0, 90, color='#FFA366', alpha=0.75)
            else:
                plt.fill_between([(5-1)*(130/5), 5*(130/5)], 0, 90, color='#FF6666', alpha=0.75)

        plt.axis('off')

        #save as an image
        save_directory = '/Users/pedroalexleite/Desktop/FPD/Generated/Heatmaps'
        os.makedirs(save_directory, exist_ok=True)
        player_name = player['Name'].replace(" ", "")
        plt.savefig(os.path.join(save_directory, f'{player_name}HeatMap.png'),
                    bbox_inches='tight')
        plt.close()

#heat_maps(players)


#CONCLUSION--------------------------------------------------------------------------------#


bar_plots(players)
heat_maps(players)

end_time = time.time()
print("plots2.py took", int((end_time-start_time)/60), "minutes!")


#------------------------------------------------------------------------------------------#
