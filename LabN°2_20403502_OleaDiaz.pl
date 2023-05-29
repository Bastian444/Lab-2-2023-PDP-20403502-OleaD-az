/*
Laboratario N° 2 - Paradigmas de Programación (1-2023)

Paradigma: Lógico
Lenguaje de programación: Prolog
Estudiante: Bastián Olea Díaz

TDA's:
    ·System
    ·User
    ·Drive
    ·File
    ·Directorio
*/

% Definición del TDA
tda_system([Nombre, Timestamp, [], [], [], [], [], []], Nombre, Timestamp).

% Ejemplo de uso del TDA
system(TDA, Nombre) :-
    get_time(Timestamp),
    tda_system(TDA, Nombre, Timestamp).
