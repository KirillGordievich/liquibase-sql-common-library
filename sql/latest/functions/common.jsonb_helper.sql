--
--  Finds differences between two objects (one level only)
--

CREATE OR REPLACE FUNCTION common.jsonb_diff_objects(
        left_object jsonb, -- e.g. '{"a":"foo", "b":"bar"}'
        right_object jsonb, -- e.g. '{"a":"foo", "b":"baz"}'

        OUT common_fields jsonb, -- e.g. '{"a":"foo"}'
        OUT left_fields jsonb, -- e.g. '{"b":"bar"}'
        OUT right_fields jsonb -- e.g. '{"b":"baz"}'
    )
    RETURNS record
    LANGUAGE SQL
    IMMUTABLE STRICT
    AS $$
WITH
    merged AS (
        SELECT
                COALESCE(l.k, r.k) AS k,
                COALESCE(l.v, r.v) AS v,
                (l.k IS NOT NULL) AS is_left,
                (r.k IS NOT NULL) AS is_right
            FROM jsonb_each(left_object) AS l(k, v)
            FULL OUTER JOIN jsonb_each(right_object) AS r(k,v)
                USING (k, v)
    )

    SELECT
        COALESCE((SELECT jsonb_object_agg(k, v) FROM merged WHERE (is_left) AND (is_right)), '{}'),
        COALESCE((SELECT jsonb_object_agg(k, v) FROM merged WHERE (is_left) AND (NOT is_right)), '{}'),
        COALESCE((SELECT jsonb_object_agg(k, v) FROM merged WHERE (NOT is_left) AND (is_right)), '{}')
$$;

ALTER FUNCTION common.jsonb_diff_objects(jsonb, jsonb) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.jsonb_diff_objects(jsonb, jsonb) TO PUBLIC;


--
--  Extracts JSON array as native SQL text array
--  Returned array can be casted to any type array
--  the entry values are suited for.
--

CREATE OR REPLACE FUNCTION common.jsonb_extract_text_array(
        item jsonb, -- e.g. ["a", "b", "c"]'::jsonb
        path VARIADIC text[] DEFAULT '{}'
    )
    RETURNS text[] -- e.g. {a,b,c}
    LANGUAGE SQL
    IMMUTABLE STRICT
    AS $$
SELECT ARRAY(SELECT jsonb_array_elements_text(item#>path)::text)
    WHERE (jsonb_typeof(item#>path) <> 'null')
$$;

ALTER FUNCTION common.jsonb_extract_text_array(jsonb, VARIADIC text[]) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.jsonb_extract_text_array(jsonb, VARIADIC text[]) TO PUBLIC;
