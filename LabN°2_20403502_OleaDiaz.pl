% Definición del TDA

% Nombre 
% Dominio:
% Descripción:
tda_system([Nombre, Timestamp, [], [], [], [], [], [], []], Nombre, Timestamp).
% Nombre 
% Dominio:
% Descripción:
tda_drive([Letter, String, Number], Letter, String, Number).
% Nombre 
% Dominio:
% Descripción:
tda_user(Name, Name).
% Nombre 
% Dominio:
% Descripción:
tda_path([StringPath,User,Drive,_,_],StringPath,User,Drive).
% Nombre 
% Dominio:
% Descripción:
file(Name,Content,[Name, Content]).

% No requeridos
% Nombre 
% Dominio:
% Descripción:
get_first_element_string([String], String).

% Nombre 
% Dominio:
% Descripción:
getFirstElement([], []).
getFirstElement([[First|_]|Rest], [First|Firsts]) :-
    getFirstElement(Rest, Firsts).

% Nombre 
% Dominio:
% Descripción:
checkLetterRep(List) :-
    getFirstElement(List, Firsts),
    sort(Firsts, SortedFirsts),
    length(Firsts, N),
    length(SortedFirsts, N).

% Nombre 
% Dominio:
% Descripción:
userRep(String, List) :-
    \+ (select(String, List, _)),
    !.

% Nombre 
% Dominio:
% Descripción:
isnull([]). % Para preguntar por no null añadir \+, es decir, \+ (isnull(algo))

% Nombre 
% Dominio:
% Descripción:
checkDrive(Letter, Lists) :- % Checkear que sea una letra de un drive, que ya exista
    member([Letter|_], Lists).

% Nombre 
% Dominio:
% Descripción:
path([StringPath, User, Drive, Timestamp1, Timestamp2], StringPath, User, Drive) :-
    get_time(Timestamp1),
    get_time(Timestamp2),
    tda_path(_,_,User,Drive). % Crea un path

% Nombre 
% Dominio:
% Descripción:
get_substring(String, Substring) :- % Recorta strings tipo Holamundo/lab1 -> Holamundo
    split_string(String, "/", "", [Substring|_]).



% Nombre 
% Dominio:
% Descripción:
% Para checkear que un string solo contenga Letras y Numeros 
soloLetrasyNumeros(String) :-
    string_chars(String, Chars),
    soloLetrasyNumerosLista(Chars).

soloLetrasyNumerosLista([]).
soloLetrasyNumerosLista([Char | Rest]) :-
    char_type(Char, alnum),
    soloLetrasyNumerosLista(Rest).

% Nombre 
% Dominio:
% Descripción:
% Hecha para el cd de "./folder1"
puntoSlashFolder(String) :-
    sub_string(String, 0, 2, _, "./"),
    sub_string(String, 2, _, 0, Substring),
    soloLetrasyNumeros(Substring).

% Nombre 
% Dominio:
% Descripción:
% Hecha para "dir1/dir2" -> dir2
subdir(String, Result) :-
    split_string(String, "/", "", [_|Result]).

% Nombre 
% Dominio:
% Descripción:
% Hecha para checkear si "dir1/dir2"
dirSlashdir(S) :-
    string_codes(S, Codes),
    maplist([C]>>(C>=48,C=<57;C>=65,C=<90;C>=97,C=<122;C=47), Codes).

% Nombre 
% Dominio:
% Descripción:
% Hecha para "../dir1"
puntoPuntoSlash(S) :-
    sub_string(S, 0, 3, _, "../").

% Nombre 
% Dominio:
% Descripción:
% Hecha para checkear si "././././"
puntosySlashes(S) :-
    string_codes(S, Codes),
    maplist([C]>>(C=46;C=47), Codes).

% Requerimientos funcionales

% Nombre 
% Dominio:
% Descripción:
system(TDA, Nombre) :-
    get_time(Timestamp),
    tda_system(TDA, Nombre, Timestamp).

