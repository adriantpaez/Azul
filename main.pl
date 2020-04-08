:-["strategy.pl"].
:-["print.pl"].

playerround([W, PL, _, Points], Factories, Bag, Cover, Table, TableR, CoverR, BagR, FactoriesR, [WR, PLR, FT, PointsR], EOG):-
    floorVector(F),
    randomStrategy(PL, W, Factories, Table, TableR, Cover, CoverT,F, FT, PLT),
    fromPLToWall(PLT, PLR, W, WR, CoverT, CoverR, FT, Points, PointsR),
    checkEOG(WR, EOG).

round([P1, P2, P3, P4], Factories, Bag, Cover, Table, TableR, CoverR, BagR, FactoriesR, [PR1, PR2, PR3, PR4], EOG):-
    playerround(P1, Factories, Bag, Cover, Table, TableT1, CoverT1, BagT1, FactoriesT1, PR1, EOG),
    printplayerResult(P1, Factories),
    not(EOG),
    !,
    playerround(P2, FactoriesT1, BagT1, CoverT1, TableT1, TableT2, CoverT2, BagT2, FactoriesT2, PR2, EOG),
    printplayerResult(P2, Factories),
    not(EOG),
    !,
    playerround(P3, FactoriesT2, BagT2, CoverT2, TableT2, TableT3, CoverT3, BagT3, FactoriesT4, PR3, EOG),
    printplayerResult(P3, Factories),
    not(EOG),
    !,
    playerround(P4, FactoriesT3, BagT3, CoverT3, TableT3, TableR, CoverR, BagR, FactoriesR, PR4, EOG),
    printplayerResult(P4, Factories).

play(Players, Factories, Bag, Cover, Table, Players, true):-!.

play(Players, Factories, Bag, Cover, Table, PlayersR, false):-
    round(Players, Factories, Bag, Cover, Table, TableT, CoverT, BagT, FactoriesT, PlayersT, EOG),
    nextround(FactoriesT,BagT,CoverT,FactoriesR,BagR,CoverR),
    play(PlayersT, FactoriesR, BagR, CoverR, TableR, PlayersR, EOG).

printplayerResult([PL, W, FL, _], Factories):-
    printFactories(Factories),
    printBoard(PL, W, FL),
    printNewLine().


game():-    newPlayers(Players),
            initializeGame(Players, Factories, Bag, Cover, Table),
            play(Players, Factories, Bag, Cover, Table, PlayersR, EOG).
