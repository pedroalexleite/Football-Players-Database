#INTRODUCTION------------------------------------------------------------------------------#


import time
import pandas as pd
import numpy as np
import os
import string
from scipy.stats import percentileofscore, norm
import matplotlib.pyplot as plt
from scipy.stats import norm
import warnings

start_time = time.time()

#suppress future warnings
warnings.filterwarnings('ignore', category=FutureWarning)

#function to export to a csv file
def simple_export(df, fileName):
    current_dir = os.getcwd()
    exports_folder = current_dir
    if not os.path.exists(exports_folder):
        os.makedirs(exports_folder)
    full_path = os.path.join(exports_folder, fileName)
    df.to_csv(full_path, sep=',', index=False, encoding='utf-8')


#OUTFIELD PLAYERS DATAFRAME----------------------------------------------------------------#


#our dataframe with all information, for the oufield players
outfieldplayers = pd.read_csv('/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Dataframes/outfieldplayers.csv')

#we only want to keep the essential columns
selected_columns = [
    'Player_STANDARD', 'Age_STANDARD', 'player_height_mtrs_TM', 'player_foot_TM',
    'comp_name_TM', 'Squad_STANDARD', 'player_nationality_TM', 'player_position_TM',
    'Min_Playing_Time_STANDARD', 'player_market_value_euro_TM', 'WeeklyWageEUR_WAGES',
    'contract_expiry_TM', 'Def Pen_Touches_POSSESSION', 'Def 3rd_Touches_POSSESSION',
    'Mid 3rd_Touches_POSSESSION', 'Att 3rd_Touches_POSSESSION', 'Att Pen_Touches_POSSESSION',
    'G_minus_PK_STANDARD', 'xA_Expected_PASSING', 'PrgR_Receiving_POSSESSION',
    'Succ_Take_Ons_POSSESSION', 'KP_PASSING', 'PrgP_Progression_STANDARD',
    'PrgC_Progression_STANDARD', 'Touches_Touches_POSSESSION', 'Won_Aerial_Duels_MISC',
    'Int_DEFENSE', 'TklW_Tackles_DEFENSE', 'UrlFBref'
]
dataframe = outfieldplayers[selected_columns].copy()

#rename the columns
dataframe.rename(columns={'Player_STANDARD': 'Name', 'Age_STANDARD': 'Age',
                          'player_height_mtrs_TM': 'Height', 'player_foot_TM': 'Preferred Foot',
                          'comp_name_TM': 'League', 'Squad_STANDARD': 'Club', 'player_nationality_TM': 'Country',
                          'player_position_TM': 'Position', 'Min_Playing_Time_STANDARD' : 'Minutes Played',
                          'player_market_value_euro_TM': 'Market Value', 'WeeklyWageEUR_WAGES': 'Weekly Wages',
                          'contract_expiry_TM': 'Contract Expiration', 'Def Pen_Touches_POSSESSION': '1st',
                          'Def 3rd_Touches_POSSESSION': '2nd', 'Mid 3rd_Touches_POSSESSION': '3rd',
                          'Att 3rd_Touches_POSSESSION': '4th', 'Att Pen_Touches_POSSESSION': '5th',
                          'G_minus_PK_STANDARD': 'Scoring', 'xA_Expected_PASSING': 'Assisting',
                          'PrgR_Receiving_POSSESSION': 'Receiving', 'Succ_Take_Ons_POSSESSION': 'Dribbling',
                          'KP_PASSING': 'Creating', 'PrgP_Progression_STANDARD': 'Passing',
                          'PrgC_Progression_STANDARD': 'Carrying', 'Touches_Touches_POSSESSION': 'Possession',
                          'Won_Aerial_Duels_MISC': 'Heading', 'Int_DEFENSE': 'Intercepting',
                          'TklW_Tackles_DEFENSE': 'Tackling', 'UrlFBref': 'URL'
                          }, inplace=True)

#we want the stats per minute
dataframe['Scoring'] = dataframe['Scoring']/dataframe['Minutes Played']
dataframe['Assisting'] = dataframe['Assisting']/dataframe['Minutes Played']
dataframe['Receiving'] = dataframe['Receiving']/dataframe['Minutes Played']
dataframe['Dribbling'] = dataframe['Dribbling']/dataframe['Minutes Played']
dataframe['Creating'] = dataframe['Creating']/dataframe['Minutes Played']
dataframe['Passing'] = dataframe['Passing']/dataframe['Minutes Played']
dataframe['Carrying'] = dataframe['Carrying']/dataframe['Minutes Played']
dataframe['Possession'] = dataframe['Possession']/dataframe['Minutes Played']
dataframe['Heading'] = dataframe['Heading']/dataframe['Minutes Played']
dataframe['Intercepting'] = dataframe['Intercepting']/dataframe['Minutes Played']
dataframe['Tackling'] = dataframe['Tackling']/dataframe['Minutes Played']

#lets replace some more rare positions, for the most normal ones
unique_positions = dataframe['Position'].unique()
#print(unique_positions)
dataframe['Position'] = dataframe['Position'].replace('Centre-Back', 'Centre Back')
dataframe['Position'] = dataframe['Position'].replace('Right-Back', 'Right Back')
dataframe['Position'] = dataframe['Position'].replace('Left-Back', 'Left Back')
dataframe['Position'] = dataframe['Position'].replace('Right Midfield', 'Right Winger')
dataframe['Position'] = dataframe['Position'].replace('Left Midfield', 'Left Winger')
dataframe['Position'] = dataframe['Position'].replace('Second Striker', 'Attacking Midfield')
dataframe['Position'] = dataframe['Position'].replace('Centre-Forward', 'Striker')
unique_positions = dataframe['Position'].unique()
#print(unique_positions)

