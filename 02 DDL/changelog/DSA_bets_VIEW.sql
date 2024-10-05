--liquibase formatted sql

--changeset DSA_fd_stats:init
drop view DSA_bets_VIEW;
create view DSA_bets_VIEW as
	select 
	cast(speelronde as int) speelronde,
	date(datum) datum,
	s_wedstrijd,
	cast(replace(best_odd, ',', '.') as decimal(10,2)) best_odd,
	case when min_odd = 'nan' then null else cast(replace(min_odd, ',','.') as decimal(10,2)) end min_odd,
	case when rea_inzet = 'nan' then null else cast(rea_inzet as decimal(10,0)) end rea_inzet,
	cast(replace(rea_odd, ',', '.') as decimal(10,2)) rea_odd,
	case when wedkantoor = 'nan' then null else wedkantoor end wedkantoor
	from DSA_bets
order by datum, speelronde
;