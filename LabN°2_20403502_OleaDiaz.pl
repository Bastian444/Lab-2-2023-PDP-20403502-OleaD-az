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
tda_drive([Letter, String, Number], Letter, String, Number).

% No requeridos
checkLetterRep(List) :-
    getFirstElement(List, Firsts),
    sort(Firsts, SortedFirsts),
    length(Firsts, N),
    length(SortedFirsts, N).
    
getFirstElement([], []).
getFirstElement([[First|_]|Rest], [First|Firsts]) :-
    getFirstElement(Rest, Firsts).


% Requerimientos funcionales
system(TDA, Nombre) :-
    get_time(Timestamp),
    tda_system(TDA, Nombre, Timestamp).

systemAddDrive(S1, Letter, String, Number, S2) :-
    tda_drive(Drive, Letter, String, Number),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6],
    append(L3, [Drive], NewDriveList),
    S2 = [Nombre, Timestamp, L1, L2, NewDriveList, L4, L5, L6],
    checkLetterRep(NewDriveList).
