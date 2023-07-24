:- use_module(tda_system_20403502_OleaDiaz).
:- use_module(tda_user_20403502_OleaDiaz).
:- use_module(tda_file_20403502_OleaDiaz).
:- use_module(tda_drive_20403502_OleaDiaz).



/*
 -----------------------------------------------------------
 Laboratorio N°2 - Paradigmas de programación
 Estudiante: Bastián Olea Díaz
 Sección: B-2
 Profesor: Gonzalo Martínez

 *** Requerimientos funcionales a partir de la linea 206***
 -----------------------------------------------------------
 */
% ************************************* Otras Funciones *******************************
% 
% TDA Path
% Dominio: Path x Ruta x Usuario x Drive
% Descripción: Crea una ruta a partir de un path, usuario activo y drive.
tda_path([StringPath,User,Drive,_,_],StringPath,User,Drive).

% extGetter
% Dominio: Nombre de archivo x Extension este
% Descripción: Dado el nombre de un archivo, obtiene la extension del archivo
% Ejemplo: extGetter("El Principito.pdf", EXT). EXT = "pdf".
extGetter(String, Ext) :-
    split_string(String,".","",[_|Ext]).

% unlistOneElement 
% Dominio: Lista
% Descripción: El unico propósito que cumple es desenlistar.
% Ejemplo: unlistOneElement(["Nombre de Usuario"], Elemento). Elemento = "Nombre de Usuario".
unlistOneElement([X], X).

% getFirstElement
% Dominio: Lista x Lista
% Descripción: Su propósito es agrupar todas las letras existentes de los drives, ya existentes
% para luego verificar si la nueva letra que se quiere ingresar es ya existente.
getFirstElement([], []).
getFirstElement([[First|_]|Rest], [First|Firsts]) :-
    getFirstElement(Rest, Firsts).

get_first_element_string([String], String).

% checkLetterRep
% Dominio: Lista
% Descripción: Checkea si en la lista hay alguna letra que se repita.
checkLetterRep(List) :-
    getFirstElement(List, Firsts),
    sort(Firsts, SortedFirsts),
    length(Firsts, N),
    length(SortedFirsts, N).

% userRep
% Dominio: String x Lista
% Descripción: Verificar si el usuario que se va a añadir es repetido.
userRep(String, List) :-
    \+ (select(String, List, _)),
    !.

% isnull 
% Dominio: Lista
% Descripción: Verificar si una lista es vacía.
isnull([]). % Para preguntar por no null añadir \+, es decir, \+ (isnull(algo))

% checkDrive
% Dominio: Letra x Lista
% Descripción: Checkear que sea una letra de un drive, que ya exista
checkDrive(Letter, Lists) :- 
    member([Letter|_], Lists).

% Nombre 
% Dominio:
% Descripción:
path([StringPath, User, Drive, Timestamp1, Timestamp2], StringPath, User, Drive) :-
    get_time(Timestamp1),
    get_time(Timestamp2),
    tda_path(_,_,User,Drive). % Crea un path

% get_substring
% Dominio: String x Substring
% Descripción: Recorta strings tipo Holamundo/lab1 -> Holamundo
get_substring(String, Substring) :- 
    split_string(String, "/", "", [Substring|_]).



% soloLetrasyNUmeros
% Dominio: String
% Descripción: Para checkear que un string solo contenga Letras y Numeros 
soloLetrasyNumeros(String) :-
    string_chars(String, Chars),
    soloLetrasyNumerosLista(Chars).

soloLetrasyNumerosLista([]).
soloLetrasyNumerosLista([Char | Rest]) :-
    char_type(Char, alnum),
    soloLetrasyNumerosLista(Rest).

% puntoSlashFolder
% Dominio: String
% Descripción: Hecha para el cd de "./folder1"
puntoSlashFolder(String) :-
    sub_string(String, 0, 2, _, "./"),
    sub_string(String, 2, _, 0, Substring),
    soloLetrasyNumeros(Substring).

% subdir
% Dominio: String x String
% Descripción: Hecha para "dir1/dir2" -> dir2
subdir(String, Result) :-
    split_string(String, "/", "", [_|Result]).

% dirSlashdir
% Dominio: String
% Descripción: Hecha para checkear si "dir1/dir2"
dirSlashdir(S) :-
    string_codes(S, Codes),
    maplist([C]>>(C>=48,C=<57;C>=65,C=<90;C>=97,C=<122;C=47), Codes).

% puntoPuntoSlash
% Dominio: String
% Descripción: Hecha para identificar "../dir1"
puntoPuntoSlash(S) :-
    sub_string(S, 0, 3, _, "../").

