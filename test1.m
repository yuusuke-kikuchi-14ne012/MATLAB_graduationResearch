rootname = 'sample/ééóø1/êÿî≤Ç´Åi550Å~1500Åj/sm'; 
extension = '.jpg';
scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)])

for i = -10:90
    try
        filename = [rootname, num2str(i), extension];        
        RGB = imread(filename);
        r = RGB(:,:,1);
        g = RGB(:,:,2);
        b = RGB(:,:,3);  
        subplot(1,2,1), imshow(RGB)
        subplot(1,2,2), histogram(r,'BinMethod','integers','FaceColor','r','EdgeAlpha',0,'FaceAlpha',1)
                        hold on
                        histogram(g,'BinMethod','integers','FaceColor','g','EdgeAlpha',0,'FaceAlpha',0.7)
                        histogram(b,'BinMethod','integers','FaceColor','b','EdgeAlpha',0,'FaceAlpha',0.7)
                        xlabel('RGB value')
                        ylabel('Frequency')
                        title(i)
                        xlim([0 257])
                        ylim([0 15000])
                        hold off
        savename = [rootname, num2str(i)];
        saveas(gcf,savename,'png')
        pause(1.5);
    catch
        continue
    end
end

close;