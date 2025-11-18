#PART 1:  INTRODUCTION-----------------------------------------------------------------------------------


#restart R if necessary
#.rs.restartR()

#data from https://jaseziv.github.io/worldfootballR/ 
suppressMessages({
  library(worldfootballR)
  library(dplyr)
  library(tidyverse)
})

#version
package_version <- packageVersion("worldfootballR")
#print(package_version)

#start time
start_time <- Sys.time()


#PART 2: FBREF-------------------------------------------------------------------------------------------


#website
#https://fbref.com/en
#notebook
#https://jaseziv.github.io/worldfootballR/articles/extract-fbref-data.html


#PART 2.1: FBREF PREMIER LEAGUE--------------------------------------------------------------------------


#fbref url
premier_league <- fb_league_urls(country = "ENG", gender = "M", season_end_year = 2024, tier = '1st')
#print(premier_league)

#list of the fbref urls for every team
premier_league_teams <- fb_teams_urls(premier_league)
#print(premier_league_teams)

#stats for every team
#types of stats: standard, shooting, passing, passing_types, gca, defense, possession, playing_time, 
#misc, keepers, keepers_adv

#standard
premier_league_standard <- fb_team_player_stats(team_urls = premier_league_teams, stat_type = 'standard')
#remove goalkeepers
premier_league_standard <- 
  premier_league_standard %>%
  filter(Pos != "GK")
#add "_STANDARD" to the end of every column
premier_league_standard <- 
  premier_league_standard %>%
  rename_all(~paste0(., "_STANDARD"))
#rename the PlayerURL
premier_league_standard <- 
  premier_league_standard %>%
  rename(PlayerURL = PlayerURL_STANDARD)
#view(premier_league_standard)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age", "Mins_Per_90")

#passing
premier_league_passing <- fb_team_player_stats(team_urls = premier_league_teams, stat_type = 'passing')
#remove goalkeepers
premier_league_passing <- 
  premier_league_passing %>%
  filter(Pos != "GK")
#remove repeated columns
premier_league_passing <- 
  premier_league_passing %>%
  select(-one_of(common_columns))
#add "_PASSING" to the end of every column
premier_league_passing <- 
  premier_league_passing %>%
  rename_all(~paste0(., "_PASSING"))
#rename the PlayerURL
premier_league_passing <- 
  premier_league_passing %>%
  rename(PlayerURL = PlayerURL_PASSING)
#view(premier_league_passing)

#defense
premier_league_defense <- fb_team_player_stats(team_urls = premier_league_teams, stat_type = 'defense')
#remove goalkeepers
premier_league_defense <- 
  premier_league_defense %>%
  filter(Pos != "GK")
#remove repeated columns
premier_league_defense <- 
  premier_league_defense %>%
  select(-one_of(common_columns))
#add "_DEFENSE" to the end of every column
premier_league_defense <- 
  premier_league_defense %>%
  rename_all(~paste0(., "_DEFENSE"))
#rename the PlayerURL
premier_league_defense <- 
  premier_league_defense %>%
  rename(PlayerURL = PlayerURL_DEFENSE)
#view(premier_league_defense)

#possession
premier_league_possession <- fb_team_player_stats(team_urls = premier_league_teams, stat_type = 'possession')
#remove goalkeepers
premier_league_possession <- 
  premier_league_possession %>%
  filter(Pos != "GK")
#remove repeated columns
premier_league_possession <- 
  premier_league_possession %>%
  select(-one_of(common_columns))
#add "_POSSESION" to the end of every column
premier_league_possession <- 
  premier_league_possession %>%
  rename_all(~paste0(., "_POSSESSION"))
#rename the PlayerURL
premier_league_possession <- 
  premier_league_possession %>%
  rename(PlayerURL = PlayerURL_POSSESSION)
#view(premier_league_possession)

#misc
premier_league_misc <- fb_team_player_stats(team_urls = premier_league_teams, stat_type = 'misc')
#remove goalkeepers
premier_league_misc <- 
  premier_league_misc %>%
  filter(Pos != "GK")
#remove repeated columns
premier_league_misc <- 
  premier_league_misc %>%
  select(-one_of(common_columns))
#add "_MISC" to the end of every column
premier_league_misc <- 
  premier_league_misc %>%
  rename_all(~paste0(., "_MISC"))
#rename the PlayerURL
premier_league_misc <- 
  premier_league_misc %>%
  rename(PlayerURL = PlayerURL_MISC)
#view(premier_league_misc)

