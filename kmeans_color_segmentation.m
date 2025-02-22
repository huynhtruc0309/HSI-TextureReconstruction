% Do color segmentation by kmeans classification.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 16;

% Check that user has the Image Processing Toolbox installed and licensed.
hasLicenseForToolbox = license('test', 'image_toolbox');   % license('test','Statistics_toolbox'), license('test','Signal_toolbox')
if ~hasLicenseForToolbox
	% User does not have the toolbox installed, or if it is, there is no available license for it.
	% For example, there is a pool of 10 licenses and all 10 have been checked out by other people already.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end
% Check that user has the Statistics and Machine Learning Toolbox installed and licensed.
hasLicenseForToolbox = license('test','Statistics_toolbox');
if ~hasLicenseForToolbox
	% User does not have the toolbox installed, or if it is, there is no available license for it.
	% For example, there is a pool of 10 licenses and all 10 have been checked out by other people already.
	message = sprintf('Sorry, but you do not seem to have the Statistics and Machine Learning Toolbox Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end

%===============================================================================
% Get the name of the demo image the user wants to use.
% Lighthouse.png is a good one.
% Let's let the user select from a list of all the demo images that ship with the Image Processing Toolbox.
folder = fileparts(which('cameraman.tif')); % Determine where demo folder is (works with all versions).
% Demo images have extensions of TIF, PNG, and JPG.  Get a list of all of them.
imageFiles = [dir(fullfile(folder,'*.TIF')); dir(fullfile(folder,'*.PNG')); dir(fullfile(folder,'*.jpg'))];
for k = 1 : length(imageFiles)
	% 	fprintf('%d: %s\n', k, files(k).name);
	[~, baseFileName, extension] = fileparts(imageFiles(k).name);
	ca{k} = [baseFileName, extension];
end
% Sort the base file names alphabetically.
[ca, sortOrder] = sort(ca);
imageFiles = imageFiles(sortOrder);
button = menu('Use which gray scale demo image?', ca); % Display all image file names in a popup menu.
% Get the base filename.
baseFileName = imageFiles(button).name; % Assign the one on the button that they clicked on.
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
% fullFileName = 'C:\Users\Mark\Documents\MATLAB\work\Tests\cotton25.jpg'
%===============================================================================
% Read in the standard MATLAB color demo image that the user chose.
if ~exist(fullFileName, 'file')
	% Didn't find it there.  Check the search path for it.
	fullFileName = baseFileName; % No path this time.
	if ~exist(fullFileName, 'file')
		% Still didn't find it.  Alert user.
		errorMessage = sprintf('Error: %s does not exist.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
rgbImage = imread(fullFileName);
% Get the dimensions of the image.  numberOfColorChannels should be = 3.
[rows, columns, numberOfColorChannels] = size(rgbImage);
% Make sure it's a color image
if numberOfColorChannels ~= 3
	message = sprintf('You need to select an RGB image.');
	uiwait(errordlg(message));
	return;
end
% Display the original color image.
subplot(2, 2, 1);
imshow(rgbImage);
title('Original Color Image', 'FontSize', fontSize, 'Interpreter', 'None');
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1], 'Name', 'Color Channels');

% Extract the individual red, green, and blue color channels.
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);

% Display the color channels.
subplot(2, 2, 2);
imshow(redChannel);
title('Red Channel Image', 'FontSize', fontSize, 'Interpreter', 'None');
subplot(2, 2, 3);
imshow(greenChannel);
title('Green Channel Image', 'FontSize', fontSize, 'Interpreter', 'None');
subplot(2, 2, 4);
imshow(blueChannel);
title('Blue Channel Image', 'FontSize', fontSize, 'Interpreter', 'None');

%----------------------------------------------------------------------------------------
% Ask user how many color classes they want.
defaultValue = 5;
titleBar = 'Enter an integer value';
userPrompt = 'Enter the number of color classes to find (2 through 6)';
caUserInput = inputdlg(userPrompt, titleBar, 1, {num2str(defaultValue)});
if isempty(caUserInput),return,end % Bail out if they clicked Cancel.
% Round to nearest integer in case they entered a floating point number.
numberOfClasses = round(str2double(cell2mat(caUserInput)));
% Check for a valid integer.
if isnan(numberOfClasses) || numberOfClasses < 2 || numberOfClasses > 6
	% They didn't enter a number.
	% They clicked Cancel, or entered a character, symbols, or something else not allowed.
	numberOfClasses = defaultValue;
	message = sprintf('I said it had to be an integer.\nTry replacing the user.\nI will use %d and continue.', numberOfClasses);
	uiwait(warndlg(message));
end

%----------------------------------------------------------------------------------------
%  KMEANS CLASSIFICATION RIGHT HERE!!!
% Get the data for doing kmeans.  We will have 3 columns, each with one color channel.
% Need to cast it to double or else kmeans will throw an error for uint8 data.
data = double([redChannel(:), greenChannel(:), blueChannel(:)]);
% data is an N-by-3 list of RGB colors.  Using (:) converts each 2-D matrix into a column.
% Each row of data represents one pixel (observation), so we have
% [r1, g1, b1;
%  r2, g2, b2;
%  r3, g3, b3;
%     etc.
%  rN, gN, bN];
% For as many pixels as we have in the image.
% Now, ask kmeans() to decide which cluster each pixel belongs to.
indexes = kmeans(data, numberOfClasses);

