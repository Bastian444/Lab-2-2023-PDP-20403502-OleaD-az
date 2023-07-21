
/*
 -----------------------------------------------------------
 Laboratorio N°2 - Paradigmas de programación
 Estudiante: Bastián Olea Díaz
 Sección: B-2
 Profesor: Gonzalo Martínez
 -----------------------------------------------------------
 Script de Pruebas
 -----------------------------------------------------------
 */

/*
 *************** Pruebas por el estudiante ***************
*/
system(S1, "Kali"),
system(T1, "FAT32"),
system(U1, "Windows 98"),
systemAddDrive(S1, 'A', 'Drive1', 512, S2),
systemAddDrive(S2, 'B', 'Drive2', 64, S3),
systemAddDrive(S3, 'C', 'Drive3', 825, S4),
systemRegister(S4,'Renato', S5),
systemRegister(S5,'Lisa', S6)
systemRegister(T1,'Batman', T2),
systemLogin(S6,'Lisa',S7),
systemLogout(S7a,S8a),
systemLogin(S8a,'Renato',S8b),
systemLogout(S8b,S8c),
systemLogin(T2,'Batman',T3),
% systemLogin(T3,'Robin',T4), % Falso. Eliminar comentario al inicio de la linea para ejecutar
systemSwitchDrive(S7,'C',S8),
systemSwitchDrive(S8,'A',S8a),
systemSwitchDrive(S8a,'B',S8b),
systemMkdir(S8, "folder1", S9),
systemMkdir(S9, "folder2", S10),
systemMkdir(S10, "folder2/folder3", S11),
systemCd(S11,"folder1",S12),
systemCd(S12,"folder2/folder3",S12a),
systemCd(S12a,"folder2",S12b),
file("Libro de Calculo.pdf", "El calculo fue inventado...", File1),
file("Libro de Algebra.pdf", "En este libro...", File2),
file("Libro de Física.pdf", "La fisíca es la ciencia...", File3),
file("PesoPluma-Bye.mp3", "Que será la noche como de costumbre...", File4),
systemAddFile(S12,File1,S13),
systemAddFile(S13,File2,S14),
systemAddFile(S14,File3,S15),
systemAddFile(S15,File4,S16).

/*
 *************** Pruebas del enunciado ***************
 */

% Caso que debe retornar true:
% Creando un sistema, con el disco C, dos usuarios: “user1” y “user2”, 
% se hace login con "user1”, se utiliza el disco "C", se crea la carpeta “folder1”, 
% “folder2”, se cambia al directorio actual “folder1", 
% se crea la carpeta "folder11" dentro de "folder1", 
% se hace logout del usuario "user1", se hace login con “user2”, 
% se crea el archivo "foo.txt" dentro de “folder1”, se acceder a la carpeta c:/folder2, 
% se crea el archivo "ejemplo.txt" dentro de c:/folder2
system("newSystem", S1), systemAddDrive(S1, "C", "OS", 10000000000, S2), 
systemRegister(S2, "user1", S3), systemRegister(S3, "user2", S4), 
systemLogin(S4, "user1", S5), systemSwitchDrive(S5, "C", S6), 
systemMkdir(S6, "folder1", S7), systemMkdir(S7, "folder2", S8), 
systemCd(S8, "folder1", S9), systemMkdir(S9, "folder11", S10), 
systemLogout(S10, S11), systemLogin(S11, "user2", S12), 
file( "foo.txt", "hello world", F1), systemAddFile(S12, F1, S13), 
systemCd(S13, "/folder2", S14),  file( "ejemplo.txt", "otro archivo", F2), 
systemAddFile(S14, F2, S15).

% Casos que deben retornar false:
% si se intenta añadir una unidad con una letra que ya existe
system("newSystem", S1), systemRegister(S1, "user1", S2), 
systemAddDrive(S2, "C", "OS", 1000000000, S3), 
systemAddDrive(S3, "C", "otra etiqueta", 1000000000, S4).

% si se intenta hacer login con otra sesión ya iniciada por este usuario u otro
system("newSystem", S1), systemRegister(S1, "user1", S2), 
systemRegister(S2, "user2", S3), systemLogin(S3, "user1", S4), 
systemLogin(S4, "user2", S5).

% si se intenta usar una unidad inexistente
system("newSystem", S1), systemRegister(S1, "user1", S2), 
systemLogin(S2, "user1", S3), systemSwitchDrive(S3, "K", S4).
