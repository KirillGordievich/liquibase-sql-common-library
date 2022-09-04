--
--  Immediately if (cond ? true_case : false_case)
--

-- example: SELECT * FROM common.iif(2*2=5, 'It is true'::text, 'It is false'::text) AS result

CREATE OR REPLACE FUNCTION common.iif(cond boolean, true_case anyelement, false_case anyelement)
    RETURNS anyelement
    LANGUAGE SQL
    IMMUTABLE
    AS $$
SELECT CASE WHEN (cond) THEN true_case ELSE false_case END
$$;

ALTER FUNCTION common.iif(boolean, anyelement, anyelement) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.iif(boolean, anyelement, anyelement) TO PUBLIC;
