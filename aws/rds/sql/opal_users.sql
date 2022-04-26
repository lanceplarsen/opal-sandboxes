-- Create a group
CREATE ROLE readaccess;

-- Grant access to existing tables
GRANT USAGE ON SCHEMA public TO readaccess;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readaccess;

-- Grant access to future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readaccess;

-- Create a user with IAM authentication
CREATE USER readonly; -- NOTE: THIS USERNAME IS REQUIRED
GRANT readaccess TO readonly;
GRANT rds_iam TO readonly;

CREATE USER fullaccess; -- NOTE: THIS USERNAME IS REQUIRED
GRANT rds_superuser TO fullaccess;
GRANT rds_iam TO fullaccess;
