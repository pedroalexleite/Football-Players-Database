#INTRODUCTION------------------------------------------------------------------------------#


#cd Desktop/FPD/Python
#Python3 images2.py
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
<<<<<<< HEAD
players = pd.read_csv('../Data/Dataframes/players.csv')
=======
players = pd.read_csv('/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Dataframes/players.csv')
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
players.sort_values(by='Rating', ascending=False, inplace=True)


#MERGE BARPLOT AND HEATMAP-----------------------------------------------------------------#


def merge1(players):
    for index, player in players.iterrows():
        player_barplot = player['Name'].replace(" ", "")+"BarPlot.png"
        player_heatmap = player['Name'].replace(" ", "")+"HeatMap.png"

<<<<<<< HEAD
        directory_barplot = "../Data/Images/BarPlots/"+player_barplot
        directory_heatmap = "../Data/Images/HeatMaps/"+player_heatmap
=======
        directory_barplot = "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/BarPlots/"+player_barplot
        directory_heatmap = "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/HeatMaps/"+player_heatmap
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4

        image_barplot = Image.open(directory_barplot)
        image_heatmap = Image.open(directory_heatmap)

        image_heatmap_resized = image_heatmap.resize((int(image_heatmap.width*(image_barplot.height/image_heatmap.height)),
                                                     image_barplot.height))

        appended_image = Image.new('RGB', (image_barplot.width+image_heatmap_resized.width,
                                   image_barplot.height))
        appended_image.paste(image_barplot, (0, 0))
        appended_image.paste(image_heatmap_resized, (image_barplot.width, 0))

        #save as an image
<<<<<<< HEAD
        save_directory = '../Data/Images/Merge1'
=======
        save_directory = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Merge1'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
        os.makedirs(save_directory, exist_ok=True)
        player_name = player['Name'].replace(" ", "")
        appended_image.save(os.path.join(save_directory, f'{player_name}Merge1.png'))

#merge1(players)


#MERGE RATING AND HEADSHOT-----------------------------------------------------------------#


def merge2(players):
    for index, player in players.iterrows():
        player_headshot = player['Name'].replace(" ", "") + "HeadShot.png"
        player_rating = player['Name'].replace(" ", "") + "Rating.png"

<<<<<<< HEAD
        directory_headshot = "../Data/Images/HeadShots/" + player_headshot
        directory_rating = "../Data/Images/Ratings/" + player_rating
=======
        directory_headshot = "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/HeadShots/" + player_headshot
        directory_rating = "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Ratings/" + player_rating
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4

        image_headshot = Image.open(directory_headshot)
        image_rating = Image.open(directory_rating)

        width_rating, height_rating = image_rating.size
        width_headshot = width_rating
        height_headshot = int(image_headshot.size[1]*(width_headshot/image_headshot.size[0]))
        image_headshot_resized = image_headshot.resize((width_headshot, height_headshot))

        appended_image = Image.new('RGB', (width_rating, height_rating + height_headshot))
        appended_image.paste(image_headshot_resized, (0, 0))
        appended_image.paste(image_rating, (0, height_headshot))

        #save as an image
<<<<<<< HEAD
        save_directory = '../Data/Images/Merge2'
=======
        save_directory = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Merge2'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
        os.makedirs(save_directory, exist_ok=True)
        player_name = player['Name'].replace(" ", "")
        appended_image.save(os.path.join(save_directory, f'{player_name}Merge2.png'))

#merge2(players)


#MERGE RATING/HEADSHOT AND INFORMATION-----------------------------------------------------#


def merge3(players):
    for index, player in players.iterrows():
        player_merge2 = player['Name'].replace(" ", "") + "Merge2.png"
        player_information = player['Name'].replace(" ", "") + "Information.png"

<<<<<<< HEAD
        directory_merge2 = "../Data/Images/Merge2/" + player_merge2
        directory_information = "../Data/Images/Informations/" + player_information
=======
        directory_merge2 = "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Merge2/" + player_merge2
        directory_information = "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Informations/" + player_information
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4

        image_merge2 = Image.open(directory_merge2)
        image_information = Image.open(directory_information)

        width_ratio = image_merge2.width/image_information.width
        new_height = int(image_information.height*width_ratio)
        image_information_resized = image_information.resize((image_merge2.width, new_height))
        height_ratio = image_merge2.height/image_information_resized.height
        new_width = int(image_information_resized.width*height_ratio)
        image_information_final = image_information_resized.resize((new_width, image_merge2.height))
        width_merged = image_merge2.width+image_information_final.width
        height_merged = max(image_merge2.height, image_information_final.height)

        merged_image = Image.new("RGB", (width_merged, height_merged))
        merged_image.paste(image_merge2, (0, 0))
        merged_image.paste(image_information_final, (image_merge2.width, 0))

        #save the merged image
<<<<<<< HEAD
        save_directory = '../Data/Images/Merge3'
