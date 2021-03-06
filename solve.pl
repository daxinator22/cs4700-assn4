% These rules are incomplete, that is there are missing rules, and
% missing parts to the rules.  They are provided to illustrate
% the approach.

% Try a move in an "Up" direction, assumes Row and Column are bound.
try(Row, Column, NextRow, NextColumn) :- NextRow is Row, NextColumn is Column - 1.

% move(Maze, List, NewList, Row, Column, GoalRow, GoalColumn) - moves, 
%   and keep on moving until the GoalRow and GoalColumn coordinates 
%   are reached. List is the list of previous moves (important to check 
%   that the current move is not one previously made), NewList will be 
%   bound to the list of successful moves in a solved maze.

%
%   Recursive case still needed.

% printCell(Maze, List, Row, Column) - helper goal for printMaze, printCell
%   prints a single cell in the maze.
%
%   Print a barrier.

getNumbers(Start, End, List) :- Start =:= End, append([[Start, End]], [], List).
getNumbers(Start, End, List) :- NewStart is Start + 1, getNumbers(NewStart, End, NewList), append([[Start, End]], NewList, List).

printCell(Maze, List, Row, Column) :- maze(Maze, Row, Column, barrier), write('x').
printCell(Maze, List, Row, Column) :- maze(Maze, Row, Column, open), member([Row, Column], List), write('*').
printCell(Maze, List, Row, Column) :- maze(Maze, Row, Column, open), write(' ').

printList([]).
printList([H|T]) :-
	write(H),
	nl,
	printList(T).

%Prints out the maze
printMaze(Maze, List) :- 
	loopMaze(Maze, List, 0, 1),
	true.

%Checks initial corner on bottom row
loopMaze(Maze, List, Row, Column) :-
	mazeSize(Maze, MaxRow, MaxCol),
	Row =:= MaxRow + 1,
	Column =:= 1, 
	write('+-'),
	NewCol is Column + 1,
	loopMaze(Maze, List, Row, NewCol).

%Checks last corner on bottom row
loopMaze(Maze, List, Row, Column) :-
	mazeSize(Maze, MaxRow, MaxCol),
	Row =:= MaxRow + 1,
	Column =:= MaxCol,
	write('-+'),
	nl.

%Adds line on bottom row
loopMaze(Maze, List, Row, Column) :-
	mazeSize(Maze, MaxRow, MaxCol),
	Row =:= MaxRow + 1,
	write('-'),
	NewCol is Column + 1,
	loopMaze(Maze, List, Row, NewCol).

%Checks initial corner on top row
loopMaze(Maze, List, Row, Column) :-
	Row =:= 0,
	Column =:= 1,
	write('+-'),
	NewCol is Column + 1,
	loopMaze(Maze, List, Row, NewCol).

%Checks last corner on top row
loopMaze(Maze, List, Row, Column) :-
	mazeSize(Maze, MaxRow, MaxCol),
	Row =:= 0,
	Column =:= MaxCol,
	write('-+'),
	nl,
	NewRow is Row + 1,
	loopMaze(Maze, List, NewRow, 1).

%Adds initial line on top row
loopMaze(Maze, List, Row, Column) :-
	Row =:= 0,
	write('-'),
	NewCol is Column + 1,
	loopMaze(Maze, List, Row, NewCol).

%Checks to see if the row is the max row
loopMaze(Maze, List, Row, Column) :-
	mazeSize(Maze, MaxRow, MaxCol),
	MaxRow =:= Row,
	MaxCol =:= Column,
	printCell(Maze, List, Row, Column),
	write('|'),
	NewRow is Row + 1
	loopMaze(Maze, List, Row, 1).

%Checks to see if the col is the max column
loopMaze(Maze, List, Row, Column) :-
	mazeSize(Maze, MaxRow, MaxCol),
	MaxCol =:= Column,
	printCell(Maze, List, Row, Column),
	write('|'),
	nl,
	NewRow is Row + 1,
	loopMaze(Maze, List, NewRow, 1).

%First of row call
loopMaze(Maze, List, Row, Column) :-
	Column =:= 1,
	write('|'),
	printCell(Maze, List, Row, Column),
	NewCol is Column + 1,
	loopMaze(Maze, List, Row, NewCol).

%Normal recursive call
loopMaze(Maze, List, Row, Column) :-
	printCell(Maze, List, Row, Column),
	NewCol is Column + 1,
	loopMaze(Maze, List, Row, NewCol).

%Solves the maze
solve(Maze) :-
	isPath(Maze, [], 1, 1, List),
	printList(List),
	printMaze(Maze, List).

%If the path has reached the goal
isPath(Maze, List, Row, Col, Path) :-
	mazeSize(Maze, MaxRow, MaxCol),
	Row =:= MaxRow,
	Col =:= MaxCol,
	append(List, [[Row, Col]], Path).

%Checks to see if vaild path down
isPath(Maze, List, Row, Col, Path) :-
	append(List, [[Row, Col]], NewList),
	canMoveDown(Maze, NewList, Row, Col, NewRow, NewCol),
	\+ member([NewRow, NewCol], List),
	isPath(Maze, NewList, NewRow, NewCol, Path).

%Checks to see if vaild path right
isPath(Maze, List, Row, Col, Path) :-
	append(List, [[Row, Col]], NewList),
	canMoveRight(Maze, NewList, Row, Col, NewRow, NewCol),
	\+ member([NewRow, NewCol], List),
	isPath(Maze, NewList, NewRow, NewCol, Path).

%Checks to see if vaild path left
isPath(Maze, List, Row, Col, Path) :-
	append(List, [[Row, Col]], NewList),
	canMoveLeft(Maze, NewList, Row, Col, NewRow, NewCol),
	\+ member([NewRow, NewCol], List),
	isPath(Maze, NewList, NewRow, NewCol, Path).

%Checks to see if vaild path up
isPath(Maze, List, Row, Col, Path) :-
	append(List, [[Row, Col]], NewList),
	canMoveUp(Maze, NewList, Row, Col, NewRow, NewCol),
	\+ member([NewRow, NewCol], List),
	isPath(Maze, NewList, NewRow, NewCol, Path).

%Shortcuts for canMove
canMoveDown(Maze, List, Row, Col, NewRow, NewCol) :- canMove(Maze, List, Row, Col, 1, 0, NewRow, NewCol).
canMoveLeft(Maze, List, Row, Col, NewRow, NewCol) :- canMove(Maze, List, Row, Col, 0, -1, NewRow, NewCol).
canMoveUp(Maze, List, Row, Col, NewRow, NewCol) :- canMove(Maze, List, Row, Col, -1, 0, NewRow, NewCol).
canMoveRight(Maze, List, Row, Col, NewRow, NewCol) :- canMove(Maze, List, Row, Col, 0, 1, NewRow, NewCol).

%Checks to see if point is in bounds and is open
canMove(Maze, List, Row, Col, RowMove, ColMove, NewRow, NewCol) :-
	NewCol is Col + ColMove,
	NewRow is Row + RowMove,
	NewRow >= 1,
	NewCol >= 1,
	mazeSize(Maze, MaxRow, MaxCol),
	NewRow =< MaxRow,
	NewCol =< MaxCol,
	maze(Maze, NewRow, NewCol, open).