% puntoySlashes
% Dominio: String
% Descripción: Hecha para checkear si "././././"
puntosySlashes(S) :-
    string_codes(S, Codes),
    maplist([C]>>(C=46;C=47), Codes).

% fileFinder
% Dominio: String x Lista x Lista
% Descripción: Según un path dado, agrupa los archivos y directorios que cumplan,
% y los retorna en otra lista.
fileFinder(_, [], []).
fileFinder(Key, [[Key|Rest] | _], [Key|Rest]).
fileFinder(Key, [_|RestLists], Result) :-
    fileFinder(Key, RestLists, Result).

% ifFileName
% Dominio: String
% Descripción:
ifFileName(String) :-
    string_codes(String, Codes),
    validFileName(Codes).

validFileName([]).
validFileName([Code|Rest]) :-
    (   Code = 46 % dot
    ;   Code >= 48, Code =< 57 % Números 
    ;   Code >= 65, Code =< 90 % Minúsculas
    ;   Code >= 97, Code =< 122 % Mayúsculas
    ),
    validFileName(Rest).

% fileDeleter
% Dominio: String x Lista x Lista
% Descripción: Según path dado busca en una lista los archivos y directorios,
% que cumpla y los elimina
fileDeleter(_, [], []).
fileDeleter(Key, [[Key|_]|RestLists], Result) :-
    fileDeleter(Key, RestLists, Result).
fileDeleter(Key, [List|RestLists], [List|Result]) :-
    fileDeleter(Key, RestLists, Result).

% ifExtension 
% Dominio: String
% Descripción: Revisa para el caso de que se quiera elminar por extensión
% Ejemplo: "*.docx"
ifExtension(String) :-
    atom_chars(String, [A, B, C | _]),
    A = '*',
    B = '.',
    char_type(C, alpha).

% deleteByExtension 
% Dominio: String x Lista x Lista
% Descripción: Dado un sting (Extension) y una lista agrupa todos los elementos que 
% cumplan con la extension dada y los elimina para formar una lista nueva, sin estos.
deleteByExtension(_, [], []).
deleteByExtension(String, [[_, X] | Rest], Result) :-
    X \= String,
    deleteByExtension(String, Rest, NewResult),
    Result = [[_, X] | NewResult].
deleteByExtension(String, [[_, String] | Rest], Result) :-
    deleteByExtension(String, Rest, Result).

% toBeRemovedByExtension
% Dominio: String x Lista x Lista
% Descripción: Dado una extension y una lista agrupa, los elementos que deben ser 
% movidos a la papelera.
toBeRemovedByExtension(_, [], []).
toBeRemovedByExtension(String, [[_, String] | Rest], Result) :-
    toBeRemovedByExtension(String, Rest, NewResult),
    Result = [[_, String] | NewResult].
toBeRemovedByExtension(String, [[_, X] | Rest], Result) :-
    X \= String,
    toBeRemovedByExtension(String, Rest, Result).

% ************************************************************************************************************************
% ************************************************************************************************************************
% ********************************************** Requerimientos funcionales **********************************************
% ************************************************************************************************************************
%  ************************************************************************************************************************

% system - Constructor
% Dominio: System x Nombre del sistema
% Descripción: Crea un sistema a partir de un nombre.
system(Nombre, TDA) :-
    get_time(Timestamp),
    tda_system(TDA, Nombre, Timestamp).

% systemAddDrive 
% Dominio: System x Letra x Nombre de Drive x Capacidad x System
% Descripción: Añade un drive al system. Falla en caso de repetir letra.
systemAddDrive(S1, Letter, String, Number, S2) :-
    tda_drive(Drive, Letter, String, Number),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    append(L3, [Drive], NewDriveList),
    S2 = [Nombre, Timestamp, L1, L2, NewDriveList, L4, L5, L6, L7],
    checkLetterRep(NewDriveList).

% systemRegister
% Dominio: System x Usuario x System
% Descripción: Registra un nuevo usuario, falla en caso de repetir nombre.
systemRegister(S1, User, S2) :-
    tda_user(NewUser,User),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    userRep(NewUser,L2),
    append(L2, [NewUser], NewUsers),
    S2 = [Nombre, Timestamp, L1, NewUsers, L3, L4, L5, L6, L7].

% systemLogin
% Dominio: System x Usuario x System
% Descripción: Inicia sesión con un usuario.
systemLogin(S1, User, S2) :-
    tda_user(NewUser,User),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    isnull(L1),
    member(NewUser,L2),
    append(L1,[NewUser], NewCurrentUser),
    S2 = [Nombre, Timestamp, NewCurrentUser, L2, L3, L4, L5, L6, L7].

