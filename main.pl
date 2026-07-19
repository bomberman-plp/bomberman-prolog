/*
  Ponto de entrada do jogo.
*/

:- use_module('./functions/map/map.pl').
:- use_module('./game.pl').

main :-
    main('assets/map1.txt').

main(FilePath) :-
    load_map(FilePath, GameMap, PlayerPos, _PortalPos),
    run_game(GameMap, PlayerPos).