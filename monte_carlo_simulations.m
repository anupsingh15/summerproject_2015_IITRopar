%% monte carlo simulations of dynamical model
clc
clear all
%% Input Parameters
L=100;                                         % no. of sites in one lane
% No. of sites occupied initially in lane 1 and 2
M=int8(0.05*L);
N=int8(0.05*L);
nsteps=10000000;                                % no. of time steps
nignored=0.05*nsteps;
dt=1;
T=nignored*dt;                                  % ignored time
Time=nsteps*dt;                                 % total time
alpha=0.6;                                      % injection rate
beta=0.2;                                      % removal rate
%constants
p1=1;
q1=1-p1;
p2=1;
q2=1-p2;
w1=1;                                         % rate of lane changing from 1 to 2
w2=1;                                         % rate of lane changing from 2 to 1
%defining arrays
A=zeros(1,L);
B=zeros(1,L);
%% INITIAL DISTRIBUTION
Rn=randperm(L);
U=Rn(1:M);
V=Rn(3:N+2);
% U=[2 4 7];
% V=[5 7];
A(U(:))=1;
B(V(:))=1;
tic
for r=1:L
    density_1(r)=0;
    density_2(r)=0;
end
%% dynamical rules
count=0;
for m=1:nsteps
    R=randperm(L);
     % case 1
    site=rand;
       if site<= 0.5 
             random_site_1=R(1);
             if random_site_1==1
                     if A(1)==0
                         r1=rand;
                            if r1 <= alpha
                               A(1)=1;
                            end
                     else 
                            if A(2)==0
                                r2=rand;
                                if r2<=p1
                                   A(2)=1;
                                   A(1)=0;
                                end
                            end
                     end
             end
             if random_site_1==L
                    if A(L)==1
%                         if B(L)==0
%                             r3=rand;
%                             if r3 <=w1
%                                 B(L)=1;
%                                 A(L)=0;
%                             else 
%                                 if r3<=beta*(1-w1)
%                                     A(L)=0;
%                                 end
%                             end
%                         else
                            r4=rand;
                        if r4<=beta
                                A(L)=0;
%                             end
                        end
                    end  
             end
             if random_site_1~=1 && random_site_1~=L
                 i=random_site_1;
%                  if A(i)==1
                            % when three possible sites are vacant
                            if (A(i)==1 && A(i+1)==0 && A(i-1)==0 && B(i)==0)
                                rate_r=p1*(1-w1);           % rate of hopping right
                                rate_l=q1*(1-w1);           % rate of hopping left
                                rate_v=w1;                  % rate of hopping vertical
                                r5=rand;
                                if r5<= rate_r
                                    A(i+1)=1;
                                    A(i)=0;
                                elseif r5<=rate_r+rate_l
                                    A(i-1)=1;
                                    A(i)=0;
                                else B(i)=1;
                                    A(i)=0;
                                end
                            end
                            % when two sites are vacant(right and left)
                            if (A(i)==1 && A(i+1)==0 && A(i-1)==0 && B(i)==1)
                                rate_r=p1;                   % rate of hopping right
                                rate_l=q1;                   % rate of hopping left
                                r6=rand;
                                if r6<=rate_r
                                    A(i+1)=1;
                                    A(i)=0;
                                else A(i-1)=1;
                                    A(i)=0;
                                end
                            end
                                % when two sites are vacant(right and vertical)
                            if (A(i)==1 && A(i+1)==0 && A(i-1)==1 && B(i)==0)
                                rate_r=p1*(1-w1);                   % rate of hopping right
                                rate_v=w1;                          % rate of hopping vertical
                                r7=rand;
                                if r7<=rate_r
                                    A(i+1)=1;
                                    A(i)=0;
                                else 
                                    if r7<=rate_v
                                        B(i)=1;
                                        A(i)=0;
                                    end
                                end
                            end
                            % when two sites are vacant(left and vertical)
                            if (A(i)==1 && A(i+1)==1 && A(i-1)==0 && B(i)==0)
                                rate_l=q1*(1-w1);                   % rate of hopping left
                                rate_v=w1;                          % rate of hopping vertical
                                r8=rand;
                                if r8<=rate_l
                                    A(i-1)=1;
                                    A(i)=0;
                                else 
                                    if r8<=rate_v
                                        B(i)=1;
                                        A(i)=0;
                                    end
                                end
                            end
                            % when one site is vacant(right)
                            if (A(i)==1 && A(i+1)==0 && A(i-1)==1 && B(i)==1)
                                rate_r=p1;                           % rate of hopping right
                                r9=rand;
                                if r9<=rate_r
                                    A(i+1)=1;
                                    A(i)=0;
                                end
                            end
                            % when one site is vacant(left)
                            if (A(i)==1 && A(i+1)==1 && A(i-1)==0 && B(i)==1)
                                rate_l=q1;                           % rate of hopping left
                                r10=rand;
                                if r10<=rate_l
                                    A(i-1)=1;
                                    A(i)=0;
                                end
                            end
                            % when one site is vacant(vertical)
                            if (A(i)==1 && A(i+1)==1 && A(i-1)==1 && B(i)==0)
                                rate_v=w1;                           % rate of hopping vertical
                                r11=rand;
                                if r11<=rate_v
                                    B(i)=1;
                                    A(i)=0;
                                end
                            end