% systemLogout
% Dominio: System x System
% Descripción: Cierra la sesión de un usuario preiamente activo.
systemLogout(S1,S2) :-
    S1 = [Nombre, Timestamp, _, L2, L3, L4, L5, L6, L7],
    S2 = [Nombre, Timestamp, [], L2, L3, L4, L5, L6, L7].

% systemSwitchDrive 
% Dominio: System x Letra de Drive x System
% Descripción: Cambia al drive donde se harán cambios
systemSwitchDrive(S1, Letter, S2) :-    
    S1 = [Nombre, Timestamp, L1, L2, L3, _, L5, L6, L7],
    not(isnull(L1)), % Checkear que haya un usuario logeado
    checkDrive(Letter,L3),
    append([],Letter, NewCurrentDrive), % Resetear el drive
    S2 = [Nombre, Timestamp, L1, L2, L3, NewCurrentDrive, L5, L6, L7].

% systemMkdir
% Dominio: System x String el cual es un path x System
% Descripción: Crea un directorio, debe previamente haber un usuario logeado.
systemMkdir(S1, StringPath,S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    \+ isnull(L1),
    get_first_element_string(L1, Cosa),
    (isnull(L5)
    -> FullPath = StringPath
    ; get_first_element_string(L5, SubString),
      atomic_list_concat([SubString,StringPath], '/', FullPath)
    ),
    path(Path, FullPath, Cosa, L4),
    append(L6, [Path], NewPaths),
    write('Rutas del sistema (Nuevo directorio agregado): '), write(NewPaths), nl,
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewPaths, L7].

% systemCd
% Dominio: System x String el cual es un path x System
% Descripción: Cambia a la ruta actual en la cuál se harán cambios.
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
% Dominio: System x File x System
% Descripción: Añade un archivo en la ruta en la cuál se está actualmente.
systemAddFile(S1, File, S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    append(File,L1,FileWithUser),
    append(FileWithUser,L5,FileWithPath),
    append(L6,[FileWithPath],NewPaths),
    write('Rutas del sistema (Nuevo archivo agregado): '), write(NewPaths), nl,
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewPaths, L7].

% systemDel
% Dominio: System x String el cuál es un path x System
% Descripción: Elimina un archivo o directorio, posteriormente lo mueve a la papelera.
systemDel(S1,PathToDel,S2) :- % Caso de "file.txt" - REDY
    ifFileName(PathToDel),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    fileFinder(PathToDel,L6,FileToBeRemoved),
    append(L7,[FileToBeRemoved],NewTrash),
    fileDeleter(PathToDel,L6,NewRutas),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewRutas, NewTrash].

systemDel(S1,PathToDel,S2) :- % Caso de "*.txt" - 
    ifExtension(PathToDel),
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    extGetter(PathToDel,Ext),
    unlistOneElement(Ext,Extension),
    toBeRemovedByExtension(Extension,L6,Trash),
    deleteByExtension(Extension,L6,NewRutas),
    append(L7,Trash,NewTrash),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewRutas, NewTrash].

% systemCopy
% Dominio: System x String x String x System
% Descripción: Copia un archivo o directorio a una nueva ruta.
% Files
systemCopy(S1,sourceStr,targetStr,S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    fileFinder(sourceStr,L6,FileToBeCopied),
    append(FileToBeCopied,L5,FileToBeCopiedWithPath),
    append(L6,[FileToBeCopiedWithPath],NewPaths),
    write('Rutas del sistema (Nuevo archivo copiado): '), write(NewPaths), nl,
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewPaths, L7].
% Folders
systemCopy(S1,sourceStr,targetStr,S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    fileFinder(sourceStr,L6,FolderToBeCopied),
    append(FolderToBeCopied,L5,FolderToBeCopiedWithPath),
    append(L6,[FolderToBeCopiedWithPath],NewPaths),
    write('Rutas del sistema (Nuevo directorio copiado): '), write(NewPaths), nl,
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewPaths, L7].

% systemMove
% Dominio: System x String x String x System
% Descripción: Mueve un archivo o directorio a una nueva ruta.
% Files
systemMove(S1,sourceStr,targetStr,S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    fileFinder(sourceStr,L6,FileToBeMoved),
    append(FileToBeMoved,L5,FileToBeMovedWithPath),
    append(L6,[FileToBeMovedWithPath],NewPaths),
    write('Rutas del sistema (Nuevo archivo movido): '), write(NewPaths), nl,
    fileDeleter(sourceStr,L6,NewRutas),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewRutas, L7].
