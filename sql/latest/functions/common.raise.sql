--
--  Wrap RAISE NOTICE as function
--

CREATE FUNCTION common.raise_notice(message text)
    RETURNS VOID
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE '%', message;
END
$$;

ALTER FUNCTION common.raise_notice(text) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.raise_notice(text) TO PUBLIC;


--
--  Wrap RAISE INFO as function
--

CREATE FUNCTION common.raise_info(message text)
    RETURNS VOID
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE INFO '%', message;
END
$$;

ALTER FUNCTION common.raise_info(text) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.raise_info(text) TO PUBLIC;


--
--  Wrap RAISE WARNING as function
--

CREATE FUNCTION common.raise_warning(message text)
    RETURNS VOID
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE WARNING '%', message;
END
$$;


ALTER FUNCTION common.raise_warning(text) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.raise_warning(text) TO PUBLIC;


--
--  Wrap RAISE EXCEPTION as function
--

CREATE FUNCTION common.raise_exception(message text)
    RETURNS VOID
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE EXCEPTION '%', message;
END
$$;

ALTER FUNCTION common.raise_exception(text) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.raise_exception(text) TO PUBLIC;
