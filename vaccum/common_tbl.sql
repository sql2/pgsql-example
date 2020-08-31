DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl( col1 INT, col2 INT );

ALTER TABLE bloat_tbl SET (autovacuum_enabled = true);

INSERT INTO tbl
	SELECT generate_series, generate_series 
	FROM generate_series(1, 100000);
\dt+ tbl 

UPDATE tbl SET col2 = col2 + 1;
\dt+ tbl

UPDATE tbl SET col2 = col2 + 1;
\dt+ tbl

--VACUUM VERBOSE tbl;
--\dt+ tbl

--VACUUM FULL VERBOSE tbl;
--\dt+ tbl
