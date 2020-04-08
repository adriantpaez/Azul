:-["strategy.pl"]

PlayerRound([W, PL, F, Points], Factories, Bag, Cover, Table, TableR, CoverR, BagR, FactoriesR, [WR, PLR, FR, PointsR], EOG):-
    randomStrategy(PL, W, Factories, Table, TableR, Cover, CoverT, Floor, FloorR, PLT)
    fromPLToWall(PLT, PLR, W, WR, CoverT, CoverR, FloorR, Points, PointsR),
    checkEOG(WR, EOG).

Round([P1, P2, P3, P4], Factories, Bag, Cover, Table, TableR, CoverR, BagR, FactoriesR, [PR1, PR2, PR3, PR4], EOG):-
    PlayerRound(P1, Factories, Bag, Cover, Table, TableT1, CoverT1, BagT1, FactoriesT1, PR1, EOG),
    not EOG,
    !,
    PlayerRound(P2, FactoriesT1, BagT1, CoverT1, TableT1, TableT2, CoverT2, BagT2, FactoriesT2, PR2, EOG),
    not EOG,
    !,
    PlayerRound(P3, FactoriesT2, BagT2, CoverT2, TableT2, TableT3, CoverT3, BagT3, FactoriesT4, PR3, EOG),
    not EOG,
    !,
    PlayerRound(P4, FactoriesT3, BagT3, CoverT3, TableT3, TableR, CoverR, BagR, FactoriesR, PR4, EOG).

Play(Players, Factories, Bag, Cover, Table, Players, true):-!.

Play(Players, Factories, Bag, Cover, Table, PlayersR, false):-
    Round(Players, Factories, Bag, Cover, Table, TableT, CoverT, BagT, FactoriesT, PlayersT, EOG),
    nextRound(FactoriesT,BagT,CoverT,FactoriesR,BagR,CoverR),
    Play(PlayersT, FactoriesR, BagR, CoverR, TableR, PlayersR, EOG).

:-  newPlayers(Players),
    initializeGame(Players, Factories, Bag, Cover, Table),
    Play(Players, Factories, Bag, Cover, Table, PlayersR, EOG).
