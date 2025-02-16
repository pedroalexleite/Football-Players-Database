#INTRODUCTION------------------------------------------------------------------------------#


#cd Desktop/FPD/Python
#Python3 plots.py
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


#RATING------------------------------------------------------------------------------------#


def ratings(players):
    for index, player in players.iterrows():
        #extract the value for the selected column
        rating = player['Rating']

        #set the color
        if rating<65:
            color = '#FF6666'
        if rating>=65 and rating<75:
            color = '#FFA366'
        if rating>=75 and rating<85:
            color = '#FFFF99'
        if rating>=85:
            color = '#99FF99'

        plt.clf()
        fig, ax = plt.subplots(figsize=(13, 68.4))
        fig.set_facecolor('#1D1D1D')

        bb = mtransforms.Bbox([[0.6, 0.15], [2.15, 0.35]])
        alpha = 0.8
        color = (int(color[1:3], 16)/255, int(color[3:5], 16)/255, int(color[5:], 16)/255, alpha)
        p_fancy = FancyBboxPatch((bb.xmin, bb.ymin),
                                 abs(bb.width), abs(bb.height),
                                 boxstyle="round,pad=0.1",
                                 facecolor=color, linewidth=0)

        ax.add_patch(p_fancy)

        p_fancy.set_boxstyle("round,pad=0.1, rounding_size=0.23")

        text_x = (bb.xmin+bb.xmax)/2
        text_y = (bb.ymin+bb.ymax)/2
        ax.text(text_x, text_y, rating, color='black',
                ha='center', va='center', weight='bold', fontsize=50)

        ax.set_facecolor('#1D1D1D')
        ax.set_xlim(0., 2.75)
        ax.set_ylim(0., 0.5)
        ax.set_aspect(1.)

        for spine in ax.spines.values():
            spine.set_edgecolor('#1D1D1D')

        ax.set_facecolor('#1D1D1D')
        ax.set_xlim(0., 2.75)
        ax.set_ylim(0., 0.5)
        ax.set_aspect(1.)

        for spine in ax.spines.values():
            spine.set_edgecolor('#1D1D1D')

        plt.xticks([])
        plt.yticks([])

        #save as an image
        save_directory = '/Users/pedroalexleite/Desktop/FPD/Generated/Ratings'
        os.makedirs(save_directory, exist_ok=True)
        player_name = player['Name'].replace(" ", "")
        plt.savefig(os.path.join(save_directory, f'{player_name}Rating.png'), bbox_inches='tight')
        plt.close()

#ratings(players)


#INFORMATION-------------------------------------------------------------------------------#


def information(players):
    for index, player in players.iterrows():
        #create a dark grey figure
        fig, ax = plt.subplots(figsize=(23.613, 15), constrained_layout=True)
        fig.set_facecolor('#1D1D1D')
        rectangle = Rectangle((0, 0), 1, 1, edgecolor='#1D1D1D', facecolor='#1D1D1D')

        #add text
        initial_name = str(player['Name']).strip()
        if len(initial_name)>16:
            name = initial_name.split()[-1]
            if len(name)>16:
                name = initial_name.split()[0]
        else:
            name = initial_name
        ax.text(0.051, 7/8, "Name: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.195-0.03, 7/8, name, color='white', ha='left', va='center', fontsize=50)

        country = str(player['Country']).strip()
        ax.text(0.051, 6/8, "Country: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.231-0.03, 6/8, country, color='white', ha='left', va='center', fontsize=50)

        league = str(player['League']).strip()
        if league == 'Série A':
            league = "Brasileirão"
        if league == 'Copa de la Liga':
            league = 'Liga Profesional'
        ax.text(0.051, 5/8, "League: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.20-0.01, 5/8, league, color='white', ha='left', va='center', fontsize=50)

        initial_club = str(player['Club']).strip()
        if len(initial_club)>16:
            club = initial_club.split()[0]
            if len(club)>16:
                club = initial_club.split()[-1]
        else:
            club = initial_club
        ax.text(0.051, 4/8, "Club: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.173-0.03, 4/8, club, color='white', ha='left', va='center', fontsize=50)

        ax.text(0.051, 3/8, "Season: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.221-0.03, 3/8, "2023/2024", color='white', ha='left', va='center', fontsize=50)

        position = str(player['Position']).strip()
        if position == 'Goalkeeper':
            position = 'GK'
        if position == 'Left Centre Back':
            position = 'LCB'
        if position == 'Right Centre Back':
            position = 'RCB'
        if position == 'Left Back':
            position = 'LB'
        if position == 'Right Back':
            position = 'RB'
        if position == 'Defensive Midfielder':
            position = 'DM'
        if position == 'Central Midfielder':
            position = 'CM'
        if position == 'Attacking Midfielder':
            position = 'AM'
        if position == 'Left Winger':
            position = 'LW'
        if position == 'Right Winger':
            position = 'RW'
        if position == 'Striker':
            position = 'ST'
        ax.text(0.051, 2/8, "Position: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.234-0.03, 2/8, position, color='white', ha='left', va='center', fontsize=50)

        role = str(player['Role']).strip()
        ax.text(0.051, 1/8, "Role: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.172-0.03, 1/8, role, color='white', ha='left', va='center',fontsize=50)

        age = str(player['Age']).strip()
        ax.text(0.551, 7/8, "Age: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.662-0.03, 7/8, age, color='white', ha='left', va='center', fontsize=50)

        height = '{:.2f}'.format(player['Height'])
        ax.text(0.551, 6/8, "Height: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.69-0.01, 6/8, height, color='white', ha='left', va='center', fontsize=50)

        foot = str(player['Preferred Foot']).strip()
        ax.text(0.551, 5/8, "Foot: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.672-0.03, 5/8, foot, color='white', ha='left', va='center', fontsize=50)

        minutes = str(player['Minutes Played']).strip()
        ax.text(0.551, 4/8, "Minutes: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.730-0.03, 4/8, minutes, color='white', ha='left', va='center', fontsize=50)

        value = str(player['Market Value']).strip()
        ax.text(0.551, 3/8, "Value: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.690-0.03, 3/8, value, color='white', ha='left', va='center', fontsize=50)

        wages = player['Weekly Wages']
        if pd.isna(wages) or wages == 'N/A':
            wages_str = 'N/A'
        else:
            wages_str = str(wages).strip()
        ax.text(0.551, 2/8, "Wages: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.69-0.01, 2/8, wages_str, color='white', ha='left', va='center', fontsize=50)

        contract = player['Contract Expiration']
        if np.isnan(contract):
            contract = 'N/A'
        else:
            contract = str(int(contract))
        ax.text(0.551, 1/8, "Contract: ", color='white', ha='left', va='center', weight='bold', fontsize=50)
        ax.text(0.742-0.03, 1/8, contract, color='white', ha='left', va='center', fontsize=50)

        #axis
        ax.set_xlim(0, 1)
        ax.set_ylim(0, 1)
        plt.axis('off')

        #save as an image
        save_directory = '/Users/pedroalexleite/Desktop/FPD/Generated/Informations'
        os.makedirs(save_directory, exist_ok=True)
        player_name = player['Name'].replace(" ", "")
        plt.savefig(os.path.join(save_directory, f'{player_name}Information.png'))
        plt.close()

#information(players)


#CONCLUSION--------------------------------------------------------------------------------#


ratings(players)
information(players)

end_time = time.time()
print("plots.py took", int((end_time-start_time)/60), "minutes!")


#------------------------------------------------------------------------------------------#
