
:- ["utils.pl"].

getIndex(azul,0).
getIndex(amarillo,1).
getIndex(rojo,2).
getIndex(negro,3).
getIndex(blanco,4).

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


% pushNColorVector(ColorVector,Color,N,ColorVectorResult)
% Aumenta en N la cantidad de Color en ColorVector, dando como resultado ColorVectorResult
% 
pushNColorVector([[Color,Count]|ColorVector],Color,N,[[Color,NewCount]|ColorVector]) :- 
    NewCount is Count + N, !.

pushNColorVector([[OtherColor,Count]|ColorVector],Color,N,[[OtherColor,Count]|ColorVectorResult]) :- 
    pushNColorVector(ColorVector,Color,N,ColorVectorResult).

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

floorPoint([[true,Value]|R],Points) :-
    floorPoint(R,RPoints),
    Points is RPoints + Value.

%pushFloor(F, N, FR)
%Coloca N azulejos en F y el resultado lo devuelve en FR
%

pushFloor([[false, Points]|Rest], [_,0], [[true, Points]|Rest], Cover, Cover):-!.

pushFloor([], [Color, N], [], Cover, CoverResult) :- pushNColorVector(Cover, Color, N, CoverResult).

pushFloor([[false, points]|Rest], [Color, N], [[true, points]|ResultRest], Cover, CoverResult) :-   NewN is N-1, 
                                                                                                    pushFloor(Rest, [Color, NewN], ResultRest, Cover, CoverResult).

pushFloor([[true, Points]|Rest], ColorTuple, [[true, Points]|ResultRest], Cover, CoverResult) :- pushFloor(Rest, ColorTuple, ResultRest, Cover, CoverResult).



% ====
% WALL
% ====

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
    getByIndex(W,I,0), !.

wallPoints(W,I,P) :-
    TL is (I/5) * 5, 
    rowPoints(W,I,TL,PR), 
    TU is I mod 5, 
    columnPoints(W,I,TU,PC), 
    P is PR + PC.


% ===
% BAG
% ===


% initializebag(B)
% Genera la bolsa inicial del juego con las 100 fichas, 20 de cada una
initializebag([[BlueTuple,YellowTuple,RedTuple,BlackTuple, WhiteTuple],[0,1,2,3,4]]) :-
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

<<<<<<< HEAD


% =======
% PATTERN-LINE
% =======

%initializePL
%Inicializa el Pattern Line con el límite posible de azulejos a colocar: la posición + 1 y el espacio vacío correspondiente al color

initializePL([[[],1], [[],2], [[],3], [[],4], [[],5]]).

%pushColorPL(PL, [Color, Count], Pos, Wall, Floor, FloorResult, Cover, CoverResult, PLResult)

pushColorPL(PL, [Color, PushCount], Pos, Wall, F, FR, C, CR, PLR) :- 
    pushByIndex(PLTemp, Pos, [Color, Count], PL),
    TempCount is Count-PushCount,
    max(0, TempCount, NewCount),
    pushByIndex(PLTemp, Pos, [Color, NewCount], PLR),
    getIndex(Color, IndexTemp),
    Index is ((Pos-1)*5) + IndexTemp,
    getByIndex(Wall, Index, 0),
    !,
    FloorTiles is 0-TempCount,
    pushFloor(F, FloorTiles, FR, C, CR).



=======
% =====
% COVER
% =====

coverEmpty(Cover) :- colorVector(Cover).

% initializeGame(Players,Factories,Bag,Cover)
% Preparar Partida
% Players: lista de jugadores
% Factories: Estado inicial de las factorias. La cntidad de factorias depende 
%            de la cantidad de jugadores
% Bag: Estado de la bolsa luego de formar las factorias
% Cover: Tapa del juego, es donde se ponen las fichas sobrantes de la ronda

initializeGame(Players,Factories,Bag,Cover) :-
    length(Players,2),
    coverEmpty(Cover),
    initializebag(BagTemp),
    makeNFactories(5,BagTemp,Factories,Bag),
    !.

initializeGame(Players,Factories,Bag,Cover) :-
    length(Players,3),
    coverEmpty(Cover),
    initializebag(BagTemp),
    makeNFactories(7,BagTemp,Factories,Bag),
    !.
    
initializeGame(Players,Factories,Bag,Cover) :-
    length(Players,4),
    coverEmpty(Cover),
    initializebag(BagTemp),
    makeNFactories(9,BagTemp,Factories,Bag),
    !.
>>>>>>> 2816ba863abcab40f0f457f5024496589481d971
