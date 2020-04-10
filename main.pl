:-["strategy.pl"].
:-["print.pl"].

playerPlay([W, PL, _, Points], Factories, Table, TableR, Cover, CoverR, [WR, PLR, FR, PointsR], Mask, MaskR, Initial):-
    floorVector(F),
    randomStrategy(PL, W, Factories, Table, TableR, Cover, CoverT, F, FR,PLT, Mask, MaskR, Initial),
    fromPLToWall(PLT, PLR, W, WR, CoverT, CoverR, FR, Points, PointsR).

playerRound([W, PL, _, Points], Factories, Cover, Table, TableR, CoverR, [WR, PLR, FR, PointsR],Mask, MaskR, Initial):-
    playerPlay([W, PL, _, Points], Factories, Table, TableR, Cover, CoverR, [WR, PLR, FR, PointsR], Mask, MaskR, Initial),
    not(check(MaskR, TableR, W)).

check(_, _,W):-
    checkEOG(W, true).

check([],[[azul,0], [amarillo, 0], [rojo,0], [negro,0], [blanco,0]], _).

round([P1, P2, P3, P4], Factories, Cover, Table, TableR, CoverR, [PR1, PR2, PR3, PR4], Mask,MaskR, Initial):-
    playerRound(P1, Factories, Cover, Table, TableT1, CoverT1, PT1, Mask, MaskT1, Initial1),
    penalizeInitial(PT1, Initial1, PR1, false),
    printplayerResult(PR1, Factories,MaskT1),
    printInitial(true),
    write("Cover: "),
    printCover(CoverT1),
    printNewLine(),
    write("Table: "),
    printCover(TableT1),
    printNewLine(),
    get_single_char(32),
    playerRound(P2, Factories, CoverT1, TableT1, TableT2, CoverT2, PT2,MaskT1, MaskT2, Initial2),
    penalizeInitial(PT2, Initial2, PR2, Initial1),
    printplayerResult(PR2, Factories,MaskT2),
    printInitial(Initial2),
    write("Cover: "),
    printCover(CoverT2),
    printNewLine(),
    write("Table: "),
    printCover(TableT2),
    printNewLine(),
    get_single_char(32),
    playerRound(P3, Factories, CoverT2, TableT2, TableT3, CoverT3, PT3, MaskT2, MaskT3, Initial3),
    or([Initial1, Initial2], Taken)
    penalizeInitial(PT3, Initial3, PR3, Taken),
    printplayerResult(PR3, Factories,MaskT3),
    printInitial(Initial3),
    write("Cover: "),
    printCover(CoverT3),
    printNewLine(),
    write("Table: "),
    printCover(TableT3),
    printNewLine(),
    get_single_char(32),
    playerRound(P4, Factories, CoverT3, TableT3, TableR, CoverR, PT4, MaskT3, MaskR, Initial4),
    or([Initial1, Initial2, Initial3], Taken)
    penalizeInitial(PT4, Initial4, PR4, Taken),
    printplayerResult(PR4, Factories,MaskR),
    printInitial(Initial4),
    write("Cover: "),
    printCover(CoverR),
    printNewLine(),
    write("Table: "),
    printCover(TableR),
    printNewLine(),
    get_single_char(32),
    checkInitial(Initial1, Initial2, Initial3, Initial4, Initial).

checkInitial(false, false, false, false, 0).
checkInitial(true, _,_,_, 0).
checkInitial(_, true, _,_, 1).
checkInitial(_,_,true,_, 2).
checkInitial(_,_,_,true, 3).

penalizeInitial(P, false, P, _).
penalizeInitial(P, true, P, true).
penalizeInitial([W, PL, F, Points], true, [W, PL, FR, PointsR], false):-
    fullFloor(F, false),
    pushFloor(F, [initial, 1], FR, _ ,_),
    floorLastSpace(FR, PointsF),
    PointsR is Points+PointsF.

penalizeInitial(P,_,P,_).
    
play(Players, Factories, Bag, Cover, Table, Mask):-
    printBag(Bag),
    printFactories(Factories,[0,1,2,3,4,5,6,7,8]),
    round(Players, Factories, Cover, Table, TableR, CoverT, PlayersT, Mask, MaskT, Initial),
    removeEmptyFactories(Factories, MaskT,FactoriesT),
    nextRound(FactoriesT,Bag,CoverT,FactoriesR,BagR,CoverR),
     calculateMaskFactories(FactoriesR, MaskR),
    write("End Round\n"),
    get_single_char(32),
    changeOrder(PlayersT, Initial, PlayersR),
    play(PlayersR, FactoriesR, BagR, CoverR, TableR, MaskR).

play(_,_,_,_,_,_):-
    write('El juego ha terminado \n').

changeOrder(Players, 0, Players).
changeOrder([P1,P2,P3,P4], 1, [P2,P3,P4,P1]).
changeOrder([P1,P2,P3,P4], 2, [P3,P4, P1,P2]).
changeOrder([P1,P2,P3,P4], 3, [P4, P1, P2, P3]).


game():-    newPlayers(Players),
            initializeGame(Factories, Bag, Cover, Table),
            printBag(Bag),
            write("Cover: "),
            printCover(Cover),
            printNewLine(),
            write("Table: "),
            printCover(Table),
            printNewLine(),
            printFactories(Factories,[0,1,2,3,4,5,6,7,8]),
            printNewLine(),
            play(Players, Factories, Bag, Cover, Table, [0,1,2,3,4,5,6,7,8]).
