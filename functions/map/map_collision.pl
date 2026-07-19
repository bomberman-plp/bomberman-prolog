:- module(map_collision, [
    is_empty/2,
    is_destructible/2,
    is_indestructible/2
]).

/*
  Módulo responsável pela verificacao das colisoes do mapa
*/

:- use_module(map_manager).

is_empty(Coord, GameMap) :-
    get_tile(Coord, GameMap, empty).

is_destructible(Coord, GameMap) :-
    get_tile(Coord, GameMap, destructible).

is_indestructible(Coord, GameMap) :-
    get_tile(Coord, GameMap, indestructible).