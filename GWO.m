% Gri Kurt Optimizasyonu
function [Alpha_score,Alpha_pos,Convergence_curve]=GWO(SearchAgents_no,Max_iter,lb,ub,dim,fobj)
% alpha, beta ve delta_pos'u başlat
Alpha_pos=zeros(1,dim);
Alpha_score=inf; % Maksimizasyon problemleri için bunu -inf olarak değiştirin

Beta_pos=zeros(1,dim);
Beta_score=inf; % Maksimizasyon problemleri için bunu -inf olarak değiştirin

Delta_pos=zeros(1,dim);
Delta_score=inf; % Maksimizasyon problemleri için bunu -inf olarak değiştirin

% Arama ajanlarının pozisyonlarını başlat
Positions=initialization(SearchAgents_no,dim,ub,lb);
Convergence_curve=zeros(1,Max_iter);

l=1;% Döngü sayacı

% Ana döngü
while l<Max_iter
    for i=1:size(Positions,1)
        
        % Arama uzayının sınırlarını aşan ajanları geri döndür
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        % Her bir arama ajanı için hedef fonksiyonu hesapla
        fitness=fobj(Positions(i,:));
        
        % Alpha, Beta ve Delta'yı güncelle
        if fitness<Alpha_score
            Alpha_score=fitness; % Alpha'yı güncelle
            Alpha_pos=Positions(i,:);
        end
        
        if fitness>Alpha_score && fitness<Beta_score
            Beta_score=fitness; % Beta'yı güncelle
            Beta_pos=Positions(i,:);
        end
        
        if fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score
            Delta_score=fitness; % Delta'yı güncelle
            Delta_pos=Positions(i,:);
        end
    end
    
    
    a=2-l*((2)/Max_iter); % a, 2'den 0'a doğru lineer olarak azalır
    
    % Omega kurtlarını da içeren arama ajanlarının pozisyonlarını güncelle
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)
            
            r1=rand(); % r1, [0,1] aralığında rastgele bir sayı
            r2=rand(); % r2, [0,1] aralığında rastgele bir sayı
            
            A1=2*a*r1-a; % Denklem (3.3)
            C1=2*r2; % Denklem (3.4)
            
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j)); % Denklem (3.5)-1. kısım
            X1=Alpha_pos(j)-A1*D_alpha; % Denklem (3.6)-1. kısım
            
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a; % Denklem (3.3)
            C2=2*r2; % Denklem (3.4)
            
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); % Denklem (3.5)-2. kısım
            X2=Beta_pos(j)-A2*D_beta; % Denklem (3.6)-2. kısım
            
            r1=rand();
            r2=rand();
           
            A3=2*a*r1-a; % Denklem (3.3)
            C3=2*r2; % Denklem (3.4)
            
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j)); % Denklem (3.5)-3. kısım
            X3=Delta_pos(j)-A3*D_delta; % Denklem (3.5)-3. kısım
            
            
            Positions(i,j)=(X1+X2+X3)/3;
        end
    end
    
    l=l+1;
    Convergence_curve(l)=Alpha_score;
end
