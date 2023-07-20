:- module(tda_file_20403502_OleaDiaz, [tda_file/3]).

% TDA File
% Dominio: Nombre x Contenido x File  
% Descripción: Crea un archivo a partir de su nombre, contenido.
tda_file(Name,Content,File) :- 
    extGetter(Name,Ext),
    unlistOneElement(Ext,Extension),
    File = [Name,Content,Extension].