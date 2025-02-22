% Demo to show how to use Discriminant Analysis classification to classify color images into a specified number of color classes.
function Classify_RGB_Image()
try
	clc;    % Clear the command window.
	close all;  % Close all figures (except those of imtool.)
	clear;  % Erase all existing variables. Or clearvars if you want.
	workspace;  % Make sure the workspace panel is showing.
	format long g;
	format compact;
	fontSize = 20;
	
	% Check that user has the specified Toolbox installed and licensed.
	hasLicenseForToolbox = license('test', 'image_toolbox');
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
	
	% Check that user has the specified Toolbox installed and licensed.
	hasLicenseForToolbox = license('test', 'Statistics_toolbox');
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
	
	%-----------------------------------------------------------------------------------------------------------------------------
	% Have user browse for a file, from a specified "starting folder."
	% For convenience in browsing, set a starting folder from which to browse.
 	startingFolder = pwd;
% 	startingFolder = fileparts(which('cameraman.tif')); % Determine where demo folder is (works with all versions).
	if ~exist(startingFolder, 'dir')
		% If that folder doesn't exist, just start in the current folder.
		startingFolder = pwd;
	end
	% Get the name of the file that the user wants to use.
	defaultFileName = fullfile(startingFolder, '*.*');
	[baseFileName, folder] = uigetfile(defaultFileName, 'Select an image file');
	if baseFileName == 0
		% User clicked the Cancel button.
		return;
	end
	fullFileName = fullfile(folder, baseFileName);
	rgbImage = imread(fullFileName);
	imshow(rgbImage);
	title('Original Image', 'FontSize', fontSize);
	% Need to put up a color bar to get the size and location of the image right so we can "flicker" between
	% classified images and original image without the image shifting.
	colorbar;
	% Get the dimensions of the image.
	% numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
	[rows, columns, numberOfColorChannels] = size(rgbImage);
	
	%-----------------------------------------------------------------------------------------------------------------------------
	% Set up figure properties:
	% Enlarge figure to full screen.
	set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
	% Get rid of tool bar and pulldown menus that are along top of figure.
	% set(gcf, 'Toolbar', 'none', 'Menu', 'none');
	% Give a name to the title bar.
	set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off')
	
	%-----------------------------------------------------------------------------------------------------------------------------
	% Get training set by having the user lassoo regions in the image for each class.
	% Each drawn region will be of roughly the same color, e.g. greenish, bluish, etc.
	% Each pixel in the training set will have a known, assigned class number.
	[pixelColors, meanColors, outlines] = GetClassMeans(rgbImage);
	if isempty(pixelColors)
		return;
	end
	% Extract just the RGB values.
	training = pixelColors(:, 1:3);
	% Extract just the group/class number of the region.
	group = pixelColors(:, 4);
	% meanColors = grpstats(training, group, 'mean')
	% Draw outlines over image.
	hold on;
	numberOfClasses = length(outlines);
	for k = 1 : numberOfClasses
		thisOutline = outlines{k};
		x = thisOutline(:, 1);
		y = thisOutline(:, 2);
		% Need to add first point as the final point otherwise the curve is not closed.
		x(end + 1) = x(1);
		y(end + 1) = y(1);
		plot(x, y, 'r', 'LineWidth', 2);
	end

	%-----------------------------------------------------------------------------------------------------------------------------
	% Get test/sample/unknown set - basically the whole image.
	% First, extract the individual red, green, and blue color channels.
	redChannel = rgbImage(:, :, 1);
	greenChannel = rgbImage(:, :, 2);
	blueChannel = rgbImage(:, :, 3);
	% Now put them into an N-by-3 matrix of RGB values.
	sample = [redChannel(:), greenChannel(:), blueChannel(:)];
	
	%-----------------------------------------------------------------------------------------------------------------------------
	% Try different classification algorithms: linear, diaglinear, quadratic, and diagquadratic.
	classifiedImage1 = ClassifyImage(sample, training, group, meanColors, rows, columns, 'linear');
	classifiedImage2 = ClassifyImage(sample, training, group, meanColors, rows, columns, 'diaglinear');
	classifiedImage3 = ClassifyImage(sample, training, group, meanColors, rows, columns, 'quadratic');
	classifiedImage4 = ClassifyImage(sample, training, group, meanColors, rows, columns, 'diagquadratic');
	classifiedImage5 = ClassifyImage(sample, training, group, meanColors, rows, columns, 'mahalanobis');
	
	%-----------------------------------------------------------------------------------------------------------------------------
	% Show all the different methods on one figure:
	figure;
	subplot(2, 3, 1);
	imshow(rgbImage);
	title(gca, 'Original RGB Image', 'FontSize', fontSize);
	% Enlarge figure to full screen.
	set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
	
	% Draw outlines over image.
	hold on;
	for k = 1 : numberOfClasses
		thisOutline = outlines{k};
		x = thisOutline(:, 1);
		y = thisOutline(:, 2);
		% Need to add first point as the final point otherwise the curve is not closed.
		x(end + 1) = x(1);
		y(end + 1) = y(1);
		plot(x, y, 'r', 'LineWidth', 2);
	end
	hold off;
	set(gcf, 'Name', 'Discriminant Analysis Demo by ImageAnalyst', 'NumberTitle', 'Off')
	
	subplot(2, 3, 2);
	imshow(classifiedImage1);
	title(gca, 'Linear DA', 'FontSize', fontSize);
	% Apply colormap where each class appears in the mean color for that particular class.
	colormap(gca, meanColors/255);
	colorbar;
	caxis([1, numberOfClasses]);
	
	subplot(2, 3, 3);
	imshow(classifiedImage2);
	title(gca, 'DiagLinear DA', 'FontSize', fontSize);
	% Apply colormap where each class appears in the mean color for that particular class.
	colormap(gca, meanColors/255);
	colorbar;
	caxis([1, numberOfClasses]);
	
	subplot(2, 3, 4);
	imshow(classifiedImage3);
	title(gca, 'Quadratic DA', 'FontSize', fontSize);
	% Apply colormap where each class appears in the mean color for that particular class.
	colormap(gca, meanColors/255);
	colorbar;
	caxis([1, numberOfClasses]);
	
	subplot(2, 3, 5);
	imshow(classifiedImage4);
	title(gca, 'DiagQuadratic DA', 'FontSize', fontSize);
	% Apply colormap where each class appears in the mean color for that particular class.
	colormap(gca, meanColors/255);
	colorbar;
	caxis([1, numberOfClasses]);
	
	subplot(2, 3, 6);
	imshow(classifiedImage5);
	title(gca, 'Mahalanobis DA', 'FontSize', fontSize);
	% Apply colormap where each class appears in the mean color for that particular class.
	colormap(gca, meanColors/255);
	colorbar;
	caxis([1, numberOfClasses]);
	
	% Plot the color clouds for each region.
	numClasses = length(outlines);
	for k = 1 : numClasses
		classIndexes = (group == k);
		if isempty(classIndexes)
			continue;
		end
		% 		fprintf('There are %d pixels in class #%d.\n', sum(classIndexes), k);
		% Make a 1-D RGB image of this region/class so we can plot its gamut with colorcloud.
		thisImage = double(cat(3, training(classIndexes, 1), training(classIndexes, 2), training(classIndexes, 3))) / 255;
		colorcloud(thisImage); % Comes up in a new figure window (can't use subplot) - nothing we can do about that.
		% Give the figure a name in the titlebar.
		caption = sprintf('Gamut of Class #%d', k);
		set(gcf, 'Name', caption, 'NumberTitle', 'Off')
		% fit the clouds on screen.
		set(gcf, 'Units', 'Normalized', 'OuterPosition', [(k-1)/numClasses, 0.2, 1/numClasses, 0.7]);
	end

catch ME
	errorMessage = sprintf('Error in program %s, function %s(), at line %d.\n\nError Message:\n%s', ...
		mfilename, ME.stack(1).name, ME.stack(1).line, ME.message);
	WarnUser(errorMessage);
end

function classifiedImage = ClassifyImage(sample, training, group, meanColors, rows, columns, classificationType)
try
	classifiedImage = [];	% Initialize so any error won't also throw an error about this variable not being defined.
	fontSize = 20;
	
	% Classify the whole image.
	[classes, misclassificationRate] = classify(double(sample), double(training), group, classificationType);
	
	% Report the overall misclassification rate over all classes.
	% This is the fraction of training pixels that were reported to have an estimated class ID
	% that is different than their actual, "true" class ID.
	fprintf('The misclassification rate for the %s classification is %.5g %%.\n', classificationType, 100 * misclassificationRate);
	
	% Classes is a 1-D list of the class that is assigned to each pixel.
	numClasses = length(unique(group));
	
	% Recombine classes of each pixel into a single, indexed image
	% where the value is the class that each pixel got assigned.
	classifiedImage = reshape(classes, rows, columns);
	% Display it.
	figure; % Bring up new figure
	imshow(classifiedImage, []);
	caption = sprintf('Classified Image with %d Color Classes, and Classifier "%s"', numClasses, classificationType);
	title(caption, 'FontSize', fontSize);
	% Apply colormap where each class appears in the mean color for that particular class.
	colormap(gca, meanColors/255);
	colorbar;
	%------------------------------------------------------------------------------
	% Set up figure properties:
	% Enlarge figure to full screen.
	set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
	% Get rid of tool bar and pulldown menus that are along top of figure.
	% set(gcf, 'Toolbar', 'none', 'Menu', 'none');
	% Give a name to the title bar.
	caption = sprintf('Classification Type is %s', classificationType);
	set(gcf, 'Name', caption, 'NumberTitle', 'Off')
	drawnow;
catch ME
	errorMessage = sprintf('Error in program %s, function %s(), at line %d.\n\nError Message:\n%s', ...
		mfilename, ME.stack(1).name, ME.stack(1).line, ME.message);
	WarnUser(errorMessage);
end
return;


function [pixelColors, meanColors, outlines] = GetClassMeans(rgbImage)
try
	meanColors = [];	% Initialize
	pixelColors = [];	% Initialize
	outlines = [];		% Initialize
	[rows, columns, numberOfColorChannels] = size(rgbImage);
	% Bring up new figure and display image.
	hFig = figure;
	imshow(rgbImage);
	axis on;
	title('Click to sample pixels colors.  Press Enter key when done.', 'FontSize', 15);
	hold on;
	% Maximize the window via undocumented Java call.
	% Reference: http://undocumentedmatlab.com/blog/minimize-maximize-figure-window
	MaximizeFigureWindow;
	
	% Extract the individual red, green, and blue color channels.
	redChannel = rgbImage(:, :, 1);
	greenChannel = rgbImage(:, :, 2);
	blueChannel = rgbImage(:, :, 3);
	
	% Get rid of tool bar and pulldown menus that are along top of figure.
	set(gcf, 'Toolbar', 'none', 'Menu', 'none');
	% Give a name to the title bar.
	set(gcf, 'Name', 'Define Color Classes', 'NumberTitle', 'Off')
	
	% Get the class names:
	[numClasses, classNames] = GetClassNames()
	if isempty(classNames)
		return;
	end
	meanColors = zeros(numClasses, 3);
	for classIndex = 1 : numClasses
		titleString = sprintf('Draw sample pixels colors for class #%d, %s.', classIndex, classNames{classIndex});
		title(titleString, 'FontSize', 15);
		message = sprintf('Draw the sample pixels colors for class #%d, %s.', classIndex, classNames{classIndex});
		reply = questdlg(message, 'Continue?', 'OK', 'Quit', 'OK');
		% reply = '' for Upper right X, otherwise it's the exact wording.
		if strcmpi(reply, 'Quit')
			meanColors = [];
			meanColors = [];	% Make meanColors null/empty if they quit.
			pixelColors = [];	% Make meanColors null/empty if they quit.
			outlines = [];	% Make meanColors null/empty if they quit.
			break;
		end
		
		% Ask user to draw points.
		numPoints = 0;
		while numPoints <= 3  % Need at least a triangle so there is an area.
			if classIndex == 1
				% Ask user to draw freehand mask.
				message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
				uiwait(msgbox(message));
			end
			hFH = imfreehand(); % Actual line of code to do the drawing.
			% Create a binary image ("mask") from the ROI object.
			mask = hFH.createMask();
			xy = hFH.getPosition;
			numPoints = size(xy, 1);
			% Save outlines so the calling program can overlay them on the image.
			outlines{classIndex} = xy;
		end
		
		% Get just the pixels of this image that are within
		% the user drawn mask for this class region.
		redPixels = redChannel(mask);
		greenPixels = greenChannel(mask);
		bluePixels = blueChannel(mask);
		
		% If the user drew outside the axes, then there will be nan values in the pixel arrays.  
		% Remove the nan values or it will cause problems in the classification step.
		nanPixels = isnan(redPixels);
		redPixels(nanPixels) = [];
		greenPixels(nanPixels) = [];
		bluePixels(nanPixels) = [];
		
		% OPTIONAL STEP (i.e. you can remove it if you have no idea what it's doing).
		% Some pixels from a different class might be included in the region that the user drew for this class.
		% To "purify" the region and get rid of pixels that are possibly not really in this class
		% discard a certain number of pixels - those that seem most different than most (i.e. outliers).
		[redPixels, greenPixels, bluePixels] = RemoveOutliers(redPixels, greenPixels, bluePixels, 0.001);

		% Pack the remaining "good" pixels for this class into an array 
		% that will hold all training pixels from all classes.
		thesePixelColors = [redPixels, greenPixels, bluePixels, classIndex * ones(length(bluePixels), 1)];
		if classIndex == 1
			pixelColors = thesePixelColors;
		else
			pixelColors = [pixelColors; thesePixelColors];
		end
		% Get the mean of the "good" pixels for this class.
		meanR = mean(redPixels);
		meanG = mean(greenPixels);
		meanB = mean(bluePixels);
		% Put this class's means into the array that holds means for all classes.
		meanColors(classIndex,:) = [meanR, meanG, meanB];
		
		% Post the mean color as text into an overlay over the image.
		message = sprintf('Red mean = %.2f\nGreen mean = %.2f\nBlue mean = %.2f', meanR, meanG, meanB);
		x = 10;
		y = (classIndex - 1) * rows/numClasses + 100;
		text(x, y, message, 'FontSize', 15, 'FontWeight', 'bold', 'Color', 'r');
		% 		msgboxh(message);
		fprintf('For the %d pixels in class #%d ("%s"), Red mean = %6.2f, Green mean = %6.2f, Blue mean = %6.2f\n', ...
			length(redPixels), classIndex, classNames{classIndex}, meanR, meanG, meanB);		
	end
catch ME
	errorMessage = sprintf('Error in program %s, function %s(), at line %d.\n\nError Message:\n%s', ...
		mfilename, ME.stack(1).name, ME.stack(1).line, ME.message);
	WarnUser(errorMessage);
end
close(hFig);
return; % from GetClassMeans


%==========================================================================================================================
% Uses principal components analysis to determine which pixels are outliers and removes a specified fraction of them.
function [redPixels, greenPixels, bluePixels] = RemoveOutliers(redPixels, greenPixels, bluePixels, percentOutliers)
try
	numPixelsInMask = numel(redPixels);
	
% 	numPixelsToDiscard = round(percentOutliers * numPixelsInMask);
% 	% Discard the darkest and brightest percentage.
% 	redPixels = sort(redPixels);
% 	greenPixels = sort(greenPixels);
% 	bluePixels = sort(bluePixels);
% 	redPixels = double(redPixels(numPixelsToDiscard + 1 : end-numPixelsToDiscard));
% 	greenPixels = double(greenPixels(numPixelsToDiscard + 1 : end-numPixelsToDiscard));
% 	bluePixels = double(bluePixels(numPixelsToDiscard + 1 : end-numPixelsToDiscard));
	
	% Get an N by 3 array of all the RGB values.  Each pixel is one row.
	% Column 1 is the red values, column 2 is the green values, and column 3 is the blue values.
	listOfRGBValues = double([redPixels, greenPixels, bluePixels]);
	
	% Now get the principal components.
	coeff = pca(listOfRGBValues);
	
	% Take the coefficients and transform the RGB list into a PCA list.
	transformedImagePixelList = listOfRGBValues * coeff;
	
	% transformedImagePixelList is also an N by 3 matrix of values.
	% Column 1 is the values of principal component #1, column 2 is the PC2, and column 3 is PC3.
	
	% Find indexes where the data is in the [percentOutliers, (1-percentOutliers)] range for all pixels.
	% In other words, throw out any pixels that are in the lower percentOutliers or upper percentOutliers for any PC.
	% First initialize the good indexes.
	goodIndexes = true(numPixelsInMask, 1);
	for k = 1 : size(transformedImagePixelList, 2) % For every PC...
		% Get the k'th PC for all pixels.
		thisPC = transformedImagePixelList(:, k);
		% Get the cumulative distribution function of PC1.
		h = histogram(thisPC, 1000, 'Normalization', 'cdf');
		theCDF = h.Values;
		% Find out the data value at which percentOutliers occurs.
		pcLowIndex = find(theCDF > percentOutliers, 1, 'first');
		pcLow = h.BinEdges(pcLowIndex);
		% Find out the data value at which (1-percentOutliers) occurs.
		pcHighIndex = find(theCDF > (1-percentOutliers), 1, 'first');
		pcHigh = h.BinEdges(pcHighIndex);
		fprintf('Extracting PC #%d pixels between %.1f and %.1f\n', k, pcLow, pcHigh);
		% Find pixels indexes between pc1Low and pc1High
		theseAreGood = thisPC >= pcLow & thisPC <= pcHigh;
		goodIndexes = goodIndexes & theseAreGood;
	end
	% Extract only the "good" pixels, if there are some good pixels.
	% If there are no good pixels, then just take them all.
	if max(goodIndexes(:)) >= 1
		redPixels = redPixels(goodIndexes);
		greenPixels = greenPixels(goodIndexes);
		bluePixels = bluePixels(goodIndexes);
	end
	
catch ME
	errorMessage = sprintf('Error in program %s, function %s(), at line %d.\n\nError Message:\n%s', ...
		mfilename, ME.stack(1).name, ME.stack(1).line, ME.message);
	WarnUser(errorMessage);
end
return; % from RemoveOutliers
	
%==========================================================================================================================
function [numClasses, classNames] = GetClassNames()
try
	% Ask user for number of classes.
	defaultValue = 3;
	titleBar = 'Enter an integer value';
	userPrompt = 'Enter the number of classes';
	caUserInput = inputdlg(userPrompt, titleBar, 1, {num2str(defaultValue)});
	if isempty(caUserInput),return,end % Bail out if they clicked Cancel.
	% Round to nearest integer in case they entered a floating point number.
	numClasses = round(str2double(cell2mat(caUserInput)));
	% Check for a valid integer.
	if isnan(numClasses)
		% They didn't enter a number.
		% They clicked Cancel, or entered a character, symbols, or something else not allowed.
		numClasses = defaultValue;
		message = sprintf('I said it had to be an integer.\nTry replacing the user.\nI will use %d and continue.', numClasses);
		uiwait(warndlg(message));
	end
	
	% Now ask for names
	for k = 1 : numClasses
		defaultClassNames{k} = sprintf('Class%d', k);
		editFieldPrompt{k} = sprintf('Enter name of class #%d', k);
	end
	titleBar = 'Enter class names';
	classNames = inputdlg(editFieldPrompt, titleBar, 1, defaultClassNames);
	if isempty(classNames),return,end % Bail out if they clicked Cancel.
	% Find out how many classes actually have names in them.
	for classIndex = 1 : numClasses
		if isempty(classNames{classIndex})
			numClasses = classIndex - 1;
			break;
		end
	end
	% Strip off any blank names.
	classNames = classNames(1:numClasses);
	
catch ME
	errorMessage = sprintf('Error in program %s, function %s(), at line %d.\n\nError Message:\n%s', ...
		mfilename, ME.stack(1).name, ME.stack(1).line, ME.message);
	WarnUser(errorMessage);
end
return; % from GetClassMeans

%==========================================================================================================================
function WarnUser(warningMessage)
fprintf('%s\n', warningMessage);
uiwait(warndlg(warningMessage));
