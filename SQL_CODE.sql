
SELECT club_games.game_id, clubs.club_id FROM clubs
JOIN club_games ON club_games.club_id = clubs.club_id;

SHOW DATABASES;
USE fb;

describe clubs;



SELECT 
    a.player_id,
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    SUM(a.goals) AS total_goals,
    SUM(a.assists) AS total_assists,
    SUM(a.yellow_cards) AS total_yellow_cards,
    SUM(a.red_cards) AS total_red_cards
FROM 
    appearances a
JOIN 
    players p ON a.player_id = p.player_id
GROUP BY 
    a.player_id, player_name;


SELECT 
    a.player_id,
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    SUM(a.minutes_played) AS total_minutes_played
FROM 
    appearances a
JOIN 
    players p ON a.player_id = p.player_id
GROUP BY 
    a.player_id, player_name;
    
    
SELECT 
    c.name AS club_name,
    SUM(CASE WHEN cg.hosting = 'home' THEN cg.own_goals ELSE 0 END) AS goals_scored_home,
    SUM(CASE WHEN cg.hosting = 'away' THEN cg.own_goals ELSE 0 END) AS goals_scored_away,
    SUM(CASE WHEN cg.hosting = 'home' THEN cg.opponent_goals ELSE 0 END) AS goals_conceded_home,
    SUM(CASE WHEN cg.hosting = 'away' THEN cg.opponent_goals ELSE 0 END) AS goals_conceded_away
FROM 
    club_games cg
JOIN 
    clubs c ON cg.club_id = c.club_id
GROUP BY 
    c.name;


SELECT 
    cg.own_manager_name,
    COUNT(*) AS total_games,
    SUM(CASE WHEN cg.own_goals > cg.opponent_goals THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN cg.own_goals < cg.opponent_goals THEN 1 ELSE 0 END) AS losses,
    SUM(CASE WHEN cg.own_goals = cg.opponent_goals THEN 1 ELSE 0 END) AS draws
FROM 
    club_games cg
GROUP BY 
    cg.own_manager_name;

SELECT 
    p.player_id,
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    pv.date AS valuation_date,
    pv.market_value_in_eur AS valuation_before_transfer,
    p.current_club_id AS current_club_id,
    (SELECT pv2.market_value_in_eur FROM player_valuations pv2 
    WHERE pv2.player_id = pv.player_id AND pv2.date > pv.date ORDER BY pv2.date ASC LIMIT 1)
    AS valuation_after_transfer
FROM 
    player_valuations pv
JOIN 
    players p ON pv.player_id = p.player_id;
    
 
 # Calculate the average market value of players participating in each competitions.
SELECT 
    c.competition_id,
    c.name AS competition_name,
    AVG(pv.market_value_in_eur) AS average_market_value
FROM 
    player_valuations pv
JOIN 
    players p ON pv.player_id = p.player_id
JOIN 
    games g ON pv.current_club_id = g.home_club_id OR pv.current_club_id = g.away_club_id
JOIN 
    competitions c ON g.competition_id = c.competition_id
GROUP BY 
    c.competition_id, c.name;


SELECT 
    ge.date,
    ge.minute,
    ge.type,
    c.name AS club_name,
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    ge.description
FROM 
    game_events ge
LEFT JOIN 
    clubs c ON ge.club_id = c.club_id
LEFT JOIN 
    players p ON ge.player_id = p.player_id
WHERE 
    ge.game_id = game_id;













