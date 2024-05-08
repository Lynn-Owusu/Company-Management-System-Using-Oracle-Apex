CREATE OR REPLACE FUNCTION AuthenticateUser(
    p_username IN VARCHAR2, -- User_Name
    p_password IN VARCHAR2 -- Password    
) RETURN BOOLEAN
AS
    lc_pwd_exit VARCHAR2(1);
    lc_role_name VARCHAR2(50);
BEGIN
    -- Validate whether the user exists or not
    SELECT 'Y', r.RoleName
    INTO lc_pwd_exit, lc_role_name
    FROM Users u
    INNER JOIN Roles r ON u.RoleID = r.RoleID
    WHERE UPPER(u.Username) = UPPER(p_username) AND u.PasswordHash = p_password;

    -- Check if the user has access to the application
    IF lc_role_name IN ('Administrator', 'HR manager', 'Department manager') THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END AuthenticateUser;