:-["strategy.pl"].
:-["strategy2.pl"].
:-["print.pl"].


playerPlay([W, PL, _, Points], Factories, Table, TableR, Cover, CoverR, [WR, PLR, FR, PointsR], Mask, MaskR, Initial):-
    floorVector(F),
    %randomStrategy(PL, W, Factories, Table, TableR, Cover, CoverT, F, FR,PLT, Mask, MaskR, Initial),
    strategy(PL, W, Factories, Table, TableR, Cover, CoverT, F, FR,PLT, Mask, MaskR, Initial),
    fromPLToWall(PLT, PLR, W, WR, CoverT, CoverR, FR, Points, PointsR).


round(_, _, _, _, _, _, _, _, _, _, _,true, true) :-
    write('El juego ha terminado \n'),
    !.


round([], _, Mask, Cover, Table, Mask, Cover, Table, [], CurrentInitial, CurrentInitial, EOGNow, EOGNow) :-
    write("End Round\n"),
    get_single_char(_).


round([Player|RPlayers], Factories, Mask, Cover, Table, MaskR, CoverR, TableR, [PlayerR|RPlayersR], CurrentInitial, NewInitial, false, EOG) :-
    playerPlay(Player, Factories,Table, TableTemp, Cover, CoverTemp, [WR, PLR, FR, PointsR], Mask, MaskTemp, IsInitial),
    length(RPlayers,Length),
    Current is 3 - Length,
    printNewLine(),
    checkInitial(CurrentInitial, Current, IsInitial, NewInitialTemp, Penalize),
    penalizeInitial([WR, PLR, FR, PointsR], Penalize, PlayerR),
    printplayerResult(PlayerR, Factories, MaskTemp),
    printInitial(IsInitial),
    printCover(CoverTemp),
    printTable(TableTemp),
    checkEOG(WR, EOGNow),
    get_single_char(_),
    round(RPlayers, Factories, MaskTemp, CoverTemp, TableTemp, MaskR, CoverR, TableR, RPlayersR, NewInitialTemp, NewInitial, EOGNow, EOG),
    !.


round(Players, Factories, Mask, Cover, Table, MaskR, CoverR, TableR, PlayersR, NewInitial, EOG) :-
    round(Players, Factories, Mask, Cover, Table, MaskR, CoverR, TableR, PlayersR, -1, NewInitial, false, EOG).


checkInitial(-1,Current,true,Current, true) :- !.
checkInitial(Old,_,_,Old, false) :- !.


penalizeInitial(P, false, P).
penalizeInitial([W, PL, F, Points], true, [W, PL, FR, PointsR]):-
    fullFloor(F, false),
    pushFloor(F, [initial, 1], FR, _ ,_),
    floorLastSpace(FR, PointsF),
    PointsR is Points+PointsF.

penalizeInitial(P,_,P).
    
play(Players, Factories, Bag, Cover, Table, Mask):-
    printBag(Bag),
    printFactories(Factories,[0,1,2,3,4,5,6,7,8]),
    round(Players, Factories, Mask, Cover, Table, MaskT, CoverT, TableR, PlayersT, Initial, EOG),
    fixInitial(Initial,NewInitial),
    check(EOG),
    removeEmptyFactories(Factories, MaskT,FactoriesT),
    nextRound(FactoriesT,Bag,CoverT,FactoriesR,BagR,CoverR),
    calculateMaskFactories(FactoriesR, MaskR),
    changeOrder(PlayersT, NewInitial, PlayersR),
    play(PlayersR, FactoriesR, BagR, CoverR, TableR, MaskR).


check(false).

fixInitial(-1,0) :- !.
fixInitial(X,X).

changeOrder(Players, 0, Players).
changeOrder([P1,P2,P3,P4], 1, [P2,P3,P4,P1]).
changeOrder([P1,P2,P3,P4], 2, [P3,P4, P1,P2]).
changeOrder([P1,P2,P3,P4], 3, [P4, P1, P2, P3]).


game():-    newPlayers(Players),
            initializeGame(Factories, Bag, Cover, Table),
            printBag(Bag),
            printCover(Cover),
            printTable(Table),
            printFactories(Factories,[0,1,2,3,4,5,6,7,8]),
            printNewLine(),
            play(Players, Factories, Bag, Cover, Table, [0,1,2,3,4,5,6,7,8]).

game().
