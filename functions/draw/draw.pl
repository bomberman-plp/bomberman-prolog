:- module(draw, [
    draw_map/1
]).

/*
Este módulo é responsável por renderizar um mapa do jogo em formato de texto no terminal. 
Ele lê uma lista de coordenadas e tipos de blocos e constrói uma matriz de caracteres
*/

tile_to_asset(indestructible, '█').
tile_to_asset(destructible,   '▒').
tile_to_asset(empty,          ' ').
tile_to_asset(player,         '☻').
tile_to_asset(victory_portal, '⚑').
tile_to_asset(_,              ' ').

draw_map(GameMap) :-
    findall(X, member(((X, _), _), GameMap), Xs),
    findall(Y, member(((_, Y), _), GameMap), Ys),
    max_list(Xs, MaxX),
    max_list(Ys, MaxY),
    build_rows(0, MaxY, MaxX, GameMap, CharCodes),
    write('\e[H'),
    format('~s', [CharCodes]),
    flush_output.

build_rows(Y, MaxY, _, _, []) :- Y > MaxY, !.
build_rows(Y, MaxY, MaxX, GameMap, Codes) :-
    build_cols(0, MaxX, Y, GameMap, RowCodes),
    NextY is Y + 1,
    build_rows(NextY, MaxY, MaxX, GameMap, RestCodes),
    append(RowCodes, [10 | RestCodes], Codes). % 10 é o ASCII para nova linha (\n)

build_cols(X, MaxX, _, _, []) :- X > MaxX, !.
build_cols(X, MaxX, Y, GameMap, [CharCode | Rest]) :-
    (   member(((X, Y), Tile), GameMap)
    ->  tile_to_asset(Tile, Char)
    ;   Char = ' '
    ),
    char_code(Char, CharCode),
    NextX is X + 1,
    build_cols(NextX, MaxX, Y, GameMap, Rest).