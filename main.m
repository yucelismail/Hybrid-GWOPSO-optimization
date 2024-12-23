% Bu betik, PSO ve GWO optimizasyon algoritmasının hibrit bir versiyonunu uygular.
% Bu kod, https://free-thesis.com adresinde geliştirilmiştir.
% https://in.mathworks.com/matlabcentral/fileexchange/44974-grey-wolf-optimizer-gwo
% adresindeki GWO kodu genişletilerek PSO ile hibrit hale getirilmiş ve GWO'dan daha iyi bir versiyon oluşturulmuştur.

%%

clear all 
clc
close all

SearchAgents_no=30; % Arama aracılarının sayısı

Function_name='F18'; % F1'den F23'e kadar olabilen test fonksiyonunun adı (Makaledeki Tablo 1,2,3)

Max_iteration=500; % Maksimum yineleme sayısı

% Seçili kıyaslama fonksiyonunun yükleme ayrıntıları
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);

[Best_score,Best_pos,PSOGWO_cg_curve]=PSOGWO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
[Alpha_score,Alpha_pos,GWO_cg_curve]=GWO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);

figure('Position',[500 500 660 290])
%Arama alanını çiz
subplot(1,2,1);
func_plot(Function_name);
title('Parameter space')
xlabel('x_1');
ylabel('x_2');
zlabel([Function_name,'( x_1 , x_2 )'])

%Hedef alanı çiz
subplot(1,2,2);
semilogy(PSOGWO_cg_curve,'Color','r')
hold on
semilogy(GWO_cg_curve,'Color','b')
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');

axis tight
grid on
box on
legend('PSOGWO','GWO')

display(['The best solution obtained by PSOGWO is : ', num2str(Best_pos)]);
display(['The best optimal value of the objective funciton found by PSOGWO is : ', num2str(Best_score)]);
display(['The best solution obtained by GWO is : ', num2str(Alpha_pos)]);
display(['The best optimal value of the objective funciton found by GWO is : ', num2str(Alpha_score)]);
        
