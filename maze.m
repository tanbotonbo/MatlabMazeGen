mazeWidth = input('Enter width of maze')
mazeHeight = input('Enter height of maze')
tic
weightGraph = zeros(mazeHeight, mazeWidth);
for n = 1:mazeHeight
    for m = 1:mazeWidth
        loop = 1;
        while loop
            loop = 1;
            randomRow = randi([1, mazeHeight]);
            randomColumn = randi([1, mazeWidth]);
            if weightGraph(randomRow, randomColumn) == 0
                weightGraph(randomRow, randomColumn) = (n-1)*mazeWidth + m + 1;
                loop = 0;
            end
        end
    end
end
%display(weightGraph)
mazeMatrix = zeros(mazeHeight*2+1, mazeWidth*2+1);

for n = 0:(mazeHeight)
    for m = 0:(mazeWidth)
        mazeMatrix(n*2 + 1, m*2 + 1) = 1;
    end
end

for n = 1:mazeHeight
    for m = 0:mazeWidth
        mazeMatrix(2*n, 2*m+1)=1;
    end
end

for n = 0:mazeHeight
    for m = 1:mazeWidth
        mazeMatrix(2*n+1, 2*m) = 1;
    end
end


for n = 1:mazeHeight
    for m = 1:mazeWidth
        mazeMatrix(2*n, 2*m) = weightGraph(n,m);
    end
end

r = randi([1,mazeHeight]);
c = randi([1, mazeWidth]);

visitedMatrix = zeros(mazeHeight, mazeWidth);


% Here we begin the growth of the maze via Prim's Algorithm

[r, c] = find(weightGraph==2);
visitedMatrix(r, c) = 1;

% HEAVILY REVISED THE ALGORITHM BELOW TO ONLY ADD AND SUBTRACT FROM LIST OF
% POSSIBLE SPACES WHEN MAKING CONNECTIONS TO NEW SPOTS, THUS CONSIDERABLY
% REDUCING THE NUMBER OF CHECKS MADE EACH LOOP AND PREVENTING GROWTH IN
% COMPUTATION TIME WITH EACH EXTRA STEP, MAKING NONLINEAR PRODUCTION TIMES
% EMERGE NO LONGER

adjRooms = zeros (1,3);
also = zeros (1,3);

%r and c of the above thing will be used to record which room was most
%recently added to the maze

%We are going to record the location of the highest weight only once, at
%the beginning
[r3, c3] = find(weightGraph==mazeHeight*mazeWidth+1);

looping = 1;
while looping
    
    %Here we add new numbers to the adjRooms matrix, also recording their
    %locations and preventing the necessity of searching for them again
    %when we'd already found them prior and just not recorded the number
    
    if r>1 && visitedMatrix(r-1, c) == 0
        adjRooms = [adjRooms;[weightGraph(r-1, c), r-1, c]];
        also = [also;[weightGraph(r-1, c), r-1, c]];
    end
    if r<mazeHeight && visitedMatrix(r+1, c) == 0
        adjRooms = [adjRooms;[weightGraph(r+1, c), r+1, c]];
        also = [also;[weightGraph(r+1, c), r+1, c]];
    end
    if c>1 && visitedMatrix(r, c-1) == 0
        adjRooms = [adjRooms;[weightGraph(r, c-1), r, c-1]];
        also = [also;[weightGraph(r, c-1), r, c-1]];
    end
    if c<mazeWidth && visitedMatrix(r, c+1) == 0
        adjRooms = [adjRooms;[weightGraph(r, c+1), r, c+1]];
        also = [also;[weightGraph(r, c+1), r, c+1]];
    end
    
    %Here we decide which is the lowest
    
    if size(adjRooms, 1)>1
        lowVal = adjRooms(2,1);
        for n=2:size(adjRooms,1)
            if adjRooms(n,1)<lowVal
                lowVal = adjRooms(n,1);
            end
        end
    end
    
    %Then write its location on the weightGraph into the variables r and c,

    index = find(adjRooms(:,1) == lowVal, 1);
    
    r = adjRooms(index, 2);
    c = adjRooms(index, 3);
    
    %mark it as visited and prevent it from being chosen again,
    index2 = find(adjRooms(:,1) == lowVal);
    adjRooms(index2,:)=[];
    visitedMatrix(r,c) = 1;
    
    %and then choose the highest weighted visited neighbor as the
    %connection point
    possCon = zeros(1,1);
    
    if r>1 && visitedMatrix(r-1,c) == 1
        possCon = [possCon;weightGraph(r-1, c)];
    end
    if r<mazeHeight && visitedMatrix(r+1, c) == 1
        possCon = [possCon;weightGraph(r+1, c)];
    end
    if c>1 && visitedMatrix(r, c-1) == 1
        possCon = [possCon;weightGraph(r, c-1)];
    end
    if c<mazeWidth && visitedMatrix(r, c+1) == 1
        possCon = [possCon;weightGraph(r, c+1)];
    end
    
    
    if size(possCon, 1)>1
        highVal = possCon(2,1);
        for n=2:size(possCon,1)
            if possCon(n,1)>highVal
                highVal = possCon(n,1);
            end
        end
    else
        highVal = possCon(2,1);
    end
    
    [rl, cl] = find(mazeMatrix == lowVal);
    [r2, c2] = find(mazeMatrix == highVal);
    
    mazeMatrix((rl+r2)/2, (cl+c2)/2) = 0;
 
    
    %Now we will check to see if the last spot has been hit
    if visitedMatrix(r3, c3) == 1
        looping = 0;
    end
