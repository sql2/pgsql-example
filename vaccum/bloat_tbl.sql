DROP TABLE IF EXISTS bloat_tbl;
CREATE TABLE bloat_tbl( col1 INT, col2 INT );

SHOW autovacuum;

SHOW autovacuum_max_workers;

ALTER TABLE bloat_tbl SET (autovacuum_enabled = false);

SELECT relowner, relname, reloptions 
FROM pg_catalog.pg_class
WHERE relname='bloat_tbl';

INSERT INTO bloat_tbl
	SELECT generate_series, generate_series 
	FROM generate_series(1, 100000);
\dt+ bloat_tbl 

UPDATE bloat_tbl SET col2 = col2 + 1;
\dt+ bloat_tbl

UPDATE bloat_tbl SET col2 = col2 + 1;
\dt+ bloat_tbl

ALTER TABLE bloat_tbl SET (autovacuum_vacuum_scale_factor  = 0.2);
ALTER TABLE bloat_tbl SET (autovacuum_vacuum_threshold     = 50);
ALTER TABLE bloat_tbl SET (autovacuum_analyze_scale_factor = 0.1);
ALTER TABLE bloat_tbl SET (autovacuum_analyze_threshold    = 50);
ALTER TABLE bloat_tbl SET (autovacuum_vacuum_cost_limit    = 1000);
ALTER TABLE bloat_tbl SET (autovacuum_vacuum_cost_delay    = 10);

-- rows : 1000
-- Table : bloat_tbl becomes a candidate for autovacuum Vacuum when,
-- Total number of Obsolete records = (0.2 * 1000) + 50 = 250

-- Table : bloat_tbl becomes a candidate for autovacuum ANALYZE when,
-- Total number of Inserts/Deletes/Updates = (0.1 * 1000) + 50 = 150

SELECT pg_sleep(2);
SELECT pg_sleep(2);
SELECT pg_sleep(2);
SELECT pg_sleep(2);
SELECT pg_sleep(2);
\dt+ bloat_tbl

SELECT n_tup_ins as "inserts",
	n_tup_upd as "updates",
	n_tup_del as "deletes",
	n_live_tup as "live_tuples",
	n_dead_tup as "dead_tuples"
FROM pg_stat_user_tables
WHERE schemaname = 'public' and relname = 'bloat_tbl';

VACUUM (VERBOSE,ANALYZE) bloat_tbl;
\dt+ bloat_tbl

UPDATE bloat_tbl SET col2 = col2 + 1;
\dt+ bloat_tbl

VACUUM (VERBOSE, FULL) bloat_tbl;
\dt+ bloat_tbl

