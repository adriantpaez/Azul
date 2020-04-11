
:- ["utils.pl"].

getIndex(azul,0).
getIndex(amarillo,1).
getIndex(rojo,2).
getIndex(negro,3).
getIndex(blanco,4).
getIndex(initial,5).

% ==========
% COLORTUPLE
% ==========

%  colorTuple(Color,Count,CT)
% Inicializa un ColorTuple en CT con Color y Count
% 
colorTuple(Color,Count,[Color,Count]).

% insertTile(ColorTuple,Count,ColorTupleResult)
% Incrementa el contador de ColorTuple en Count
insertTile([Color,ColorCount], Count, [Color,CountResult]) :- 
    CountResult is ColorCount + Count.

% ===========
% COLORVECTOR
% ===========

% colorVector(CV)
% Inicializa un ColorVector en CV
% 
colorVector([[azul,0],[amarillo,0],[rojo,0],[negro,0],[blanco,0]]).

% colorVectorTileCount(CV,Count)
% Count es la cantidad de azulejos que hay en CV
colorVectorTileCount([[_,Count]],Count) :- !.

colorVectorTileCount([[_,Count]|FactoryR],TotalCount) :-
    colorVectorTileCount(FactoryR,CountR),
    TotalCount is Count + CountR.

% pushNColorVector(ColorVector,Color,N,ColorVectorResult)
% Aumenta en N la cantidad de Color en ColorVector, dando como resultado ColorVectorResult
% 
pushNColorVector([[Color,Count]|ColorVector],Color,N,[[Color,NewCount]|ColorVector]) :- 
    NewCount is Count + N, !.

pushNColorVector([[OtherColor,Count]|ColorVector],Color,N,[[OtherColor,Count]|ColorVectorResult]) :- 
    pushNColorVector(ColorVector,Color,N,ColorVectorResult).

% mergeColorVector(CVA,CVB,CVR)
% CVR es el resultado de mezclar los ColorVector CVA,CVB, uniendo sus azulejos
%
mergeColorVector([],[],[]) :- !.

mergeColorVector([[Color,CountA]|RA],[[Color,CountB]|RB],[[Color,Count]|R]) :-
    Count is CountA + CountB,
    mergeColorVector(RA,RB,R).

% popColor(ColorVector,Color,ColorVectorResult,Count)
% Remueve todos los azulejos de color Color de ColorVector. Devolviendo en ColorVectorResult
% el vector resultante y en Count la cantidad removida.
% 
popColor([],_,[],_) :- !.
popColor([[Color,Count]|ColorVector],Color,[[Color,0]|ColorVectorTemp],Count) :-
    popColor(ColorVector,Color,ColorVectorTemp,_), !.
popColor([[OtherColor,OtherCount]|ColorVector],Color,[[OtherColor,OtherCount]|ColorVectorTemp],Count) :-
    popColor(ColorVector,Color,ColorVectorTemp,Count).

% =====
% FLOOR
% =====

floorVector([[false,-1], [false,-1], [false,-2], [false,-2], [false,-2], [false,-3], [false,-3]]).

% floorPoint(FloorVector,Points).
% Calcular los puntos negativos del piso
% 
floorPoint([],0) :- !.

floorPoint([[false,_]|R],Points) :-
    floorPoint(R,Points), !.

floorPoint([[_,Value]|R],Points) :-
    floorPoint(R,RPoints),
    Points is RPoints + Value.

floorLastSpace([[true, Points]|_], Points).

floorLastSpace([[false, _]|R], Points):-
    floorLastSpace(R, Points).

fullFloor([[false, _]|_], false).
fullFloor([], true).
fullFloor([[true,_]|Floor], Result):-
    fullFloor(Floor, Result).

%pushFloor(F, N, FR)
%Coloca N azulejos en F y el resultado lo devuelve en FR
%

pushFloor(R, [_,0], R, Cover, Cover):-!.

