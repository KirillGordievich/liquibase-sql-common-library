--
--  Returns all inherited roles of the given role/user (member).
--

CREATE OR REPLACE FUNCTION common.get_all_roles_of(
        member_name name,
        with_itself boolean DEFAULT FALSE,

        OUT role_oid oid,
        OUT role_name name
    )
    RETURNS SETOF record
    LANGUAGE SQL
    SECURITY DEFINER
    AS $$
WITH RECURSIVE cte AS (
        SELECT r.oid, r.rolname
            FROM pg_catalog.pg_roles AS r
            WHERE (r.rolname = $1)
        
        UNION SELECT m.roleid, r.rolname
            FROM cte AS c
            JOIN pg_catalog.pg_auth_members AS m
                ON (m.member = c.oid)
            JOIN pg_catalog.pg_roles AS r
                ON (m.roleid = r.oid)
    )

    SELECT DISTINCT cte.oid, cte.rolname
        FROM cte
        WHERE (cte.rolname <> $1)
            OR ((cte.rolname = $1) = $2)
$$;

ALTER FUNCTION common.get_all_roles_of(name, boolean) OWNER TO common_owner;
GRANT EXECUTE ON FUNCTION common.get_all_roles_of(name, boolean) TO PUBLIC;