% Folders
systemMove(S1,sourceStr,targetStr,S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    fileFinder(sourceStr,L6,FolderToBeMoved),
    append(FolderToBeMoved,L5,FolderToBeMovedWithPath),
    append(L6,[FolderToBeMovedWithPath],NewPaths),
    write('Rutas del sistema (Nuevo directorio movido): '), write(NewPaths), nl,
    fileDeleter(sourceStr,L6,NewRutas),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewRutas, L7].

% systemRename
% Dominio: System x String x String x System
% Descripción: Renombra un archivo o directorio.
% Files
systemRen(S1,targetName,newName,S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    fileFinder(targetName,L6,FileToBeRenamed),
    append(FileToBeRenamed,L5,FileToBeRenamedWithPath),
    append(L6,[FileToBeRenamedWithPath],NewPaths),
    write('Rutas del sistema (Nuevo archivo renombrado): '), write(NewPaths), nl,
    fileDeleter(targetName,L6,NewRutas),
    append([newName],FileToBeRenamed,NewFile),
    append(NewFile,L5,NewFileWithPath),
    append(NewRutas,[NewFileWithPath],NewRutas2),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewRutas2, L7].
% Folders
systemRen(S1,targetName,newName,S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    fileFinder(targetName,L6,FolderToBeRenamed),
    append(FolderToBeRenamed,L5,FolderToBeRenamedWithPath),
    append(L6,[FolderToBeRenamedWithPath],NewPaths),
    write('Rutas del sistema (Nuevo directorio renombrado): '), write(NewPaths), nl,
    fileDeleter(targetName,L6,NewRutas),
    append([newName],FolderToBeRenamed,NewFolder),
    append(NewFolder,L5,NewFolderWithPath),
    append(NewRutas,[NewFolderWithPath],NewRutas2),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewRutas2, L7].

% systemDir 
% Dominio: System x Params (String list) x System
% Descripción: Muestra los archivos y directorios de una ruta.
% Primero revisamos la lista de strings Params para ver que tipo de dir se quiere ejecutar
% [] para un dir de la ruta actual
% ["/s"] para un dir de la ruta actual y sus subdirectorios
% ["/a"] para un dir de la ruta actual y sus archivos ocultos -- NO REALIZADO
% ["/s","/a"] para un dir de la ruta actual y sus subdirectorios y archivos ocultos -- NO REALIZADO
% ["/o N"] para un dir de la ruta actual ordenado alfabeticamente -- NO REALIZADO
% ["/o -D"] para un dir de la ruta actual ordenado por fecha -- NO REALIZADO
% ["/o D"] para un dir de la ruta actual ordenado por tamaño -- NO REALIZADO
% ["/?"] para mostrar texto de ayuda el usuario -- NO REALIZADO

% Caso de ["/s"] 
systemDir(S1, Params, S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    get_first_element_string(L5, c-path),
    % Recorrer los Path buscando los que tengan un path que sea igual al c-path
    get_first_element_string(Params, Param),
    Param = "/s",
    fileFinder(c-path,L6,FileToBePrinted),
    write('Archivos y directorios de la ruta actual: '), write(FileToBePrinted), nl,
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7].

% Caso de []
systemDir(S1, Params, S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    isnull(Params),
    get_first_element_string(L5, c-path),
    fileFinder(c-path,L6,FileToBePrinted),
    write('Archivos y directorios de la ruta actual: '), write(FileToBePrinted), nl,
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7].

% Caso de ["/?"]
systemDir(_,Params,_) :-
    get-first_element_string(Params,Param),
    Param = "/?",
    write('Para mostrar el directorio actual = []'), nl,
    write('Para mostrar el directorio actual y sus subdirectorios = ["/s"]'), nl.

% systemFormat
% Dominio: System x Char x String x System 
% Descripción: Formatea un drive, eliminando todos los archivos y directorios. Cambia su nombre pero conserva la capacidad. 
systemFormat(S1,letter,name,S2) :-
    S1 = [Nombre, Timestamp, L1, L2, L3, L4, L5, L6, L7],
    L3 = [[letter,name,_]|_],
    delete(L3,[letter,_,Capacity],NewDrives),
    append(NewDrives,[[letter,name,Capacity]],_),
    % Ahora se borrarán los archivos que contengan la letra indicada
    L6 = [[_,letter|_]|_],
    delete(L6,[_,letter,_],NewPaths),
    S2 = [Nombre, Timestamp, L1, L2, L3, L4, L5, NewPaths, L7].

    
    


    


   

