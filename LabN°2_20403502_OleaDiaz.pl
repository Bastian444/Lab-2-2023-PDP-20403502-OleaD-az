% Definición del TDA
tda_system([Nombre, Timestamp, [], [], [], [], [], []], Nombre, Timestamp).
tda_drive([Letter, String, Number], Letter, String, Number).
tda_user(Name, Name).
tda_path([StringPath,User,Drive,_,_],StringPath,User,Drive).

% No requeridos
get_first_element([String], String).


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

isnull([]). % Para preguntar por no null añadir not, es decir, not(isnull(algo))

checkDrive(Letter, Lists) :- % Checkear que sea una letra de un drive, que ya exista
    member([Letter|_], Lists).

path([StringPath, User, Drive, Timestamp1, Timestamp2], StringPath, User, Drive) :-
    get_time(Timestamp1),
    get_time(Timestamp2),
    tda_path(_,_,User,Drive).

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

systemMkdir(S1,StringPath,S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6],
    not(isnull(L1)), % Checkear que haya un usuario logeado
    get_first_element(L1,Cosa),
    path(Path,StringPath,Cosa,L4),
    append(L6,[Path],NewPaths),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewPaths].