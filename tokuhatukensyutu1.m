%�ΏۃI�u�W�F�N�g���܂ގQ�ƃC���[�W��ǂݎ��܂��B
x = imread('sample/����1/�ؔ����i550�~1500�j/sm0.jpg');
boxImage = rgb2gray(x);
figure;
imshow(boxImage);
title('Image of a Box');

%�v�f�̑����V�[�����܂ރ^�[�Q�b�g �C���[�W��ǂݎ��܂��B
y = imread('sample/����1/sm1.jpg');
sceneImage = rgb2gray(y);
figure;
imshow(sceneImage);
title('Image of a Cluttered Scene');

%�����̃C���[�W�œ����_�����o���܂��B
boxPoints = detectSURFFeatures(boxImage);
scenePoints = detectSURFFeatures(sceneImage);

%�Q�ƃC���[�W�Ō��o���ꂽ�ł����������_���������܂��B
figure;
imshow(boxImage);
title('100 Strongest Feature Points from Box Image');
hold on;
plot(selectStrongest(boxPoints, 100));

%�^�[�Q�b�g�C���[�W�Ō��o���ꂽ�ł����������_���������܂��B
figure;
imshow(sceneImage);
title('300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 300));

%�����̃C���[�W���̊֐S�_�ɂ���������L�q�q�𒊏o���܂��B

[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

%�����L�q�q���g�p���ē������}�b�`���O���܂��B
boxPairs = matchFeatures(boxFeatures, sceneFeatures);

%�}�b�`�ł���Ɛ��肳��������\�����܂��B
matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
figure;
showMatchedFeatures(boxImage, sceneImage, matchedBoxPoints, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');

%estimateGeometricTransform �́A�O��l��r�����Ȃ���A�}�b�`�����_���֘A�t����ϊ����v�Z���܂��B���̕ϊ��ɂ���ăV�[�����̃I�u�W�F�N�g�̈ʒu������ł��܂��B
[tform, inlierBoxPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');

%�O��l���폜���������ŁA�}�b�`����_�̃y�A��\�����܂��B
figure;
showMatchedFeatures(boxImage, sceneImage, inlierBoxPoints, ...
    inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');

%�Q�ƃC���[�W�̋��E���p�`���擾���܂��B
boxPolygon = [1, 1;...                           % top-left
        size(boxImage, 2), 1;...                 % top-right
        size(boxImage, 2), size(boxImage, 1);... % bottom-right
        1, size(boxImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon
    
%���̑��p�`���^�[�Q�b�g �C���[�W�̍��W�n�ɕϊ����܂��B�ϊ���̑��p�`�́A�V�[�����̃I�u�W�F�N�g�̈ʒu�������Ă��܂��B
newBoxPolygon = transformPointsForward(tform, boxPolygon);

%���o�����I�u�W�F�N�g��\�����܂��B
figure;
imshow(y);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
title('Detected Box');