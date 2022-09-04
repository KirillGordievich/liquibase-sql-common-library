--
--  Assertion check (boolean)
--

CREATE OR REPLACE FUNCTION common.assert(cond boolean, message text)
    RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (cond IS DISTINCT FROM TRUE) THEN
        IF (message IS NULL) THEN
            message := '(no details)';
        END IF;
        RAISE EXCEPTION 'Assertion failed: %', message;
    END IF;
END
$$;

ALTER FUNCTION common.assert(boolean, text) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.assert(boolean, text) TO PUBLIC;


--
--  Assertion equality check (any types)
--

CREATE OR REPLACE FUNCTION common.assert_equal(value anyelement, expected anyelement, name text DEFAULT NULL)
    RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (value IS DISTINCT FROM expected) THEN
        IF (name IS NULL) THEN
            name := '';
        ELSE
            name := name || ' ';
        END IF;
        RAISE EXCEPTION 'Assertion failed: %value is "%", but expected "%"', name, value, expected;
    END IF;
END
$$;

ALTER FUNCTION common.assert_equal(anyelement, anyelement, text) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.assert_equal(anyelement, anyelement, text) TO PUBLIC;