#divide the dataframe in separate dataframes by position, for the oufield players
position_dataframes = {}
for position in unique_positions:
    position_dataframes[position] = dataframe[dataframe['Position'] == position]
centre_backs = position_dataframes['Centre Back']
left_backs = position_dataframes['Left Back']
right_backs = position_dataframes['Right Back']
defensive_midfielders = position_dataframes['Defensive Midfield']
central_midfielders = position_dataframes['Central Midfield']
attacking_midfielders = position_dataframes['Attacking Midfield']
left_wingers = position_dataframes['Left Winger']
right_wingers = position_dataframes['Right Winger']
strikers = position_dataframes['Striker']

#calculate the percentil of each attribute, for the centre backs
centre_backs = centre_backs.copy()
centre_backs['Scoring'] = round(centre_backs['Scoring'].rank(pct=True)*100)
centre_backs['Assisting'] = round(centre_backs['Assisting'].rank(pct=True)*100)
centre_backs['Receiving'] = round(centre_backs['Receiving'].rank(pct=True)*100)
centre_backs['Dribbling'] = round(centre_backs['Dribbling'].rank(pct=True)*100)
centre_backs['Creating'] = round(centre_backs['Creating'].rank(pct=True)*100)
centre_backs['Passing'] = round(centre_backs['Passing'].rank(pct=True)*100)
centre_backs['Carrying'] = round(centre_backs['Carrying'].rank(pct=True)*100)
centre_backs['Possession'] = round(centre_backs['Possession'].rank(pct=True)*100)
centre_backs['Heading'] = round(centre_backs['Heading'].rank(pct=True)*100)
centre_backs['Intercepting'] = round(centre_backs['Intercepting'].rank(pct=True)*100)
centre_backs['Tackling'] = round(centre_backs['Tackling'].rank(pct=True)*100)

#calculate the percentil of each attribute, for the left backs
left_backs = left_backs.copy()
left_backs['Scoring'] = round(left_backs['Scoring'].rank(pct=True)*100)
left_backs['Assisting'] = round(left_backs['Assisting'].rank(pct=True)*100)
left_backs['Receiving'] = round(left_backs['Receiving'].rank(pct=True)*100)
left_backs['Dribbling'] = round(left_backs['Dribbling'].rank(pct=True)*100)
left_backs['Creating'] = round(left_backs['Creating'].rank(pct=True)*100)
left_backs['Passing'] = round(left_backs['Passing'].rank(pct=True)*100)
left_backs['Carrying'] = round(left_backs['Carrying'].rank(pct=True)*100)
left_backs['Possession'] = round(left_backs['Possession'].rank(pct=True)*100)
left_backs['Heading'] = round(left_backs['Heading'].rank(pct=True)*100)
left_backs['Intercepting'] = round(left_backs['Intercepting'].rank(pct=True)*100)
left_backs['Tackling'] = round(left_backs['Tackling'].rank(pct=True)*100)

#calculate the percentil of each attribute, for the right backs
right_backs = right_backs.copy()
right_backs['Scoring'] = round(right_backs['Scoring'].rank(pct=True)*100)
right_backs['Assisting'] = round(right_backs['Assisting'].rank(pct=True)*100)
right_backs['Receiving'] = round(right_backs['Receiving'].rank(pct=True)*100)
right_backs['Dribbling'] = round(right_backs['Dribbling'].rank(pct=True)*100)
right_backs['Creating'] = round(right_backs['Creating'].rank(pct=True)*100)
right_backs['Passing'] = round(right_backs['Passing'].rank(pct=True)*100)
right_backs['Carrying'] = round(right_backs['Carrying'].rank(pct=True)*100)
right_backs['Possession'] = round(right_backs['Possession'].rank(pct=True)*100)
right_backs['Heading'] = round(right_backs['Heading'].rank(pct=True)*100)
right_backs['Intercepting'] = round(right_backs['Intercepting'].rank(pct=True)*100)
right_backs['Tackling'] = round(right_backs['Tackling'].rank(pct=True)*100)

#calculate the percentil of each attribute, for the defensive midfielders
defensive_midfielders = defensive_midfielders.copy()
defensive_midfielders['Scoring'] = round(defensive_midfielders['Scoring'].rank(pct=True)*100)
defensive_midfielders['Assisting'] = round(defensive_midfielders['Assisting'].rank(pct=True)*100)
defensive_midfielders['Receiving'] = round(defensive_midfielders['Receiving'].rank(pct=True)*100)
defensive_midfielders['Dribbling'] = round(defensive_midfielders['Dribbling'].rank(pct=True)*100)
defensive_midfielders['Creating'] = round(defensive_midfielders['Creating'].rank(pct=True)*100)
defensive_midfielders['Passing'] = round(defensive_midfielders['Passing'].rank(pct=True)*100)
defensive_midfielders['Carrying'] = round(defensive_midfielders['Carrying'].rank(pct=True)*100)
defensive_midfielders['Possession'] = round(defensive_midfielders['Possession'].rank(pct=True)*100)
defensive_midfielders['Heading'] = round(defensive_midfielders['Heading'].rank(pct=True)*100)
defensive_midfielders['Intercepting'] = round(defensive_midfielders['Intercepting'].rank(pct=True)*100)
defensive_midfielders['Tackling'] = round(defensive_midfielders['Tackling'].rank(pct=True)*100)