#do the dataframes have repetead columns? 
data_frames <- list(
  premier_league_standard,
  premier_league_passing,
  premier_league_defense,
  premier_league_possession,
  premier_league_misc
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
premier_league_players_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
premier_league_players_fbref <- 
  premier_league_players_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(premier_league_players_fbref)

#keeper
premier_league_keeper <- fb_team_player_stats(team_urls = premier_league_teams, stat_type = 'keeper')
#add "_KEEPER" to the end of every column
premier_league_keeper <- 
  premier_league_keeper %>%
  rename_all(~paste0(., "_KEEPER"))
#rename the PlayerURL
premier_league_keeper <- 
  premier_league_keeper %>%
  rename(PlayerURL = PlayerURL_KEEPER)
#view(premier_league_keeper)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age")

#keeper_adv
premier_league_keeper_adv <- fb_team_player_stats(team_urls = premier_league_teams, stat_type = 'keeper_adv')
#remove repeated columns
premier_league_keeper_adv <- 
  premier_league_keeper_adv %>%
  select(-one_of(common_columns))
#add "_KEEPER_ADV" to the end of every column
premier_league_keeper_adv <- 
  premier_league_keeper_adv %>%
  rename_all(~paste0(., "_KEEPER_ADV"))
#rename the PlayerURL
premier_league_keeper_adv <- 
  premier_league_keeper_adv %>%
  rename(PlayerURL = PlayerURL_KEEPER_ADV)
#view(premier_league_keeper_adv)

#do the dataframes have repetead columns? 
data_frames <- list(
  premier_league_keeper,
  premier_league_keeper_adv
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
premier_league_keepers_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
premier_league_keepers_fbref <- 
  premier_league_keepers_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(premier_league_keepers_fbref)

#wages
premier_league_wages <- fb_squad_wages(team_urls = premier_league_teams)
#rename the UrlFBRef
premier_league_wages <- 
  premier_league_wages %>%
  rename(UrlFBref = Url)
#rename the WeeklyWageEUR_WAGES
premier_league_wages <- 
  premier_league_wages %>%
  rename(WeeklyWageEUR_WAGES = WeeklyWageEUR)
#columns that need to be removed, to avoid repetition
common_columns <- c("Team", "Comp", "Season", "Player", "Nation", "Pos", "Age", "WeeklyWageGBP", "WeeklyWageUSD",
                    "AnnualWageGBP", "AnnualWageEUR", "AnnualWageUSD", "Notes")
premier_league_wages <- 
  premier_league_wages %>%
  select(-one_of(common_columns))
#view(premier_league_wages)

#merge the original dataframe, with the one with the wages, for the outfield players
data_frames <- list(
  premier_league_players_fbref,
  premier_league_wages
)
premier_league_players_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(premier_league_players_fbref)

#merge the original dataframe, with the one with the wages, for the goalkeepers
data_frames <- list(
  premier_league_keepers_fbref,
  premier_league_wages
)
premier_league_keepers_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(premier_league_keepers_fbref)


#PART 2.2: FBREF LA LIGA---------------------------------------------------------------------------------


#fbref url
la_liga <- fb_league_urls(country = "ESP", gender = "M", season_end_year = 2024, tier = '1st')
#print(la_liga)

#list of the fbref urls for every team
la_liga_teams <- fb_teams_urls(la_liga)
#print(la_liga_teams)

#stats for every team
#types of stats: standard, shooting, passing, passing_types, gca, defense, possession, playing_time, 
#misc, keepers, keepers_adv

#standard
la_liga_standard <- fb_team_player_stats(team_urls = la_liga_teams, stat_type= 'standard')
#remove goalkeepers
la_liga_standard <- 
  la_liga_standard %>%
  filter(Pos != "GK")
#add "_STANDARD" to the end of every column
la_liga_standard <- 
  la_liga_standard %>%
  rename_all(~paste0(., "_STANDARD"))
#rename the PlayerURL
la_liga_standard <- 
  la_liga_standard %>%
  rename(PlayerURL = PlayerURL_STANDARD)
#view(la_liga_standard)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age", "Mins_Per_90")

#passing
la_liga_passing <- fb_team_player_stats(team_urls = la_liga_teams, stat_type= 'passing')
#remove goalkeepers
la_liga_passing <- 
  la_liga_passing %>%
  filter(Pos != "GK")
#remove repeated columns
la_liga_passing <- 
  la_liga_passing %>%
  select(-one_of(common_columns))
#add "_PASSING" to the end of every column
la_liga_passing <- 
  la_liga_passing %>%
  rename_all(~paste0(., "_PASSING"))
#rename the PlayerURL
la_liga_passing <- 
  la_liga_passing %>%
  rename(PlayerURL = PlayerURL_PASSING)
#view(la_liga_passing)

#defense
la_liga_defense <- fb_team_player_stats(team_urls = la_liga_teams, stat_type = 'defense')
#remove goalkeepers
la_liga_defense <- 
  la_liga_defense %>%
  filter(Pos != "GK")
#remove repeated columns
la_liga_defense <- 
  la_liga_defense %>%
  select(-one_of(common_columns))
#add "_DEFENSE" to the end of every column
la_liga_defense <- 
  la_liga_defense %>%
  rename_all(~paste0(., "_DEFENSE"))
#rename the PlayerURL
la_liga_defense <- 
  la_liga_defense %>%
  rename(PlayerURL = PlayerURL_DEFENSE)
#view(la_liga_defense)

#possession
la_liga_possession <- fb_team_player_stats(team_urls = la_liga_teams, stat_type = 'possession')
#remove goalkeepers
la_liga_possession <- 
  la_liga_possession %>%
  filter(Pos != "GK")
#remove repeated columns
la_liga_possession <- 
  la_liga_possession %>%
  select(-one_of(common_columns))
#add "_POSSESION" to the end of every column
la_liga_possession <- 
  la_liga_possession %>%
  rename_all(~paste0(., "_POSSESSION"))
#rename the PlayerURL
la_liga_possession <- 
  la_liga_possession %>%
  rename(PlayerURL = PlayerURL_POSSESSION)
#view(la_liga_possession)

#misc
la_liga_misc <- fb_team_player_stats(team_urls = la_liga_teams, stat_type = 'misc')
#remove goalkeepers
la_liga_misc <- 
  la_liga_misc %>%
  filter(Pos != "GK")
#remove repeated columns
la_liga_misc <- 
  la_liga_misc %>%
  select(-one_of(common_columns))
#add "_MISC" to the end of every column
la_liga_misc <- 
  la_liga_misc %>%
  rename_all(~paste0(., "_MISC"))
#rename the PlayerURL
la_liga_misc <- 
  la_liga_misc %>%
  rename(PlayerURL = PlayerURL_MISC)
#view(la_liga_misc)

#do the dataframes have repetead columns? 
data_frames <- list(
  la_liga_standard,
  la_liga_passing,
  la_liga_defense,
  la_liga_possession,
  la_liga_misc
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
la_liga_players_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
la_liga_players_fbref <- 
  la_liga_players_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(la_liga_players_fbref)

#keeper
la_liga_keeper <- fb_team_player_stats(team_urls = la_liga_teams, stat_type = 'keeper')
#add "_KEEPER" to the end of every column
la_liga_keeper <- 
  la_liga_keeper %>%
  rename_all(~paste0(., "_KEEPER"))
#rename the PlayerURL
la_liga_keeper <- 
  la_liga_keeper %>%
  rename(PlayerURL = PlayerURL_KEEPER)
#view(la_liga_keeper)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age")

#keeper_adv
la_liga_keeper_adv <- fb_team_player_stats(team_urls = la_liga_teams, stat_type = 'keeper_adv')
#remove repeated columns
la_liga_keeper_adv <- 
  la_liga_keeper_adv %>%
  select(-one_of(common_columns))
#add "_KEEPER_ADV" to the end of every column
la_liga_keeper_adv <- 
  la_liga_keeper_adv %>%
  rename_all(~paste0(., "_KEEPER_ADV"))
#rename the PlayerURL
la_liga_keeper_adv <- 
  la_liga_keeper_adv %>%
  rename(PlayerURL = PlayerURL_KEEPER_ADV)
#view(la_liga_keeper_adv)

#do the dataframes have repetead columns? 
data_frames <- list(
  la_liga_keeper,
  la_liga_keeper_adv
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
la_liga_keepers_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
la_liga_keepers_fbref <- 
  la_liga_keepers_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(la_liga_keepers_fbref)

#wages
la_liga_wages <- fb_squad_wages(team_urls = la_liga_teams)
#rename the UrlFBRef
la_liga_wages <- 
  la_liga_wages %>%
  rename(UrlFBref = Url)
#rename the WeeklyWageEUR_WAGES
la_liga_wages <- 
  la_liga_wages %>%
  rename(WeeklyWageEUR_WAGES = WeeklyWageEUR)
#columns that need to be removed, to avoid repetition
common_columns <- c("Team", "Comp", "Season", "Player", "Nation", "Pos", "Age", "WeeklyWageGBP", "WeeklyWageUSD",
                    "AnnualWageGBP", "AnnualWageEUR", "AnnualWageUSD", "Notes")
la_liga_wages <- 
  la_liga_wages %>%
  select(-one_of(common_columns))
#view(la_liga_wages)

#merge the original dataframe, with the one with the wages, for the outfield players
data_frames <- list(
  la_liga_players_fbref,
  la_liga_wages
)
la_liga_players_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(la_liga_players_fbref)

#merge the original dataframe, with the one with the wages, for the goalkeepers
data_frames <- list(
  la_liga_keepers_fbref,
  la_liga_wages
)
la_liga_keepers_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(la_liga_keepers_fbref)


#PART 2.3: FBREF SERIE A---------------------------------------------------------------------------------


#fbref url
serie_a <- fb_league_urls(country = "ITA", gender = "M", season_end_year = 2024, tier = '1st')
#print(serie_a)

#list of the fbref urls for every team
serie_a_teams <- fb_teams_urls(serie_a)
#print(serie_a_teams)

#stats for every team
#types of stats: standard, shooting, passing, passing_types, gca, defense, possession, playing_time, 
#misc, keepers, keepers_adv

#standard
serie_a_standard <- fb_team_player_stats(team_urls = serie_a_teams, stat_type= 'standard')
#remove goalkeepers
serie_a_standard <- 
  serie_a_standard %>%
  filter(Pos != "GK")
#add "_STANDARD" to the end of every column
serie_a_standard <- 
  serie_a_standard %>%
  rename_all(~paste0(., "_STANDARD"))
#rename the PlayerURL
serie_a_standard <- 
  serie_a_standard %>%
  rename(PlayerURL = PlayerURL_STANDARD)
#view(serie_a_standard)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age", "Mins_Per_90")

#passing
serie_a_passing <- fb_team_player_stats(team_urls = serie_a_teams, stat_type= 'passing')
#remove goalkeepers
serie_a_passing <- 
  serie_a_passing %>%
  filter(Pos != "GK")
#remove repeated columns
serie_a_passing <- 
  serie_a_passing %>%
  select(-one_of(common_columns))
#add "_PASSING" to the end of every column
serie_a_passing <- 
  serie_a_passing %>%
  rename_all(~paste0(., "_PASSING"))
#rename the PlayerURL
serie_a_passing <- 
  serie_a_passing %>%
  rename(PlayerURL = PlayerURL_PASSING)
#view(serie_a_passing)

#defense
serie_a_defense <- fb_team_player_stats(team_urls = serie_a_teams, stat_type = 'defense')
#remove goalkeepers
serie_a_defense <- 
  serie_a_defense %>%
  filter(Pos != "GK")
#remove repeated columns
serie_a_defense <- 
  serie_a_defense %>%
  select(-one_of(common_columns))
#add "_DEFENSE" to the end of every column
serie_a_defense <- 
  serie_a_defense %>%
  rename_all(~paste0(., "_DEFENSE"))
#rename the PlayerURL
serie_a_defense <- 
  serie_a_defense %>%
  rename(PlayerURL = PlayerURL_DEFENSE)
#view(serie_a_defense)

#possession
serie_a_possession <- fb_team_player_stats(team_urls = serie_a_teams, stat_type = 'possession')
#remove goalkeepers
serie_a_possession <- 
  serie_a_possession %>%
  filter(Pos != "GK")
#remove repeated columns
serie_a_possession <- 
  serie_a_possession %>%
  select(-one_of(common_columns))
#add "_POSSESION" to the end of every column
serie_a_possession <- 
  serie_a_possession %>%
  rename_all(~paste0(., "_POSSESSION"))
#rename the PlayerURL
serie_a_possession <- 
  serie_a_possession %>%
  rename(PlayerURL = PlayerURL_POSSESSION)
#view(serie_a_possession)

#misc
serie_a_misc <- fb_team_player_stats(team_urls = serie_a_teams, stat_type = 'misc')
#remove goalkeepers
serie_a_misc <- 
  serie_a_misc %>%
  filter(Pos != "GK")
#remove repeated columns
serie_a_misc <- 
  serie_a_misc %>%
  select(-one_of(common_columns))
#add "_MISC" to the end of every column
serie_a_misc <- 
  serie_a_misc %>%
  rename_all(~paste0(., "_MISC"))
#rename the PlayerURL
serie_a_misc <- 
  serie_a_misc %>%
  rename(PlayerURL = PlayerURL_MISC)
#view(serie_a_misc)

#do the dataframes have repetead columns? 
data_frames <- list(
  serie_a_standard,
  serie_a_passing,
  serie_a_defense,
  serie_a_possession,
  serie_a_misc
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
serie_a_players_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
serie_a_players_fbref <- 
  serie_a_players_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(serie_a_players_fbref)

#keeper
serie_a_keeper <- fb_team_player_stats(team_urls = serie_a_teams, stat_type = 'keeper')
#add "_KEEPER" to the end of every column
serie_a_keeper <- 
  serie_a_keeper %>%
  rename_all(~paste0(., "_KEEPER"))
#rename the PlayerURL
serie_a_keeper <- 
  serie_a_keeper %>%
  rename(PlayerURL = PlayerURL_KEEPER)
#view(serie_a_keeper)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age")

#keeper_adv
serie_a_keeper_adv <- fb_team_player_stats(team_urls = serie_a_teams, stat_type = 'keeper_adv')
#remove repeated columns
serie_a_keeper_adv <- 
  serie_a_keeper_adv %>%
  select(-one_of(common_columns))
#add "_KEEPER_ADV" to the end of every column
serie_a_keeper_adv <- 
  serie_a_keeper_adv %>%
  rename_all(~paste0(., "_KEEPER_ADV"))
#rename the PlayerURL
serie_a_keeper_adv <- 
  serie_a_keeper_adv %>%
  rename(PlayerURL = PlayerURL_KEEPER_ADV)
#view(serie_a_keeper_adv)

#do the dataframes have repetead columns? 
data_frames <- list(
  serie_a_keeper,
  serie_a_keeper_adv
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
serie_a_keepers_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
serie_a_keepers_fbref <- 
  serie_a_keepers_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(serie_a_keepers_fbref)

#wages
serie_a_wages <- fb_squad_wages(team_urls = serie_a_teams)
#rename the UrlFBRef
serie_a_wages <- 
  serie_a_wages %>%
  rename(UrlFBref = Url)
#rename the WeeklyWageEUR_WAGES
serie_a_wages <- 
  serie_a_wages %>%
  rename(WeeklyWageEUR_WAGES = WeeklyWageEUR)
#columns that need to be removed, to avoid repetition
common_columns <- c("Team", "Comp", "Season", "Player", "Nation", "Pos", "Age", "WeeklyWageGBP", "WeeklyWageUSD",
                    "AnnualWageGBP", "AnnualWageEUR", "AnnualWageUSD", "Notes")
serie_a_wages <- 
  serie_a_wages %>%
  select(-one_of(common_columns))
#view(serie_a_wages)

#merge the original dataframe, with the one with the wages, for the outfield players
data_frames <- list(
  serie_a_players_fbref,
  serie_a_wages
)
serie_a_players_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(serie_a_players_fbref)

#merge the original dataframe, with the one with the wages, for the goalkeepers
data_frames <- list(
  serie_a_keepers_fbref,
  serie_a_wages
)
serie_a_keepers_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(serie_a_keepers_fbref)


#PART 2.4: FBREF BUNDESLIGA------------------------------------------------------------------------------


#fbref url
bundesliga <- fb_league_urls(country = "GER", gender = "M", season_end_year = 2024, tier = '1st')
#print(bundesliga)

#list of the fbref urls for every team
bundesliga_teams <- fb_teams_urls(bundesliga)
#print(bundesliga_teams)

#stats for every team
#types of stats: standard, shooting, passing, passing_types, gca, defense, possession, playing_time, 
#misc, keepers, keepers_adv

#standard
bundesliga_standard <- fb_team_player_stats(team_urls = bundesliga_teams, stat_type= 'standard')
#remove goalkeepers
bundesliga_standard <- 
  bundesliga_standard %>%
  filter(Pos != "GK")
#add "_STANDARD" to the end of every column
bundesliga_standard <- 
  bundesliga_standard %>%
  rename_all(~paste0(., "_STANDARD"))
#rename the PlayerURL
bundesliga_standard <- 
  bundesliga_standard %>%
  rename(PlayerURL = PlayerURL_STANDARD)
#view(bundesliga_standard)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age", "Mins_Per_90")

#passing
bundesliga_passing <- fb_team_player_stats(team_urls = bundesliga_teams, stat_type= 'passing')
#remove goalkeepers
bundesliga_passing <- 
  bundesliga_passing %>%
  filter(Pos != "GK")
#remove repeated columns
bundesliga_passing <- 
  bundesliga_passing %>%
  select(-one_of(common_columns))
#add "_PASSING" to the end of every column
bundesliga_passing <- 
  bundesliga_passing %>%
  rename_all(~paste0(., "_PASSING"))
#rename the PlayerURL
bundesliga_passing <- 
  bundesliga_passing %>%
  rename(PlayerURL = PlayerURL_PASSING)
#view(bundesliga_passing)

#defense
bundesliga_defense <- fb_team_player_stats(team_urls = bundesliga_teams, stat_type = 'defense')
#remove goalkeepers
bundesliga_defense <- 
  bundesliga_defense %>%
  filter(Pos != "GK")
#remove repeated columns
bundesliga_defense <- 
  bundesliga_defense %>%
  select(-one_of(common_columns))
#add "_DEFENSE" to the end of every column
bundesliga_defense <- 
  bundesliga_defense %>%
  rename_all(~paste0(., "_DEFENSE"))
#rename the PlayerURL
bundesliga_defense <- 
  bundesliga_defense %>%
  rename(PlayerURL = PlayerURL_DEFENSE)
#view(bundesliga_defense)

#possession
bundesliga_possession <- fb_team_player_stats(team_urls = bundesliga_teams, stat_type = 'possession')
#remove goalkeepers
bundesliga_possession <- 
  bundesliga_possession %>%
  filter(Pos != "GK")
#remove repeated columns
bundesliga_possession <- 
  bundesliga_possession %>%
  select(-one_of(common_columns))
#add "_POSSESION" to the end of every column
bundesliga_possession <- 
  bundesliga_possession %>%
  rename_all(~paste0(., "_POSSESSION"))
#rename the PlayerURL
bundesliga_possession <- 
  bundesliga_possession %>%
  rename(PlayerURL = PlayerURL_POSSESSION)
#view(bundesliga_possession)

#misc
bundesliga_misc <- fb_team_player_stats(team_urls = bundesliga_teams, stat_type = 'misc')
#remove goalkeepers
bundesliga_misc <- 
  bundesliga_misc %>%
  filter(Pos != "GK")
#remove repeated columns
bundesliga_misc <- 
  bundesliga_misc %>%
  select(-one_of(common_columns))
#add "_MISC" to the end of every column
bundesliga_misc <- 
  bundesliga_misc %>%
  rename_all(~paste0(., "_MISC"))
#rename the PlayerURL
bundesliga_misc <- 
  bundesliga_misc %>%
  rename(PlayerURL = PlayerURL_MISC)
#view(bundesliga_misc)

#do the dataframes have repetead columns? 
data_frames <- list(
  bundesliga_standard,
  bundesliga_passing,
  bundesliga_defense,
  bundesliga_possession,
  bundesliga_misc
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
bundesliga_players_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
bundesliga_players_fbref <- 
  bundesliga_players_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(bundesliga_players_fbref)

#keeper
bundesliga_keeper <- fb_team_player_stats(team_urls = bundesliga_teams, stat_type = 'keeper')
#add "_KEEPER" to the end of every column
bundesliga_keeper <- 
  bundesliga_keeper %>%
  rename_all(~paste0(., "_KEEPER"))
#rename the PlayerURL
bundesliga_keeper <- 
  bundesliga_keeper %>%
  rename(PlayerURL = PlayerURL_KEEPER)
#view(bundesliga_keeper)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age")

#keeper_adv
bundesliga_keeper_adv <- fb_team_player_stats(team_urls = bundesliga_teams, stat_type = 'keeper_adv')
#remove repeated columns
bundesliga_keeper_adv <- 
  bundesliga_keeper_adv %>%
  select(-one_of(common_columns))
#add "_KEEPER_ADV" to the end of every column
bundesliga_keeper_adv <- 
  bundesliga_keeper_adv %>%
  rename_all(~paste0(., "_KEEPER_ADV"))
#rename the PlayerURL
bundesliga_keeper_adv <- 
  bundesliga_keeper_adv %>%
  rename(PlayerURL = PlayerURL_KEEPER_ADV)
#view(bundesliga_keeper_adv)

#do the dataframes have repetead columns? 
data_frames <- list(
  bundesliga_keeper,
  bundesliga_keeper_adv
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
bundesliga_keepers_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
bundesliga_keepers_fbref <- 
  bundesliga_keepers_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(bundesliga_keepers_fbref)

#wages
bundesliga_wages <- fb_squad_wages(team_urls = bundesliga_teams)
#rename the UrlFBRef
bundesliga_wages <- 
  bundesliga_wages %>%
  rename(UrlFBref = Url)
#rename the WeeklyWageEUR_WAGES
bundesliga_wages <- 
  bundesliga_wages %>%
  rename(WeeklyWageEUR_WAGES = WeeklyWageEUR)
#columns that need to be removed, to avoid repetition
common_columns <- c("Team", "Comp", "Season", "Player", "Nation", "Pos", "Age", "WeeklyWageGBP", "WeeklyWageUSD",
                    "AnnualWageGBP", "AnnualWageEUR", "AnnualWageUSD", "Notes")
bundesliga_wages <- 
  bundesliga_wages %>%
  select(-one_of(common_columns))
#view(bundesliga_wages)

#merge the original dataframe, with the one with the wages, for the outfield players
data_frames <- list(
  bundesliga_players_fbref,
  bundesliga_wages
)
bundesliga_players_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(bundesliga_players_fbref)

#merge the original dataframe, with the one with the wages, for the goalkeepers
data_frames <- list(
  bundesliga_keepers_fbref,
  bundesliga_wages
)
bundesliga_keepers_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(bundesliga_keepers_fbref)


#PART 2.5: FBREF LIGUE ONE-------------------------------------------------------------------------------


#fbref url
ligue_one <- fb_league_urls(country = "FRA", gender = "M", season_end_year = 2024, tier = '1st')
#print(ligue_one)

#list of the fbref urls for every team
ligue_one_teams <- fb_teams_urls(ligue_one)
#print(ligue_one_teams)

#stats for every team
#types of stats: standard, shooting, passing, passing_types, gca, defense, possession, playing_time, 
#misc, keepers, keepers_adv

#standard
ligue_one_standard <- fb_team_player_stats(team_urls = ligue_one_teams, stat_type= 'standard')
#remove goalkeepers
ligue_one_standard <- 
  ligue_one_standard %>%
  filter(Pos != "GK")
#add "_STANDARD" to the end of every column
ligue_one_standard <- 
  ligue_one_standard %>%
  rename_all(~paste0(., "_STANDARD"))
#rename the PlayerURL
ligue_one_standard <- 
  ligue_one_standard %>%
  rename(PlayerURL = PlayerURL_STANDARD)
#view(ligue_one_standard)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age", "Mins_Per_90")

#passing
ligue_one_passing <- fb_team_player_stats(team_urls = ligue_one_teams, stat_type= 'passing')
#remove goalkeepers
ligue_one_passing <- 
  ligue_one_passing %>%
  filter(Pos != "GK")
#remove repeated columns
ligue_one_passing <- 
  ligue_one_passing %>%
  select(-one_of(common_columns))
#add "_PASSING" to the end of every column
ligue_one_passing <- 
  ligue_one_passing %>%
  rename_all(~paste0(., "_PASSING"))
#rename the PlayerURL
ligue_one_passing <- 
  ligue_one_passing %>%
  rename(PlayerURL = PlayerURL_PASSING)
#view(ligue_one_passing)

#defense
ligue_one_defense <- fb_team_player_stats(team_urls = ligue_one_teams, stat_type = 'defense')
#remove goalkeepers
ligue_one_defense <- 
  ligue_one_defense %>%
  filter(Pos != "GK")
#remove repeated columns
ligue_one_defense <- 
  ligue_one_defense %>%
  select(-one_of(common_columns))
#add "_DEFENSE" to the end of every column
ligue_one_defense <- 
  ligue_one_defense %>%
  rename_all(~paste0(., "_DEFENSE"))
#rename the PlayerURL
ligue_one_defense <- 
  ligue_one_defense %>%
  rename(PlayerURL = PlayerURL_DEFENSE)
#view(ligue_one_defense)

#possession
ligue_one_possession <- fb_team_player_stats(team_urls = ligue_one_teams, stat_type = 'possession')
#remove goalkeepers
ligue_one_possession <- 
  ligue_one_possession %>%
  filter(Pos != "GK")
#remove repeated columns
ligue_one_possession <- 
  ligue_one_possession %>%
  select(-one_of(common_columns))
#add "_POSSESION" to the end of every column
ligue_one_possession <- 
  ligue_one_possession %>%
  rename_all(~paste0(., "_POSSESSION"))
#rename the PlayerURL
ligue_one_possession <- 
  ligue_one_possession %>%
  rename(PlayerURL = PlayerURL_POSSESSION)
#view(ligue_one_possession)

#misc
ligue_one_misc <- fb_team_player_stats(team_urls = ligue_one_teams, stat_type = 'misc')
#remove goalkeepers
ligue_one_misc <- 
  ligue_one_misc %>%
  filter(Pos != "GK")
#remove repeated columns
ligue_one_misc <- 
  ligue_one_misc %>%
  select(-one_of(common_columns))
#add "_MISC" to the end of every column
ligue_one_misc <- 
  ligue_one_misc %>%
  rename_all(~paste0(., "_MISC"))
#rename the PlayerURL
ligue_one_misc <- 
  ligue_one_misc %>%
  rename(PlayerURL = PlayerURL_MISC)
#view(ligue_one_misc)

#do the dataframes have repetead columns? 
data_frames <- list(
  ligue_one_standard,
  ligue_one_passing,
  ligue_one_defense,
  ligue_one_possession,
  ligue_one_misc
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
ligue_one_players_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
ligue_one_players_fbref <- 
  ligue_one_players_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(ligue_one_players_fbref)

#keeper
ligue_one_keeper <- fb_team_player_stats(team_urls = ligue_one_teams, stat_type = 'keeper')
#add "_KEEPER" to the end of every column
ligue_one_keeper <- 
  ligue_one_keeper %>%
  rename_all(~paste0(., "_KEEPER"))
#rename the PlayerURL
ligue_one_keeper <- 
  ligue_one_keeper %>%
  rename(PlayerURL = PlayerURL_KEEPER)
#view(ligue_one_keeper)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age")

#keeper_adv
ligue_one_keeper_adv <- fb_team_player_stats(team_urls = ligue_one_teams, stat_type = 'keeper_adv')
#remove repeated columns
ligue_one_keeper_adv <- 
  ligue_one_keeper_adv %>%
  select(-one_of(common_columns))
#add "_KEEPER_ADV" to the end of every column
ligue_one_keeper_adv <- 
  ligue_one_keeper_adv %>%
  rename_all(~paste0(., "_KEEPER_ADV"))
#rename the PlayerURL
ligue_one_keeper_adv <- 
  ligue_one_keeper_adv %>%
  rename(PlayerURL = PlayerURL_KEEPER_ADV)
#view(ligue_one_keeper_adv)

#do the dataframes have repetead columns? 
data_frames <- list(
  ligue_one_keeper,
  ligue_one_keeper_adv
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
ligue_one_keepers_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
ligue_one_keepers_fbref <- 
  ligue_one_keepers_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(ligue_one_keepers_fbref)

#wages
ligue_one_wages <- fb_squad_wages(team_urls = ligue_one_teams)
#rename the UrlFBRef
ligue_one_wages <- 
  ligue_one_wages %>%
  rename(UrlFBref = Url)
#rename the WeeklyWageEUR_WAGES
ligue_one_wages <- 
  ligue_one_wages %>%
  rename(WeeklyWageEUR_WAGES = WeeklyWageEUR)
#columns that need to be removed, to avoid repetition
common_columns <- c("Team", "Comp", "Season", "Player", "Nation", "Pos", "Age", "WeeklyWageGBP", "WeeklyWageUSD",
                    "AnnualWageGBP", "AnnualWageEUR", "AnnualWageUSD", "Notes")
ligue_one_wages <- 
  ligue_one_wages %>%
  select(-one_of(common_columns))
#view(ligue_one_wages)

#merge the original dataframe, with the one with the wages, for the outfield players
data_frames <- list(
  ligue_one_players_fbref,
  ligue_one_wages
)
ligue_one_players_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(ligue_one_players_fbref)

#merge the original dataframe, with the one with the wages, for the goalkeepers
data_frames <- list(
  ligue_one_keepers_fbref,
  ligue_one_wages
)
ligue_one_keepers_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(ligue_one_keepers_fbref)


#PART 2.6: FBREF EREDIVISIE-----------------------------------------------------------------------------


#fbref url
eredivisie <- fb_league_urls(country = "NED", gender = "M", season_end_year = 2024, tier = '1st')
#print(eredivisie)

#list of the fbref urls for every team
eredivisie_teams <- fb_teams_urls(eredivisie)
#print(eredivisie_teams)

#stats for every team
#types of stats: standard, shooting, passing, passing_types, gca, defense, possession, playing_time, 
#misc, keepers, keepers_adv

#standard
eredivisie_standard <- fb_team_player_stats(team_urls = eredivisie_teams, stat_type= 'standard')
#remove goalkeepers
eredivisie_standard <- 
  eredivisie_standard %>%
  filter(Pos != "GK")
#add "_STANDARD" to the end of every column
eredivisie_standard <- 
  eredivisie_standard %>%
  rename_all(~paste0(., "_STANDARD"))
#rename the PlayerURL
eredivisie_standard <- 
  eredivisie_standard %>%
  rename(PlayerURL = PlayerURL_STANDARD)
#view(eredivisie_standard)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age", "Mins_Per_90")

#passing
eredivisie_passing <- fb_team_player_stats(team_urls = eredivisie_teams, stat_type= 'passing')
#remove goalkeepers
eredivisie_passing <- 
  eredivisie_passing %>%
  filter(Pos != "GK")
#remove repeated columns
eredivisie_passing <- 
  eredivisie_passing %>%
  select(-one_of(common_columns))
#add "_PASSING" to the end of every column
eredivisie_passing <- 
  eredivisie_passing %>%
  rename_all(~paste0(., "_PASSING"))
#rename the PlayerURL
eredivisie_passing <- 
  eredivisie_passing %>%
  rename(PlayerURL = PlayerURL_PASSING)
#view(eredivisie_passing)

#defense
eredivisie_defense <- fb_team_player_stats(team_urls = eredivisie_teams, stat_type = 'defense')
#remove goalkeepers
eredivisie_defense <- 
  eredivisie_defense %>%
  filter(Pos != "GK")
#remove repeated columns
eredivisie_defense <- 
  eredivisie_defense %>%
  select(-one_of(common_columns))
#add "_DEFENSE" to the end of every column
eredivisie_defense <- 
  eredivisie_defense %>%
  rename_all(~paste0(., "_DEFENSE"))
#rename the PlayerURL
eredivisie_defense <- 
  eredivisie_defense %>%
  rename(PlayerURL = PlayerURL_DEFENSE)
#view(eredivisie_defense)

#possession
eredivisie_possession <- fb_team_player_stats(team_urls = eredivisie_teams, stat_type = 'possession')
#remove goalkeepers
eredivisie_possession <- 
  eredivisie_possession %>%
  filter(Pos != "GK")
#remove repeated columns
eredivisie_possession <- 
  eredivisie_possession %>%
  select(-one_of(common_columns))
#add "_POSSESION" to the end of every column
eredivisie_possession <- 
  eredivisie_possession %>%
  rename_all(~paste0(., "_POSSESSION"))
#rename the PlayerURL
eredivisie_possession <- 
  eredivisie_possession %>%
  rename(PlayerURL = PlayerURL_POSSESSION)
#view(eredivisie_possession)

#misc
eredivisie_misc <- fb_team_player_stats(team_urls = eredivisie_teams, stat_type = 'misc')
#remove goalkeepers
eredivisie_misc <- 
  eredivisie_misc %>%
  filter(Pos != "GK")
#remove repeated columns
eredivisie_misc <- 
  eredivisie_misc %>%
  select(-one_of(common_columns))
#add "_MISC" to the end of every column
eredivisie_misc <- 
  eredivisie_misc %>%
  rename_all(~paste0(., "_MISC"))
#rename the PlayerURL
eredivisie_misc <- 
  eredivisie_misc %>%
  rename(PlayerURL = PlayerURL_MISC)
#view(eredivisie_misc)

#do the dataframes have repetead columns? 
data_frames <- list(
  eredivisie_standard,
  eredivisie_passing,
  eredivisie_defense,
  eredivisie_possession,
  eredivisie_misc
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
eredivisie_players_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
eredivisie_players_fbref <- 
  eredivisie_players_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(eredivisie_players_fbref)

#keeper
eredivisie_keeper <- fb_team_player_stats(team_urls = eredivisie_teams, stat_type = 'keeper')
#add "_KEEPER" to the end of every column
eredivisie_keeper <- 
  eredivisie_keeper %>%
  rename_all(~paste0(., "_KEEPER"))
#rename the PlayerURL
eredivisie_keeper <- 
  eredivisie_keeper %>%
  rename(PlayerURL = PlayerURL_KEEPER)
#view(eredivisie_keeper)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age")

#keeper_adv
eredivisie_keeper_adv <- fb_team_player_stats(team_urls = eredivisie_teams, stat_type = 'keeper_adv')
#remove repeated columns
eredivisie_keeper_adv <- 
  eredivisie_keeper_adv %>%
  select(-one_of(common_columns))
#add "_KEEPER_ADV" to the end of every column
eredivisie_keeper_adv <- 
  eredivisie_keeper_adv %>%
  rename_all(~paste0(., "_KEEPER_ADV"))
#rename the PlayerURL
eredivisie_keeper_adv <- 
  eredivisie_keeper_adv %>%
  rename(PlayerURL = PlayerURL_KEEPER_ADV)
#view(eredivisie_keeper_adv)

#do the dataframes have repetead columns? 
data_frames <- list(
  eredivisie_keeper,
  eredivisie_keeper_adv
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
eredivisie_keepers_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
eredivisie_keepers_fbref <- 
  eredivisie_keepers_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(eredivisie_keepers_fbref)

#wages
#eredivisie_wages <- fb_squad_wages(team_urls = eredivisie_teams)
#rename the UrlFBRef
#eredivisie_wages <- 
  #eredivisie_wages %>%
  #rename(UrlFBref = Url)
#rename the WeeklyWageEUR_WAGES
#eredivisie_wages <- 
  #eredivisie_wages %>%
  #rename(WeeklyWageEUR_WAGES = WeeklyWageEUR)
#columns that need to be removed, to avoid repetition
#common_columns <- c("Team", "Comp", "Season", "Player", "Nation", "Pos", "Age", "WeeklyWageGBP", "WeeklyWageUSD",
                    #"AnnualWageGBP", "AnnualWageEUR", "AnnualWageUSD", "Notes")
#eredivisie_wages <- 
  #eredivisie_wages %>%
  #select(-one_of(common_columns))
#view(eredivisie_wages)

#merge the original dataframe, with the one with the wages, for the outfield players
#data_frames <- list(
  #eredivisie_players_fbref,
  #eredivisie_wages
#)
#eredivisie_players_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(eredivisie_players_fbref)

#merge the original dataframe, with the one with the wages, for the goalkeepers
#data_frames <- list(
  #eredivisie_keepers_fbref,
  #eredivisie_wages
#)
#eredivisie_keepers_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(eredivisie_keepers_fbref)


#PART 2.7: FBREF PRIMEIRA LIGA--------------------------------------------------------------------------


#fbref url
primeira_liga <- fb_league_urls(country = "POR", gender = "M", season_end_year = 2024, tier = '1st')
#print(primeira_liga)

#list of the fbref urls for every team
primeira_liga_teams <- fb_teams_urls(primeira_liga)
#print(primeira_liga_teams)

#stats for every team
#types of stats: standard, shooting, passing, passing_types, gca, defense, possession, playing_time, 
#misc, keepers, keepers_adv

#standard
primeira_liga_standard <- fb_team_player_stats(team_urls = primeira_liga_teams, stat_type= 'standard')
#remove goalkeepers
primeira_liga_standard <- 
  primeira_liga_standard %>%
  filter(Pos != "GK")
#add "_STANDARD" to the end of every column
primeira_liga_standard <- 
  primeira_liga_standard %>%
  rename_all(~paste0(., "_STANDARD"))
#rename the PlayerURL
primeira_liga_standard <- 
  primeira_liga_standard %>%
  rename(PlayerURL = PlayerURL_STANDARD)
#view(primeira_liga_standard)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age", "Mins_Per_90")

#passing
primeira_liga_passing <- fb_team_player_stats(team_urls = primeira_liga_teams, stat_type= 'passing')
#remove goalkeepers
primeira_liga_passing <- 
  primeira_liga_passing %>%
  filter(Pos != "GK")
#remove repeated columns
primeira_liga_passing <- 
  primeira_liga_passing %>%
  select(-one_of(common_columns))
#add "_PASSING" to the end of every column
primeira_liga_passing <- 
  primeira_liga_passing %>%
  rename_all(~paste0(., "_PASSING"))
#rename the PlayerURL
primeira_liga_passing <- 
  primeira_liga_passing %>%
  rename(PlayerURL = PlayerURL_PASSING)
#view(primeira_liga_passing)

#defense
primeira_liga_defense <- fb_team_player_stats(team_urls = primeira_liga_teams, stat_type = 'defense')
#remove goalkeepers
primeira_liga_defense <- 
  primeira_liga_defense %>%
  filter(Pos != "GK")
#remove repeated columns
primeira_liga_defense <- 
  primeira_liga_defense %>%
  select(-one_of(common_columns))
#add "_DEFENSE" to the end of every column
primeira_liga_defense <- 
  primeira_liga_defense %>%
  rename_all(~paste0(., "_DEFENSE"))
#rename the PlayerURL
primeira_liga_defense <- 
  primeira_liga_defense %>%
  rename(PlayerURL = PlayerURL_DEFENSE)
#view(primeira_liga_defense)

#possession
primeira_liga_possession <- fb_team_player_stats(team_urls = primeira_liga_teams, stat_type = 'possession')
#remove goalkeepers
primeira_liga_possession <- 
  primeira_liga_possession %>%
  filter(Pos != "GK")
#remove repeated columns
primeira_liga_possession <- 
  primeira_liga_possession %>%
  select(-one_of(common_columns))
#add "_POSSESION" to the end of every column
primeira_liga_possession <- 
  primeira_liga_possession %>%
  rename_all(~paste0(., "_POSSESSION"))
#rename the PlayerURL
primeira_liga_possession <- 
  primeira_liga_possession %>%
  rename(PlayerURL = PlayerURL_POSSESSION)
#view(primeira_liga_possession)

#misc
primeira_liga_misc <- fb_team_player_stats(team_urls = primeira_liga_teams, stat_type = 'misc')
#remove goalkeepers
primeira_liga_misc <- 
  primeira_liga_misc %>%
  filter(Pos != "GK")
#remove repeated columns
primeira_liga_misc <- 
  primeira_liga_misc %>%
  select(-one_of(common_columns))
#add "_MISC" to the end of every column
primeira_liga_misc <- 
  primeira_liga_misc %>%
  rename_all(~paste0(., "_MISC"))
#rename the PlayerURL
primeira_liga_misc <- 
  primeira_liga_misc %>%
  rename(PlayerURL = PlayerURL_MISC)
#view(primeira_liga_misc)

#do the dataframes have repetead columns? 
data_frames <- list(
  primeira_liga_standard,
  primeira_liga_passing,
  primeira_liga_defense,
  primeira_liga_possession,
  primeira_liga_misc
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
primeira_liga_players_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
primeira_liga_players_fbref <- 
  primeira_liga_players_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(primeira_liga_players_fbref)

#keeper
primeira_liga_keeper <- fb_team_player_stats(team_urls = primeira_liga_teams, stat_type = 'keeper')
#add "_KEEPER" to the end of every column
primeira_liga_keeper <- 
  primeira_liga_keeper %>%
  rename_all(~paste0(., "_KEEPER"))
#rename the PlayerURL
primeira_liga_keeper <- 
  primeira_liga_keeper %>%
  rename(PlayerURL = PlayerURL_KEEPER)
#view(primeira_liga_keeper)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age")

#keeper_adv
primeira_liga_keeper_adv <- fb_team_player_stats(team_urls = primeira_liga_teams, stat_type = 'keeper_adv')
#remove repeated columns
primeira_liga_keeper_adv <- 
  primeira_liga_keeper_adv %>%
  select(-one_of(common_columns))
#add "_KEEPER_ADV" to the end of every column
primeira_liga_keeper_adv <- 
  primeira_liga_keeper_adv %>%
  rename_all(~paste0(., "_KEEPER_ADV"))
#rename the PlayerURL
primeira_liga_keeper_adv <- 
  primeira_liga_keeper_adv %>%
  rename(PlayerURL = PlayerURL_KEEPER_ADV)
#view(primeira_liga_keeper_adv)

#do the dataframes have repetead columns? 
data_frames <- list(
  primeira_liga_keeper,
  primeira_liga_keeper_adv
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
primeira_liga_keepers_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
primeira_liga_keepers_fbref <- 
  primeira_liga_keepers_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(primeira_liga_keepers_fbref)

#wages
#primeira_liga_wages <- fb_squad_wages(team_urls = primeira_liga_teams)
#rename the UrlFBRef
#primeira_liga_wages <- 
  #primeira_liga_wages %>%
  #rename(UrlFBref = Url)
#rename the WeeklyWageEUR_WAGES
#primeira_liga_wages <- 
  #primeira_liga_wages %>%
  #rename(WeeklyWageEUR_WAGES = WeeklyWageEUR)
#columns that need to be removed, to avoid repetition
#common_columns <- c("Team", "Comp", "Season", "Player", "Nation", "Pos", "Age", "WeeklyWageGBP", "WeeklyWageUSD",
                    #"AnnualWageGBP", "AnnualWageEUR", "AnnualWageUSD", "Notes")
#primeira_liga_wages <- 
  #primeira_liga_wages %>%
  #select(-one_of(common_columns))
#view(primeira_liga_wages)

#merge the original dataframe, with the one with the wages, for the outfield players
#data_frames <- list(
  #primeira_liga_players_fbref,
  #primeira_liga_wages
#)
#primeira_liga_players_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(primeira_liga_players_fbref)

#merge the original dataframe, with the one with the wages, for the goalkeepers
#data_frames <- list(
  #primeira_liga_keepers_fbref,
  #primeira_liga_wages
#)
#primeira_liga_keepers_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(primeira_liga_keepers_fbref)


#PART 2.8: FBREF BRASILEIRAO----------------------------------------------------------------------------


#fbref url
brasileirao <- fb_league_urls(country = "BRA", gender = "M", season_end_year = 2023, tier = '1st')
#print(brasileirao)

#list of the fbref urls for every team
brasileirao_teams <- fb_teams_urls(brasileirao)
#print(brasileirao_teams)

#stats for every team
#types of stats: standard, shooting, passing, passing_types, gca, defense, possession, playing_time, 
#misc, keepers, keepers_adv

#standard
brasileirao_standard <- fb_team_player_stats(team_urls = brasileirao_teams, stat_type= 'standard')
#remove goalkeepers
brasileirao_standard <- 
  brasileirao_standard %>%
  filter(Pos != "GK")
#add "_STANDARD" to the end of every column
brasileirao_standard <- 
  brasileirao_standard %>%
  rename_all(~paste0(., "_STANDARD"))
#rename the PlayerURL
brasileirao_standard <- 
  brasileirao_standard %>%
  rename(PlayerURL = PlayerURL_STANDARD)
#view(brasileirao_standard)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age", "Mins_Per_90")

#passing
brasileirao_passing <- fb_team_player_stats(team_urls = brasileirao_teams, stat_type= 'passing')
#remove goalkeepers
brasileirao_passing <- 
  brasileirao_passing %>%
  filter(Pos != "GK")
#remove repeated columns
brasileirao_passing <- 
  brasileirao_passing %>%
  select(-one_of(common_columns))
#add "_PASSING" to the end of every column
brasileirao_passing <- 
  brasileirao_passing %>%
  rename_all(~paste0(., "_PASSING"))
#rename the PlayerURL
brasileirao_passing <- 
  brasileirao_passing %>%
  rename(PlayerURL = PlayerURL_PASSING)
#view(brasileirao_passing)

#defense
brasileirao_defense <- fb_team_player_stats(team_urls = brasileirao_teams, stat_type = 'defense')
#remove goalkeepers
brasileirao_defense <- 
  brasileirao_defense %>%
  filter(Pos != "GK")
#remove repeated columns
brasileirao_defense <- 
  brasileirao_defense %>%
  select(-one_of(common_columns))
#add "_DEFENSE" to the end of every column
brasileirao_defense <- 
  brasileirao_defense %>%
  rename_all(~paste0(., "_DEFENSE"))
#rename the PlayerURL
brasileirao_defense <- 
  brasileirao_defense %>%
  rename(PlayerURL = PlayerURL_DEFENSE)
#view(brasileirao_defense)

#possession
brasileirao_possession <- fb_team_player_stats(team_urls = brasileirao_teams, stat_type = 'possession')
#remove goalkeepers
brasileirao_possession <- 
  brasileirao_possession %>%
  filter(Pos != "GK")
#remove repeated columns
brasileirao_possession <- 
  brasileirao_possession %>%
  select(-one_of(common_columns))
#add "_POSSESION" to the end of every column
brasileirao_possession <- 
  brasileirao_possession %>%
  rename_all(~paste0(., "_POSSESSION"))
#rename the PlayerURL
brasileirao_possession <- 
  brasileirao_possession %>%
  rename(PlayerURL = PlayerURL_POSSESSION)
#view(brasileirao_possession)

#misc
brasileirao_misc <- fb_team_player_stats(team_urls = brasileirao_teams, stat_type = 'misc')
#remove goalkeepers
brasileirao_misc <- 
  brasileirao_misc %>%
  filter(Pos != "GK")
#remove repeated columns
brasileirao_misc <- 
  brasileirao_misc %>%
  select(-one_of(common_columns))
#add "_MISC" to the end of every column
brasileirao_misc <- 
  brasileirao_misc %>%
  rename_all(~paste0(., "_MISC"))
#rename the PlayerURL
brasileirao_misc <- 
  brasileirao_misc %>%
  rename(PlayerURL = PlayerURL_MISC)
#view(brasileirao_misc)

#do the dataframes have repetead columns? 
data_frames <- list(
  brasileirao_standard,
  brasileirao_passing,
  brasileirao_defense,
  brasileirao_possession,
  brasileirao_misc
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
brasileirao_players_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
brasileirao_players_fbref <- 
  brasileirao_players_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(brasileirao_players_fbref)

#keeper
brasileirao_keeper <- fb_team_player_stats(team_urls = brasileirao_teams, stat_type = 'keeper')
#add "_KEEPER" to the end of every column
brasileirao_keeper <- 
  brasileirao_keeper %>%
  rename_all(~paste0(., "_KEEPER"))
#rename the PlayerURL
brasileirao_keeper <- 
  brasileirao_keeper %>%
  rename(PlayerURL = PlayerURL_KEEPER)
#view(brasileirao_keeper)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age")

#keeper_adv
brasileirao_keeper_adv <- fb_team_player_stats(team_urls = brasileirao_teams, stat_type = 'keeper_adv')
#remove repeated columns
brasileirao_keeper_adv <- 
  brasileirao_keeper_adv %>%
  select(-one_of(common_columns))
#add "_KEEPER_ADV" to the end of every column
brasileirao_keeper_adv <- 
  brasileirao_keeper_adv %>%
  rename_all(~paste0(., "_KEEPER_ADV"))
#rename the PlayerURL
brasileirao_keeper_adv <- 
  brasileirao_keeper_adv %>%
  rename(PlayerURL = PlayerURL_KEEPER_ADV)
#view(brasileirao_keeper_adv)

#do the dataframes have repetead columns? 
data_frames <- list(
  brasileirao_keeper,
  brasileirao_keeper_adv
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
brasileirao_keepers_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
brasileirao_keepers_fbref <- 
  brasileirao_keepers_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(brasileirao_keepers_fbref)

#wages
#brasileirao_wages <- fb_squad_wages(team_urls = brasileirao_teams)
#rename the UrlFBRef
#brasileirao_wages <- 
#brasileirao_wages %>%
#rename(UrlFBref = Url)
#rename the WeeklyWageEUR_WAGES
#brasileirao_wages <- 
#brasileirao_wages %>%
#rename(WeeklyWageEUR_WAGES = WeeklyWageEUR)
#columns that need to be removed, to avoid repetition
#common_columns <- c("Team", "Comp", "Season", "Player", "Nation", "Pos", "Age", "WeeklyWageGBP", "WeeklyWageUSD",
#"AnnualWageGBP", "AnnualWageEUR", "AnnualWageUSD", "Notes")
#brasileirao_wages <- 
#brasileirao_wages %>%
#select(-one_of(common_columns))
#view(brasileirao_wages)

#merge the original dataframe, with the one with the wages, for the outfield players
#data_frames <- list(
#brasileirao_players_fbref,
#brasileirao_wages
#)
#brasileirao_players_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(brasileirao_players_fbref)

#merge the original dataframe, with the one with the wages, for the goalkeepers
#data_frames <- list(
#brasileirao_keepers_fbref,
#brasileirao_wages
#)
#brasileirao_keepers_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(brasileirao_keepers_fbref)


#PART 2.9: FBREF SUPERLIGA----------------------------------------------------------------------------


#fbref url
superliga <- fb_league_urls(country = "ARG", gender = "M", season_end_year = 2023, tier = '1st')
#print(superliga)

#list of the fbref urls for every team
superliga_teams <- fb_teams_urls(superliga)
#print(superliga_teams)

#stats for every team
#types of stats: standard, shooting, passing, passing_types, gca, defense, possession, playing_time, 
#misc, keepers, keepers_adv

#standard
superliga_standard <- fb_team_player_stats(team_urls = superliga_teams, stat_type= 'standard')
#remove goalkeepers
superliga_standard <- 
  superliga_standard %>%
  filter(Pos != "GK")
#add "_STANDARD" to the end of every column
superliga_standard <- 
  superliga_standard %>%
  rename_all(~paste0(., "_STANDARD"))
#rename the PlayerURL
superliga_standard <- 
  superliga_standard %>%
  rename(PlayerURL = PlayerURL_STANDARD)
#view(superliga_standard)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age", "Mins_Per_90")

#passing
superliga_passing <- fb_team_player_stats(team_urls = superliga_teams, stat_type= 'passing')
#remove goalkeepers
superliga_passing <- 
  superliga_passing %>%
  filter(Pos != "GK")
#remove repeated columns
superliga_passing <- 
  superliga_passing %>%
  select(-one_of(common_columns))
#add "_PASSING" to the end of every column
superliga_passing <- 
  superliga_passing %>%
  rename_all(~paste0(., "_PASSING"))
#rename the PlayerURL
superliga_passing <- 
  superliga_passing %>%
  rename(PlayerURL = PlayerURL_PASSING)
#view(superliga_passing)

#defense
superliga_defense <- fb_team_player_stats(team_urls = superliga_teams, stat_type = 'defense')
#remove goalkeepers
superliga_defense <- 
  superliga_defense %>%
  filter(Pos != "GK")
#remove repeated columns
superliga_defense <- 
  superliga_defense %>%
  select(-one_of(common_columns))
#add "_DEFENSE" to the end of every column
superliga_defense <- 
  superliga_defense %>%
  rename_all(~paste0(., "_DEFENSE"))
#rename the PlayerURL
superliga_defense <- 
  superliga_defense %>%
  rename(PlayerURL = PlayerURL_DEFENSE)
#view(superliga_defense)

#possession
superliga_possession <- fb_team_player_stats(team_urls = superliga_teams, stat_type = 'possession')
#remove goalkeepers
superliga_possession <- 
  superliga_possession %>%
  filter(Pos != "GK")
#remove repeated columns
superliga_possession <- 
  superliga_possession %>%
  select(-one_of(common_columns))
#add "_POSSESION" to the end of every column
superliga_possession <- 
  superliga_possession %>%
  rename_all(~paste0(., "_POSSESSION"))
#rename the PlayerURL
superliga_possession <- 
  superliga_possession %>%
  rename(PlayerURL = PlayerURL_POSSESSION)
#view(superliga_possession)

#misc
superliga_misc <- fb_team_player_stats(team_urls = superliga_teams, stat_type = 'misc')
#remove goalkeepers
superliga_misc <- 
  superliga_misc %>%
  filter(Pos != "GK")
#remove repeated columns
superliga_misc <- 
  superliga_misc %>%
  select(-one_of(common_columns))
#add "_MISC" to the end of every column
superliga_misc <- 
  superliga_misc %>%
  rename_all(~paste0(., "_MISC"))
#rename the PlayerURL
superliga_misc <- 
  superliga_misc %>%
  rename(PlayerURL = PlayerURL_MISC)
#view(superliga_misc)

#do the dataframes have repetead columns? 
data_frames <- list(
  superliga_standard,
  superliga_passing,
  superliga_defense,
  superliga_possession,
  superliga_misc
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
superliga_players_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
superliga_players_fbref <- 
  superliga_players_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(superliga_players_fbref)

#keeper
superliga_keeper <- fb_team_player_stats(team_urls = superliga_teams, stat_type = 'keeper')
#add "_KEEPER" to the end of every column
superliga_keeper <- 
  superliga_keeper %>%
  rename_all(~paste0(., "_KEEPER"))
#rename the PlayerURL
superliga_keeper <- 
  superliga_keeper %>%
  rename(PlayerURL = PlayerURL_KEEPER)
#view(superliga_keeper)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age")

#keeper_adv
superliga_keeper_adv <- fb_team_player_stats(team_urls = superliga_teams, stat_type = 'keeper_adv')
#remove repeated columns
superliga_keeper_adv <- 
  superliga_keeper_adv %>%
  select(-one_of(common_columns))
#add "_KEEPER_ADV" to the end of every column
superliga_keeper_adv <- 
  superliga_keeper_adv %>%
  rename_all(~paste0(., "_KEEPER_ADV"))
#rename the PlayerURL
superliga_keeper_adv <- 
  superliga_keeper_adv %>%
  rename(PlayerURL = PlayerURL_KEEPER_ADV)
#view(superliga_keeper_adv)

#do the dataframes have repetead columns? 
data_frames <- list(
  superliga_keeper,
  superliga_keeper_adv
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
superliga_keepers_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
superliga_keepers_fbref <- 
  superliga_keepers_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(superliga_keepers_fbref)

#wages
#superliga_wages <- fb_squad_wages(team_urls = superliga_teams)
#rename the UrlFBRef
#superliga_wages <- 
#superliga_wages %>%
#rename(UrlFBref = Url)
#rename the WeeklyWageEUR_WAGES
#superliga_wages <- 
#superliga_wages %>%
#rename(WeeklyWageEUR_WAGES = WeeklyWageEUR)
#columns that need to be removed, to avoid repetition
#common_columns <- c("Team", "Comp", "Season", "Player", "Nation", "Pos", "Age", "WeeklyWageGBP", "WeeklyWageUSD",
#"AnnualWageGBP", "AnnualWageEUR", "AnnualWageUSD", "Notes")
#superliga_wages <- 
#superliga_wages %>%
#select(-one_of(common_columns))
#view(superliga_wages)

#merge the original dataframe, with the one with the wages, for the outfield players
#data_frames <- list(
#superliga_players_fbref,
#superliga_wages
#)
#superliga_players_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(superliga_players_fbref)

#merge the original dataframe, with the one with the wages, for the goalkeepers
#data_frames <- list(
#superliga_keepers_fbref,
#superliga_wages
#)
#superliga_keepers_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(superliga_keepers_fbref)


#PART 2.10: FBREF MLS----------------------------------------------------------------------------------


#fbref url
mls <- fb_league_urls(country = "USA", gender = "M", season_end_year = 2023, tier = '1st')
#print(mls)

#list of the fbref urls for every team
mls_teams <- fb_teams_urls(mls)
#print(mls_teams)

#stats for every team
#types of stats: standard, shooting, passing, passing_types, gca, defense, possession, playing_time, 
#misc, keepers, keepers_adv

#standard
mls_standard <- fb_team_player_stats(team_urls = mls_teams, stat_type= 'standard')
#remove goalkeepers
mls_standard <- 
  mls_standard %>%
  filter(Pos != "GK")
#add "_STANDARD" to the end of every column
mls_standard <- 
  mls_standard %>%
  rename_all(~paste0(., "_STANDARD"))
#rename the PlayerURL
mls_standard <- 
  mls_standard %>%
  rename(PlayerURL = PlayerURL_STANDARD)
#view(mls_standard)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age", "Mins_Per_90")

#passing
mls_passing <- fb_team_player_stats(team_urls = mls_teams, stat_type= 'passing')
#remove goalkeepers
mls_passing <- 
  mls_passing %>%
  filter(Pos != "GK")
#remove repeated columns
mls_passing <- 
  mls_passing %>%
  select(-one_of(common_columns))
#add "_PASSING" to the end of every column
mls_passing <- 
  mls_passing %>%
  rename_all(~paste0(., "_PASSING"))
#rename the PlayerURL
mls_passing <- 
  mls_passing %>%
  rename(PlayerURL = PlayerURL_PASSING)
#view(mls_passing)

#defense
mls_defense <- fb_team_player_stats(team_urls = mls_teams, stat_type = 'defense')
#remove goalkeepers
mls_defense <- 
  mls_defense %>%
  filter(Pos != "GK")
#remove repeated columns
mls_defense <- 
  mls_defense %>%
  select(-one_of(common_columns))
#add "_DEFENSE" to the end of every column
mls_defense <- 
  mls_defense %>%
  rename_all(~paste0(., "_DEFENSE"))
#rename the PlayerURL
mls_defense <- 
  mls_defense %>%
  rename(PlayerURL = PlayerURL_DEFENSE)
#view(mls_defense)

#possession
mls_possession <- fb_team_player_stats(team_urls = mls_teams, stat_type = 'possession')
#remove goalkeepers
mls_possession <- 
  mls_possession %>%
  filter(Pos != "GK")
#remove repeated columns
mls_possession <- 
  mls_possession %>%
  select(-one_of(common_columns))
#add "_POSSESION" to the end of every column
mls_possession <- 
  mls_possession %>%
  rename_all(~paste0(., "_POSSESSION"))
#rename the PlayerURL
mls_possession <- 
  mls_possession %>%
  rename(PlayerURL = PlayerURL_POSSESSION)
#view(mls_possession)

#misc
mls_misc <- fb_team_player_stats(team_urls = mls_teams, stat_type = 'misc')
#remove goalkeepers
mls_misc <- 
  mls_misc %>%
  filter(Pos != "GK")
#remove repeated columns
mls_misc <- 
  mls_misc %>%
  select(-one_of(common_columns))
#add "_MISC" to the end of every column
mls_misc <- 
  mls_misc %>%
  rename_all(~paste0(., "_MISC"))
#rename the PlayerURL
mls_misc <- 
  mls_misc %>%
  rename(PlayerURL = PlayerURL_MISC)
#view(mls_misc)

#do the dataframes have repetead columns? 
data_frames <- list(
  mls_standard,
  mls_passing,
  mls_defense,
  mls_possession,
  mls_misc
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
mls_players_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
mls_players_fbref <- 
  mls_players_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(mls_players_fbref)

#keeper
mls_keeper <- fb_team_player_stats(team_urls = mls_teams, stat_type = 'keeper')
#add "_KEEPER" to the end of every column
mls_keeper <- 
  mls_keeper %>%
  rename_all(~paste0(., "_KEEPER"))
#rename the PlayerURL
mls_keeper <- 
  mls_keeper %>%
  rename(PlayerURL = PlayerURL_KEEPER)
#view(mls_keeper)
#columns that need to be removed, to avoid repetition
common_columns <- c("Season", "Squad", "Comp", "Player", "Nation", "Pos", "Age")

#keeper_adv
mls_keeper_adv <- fb_team_player_stats(team_urls = mls_teams, stat_type = 'keeper_adv')
#remove repeated columns
mls_keeper_adv <- 
  mls_keeper_adv %>%
  select(-one_of(common_columns))
#add "_KEEPER_ADV" to the end of every column
mls_keeper_adv <- 
  mls_keeper_adv %>%
  rename_all(~paste0(., "_KEEPER_ADV"))
#rename the PlayerURL
mls_keeper_adv <- 
  mls_keeper_adv %>%
  rename(PlayerURL = PlayerURL_KEEPER_ADV)
#view(mls_keeper_adv)

#do the dataframes have repetead columns? 
data_frames <- list(
  mls_keeper,
  mls_keeper_adv
)
common_columns <- Reduce(intersect, lapply(data_frames, names))
#print(common_columns)

#merge every dataframe
mls_keepers_fbref <- reduce(data_frames, left_join, by = "PlayerURL")
#rename the UrlFBRef
mls_keepers_fbref <- 
  mls_keepers_fbref %>%
  rename(UrlFBref = PlayerURL)
#view(mls_keepers_fbref)

#wages
#mls_wages <- fb_squad_wages(team_urls = mls_teams)
#rename the UrlFBRef
#mls_wages <- 
#mls_wages %>%
#rename(UrlFBref = Url)
#rename the WeeklyWageEUR_WAGES
#mls_wages <- 
#mls_wages %>%
#rename(WeeklyWageEUR_WAGES = WeeklyWageEUR)
#columns that need to be removed, to avoid repetition
#common_columns <- c("Team", "Comp", "Season", "Player", "Nation", "Pos", "Age", "WeeklyWageGBP", "WeeklyWageUSD",
#"AnnualWageGBP", "AnnualWageEUR", "AnnualWageUSD", "Notes")
#mls_wages <- 
#mls_wages %>%
#select(-one_of(common_columns))
#view(mls_wages)

#merge the original dataframe, with the one with the wages, for the outfield players
#data_frames <- list(
#mls_players_fbref,
#mls_wages
#)
#mls_players_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(mls_players_fbref)

#merge the original dataframe, with the one with the wages, for the goalkeepers
#data_frames <- list(
#mls_keepers_fbref,
#mls_wages
#)
#mls_keepers_fbref <- reduce(data_frames, left_join, by = "UrlFBref")
#view(mls_keepers_fbref)


#PART 3: TRANSFERMARKT-----------------------------------------------------------------------------------


#website
#https://www.transfermarkt.com/
#notebook
#https://jaseziv.github.io/worldfootballR/articles/extract-transfermarkt-data.html


#PART 3.1: TRANSFERMARKT PREMIER LEAGUE------------------------------------------------------------------


#information of the players, according to their league
premier_league_players_transfermarkt <- tm_player_market_values(country_name = "England", start_year = 2023)
#remove excess columns
excess_columns <- c("region", "country", "season_start_year", "squad", "player_num", 
                    "player_dob", "player_age", "current_club", "date_joined", "joined_from", "player_name")
premier_league_players_transfermarkt <- 
  premier_league_players_transfermarkt %>%
  select(-one_of(excess_columns))
#add "_TM" to the end of every column
premier_league_players_transfermarkt <- 
  premier_league_players_transfermarkt %>%
  rename_all(~paste0(., "_TM"))
#rename the UrlTmarkt
premier_league_players_transfermarkt <- 
  premier_league_players_transfermarkt %>%
  rename(UrlTmarkt = player_url_TM)
#view(premier_league_players_transfermarkt)


#PART 3.2: TRANSFERMARKT LA LIGA-------------------------------------------------------------------------


#information of the players, according to their league
la_liga_players_transfermarkt <- tm_player_market_values(country_name = "Spain", start_year = 2023)
#remove excess columns
excess_columns <- c("region", "country", "season_start_year", "squad", "player_num", 
                    "player_dob", "player_age", "current_club", "date_joined", "joined_from", "player_name")
la_liga_players_transfermarkt <- 
  la_liga_players_transfermarkt %>%
  select(-one_of(excess_columns))
#add "_TM" to the end of every column
la_liga_players_transfermarkt <- 
  la_liga_players_transfermarkt %>%
  rename_all(~paste0(., "_TM"))
#rename the UrlTmarkt
la_liga_players_transfermarkt <- 
  la_liga_players_transfermarkt %>%
  rename(UrlTmarkt = player_url_TM)
#view(la_liga_players_transfermarkt)


#PART 3.3: TRANSFERMARKT SERIE A-------------------------------------------------------------------------


#information of the players, according to their league
serie_a_players_transfermarkt <- tm_player_market_values(country_name = "Italy", start_year = 2023)
#remove excess columns
excess_columns <- c("region", "country", "season_start_year", "squad", "player_num", 
                    "player_dob", "player_age", "current_club", "date_joined", "joined_from", "player_name")
serie_a_players_transfermarkt <- 
  serie_a_players_transfermarkt %>%
  select(-one_of(excess_columns))
#add "_TM" to the end of every column
serie_a_players_transfermarkt <- 
  serie_a_players_transfermarkt %>%
  rename_all(~paste0(., "_TM"))
#rename the UrlTmarkt
serie_a_players_transfermarkt <- 
  serie_a_players_transfermarkt %>%
  rename(UrlTmarkt = player_url_TM)
#view(serie_a_players_transfermarkt)


#PART 3.4: TRANSFERMARKT BUNDESLIGA----------------------------------------------------------------------


#information of the players, according to their league
bundesliga_players_transfermarkt <- tm_player_market_values(country_name = "Germany", start_year = 2023)
#remove excess columns
excess_columns <- c("region", "country", "season_start_year", "squad", "player_num", 
                    "player_dob", "player_age", "current_club", "date_joined", "joined_from", "player_name")
bundesliga_players_transfermarkt <- 
  bundesliga_players_transfermarkt %>%
  select(-one_of(excess_columns))
#add "_TM" to the end of every column
bundesliga_players_transfermarkt <- 
  bundesliga_players_transfermarkt %>%
  rename_all(~paste0(., "_TM"))
#rename the UrlTmarkt
bundesliga_players_transfermarkt <- 
  bundesliga_players_transfermarkt %>%
  rename(UrlTmarkt = player_url_TM)
#view(bundesliga_players_transfermarkt)


#PART 3.5: TRANSFERMARKT LIGUE ONE-----------------------------------------------------------------------


#information of the players, according to their league
ligue_one_players_transfermarkt <- tm_player_market_values(country_name = "France", start_year = 2023)
#remove excess columns
excess_columns <- c("region", "country", "season_start_year", "squad", "player_num", 
                    "player_dob", "player_age", "current_club", "date_joined", "joined_from", "player_name")
ligue_one_players_transfermarkt <- 
  ligue_one_players_transfermarkt %>%
  select(-one_of(excess_columns))
#add "_TM" to the end of every column
ligue_one_players_transfermarkt <- 
  ligue_one_players_transfermarkt %>%
  rename_all(~paste0(., "_TM"))
#rename the UrlTmarkt
ligue_one_players_transfermarkt <- 
  ligue_one_players_transfermarkt %>%
  rename(UrlTmarkt = player_url_TM)
#view(ligue_one_players_transfermarkt)


#PART 3.6: TRANSFERMARKT EREDIVISIE---------------------------------------------------------------------


#information of the players, according to their league
eredivisie_players_transfermarkt <- tm_player_market_values(country_name = "Netherlands", start_year = 2023)
#remove excess columns
excess_columns <- c("region", "country", "season_start_year", "squad", "player_num", 
                    "player_dob", "player_age", "current_club", "date_joined", "joined_from", "player_name")
eredivisie_players_transfermarkt <- 
  eredivisie_players_transfermarkt %>%
  select(-one_of(excess_columns))
#add "_TM" to the end of every column
eredivisie_players_transfermarkt <- 
  eredivisie_players_transfermarkt %>%
  rename_all(~paste0(., "_TM"))
#rename the UrlTmarkt
eredivisie_players_transfermarkt <- 
  eredivisie_players_transfermarkt %>%
  rename(UrlTmarkt = player_url_TM)
#view(eredivisie_players_transfermarkt)


#PART 3.7: TRANSFERMARKT PRIMEIRA LIGA------------------------------------------------------------------


#information of the players, according to their league
primeira_liga_players_transfermarkt <- tm_player_market_values(country_name = "Portugal", start_year = 2023)
#remove excess columns
excess_columns <- c("region", "country", "season_start_year", "squad", "player_num", 
                    "player_dob", "player_age", "current_club", "date_joined", "joined_from", "player_name")
primeira_liga_players_transfermarkt <- 
  primeira_liga_players_transfermarkt %>%
  select(-one_of(excess_columns))
#add "_TM" to the end of every column
primeira_liga_players_transfermarkt <- 
  primeira_liga_players_transfermarkt %>%
  rename_all(~paste0(., "_TM"))
#rename the UrlTmarkt
primeira_liga_players_transfermarkt <- 
  primeira_liga_players_transfermarkt %>%
  rename(UrlTmarkt = player_url_TM)
#view(primeira_liga_players_transfermarkt)


#PART 3.8: TRANSFERMARKT BRASILEIRAO------------------------------------------------------------------


#information of the players, according to their league
brasileirao_players_transfermarkt <- tm_player_market_values(country_name = "Brazil", start_year = 2023)
#remove excess columns
excess_columns <- c("region", "country", "season_start_year", "squad", "player_num", 
                    "player_dob", "player_age", "current_club", "date_joined", "joined_from", "player_name")
brasileirao_players_transfermarkt <- 
  brasileirao_players_transfermarkt %>%
  select(-one_of(excess_columns))
#add "_TM" to the end of every column
brasileirao_players_transfermarkt <- 
  brasileirao_players_transfermarkt %>%
  rename_all(~paste0(., "_TM"))
#rename the UrlTmarkt
brasileirao_players_transfermarkt <- 
  brasileirao_players_transfermarkt %>%
  rename(UrlTmarkt = player_url_TM)
#view(brasileirao_players_transfermarkt)


#PART 3.9: TRANSFERMARKT SUPERLIGA------------------------------------------------------------------


#information of the players, according to their league
superliga_players_transfermarkt <- tm_player_market_values(country_name = "Argentina", start_year = 2023)
#remove excess columns
excess_columns <- c("region", "country", "season_start_year", "squad", "player_num", 
                    "player_dob", "player_age", "current_club", "date_joined", "joined_from", "player_name")
superliga_players_transfermarkt <- 
  superliga_players_transfermarkt %>%
  select(-one_of(excess_columns))
#add "_TM" to the end of every column
superliga_players_transfermarkt <- 
  superliga_players_transfermarkt %>%
  rename_all(~paste0(., "_TM"))
#rename the UrlTmarkt
superliga_players_transfermarkt <- 
  superliga_players_transfermarkt %>%
  rename(UrlTmarkt = player_url_TM)
#view(superliga_players_transfermarkt)


#PART 3.10: TRANSFERMARKT MLS----------------------------------------------------------------------------


#information of the players, according to their league
mls_players_transfermarkt <- tm_player_market_values(country_name = "United States", start_year = 2023)
#remove excess columns
excess_columns <- c("region", "country", "season_start_year", "squad", "player_num", 
                    "player_dob", "player_age", "current_club", "date_joined", "joined_from", "player_name")
mls_players_transfermarkt <- 
  mls_players_transfermarkt %>%
  select(-one_of(excess_columns))
#add "_TM" to the end of every column
mls_players_transfermarkt <- 
  mls_players_transfermarkt %>%
  rename_all(~paste0(., "_TM"))
#rename the UrlTmarkt
mls_players_transfermarkt <- 
  mls_players_transfermarkt %>%
  rename(UrlTmarkt = player_url_TM)
#view(mls_players_transfermarkt)


#PART 4: MERGE FBREF AND TRANSFERMARKT-------------------------------------------------------------------


players_mapping <- player_dictionary_mapping()
#remove excess columns
excess_columns <- c("PlayerFBref", "TmPos")
players_mapping <- 
  players_mapping %>%
  select(-one_of(excess_columns))
#view(players_mapping)


#PART 4.1: MERGE FBREF AND TRANSFERMARKT PREMIER LEAGUE--------------------------------------------------


#merge the fbref dataframe with the one with the mapping, for the oufield players
data_frames <- list(
  premier_league_players_fbref,
  players_mapping
)
premier_league_players_fbref_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(premier_league_players_fbref_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the oufiled players
data_frames <- list(
  premier_league_players_fbref_mapping,
  premier_league_players_transfermarkt
)
premier_league_players_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(premier_league_players_fbref_transfermarkt)

#merge the fbref dataframe with the one with the mapping, for the goalkeepers
data_frames <- list(
  premier_league_keepers_fbref,
  players_mapping
)
premier_league_fbref_keepers_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(premier_league_fbref_keepers_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the goalkeepers
data_frames <- list(
  premier_league_fbref_keepers_mapping,
  premier_league_players_transfermarkt
)
premier_league_keepers_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(premier_league_keepers_fbref_transfermarkt)


#PART 4.2: MERGE FBREF AND TRANSFERMARKT LA LIGA---------------------------------------------------------


#merge the fbref dataframe with the one with the mapping, for the oufield players
data_frames <- list(
  la_liga_players_fbref,
  players_mapping
)
la_liga_players_fbref_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(la_liga_players_fbref_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the oufiled players
data_frames <- list(
  la_liga_players_fbref_mapping,
  la_liga_players_transfermarkt
)
la_liga_players_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(la_liga_players_fbref_transfermarkt)

#merge the fbref dataframe with the one with the mapping, for the goalkeepers
data_frames <- list(
  la_liga_keepers_fbref,
  players_mapping
)
la_liga_fbref_keepers_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(la_liga_fbref_keepers_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the goalkeepers
data_frames <- list(
  la_liga_fbref_keepers_mapping,
  la_liga_players_transfermarkt
)
la_liga_keepers_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(la_liga_keepers_fbref_transfermarkt)


#PART 4.3: MERGE FBREF AND TRANSFERMARKT SERIE A---------------------------------------------------------


#merge the fbref dataframe with the one with the mapping, for the oufield players
data_frames <- list(
  serie_a_players_fbref,
  players_mapping
)
serie_a_players_fbref_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(serie_a_players_fbref_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the oufiled players
data_frames <- list(
  serie_a_players_fbref_mapping,
  serie_a_players_transfermarkt
)
serie_a_players_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(serie_a_players_fbref_transfermarkt)

#merge the fbref dataframe with the one with the mapping, for the goalkeepers
data_frames <- list(
  serie_a_keepers_fbref,
  players_mapping
)
serie_a_fbref_keepers_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(serie_a_fbref_keepers_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the goalkeepers
data_frames <- list(
  serie_a_fbref_keepers_mapping,
  serie_a_players_transfermarkt
)
serie_a_keepers_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(serie_a_keepers_fbref_transfermarkt)


#PART 4.4: MERGE FBREF AND TRANSFERMARKT BUNDESLIGA------------------------------------------------------


#merge the fbref dataframe with the one with the mapping, for the oufield players
data_frames <- list(
  bundesliga_players_fbref,
  players_mapping
)
bundesliga_players_fbref_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(bundesliga_players_fbref_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the oufiled players
data_frames <- list(
  bundesliga_players_fbref_mapping,
  bundesliga_players_transfermarkt
)
bundesliga_players_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(bundesliga_players_fbref_transfermarkt)

#merge the fbref dataframe with the one with the mapping, for the goalkeepers
data_frames <- list(
  bundesliga_keepers_fbref,
  players_mapping
)
bundesliga_fbref_keepers_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(bundesliga_fbref_keepers_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the goalkeepers
data_frames <- list(
  bundesliga_fbref_keepers_mapping,
  bundesliga_players_transfermarkt
)
bundesliga_keepers_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(bundesliga_keepers_fbref_transfermarkt)


#PART 4.5: MERGE FBREF AND TRANSFERMARKT LIGUE ONE-------------------------------------------------------


#merge the fbref dataframe with the one with the mapping, for the oufield players
data_frames <- list(
  ligue_one_players_fbref,
  players_mapping
)
ligue_one_players_fbref_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(ligue_one_players_fbref_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the oufiled players
data_frames <- list(
  ligue_one_players_fbref_mapping,
  ligue_one_players_transfermarkt
)
ligue_one_players_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(ligue_one_players_fbref_transfermarkt)

#merge the fbref dataframe with the one with the mapping, for the goalkeepers
data_frames <- list(
  ligue_one_keepers_fbref,
  players_mapping
)
ligue_one_fbref_keepers_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(ligue_one_fbref_keepers_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the goalkeepers
data_frames <- list(
  ligue_one_fbref_keepers_mapping,
  ligue_one_players_transfermarkt
)
ligue_one_keepers_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(ligue_one_keepers_fbref_transfermarkt)


#PART 4.6: MERGE FBREF AND TRANSFERMARKT EREDIVISIE---------------------------------------------------


#merge the fbref dataframe with the one with the mapping, for the oufield players
data_frames <- list(
  eredivisie_players_fbref,
  players_mapping
)
eredivisie_players_fbref_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(eredivisie_players_fbref_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the oufiled players
data_frames <- list(
  eredivisie_players_fbref_mapping,
  eredivisie_players_transfermarkt
)
eredivisie_players_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(eredivisie_players_fbref_transfermarkt)

#merge the fbref dataframe with the one with the mapping, for the goalkeepers
data_frames <- list(
  eredivisie_keepers_fbref,
  players_mapping
)
eredivisie_fbref_keepers_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(eredivisie_fbref_keepers_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the goalkeepers
data_frames <- list(
  eredivisie_fbref_keepers_mapping,
  eredivisie_players_transfermarkt
)
eredivisie_keepers_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(eredivisie_keepers_fbref_transfermarkt)


#PART 4.7: MERGE FBREF AND TRANSFERMARKT PRIMEIRA LIGA--------------------------------------------------


#merge the fbref dataframe with the one with the mapping, for the oufield players
data_frames <- list(
  primeira_liga_players_fbref,
  players_mapping
)
primeira_liga_players_fbref_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(primeira_liga_players_fbref_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the oufiled players
data_frames <- list(
  primeira_liga_players_fbref_mapping,
  primeira_liga_players_transfermarkt
)
primeira_liga_players_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(primeira_liga_players_fbref_transfermarkt)

#merge the fbref dataframe with the one with the mapping, for the goalkeepers
data_frames <- list(
  primeira_liga_keepers_fbref,
  players_mapping
)
primeira_liga_fbref_keepers_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(primeira_liga_fbref_keepers_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the goalkeepers
data_frames <- list(
  primeira_liga_fbref_keepers_mapping,
  primeira_liga_players_transfermarkt
)
primeira_liga_keepers_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(primeira_liga_keepers_fbref_transfermarkt)


#PART 4.8: MERGE FBREF AND TRANSFERMARKT BRASILEIRAO----------------------------------------------------


#merge the fbref dataframe with the one with the mapping, for the oufield players
data_frames <- list(
  brasileirao_players_fbref,
  players_mapping
)
brasileirao_players_fbref_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(brasileirao_players_fbref_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the oufiled players
data_frames <- list(
  brasileirao_players_fbref_mapping,
  brasileirao_players_transfermarkt
)
brasileirao_players_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(brasileirao_players_fbref_transfermarkt)

#merge the fbref dataframe with the one with the mapping, for the goalkeepers
data_frames <- list(
  brasileirao_keepers_fbref,
  players_mapping
)
brasileirao_fbref_keepers_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(brasileirao_fbref_keepers_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the goalkeepers
data_frames <- list(
  brasileirao_fbref_keepers_mapping,
  brasileirao_players_transfermarkt
)
brasileirao_keepers_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(brasileirao_keepers_fbref_transfermarkt)


#PART 4.9: MERGE FBREF AND TRANSFERMARKT SUPERLIGA------------------------------------------------------


#merge the fbref dataframe with the one with the mapping, for the oufield players
data_frames <- list(
  superliga_players_fbref,
  players_mapping
)
superliga_players_fbref_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(superliga_players_fbref_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the oufiled players
data_frames <- list(
  superliga_players_fbref_mapping,
  superliga_players_transfermarkt
)
superliga_players_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(superliga_players_fbref_transfermarkt)

#merge the fbref dataframe with the one with the mapping, for the goalkeepers
data_frames <- list(
  superliga_keepers_fbref,
  players_mapping
)
superliga_fbref_keepers_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(superliga_fbref_keepers_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the goalkeepers
data_frames <- list(
  superliga_fbref_keepers_mapping,
  superliga_players_transfermarkt
)
superliga_keepers_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(superliga_keepers_fbref_transfermarkt)


#PART 4.10: MERGE FBREF AND TRANSFERMARKT MLS----------------------------------------------------------


#merge the fbref dataframe with the one with the mapping, for the oufield players
data_frames <- list(
  mls_players_fbref,
  players_mapping
)
mls_players_fbref_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(mls_players_fbref_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the oufiled players
data_frames <- list(
  mls_players_fbref_mapping,
  mls_players_transfermarkt
)
mls_players_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(mls_players_fbref_transfermarkt)

#merge the fbref dataframe with the one with the mapping, for the goalkeepers
data_frames <- list(
  mls_keepers_fbref,
  players_mapping
)
mls_fbref_keepers_mapping <- reduce(data_frames, left_join, by = "UrlFBref")
#view(mls_fbref_keepers_mapping)

#merge the last dataframe with the transfermarkt dataframe, for the goalkeepers
data_frames <- list(
  mls_fbref_keepers_mapping,
  mls_players_transfermarkt
)
mls_keepers_fbref_transfermarkt <- reduce(data_frames, left_join, by = "UrlTmarkt")
#view(mls_keepers_fbref_transfermarkt)


#PART 5: DATA CLEANING-----------------------------------------------------------------------------------


#PART 5.1: DATA CLEANING PREMIER LEAGUE-----------------------------------------------------------------


#remove NULL columns, for the outfield players
excess_columns <- c("MP_Playing_Time_STANDARD")
premier_league_players_fbref_transfermarkt <- 
  premier_league_players_fbref_transfermarkt %>%
  select(-one_of(excess_columns))
#view(premier_league_players_fbref_transfermarkt)

#count of NULL observations, for the outfield players
null_counts <- apply(premier_league_players_fbref_transfermarkt, 1, function(row) sum(is.na(row)))
#print(null_counts)
#remove observations with 122 or more NULLs, for the outfield players
premier_league_players_fbref_transfermarkt <- premier_league_players_fbref_transfermarkt[rowSums(is.na(premier_league_players_fbref_transfermarkt)) < 122, ]
#view(premier_league_players_fbref_transfermarkt)

#remove repeated observations, for the outfield players
premier_league_players_fbref_transfermarkt <- premier_league_players_fbref_transfermarkt[!duplicated(premier_league_players_fbref_transfermarkt$UrlTmarkt), ]
#view(premier_league_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the outfield players
premier_league_players_fbref_transfermarkt <- subset(premier_league_players_fbref_transfermarkt, !is.na(player_position_TM))
#view(premier_league_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the goalkeepers
premier_league_keepers_fbref_transfermarkt <- subset(premier_league_keepers_fbref_transfermarkt, !is.na(player_position_TM))
#view(premier_league_keepers_fbref_transfermarkt)

#remove the observations with <30% of the minutes possible, for the oufield players
max_premier_league_players <- (max(premier_league_players_fbref_transfermarkt$Starts_Playing_Time_STANDARD)*90)*0.30
premier_league_players_fbref_transfermarkt <- premier_league_players_fbref_transfermarkt[premier_league_players_fbref_transfermarkt$Min_Playing_Time_STANDARD >= max_premier_league_players, ]

#remove the observations with <30% of the minutes possible, for the goalkeepers
max_premier_league_keepers <- (max(premier_league_keepers_fbref_transfermarkt$MP_Playing_Time_KEEPER)*90)*0.30
premier_league_keepers_fbref_transfermarkt <- premier_league_keepers_fbref_transfermarkt[premier_league_keepers_fbref_transfermarkt$Min_Playing_Time_KEEPER >= max_premier_league_keepers, ]


#PART 5.2: DATA CLEANING LA LIGA-------------------------------------------------------------------------


#remove NULL columns, for the outfield players
excess_columns <- c("MP_Playing_Time_STANDARD")
la_liga_players_fbref_transfermarkt <- 
  la_liga_players_fbref_transfermarkt %>%
  select(-one_of(excess_columns))
#view(la_liga_players_fbref_transfermarkt)

#count of NULL observations, for the outfield players
null_counts <- apply(la_liga_players_fbref_transfermarkt, 1, function(row) sum(is.na(row)))
#print(null_counts)
#remove observations with 122 or more NULLs, for the outfield players
la_liga_players_fbref_transfermarkt <- la_liga_players_fbref_transfermarkt[rowSums(is.na(la_liga_players_fbref_transfermarkt)) < 122, ]
#view(la_liga_players_fbref_transfermarkt)

#remove repeated observations, for the outfield players
la_liga_players_fbref_transfermarkt <- la_liga_players_fbref_transfermarkt[!duplicated(la_liga_players_fbref_transfermarkt$UrlTmarkt), ]
#view(la_liga_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the outfield players
la_liga_players_fbref_transfermarkt <- subset(la_liga_players_fbref_transfermarkt, !is.na(player_position_TM))
#view(la_liga_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the goalkeepers
la_liga_keepers_fbref_transfermarkt <- subset(la_liga_keepers_fbref_transfermarkt, !is.na(player_position_TM))
#view(la_liga_keepers_fbref_transfermarkt)

#remove the observations with <30% of the minutes possible, for the oufield players
max_la_liga_players <- (max(la_liga_players_fbref_transfermarkt$Starts_Playing_Time_STANDARD)*90)*0.30
la_liga_players_fbref_transfermarkt <- la_liga_players_fbref_transfermarkt[la_liga_players_fbref_transfermarkt$Min_Playing_Time_STANDARD >= max_la_liga_players, ]
#remove the observations with <30% of the minutes possible, for the goalkeepers
max_la_liga_keepers <- (max(la_liga_keepers_fbref_transfermarkt$MP_Playing_Time_KEEPER)*90)*0.30
la_liga_keepers_fbref_transfermarkt <- la_liga_keepers_fbref_transfermarkt[la_liga_keepers_fbref_transfermarkt$Min_Playing_Time_KEEPER >= max_la_liga_keepers, ]


#PART 5.3: DATA CLEANING SERIE A-------------------------------------------------------------------------


#remove NULL columns, for the outfield players
excess_columns <- c("MP_Playing_Time_STANDARD")
serie_a_players_fbref_transfermarkt <- 
  serie_a_players_fbref_transfermarkt %>%
  select(-one_of(excess_columns))
#view(serie_a_players_fbref_transfermarkt)

#count of NULL observations, for the outfield players
null_counts <- apply(serie_a_players_fbref_transfermarkt, 1, function(row) sum(is.na(row)))
#print(null_counts)
#remove observations with 122 or more NULLs, for the outfield players
serie_a_players_fbref_transfermarkt <- serie_a_players_fbref_transfermarkt[rowSums(is.na(serie_a_players_fbref_transfermarkt)) < 122, ]
#view(serie_a_players_fbref_transfermarkt)

#remove repeated observations, for the outfield players
serie_a_players_fbref_transfermarkt <- serie_a_players_fbref_transfermarkt[!duplicated(serie_a_players_fbref_transfermarkt$UrlTmarkt), ]
#view(serie_a_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the outfield players
serie_a_players_fbref_transfermarkt <- subset(serie_a_players_fbref_transfermarkt, !is.na(player_position_TM))
#view(serie_a_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the goalkeepers
serie_a_keepers_fbref_transfermarkt <- subset(serie_a_keepers_fbref_transfermarkt, !is.na(player_position_TM))
#view(serie_a_keepers_fbref_transfermarkt)

#remove the observations with <30% of the minutes possible, for the oufield players
max_serie_a_players <- (max(serie_a_players_fbref_transfermarkt$Starts_Playing_Time_STANDARD)*90)*0.30
serie_a_players_fbref_transfermarkt <- serie_a_players_fbref_transfermarkt[serie_a_players_fbref_transfermarkt$Min_Playing_Time_STANDARD >= max_serie_a_players, ]

#remove the observations with <30% of the minutes possible, for the goalkeepers
max_serie_a_keepers <- (max(serie_a_keepers_fbref_transfermarkt$MP_Playing_Time_KEEPER)*90)*0.30
serie_a_keepers_fbref_transfermarkt <- serie_a_keepers_fbref_transfermarkt[serie_a_keepers_fbref_transfermarkt$Min_Playing_Time_KEEPER >= max_serie_a_keepers, ]


#PART 5.4: DATA CLEANING BUNDESLIGA----------------------------------------------------------------------


#remove NULL columns, for the outfield players
excess_columns <- c("MP_Playing_Time_STANDARD")
bundesliga_players_fbref_transfermarkt <- 
  bundesliga_players_fbref_transfermarkt %>%
  select(-one_of(excess_columns))
#view(bundesliga_players_fbref_transfermarkt)

#count of NULL observations, for the outfield players
null_counts <- apply(bundesliga_players_fbref_transfermarkt, 1, function(row) sum(is.na(row)))
#print(null_counts)
#remove observations with 122 or more NULLs, for the outfield players
bundesliga_players_fbref_transfermarkt <- bundesliga_players_fbref_transfermarkt[rowSums(is.na(bundesliga_players_fbref_transfermarkt)) < 122, ]
#view(bundesliga_players_fbref_transfermarkt)

#remove repeated observations, for the outfield players
bundesliga_players_fbref_transfermarkt <- bundesliga_players_fbref_transfermarkt[!duplicated(bundesliga_players_fbref_transfermarkt$UrlTmarkt), ]
#view(bundesliga_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the outfield players
bundesliga_players_fbref_transfermarkt <- subset(bundesliga_players_fbref_transfermarkt, !is.na(player_position_TM))
#view(bundesliga_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the goalkeepers
bundesliga_keepers_fbref_transfermarkt <- subset(bundesliga_keepers_fbref_transfermarkt, !is.na(player_position_TM))
#view(bundesliga_keepers_fbref_transfermarkt)

#remove the observations with <30% of the minutes possible, for the oufield players
max_bundesliga_players <- (max(bundesliga_players_fbref_transfermarkt$Starts_Playing_Time_STANDARD)*90)*0.30
bundesliga_players_fbref_transfermarkt <- bundesliga_players_fbref_transfermarkt[bundesliga_players_fbref_transfermarkt$Min_Playing_Time_STANDARD >= max_bundesliga_players, ]

#remove the observations with <30% of the minutes possible, for the goalkeepers
max_bundesliga_keepers <- (max(bundesliga_keepers_fbref_transfermarkt$MP_Playing_Time_KEEPER)*90)*0.30
bundesliga_keepers_fbref_transfermarkt <- bundesliga_keepers_fbref_transfermarkt[bundesliga_keepers_fbref_transfermarkt$Min_Playing_Time_KEEPER >= max_bundesliga_keepers, ]


#PART 5.5: DATA CLEANING LIGUE ONE-----------------------------------------------------------------------


#remove NULL columns, for the outfield players
excess_columns <- c("MP_Playing_Time_STANDARD")
ligue_one_players_fbref_transfermarkt <- 
  ligue_one_players_fbref_transfermarkt %>%
  select(-one_of(excess_columns))
#view(ligue_one_players_fbref_transfermarkt)

#count of NULL observations, for the outfield players
null_counts <- apply(ligue_one_players_fbref_transfermarkt, 1, function(row) sum(is.na(row)))
#print(null_counts)
#remove observations with 122 or more NULLs, for the outfield players
ligue_one_players_fbref_transfermarkt <- ligue_one_players_fbref_transfermarkt[rowSums(is.na(ligue_one_players_fbref_transfermarkt)) < 122, ]
#view(ligue_one_players_fbref_transfermarkt)

#remove repeated observations, for the outfield players
ligue_one_players_fbref_transfermarkt <- ligue_one_players_fbref_transfermarkt[!duplicated(ligue_one_players_fbref_transfermarkt$UrlTmarkt), ]
#view(ligue_one_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the outfield players
ligue_one_players_fbref_transfermarkt <- subset(ligue_one_players_fbref_transfermarkt, !is.na(player_position_TM))
#view(ligue_one_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the goalkeepers
ligue_one_keepers_fbref_transfermarkt <- subset(ligue_one_keepers_fbref_transfermarkt, !is.na(player_position_TM))
#view(ligue_one_keepers_fbref_transfermarkt)

#remove the observations with <30% of the minutes possible, for the oufield players
max_ligue_one_players <- (max(ligue_one_players_fbref_transfermarkt$Starts_Playing_Time_STANDARD)*90)*0.30
ligue_one_players_fbref_transfermarkt <- ligue_one_players_fbref_transfermarkt[ligue_one_players_fbref_transfermarkt$Min_Playing_Time_STANDARD >= max_ligue_one_players, ]

#remove the observations with <30% of the minutes possible, for the goalkeepers
max_ligue_one_keepers <- (max(ligue_one_keepers_fbref_transfermarkt$MP_Playing_Time_KEEPER)*90)*0.30
ligue_one_keepers_fbref_transfermarkt <- ligue_one_keepers_fbref_transfermarkt[ligue_one_keepers_fbref_transfermarkt$Min_Playing_Time_KEEPER >= max_ligue_one_keepers, ]


#PART 5.6: DATA CLEANING EREDIVISIE---------------------------------------------------------------------


#remove NULL columns, for the outfield players
excess_columns <- c("MP_Playing_Time_STANDARD")
eredivisie_players_fbref_transfermarkt <- 
  eredivisie_players_fbref_transfermarkt %>%
  select(-one_of(excess_columns))
#view(eredivisie_players_fbref_transfermarkt)

#count of NULL observations, for the outfield players
null_counts <- apply(eredivisie_players_fbref_transfermarkt, 1, function(row) sum(is.na(row)))
#print(null_counts)
#remove observations with 122 or more NULLs, for the outfield players
eredivisie_players_fbref_transfermarkt <- eredivisie_players_fbref_transfermarkt[rowSums(is.na(eredivisie_players_fbref_transfermarkt)) < 122, ]
#view(eredivisie_players_fbref_transfermarkt)

#remove repeated observations, for the outfield players
eredivisie_players_fbref_transfermarkt <- eredivisie_players_fbref_transfermarkt[!duplicated(eredivisie_players_fbref_transfermarkt$UrlTmarkt), ]
#view(eredivisie_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the outfield players
eredivisie_players_fbref_transfermarkt <- subset(eredivisie_players_fbref_transfermarkt, !is.na(player_position_TM))
#view(eredivisie_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the goalkeepers
eredivisie_keepers_fbref_transfermarkt <- subset(eredivisie_keepers_fbref_transfermarkt, !is.na(player_position_TM))
#view(eredivisie_keepers_fbref_transfermarkt)

#remove the observations with <30% of the minutes possible, for the oufield players
max_eredivisie_players <- (max(eredivisie_players_fbref_transfermarkt$Starts_Playing_Time_STANDARD)*90)*0.30
eredivisie_players_fbref_transfermarkt <- eredivisie_players_fbref_transfermarkt[eredivisie_players_fbref_transfermarkt$Min_Playing_Time_STANDARD >= max_eredivisie_players, ]

#remove the observations with <30% of the minutes possible, for the goalkeepers
max_eredivisie_keepers <- (max(eredivisie_keepers_fbref_transfermarkt$MP_Playing_Time_KEEPER)*90)*0.30
eredivisie_keepers_fbref_transfermarkt <- eredivisie_keepers_fbref_transfermarkt[eredivisie_keepers_fbref_transfermarkt$Min_Playing_Time_KEEPER >= max_eredivisie_keepers, ]


#PART 5.7: DATA CLEANING PRIMEIRA LIGA------------------------------------------------------------------


#remove NULL columns, for the outfield players
excess_columns <- c("MP_Playing_Time_STANDARD")
primeira_liga_players_fbref_transfermarkt <- 
  primeira_liga_players_fbref_transfermarkt %>%
  select(-one_of(excess_columns))
#view(primeira_liga_players_fbref_transfermarkt)

#count of NULL observations, for the outfield players
null_counts <- apply(primeira_liga_players_fbref_transfermarkt, 1, function(row) sum(is.na(row)))
#print(null_counts)
#remove observations with 122 or more NULLs, for the outfield players
primeira_liga_players_fbref_transfermarkt <- primeira_liga_players_fbref_transfermarkt[rowSums(is.na(primeira_liga_players_fbref_transfermarkt)) < 122, ]
#view(primeira_liga_players_fbref_transfermarkt)

#remove repeated observations, for the outfield players
primeira_liga_players_fbref_transfermarkt <- primeira_liga_players_fbref_transfermarkt[!duplicated(primeira_liga_players_fbref_transfermarkt$UrlTmarkt), ]
#view(primeira_liga_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the outfield players
primeira_liga_players_fbref_transfermarkt <- subset(primeira_liga_players_fbref_transfermarkt, !is.na(player_position_TM))
#view(primeira_liga_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the goalkeepers
primeira_liga_keepers_fbref_transfermarkt <- subset(primeira_liga_keepers_fbref_transfermarkt, !is.na(player_position_TM))
#view(primeira_liga_keepers_fbref_transfermarkt)

#remove the observations with <30% of the minutes possible, for the oufield players
max_primeira_liga_players <- (max(primeira_liga_players_fbref_transfermarkt$Starts_Playing_Time_STANDARD)*90)*0.30
primeira_liga_players_fbref_transfermarkt <- primeira_liga_players_fbref_transfermarkt[primeira_liga_players_fbref_transfermarkt$Min_Playing_Time_STANDARD >= max_primeira_liga_players, ]

#remove the observations with <30% of the minutes possible, for the goalkeepers
max_primeira_liga_keepers <- (max(primeira_liga_keepers_fbref_transfermarkt$MP_Playing_Time_KEEPER)*90)*0.30
primeira_liga_keepers_fbref_transfermarkt <- primeira_liga_keepers_fbref_transfermarkt[primeira_liga_keepers_fbref_transfermarkt$Min_Playing_Time_KEEPER >= max_primeira_liga_keepers, ]


#PART 5.8: DATA CLEANING BRASILEIRAO--------------------------------------------------------------------


#remove NULL columns, for the outfield players
excess_columns <- c("MP_Playing_Time_STANDARD")
brasileirao_players_fbref_transfermarkt <- 
  brasileirao_players_fbref_transfermarkt %>%
  select(-one_of(excess_columns))
#view(brasileirao_players_fbref_transfermarkt)

#count of NULL observations, for the outfield players
null_counts <- apply(brasileirao_players_fbref_transfermarkt, 1, function(row) sum(is.na(row)))
#print(null_counts)
#remove observations with 122 or more NULLs, for the outfield players
brasileirao_players_fbref_transfermarkt <- brasileirao_players_fbref_transfermarkt[rowSums(is.na(brasileirao_players_fbref_transfermarkt)) < 122, ]
#view(brasileirao_players_fbref_transfermarkt)

#remove repeated observations, for the outfield players
brasileirao_players_fbref_transfermarkt <- brasileirao_players_fbref_transfermarkt[!duplicated(brasileirao_players_fbref_transfermarkt$UrlTmarkt), ]
#view(brasileirao_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the outfield players
brasileirao_players_fbref_transfermarkt <- subset(brasileirao_players_fbref_transfermarkt, !is.na(player_position_TM))
#view(brasileirao_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the goalkeepers
brasileirao_keepers_fbref_transfermarkt <- subset(brasileirao_keepers_fbref_transfermarkt, !is.na(player_position_TM))
#view(brasileirao_keepers_fbref_transfermarkt)

#remove the observations with <30% of the minutes possible, for the oufield players
max_brasileirao_players <- (max(brasileirao_players_fbref_transfermarkt$Starts_Playing_Time_STANDARD)*90)*0.30
brasileirao_players_fbref_transfermarkt <- brasileirao_players_fbref_transfermarkt[brasileirao_players_fbref_transfermarkt$Min_Playing_Time_STANDARD >= max_brasileirao_players, ]

#remove the observations with <30% of the minutes possible, for the goalkeepers
max_brasileirao_keepers <- (max(brasileirao_keepers_fbref_transfermarkt$MP_Playing_Time_KEEPER)*90)*0.30
brasileirao_keepers_fbref_transfermarkt <- brasileirao_keepers_fbref_transfermarkt[brasileirao_keepers_fbref_transfermarkt$Min_Playing_Time_KEEPER >= max_brasileirao_keepers, ]


#PART 5.9: DATA CLEANING SUPERLIGA---------------------------------------------------------------------


#remove NULL columns, for the outfield players
excess_columns <- c("MP_Playing_Time_STANDARD")
superliga_players_fbref_transfermarkt <- 
  superliga_players_fbref_transfermarkt %>%
  select(-one_of(excess_columns))
#view(superliga_players_fbref_transfermarkt)

#count of NULL observations, for the outfield players
null_counts <- apply(superliga_players_fbref_transfermarkt, 1, function(row) sum(is.na(row)))
#print(null_counts)
#remove observations with 122 or more NULLs, for the outfield players
superliga_players_fbref_transfermarkt <- superliga_players_fbref_transfermarkt[rowSums(is.na(superliga_players_fbref_transfermarkt)) < 122, ]
#view(superliga_players_fbref_transfermarkt)

#remove repeated observations, for the outfield players
superliga_players_fbref_transfermarkt <- superliga_players_fbref_transfermarkt[!duplicated(superliga_players_fbref_transfermarkt$UrlTmarkt), ]
#view(superliga_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the outfield players
superliga_players_fbref_transfermarkt <- subset(superliga_players_fbref_transfermarkt, !is.na(player_position_TM))
#view(superliga_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the goalkeepers
superliga_keepers_fbref_transfermarkt <- subset(superliga_keepers_fbref_transfermarkt, !is.na(player_position_TM))
#view(superliga_keepers_fbref_transfermarkt)

#remove the observations with <30% of the minutes possible, for the oufield players
max_superliga_players <- (max(superliga_players_fbref_transfermarkt$Starts_Playing_Time_STANDARD)*90)*0.30
superliga_players_fbref_transfermarkt <- superliga_players_fbref_transfermarkt[superliga_players_fbref_transfermarkt$Min_Playing_Time_STANDARD >= max_superliga_players, ]

#remove the observations with <30% of the minutes possible, for the goalkeepers
max_superliga_keepers <- (max(superliga_keepers_fbref_transfermarkt$MP_Playing_Time_KEEPER)*90)*0.30
superliga_keepers_fbref_transfermarkt <- superliga_keepers_fbref_transfermarkt[superliga_keepers_fbref_transfermarkt$Min_Playing_Time_KEEPER >= max_superliga_keepers, ]


#PART 5.10: DATA CLEANING MLS---------------------------------------------------------------------------


#remove NULL columns, for the outfield players
excess_columns <- c("MP_Playing_Time_STANDARD")
mls_players_fbref_transfermarkt <- 
  mls_players_fbref_transfermarkt %>%
  select(-one_of(excess_columns))
#view(mls_players_fbref_transfermarkt)

#count of NULL observations, for the outfield players
null_counts <- apply(mls_players_fbref_transfermarkt, 1, function(row) sum(is.na(row)))
#print(null_counts)
#remove observations with 122 or more NULLs, for the outfield players
mls_players_fbref_transfermarkt <- mls_players_fbref_transfermarkt[rowSums(is.na(mls_players_fbref_transfermarkt)) < 122, ]
#view(mls_players_fbref_transfermarkt)

#remove repeated observations, for the outfield players
mls_players_fbref_transfermarkt <- mls_players_fbref_transfermarkt[!duplicated(mls_players_fbref_transfermarkt$UrlTmarkt), ]
#view(mls_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the outfield players
mls_players_fbref_transfermarkt <- subset(mls_players_fbref_transfermarkt, !is.na(player_position_TM))
#view(mls_players_fbref_transfermarkt)

#remove observations with "player_position_TM" = NULL, for the goalkeepers
mls_keepers_fbref_transfermarkt <- subset(mls_keepers_fbref_transfermarkt, !is.na(player_position_TM))
#view(mls_keepers_fbref_transfermarkt)

#remove the observations with <30% of the minutes possible, for the oufield players
max_mls_players <- (max(mls_players_fbref_transfermarkt$Starts_Playing_Time_STANDARD)*90)*0.30
mls_players_fbref_transfermarkt <- mls_players_fbref_transfermarkt[mls_players_fbref_transfermarkt$Min_Playing_Time_STANDARD >= max_mls_players, ]

#remove the observations with <30% of the minutes possible, for the goalkeepers
max_mls_keepers <- (max(mls_keepers_fbref_transfermarkt$MP_Playing_Time_KEEPER)*90)*0.30
mls_keepers_fbref_transfermarkt <- mls_keepers_fbref_transfermarkt[mls_keepers_fbref_transfermarkt$Min_Playing_Time_KEEPER >= max_mls_keepers, ]


#PART 6: CONCLUSION--------------------------------------------------------------------------------------


#PART 6.1: FINAL MERGE-----------------------------------------------------------------------------------


#add a column WeeklyWageEUR_WAGES filled with null values, to the eredivisie dataframe, 
#for the outfieled players
eredivisie_players_fbref_transfermarkt <- 
  eredivisie_players_fbref_transfermarkt %>%
  mutate(WeeklyWageEUR_WAGES = NA)

#add a column WeeklyWageEUR_WAGES filled with null values, to the eredivisie dataframe, 
#for the goalkeepers
eredivisie_keepers_fbref_transfermarkt <- 
  eredivisie_keepers_fbref_transfermarkt %>%
  mutate(WeeklyWageEUR_WAGES = NA)

#add a column WeeklyWageEUR_WAGES filled with null values, to the primeira liga dataframe,
#for the outfield players
primeira_liga_players_fbref_transfermarkt <- 
  primeira_liga_players_fbref_transfermarkt %>%
  mutate(WeeklyWageEUR_WAGES = NA)

#add a column WeeklyWageEUR_WAGES filled with null values, to the primeira liga dataframe,
#for the goalkeepers
primeira_liga_keepers_fbref_transfermarkt <- 
  primeira_liga_keepers_fbref_transfermarkt %>%
  mutate(WeeklyWageEUR_WAGES = NA)

#add a column WeeklyWageEUR_WAGES filled with null values, to the brasileirao dataframe,
#for the outfield players
brasileirao_players_fbref_transfermarkt <- 
  brasileirao_players_fbref_transfermarkt %>%
  mutate(WeeklyWageEUR_WAGES = NA)

#add a column WeeklyWageEUR_WAGES filled with null values, to the brrasileirao dataframe,
#for the goalkeepers
brasileirao_keepers_fbref_transfermarkt <- 
  brasileirao_keepers_fbref_transfermarkt %>%
  mutate(WeeklyWageEUR_WAGES = NA)

#remove the "2023" from the "Squad_STANDARD", to the brasileirao dataframe,
#for the outfield players
brasileirao_players_fbref_transfermarkt$Squad_STANDARD <- sub("^\\d+\\s+", "", brasileirao_players_fbref_transfermarkt$Squad_STANDARD)

#remove the "2023" from the "Squad_STANDARD", to the brasileirao dataframe,
#for the goalkeepers
brasileirao_keepers_fbref_transfermarkt$Squad_KEEPER <- sub("^\\d+\\s+", "", brasileirao_keepers_fbref_transfermarkt$Squad_KEEPER)

#add a column WeeklyWageEUR_WAGES filled with null values, to the superliga dataframe,
#for the outfield players
superliga_players_fbref_transfermarkt <- 
  superliga_players_fbref_transfermarkt %>%
  mutate(WeeklyWageEUR_WAGES = NA)

#add a column WeeklyWageEUR_WAGES filled with null values, to the superliga dataframe,
#for the goalkeepers
superliga_keepers_fbref_transfermarkt <- 
  superliga_keepers_fbref_transfermarkt %>%
  mutate(WeeklyWageEUR_WAGES = NA)

#remove the "2023" from the "Squad_STANDARD", to the superliga dataframe,
#for the outfield players
superliga_players_fbref_transfermarkt$Squad_STANDARD <- sub("^\\d+\\s+", "", superliga_players_fbref_transfermarkt$Squad_STANDARD)

#remove the "2023" from the "Squad_STANDARD", to the superliga dataframe,
#for the goalkeepers
superliga_keepers_fbref_transfermarkt$Squad_KEEPER <- sub("^\\d+\\s+", "", superliga_keepers_fbref_transfermarkt$Squad_KEEPER)

#add a column WeeklyWageEUR_WAGES filled with null values, to the mls dataframe,
#for the outfield players
mls_players_fbref_transfermarkt <- 
  mls_players_fbref_transfermarkt %>%
  mutate(WeeklyWageEUR_WAGES = NA)

#add a column WeeklyWageEUR_WAGES filled with null values, to the mls dataframe,
#for the goalkeepers
mls_keepers_fbref_transfermarkt <- 
  mls_keepers_fbref_transfermarkt %>%
  mutate(WeeklyWageEUR_WAGES = NA)

#remove the "2023" from the "Squad_STANDARD", to the mls dataframe,
#for the outfield players
mls_players_fbref_transfermarkt$Squad_STANDARD <- sub("^\\d+\\s+", "", mls_players_fbref_transfermarkt$Squad_STANDARD)

#remove the "2023" from the "Squad_STANDARD", to the mls dataframe,
#for the goalkeepers
mls_keepers_fbref_transfermarkt$Squad_KEEPER <- sub("^\\d+\\s+", "", mls_keepers_fbref_transfermarkt$Squad_KEEPER)

#final dataframe for the outfield players
outfieldplayers <- rbind(
  premier_league_players_fbref_transfermarkt,
  la_liga_players_fbref_transfermarkt,
  serie_a_players_fbref_transfermarkt,
  bundesliga_players_fbref_transfermarkt,
  ligue_one_players_fbref_transfermarkt,
  eredivisie_players_fbref_transfermarkt,
  primeira_liga_players_fbref_transfermarkt,
  brasileirao_players_fbref_transfermarkt,
  superliga_players_fbref_transfermarkt,
  mls_players_fbref_transfermarkt
)
#view(outfieldplayers)

#final dataframe for the goalkeepers
goalkeepers <- rbind(
  premier_league_keepers_fbref_transfermarkt,
  la_liga_keepers_fbref_transfermarkt,
  serie_a_keepers_fbref_transfermarkt,
  bundesliga_keepers_fbref_transfermarkt,
  ligue_one_keepers_fbref_transfermarkt,
  eredivisie_keepers_fbref_transfermarkt,
  primeira_liga_keepers_fbref_transfermarkt,
  brasileirao_keepers_fbref_transfermarkt,
  superliga_keepers_fbref_transfermarkt,
  mls_keepers_fbref_transfermarkt
)
#view(goalkeepers)

#remove the rows with null values, for the outfield players
outfieldplayers <- outfieldplayers[!is.na(outfieldplayers$Player_STANDARD), ]
#view(outfieldplayers)

#remove the rows with null values, for the goalkeepers
goalkeepers <- goalkeepers[!is.na(goalkeepers$Player_KEEPER), ]
#view(goalkeepers)


#PART 6.2: EXPORTATION-----------------------------------------------------------------------------------


#convert to a csv file the final dataframe for the outfield players
write.csv(outfieldplayers, "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Dataframes/outfieldplayers.csv", row.names=FALSE)

#convert to a csv file the final dataframe for the goalkeepers
write.csv(goalkeepers, "/Users/pedroalexleite/Desktop/Football-Players-Database/Data/Dataframes/goalkeepers.csv", row.names=FALSE)

#end time
end_time <- Sys.time()
elapsed_time <- end_time-start_time
elapsed_minutes <- as.numeric(elapsed_time, units="mins")
#print(paste("extractdata.r took", round(elapsed_minutes), "minutes!"))

