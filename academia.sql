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
SELECT grantee,count(privilege) FROM dba_sys_privs WHERE  admin_option='YES'AND grantee='WORLD' GROUP BY grantee;
-- ejercicio 3
-- creamos tablas
CONNECT world;
DROP TABLE cursos;
DROP TABLE alumnos;
CREATE TABLE cursos(
    idcurso VARCHAR2(6)PRIMARY KEY,
    nombre VARCHAR2(30)NOT NULL,
    horario VARCHAR2(11),
    fechainicial DATE,
    fechafinal DATE,
    precio NUMBER(6,2),
    profesor VARCHAR2(30)
);
CREATE TABLE alumnos(
    nombre VARCHAR2(30)NOT NULL,
    idalumno VARCHAR2(5) PRIMARY KEY,
    idcurso VARCHAR2(10),
    fechainscipcion DATE,
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

CREATE USER secre1 IDENTIFIED BY "world1234";
CREATE USER secre2 IDENTIFIED BY "world1234";

GRANT CREATE SESSION to secre1
GRANT SELECT,INSERT,UPDATE,DELETE ON cursos to secre1;
GRANT SELECT,INSERT,UPDATE,DELETE ON alumnos to secre1;

GRANT CREATE SESSION to secre2
GRANT SELECT,INSERT,UPDATE,DELETE ON cursos to secre2;
GRANT SELECT,INSERT,UPDATE,DELETE ON alumnos to secre2;
-- comprobar los privilegios de la sesion en la que estamos
SELECT * FROM session_privs;
-- pendiente probar todo


-- ejercicio 5
GRANT CREATE USER to secre1;
-- prueva comprobacion
REVOKE DELETE ON cursos FROM secre2;
-- prueva comprobacion

SELECT sunstr(privilege,1,20), substr(table_name, 1,20)FROM dba_tab_privs WHERE grantee="SECRE2";

-- ejercicio 6
GRANT SELECT ON alumnos TO secre2 WITH GRANT OPTION;
-- pendiente comprobacion