#calculate the percentil of each attribute, for the central midfielders
central_midfielders = central_midfielders.copy()
central_midfielders['Scoring'] = round(central_midfielders['Scoring'].rank(pct=True)*100)
central_midfielders['Assisting'] = round(central_midfielders['Assisting'].rank(pct=True)*100)
central_midfielders['Receiving'] = round(central_midfielders['Receiving'].rank(pct=True)*100)
central_midfielders['Dribbling'] = round(central_midfielders['Dribbling'].rank(pct=True)*100)
central_midfielders['Creating'] = round(central_midfielders['Creating'].rank(pct=True)*100)
central_midfielders['Passing'] = round(central_midfielders['Passing'].rank(pct=True)*100)
central_midfielders['Carrying'] = round(central_midfielders['Carrying'].rank(pct=True)*100)
central_midfielders['Possession'] = round(central_midfielders['Possession'].rank(pct=True)*100)
central_midfielders['Heading'] = round(central_midfielders['Heading'].rank(pct=True)*100)
central_midfielders['Intercepting'] = round(central_midfielders['Intercepting'].rank(pct=True)*100)
central_midfielders['Tackling'] = round(central_midfielders['Tackling'].rank(pct=True)*100)

#calculate the percentil of each attribute, for the attacking midfielders
attacking_midfielders = attacking_midfielders.copy()
attacking_midfielders['Scoring'] = round(attacking_midfielders['Scoring'].rank(pct=True)*100)
attacking_midfielders['Assisting'] = round(attacking_midfielders['Assisting'].rank(pct=True)*100)
attacking_midfielders['Receiving'] = round(attacking_midfielders['Receiving'].rank(pct=True)*100)
attacking_midfielders['Dribbling'] = round(attacking_midfielders['Dribbling'].rank(pct=True)*100)
attacking_midfielders['Creating'] = round(attacking_midfielders['Creating'].rank(pct=True)*100)
attacking_midfielders['Passing'] = round(attacking_midfielders['Passing'].rank(pct=True)*100)
attacking_midfielders['Carrying'] = round(attacking_midfielders['Carrying'].rank(pct=True)*100)
attacking_midfielders['Possession'] = round(attacking_midfielders['Possession'].rank(pct=True)*100)
attacking_midfielders['Heading'] = round(attacking_midfielders['Heading'].rank(pct=True)*100)
attacking_midfielders['Intercepting'] = round(attacking_midfielders['Intercepting'].rank(pct=True)*100)
attacking_midfielders['Tackling'] = round(attacking_midfielders['Tackling'].rank(pct=True)*100)

#calculate the percentil of each attribute, for the left wingers
left_wingers = left_wingers.copy()
left_wingers['Scoring'] = round(left_wingers['Scoring'].rank(pct=True)*100)
left_wingers['Assisting'] = round(left_wingers['Assisting'].rank(pct=True)*100)
left_wingers['Receiving'] = round(left_wingers['Receiving'].rank(pct=True)*100)
left_wingers['Dribbling'] = round(left_wingers['Dribbling'].rank(pct=True)*100)
left_wingers['Creating'] = round(left_wingers['Creating'].rank(pct=True)*100)
left_wingers['Passing'] = round(left_wingers['Passing'].rank(pct=True)*100)
left_wingers['Carrying'] = round(left_wingers['Carrying'].rank(pct=True)*100)
left_wingers['Possession'] = round(left_wingers['Possession'].rank(pct=True)*100)
left_wingers['Heading'] = round(left_wingers['Heading'].rank(pct=True)*100)
left_wingers['Intercepting'] = round(left_wingers['Intercepting'].rank(pct=True)*100)
left_wingers['Tackling'] = round(left_wingers['Tackling'].rank(pct=True)*100)

#calculate the percentil of each attribute, for the right wingers
right_wingers = right_wingers.copy()
right_wingers['Scoring'] = round(right_wingers['Scoring'].rank(pct=True)*100)
right_wingers['Assisting'] = round(right_wingers['Assisting'].rank(pct=True)*100)
right_wingers['Receiving'] = round(right_wingers['Receiving'].rank(pct=True)*100)
right_wingers['Dribbling'] = round(right_wingers['Dribbling'].rank(pct=True)*100)
right_wingers['Creating'] = round(right_wingers['Creating'].rank(pct=True)*100)
right_wingers['Passing'] = round(right_wingers['Passing'].rank(pct=True)*100)
right_wingers['Carrying'] = round(right_wingers['Carrying'].rank(pct=True)*100)
right_wingers['Possession'] = round(right_wingers['Possession'].rank(pct=True)*100)
right_wingers['Heading'] = round(right_wingers['Heading'].rank(pct=True)*100)
right_wingers['Intercepting'] = round(right_wingers['Intercepting'].rank(pct=True)*100)
right_wingers['Tackling'] = round(right_wingers['Tackling'].rank(pct=True)*100)

#calculate the percentil of each attribute, for the strikers
strikers = strikers.copy()
strikers['Scoring'] = round(strikers['Scoring'].rank(pct=True)*100)
strikers['Assisting'] = round(strikers['Assisting'].rank(pct=True)*100)
strikers['Receiving'] = round(strikers['Receiving'].rank(pct=True)*100)
strikers['Dribbling'] = round(strikers['Dribbling'].rank(pct=True)*100)
strikers['Creating'] = round(strikers['Creating'].rank(pct=True)*100)
strikers['Passing'] = round(strikers['Passing'].rank(pct=True)*100)
strikers['Carrying'] = round(strikers['Carrying'].rank(pct=True)*100)
strikers['Possession'] = round(strikers['Possession'].rank(pct=True)*100)
strikers['Heading'] = round(strikers['Heading'].rank(pct=True)*100)
strikers['Intercepting'] = round(strikers['Intercepting'].rank(pct=True)*100)
strikers['Tackling'] = round(strikers['Tackling'].rank(pct=True)*100)

