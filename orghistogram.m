rootname = 'sample/ééóø1/êÿî≤Ç´Åi550Å~1500Åj/sm'; 
extension = '.jpg';
scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)])

for i = -10:90
    try
        filename = [rootname, num2str(i), extension];
        [X1,map1] = imread(filename);        
        subplot(1,2,1), imshow(X1,map1)
        subplot(1,2,2), histogram([X1,map1],'Normalization','probability')
        xlim([0 257])
        ylim([0 0.012])
        title(i)
        savename = [rootname, num2str(i)];
        saveas(gcf,savename,'png')
        pause(1.5);
    catch
        continue
    end
end

close;