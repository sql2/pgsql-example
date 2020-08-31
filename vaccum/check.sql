SELECT
    n.nspname AS schema_name,
    c.relname AS table_name,
    pg_stat_get_live_tuples(c.oid) + pg_stat_get_dead_tuples(c.oid) as total_tuple,
    pg_stat_get_live_tuples(c.oid) AS live_tuple,
    pg_stat_get_dead_tuples(c.oid) AS dead_tupple,
    round(100*pg_stat_get_live_tuples(c.oid) / (pg_stat_get_live_tuples(c.oid) + pg_stat_get_dead_tuples(c.oid)),2) as live_tuple_rate,
    round(100*pg_stat_get_dead_tuples(c.oid) / (pg_stat_get_live_tuples(c.oid) + pg_stat_get_dead_tuples(c.oid)),2) as dead_tuple_rate,
    pg_size_pretty(pg_total_relation_size(c.oid)) as total_relation_size,
    pg_size_pretty(pg_relation_size(c.oid)) as relation_size
FROM pg_class AS c
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace 
WHERE pg_stat_get_live_tuples(c.oid) > 0
AND c.relname NOT LIKE 'pg_%'
ORDER BY dead_tupple DESC;