#merge every dataframe, for the outfieldplayers
new_outfieldplayers = pd.concat([centre_backs, left_backs, right_backs, defensive_midfielders,
                                central_midfielders, attacking_midfielders, left_wingers,
                                right_wingers, strikers])

#add the columns of the goalkeepers
columns_to_add = ['Cross-Stopping', 'Exiting', 'Penalty-Defending', 'Shot-Defending', 'Goal-Defending']
for column in columns_to_add:
    new_outfieldplayers[column] = np.nan

#simple_export(new_outfieldplayers, 'new_outfieldplayers.csv')


#GOALKEEPERS DATAFRAME---------------------------------------------------------------------#


#our dataframe with all information, for the goalkeepers
goalkeepers = pd.read_csv('/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Dataframes/goalkeepers.csv', sep=',', low_memory=False)

#we only want to keep the essential columns
selected_columns = [
    'Player_KEEPER', 'Age_KEEPER', 'player_height_mtrs_TM', 'player_foot_TM',
    'comp_name_TM', 'Squad_KEEPER', 'player_nationality_TM', 'player_position_TM',
    'Min_Playing_Time_KEEPER', 'player_market_value_euro_TM', 'WeeklyWageEUR_WAGES',
    'contract_expiry_TM', 'Cmp_percent_Launched_KEEPER_ADV', 'Stp_Crosses_KEEPER_ADV',
    'Player_NumOPA_Sweeper_KEEPER_ADV', 'Save_percent_Kicks_KEEPER', 'Save_percent_KEEPER',
    'PSxGPlus_Minus_Expected_KEEPER_ADV', 'UrlFBref'
]
dataframe2 = goalkeepers[selected_columns].copy()

#rename the columns
dataframe2.rename(columns={'Player_KEEPER': 'Name', 'Age_KEEPER': 'Age',
                           'player_height_mtrs_TM': 'Height', 'player_foot_TM': 'Preferred Foot',
                           'comp_name_TM': 'League', 'Squad_KEEPER': 'Club', 'player_nationality_TM': 'Country',
                           'player_position_TM': 'Position', 'Min_Playing_Time_KEEPER' : 'Minutes Played',
                           'player_market_value_euro_TM': 'Market Value', 'WeeklyWageEUR_WAGES': 'Weekly Wages',
                           'contract_expiry_TM': 'Contract Expiration', 'Cmp_percent_Launched_KEEPER_ADV': 'Passing',
                           'Stp_Crosses_KEEPER_ADV': 'Cross-Stopping', 'Player_NumOPA_Sweeper_KEEPER_ADV': 'Exiting',
                           'Save_percent_Kicks_KEEPER': 'Penalty-Defending', 'Save_percent_KEEPER': 'Shot-Defending',
                           'PSxGPlus_Minus_Expected_KEEPER_ADV': 'Goal-Defending', 'UrlFBref': 'URL'
                           }, inplace=True)

#we want the stats per minute
dataframe2['Cross-Stopping'] = dataframe2['Cross-Stopping']/dataframe2['Minutes Played']
dataframe2['Exiting'] = dataframe2['Exiting']/dataframe2['Minutes Played']
dataframe2['Goal-Defending'] = dataframe2['Goal-Defending']/dataframe2['Minutes Played']

#add the columns of the outfield players
columns_to_add = ['Scoring', 'Assisting', 'Receiving', 'Dribbling', 'Creating',
                  'Carrying', 'Possession', 'Heading', 'Intercepting', 'Tackling',
                  '1st', '2nd', '3rd', '4th', '5th'
                 ]
for column in columns_to_add:
    dataframe2[column] = np.nan

#calculate the percentil of each attribute, for the goalkeepers
new_goalkeepers = dataframe2.copy()
new_goalkeepers['Passing'] = round(new_goalkeepers['Passing'].rank(pct=True)*100)
new_goalkeepers['Cross-Stopping'] = round(new_goalkeepers['Cross-Stopping'].rank(pct=True)*100)
new_goalkeepers['Exiting'] = round(new_goalkeepers['Exiting'].rank(pct=True)*100)
new_goalkeepers['Penalty-Defending'] = round(new_goalkeepers['Penalty-Defending'].rank(pct=True)*100)
new_goalkeepers['Shot-Defending'] = round(new_goalkeepers['Shot-Defending'].rank(pct=True)*100)
new_goalkeepers['Goal-Defending'] = round(new_goalkeepers['Goal-Defending'].rank(pct=True)*100)

#simple_export(new_goalkeepers, 'new_goalkeepers.csv')


#MERGE OUTFIELD PLAYERS AND GOALKEERPS DATABASES-------------------------------------------#


#concatenat the dataframes for the oufield players and goalkeepers
players = pd.concat([new_outfieldplayers, new_goalkeepers])

#simple_export(players, '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Dataframes/players.csv')


#DATA CLEANING-----------------------------------------------------------------------------#

#reformart some countries
players['Country'] = players['Country'].replace('Korea, South', 'South Korea')
players['Country'] = players['Country'].replace("Cote d'Ivoire", "Ivory Coast")
players['Country'] = players['Country'].replace("Türkiye", "Turkey")
players['Country'] = players['Country'].replace("The Gambia", "Gambia")

