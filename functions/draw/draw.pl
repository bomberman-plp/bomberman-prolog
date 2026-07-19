:- module(draw, [
    draw_map/1
]).

/*
  Desenho do mapa no terminal.
*/

tile_to_asset(indestructible, '█').
tile_to_asset(destructible,   '▒').
tile_to_asset(empty,          ' ').
tile_to_asset(player,         '☻').
tile_to_asset(victory_portal, '⚑').
tile_to_asset(_,              ' ').

draw_map(GameMap) :-
    write('\e[H\e[2J'),
    
    findall(X, member(((X, _), _), GameMap), Xs),
    findall(Y, member(((_, Y), _), GameMap), Ys),
    max_list(Xs, MaxX),
    max_list(Ys, MaxY),
    
    draw_rows(0, MaxY, MaxX, GameMap).

draw_rows(Y, MaxY, _, _) :- Y > MaxY, !.
draw_rows(Y, MaxY, MaxX, GameMap) :-
    draw_cols(0, MaxX, Y, GameMap),
    nl,
    NextY is Y + 1,
    draw_rows(NextY, MaxY, MaxX, GameMap).

draw_cols(X, MaxX, _, _) :- X > MaxX, !.
draw_cols(X, MaxX, Y, GameMap) :-
    (   member(((X, Y), Tile), GameMap)
    ->  tile_to_asset(Tile, Char)
    ;   Char = ' '
    ),
    write(Char),
    NextX is X + 1,
    draw_cols(NextX, MaxX, Y, GameMap).