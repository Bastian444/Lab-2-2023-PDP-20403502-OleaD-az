% Definición del TDA
tda_system([Nombre, Timestamp, [], [], [], [], [], []], Nombre, Timestamp).
tda_drive([Letter, String, Number], Letter, String, Number).
tda_user(Name, Name).
tda_path([StringPath,User,Drive,_,_],StringPath,User,Drive).

% No requeridos
get_first_element_string([String], String).


getFirstElement([], []).
getFirstElement([[First|_]|Rest], [First|Firsts]) :-
    getFirstElement(Rest, Firsts).

checkLetterRep(List) :-
    getFirstElement(List, Firsts),
    sort(Firsts, SortedFirsts),
    length(Firsts, N),
    length(SortedFirsts, N).

userRep(String, List) :-
    \+ (select(String, List, _)),
    !.

isnull([]). % Para preguntar por no null añadir \+, es decir, \+ (isnull(algo))

checkDrive(Letter, Lists) :- % Checkear que sea una letra de un drive, que ya exista
    member([Letter|_], Lists).

path([StringPath, User, Drive, Timestamp1, Timestamp2], StringPath, User, Drive) :-
    get_time(Timestamp1),
    get_time(Timestamp2),
    tda_path(_,_,User,Drive). % Crea un path

get_substring(String, Substring) :- % Recorta strings tipo Holamundo/lab1 -> Holamundo
    split_string(String, "/", "", [Substring|_]).


% Para checkear que un string solo contenga Letras y Numeros 
soloLetrasyNumeros(String) :-
    string_chars(String, Chars),
    soloLetrasyNumerosLista(Chars).

soloLetrasyNumerosLista([]).
soloLetrasyNumerosLista([Char | Rest]) :-
    char_type(Char, alnum),
    soloLetrasyNumerosLista(Rest).

% Hecha para el cd de "./folder1"
puntoSlashFolder(String) :-
    sub_string(String, 0, 2, _, "./"),
    sub_string(String, 2, _, 0, Substring),
    soloLetrasyNumeros(Substring).

% Hecha para "dir1/dir2" -> dir2
subdir(String, Result) :-
    split_string(String, "/", "", [_|Result]).

% Hecha para checkear si "dir1/dir2"
dirSlashdir(S) :-
    string_codes(S, Codes),
    maplist([C]>>(C>=48,C=<57;C>=65,C=<90;C>=97,C=<122;C=47), Codes).

% Hecha para "../dir1"
puntoPuntoSlash(S) :-
    sub_string(S, 0, 3, _, "../").

% Hecha para checkear si "././././"
puntosySlashes(S) :-
    string_codes(S, Codes),
    maplist([C]>>(C=46;C=47), Codes).

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

systemRegister(S1, User, S2) :-
    tda_user(NewUser,User),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6],
    userRep(NewUser,L2),
    append(L2, [NewUser], NewUsers),
    S2 = [Nombre, Timestamp, L1, NewUsers, L3, L4, L5, L6].

systemLogin(S1, User, S2) :-
    tda_user(NewUser,User),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6],
    isnull(L1),
    member(NewUser,L2),
    append(L1,[NewUser], NewCurrentUser),
    S2 = [Nombre, Timestamp, NewCurrentUser, L2, L3, L4, L5, L6].

systemLogout(S1,S2) :-
    S1 = [Nombre, Timestamp, _, L2, L3, L4, L5, L6],
    S2 = [Nombre, Timestamp, [], L2, L3, L4, L5, L6].

systemSwitchDrive(S1, Letter, S2) :-    
    S1 = [Nombre, Timestamp, L1, L2, L3, _, L5, L6],
    not(isnull(L1)), % Checkear que haya un usuario logeado
    checkDrive(Letter,L3),
    append([],Letter, NewCurrentDrive), % Resetear el drive
    S2 = [Nombre, Timestamp, L1, L2, L3, NewCurrentDrive, L5, L6].

systemMkdir(S1, StringPath,S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6],
    \+ (isnull(L1)), % Checkear que haya un usuario logeado
    get_first_element_string(L1,Cosa),
    path(Path,StringPath,Cosa,L4),
    append(L6,[Path],NewPaths),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewPaths].

% systemCd

systemCd(S1, StringPath, S2) :- % './' - REDY
    StringPath = "./",
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6].

systemCd(S1, StringPath, S2) :- % '..' - REDY
    StringPath = "..",
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, [CPath], L6],
    get_substring(CPath,NewPath),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, [NewPath], L6].

systemCd(S1, StringPath, S2) :- % '/' - REDY
    StringPath = "/",
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, _, L6],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, ["/"], L6].

systemCd(S1, StringPath, S2) :- % 'folder1' - REDY
    soloLetrasyNumeros(StringPath),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, _, L6],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, [StringPath], L6].

systemCd(S1, StringPath, S2) :- % '/.folder1' - REDY
    puntoSlashFolder(StringPath),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, _, L6],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, [StringPath], L6].

systemCd(S1, StringPath, S2) :- % 'folder/folder11' - REDY
    dirSlashdir(StringPath),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, _, L6],
    %subdir(StringPath,NewPath),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, [StringPath], L6].

% Suponiendo que hay un directorio actual y se llama 'dir1'
systemCd(S1, StringPath, S2) :- % '.' - REDY
    StringPath = ".",
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6].
  
systemCd(S1, StringPath, S2) :- % '../dir1' - REDY
    puntoPuntoSlash(StringPath),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6].

systemCd(S1, StringPath, S2) :- % '././././' - Redy
    puntosySlashes(StringPath),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6],
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6].