#convert "Tiago santos" to "Tiago Santos"
players['Name'] = players['Name'].apply(lambda x: x.title())

#convert the 'Age' from 32-203 to 32
players['Age'] = players['Age'].str.extract(r'(\d{2})')
players['Age'] = pd.to_numeric(players['Age'], errors='coerce')

#convert the 'Preferred Foot' from righ to Right
players['Preferred Foot'] = players['Preferred Foot'].str.capitalize()
players['Preferred Foot'] = players['Preferred Foot'].str.strip()
players['Preferred Foot'].replace('', 'N/A', inplace=True)
players['Preferred Foot'].fillna('N/A', inplace=True)

#convert the "Height" from 1.8 to 1.80
players['Height'] = players['Height'].map(lambda x: f'{float(x):.2f}' if pd.notnull(x) else x)
players['Height'] = players['Height'].str.strip()
players['Height'].replace('', 'N/A', inplace=True)
players['Height'].fillna('N/A', inplace=True)

#convert "LaLiga" to "La Liga" in "League"
players['League'].replace('LaLiga', 'La Liga', inplace=True)

#convert "Defensive Midfield" to "Defensive Midfielder", ..., in "Position"
players['Position'].replace('Defensive Midfield', 'Defensive Midfielder', inplace=True)
players['Position'].replace('Central Midfield', 'Central Midfielder', inplace=True)
players['Position'].replace('Attacking Midfield', 'Attacking Midfielder', inplace=True)

#take ou the points "." from the clubs name
players['Club'] = players['Club'].str.translate(str.maketrans('', '', string.punctuation))

#convert the 'Market Value' from 32000000.0 to 32M€
def format_market_value(value):
    if pd.notnull(value):
        if value >= 1e6:
            formatted_value = f'{value / 1e6:.0f}' if value % 1 == 0 else f'{value / 1e6:.2f}'
            return f'{formatted_value}M€'
        else:
            return '<1M€'
    else:
        return None
players['Market Value'] = players['Market Value'].apply(format_market_value)

#convert the 'Weekly Wages' from 255951.0 to 255K€
def format_weekly_wages(value):
    if pd.notnull(value):
        if value >= 1e3:
            formatted_value = f'{value / 1e3:.0f}' if value % 1 == 0 else f'{value / 1e3:.2f}'
            return f'{formatted_value}K€'
        else:
            return '<1K€'
    else:
        return 'N/A'
players['Weekly Wages'] = players['Weekly Wages'].apply(format_weekly_wages)

#convert the "Contract Expiration" from 2025-06-30 to 2025
players['Contract Expiration'] = players['Contract Expiration'].str[:4]
players['Contract Expiration'].fillna('N/A', inplace=True)

#convert the "Minutes Played, Scoring, Assisting, ...from 1647.0 to 1647
players['Minutes Played'] = players['Minutes Played'].astype('Int64')
players['Scoring'] = players['Scoring'].astype('Int64')
players['Assisting'] = players['Assisting'].astype('Int64')
players['Receiving'] = players['Receiving'].astype('Int64')
players['Dribbling'] = players['Dribbling'].astype('Int64')
players['Creating'] = players['Creating'].astype('Int64')
players['Passing'] = players['Passing'].astype('Int64')
players['Carrying'] = players['Carrying'].astype('Int64')
players['Possession'] = players['Possession'].astype('Int64')
players['Heading'] = players['Heading'].astype('Int64')
players['Intercepting'] = players['Intercepting'].astype('Int64')
players['Tackling'] = players['Tackling'].astype('Int64')
players['Penalty-Defending'] = players['Penalty-Defending'].astype('Int64')
players['Cross-Stopping'] = players['Cross-Stopping'].astype('Int64')
players['Exiting'] = players['Exiting'].astype('Int64')
players['Shot-Defending'] = players['Shot-Defending'].astype('Int64')
players['Goal-Defending'] = players['Goal-Defending'].astype('Int64')

#simple_export(players, '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Dataframes/players.csv')


#RATING CALCULATION------------------------------------------------------------------------#

#add rating column
players['Rating'] = np.nan

#average calculation for the goalkeepers
def calculate_goalkeeper_rating(player):
    position = str(player['Position']).strip()
    if position == 'Goalkeeper':
        passing = player['Passing'] if pd.notna(player['Passing']) else 0
        penalty_defending = player['Penalty-Defending'] if pd.notna(player['Penalty-Defending']) else 0
        cross_stopping = player['Cross-Stopping'] if pd.notna(player['Cross-Stopping']) else 0
        exiting = player['Exiting'] if pd.notna(player['Exiting']) else 0
        shot_defending = player['Shot-Defending'] if pd.notna(player['Shot-Defending']) else 0
        goal_defending = player['Goal-Defending'] if pd.notna(player['Goal-Defending']) else 0
        rating = round((passing+penalty_defending+cross_stopping+exiting+shot_defending+goal_defending)/6)
        return rating

#average calculation for the centrebacks
def calculate_centreback_rating(player):
    position = str(player['Position']).strip()
    if position == 'Centre Back':
        possession = player['Possession'] if pd.notna(player['Possession']) else 0
        passing = player['Passing'] if pd.notna(player['Passing']) else 0
        carrying = player['Carrying'] if pd.notna(player['Carrying']) else 0
        heading = player['Heading'] if pd.notna(player['Heading']) else 0
        intercepting = player['Intercepting'] if pd.notna(player['Intercepting']) else 0
        tackling = player['Tackling'] if pd.notna(player['Tackling']) else 0
        rating = round((possession+passing+carrying+heading+intercepting+tackling)/6)
        return rating