=======
        save_directory = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Merge3'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
        os.makedirs(save_directory, exist_ok=True)
        player_name = player['Name'].replace(" ", "")
        merged_image.save(os.path.join(save_directory, f'{player_name}Merge3.png'))

#merge3(players)


#MERGE RATING/HEADSHOT/INFORMATION AND BARPLOT/HEATMAP-------------------------------------#


def merge4(players):
    for index, player in players.iterrows():
        player_merge3 = player['Name'].replace(" ", "") + "Merge3.png"
        player_merge1 = player['Name'].replace(" ", "") + "Merge1.png"

<<<<<<< HEAD
        directory_merge3 = "../Data/Images/Merge3/" + player_merge3
        directory_merge1 = "../Data/Images/Merge1/" + player_merge1
=======
        directory_merge3 = "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Merge3/" + player_merge3
        directory_merge1 = "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Merge1/" + player_merge1
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4

        image_merge3 = Image.open(directory_merge3)
        image_merge1 = Image.open(directory_merge1)

        width_merge3, height_merge3 = image_merge3.size
        width_merge1 = width_merge3
        image_merge1_resized = image_merge1.resize((width_merge1, int(image_merge1.height * (width_merge1 / image_merge1.width))))
        width_merged = max(width_merge3, width_merge1)
        height_merged = height_merge3 + image_merge1_resized.height

        merged_image = Image.new("RGB", (width_merged, height_merged))
        merged_image.paste(image_merge3, (0, 0))
        merged_image.paste(image_merge1_resized, (0, height_merge3))

        #save the card
<<<<<<< HEAD
        save_directory = '../Data/Images/Cards'
=======
        save_directory = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Cards'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
        os.makedirs(save_directory, exist_ok=True)
        player_name = player['Name'].replace(" ", "")
        merged_image.save(os.path.join(save_directory, f'{player_name}Card.png'))

#merge4(players)


#ROUND CORNERS-----------------------------------------------------------------------------#


def round_corners(players):
    for index, player in players.iterrows():
        player_card = player['Name'].replace(" ", "") + "Card.png"
<<<<<<< HEAD
        directory_card = "../Data/Images/Cards/"+player_card
=======
        directory_card = "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Cards/"+player_card
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
        image_card = Image.open(directory_card)

        rad = 50
        circle = Image.new('L', (rad*2, rad*2), 0)
        draw = ImageDraw.Draw(circle)
        draw.ellipse((0, 0, rad*2-1, rad*2-1), fill=255)
        alpha = Image.new('L', image_card.size, 255)
        w, h = image_card.size
        alpha.paste(circle.crop((0, 0, rad, rad)), (0, 0))
        alpha.paste(circle.crop((0, rad, rad, rad*2)), (0, h-rad))
        alpha.paste(circle.crop((rad, 0, rad*2, rad)), (w-rad, 0))
        alpha.paste(circle.crop((rad, rad, rad*2, rad*2)), (w-rad, h-rad))
        image_card.putalpha(alpha)

        #save the rounded image
<<<<<<< HEAD
        save_directory = '../Data/Images/Cards'
=======
        save_directory = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Cards'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
        os.makedirs(save_directory, exist_ok=True)
        player_name = player['Name'].replace(" ", "")
        image_card.save(os.path.join(save_directory, f'{player_name}Card.png'))

#round_corners(players)


#ADD MARGIN--------------------------------------------------------------------------------#


def add_margin(players):
    for index, player in players.iterrows():
        player_card = player['Name'].replace(" ", "") + "Card.png"
<<<<<<< HEAD
        directory_card = "../Data/Images/Cards/"+player_card
=======
        directory_card = "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Cards/"+player_card
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
        image_card = Image.open(directory_card).convert("RGBA")

        margin_size = 10
        radius = 50
        margin_color = (102, 204, 255, 255)

        width, height = image_card.size
        new_width = width+2*margin_size
        new_height = height+2*margin_size

        new_image = Image.new("RGBA", (new_width, new_height), (0, 0, 0, 0))
        draw = ImageDraw.Draw(new_image)
        draw.rounded_rectangle((0, 0, new_width, new_height), radius, fill=margin_color)
        new_image.paste(image_card, (margin_size, margin_size), mask=image_card)

        #save with the margin
<<<<<<< HEAD
        save_directory = '../Data/Images/Cards'
=======
        save_directory = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Cards'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
        os.makedirs(save_directory, exist_ok=True)
        player_name = player['Name'].replace(" ", "")
        output_filename = os.path.join(save_directory, f'{player_name}Card.png')
        new_image.save(output_filename)


#add_margin(players)


#CONCLUSION--------------------------------------------------------------------------------#


merge1(players)
merge2(players)
merge3(players)
merge4(players)
round_corners(players)
add_margin(players)

end_time = time.time()
print("images2.py took", int((end_time-start_time)/60), "minutes!")


#------------------------------------------------------------------------------------------#
