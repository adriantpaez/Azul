:-["strategy.pl"].
:-["print.pl"].

playerPlay([W, PL, _, Points], Factories, Table, TableR, Cover, CoverR, [WR, PLR, FR, PointsR], Mask, MaskR):-
    floorVector(F),
    randomStrategy(PL, W, Factories, Table, TableR, Cover, CoverT, F, FR,PLT, Mask, MaskR),
    fromPLToWall(PLT, PLR, W, WR, CoverT, CoverR, FR, Points, PointsR).

playerRound([W, PL, _, Points], Factories, Cover, Table, TableR, CoverR, [WR, PLR, FR, PointsR],Mask, MaskR):-
    playerPlay([W, PL, _, Points], Factories, Table, TableR, Cover, CoverR, [WR, PLR, FR, PointsR], Mask, MaskR),
    not(check(MaskR, TableR, W)).

check(_, _,W):-
    checkEOG(W, true).

check([],_, _).

check(_,[[azul,0], [amarillo, 0], [rojo,0], [negro,0], [blanco,0]],_).

round([P1, P2, P3, P4], Factories, Cover, Table, TableR, CoverR, [PR1, PR2, PR3, PR4], Mask,MaskR):-
    playerRound(P1, Factories, Cover, Table, TableT1, CoverT1, PR1, Mask, MaskT1),
    printplayerResult(PR1, Factories,MaskT1),
    write("Cover: "),
    printCover(CoverT1),
    printNewLine(),
    write("Table: "),
    printCover(TableT1),
    printNewLine(),
    get_single_char(32),
    playerRound(P2, Factories, CoverT1, TableT1, TableT2, CoverT2, PR2,MaskT1, MaskT2),
    printplayerResult(PR2, Factories,MaskT2),
    write("Cover: "),
    printCover(CoverT2),
    printNewLine(),
    write("Table: "),
    printCover(TableT2),
    printNewLine(),
    get_single_char(32),
    playerRound(P3, Factories, CoverT2, TableT2, TableT3, CoverT3, PR3, MaskT2, MaskT3),
    printplayerResult(PR3, Factories,MaskT3),
    write("Cover: "),
    printCover(CoverT3),
    printNewLine(),
    write("Table: "),
    printCover(TableT3),
    printNewLine(),
    get_single_char(32),
    playerRound(P4, Factories, CoverT3, TableT3, TableR, CoverR, PR4, MaskT3, MaskR),
    printplayerResult(PR4, Factories,MaskR),
    write("Cover: "),
    printCover(CoverR),
    printNewLine(),
    write("Table: "),
    printCover(TableR),
    printNewLine(),
    get_single_char(32).


play(Players, Factories, Bag, Cover, Table, Mask):-
    write("Bag: "),
    printBag(Bag),
    printNewLine(),
    round(Players, Factories, Cover, Table, TableR, CoverT, PlayersT, Mask, MaskT),
    removeEmptyFactories(Factories, MaskT,FactoriesT),
    nextRound(FactoriesT,Bag,CoverT,FactoriesR,BagR,CoverR),
    calculateMaskFactories(FactoriesR, MaskR),
    write("End Round\n"),
    get_single_char(32),
    play(PlayersT, FactoriesR, BagR, CoverR, TableR, MaskR).

play(_,_,_,_,_,_):-
    write('El juego ha terminado \n').

game():-    newPlayers(Players),
            initializeGame(Factories, Bag, Cover, Table),
            write("Bag: "),
            printBag(Bag),
            printNewLine(),
            write("Cover: "),
            printCover(Cover),
            printNewLine(),
            write("Table: "),
            printCover(Table),
            printNewLine(),
            printFactories(Factories,[0,1,2,3,4,5,6,7,8]),
            printNewLine(),
            play(Players, Factories, Bag, Cover, Table, [0,1,2,3,4,5,6,7,8]).
