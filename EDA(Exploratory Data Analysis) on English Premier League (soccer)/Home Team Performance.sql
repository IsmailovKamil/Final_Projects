SELECT "HomeTeam",
	round(avg("FTHG"),2) as "avg_goals",
	round(avg("HTHG"),2) as "avg_HT_goals",
	round(avg("FTAG"),2) as "avg_conceded_goals",
	round(avg("HTAG"),2) as "avg_HT_conceded_goals",
	sum("FTHG") as sum_goals,
	round(avg("HS"),2) as "avg_shots",
	round(avg("HST"),2) as "avg_shots_on_target"
FROM public."EPL 2018/2019" group by "HomeTeam" order by "avg_goals" desc