pushFloor(R, [_, Count],R, Cover, Cover):- 
    max(0, Count, 0),
    !.

pushFloor([], [Color, N], [], Cover, CoverResult) :- 
    pushNCover(Cover, Color, N, CoverResult).

pushFloor([[false, Points]|Rest], [Color, N], [[Color, Points]|ResultRest], Cover, CoverResult) :-   
    NewN is N-1, 
    pushFloor(Rest, [Color, NewN], ResultRest, Cover, CoverResult),
    !.

pushFloor([[_, Points]|Rest], ColorTuple, [[_, Points]|ResultRest], Cover, CoverResult) :- 
    pushFloor(Rest, ColorTuple, ResultRest, Cover, CoverResult).


% ====
% WALL
% ====
newWall(Wall):-
    newWallN(Wall, 0).

newWallN(_, 26):-!.

newWallN([0|WallR], N):-
    NewN is N+1,
    newWallN(WallR, NewN).


%chequea si el juego ha llegado a su fin verificando si hay una linea horizontal entera de 1s.

checkRow(Wall, 5, false, Wall, 0) :- !.

checkRow(Wall, 5, true, Wall, 1) :- !.

checkRow([0|R], Count, _,WallResult, Result) :-
    NewCount is Count + 1,
    checkRow(R, NewCount, false, WallResult, Result).

checkRow([1|R], Count, false,WallResult, Result) :-
    NewCount is Count + 1,
    checkRow(R, NewCount, false, WallResult, Result).

checkRow([1|R], Count, true,WallResult, Result) :-
    NewCount is Count + 1,
    checkRow(R, NewCount, true, WallResult, Result).

wallCountHorizontal(Wall, Count) :-
    checkRow(Wall,0,true,Wall1,C1),
    checkRow(Wall1,0,true,Wall2,C2),
    checkRow(Wall2,0,true,Wall3,C3),
    checkRow(Wall3,0,true,Wall4,C4),
    checkRow(Wall4,0,true,_,C5),
    Count is C1 + C2 + C3 + C4 + C5,
    !.

myAnd(true, true, true) :- !.

myAnd(_,_, false).

countTrue([],0) :- !.

countTrue([false|R],Count) :-
    countTrue(R, Count).

countTrue([true|R],Count) :-
    countTrue(R, TempCount),
    Count is TempCount + 1.

countColumns(_,5,[RA,RB,RC,RD,RE],Count) :-
    countTrue([RA,RB,RC,RD,RE],Count).

countColumns([A,B,C,D,E|R], Index, [LA,LB,LC,LD,LE], Count) :-
    myAnd(A,LA,RA),
    myAnd(B,LB,RB),
    myAnd(C,LC,RC),
    myAnd(D,LD,RD),
    myAnd(E,LE,RE),
    NewIndex is Index + 1,
    countColumns(R, NewIndex, [RA,RB,RC,RD,RE], Count).

countColumns(Wall,Count) :-
    countColumns(Wall,0,[true,true,true,true,true],Count).

checkEOG(W, R):-
    checkEndOfGame(W, R, 0).

checkEndOfGame(_, false, 25):-!.

checkEndOfGame([1|_], true, Count):-
    4 is mod(Count, 5),
    !.

checkEndOfGame([1|Wall], Result, Count):-
    NewCount is Count+1,
    checkEndOfGame(Wall, Result, NewCount),
    !.