%----------------------------------------------------------------------------------------
% Let's convert what class index the pixel is into images for each class index.
% Since indexes is just a 1-D vector of indexe, we need to reshape it back into a 2-D image.
% Doing indexes == n will give the same size vector (one element for every pixel in the image)
% but will be 0 for elements that don't have value n, and 1 for elements that do have value n.
class1 = reshape(indexes == 1, rows, columns);
class2 = reshape(indexes == 2, rows, columns);
class3 = reshape(indexes == 3, rows, columns);
class4 = reshape(indexes == 4, rows, columns);
class5 = reshape(indexes == 5, rows, columns);
class6 = reshape(indexes == 6, rows, columns);
% Let's put these into a 3-D array for later to make it easy to display them all with a loop.
allClasses = cat(3, class1, class2, class3, class4, class5, class6);
allClasses = allClasses(:, :, 1:numberOfClasses); % Crop off just what we need.
% OK!  WE'RE ALL DONE!.  Nothing left now but to display our classification images.

% Plot the 3-D color gamut.  This works only in R2016b or later.
v = ver;
theYear = str2double(v(1).Release(3:end-2))
if theYear >= 2016 || (theYear == 2016 && strcmpi(v(1).Release(end-1), 'b'))
	colorcloud(rgbImage);
	title('RGB Color Cloud (3-D Color Gamut)', 'FontSize', fontSize, 'Interpreter', 'None');
	% Enlarge figure to nearfull screen.
	set(gcf, 'Units', 'Normalized', 'Outerposition', [0.05, 0.05, 0.9, 0.9], 'Name', 'Color classes');
end

%----------------------------------------------------------------------------------------
% Compute an indexed image for comparison;
[indexedImage, customColorMap]  = rgb2ind(rgbImage, numberOfClasses);
figure; % Bring up new figure.
% Display the color channels again on this new figure.
subplotCols = max([4, numberOfClasses]); % Make sure we have enough columns to show the top 4 plots.
subplot(3, subplotCols, 1);
imshow(rgbImage);
fontSize = 12; % Needs a smaller font.
title('RGB Color Image', 'FontSize', fontSize, 'Interpreter', 'None');
% subplot(3, numberOfClasses, 2);
h3 = subplot(3, subplotCols, 2);
imshow(indexedImage, []);
colormap(h3, customColorMap);
colorbar;
caption = sprintf('Indexed (quantized) Image\nusing rgb2ind()');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

% Enlarge figure to near full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0.1, 0.1, 0.8, 0.8], 'Name', 'Color classes');

% Display the classes, both binary and masking the original.
% Also make an indexes image so we can display each class in a unique color.
indexedImageK = zeros(size(indexedImage), 'uint8'); % Initialize another indexed image.
for c = 1 : numberOfClasses
	% Display binary image of what pixels have this class ID number.
	subplot(3, subplotCols, c + numberOfClasses);
	thisClass = allClasses(:, :, c);
	imshow(thisClass);
	caption = sprintf('Image of\nClass %d Indexes', c);
	title(caption, 'FontSize', fontSize);

	% Mask the image using bsxfun() function
	maskedRgbImage = bsxfun(@times, rgbImage, cast(thisClass, 'like', rgbImage));
	% Display masked image.
	subplot(3, subplotCols, c + 2 * numberOfClasses);
	imshow(maskedRgbImage);
	caption = sprintf('Class %d Image\nMasking Original', c);
	title(caption, 'FontSize', fontSize);
	
	% Make indexed image
	indexedImageK(thisClass) = c;
end

% Display the image, indexed by kmeans, in pseudocolor.
h5 = subplot(3, subplotCols, 3);
kmeansCustomColorMap = [lines(numberOfClasses)];
imshow(indexedImageK, 'Colormap', kmeansCustomColorMap);
caxis([1, numberOfClasses]); % Make bottom of colormap apply to the first class.
colorbar;
caption = sprintf('Indexed (quantized) Image\nusing kmeans()');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

% Show a pie chart with the proportions of the various classes.
counts = histcounts(indexedImage);
counts = 100 * counts / sum(counts); % Normalize to 100 percent.
h3 = subplot(3, subplotCols, 4);
for k = 1 : numberOfClasses
	pieLabels{k} = sprintf('Class %d = %.1f%%', k, counts(k));
end
patchOrTextObects = pie(counts, pieLabels);
% Give pie chart the same colors as our image, class for class.
% Unfortunately, as of 2020b there is no way to pass a colormap into pie() so we have to set each patch individually.
colorMapIndex = 1;
for k = 1 : length(patchOrTextObects)
	if contains(patchOrTextObects(k).Type, 'patch', 'IgnoreCase', true) % Do only patch objects, not text objects.
		thisSlicesColor = kmeansCustomColorMap(colorMapIndex, :)
		patchOrTextObects(k).FaceColor =thisSlicesColor; % Row 1 is 0 (black) 
		colorMapIndex = colorMapIndex + 1;
	end
end
caption = sprintf('Area Fractions using kmeans()');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

message = sprintf('Note: class numbers assigned by rgb2ind and kmeans may be different, so the color at each pixel may differ');
helpdlg(message);
