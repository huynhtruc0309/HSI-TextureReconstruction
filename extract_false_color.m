clc; clear; close all

% Define input and output directories
inputDirs = {'Fragment1', 'Fragment4'};
outputDir = 'ColoredImages';

% Create output directory if it doesn't exist
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% Loop through each input directory
for d = 1:length(inputDirs)
    % Create subdirectory for each input folder
    subOutputDir = fullfile(outputDir, inputDirs{d});
    if ~exist(subOutputDir, 'dir')
        mkdir(subOutputDir);
    end
    
    % Get list of .img files in the current directory
    imgFiles = dir(fullfile('Fragments/', inputDirs{d}, '*.img'));
    
    % Loop through each .img file
    for f = 1:length(imgFiles)
        % Construct full file path
        filename = fullfile(imgFiles(f).folder, imgFiles(f).name);
        
        % Read the hypercube
        hcube = hypercube(filename);
        
        % Colorize the hypercube
        coloredImg = colorize(hcube);
        
        % Construct output filename
        outputFilename = fullfile(subOutputDir, [imgFiles(f).name(1:end-4) '_colored.png']);
        
        % Save the colored image
        imwrite(coloredImg, outputFilename);
        
        % Display progress
        fprintf('Processed: %s -> %s\n', imgFiles(f).name, outputFilename);
    end
end
