% Gri Kurt Optimizasyonu
function [Alpha_score,Alpha_pos,Convergence_curve]=GWO(SearchAgents_no,Max_iter,lb,ub,dim,fobj)
% alpha, beta ve delta_pos'u başlat
Alpha_pos=zeros(1,dim);
Alpha_score=inf; %Maksimizasyon problemleri için bunu -inf olarak değiştirin
Beta_pos=zeros(1,dim);
Beta_score=inf; %Maksimizasyon problemleri için bunu -inf olarak değiştirin

Delta_pos=zeros(1,dim);
Delta_score=inf;%Maksimizasyon problemleri için bunu -inf olarak değiştirin

%Arama aracılarının konumlarını başlat
Positions=initialization(SearchAgents_no,dim,ub,lb);
Convergence_curve=zeros(1,Max_iter);
velocity = .3*randn(SearchAgents_no,dim) ;
w=0.5+rand()/2;
l=0;% Loop counter

% Ana döngü
while l<Max_iter
    for i=1:size(Positions,1)
        
       % Arama alanının sınırlarını aşan arama aracılarını geri döndür
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
       % Her arama aracısı için hedef fonksiyonunu hesapla
        fitness=fobj(Positions(i,:));
        
       % Alfa, Beta ve Delta'yı güncelle
        if fitness<Alpha_score
            Alpha_score=fitness; % Alfa güncellemesi
            Alpha_pos=Positions(i,:);
        end
        
        if fitness>Alpha_score && fitness<Beta_score
            Beta_score=fitness; % Beta güncellemesi
            Beta_pos=Positions(i,:);
        end
        
        if fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score
            Delta_score=fitness; % Deltayı güncelle
            Delta_pos=Positions(i,:);
        end
    end
    
    
    a=2-l*((2)/Max_iter); % a 2'den 0'a doğrusal olarak azalır
    
   % Omegalar dahil arama aracılarının konumunu güncelle
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)
            
            r1=rand(); % r1 is a random number in [0,1]
            r2=rand(); % r2 is a random number in [0,1]
            
            A1=2*a*r1-a; % Denklem (3.3)
           %C1=2*r2; % Denklem (3.4)
            C1=0.5;
            
            D_alpha=abs(C1*Alpha_pos(j)-w*Positions(i,j)); % Denklem (3.5)-bölüm 1
            X1=Alpha_pos(j)-A1*D_alpha; % Denklem (3.6)-bölüm 1
            
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a; % Denklem (3.3)
            %C2=2*r2; % Denklem (3.4)
            C2=0.5;
            
            D_beta=abs(C2*Beta_pos(j)-w*Positions(i,j)); % Denklem (3.5)-bölüm 2
            X2=Beta_pos(j)-A2*D_beta; % Denklem (3.6)-bölüm 2
            
            r1=rand();
            r2=rand();
            r3=rand();
            A3=2*a*r1-a; % Denklem (3.3)
            %C3=2*r2; % Denklem (3.4)
            C3=0.5;
            D_delta=abs(C3*Delta_pos(j)-w*Positions(i,j)); % Denklem (3.5)-bölüm 3
            X3=Delta_pos(j)-A3*D_delta; % Denklem (3.5)-bölüm 3
            
            % hız güncellemesi
            velocity(i,j)=w*(velocity(i,j)+C1*r1*(X1-Positions(i,j))+C2*r2*(X2-Positions(i,j))+C3*r3*(X3-Positions(i,j)));
            
           % pozisyon güncellemesi
            Positions(i,j)=Positions(i,j)+velocity(i,j);
        end
    end
    
    l=l+1;
    Convergence_curve(l)=Alpha_score;
end
