:- module(map_loader, [
    load_map/4,
    asset_to_tile/2
]).

/*
  Módulo responsável pelo mapa e pelo mapeamento de tiles para os
  diferentes tipos de blocos.
*/

asset_to_tile('#', indestructible) :- !.
asset_to_tile('x', destructible) :- !.
asset_to_tile('.', empty) :- !.
asset_to_tile('1', player) :- !.
asset_to_tile('2', victory_portal) :- !.
asset_to_tile('b', bomb) :- !.
asset_to_tile(_, empty).

% Faz o carregamento do mapa a partir de um arquivo. retorna o mapa, a posicao do player e a posicao do portal

load_map(FilePath, GameMap, PlayerPos, PortalPos) :-
    setup_call_cleanup(
        open(FilePath, read, Stream),
        read_lines(Stream, Lines),
        close(Stream)
    ),
    process_lines(Lines, 0, GameMap),
    (   member(((PX, PY), player), GameMap)
    ->  PlayerPos = (PX, PY)
    ;   PlayerPos = none
    ),
    (   member(((TX, TY), victory_portal), GameMap)
    ->  PortalPos = (TX, TY)
    ;   PortalPos = none
    ).

% Faz a leitura das linhas do arquivo. No predicado seguinte, processa as linhas convertendo-as em tiles

read_lines(Stream, Lines) :-
    read_line_to_string(Stream, LineString),
    (   LineString == end_of_file
    ->  Lines = []
    ;   string_chars(LineString, Chars),
        Lines = [Chars|Rest],
        read_lines(Stream, Rest)
    ).

process_lines([], _, []).
process_lines([Row|Rows], Y, Map) :-
    process_row(Row, 0, Y, RowMap),
    NextY is Y + 1,
    process_lines(Rows, NextY, RestMap),
    append(RowMap, RestMap, Map).

process_row([], _, _, []).
process_row([Char|Chars], X, Y, [((X, Y), Tile)|Rest]) :-
    asset_to_tile(Char, Tile),
    NextX is X + 1,
    process_row(Chars, NextX, Y, Rest).