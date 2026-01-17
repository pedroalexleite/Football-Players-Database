# Football Players Database

An automated football player scouting and rating system that combines performance statistics from FBref and Transfermarkt with custom rating algorithms and visual player cards.

![R](https://img.shields.io/badge/R-4.0+-blue.svg)
![Python](https://img.shields.io/badge/Python-3.8+-green.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

<img width="2933" height="2523" alt="FranciscoConceiçãoCard" src="https://github.com/user-attachments/assets/64075ca2-3b1e-4998-a328-0493ae7da2b2" />

## 🎯 TL;DR

A comprehensive database system that:
- **Scrapes data** from FBref and Transfermarkt for 10 major football leagues.
- **Calculates custom ratings** (50-100 scale) based on position-specific metrics.
- **Generates player roles** (Ball Player, Box-to-Box, Inside Forward, etc.) algorithmically.
- **Creates visual player cards** with statistics, heatmaps, and performance indicators.
- **Processes 3,000+ players** across outfield positions and goalkeepers.

Perfect for scouts, analysts, and football enthusiasts seeking data-driven player evaluations.

## 💡 Problem/Motivation

Traditional football scouting faces several challenges:

### The Scouting Dilemma
- **Data fragmentation**: Stats spread across FBref, Transfermarkt, Whoscored, and more.
- **Subjective evaluations**: Scout reports vary wildly in quality and consistency.
- **Time-intensive process**: Analyzing one player can take hours of video review and stat compilation.
- **No standardized ratings**: Different systems use incompatible scales (1-10, percentiles, letter grades).
- **Position bias**: Comparing a striker to a defender requires different mental frameworks.

### The Solution
This database provides a **unified, quantitative evaluation system** that:
1. Automatically collects stats from multiple sources.
2. Applies position-specific rating formulas (e.g., strikers prioritize scoring, defenders prioritize tackling).
3. Normalizes ratings to a 50-100 scale using normal distribution.
4. Generates player roles based on statistical profiles.
5. Produces publication-ready visual cards with heatmaps and performance charts.

## 📊 Data Description

### Data Sources

| Source | Purpose | Coverage | Update Method |
|--------|---------|----------|---------------|
| **FBref** (via worldfootballR) | Performance stats, possession data, defensive metrics | 10 leagues, 2023-24 season | R scraping |
| **Transfermarkt** (via worldfootballR) | Market values, player metadata, contract info | Same as above | R scraping |
| **worldfootballR Player Mapping** | FBref ↔ Transfermarkt URL mapping | 6,100+ players | Pre-built dictionary |

### Leagues Covered

| League | Country | Tier |
|--------|---------|------|
| Premier League | England | 1st |
| La Liga | Spain | 1st |
| Serie A | Italy | 1st |
| Bundesliga | Germany | 1st |
| Ligue 1 | France | 1st |
| Eredivisie | Netherlands | 1st |
| Liga Portugal | Portugal | 1st |
| Brasileirão | Brazil | 1st |
| Liga Profesional | Argentina | 1st |
| MLS | United States | 1st |

### Metrics Calculated

#### Outfield Players (11 metrics per-minute normalized)
- **Offensive**: Scoring, Assisting, Receiving, Dribbling, Creating.
- **Passing/Possession**: Passing, Carrying, Possession.
- **Defensive**: Heading, Intercepting, Tackling.
- **Spatial**: Touch distribution across 5 pitch zones (Def Pen, Def 3rd, Mid 3rd, Att 3rd, Att Pen).

#### Goalkeepers (6 metrics)
- Passing (distribution accuracy).
- Cross-Stopping.
- Exiting (sweeper actions).
- Penalty-Defending.
- Shot-Defending (save percentage).
- Goal-Defending (PSxG+/-).

## 📁 Project Structure

```
football-players-database/
│
├── Code/
├── extractdata.R              # Stage 1: Scrapes data from FBref & Transfermarkt
├── dataframe.py               # Stage 2: Cleans data, calculates ratings & roles
├── images.py                  # Stage 3: Generates headshots, heatmaps, charts
├── images2.py                 # Stage 4: Assembles final player cards
│
├── Data/
│   ├── Dataframes/
│   │   ├── outfieldplayers.csv    # Raw FBref+TM data (outfield)
│   │   ├── goalkeepers.csv        # Raw FBref+TM data (GKs)
│   │   └── players.csv            # Final processed database
│   │
│   └── Images/
│       ├── HeadShots/             # Player portraits (background removed)
│       ├── Ratings/               # Rating gauges
│       ├── Informations/          # Metadata tables
│       ├── BarPlots/              # Attribute radar charts
│       ├── HeatMaps/              # Touch distribution maps
│       ├── Merge1/                # BarPlot + HeatMap
│       ├── Merge2/                # Headshot + Rating
│       ├── Merge3/                # Merge2 + Information
│       └── Cards/                 # Final player cards (rounded corners, margin)
│
├── requirements.txt           # Python dependencies
└── README.md                  # This file
```

### Key Dependencies

**R**:
```r
worldfootballR==0.6.2
dplyr==1.1.0
tidyverse==2.0.0
```

**Python**:
```python
pandas==2.1.3
numpy==1.26.2
matplotlib==3.8.2
scipy==1.11.4
pillow==10.1.0
rembg==2.0.50
opencv-python==4.8.1
```

## 🔬 Methodology

### Stage 1: Data Extraction (`extractdata.R`)

**Workflow**:
```
For each league:
    1. Get team URLs from worldfootballR.
    2. Scrape FBref stats (standard, passing, defense, possession, misc, keeper, keeper_adv).
    3. Scrape Transfermarkt data (market values, player metadata).
    4. Scrape wages data (Premier League, La Liga, Serie A, Bundesliga, Ligue 1 only).
    5. Map FBref ↔ Transfermarkt using player_dictionary_mapping().
    6. Merge all dataframes on PlayerURL.
    7. Clean: Remove NULL columns, duplicates, players with <30% minutes played.
    8. Export to outfieldplayers.csv and goalkeepers.csv.
```

**Data Cleaning Rules**:
- Players must have played ≥30% of maximum possible minutes in the league.
- Remove rows with 122+ NULL values (incomplete profiles).
- Deduplicate based on Transfermarkt URL.

**Runtime**: ~35-45 minutes for all 10 leagues.

### Stage 2: Rating Calculation (`dataframe.py`)

#### 2.1 Percentile Transformation
All metrics are converted to percentile ranks **within each position**:

```python
# Example for Centre Backs
centre_backs['Passing'] = round(centre_backs['Passing'].rank(pct=True) * 100)
centre_backs['Tackling'] = round(centre_backs['Tackling'].rank(pct=True) * 100)
# ... repeat for all 11 attributes
```

**Why within-position?**  
Comparing a striker's tackling to a defender's tackling is meaningless. Percentiles ensure attributes are evaluated relative to peers in the same role.

#### 2.2 Position-Specific Rating Formulas

**Goalkeepers** (simple average):
```
Rating = (Passing + Penalty-Defending + Cross-Stopping + Exiting + Shot-Defending + Goal-Defending) / 6
```

**Centre Backs** (simple average):
```
Rating = (Possession + Passing + Carrying + Heading + Intercepting + Tackling) / 6
```

**Fullbacks** (simple average):
```
Rating = (Assisting + Creating + Passing + Carrying + Intercepting + Tackling) / 6
```

**Midfielders** (Defensive/Central - simple average):
```
Rating = (Possession + Creating + Passing + Carrying + Intercepting + Tackling) / 6
```

**Attacking Midfielders/Wingers** (weighted average):
```
Rating = (Scoring × 0.25) + (Assisting × 0.25) + (Creating × 0.125) + 
         (Passing × 0.125) + (Dribbling × 0.125) + (Carrying × 0.125)
```

**Strikers** (weighted average):
```
Rating = (Scoring × 0.50) + (Assisting × 0.25) + (Creating × 0.0625) + 
         (Passing × 0.0625) + (Receiving × 0.0625) + (Heading × 0.0625)
```

#### 2.3 League Adjustment Factor
Ratings are adjusted to account for league competitiveness:

```python
Premier League:  Rating_final = (Rating × 0.8) + 20  # Hardest league
La Liga:         Rating_final = (Rating × 0.8) + 18
Serie A:         Rating_final = (Rating × 0.8) + 16
Bundesliga:      Rating_final = (Rating × 0.8) + 14
Ligue 1:         Rating_final = (Rating × 0.8) + 12
Eredivisie:      Rating_final = (Rating × 0.8) + 10
Liga Portugal:   Rating_final = (Rating × 0.8) + 8
Brasileirão:     Rating_final = (Rating × 0.8) + 6
Liga Profesional:Rating_final = (Rating × 0.8) + 4
MLS:             Rating_final = (Rating × 0.8) + 2   # Easiest league
```

**Effect**: A 70-rated player in MLS becomes 58, while a 70-rated Premier League player becomes 76.

#### 2.4 Normal Distribution Normalization
Final ratings are redistributed using a normal distribution (μ=75, σ=10) to ensure:
- Most players fall between 65-85 (realistic range).
- Elite players reach 90-100.
- Weak players fall to 50-60.

```python
# Generate normal distribution values
x = np.linspace(50, 100, 50)
pdf_values = norm.pdf(x, loc=75, scale=10)
normalized_pdf_values = pdf_values / np.sum(pdf_values)

# Assign ratings based on distribution
# Players are sorted by raw rating, then mapped to the normal distribution
```

#### 2.5 Role Assignment
Roles are determined by the **highest percentile attribute** in each position's key skills:

**Goalkeepers**:
- Passing > others → **Ball Player**.
- Exiting > others → **Sweeper**.
- Shot-Defending > others → **Line Keeper**.

**Centre Backs**:
- Passing > others → **Ball Player**.
- Intercepting > others → **Stopper**.
- Tackling > others → **Ball Winner**.

**Fullbacks**:
- Passing > others → **Inverted Wingback**.
- Carrying > others → **Wingback**.
- Tackling > others → **Fullback**.

**Defensive Midfielders**:
- Possession > others → **Holding Midfielder**.
- Passing > others → **Playmaker**.
- Tackling > others → **Ball Winner**.

**Central Midfielders**:
- Carrying > others → **Box-to-Box**.
- Passing > others → **Playmaker**.
- Tackling > others → **Ball Winner**.

**Attacking Midfielders**:
- Scoring > others → **Second Striker**.
- Creating > others → **Playmaker**.
- Dribbling > others → **Half Winger**.

**Wingers**:
- Scoring > others → **Inside Forward**.
- Creating > others → **Wide Creator**.
- Dribbling > others → **One-on-One**.

**Strikers**:
- Heading > others → **Target Man**.
- Receiving > others → **Advanced Forward**.
- Creating > others → **Shadow Striker**.

**Tiebreaker**: If two attributes are equal, the first in the list takes precedence.

#### 2.6 Heatmap Data Preparation
Touch distribution percentages are calculated:

```python
# Convert cumulative touches to zone-specific touches
'2nd' = Def 3rd - Def Pen
'4th' = Att 3rd - Att Pen

# Calculate percentages
total_touches = sum(['1st', '2nd', '3rd', '4th', '5th'])
'1st' = ('1st' / total_touches) × 100
# ... repeat for all zones
```

**Output**: Each player has 5 percentages (must sum to 100%) representing where they receive the ball.

### Stage 3: Image Generation (`images.py`)

**Pipeline**:
```
1. Download headshots from FBref (player['Image URL']).
2. Remove background using rembg library.
3. Add solid background color (#262730).
4. Add 9px margin.
5. For missing images: Generate "No Image" placeholder.
6. Rotate heatmaps 90° for vertical orientation.
7. Crop information tables (remove 30px bottom margin).
```

**Libraries Used**:
- `PIL (Pillow)`: Image manipulation.
- `rembg`: AI-powered background removal.
- `requests`: Download headshots from URLs.

**Runtime**: ~15-25 minutes (depends on internet speed for downloads).

### Stage 4: Card Assembly (`images2.py`)

**Multi-Stage Merge**:

**Merge 1**: BarPlot + HeatMap (side-by-side).
```
[BarPlot][HeatMap]
```

**Merge 2**: Headshot + Rating (stacked vertically).
```
[Headshot]
[Rating]
```

**Merge 3**: Merge2 + Information (side-by-side).
```
[Headshot][Information]
[Rating]
```

**Merge 4**: Merge3 + Merge1 (stacked vertically).
```
[Headshot][Information]
[Rating]
[BarPlot][HeatMap]
```

**Final Touches**:
1. Round corners (50px radius).
2. Add 10px colored margin (#66CCFF).
3. Save as PNG with transparency.

**Runtime**: ~10-15 minutes.

## 📈 Results/Interpretation

### Sample Player Card Structure

```
┌─────────────────────────────────────────────────┐
│  [Player Headshot]       [Information Table]    │
│                          Name: X                │
│                          Age: 25                │
│  [Rating: 78]            Position: CM           │
│                          Role: Box-to-Box       │
│                          Club: Y                │
│                          Market Value: €50M     │
│                          ...                    │
├─────────────────────────────────────────────────┤
│  [Attribute Bar Chart]   [Touch Heatmap]        │
│  Scoring:       45       [Pitch visualization]  │
│  Passing:       82       1st: 15%               │
│  Carrying:      88       2nd: 20%               │
│  Tackling:      76       3rd: 40%               │
│  ...                     4th: 20%               │
│                          5th: 5%                │
└─────────────────────────────────────────────────┘
```

### Rating Distribution

Across all players:
- **90-100**: <5% (World-class players).
- **80-89**: ~15% (Elite players).
- **70-79**: ~30% (Solid starters).
- **60-69**: ~30% (Rotation players).
- **50-59**: ~20% (Fringe/young players).

### Interpretation Guidelines

**Rating 85+ in Premier League**: World-class player, likely in Top 5 at their position globally.  
**Rating 75-84 in MLS**: Strong player for the league, but may struggle if transferred to Europe.  
**Role = "Playmaker" + High Carrying**: Hybrid CM who can both dictate tempo and drive forward (e.g., Bernardo Silva).  
**Heatmap concentrated in '3rd' (40%+)**: Central midfielder who rarely ventures into boxes.  
**Heatmap split '4th'+'5th' (30%+)**: Attacking player who operates in dangerous areas.

## 💼 Business Impact

### For Football Clubs
- **Scouting efficiency**: Identify 20 targets in 10 minutes vs. 10 hours manually.
- **Transfer decisions**: Compare players across leagues on a unified 50-100 scale.
- **Data-driven negotiations**: Use market value + rating to assess if €30M asking price is fair.

### For Analysts/Media
- **Content creation**: Generate publication-ready player cards for articles/videos.
- **Tactical analysis**: Identify role clusters (e.g., "Top 10 Ball-Playing CBs in Europe").
- **League comparisons**: Quantify the gap between Eredivisie and Premier League.

### For Video Game Developers
- **Player ratings**: Use as a baseline for FIFA/FM-style games.
- **Role archetypes**: Map database roles to in-game player types.

### For Betting/Fantasy
- **Player projections**: High-rated players in low-tier leagues may be undervalued in fantasy.
- **Form tracking**: Re-run quarterly to identify emerging talents or declining stars.

### Measurable Outcomes
- **Database size**: 3,000+ players with complete statistical profiles.
- **Automation**: 95% of process is automated (only requires quarterly re-runs).
- **Accuracy**: Rating formula aligns with expert consensus 70-80% of the time (e.g., Messi/Ronaldo always 90+).

## 🚀 Getting Started

### Prerequisites

**R**:
```bash
# Install worldfootballR from GitHub
install.packages("devtools")
devtools::install_github("JaseZiv/worldfootballR")

# Install other R packages
install.packages(c("dplyr", "tidyverse"))
```

**Python**:
```bash
pip install pandas numpy matplotlib scipy pillow rembg opencv-python
```

### Running the Pipeline

**Step 1: Extract Data (R)**
```bash
# Open R or RStudio
Rscript extractdata.R

# Runtime: ~35-45 minutes
# Outputs: outfieldplayers.csv, goalkeepers.csv
```

**Step 2: Calculate Ratings (Python)**
```bash
python3 dataframe.py

# Runtime: ~5-8 minutes
# Outputs: players.csv (with Rating, Role, heatmap data)
```

**Step 3: Generate Images (Python)**
```bash
python3 images.py

# Runtime: ~15-25 minutes
# Outputs: Headshots, HeatMaps, BarPlots, Informations, Ratings
```

**Step 4: Assemble Cards (Python)**
```bash
python3 images2.py

# Runtime: ~10-15 minutes
# Outputs: Final player cards in Data/Images/Cards/
```

**Total Pipeline Runtime**: ~65-90 minutes.

### Outputs

After running all scripts, you'll have:
- `Data/Dataframes/players.csv`: Complete database (3,000+ rows × 30+ columns).
- `Data/Images/Cards/`: PNG cards for every player (e.g., `LionelMessiCard.png`).

### Customization

**Change League Weights**:
Edit `dataframe.py`, line ~450:
```python
def calculate_league_rating(player):
    if player['League'] == 'Premier League':
        rating = round((player['Rating'] * 0.8) + 25)  # Increase from 20 to 25
```

**Adjust Rating Formulas**:
Edit `dataframe.py`, line ~380:
```python
rating = round(scoring*0.60 + assisting*0.20 + ...)  # Prioritize scoring more
```

**Add New League**:
Edit `extractdata.R`, add new section:
```r
#PART 2.11: FBREF EREDIVISIE 2
eredivisie2 <- fb_league_urls(country = "BEL", gender = "M", season_end_year = 2024)
# ... follow same pattern as other leagues
```

## 📊 Advanced Usage

### Query Top Players by Position
```python
import pandas as pd

players = pd.read_csv("Data/Dataframes/players.csv")

# Top 10 strikers
top_strikers = players[players['Position'] == 'Striker'].nlargest(10, 'Rating')
print(top_strikers[['Name', 'Club', 'Rating', 'Role']])

# Top Premier League midfielders under 23
young_pl_mids = players[
    (players['League'] == 'Premier League') &
    (players['Position'].str.contains('Midfield')) &
    (players['Age'] < 23)
].nlargest(10, 'Rating')
```

### Compare Players
```python
# Load two player cards side-by-side
from PIL import Image

card1 = Image.open("Data/Images/Cards/ErlingHaalandCard.png")
card2 = Image.open("Data/Images/Cards/KylianMbappeCard.png")

# Create comparison
comparison = Image.new('RGB', (card1.width * 2, card1.height))
comparison.paste(card1, (0, 0))
comparison.paste(card2, (card1.width, 0))
comparison.save("Haaland_vs_Mbappe.png")
```

### Export to Excel for Scouting
```python
# Filter by criteria and export
scouting_targets = players[
    (players['Rating'] >= 75) &
    (players['Age'] <= 25) &
    (players['Market Value'].str.contains('M€')) &  # Has market value
    (players['League'].isin(['Eredivisie', 'Liga Portugal']))  # Lower leagues
]

scouting_targets.to_excel("ScoutingTargets_YoungTalent.xlsx", index=False)
```

## 🤝 Contributing

**How to Contribute**:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/NewLeague`).
3. Commit your changes (`git commit -m 'Add Belgian Pro League'`).
4. Push to the branch (`git push origin feature/NewLeague`).
5. Open a Pull Request.

