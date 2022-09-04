--
--  Create owner role (add current user to created role with admin option)
--

DO $$
BEGIN
    CREATE ROLE common_owner ADMIN current_user;
EXCEPTION
    WHEN duplicate_object THEN NULL;
END
$$;

--
--  Fix common schema owner / permissions.
--

GRANT common_owner TO current_user;

ALTER SCHEMA common OWNER TO common_owner;
GRANT USAGE ON SCHEMA common TO PUBLIC;
