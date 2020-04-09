:-["strategy.pl"].
:-["print.pl"].

playerround([W, PL, _, Points], Factories, Cover, Table, TableR, CoverR, [WR, PLR, FT, PointsR],Mask, MaskR, EOG):-
    floorVector(F),
    randomStrategy(PL, W, Factories, Table, TableR, Cover, CoverT,F, FT, PLT, Mask, MaskR),
    % Aquí me quede
    fromPLToWall(PLT, PLR, W, WR, CoverT, CoverR, FT, Points, PointsR),
    checkEOG(WR, EOG).

round([P1, P2, P3, P4], Factories, Cover, Table, TableR, CoverR, [PR1, PR2, PR3, PR4], Mask,MaskR,EOG):-
    playerround(P1, Factories, Cover, Table, TableT1, CoverT1, PR1, Mask, MaskT1,EOG),
    printplayerResult(P1, Factories,MaskT1),
    not(EOG),
    !,
    playerround(P2, Factories, CoverT1, TableT1, TableT2, CoverT2, PR2,MaskT1, MaskT2, EOG),
    printplayerResult(P2, Factories,MaskT2),
    not(EOG),
    !,
    playerround(P3, Factories, CoverT2, TableT2, TableT3, CoverT3, PR3, MaskT2, MaskT3, EOG),
    printplayerResult(P3, Factories,MaskT3),
    not(EOG),
    !,
    playerround(P4, Factories, CoverT3, TableT3, TableR, CoverR, PR4, MaskT3, MaskR, EOG),
    printplayerResult(P4, Factories,MaskR).

play(_, _, _, _, _, _,true):-!.

play(Players, Factories, Bag, Cover, Table, Mask, false):-
    round(Players, Factories, Cover, Table, TableR, CoverT, PlayersT, Mask, MaskR, EOG),
    removeEmptyFactories(Factories, MaskR,FactoriesT),
    nextRound(FactoriesT,Bag,CoverT,FactoriesR,BagR,CoverR),
    calculateMaskFactories(FactoriesR, MaskR),
    play(PlayersT, FactoriesR, BagR, CoverR, TableR, MaskR, EOG).

game():-    newPlayers(Players),
            initializeGame(Factories, Bag, Cover, Table),
            play(Players, Factories, Bag, Cover, Table, [0,1,2,3,4,5,6,7,8],false).