%                  end
             end
             % lane 2 is selected
        else
            random_site_2=R(1);
             if random_site_2==1
                     if B(1)==0
                         r12=rand;
                            if r12 <= alpha
                               B(1)=1;
                            end
                     else 
                            if B(2)==0
                                r13=rand;
                                if r13<=p2
                                   B(2)=1;
                                   B(1)=0;
                                end
%                             else if A(1)==0
%                                     s=rand;
%                                     if s<=w2
%                                         A(1)=1;
%                                         B(1)=0;
%                                     end
%                                 end
                            end
                     end
             end
             if random_site_2==L
                    if B(L)==1
%                         if A(L)==0
%                             r14=rand;
%                             if r14 <=w2
%                                 A(L)=1;
%                                 B(L)=0;
%                             else 
%                                 if r14<=beta*(1-w2)
%                                     B(L)=0;
%                                 end
%                             end
%                         else
                            r15=rand;
                            if r15<=beta
                                B(L)=0;
                            end
                        end
             end  
             if random_site_2~=1 && random_site_2~=L
                 j=random_site_2;
%                  if B(j)==1
                            % when three possible sites are vacant
                            if (B(j)==1 && B(j+1)==0 && B(j-1)==0 && A(j)==0)
                                rate_r=p2*(1-w2);           % rate of hopping right
                                rate_l=q2*(1-w2);           % rate of hopping left
                                rate_v=w2;                  % rate of hopping vertical
                                r16=rand;
                                if r16<= rate_r
                                    B(j+1)=1;
                                    B(j)=0;
                                elseif r16<=rate_r+rate_l
                                    B(j-1)=1;
                                    B(j)=0;
                                else A(j)=1;
                                    B(j)=0;
                                end
                            end
                            % when two sites are vacant(right and left)
                            if (B(j)==1 && B(j+1)==0 && B(j-1)==0 && A(j)==1)
                                rate_r=p2;                   % rate of hopping right
                                rate_l=q2 ;                  % rate of hopping left
                                r17=rand;
                                if r17<=rate_r
                                    B(j+1)=1;
                                    B(j)=0;
                                else B(j-1)=1;
                                    B(j)=0;
                                end
                            end
                                % when two sites are vacant(right and vertical)
                            if (B(j)==1 && B(j+1)==0 && B(j-1)==1 && A(j)==0)
                                rate_r=p2*(1-w2);                   % rate of hopping right
                                rate_v=w2;                          % rate of hopping vertical
                                r18=rand;
                                if r18<=rate_r
                                    B(j+1)=1;
                                    B(j)=0;
                                else 
                                    if r18<=rate_v
                                        A(j)=1;
                                        B(j)=0;
                                    end
                                end
                            end
                            % when two sites are vacant(left and vertical)
                            if (B(j)==1 && B(j+1)==1 && B(j-1)==0 && A(j)==0)
                                rate_l=q2*(1-w2);                   % rate of hopping left
                                rate_v=w2;                          % rate of hopping vertical
                                r19=rand;
                                if r19<=rate_l
                                    B(j-1)=1;
                                    B(j)=0;
                                else 
                                    if r19<=rate_v
                                        A(j)=1;
                                        B(j)=0;
                                    end
                                end
                            end
                            % when one site is vacant(right)
                            if (B(j)==1 && B(j+1)==0 && B(j-1)==1 && A(j)==1)
                                rate_r=p2;                          % rate of hopping right
                                r20=rand;
                                if r20<=rate_r
                                    B(j+1)=1;
                                    B(j)=0;
                                end
                            end
                            % when one site is vacant(left)
                            if (B(j)==1 && B(j+1)==1 && B(j-1)==0 && A(j)==1)
                                rate_l=q2;                           % rate of hopping left
                                r21=rand;
                                if r21<=rate_l
                                    B(j-1)=1;
                                    B(j)=0;
                                end
                            end
                            % when one site is vacant(vertical)
                            if (B(j)==1 && B(j+1)==1 && B(j-1)==1 && A(j)==0)
                                rate_v=w2;                           % rate of hopping vertical
                                r22=rand;
                                if r22<=rate_v
                                    A(j)=1;
                                    B(j)=0;
                                end
                            end
%                  end
             end
        end
        % computation of densities
    if m> nignored
        if rem(m,10*L)==0
            count=count+1;
            for r=1:L
                if A(r)==1
                    density_1(r)=density_1(r)+1;
                end
            end
            for t=1:L
                if B(t)==1
                    density_2(t)=density_2(t)+1;
                end
            end
        end
    end
    
   
end
%% compuatation
for i=1:L
    rho_1(i)=density_1(i)/count;
    rho_2(i)=density_2(i)/count;
    h(i)=i/L;
end
plot(h,rho_1,'r')
hold on
plot(h,rho_2,'b')
toc

