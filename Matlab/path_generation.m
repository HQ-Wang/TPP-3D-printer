function [ output ] = path_generation( in,col_x,col_y,col_z,z_length )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
xyz_table=in(:,[col_x,col_y,col_z]);%read 'xyz' columns from 'in' array
for i=1:2 %move the center of xy plane to (0,0)
    xyz_table(:,i)=xyz_table(:,i)-(max(xyz_table(:,i))+min(xyz_table(:,i)))/2;
end
xyz_table(:,3)=xyz_table(:,3)-min(xyz_table(:,3));%set z_start at 0

z=unique(xyz_table(:,3));%extract unique terms from z column
output=[];
%build the scanning path: 'Z' path if mode=1, and 'S' path if mode=-1
mode=-1;
for i=1:size(z,1)
    ind_z= xyz_table(:,3)==z(i);
    xy_table=sortrows(xyz_table(ind_z,:),2);
    y=unique(xy_table(:,2));
    for j=1:size(y,1)
        ind_y= xy_table(:,2)==y(j);
        if mod(j,2)~=0
            x_table=sortrows(xy_table(ind_y,:),1);
        else
            x_table=sortrows(xy_table(ind_y,:),mode);
        end
        for k=1:size(x_table,1)
            if i==1&&j==1&&k==1
                x_table(k,4)=0;
            else
                if j==1&&k==1
                    x_table(k,4)=0;
                else
                    if k==1
                        if x_table(k,2)-output(end,2)~=1
                            x_table(k,4)=0;
                        else
                            x_table(k,4)=1;
                        end
                    else
                        if abs(x_table(k,1)-x_table(k-1,1))~=1
                            x_table(k,4)=0;
                        else
                            x_table(k,4)=1;
                        end
                    end
                end
            end
        end
        output=[output;x_table];
    end
end
output(:,1:3)=output(:,1:3)/max(output(:,3))*z_length;%set scale, the same unit as z_length
scatter3(output(:,1), output(:,2), output(:,3),'.');
xlabel('x');
end

