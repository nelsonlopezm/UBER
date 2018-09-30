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