:- module(draw, [
    draw_map/3
]).

tile_to_asset(indestructible, '█').
tile_to_asset(destructible,   '▒').
tile_to_asset(empty,          ' ').
tile_to_asset(player,         '☻').
tile_to_asset(bomb,           '●').
tile_to_asset(victory_portal, '⚑').
tile_to_asset(_,              ' ').

draw_map(GameMap, PlayerPos, BombState) :-
    findall(X, member(((X, _), _), GameMap), Xs),
    findall(Y, member(((_, Y), _), GameMap), Ys),
    max_list(Xs, MaxX),
    max_list(Ys, MaxY),
    build_rows(0, MaxY, MaxX, GameMap, PlayerPos, BombState, CharCodes),
    write('\e[H'),
    format('~s', [CharCodes]),
    flush_output.

build_rows(Y, MaxY, _, _, _, _, []) :- Y > MaxY, !.

build_rows(Y, MaxY, MaxX, GameMap, PlayerPos, BombState, Codes) :-
    build_cols(0, MaxX, Y, GameMap, PlayerPos, BombState, RowCodes),
    NextY is Y + 1,
    build_rows(NextY, MaxY, MaxX, GameMap, PlayerPos, BombState, RestCodes),
    append(RowCodes, [10 | RestCodes], Codes).

build_cols(X, MaxX, _, _, _, _, []) :-
    X > MaxX,
    !.

build_cols(X, MaxX, Y, GameMap, PlayerPos, BombState, [CharCode | Rest]) :-
    (
        BombState = exploding(Tiles, _, _),
        member((X, Y), Tiles)
    ->
        Char = '*'
    ;   BombState = bomb((X, Y), _),
        (X, Y) \= PlayerPos
    ->
        Char = '●'
    ;   member(((X, Y), Tile), GameMap)
    ->
        tile_to_asset(Tile, Char)
    ;   Char = ' '
    ),
    char_code(Char, CharCode),
    NextX is X + 1,
    build_cols(NextX, MaxX, Y, GameMap, PlayerPos, BombState, Rest).