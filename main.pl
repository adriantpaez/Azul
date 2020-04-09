:-["strategy.pl"].
:-["print.pl"].

playerround([W, PL, _, Points], Factories, Bag, Cover, Table, TableR, CoverR, BagR, [WR, PLR, FT, PointsR],Mask, MaskR, EOG):-
    floorVector(F),
    randomStrategy(PL, W, Factories, Table, TableR, Cover, CoverT,F, FT, PLT, Mask, MaskR),
    % Aquí me quede
    fromPLToWall(PLT, PLR, W, WR, CoverT, CoverR, FT, Points, PointsR),
    checkEOG(WR, EOG).

round([P1, P2, P3, P4], Factories, Bag, Cover, Table, TableR, CoverR, BagR, FactoriesR, [PR1, PR2, PR3, PR4], Mask,MaskR,EOG):-
    playerround(P1, Factories, Bag, Cover, Table, TableT1, CoverT1, BagT1, PR1, Mask, MaskT1,EOG),
    printplayerResult(P1, Factories),
    not(EOG),
    !,
    playerround(P2, Factories, BagT1, CoverT1, TableT1, TableT2, CoverT2, BagT2, PR2,MaskT1, MaskT2, EOG),
    printplayerResult(P2, Factories),
    not(EOG),
    !,
    playerround(P3, Factories, BagT2, CoverT2, TableT2, TableT3, CoverT3, BagT3, PR3, MaskT2, MaskT3, EOG),
    printplayerResult(P3, Factories),
    not(EOG),
    !,
    playerround(P4, Factories, BagT3, CoverT3, TableT3, TableR, CoverR, BagR, PR4, MaskT3, MaskR, EOG),
    printplayerResult(P4, Factories).

play(Players, Factories, Bag, Cover, Table, _,true):-!.

play(Players, Factories, Bag, Cover, Table, Mask, false):-
    round(Players, Factories, Bag, Cover, Table, TableT, CoverT, BagT, FactoriesT, PlayersT, Mask, MaskR, EOG),
    removeEmptyFactories(FactoriesT, MaskR, 0,FactoriesT1),
    nextRound(FactoriesT1,BagT,CoverT,FactoriesR,BagR,CoverR),
    calculateMaskFactories(FactoriesR, 0,MaskR),
    play(PlayersT, FactoriesR, BagR, CoverR, TableR, MaskR, EOG).

printplayerResult([W, PL, FL, _], Factories, FactoryMask):-
    printFactories(Factories, Mask),
    printBoard(W, PL, FL),
    printNewLine().




game():-    newPlayers(Players),
            initializeGame(Factories, Bag, Cover, Table),
            play(Players, Factories, Bag, Cover, Table, [0,1,2,3,4,5,6,7,8],false).
