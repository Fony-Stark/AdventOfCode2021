file_line(File, Line) :-
    setup_call_cleanup(open(File, read, In),
        stream_line(In, Line),
        close(In)).

stream_line(In, Line) :-
    repeat,
    (   read_line_to_string(In, Line0),
        Line0 \== end_of_file
    ->  Line0 = Line
    ;   !,
        fail
    ).

charles_part1(Number_of_dubbles):-
    findall(Line, file_line("Day5Input.txt", Line), Lines),

    create_1000_1000_matrix(Matrix),
    insert_horizontal_and_vertical_lines(Matrix, Lines, Matrix2),
    count_overlaps(Matrix2).

create_1000_1000_matrix(Matrix):-
    length(Matrix, 1000),
    create_rows_1000_matrix(Matrix).

create_rows_1000_matrix([]).
create_rows_1000_matrix([Row | Rows]):-
    length(Row, 1000),
    fill_me(Row, 0),
    create_rows_1000_matrix(Rows).

fill_me([], _).
fill_me([Element | Tail], Value):-
    Element = Value,
    fill_me(Tail, Value).

insert_horizontal_and_vertical_lines(Matrix, [], Matrix).
insert_horizontal_and_vertical_lines(Matrix, [Line | Lines], Matrix2):-
    interpred_line(Matrix, Line, Matrix3),
    insert_horizontal_and_vertical_lines(Matrix3, Lines, Matrix2).

interpred_line(Matrix, Line, Matrix2):-
    split_string(Line, " ", "", Pieces),
    Pieces = [From, _, To],
    split_string(From, ",", "", FromList),
    split_string(To, ",", "", ToList),
    make_numbers(FromList, FromListNum),
    make_numbers(ToList, ToListNum),
    
    check_direction(Matrix, ToListNum, FromListNum, Matrix2).

make_numbers([], []).
make_numbers([X | Xs], [Y, Ys]):-
    atom_number(X, Y),
    make_numbers(Xs, Ys).

check_direction(Matrix, [X, Y1], [X, Y2], Matrix2):-
    insert_horizontal(Matrix, [X, Y1], [X, Y2], Matrix2).
check_direction(Matrix, [X1, Y], [X2, Y], Matrix2):-
    insert_vertical(Matrix, [X1, Y], [X2, Y], Matrix2).

insert_vertical(Matrix, [XC, Y], [XE, Y], Matrix2):-
    XC is XE + 1.
insert_vertical(Matrix, [XC, Y], [XE, Y], Matrix2):-
    XB is XC + 1,
    nth0(XC, Matrix, Row),
    nth0(Y, Row, OldValue),
    Value is OldValue + 1,
    