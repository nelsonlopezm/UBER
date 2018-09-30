/*2. Create 3 Tablespaces (0.1) :*/

/* a. first one with 2 Gb and 1 datafile, tablespace should be named " uber "*/
CREATE TABLESPACE uber
DATAFILE 'uber.dbf' SIZE 2G
ONLINE;

/*b. Undo tablespace with 25Mb of space and 1 datafile*/
CREATE UNDO TABLESPACE uberundo
DATAFILE 'uberundo.dbf' SIZE 25M;

/*c. Bigfile tablespace of 5Gb*/
CREATE BIGFILE TABLESPACE uberbigfile
DATAFILE 'uberbigfile.dbf' SIZE 5G;

/*d. Set the undo tablespace to be used in the system*/
ALTER SYSTEM SET UNDO_TABLESPACE = uberundo;

/* 3. Create a DBA user (with the role DBA) and assign it to the tablespace called " uber ", this user has unlimited space on the tablespace (The user should have permission to connect) (0.1) */
	
CREATE USER uber_dba
IDENTIFIED BY uber_dba
DEFAULT tablespace uber
QUOTA UNLIMITED ON uber;	

GRANT CONNECT, DBA TO uber_dba;

/*4. Create 2 profiles. (0.1)*/

/*a. Profile 1: "clerk" password life 40 days, one session per user, 10 minutes idle, 4 failed login
attempts*/
CREATE PROFILE clerk LIMIT  -- Usuario Empleado
PASSWORD_LIFE_TIME 40
SESSIONS_PER_USER 1
IDLE_TIME 10
FAILED_LOGIN_ATTEMPTS 4;

/*b. Profile 3: "development " password life 100 days, two session per user, 30 minutes idle, no
failed login attempts*/
CREATE PROFILE development  LIMIT -- Usuario Desarrollo
PASSWORD_LIFE_TIME 100
SESSIONS_PER_USER 2
IDLE_TIME 30
FAILED_LOGIN_ATTEMPTS UNLIMITED;


/* 5 ) Create 4 users, assign them the tablespace " uber ": */

/* a. 2 of them should have the clerk profile and the remaining the development profile, all the users should be allow to connect to the database. */
CREATE USER USER1
IDENTIFIED BY user1
DEFAULT tablespace uber
PROFILE CLERK;

CREATE USER USER2
IDENTIFIED BY user2
DEFAULT tablespace uber
PROFILE CLERK;

CREATE USER USER3
IDENTIFIED BY user3
DEFAULT tablespace uber
PROFILE DEVELOPMENT;

CREATE USER USER4
IDENTIFIED BY user4
DEFAULT tablespace uber
PROFILE DEVELOPMENT;

GRANT CONNECT TO USER1, USER2, USER3, USER4;

/* b. Lock one user associate with clerk profile */ 
ALTER USER USER1 ACCOUNT LOCK; -- Usuario Bloqueado