#average calculation for the fullbacks
def calculate_fullback_rating(player):
    position = str(player['Position']).strip()
    if player['Position'] == 'Right Back' or player['Position'] == 'Left Back':
        assisting = player['Assisting'] if pd.notna(player['Assisting']) else 0
        creating = player['Creating'] if pd.notna(player['Creating']) else 0
        passing = player['Passing'] if pd.notna(player['Passing']) else 0
        carrying = player['Carrying'] if pd.notna(player['Carrying']) else 0
        intercepting = player['Intercepting'] if pd.notna(player['Intercepting']) else 0
        tackling = player['Tackling'] if pd.notna(player['Tackling']) else 0
        rating = round((assisting+creating+passing+carrying+intercepting+tackling)/6)
        return rating

#average calculation for the midfielders
def calculate_midfielders_rating(player):
    position = str(player['Position']).strip()
    if player['Position'] == 'Defensive Midfielder' or player['Position'] == 'Central Midfielder':
        possession = player['Possession'] if pd.notna(player['Possession']) else 0
        creating = player['Creating'] if pd.notna(player['Creating']) else 0
        passing = player['Passing'] if pd.notna(player['Passing']) else 0
        carrying = player['Carrying'] if pd.notna(player['Carrying']) else 0
        intercepting = player['Intercepting'] if pd.notna(player['Intercepting']) else 0
        tackling = player['Tackling'] if pd.notna(player['Tackling']) else 0
        rating = round((possession+creating+passing+carrying+intercepting+tackling)/6)
        return rating

#weighted average calculation for the attacking midfielders
def calculate_attacking_midfielders_rating(player):
    position = str(player['Position']).strip()
    if player['Position'] == 'Attacking Midfielder' or player['Position'] == 'Right Winger' or player['Position'] == 'Left Winger':
         scoring = player['Scoring'] if pd.notna(player['Scoring']) else 0
         assisting = player['Assisting'] if pd.notna(player['Assisting']) else 0
         creating = player['Creating'] if pd.notna(player['Creating']) else 0
         passing = player['Passing'] if pd.notna(player['Passing']) else 0
         dribbling = player['Dribbling'] if pd.notna(player['Dribbling']) else 0
         carrying = player['Carrying'] if pd.notna(player['Carrying']) else 0
         rating = round(scoring*0.25+assisting*0.25+creating*0.125+passing*0.125+dribbling*0.125+carrying*0.125)
         return rating

#weighted average calculation for the strikers
def calculate_strikers_rating(player):
    position = str(player['Position']).strip()
    if player['Position'] == 'Striker':
         scoring = player['Scoring'] if pd.notna(player['Scoring']) else 0
         assisting = player['Assisting'] if pd.notna(player['Assisting']) else 0
         creating = player['Creating'] if pd.notna(player['Creating']) else 0
         passing = player['Passing'] if pd.notna(player['Passing']) else 0
         receiving = player['Receiving'] if pd.notna(player['Receiving']) else 0
         heading = player['Heading'] if pd.notna(player['Heading']) else 0
         rating = round(scoring*0.5+assisting*0.25+creating*0.0625+passing*0.0625+receiving*0.0625+heading*0.0625)
         return rating

#applying the average calculations to our dataframe
players['Rating'] = players.apply(calculate_goalkeeper_rating, axis=1)
players['Rating'].fillna(players.apply(calculate_centreback_rating, axis=1), inplace=True)
players['Rating'].fillna(players.apply(calculate_fullback_rating, axis=1), inplace=True)
players['Rating'].fillna(players.apply(calculate_midfielders_rating, axis=1), inplace=True)
players['Rating'].fillna(players.apply(calculate_attacking_midfielders_rating, axis=1), inplace=True)
players['Rating'].fillna(players.apply(calculate_strikers_rating, axis=1), inplace=True)

#add league factor to the rating classification
def calculate_league_rating(player):
    if player['League'] == 'Premier League':
         rating = round((player['Rating']*0.8)+(20))
         return rating
    if player['League'] == 'La Liga':
         rating = round((player['Rating']*0.8)+(18))
         return rating
    if player['League'] == 'Serie A':
         rating = round((player['Rating']*0.8)+(16))
         return rating
    if player['League'] == 'Bundesliga':
         rating = round((player['Rating']*0.8)+(14))
         return rating
    if player['League'] == 'Ligue 1':
         rating = round((player['Rating']*0.8)+(12))
         return rating
    if player['League'] == 'Eredivisie':
         rating = round((player['Rating']*0.8)+(10))
         return rating
    if player['League'] == 'Liga Portugal':
         rating = round((player['Rating']*0.8)+(8))
         return rating
    if player['League'] == 'Série A':
         rating = round((player['Rating']*0.8)+(6))
         return rating
    if player['League'] == 'Liga Profesional' or player['League'] == 'Copa de la Liga':
         rating = round((player['Rating']*0.8)+(4))
         return rating
    if player['League'] == 'MLS':
        rating = round((player['Rating']*0.8)+(2))
        return rating

#applying the league factor to the rating to our dataframe
players['Rating'] = players.apply(calculate_league_rating, axis=1)

#calculate a new rating, using the normal distribution function
x = np.linspace(50, 100, 50)
pdf_values = norm.pdf(x, loc=75, scale=10)
normalized_pdf_values = pdf_values / np.sum(pdf_values)

