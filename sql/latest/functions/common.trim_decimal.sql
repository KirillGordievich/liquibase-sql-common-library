BEGIN;

CREATE OR REPLACE FUNCTION common.trim_decimal(
        x decimal, -- e.g. 1.123456
        max_decimals integer DEFAULT NULL -- e.g. 3
    )
    RETURNS decimal -- e.g. 1.123
    LANGUAGE SQL
    IMMUTABLE
    AS $$
SELECT
    (CASE
        WHEN (scale(x) > 0)
            THEN TRIM(trailing '0' FROM (
                    CASE WHEN (max_decimals IS NULL) OR (scale(x) <= max_decimals)
                        THEN x
                        ELSE trunc(x, max_decimals)
                    END
                )::text)::decimal
            ELSE x
    END)
$$;

ALTER FUNCTION common.trim_decimal(decimal, integer) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.trim_decimal(decimal, integer) TO PUBLIC;