checkEndOfGame([0|Wall], Result, Count):-
    NewCount is ((Count//5)+1)*5,
    ToWalk is NewCount-Count-1,
    walkNPositions(Wall, WallT, ToWalk),
    checkEndOfGame(WallT, Result, NewCount).

walkNPositions(Wall, Wall, 0):-!.

walkNPositions([_|Wall], WallR, N):-
    NewN is N-1,
    walkNPositions(Wall, WallR, NewN).







% rowPoints(W,I,TL,P)
% Devuelve en P los puntos que se ganan en fila por jugar en la posición I de W con TL como tope de izquierdo de la fila
rowPoints(W,I,TL,P) :- 
    TR is TL+4, 
    countCountinous(W,I,-1,TL,PL), 
    countCountinous(W,I,1,TR,PR), 
    P is PL + PR - 1.

% columnPoints(W,I,TU,P)
% Devuelve en P los puntos que se ganan en columna por jugar en la posición I de W con TU como tope superior de la columna
columnPoints(W,I,TU,P) :-  
    TD is TU+20, 
    countCountinous(W,I,-5,TU,PU), 
    countCountinous(W,I,5,TD,PD), 
    P is PU + PD - 1.

% wallPoints(W,I,P)
% Deveuelve en P los puntos por jugar en la posición I de W

wallPoints(W,I,0) :-
    getByIndex(W,I,0).

wallPoints(W,I,1) :-
    TU is I mod 5, 
    columnPoints(W,I,TU,1), 
    TL is (I//5) * 5, 
    rowPoints(W,I,TL,1).

wallPoints(W,I,P) :-
    TU is I mod 5, 
    columnPoints(W,I,TU,PC), 
    TL is (I//5) * 5, 
    rowPoints(W,I,TL,PR), 
    P is PR + PC.


% ===
% BAG
% ===


% initializeBag(B)
% Genera la bolsa inicial del juego con las 100 fichas, 20 de cada una
initializeBag([[BlueTuple,YellowTuple,RedTuple,BlackTuple, WhiteTuple],[0,1,2,3,4]]) :-
    colorTuple(azul,20,BlueTuple),
    colorTuple(amarillo,20,YellowTuple),
    colorTuple(rojo,20,RedTuple),
    colorTuple(negro,20,BlackTuple),
    colorTuple(blanco,20,WhiteTuple).


takeOneBag([BagVector,Mask],Index,[BagVectorResult,MaskResult],ColorResult) :-
    getByIndex(BagVector,Index,ColorTuple),
    insertTile(ColorTuple,-1,[ColorResult,0]),
    pushNColorVector(BagVector,ColorResult,-1,BagVectorResult),
    removeValue(Mask,Index,MaskResult), !.

takeOneBag([BagVector,Mask],Index,[BagVectorResult,Mask],ColorResult) :-
    getByIndex(BagVector,Index,ColorTuple),
    insertTile(ColorTuple,-1,[ColorResult,_]),
    pushNColorVector(BagVector,ColorResult,-1,BagVectorResult).

                                                                            

takeNBag([BagVector,[]], _, Factory,Factory ,[BagVector,[]]) :- !.

takeNBag([BagVector,Mask], 0, Factory,Factory ,[BagVector,Mask]) :- !.

takeNBag([BagVector,Mask], Count, Factory,FactoryResult ,[BagVectorResult,MaskResult]) :-
    length(Mask,R),
    random(0,R,I),
    getByIndex(Mask,I,J),
    takeOneBag([BagVector,Mask],J,[BagVectorTemp,MaskTemp],Color),
    pushNColorVector(Factory,Color,1,FactoryTemp),
    NewCount is Count - 1,
    takeNBag([BagVectorTemp,MaskTemp],NewCount,FactoryTemp,FactoryResult,[BagVectorResult,MaskResult]).

bagRecalculateMask_aux([],[]) :- !.

bagRecalculateMask_aux([[_,0]|R],NewMask) :-
    bagRecalculateMask_aux(R,NewMask),
    !.

bagRecalculateMask_aux([_|R],[Index|NewMask]) :-
    length(R,L),
    Index is 4 - L,
    bagRecalculateMask_aux(R,NewMask).

bagRecalculateMask([CV,_], [CV,Mask]) :-
    bagRecalculateMask_aux(CV,Mask).

bagMergeWithColorVector(ColorVector,[CV,_],[CVR,MaskR]) :-
    mergeColorVector(ColorVector,CV,CVR),
    bagRecalculateMask([CVR,_],[CVR,MaskR]).

% =====
% TABLE
% =====

table(Table) :-
    colorVector(Table).

tablePopColor(Table,Color,TableResult,Count) :-
    popColor(Table,Color,TableResult,Count).

% =======
% FACTORY
% =======

factoryEmpty([[azul,0],[amarillo,0],[rojo,0],[negro,0],[blanco,0]]).

% factories(FC,B,FL,BR)
% FL es el resultado de generar FC factorias, tomando de la bolsa B y dando BR como la bolsa resultante
makeNFactories(0,Bag,[],Bag) :- !.
makeNFactories(N,Bag,[FactoryResult|RFactoryList],BagResult) :-
    factoryEmpty(Factory),
    takeNBag(Bag,4,Factory,FactoryResult,RBagResult),
    NewN is N - 1,
    makeNFactories(NewN,RBagResult,RFactoryList,BagResult).

% refillFactories(Factoires,Bag,FactoriesResult,BagResult)
% Rellena todas las factorias con 4 azulejos, tomando azulejos de la bolsa
%
refillFactories([],Bag,[],Bag).

refillFactories([Factory|RCurrentFactories],Bag,[FactoryResult|RFactoriesReult],BagResult) :-
    colorVectorTileCount(Factory,TilesCount),
    Diff is 4 - TilesCount,
    takeNBag(Bag,Diff,Factory,FactoryResult,RBagResult),
    refillFactories(RCurrentFactories,RBagResult,RFactoriesReult,BagResult).

removeEmptyFactories([], _,_, []):-!.
removeEmptyFactories([X|F], Mask, N, [X|FR]):-
    member(N, Mask),
    NewN is N+1,
    removeEmptyFactories(F, Mask, NewN, FR),
    !.

removeEmptyFactories([_|F], Mask,N, [K|FR]):-
    factoryEmpty(K),
    NewN is N+1,
    removeEmptyFactories(F, Mask, NewN, FR).

removeEmptyFactories(Factories, Mask, FactoriesResult) :-
    removeEmptyFactories(Factories, Mask, 0, FactoriesResult).


% Devuelve la cantidad de azulejos del color Color hay en Factory
% 
factoryGetColorCount(Factory,Color,Count) :-
    getIndex(Color, Index),
    getByIndex(Factory,Index,[_,Count]).

% Toma todas las fichas de Color de la Factory y el resto las pone en la mesa
% 
factoryGetColor([],_,Table,Table) :- !.

factoryGetColor([[Color,_]|FactoryR], Color, Table, TableResult) :-
    factoryGetColor(FactoryR,Color,Table,TableResult), !.

factoryGetColor([[OtherColor,Count]|FactoryR], Color, Table, TableResult) :-
    pushNColorVector(Table,OtherColor,Count,TableResultTemp),
    factoryGetColor(FactoryR,Color,TableResultTemp,TableResult).



% =======
% PATTERN-LINE
% =======

%initializePL
%Inicializa el Pattern Line con el límite posible de azulejos a colocar: la posición + 1 y el espacio vacío correspondiente al color

initializePL([[[],1], [[],2], [[],3], [[],4], [[],5]]).


possibleToPushColorPL(PL, [Color, _], Pos, Wall):-
    getIndex(Color, IndexTemp),
    Index is ((IndexTemp + Pos) mod 5) + (Pos * 5),
    getByIndex(Wall, Index, 0),
    !,
    verifyColor(PL, Pos, Color).

%pushColorPL(PL, [Color, Count], Pos, Wall, Floor, FloorResult, Cover, CoverResult, PLResult)

pushColorPL(PL, [Color, PushCount], Pos, F, FR, C, CR, PLR) :- 
    pushByIndex(PLTemp, Pos, [_, Count], PL),
    TempCount is Count-PushCount,
    max(0, TempCount, NewCount),
    pushByIndex(PLTemp, Pos, [Color, NewCount], PLR),
    FloorTiles is 0-TempCount,
    pushFloor(F, [Color, FloorTiles], FR, C, CR).

verifyColor(PL, Pos, Color):-
    getByIndex(PL, Pos, [Color, _]),
    !.


verifyColor(PL, Pos, _):-
    getByIndex(PL, Pos, [[], _]).


%
%Este es el metodo nuevo
%

fromPLToWall([], [], Wall, Wall, Cover, Cover, _,Points, Points):-!.

fromPLToWall([ [Color, 0] | PL ], [[[], AllowedCount]|PLR], Wall, WallR, Cover, CoverR,Floor, Points, PointsR) :-
    getIndex(Color, Index),
    length([_|PL], NTemp),
    N is 5-NTemp,
    NewIndex is ((Index + N) mod 5) + (N * 5),
    changeIndex(Wall, NewIndex, 1, WallTemp),
    pushNCover(Cover, Color, N, CoverTemp),
    AllowedCount is N + 1,
    wallPoints(WallTemp, NewIndex, WP),
    floorPoint(Floor, FP),
    P is WP+FP,
    fromPLToWall(PL, PLR, WallTemp, WallR, CoverTemp, CoverR, Floor,Points, PointsTemp),
    PointsR is PointsTemp + P,
    !.

fromPLToWall([[Color, Count]| PL], [[Color, Count]|PLR], Wall, WallR, Cover, CoverR,Floor, Points, PointsR):-
    fromPLToWall(PL, PLR, Wall, WallR, Cover, CoverR, Floor,Points, PointsR).

% =======
% Players
% =======

newPlayers(Players):-
    newPlayersN(Players, 0).

newPlayersN(_, 4):-!.
newPlayersN([[Count,W, PL, F, 0]|Players], Count):-
    newWall(W),
    initializePL(PL),
    floorVector(F),
    NewCount is Count+1,
    newPlayersN(Players, NewCount).



% =====
% COVER
% =====

coverEmpty(Cover) :- colorVector(Cover).

pushNCover(Cover,Color, N, CoverResult):-pushNColorVector(Cover, Color, N, CoverResult).

% initializeGame(Players,Factories,Bag,Cover)
% Preparar Partida
% Players: lista de jugadores
% Factories: Estado inicial de las factorias. La cntidad de factorias depende 
%            de la cantidad de jugadores
% Bag: Estado de la bolsa luego de formar las factorias
% Cover: Tapa del juego, es donde se ponen las fichas sobrantes de la ronda
    
initializeGame(Factories,Bag,Cover, Table) :-
    coverEmpty(Cover),
    initializeBag(BagTemp),
    table(Table),
    makeNFactories(9,BagTemp,Factories,Bag),
    !.

checkEmptyBag([BagCV,BagMask],Cover,BagResult,NewCover,true) :-
    length(BagMask,0),
    bagMergeWithColorVector(Cover,[BagCV,BagMask],BagResult),
    coverEmpty(NewCover),
    !.

checkEmptyBag([BagCV,BagMask],Cover,[BagCV,BagMask],Cover,false) :-
    length(BagMask,_),
    !.

nextRoundContinue(true,Factories,Bag,Cover,FactoriesResult,BagResult,Cover) :-
    refillFactories(Factories,Bag,FactoriesResult,BagResult).

nextRoundContinue(false,Factories,Bag,Cover,Factories,Bag,Cover) :- !.

nextRound(Factories,Bag,Cover,FactoriesResult,BagResult,CoverResult) :-
    refillFactories(Factories,Bag,TempFactories,[TempBagCV,TempBagMask]),
    checkEmptyBag([TempBagCV,TempBagMask], Cover,BagR, CoverR,Result),
    nextRoundContinue(Result,TempFactories,BagR,CoverR,FactoriesResult,BagResult,CoverResult).

finalPoints(Wall,Points) :-
    wallCountHorizontal(Wall,Rows),
    countColumns(Wall,Columns),
    Points is Rows * 2 + Columns * 7.