num_rows = len(players)
values = np.round(normalized_pdf_values * num_rows)

new_rating = np.array([])
score = 50
counter = 0
counter2 = 0
while counter < num_rows:
    if counter2 == len(values):
        counter2 = 0
    value = int(values[counter2])
    for j in range(value):
        new_rating = np.append(new_rating, score)
        counter += 1
        if counter == num_rows:
            break
    score += 1
    counter2 += 1

new_rating = new_rating[:num_rows]

players.reset_index(drop=True, inplace=True)
players = players.sort_values(by='Rating')
i = 0
for i in range(len(new_rating)):
    players.at[players.index[i], 'Rating'] = new_rating[i]

#simple_export(players, '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Dataframes/players.csv')


#ROLE CALCULATION--------------------------------------------------------------------------#


#role calculation
def calculate_role(players):
    #add role column
    players['Role'] = np.nan

    for index, player in players.iterrows():
        position = str(player['Position']).strip()

        #for the goalkeepers
        if position == 'Goalkeeper':
            max_col = np.nanmax(player[['Passing', 'Exiting', 'Shot-Defending']])
            if max_col == player['Passing']:
                players.at[index, 'Role'] = 'Ball Player'
            elif max_col == player['Exiting']:
                players.at[index, 'Role'] = 'Sweeper'
            elif max_col == player['Shot-Defending']:
                players.at[index, 'Role'] = 'Line Keeper'
            elif player['Passing'] == player['Exiting']:
                players.at[index, 'Role'] = 'Ball Player'
            elif player['Passing'] == player['Shot-Defending']:
                players.at[index, 'Role'] = 'Ball Player'
            elif player['Exiting'] == player['Shot-Defending']:
                players.at[index, 'Role'] = 'Sweeper'

        #for the centrebacks
        if position == 'Centre Back':
            max_col = np.nanmax(player[['Passing', 'Intercepting', 'Tackling']])
            if max_col == player['Passing']:
                players.at[index, 'Role'] = 'Ball Player'
            elif max_col == player['Intercepting']:
                players.at[index, 'Role'] = 'Stopper'
            elif max_col == player['Tackling']:
                players.at[index, 'Role'] = 'Ball Winner'
            elif player['Passing'] == player['Intercepting']:
                players.at[index, 'Role'] = 'Ball Player'
            elif player['Passing'] == player['Tackling']:
                players.at[index, 'Role'] = 'Ball Player'
            elif player['Intercepting'] == player['Tackling']:
                players.at[index, 'Role'] = 'Stopper'

        #for the fulllbakcs
        if position == 'Right Back' or position == 'Left Back':
            max_col = np.nanmax(player[['Passing', 'Carrying', 'Tackling']])
            if max_col == player['Passing']:
                players.at[index, 'Role'] = 'Inverted Wingback'
            elif max_col == player['Carrying']:
                players.at[index, 'Role'] = 'Wingback'
            elif max_col == player['Tackling']:
                players.at[index, 'Role'] = 'Fullback'
            elif player['Passing'] == player['Carrying']:
                players.at[index, 'Role'] = 'Inverted Wingback'
            elif player['Passing'] == player['Tackling']:
                players.at[index, 'Role'] = 'Inverted Wingback'
            elif player['Carrying'] == player['Tackling']:
                players.at[index, 'Role'] = 'Wingback'

        #for the defensive midfielders
        if position == 'Defensive Midfielder':
            max_col = np.nanmax(player[['Possession', 'Passing', 'Tackling']])
            if max_col == player['Possession']:
                players.at[index, 'Role'] = 'Holding Midfielder'
            elif max_col == player['Passing']:
                players.at[index, 'Role'] = 'Playmaker'
            elif max_col == player['Tackling']:
                players.at[index, 'Role'] = 'Ball Winner'
            elif player['Passing'] == player['Possession']:
                players.at[index, 'Role'] = 'Playmaker'
            elif player['Passing'] == player['Tackling']:
                players.at[index, 'Role'] = 'Playmaker'
            elif player['Possession'] == player['Tackling']:
                players.at[index, 'Role'] = 'Holding Midfielder'

        #for the central midfielders
        if position == 'Central Midfielder':
            max_col = np.nanmax(player[['Carrying', 'Passing', 'Tackling']])
            if max_col == player['Carrying']:
                players.at[index, 'Role'] = 'Box-to-Box'
            elif max_col == player['Passing']:
                players.at[index, 'Role'] = 'Playmaker'
            elif max_col == player['Tackling']:
                players.at[index, 'Role'] = 'Ball Winner'
            elif player['Carrying'] == player['Passing']:
                players.at[index, 'Role'] = 'Box-to-Box'
            elif player['Carrying'] == player['Tackling']:
                players.at[index, 'Role'] = 'Box-to-Box'
            elif player['Passing'] == player['Tackling']:
                players.at[index, 'Role'] = 'Playmaker'

        #for the attacking midfielders
        if position == 'Attacking Midfielder':
            max_col = np.nanmax(player[['Scoring', 'Creating', 'Dribbling']])
            if max_col == player['Scoring']:
                players.at[index, 'Role'] = 'Second Striker'
            elif max_col == player['Creating']:
                players.at[index, 'Role'] = 'Playmaker'
            elif max_col == player['Dribbling']:
                players.at[index, 'Role'] = 'Half Winger'
            elif player['Scoring'] == player['Creating']:
                players.at[index, 'Role'] = 'Second Striker'
            elif player['Scoring'] == player['Dribbling']:
                players.at[index, 'Role'] = 'Second Striker'
            elif player['Creating'] == player['Dribbling']:
                players.at[index, 'Role'] = 'Playmaker'

        #for the wingers
        if position == 'Right Winger' or position == 'Left Winger':
            max_col = np.nanmax(player[['Scoring', 'Creating', 'Dribbling']])
            if max_col == player['Scoring']:
                players.at[index, 'Role'] = 'Inside Forward'
            elif max_col == player['Creating']:
                players.at[index, 'Role'] = 'Wide Creator'
            elif max_col == player['Dribbling']:
                players.at[index, 'Role'] = 'One-on-One'
            elif player['Scoring'] == player['Creating']:
                players.at[index, 'Role'] = 'Inside Forward'
            elif player['Scoring'] == player['Dribbling']:
                players.at[index, 'Role'] = 'Inside Forward'
            elif player['Creating'] == player['Dribbling']:
                players.at[index, 'Role'] = 'One-on-One'

        #for the strikers
        if position == 'Striker':
            max_col = np.nanmax(player[['Heading', 'Receiving', 'Creating']])
            if max_col == player['Heading']:
                players.at[index, 'Role'] = 'Target Man'
            elif max_col == player['Receiving']:
                players.at[index, 'Role'] = 'Advanced Forward'
            elif max_col == player['Creating']:
                players.at[index, 'Role'] = 'Shadow Striker'
            elif player['Heading'] == player['Receiving']:
                players.at[index, 'Role'] = 'Target Man'
            elif player['Heading'] == player['Creating']:
                players.at[index, 'Role'] = 'Target Man'
            elif player['Receiving'] == player['Creating']:
                players.at[index, 'Role'] = 'Advanced Forward'

