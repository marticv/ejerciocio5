-- ejercicio 1
-- creamos tablespace
DROP TABLESPACE academia INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE academia DATAFILE 'C:\oraclexe\app\oracle\oradata\XE\academia.dbf' SIZE 400M;
-- ejercicio 2
-- creamos usuario
DROP USER world CASCADE;
CREATE USER world IDENTIFIED BY "world" DEFAULT TABLESPACE academia QUOTA UNLIMITED ON academia;
-- damos privilegios A
GRANT ALL PRIVILEGES TO world WITH ADMIN OPTION;
-- damos privilegios B
GRANT DBA TO world;
SELECT * FROM dba_sys_privs WHERE grantee='WORLD';
SELECT grantee,count(privilege) FROM dba_sys_privs WHERE grantee='WORLD' GROUP BY grantee;
-- ejercicio 3
-- creamos tablas
CONNECT world;
DROP TABLE cursos;
DROP TABLE alumnos;
CREATE TABLE cursos(
    idcurso VARCHAR2(6)PRIMARY KEY,
    nombre VARCHAR2(30)NOT NULL,
    horario VARCHAR2(11)NOT NULL,
    fechainicial DATE NOT NULL,
    fechafinal DATE NOT NULL,
    precio NUMBER(6,2)NOT NULL,
    profesor VARCHAR2(30)NOT NULL
);
CREATE TABLE alumnos(
    nombre VARCHAR2(30)NOT NULL,
    idalumno VARCHAR2(9) PRIMARY KEY,
    idcurso VARCHAR2(6) NOT NULL,
    fechainscipcion DATE NOT NULL,
    CONSTRAINT fk_alumno FOREIGN KEY (idcurso) REFERENCES cursos(idcurso)
);
INSERT INTO cursos VALUES ('MAT101','matematicas introducción','18:00-19:00','21-01-08',date '21-06-20',500.50,'Jorge Perez');
INSERT INTO cursos VALUES ('ENG101','ingles introducció','19:00-20:00','21-01-08', '21-06-20',650.50,'Robet Smith');

INSERT INTO alumnos VALUES('Miguel Perez', 'MPC01','MAT101','20-12-20');
INSERT INTO alumnos VALUES('Javier Alto Delgado', 'JAD01','MAT101','20-12-15');
INSERT INTO alumnos VALUES('Juan Bajo Delgado', 'JBD01','ENG101','20-12-15');
INSERT INTO alumnos VALUES('Javier Alto Delgado', 'JAD02','ENG101','21-1-7');

-- creamos un sinomimo
CREATE PUBLIC SYNONYM cursos FOR world.cursos;
CREATE PUBLIC SYNONYM alumnos FOR world.alumnos;
-- ejericio 4
-- con el usuario world
DROP USER secre1;
DROP USER secre2;

CREATE USER secre1 IDENTIFIED BY "world1234" DEFAULT TABLESPACE academia;
CREATE USER secre2 IDENTIFIED BY "world1234" DEFAULT TABLESPACE academia;

GRANT CREATE SESSION to secre1, secre2;
GRANT SELECT,INSERT,UPDATE,DELETE ON cursos to secre1, secre2;
GRANT SELECT,INSERT,UPDATE,DELETE ON alumnos to secre1,secre2;

GRANT CREATE SESSION to secre2
GRANT SELECT,INSERT,UPDATE,DELETE ON cursos to secre2;
GRANT SELECT,INSERT,UPDATE,DELETE ON alumnos to secre2;
-- comprobar los privilegios de la sesion en la que estamos
SELECT * FROM dba_sys_privs WHERE grantee IN('SECRE1','SECRE2');
SELECT substr(grantee,1,10),substr(table_name,1,10),substr(privilege,1,10)
FROM dba_tab_privs WHERE grantee IN('SECRE1','SECRE2');
SELECT * FROM session_privs;
-- ejercicio 5
GRANT CREATE USER to secre1;
-- prueva comprobacion
REVOKE DELETE ON cursos FROM secre2;
-- prueva comprobacion
SELECT * FROM dba_sys_privs WHERE grantee='SECRE1';
SELECT * FROM dba_tab_privs WHERE grantee='SECRE2';

CONNECT secre2;
DELETE FROM cursos;

-- ejercicio 6
GRANT SELECT ON alumnos TO secre2 WITH GRANT OPTION;

GRANT SELECT ON
SELECT grantee,table_name,privilege FROM dba_tab_privs WHERE grantee='PRUEBA';

--ejercicio 7
CREATE ROLE rolprofe;
GRANT CREATE SESSION TO rolprofe;
GRANT SELECT ON cursos TO rolprofe;
GRANT SELECT, UPDATE ON alumnos TO rolprofe;

-- ejercicio 8
-- creamos profes y damos rol
DROP USER profe1;
DROP USER profe2;


CREATE USER profe1 IDENTIFIED BY "profe1234" DEFAULT TABLESPACE academia;
CREATE USER profe2 IDENTIFIED BY "profe1234" DEFAULT TABLESPACE academia;
GRANT rolprofe TO profe1;
GRANT rolprofe TO profe2;
-- comprobamos
SELECT * FROM dba_sys_privs WHERE grantee='ROLPROFE';
SELECT * FROM dba_tab_privs WHERE grantee='ROLPROFE';
SELECT table_name,privilege, grantee FROM dba_tab_privs WHERE grantee='ROLPROFE';
select role, granted_role from role_role_privs;
CONNECT profe1;
SELECT idcurso FROM cursos;
UPDATE alumnos SET idalumno='99999999X' WHERE idalumno='MPC01';
SELECT idalumno FROM alumnos;
DELETE FROM alumnos WHERE idalumno='99999999X';
INSERT INTO alumnos VALUES('Javier Alto Delgado', 'JAD02','ENG101','21-1-7');

SELECT grantee,table_name,privilege FROM dba_tab_privs WHERE grantee='PROFE1' ;
SELECT * FROM dba_sys_privs WHERE grantee IN('PROFE1','SECRE2');

CREATE USER hola IDENTIFIED BY "hola";
CREATE TABLE prueba(
    holaMundo VARCHAR2(2)
);

-- ejercicio 9
-- creamos perfil
CREATE PROFILE perfilprofe LIMIT
    CONNECT_TIME 60
    SESSIONS_PER_USER 2
    PASSWORD_LIFE_TIME 30;

alter profile perfilprofe limit CONNECT_TIME 2;
alter profile perfilprofe limit SESSIONS_PER_USER 1;
    
SELECT resource_name,substr(limit,1,10) FROM dba_profiles WHERE profile='PERFILPROFE';

ALTER SYSTEM SET RESOURCE_LIMIT=TRUE

ALTER USER profe1 PROFILE perfilprofe;

-- extras
drop user profe1;
drop user profe2;
drop user secre1;
drop user secre2;
drop user world;
drop user prueba;
drop profile perfilprofe;
drop role rolprofe;
drop public synonim cursos;
drop public synonim alumnos;
drop table alumnos;
drop table cursos;
DROP TABLESPACE academia INCLUDING CONTENTS AND DATAFILES;

