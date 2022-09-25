--
--  See https://wiki.postgresql.org/wiki/Pseudo_encrypt
--

-- Example query: SELECT common.pseudo_encrypt(0, 200);
-- Result: 1489531922

CREATE OR REPLACE FUNCTION common.pseudo_encrypt(
        id int4,
        key int4 DEFAULT 1
    )
    RETURNS int4
    LANGUAGE plpgsql
    STRICT IMMUTABLE
    AS $$
DECLARE
    l1 int4;
    l2 int4;
    r1 int4;
    r2 int4;
BEGIN
    l1 := (id >> 16) & 65535;
    r1 := (id >> 0) & 65535;

    -- fix key & prevent signed overflow (xor hi & lo 16 bits)
    key := COALESCE(key, 0);
    key := (key # (key >> 16)) & 65535;

    FOR i IN 1..3 LOOP
        l2 := r1;
        r2 := l1 # ((((32569 * r1 + key) % 32749) / 32749.0) * 32767)::int4;
        l1 := l2;
        r1 := r2;
    END LOOP;

    RETURN ((r1 << 16) + l1);
END
$$;

ALTER FUNCTION common.pseudo_encrypt(int4, int4) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.pseudo_encrypt(int4, int4) TO PUBLIC;


--
--  Same for 64-bit integer
--

-- Example query: SELECT common.pseudo_encrypt(0::int8, 200::int8);
-- Result: 388897292822079650
-- NOTE: use ::int8 for values in the int4 range () to use int8 version

CREATE OR REPLACE FUNCTION common.pseudo_encrypt(id int8, key int8 DEFAULT 1)
    RETURNS int8
    LANGUAGE plpgsql
    STRICT IMMUTABLE
    AS $$
DECLARE
    l1 int8;
    l2 int8;
    r1 int8;
    r2 int8;
BEGIN
    l1 := (id >> 32) & 4294967295;
    r1 := (id >> 0) & 4294967295;

    -- fix key & prevent signed overflow (xor hi & lo 32 bits)
    key := COALESCE(key, 0);
    key := (key # (key >> 32)) & 4294967295;

    FOR i IN 1..3 LOOP
        l2 := r1;
        r2 := l1 # ((((1723764131 * r1 + key) % 1991021699) / 1991021699.0) * 2147483647)::int8;
        l1 := l2;
        r1 := r2;
    END LOOP;

    RETURN ((r1 << 32) + l1);
END
$$;

ALTER FUNCTION common.pseudo_encrypt(int8, int8) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.pseudo_encrypt(int8, int8) TO PUBLIC;