calculate_role(players)

#simple_export(players, '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Dataframes/players.csv')


#TOUCHES FOR THE HEATMAP PLOT--------------------------------------------------------------#


#convert columns '1st', '2nd', '3rd', '4th', and '5th' to numeric
players['1st'] = pd.to_numeric(players['1st'], errors='coerce')
players['2nd'] = pd.to_numeric(players['2nd'], errors='coerce')
players['3rd'] = pd.to_numeric(players['3rd'], errors='coerce')
players['4th'] = pd.to_numeric(players['4th'], errors='coerce')
players['5th'] = pd.to_numeric(players['5th'], errors='coerce')

#check for null valuesvalues
nan_values = players[['1st', '2nd', '3rd', '4th', '5th']].isna().any(axis=1)

#calculate the touches in each part of the pitch
players.loc[~nan_values, '2nd'] = players.loc[~nan_values, '2nd']-players.loc[~nan_values, '1st']
players.loc[~nan_values, '4th'] = players.loc[~nan_values, '4th']-players.loc[~nan_values, '5th']

#calculate percentages for each row
total_touches = players.loc[~nan_values, ['1st', '2nd', '3rd', '4th', '5th']].sum(axis=1)
players.loc[~nan_values, '1st'] = ((players.loc[~nan_values, '1st']/total_touches)*100).round().astype(int)
players.loc[~nan_values, '2nd'] = ((players.loc[~nan_values, '2nd']/total_touches)*100).round().astype(int)
players.loc[~nan_values, '3rd'] = ((players.loc[~nan_values, '3rd']/total_touches)*100).round().astype(int)
players.loc[~nan_values, '4th'] = ((players.loc[~nan_values, '4th']/total_touches)*100).round().astype(int)
players.loc[~nan_values, '5th'] = ((players.loc[~nan_values, '5th']/total_touches)*100).round().astype(int)

#convert from 16.0 to 16 and change the null values to "N/A"
players['1st'] = players['1st'].astype('Int64').astype(str).replace(['nan', '<NA>'], 'N/A')
players['2nd'] = players['2nd'].astype('Int64').astype(str).replace(['nan', '<NA>'], 'N/A')
players['3rd'] = players['3rd'].astype('Int64').astype(str).replace(['nan', '<NA>'], 'N/A')
players['4th'] = players['4th'].astype('Int64').astype(str).replace(['nan', '<NA>'], 'N/A')
players['5th'] = players['5th'].astype('Int64').astype(str).replace(['nan', '<NA>'], 'N/A')

#simple_export(players, '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Dataframes/players.csv')


#ADD IMAGE LINK----------------------------------------------------------------------------#


def image_link(players):
    players['Image URL'] = np.nan
    for index, player in players.iterrows():
        url = str(player['URL']).strip()
        id = url[29:37]
        image_url = "https://fbref.com/req/202302030/images/headshots/" + id + "_2022.jpg"
        players.at[index, 'Image URL'] = image_url

image_link(players)


#UPDATE THE CENTREBACKS TO BE DIVIDED INTO LEFT AND RIGHT----------------------------------#


centre_backs = players[players['Position'] == 'Centre Back']
centre_backs.loc[centre_backs['Preferred Foot'] == 'Left', 'Position'] = 'Left Centre Back'
centre_backs.loc[centre_backs['Preferred Foot'] == 'Right', 'Position'] = 'Right Centre Back'
centre_backs.loc[centre_backs['Preferred Foot'] == 'Both', 'Position'] = 'Right Centre Back'
centre_backs.loc[centre_backs['Preferred Foot'] == 'N/A', 'Position'] = 'Right Centre Back'
players.update(centre_backs)


#CONCLUSION--------------------------------------------------------------------------------#


simple_export(players, '/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Dataframes/players.csv')

end_time = time.time()
print("dataframe.py took", int((end_time-start_time)/60), "minutes!")


#------------------------------------------------------------------------------------------#
