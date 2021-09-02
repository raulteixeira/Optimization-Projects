%------------------------------------------------------------
%-------------FUNÇÕES MÉTODO PREDITOR CORRETOR---------------

function t=tampasso(x,dx,n)
  
  epslon=10^-8;
  tau=0.99995;
  j=1;
  
  for i=1:n
    
    if dx(i)<0
      h(j)=(-x(i))/(dx(i));
      j++;
    end
    
  end
  
  t=tau*min(h);
  
end