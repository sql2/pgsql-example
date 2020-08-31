CREATE EXTENSION pg_stat_statements;

SELECT
  query,
  sum(calls) AS calls,
  sum(total_time) AS total_time,
  sum(rows) as rows,
  sum(shared_blks_hit) AS shared_blks_hit,
  sum(shared_blks_read) AS shared_blks_read
FROM pg_stat_statements
GROUP BY 1
ORDER BY 3 desc

select pg_stat_statements_reset();

set pg_stat_statements.track = NONE;
