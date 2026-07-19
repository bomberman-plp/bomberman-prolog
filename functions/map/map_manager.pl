:- module(map_manager, [
    get_tile/3,
    set_tile/4,
    move_player/5
]).

/*
  Módulo responsável pelo gerenciamento do mapa, permitindo sua manipulacao.
  Faz a leitura e alteração de tiles e fornece meios para mover o player
*/

get_tile(Coord, GameMap, Tile) :-
    member((Coord, FoundTile), GameMap),
    !,
    Tile = FoundTile.

get_tile(_, _, indestructible).

set_tile(Coord, Tile, OldMap, NewMap) :-
    select((Coord, _), OldMap, (Coord, Tile), NewMap),
    !.
set_tile(Coord, Tile, OldMap, [(Coord, Tile)|OldMap]).

move_player(_From, To, OldMap, OldMap, invalid_move) :-
    get_tile(To, OldMap, TileTo),
    TileTo \= empty,
    TileTo \= victory_portal,
    !.

move_player(From, _To, OldMap, OldMap, invalid_move) :-
    \+ get_tile(From, OldMap, player),
    !.

move_player(From, To, OldMap, NewMap, victory) :-
    get_tile(From, OldMap, player),
    get_tile(To, OldMap, victory_portal),
    !,
    set_tile(From, empty, OldMap, TempMap),
    set_tile(To, player, TempMap, NewMap).

move_player(From, To, OldMap, NewMap, success) :-
    get_tile(From, OldMap, player),
    get_tile(To, OldMap, empty),
    set_tile(From, empty, OldMap, TempMap),
    set_tile(To, player, TempMap, NewMap).