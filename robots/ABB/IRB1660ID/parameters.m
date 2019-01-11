%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PARAMETERS Returns a data structure containing the parameters of the
%   ABB IRB1660ID.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors:ANTONIO GARCIA RAMIREZ
%         BENJAMIN SANZ WORRELL
%         JAVIER ALBERO LOPEZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

robot.name= 'ABB_IRB1660ID';

%Path where everything is stored for this robot
robot.path = 'robots/abb/IRB1660ID';

robot.DH.theta= '[q(1) q(2)-pi/2 q(3) q(4) q(5) q(6)+pi]';
robot.DH.d='[0.4865 0 0 0.678 0 0.135]';
robot.DH.a='[0.15 0.7 0.108 0 0 0]';
robot.DH.alpha= '[-pi/2 0 -pi/2 pi/2 -pi/2 0]';
robot.J=[];


robot.inversekinematic_fn = 'inversekinematic_irb1660id(robot, T)';

%number of degrees of freedom
robot.DOF = 6;

%rotational: 0, translational: 1
robot.kind=['R' 'R' 'R' 'R' 'R' 'R'];

%minimum and maximum rotation angle in rad
robot.maxangle =[deg2rad(-180) deg2rad(180); %Axis 1, minimum, maximum
                deg2rad(-90) deg2rad(150); %Axis 2, minimum, maximum
                deg2rad(-238) deg2rad(79); %Axis 3
                deg2rad(-175) deg2rad(175); %Axis 4
                deg2rad(-120) deg2rad(120); %Axis 5
                deg2rad(-400) deg2rad(400)]; %Axis 6

%maximum absolute speed of each joint rad/s or m/s
robot.velmax = [deg2rad(180); %Axis 1, rad/s
                deg2rad(180); %Axis 2, rad/s
                deg2rad(180); %Axis 3, rad/s
                deg2rad(320); %Axis 4, rad/s
                deg2rad(360); %Axis 5, rad/s
                deg2rad(500)];%Axis 6, rad/s
robot.accelmax=robot.velmax/0.1; % 0.1 is here an acceleration time
            
            % end effectors maximum velocity
robot.linear_velmax = 2.5; %m/s

%base reference system
robot.T0 = eye(4);

%INITIALIZATION OF VARIABLES REQUIRED FOR THE SIMULATION
%position, velocity and acceleration
robot=init_sim_variables(robot);

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
robot.axis=[-2 2 -2 2 0 2.2];
%read graphics files
robot = read_graphics(robot);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%DYNAMICS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robot.has_dynamics=1;

%consider friction in the computations
robot.dynamics.friction=0;

%link masses (kg)
%Tenemos que repartir 257kg (peso total robot IRB1660ID entre los 6 eslabones)    

robot.dynamics.masses=[120 45 50 35 5 2];
%COM of each link with respect to own reference system
robot.dynamics.r_com=[0       0    0.243; %(rx, ry, rz) link 1
         0       -0.350     -0.168;%(rx, ry, rz) link 2
         -0.15	     0	   0; %(rx, ry, rz) link 3
         0       -0.0845     0.339; %(rx, ry, rz) link 4
         0       0.0675     0; %(rx, ry, rz) link 5
         0           0     0.135];%(rx, ry, rz) link 6

%Inertia matrices of each link with respect to its D-H reference system.
% Ixx	Iyy	Izz	Ixy	Iyz	Ixz, for each row
robot.dynamics.Inertia=[0      0	    0   	0	0	0;
         2.305  2.696	3.802	0	0	0;
         .0700	1.765	1.784	0	0	0;
         0.267  0.324	0.332	0	0	0;
         0.297	0.290	.023	0	0	0;
         .008	.002	.008	0   0	0;
         0      0       0       0   0   0];
     
%Selecci�n de motor
robot.motors=load_motors([5 5 4 4 2 2]);
%Speed reductor at each joint
robot.motors.G=[200 300 150 50 50 10];
