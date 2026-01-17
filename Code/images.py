#INTRODUCTION------------------------------------------------------------------------------#


#cd Desktop/FPD/Python
#Python3 images.py
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


#CROP INFORMATION----------------------------------------------------------------------------#


def crop_info():
<<<<<<< HEAD
    directory = '../Data/Images/Informations'
=======
    directory = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Informations'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
    crop_height = 30
    for filename in os.listdir(directory):
        if filename.endswith('.png'):
            filepath = os.path.join(directory, filename)
            with Image.open(filepath) as image:
                width, height = image.size
                left = 0
                top = 0
                right = width
                bottom = height-crop_height
                cropped_image = image.crop((left, top, right, bottom))
                cropped_image.save(filepath)

#crop_info()


#ROTATE THE HEAT MAP-----------------------------------------------------------------------#


def rotate_heatmaps():
<<<<<<< HEAD
    directory = '../Data/Images/HeatMaps'
=======
    directory = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/HeatMaps'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
    for filename in os.listdir(directory):
        if filename.endswith('.png'):
            filepath = os.path.join(directory, filename)
            with Image.open(filepath) as image:
                rotated_image = image.rotate(90, expand=True)
                rotated_image.save(filepath)

#rotate_heatmaps()


#HEADSHOT----------------------------------------------------------------------------------#


def head_shots(players):
    for index, player in players.iterrows():
        name = player['Name'].replace(" ", "")
        image_url = str(player['Image URL']).strip()
        response = requests.get(image_url, stream=True)

        if response.status_code == 200:
<<<<<<< HEAD
            save_directory = '../Data/Images/Headshots'
=======
            save_directory = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Headshots'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
            os.makedirs(save_directory, exist_ok=True)
            image_path = os.path.join(save_directory, f'{name}HeadShot.png')
            with open(image_path, "wb") as f:
                for chunk in response.iter_content(chunk_size=1024):
                    f.write(chunk)

#head_shots(players)


#REMOVE THE BACKGROUND---------------------------------------------------------------------#


def remove_background(input_path, output_path):
    input_image = Image.open(input_path)
    output_image = remove(input_image)
    output_image.save(output_path)

def remove_background_all_images(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".png"):
            input_path = os.path.join(directory, filename)
            output_path = os.path.join(directory, filename)
            remove_background(input_path, output_path)

<<<<<<< HEAD
directory_path = '../Data/Images/HeadShots'
=======
directory_path = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/HeadShots'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
#remove_background_all_images(directory_path)


#ADD BACKGROUND----------------------------------------------------------------------------#


def add_background(image_path, background_color=(38, 39, 48)):
    img = Image.open(image_path)
    width, height = img.size
    new_img = Image.new('RGB', (width, height), background_color)
    new_img.paste(img, (0, 0), img)

    return new_img

def add_background_to_all_images(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".png"):
            image_path = os.path.join(directory, filename)
            new_image = add_background(image_path)
            new_image.save(image_path)

<<<<<<< HEAD
directory_path = '../Data/Images/HeadShots'
=======
directory_path = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/HeadShots'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
#add_background_to_all_images(directory_path)


#ADD MARGIN--------------------------------------------------------------------------------#


def add_margin(image_path, margin_size):
    img = Image.open(image_path)
    width, height = img.size
    new_width = width+(2*margin_size)
    new_height = height+margin_size
    new_img = Image.new('RGB', (new_width, new_height), (38, 39, 48))
    new_img.paste(img, ((new_width-width)//2, new_height-height))

    return new_img

def add_margin_to_all_images(directory, margin_size):
    for filename in os.listdir(directory):
        if filename.endswith(".png"):
            image_path = os.path.join(directory, filename)
            new_image = add_margin(image_path, margin_size=margin_size)
            new_image.save(image_path)

<<<<<<< HEAD
directory_path = '../Data/Images/HeadShots'
=======
directory_path = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/HeadShots'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
#add_margin_to_all_images(directory_path, 9)


#HEADSHOT FOR THE PLAYERS THAT DON'T HAVE AN FBREF IMAGE-----------------------------------#


def head_shots2(players):
    for index, player in players.iterrows():
        name = player['Name'].replace(" ", "")
        image_url = str(player['Image URL']).strip()
        response = requests.get(image_url, stream=True)

        if response.status_code != 200:
            fig, ax = plt.subplots(figsize=(5, 5))
            fig.set_facecolor('#262730')
            ax.text(1/2, 1/2, "No\nImage", color='white', ha='center', va='center', weight='bold', fontsize=18)
            plt.xticks([])
            plt.yticks([])
            plt.box(False)

<<<<<<< HEAD
            save_directory = '../Data/Images/Headshots'
=======
            save_directory = '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Images/Headshots'
>>>>>>> c36c8515aed044de12ec29746ce26897464abde4
            os.makedirs(save_directory, exist_ok=True)
            player_name = player['Name'].replace(" ", "")
            plt.savefig(os.path.join(save_directory, f'{player_name}HeadShot.png'),
                        bbox_inches='tight')
            plt.close()

#head_shots2(players)


#CONCLUSION--------------------------------------------------------------------------------#


crop_info()
rotate_heatmaps()
head_shots(players)
remove_background_all_images(directory_path)
add_background_to_all_images(directory_path)
add_margin_to_all_images(directory_path, 9)
head_shots2(players)

end_time = time.time()
print("images.py took", int((end_time-start_time)/60), "minutes!")


#------------------------------------------------------------------------------------------#
