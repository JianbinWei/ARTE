%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PARAMETERS Returns a data structure containing the parameters of the
%   ABB IRB140.
%
%   Author:Mar�a Flores Tenza. Universidad Miguel Hernandez de Elche. 
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright (C) 2012, by Arturo Gil Aparicio
%
% This file is part of ARTE (A Robotics Toolbox for Education).
% 
% ARTE is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% ARTE is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with ARTE.  If not, see <http://www.gnu.org/licenses/>.
function robot = parameters()

robot.name= 'motoman_MH6S';

robot.DH.theta= '[q(1) q(2)-pi/2 q(3) q(4) q(5)+pi/2 q(6)]';
robot.DH.d='[0.450 0 0 0.520 0 0.095]';
robot.DH.a='[0.150 0.305 0.155 0 0 0]';
robot.DH.alpha= '[-pi/2 0 -pi/2 pi/2 -pi/2 0]';
robot.J=[];


robot.inversekinematic_fn = 'inversekinematic_MH6S(robot, T)';
robot.directkinematic_fn = 'directkinematic(robot, q)';

robot.path = 'robots\MOTOMAN\MH6S';
%number of degrees of freedom
robot.DOF = 6;

%rotational: 0, translational: 1
robot.kind=['R' 'R' 'R' 'R' 'R' 'R'];


%minimum and maximum rotation angle in rad
robot.maxangle =[-170 170; %Axis 1, minimum, maximum
                deg2rad(-80) deg2rad(133); %Axis 2, minimum, maximum
                deg2rad(-130) deg2rad(165); %Axis 3
                deg2rad(-180) deg2rad(180); %Axis 4: Unlimited (400� default)
                deg2rad(-45) deg2rad(225); %Axis 5
                deg2rad(-360) deg2rad(360)]; %Axis 6: Really Unlimited to (800� default)

%maximum absolute speed of each joint rad/s or m/s
robot.velmax = [deg2rad(220); %Axis 1, rad/s
                deg2rad(220); %Axis 2, rad/s
                deg2rad(220); %Axis 3, rad/s
                deg2rad(410); %Axis 4, rad/s
                deg2rad(410); %Axis 5, rad/s
                deg2rad(610)];%Axis 6, rad/s
    
robot.accelmax=robot.velmax/0.1; % 0.1 is here an acceleration time
            
% end effectors maximum velocity
robot.linear_velmax = 2.5; %m/s



%base reference system
robot.T0 = eye(4);


%INITIALIZATION OF VARIABLES REQUIRED FOR THE SIMULATION
%position, velocity and acceleration
robot=init_sim_variables(robot);
robot.path = pwd;


% GRAPHICS
robot.graphical.has_graphics=1;
robot.graphical.color = [255 102 51]./255;
%for transparency
robot.graphical.draw_transparent=0;
%draw DH systems
robot.graphical.draw_axes=1;
%DH system length and Font size, standard is 1/10. Select 2/20, 3/30 for
%bigger robots
robot.graphical.axes_scale=1;
%adjust for a default view of the robot
robot.axis=[-0.5 1 -0.75 1 0 1.1];
%read graphics files
robot = read_graphics(robot);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DYNAMIC PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robot.has_dynamics=1;

%consider friction in the computations
robot.dynamics.friction=0;

%link masses (kg)
robot.dynamics.masses=[38 31 22 17 9 3]; % masa total 120 Kg

%COM of each link with respect to own reference system
robot.dynamics.r_com=[0       0          0; %(rx, ry, rz) link 1
                     -0.05	 0.006	 0.1; %(rx, ry, rz) link 2
                    -0.0203	-0.0141	 0.070;  %(rx, ry, rz) link 3
                     0       0.019       0;%(rx, ry, rz) link 4
                     0       0           0;%(rx, ry, rz) link 5
                     0       0         0.032];%(rx, ry, rz) link 6

%Inertia matrices of each link with respect to its D-H reference system.
% Ixx	Iyy	Izz	Ixy	Iyz	Ixz, for each row
robot.dynamics.Inertia=[0      0.35	0   	0	0	0;
    .13     .524	.539	0	0	0;
    .066	.086	.0125	0	0	0;
    1.8e-3	1.3e-3	1.8e-3	0	0	0;
    .3e-3	.4e-3	.3e-3	0	0	0;
    .15e-3	.15e-3	.04e-3	0	0	0];

%Speed reductor at each joint
robot.motors.G=[70 75 150 10 100 1];

%Viscous friction factor of the motor
robot.motors.Viscous = [0 0 0 0 0 0];
%Coulomb friction of the motor
robot.motors.Coulomb = [0	0;
                        0	0;
                        0	0;
                        0	0;
                        0	0;
                        0	0];
%Inertia of the rotor
robot.motors.Inertia=[11.1e-4 11.1e-4 1.51e-4 0.57e-4 0.57e-4 0.57e-4];

%these correspond to ABB servo motors 9C series
%                      R(Ohm)         L(H)       Kv (V�s/rad)     Kp (Nm/A)     Max_current (A) 
robot.motors.constants=[2.17        16.5e-3         1.03            1.79            19.9; % Joint 1: 9C4.3.30
                        2.17        16.5e-3         1.03            1.79            19.9; % Joint 2: 9C4.3.30
                        3.4         18e-3           0.41            0.7             17.3; % Joint 3: 9C1.3.60
                        34.0        108.0e-3        0.66            1.15            4.5;  % Joint 4: 9C1.1.30
                        34.0        108.0e-3        0.66            1.15            4.5;  % Joint 5: 9C1.1.30
                        34.0        108.0e-3        0.66            1.15            4.5]; % Joint 6: 9C1.1.30

