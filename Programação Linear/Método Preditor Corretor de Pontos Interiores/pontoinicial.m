function [x,y,z] = pontoinicial(A,b,c)
  
  %-----Parâmetros usados no programa-----
  As=sparse(A);
  [m,n]=size(A);
  epslon2=100;
  xtil=(As')*inv(As*(As'))*b;
  epslon1=max([-min(xtil) epslon2 (norm(b,1))/((norm(A,1)*epslon2))]);
  epslon3=norm(c,1)+1;
  
  %-----x0-----
  for j=1:n
    xaux(j)=max([xtil(j) epslon1]);
  end
  x=xaux';
  %-----y0-----
  y=zeros([m 1]);
  %-----z0-----
  for i=1:n
    if c(i)>=0
      zaux(i)=c(i)+epslon3;
    elseif c(i)<=epslon3
      zaux(i)=-c(i);
    elseif -epslon3<=c(i) && c(i)<=0
      zaux(i)=epslon3;
    end
  z=zaux';
  end

end