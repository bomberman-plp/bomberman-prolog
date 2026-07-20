/*
  Ponto de entrada do jogo.
*/

:- use_module('./functions/map/map.pl').
:- use_module('./game.pl').

main :-
    main('assets/map1.txt').

main(FilePath) :-
    % \e[2J (limpa tudo) + \e[H (vai pro topo) + \e[?25l (esconde o cursor do terminal)
    write('\e[2J\e[H\e[?25l'), 
    flush_output,
    load_map(FilePath, GameMap, PlayerPos, _PortalPos),
    run_game(GameMap, PlayerPos, none).