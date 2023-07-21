<<<<<<< HEAD
:- module(tda_file_20403502_OleaDiaz, [file/3]).
=======
:- module(tda_file_20403502_OleaDiaz, [tda_file/3]).
>>>>>>> main

% TDA File
% Dominio: Nombre x Contenido x File  
% Descripción: Crea un archivo a partir de su nombre, contenido.
<<<<<<< HEAD
file(Name,Content,File) :- 
=======
tda_file(Name,Content,File) :- 
>>>>>>> main
    extGetter(Name,Ext),
    unlistOneElement(Ext,Extension),
    File = [Name,Content,Extension].