end









%Here I disable all prior written code for generating the maze
if 0
display('test')
loop = 1;
while loop
    %Get list of all nonvisited spaces touching visited spaces in a 3-wide matrix containing their weight, row, and column
    openPaths = zeros(1,1);
    
    for n = 1:mazeHeight
        for m = 1:mazeWidth
            if visitedMatrix(n,m) == 1
                surrounded = 0;
                if n>1 && visitedMatrix(n-1, m) == 0
                    openPaths = [openPaths;weightGraph(n-1, m)];
                    surrounded = surrounded + 1;
                end
                if n<mazeHeight && visitedMatrix(n+1, m) == 0
                    openPaths = [openPaths;weightGraph(n+1, m)];
                    surrounded = surrounded + 1;
                end
                if m>1 && visitedMatrix(n, m-1) == 0
                    openPaths = [openPaths;weightGraph(n, m-1)];
                    surrounded = surrounded + 1;
                end
                if m<mazeWidth && visitedMatrix(n, m+1) == 0
                    openPaths = [openPaths;weightGraph(n, m+1)];
                    surrounded = surrounded + 1;
                end
                if surrounded == 0
                    visitedMatrix(n,m)=2;
                end
            end
        end
    end
    %Determine where to break wall based on lowest weight and lowest difference
    if size(openPaths, 1)>1
        lowVal = openPaths(2,1);
        for n=2:size(openPaths,1)
            if openPaths(n,1)<lowVal
                lowVal = openPaths(n,1);
            end
        end
    end
    
    [lR, lC] = find(weightGraph==lowVal);
    possCon = zeros(1,1);
    
    if lR>1 && visitedMatrix(lR-1, lC) == 1
        possCon = [possCon;weightGraph(lR-1, lC)];
    end
    if lR<mazeHeight && visitedMatrix(lR+1, lC) == 1
        possCon = [possCon;weightGraph(lR+1, lC)];
    end
    if lC>1 && visitedMatrix(lR, lC-1) == 1
        possCon = [possCon;weightGraph(lR, lC-1)];
    end
    if lC<mazeWidth && visitedMatrix(lR, lC+1) == 1
        possCon = [possCon;weightGraph(lR, lC+1)];
    end
    
    if size(possCon, 1)>1
        highVal = possCon(2,1);
        for n=2:size(possCon,1)
            if possCon(n,1)>highVal
                highVal = possCon(n,1);
            end
        end
    else
        highVal = possCon(2,1);
    end
    
    [r1, c1] = find(mazeMatrix == lowVal);
    [r2, c2] = find(mazeMatrix == highVal);
    mazeMatrix((r1+r2)/2, (c1+c2)/2) = 0;
    
    visitedMatrix(lR, lC) = 1;
    
    [r3, c3] = find(weightGraph==mazeHeight*mazeWidth+1);
    if visitedMatrix(r3, c3) == 1
        break
    end
end 

%Here is the end of the disabled area
end

%?Add entrances and exits
rand = randi([1,4]);

rand2 = randi([1,4]);
while(rand2 == rand)
    rand2 = randi([1,4]);
end

%display([rand, rand2])


if rand == 1
    op = randi([1,mazeWidth]);
    mazeMatrix(1, 2*op) = 0;
elseif rand == 2
    op = randi([1,mazeHeight]);
    mazeMatrix(2*op, 1) = 0;
elseif rand == 3
    op = randi([1,mazeWidth]);
    mazeMatrix(mazeHeight*2+1, 2*op) = 0;
else
    op = randi([1,mazeHeight]);
    mazeMatrix(2*op, mazeWidth*2+1) = 0;
end

if rand2 == 1
    op = randi([1,mazeWidth]);
    mazeMatrix(1, 2*op) = 0;
elseif rand2 == 2
    op = randi([1,mazeHeight]);
    mazeMatrix(2*op, 1) = 0;
elseif rand2 == 3
    op = randi([1,mazeWidth]);
    mazeMatrix(mazeWidth*2+1, 2*op) = 0;
else
    op = randi([1,mazeHeight]);
    mazeMatrix(2*op, mazeHeight*2+1) = 0;
end

%display(mazeMatrix)

colorMatrix = zeros (mazeHeight*2+1, mazeWidth*2+1);
for n = 1:mazeHeight*2+1
    for m = 1:mazeWidth*2+1
        if mazeMatrix(n,m) == 1
            colorMatrix(n,m) = 0;
        else
            colorMatrix(n,m) = 255;
        end
    end
end

imagesc(colorMatrix)
toc
            
       
    