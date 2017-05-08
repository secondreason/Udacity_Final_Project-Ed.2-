-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.



CREATE DATABASE tournament;


\c tournament;


DROP TABLE players CASCADE;
DROP TABLE matches CASCADE;


DROP VIEW IF EXISTS win CASCADE;
DROP VIEW IF EXISTS loss;
DROP VIEW IF EXISTS totalmatchesplayed;
DROP VIEW IF EXISTS standings;
DROP VIEW IF EXISTS swisspairings;



CREATE TABLE players (name text, id serial primary key);
CREATE TABLE matches (winner integer references players(id), loser integer references players(id), primary key(winner, loser));



CREATE VIEW win AS SELECT players.id, players.name, count(matches.winner) as wins FROM players LEFT JOIN matches ON players.id = matches.winner GROUP BY players.id ORDER BY wins DESC;



CREATE VIEW loss AS SELECT players.id, players.name, count(matches.loser) as loses FROM players LEFT JOIN matches ON players.id = matches.loser GROUP BY players.id ORDER BY loses DESC;



CREATE VIEW totalmatchesplayed AS SELECT win.id, win.name, win.wins, sum(win.wins + loss.loses) as played FROM win LEFT JOIN loss ON win.id = loss.id GROUP BY win.id, win.name, win.wins;



CREATE VIEW standings AS SELECT players.id, players.name, totalmatchesplayed.wins, totalmatchesplayed.played as matches FROM players LEFT JOIN totalmatchesplayed ON players.id = totalmatchesplayed.id GROUP BY players.id, totalmatchesplayed.wins, totalmatchesplayed.played ORDER BY totalmatchesplayed.wins DESC;



CREATE VIEW swisspairings AS SELECT a.id AS id1, a.name AS name1, b.id AS id2, b.name AS name2 FROM standings AS a, standings AS b WHERE (a.wins >= b.wins AND b.wins >= a.wins) AND a.id < b.id;