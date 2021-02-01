SELECT "AwayTeam",
	round(avg("FTAG"),2) as "avg_goals",
	round(avg("HTAG"),2) as "avg_HT_goals",
	round(avg("FTHG"),2) as "avg_conceded_goals",
	round(avg("HTHG"),2) as "avg_HT_conceded_goals",
	sum("FTAG") as sum_goals,
	round(avg("AS"),2) as "avg_shots",
	round(avg("AST"),2) as "avg_shots_on_target"
FROM public."EPL 2018/2019" group by "AwayTeam" order by "avg_goals" desc