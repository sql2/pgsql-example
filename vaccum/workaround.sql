DROP TABLE IF EXISTS bloat_tbl;
CREATE TABLE bloat_tbl( col1 INT, col2 INT );

SHOW autovacuum;
SHOW autovacuum_max_workers;

ALTER TABLE bloat_tbl SET (autovacuum_enabled = false);

INSERT INTO bloat_tbl
	SELECT generate_series, generate_series 
	FROM generate_series(1, 100000);
\dt+ bloat_tbl 

UPDATE bloat_tbl SET col2 = col2 + 1;
\dt+ bloat_tbl

UPDATE bloat_tbl SET col2 = col2 + 1;
\dt+ bloat_tbl

--Create a new tablespace:
DROP TABLESPACE IF EXISTS temptablespace;
CREATE TABLESPACE temptablespace LOCATION '/home/user01/pg12/tmp';

SELECT tablespace FROM pg_tables WHERE tablename = 'bloat_tbl';

-- Move table to new tablespace:
ALTER TABLE bloat_tbl SET TABLESPACE temptablespace;

-- VACUUM FULL:
VACUUM FULL bloat_tbl;
\dt+ bloat_tbl

-- Move table to old tablespace:(moving to pg_default)
ALTER TABLE bloat_tbl SET TABLESPACE pg_default;

-- Drop that temp table space:
DROP TABLESPACE temptablespace;
