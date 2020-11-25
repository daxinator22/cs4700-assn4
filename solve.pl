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
	write('-+').

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

solve(Maze) :- true.