% Nombre 
% Dominio:
% Descripción:
systemAddDrive(S1, Letter, String, Number, S2) :-
    tda_drive(Drive, Letter, String, Number),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    append(L3, [Drive], NewDriveList),
    S2 = [Nombre, Timestamp, L1, L2, NewDriveList, L4, L5, L6, L7],
    checkLetterRep(NewDriveList).

% Nombre 
% Dominio:
% Descripción:
systemRegister(S1, User, S2) :-
    tda_user(NewUser,User),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    userRep(NewUser,L2),
    append(L2, [NewUser], NewUsers),
    S2 = [Nombre, Timestamp, L1, NewUsers, L3, L4, L5, L6, L7].

% Nombre 
% Dominio:
% Descripción:
systemLogin(S1, User, S2) :-
    tda_user(NewUser,User),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    isnull(L1),
    member(NewUser,L2),
    append(L1,[NewUser], NewCurrentUser),
    S2 = [Nombre, Timestamp, NewCurrentUser, L2, L3, L4, L5, L6, L7].

% Nombre 
% Dominio:
% Descripción:
systemLogout(S1,S2) :-
    S1 = [Nombre, Timestamp, _, L2, L3, L4, L5, L6, L7],
    S2 = [Nombre, Timestamp, [], L2, L3, L4, L5, L6, L7].

% Nombre 
% Dominio:
% Descripción:
systemSwitchDrive(S1, Letter, S2) :-    
    S1 = [Nombre, Timestamp, L1, L2, L3, _, L5, L6, L7],
    not(isnull(L1)), % Checkear que haya un usuario logeado
    checkDrive(Letter,L3),
    append([],Letter, NewCurrentDrive), % Resetear el drive
    S2 = [Nombre, Timestamp, L1, L2, L3, NewCurrentDrive, L5, L6, L7].

% Nombre 
% Dominio:
% Descripción:
systemMkdir(S1, StringPath,S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    \+ (isnull(L1)), % Checkear que haya un usuario logeado
    get_first_element_string(L1,Cosa),
    path(Path,StringPath,Cosa,L4),
    append(L6,[Path],NewPaths),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewPaths, L7].

% systemCd
% Nombre 
% Dominio:
% Descripción:
systemCd(S1, StringPath, S2) :- % './' - REDY
    StringPath = "./",
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7].

systemCd(S1, StringPath, S2) :- % '..' - REDY
    StringPath = "..",
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, [CPath], L6, L7],
    get_substring(CPath,NewPath),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, [NewPath], L6, L7].

systemCd(S1, StringPath, S2) :- % '/' - REDY
    StringPath = "/",
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, _, L6, L7],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, ["/"], L6, L7].

systemCd(S1, StringPath, S2) :- % 'folder1' - REDY
    soloLetrasyNumeros(StringPath),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, _, L6, L7],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, [StringPath], L6, L7].

systemCd(S1, StringPath, S2) :- % '/.folder1' - REDY
    puntoSlashFolder(StringPath),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, _, L6, L7],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, [StringPath], L6, L7].

systemCd(S1, StringPath, S2) :- % 'folder/folder11' - REDY
    dirSlashdir(StringPath),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, _, L6, L7],
    %subdir(StringPath,NewPath),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, [StringPath], L6, L7].

% Suponiendo que hay un directorio actual y se llama 'dir1'
systemCd(S1, StringPath, S2) :- % '.' - REDY
    StringPath = ".",
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7].
  
systemCd(S1, StringPath, S2) :- % '../dir1' - REDY
    puntoPuntoSlash(StringPath),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7].

systemCd(S1, StringPath, S2) :- % '././././' - Redy
    puntosySlashes(StringPath),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7].

% systemAddFile
% Nombre 
% Dominio:
% Descripción:
systemAddFile(S1, File, S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    append(File,L1,FileWithUser),
    append(FileWithUser,L5,FileWithPath),
    append(L6,[FileWithPath],NewPaths),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewPaths, L7].
    