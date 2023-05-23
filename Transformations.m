vert = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];

menu_choice = 1;
while menu_choice ~= 3
    if menu_choice == 1
        updated_vert = initializeUpdatedVert(vert);
    else
        disp('Please choose transformation type');
        disp('1. Translation');
        disp('2. Scaling');
        disp('3. Rotation');
        choice = setAndReturnChoice(1,3);
        if choice == 1
            tx = setAndReturnVariableValue('tx');
            ty = setAndReturnVariableValue('ty');
            tz = setAndReturnVariableValue('tz');
            T = [1,0,0,tx;0,1,0,ty;0,0,1,tz;0,0,0,1];
            updated_vert = T * updated_vert;
        elseif choice == 2
            sx = setAndReturnVariableValue('sx');
            sy = setAndReturnVariableValue('sy');
            sz = setAndReturnVariableValue('sz');
            S = [sx,0,0,0;0,sy,0,0;0,0,sz,0;0,0,0,1];
            updated_vert = S * updated_vert;      
        else
            degree = setAndReturnVariableValue('rotation degree');
            disp('Please choose rotation direction');
            disp('1. Clockwise');
            disp('2. Counterclockwise');
            choice = setAndReturnChoice(1,2);
            if choice == 1
                degree = 360 - degree;
            end
            radian = degree .* pi ./ 180;
            disp('Please choose rotation axis');
            disp('1. x-axis');
            disp('2. y-axis');
            disp('3. z-axis');
            choice = setAndReturnChoice(1,3);
            if choice == 1
                Rx = [1,0,0,0;0,cos(radian),-sin(radian),0;0,sin(radian),cos(radian),0;0,0,0,1];
                updated_vert = Rx * updated_vert;
            elseif choice == 2
                Ry = [cos(radian),0,sin(radian),0;0,1,0,0;-sin(radian),0,cos(radian),0;0,0,0,1];
                updated_vert = Ry * updated_vert;
            else
                Rz = [cos(radian),-sin(radian),0,0;sin(radian),cos(radian),0,0;0,0,1,0;0,0,0,1];
                updated_vert = Rz * updated_vert;
            end
        end
    end
    displayFigure(updated_vert,fac,menu_choice);

    disp('Menu');
    disp('1. Start new transformation');
    disp('2. Continue transformation');
    disp('3. Exit');
    menu_choice = setAndReturnChoice(1,3);
end

function val = setAndReturnVariableValue(var)
    eow = false;
    while ~eow
        val = input(sprintf('Please enter %s value (must be numeric) : ',var));
        if isnumeric(val)
            eow = true;
        end
    end
end

function choice = setAndReturnChoice(first,last)
    eow = false;
    while ~eow
        choice = input(sprintf('Your choice (must be %d-%d) : ',first,last));
        if isnumeric(choice) && choice >= first && choice <= last
            eow = true;
        end
    end
end

function updated_vert = initializeUpdatedVert(vert)
    updated_vert = zeros(size(vert,2) + 1 , size(vert,1));
    for i = 1 : 8
        updated_vert(:,i) = [vert(i,:) , 1];
    end
end

function displayFigure(cur_vert,fac,menu_choice)
    cur_vert(end , :) = [];
    disp_vert = zeros(size(cur_vert,2) , size(cur_vert,1));
    for i = 1 : size(cur_vert , 1)
        disp_vert(:,i) = cur_vert(i,:);
    end
    figure;
    patch('Vertices',disp_vert,'Faces',fac,'FaceVertexCData',hsv(8),'FaceColor','interp');
    view(3)
    axis vis3d

    if menu_choice == 1
        title('3D figure before transformations');
    elseif menu_choice == 2
        title('3D figure after transformation');
    end
end