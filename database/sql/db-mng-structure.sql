CREATE SCHEMA IF NOT EXISTS management;

SET SCHEMA 'management';

DROP FUNCTION IF EXISTS update_timestamp();
CREATE FUNCTION update_timestamp() RETURNS trigger AS $update_timestamp$
    BEGIN
        NEW.modified_at := current_timestamp;
        RETURN NEW;
    END;
$update_timestamp$ LANGUAGE plpgsql;

DROP TABLE IF EXISTS USERS;
CREATE TABLE USERS (
  ID SERIAL,
  USERNAME VARCHAR(100) NOT NULL,
  PASSWORD VARCHAR(50) NULL DEFAULT '',
  EMAIL VARCHAR(100) NULL,
  FIRST_NAME VARCHAR(100) NULL,
  LAST_NAME VARCHAR(100) NULL,
  LAST_LOGIN TIMESTAMP NULL,
  COVER_PHOTO_URL TEXT NULL,
  MODIFIED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ID));
CREATE UNIQUE INDEX USERNAME_UNIQUE ON USERS (USERNAME);
CREATE TRIGGER update_timestamp_users BEFORE INSERT OR UPDATE ON USERS
    FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS GROUPS;
CREATE TABLE IF NOT EXISTS GROUPS (
  ID SERIAL,
  NAME VARCHAR(255) NOT NULL,
  ROLE VARCHAR(255) NOT NULL,
  MODIFIED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ID));
CREATE UNIQUE INDEX GROUP_UNIQUE ON GROUPS (NAME);
CREATE TRIGGER update_timestamp_groups BEFORE INSERT OR UPDATE ON GROUPS FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS USER_GROUPS;
CREATE TABLE IF NOT EXISTS USER_GROUPS (
  ID SERIAL,
  GROUP_ID INT NOT NULL,
  USER_ID INT NOT NULL,
  MODIFIED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ID),
  CONSTRAINT fk_USER_GROUPS_GROUPS1
    FOREIGN KEY (GROUP_ID)
    REFERENCES GROUPS (ID)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT fk_USER_GROUPS_USERS1
    FOREIGN KEY (USER_ID)
    REFERENCES USERS (ID)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);
CREATE INDEX fk_USER_GROUPS_GROUPS1_idx ON USER_GROUPS (GROUP_ID);
CREATE INDEX fk_USER_GROUPS_USERS1_idx ON USER_GROUPS (USER_ID);
CREATE UNIQUE INDEX USER_GROUP_UNIQUE ON USER_GROUPS (USER_ID, GROUP_ID);
CREATE TRIGGER update_timestamp_user_groups BEFORE INSERT OR UPDATE ON USER_GROUPS FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS PERMISSIONS;
CREATE TABLE IF NOT EXISTS PERMISSIONS (
  ID SERIAL,
  NAME VARCHAR(255) NOT NULL,
  BLOCK VARCHAR(50) NOT NULL,
  MODIFIED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ID));
CREATE UNIQUE INDEX PERMISSION_UNIQUE ON PERMISSIONS (NAME);
CREATE TRIGGER update_timestamp_permissions BEFORE INSERT OR UPDATE ON PERMISSIONS FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


DROP TABLE IF EXISTS GROUP_PERMISSIONS;
CREATE TABLE IF NOT EXISTS GROUP_PERMISSIONS (
  ID SERIAL,
  GROUP_ID INT NOT NULL,
  PERMISSION_ID INT NOT NULL,
  MODIFIED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ID),
  CONSTRAINT fk_GROUP_PERMISSIONS_GROUPS1
    FOREIGN KEY (GROUP_ID)
    REFERENCES GROUPS (ID)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT fk_GROUP_PERMISSIONS_PERMISSIONS1
    FOREIGN KEY (PERMISSION_ID)
    REFERENCES PERMISSIONS (ID)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);
CREATE INDEX fk_GROUP_PERMISSIONS_GROUPS1_idx ON GROUP_PERMISSIONS (GROUP_ID);
CREATE INDEX fk_GROUP_PERMISSIONS_PERMISSIONS1_idx ON GROUP_PERMISSIONS (PERMISSION_ID);
CREATE UNIQUE INDEX GROUP_PERMISSION_UNIQUE ON GROUP_PERMISSIONS (PERMISSION_ID, GROUP_ID);
CREATE TRIGGER update_timestamp_group_premissions BEFORE INSERT OR UPDATE ON GROUP_PERMISSIONS FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

DROP TABLE IF EXISTS TENANCIES;
CREATE TABLE IF NOT EXISTS TENANCIES (
  ID SERIAL,
  NAME VARCHAR(255) NOT NULL,
  MODIFIED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ID));
CREATE UNIQUE INDEX NAME_UNIQUE ON TENANCIES (NAME);
CREATE TRIGGER update_timestamp_tenancies BEFORE INSERT OR UPDATE ON TENANCIES FOR EACH ROW EXECUTE PROCEDURE update_timestamp();
