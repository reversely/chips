clear; clc;

inputFolder = "C:\Users\shere\chips\trial1";
outputCSV = fullfile(inputFolder, 'fracture_energy.csv');

figFiles = dir(fullfile(inputFolder, '*.fig'));

% 3D printer velocity
velocity = 0.005; % m/s

% Results:
% FileName, dt, PeakForce, MaxForce, Threshold, FractureEnergy
results = cell(0,6);

for k = 1:length(figFiles)
    figPath = fullfile(inputFolder, figFiles(k).name);
    fig = openfig(figPath, 'invisible');
    
    % --- Extract AnimatedLine data ---
    animLines = findall(fig, 'Type', 'animatedline');
    
    bestX = [];
    bestY = [];
    maxLen = 0;
    
    for j = 1:length(animLines)
        [x, y] = getpoints(animLines(j));
        
        if numel(x) > maxLen
            maxLen = numel(x);
            bestX = x(:);
            bestY = y(:);
        end
    end
    
    close(fig);
    
    if isempty(bestX)
        fprintf('No data: %s\n', figFiles(k).name);
        results(end+1,:) = {figFiles(k).name, NaN, NaN, NaN, NaN, NaN};
        continue;
    end
    
    % --- Ensure sorted by time ---
    [bestX, sortIdx] = sort(bestX);
    bestY = bestY(sortIdx);
   
    % --- Smooth signal ---
    bestY = smoothdata(bestY, 'gaussian', 5);
    
    % --- Convert to Force (N) ---
    forceY = (bestY + 24.725) * 9.81 / 4154.6;
    
    % --- Max + threshold ---
    maxForce = max(forceY);
    baselineTol = 0.02 * maxForce;  % 2% of max force
    thresholdFactor = 0.2;
    threshold = thresholdFactor * maxForce;
    
    % --- Peak detection ---
        [pks, locs] = findpeaks(forceY);
        
        if isempty(pks)
            peakForce = NaN;
        else
            idx = find(pks >= threshold, 1, 'first');
            if isempty(idx)
                peakForce = NaN;
            else
                peakForce = pks(idx);
            end
        end
        
        % --- Fracture window (threshold crossing) ---
    activeRegion = forceY > baselineTol;
    
    if any(activeRegion)
        idxStart = find(activeRegion, 1, 'first');
        idxEnd   = find(activeRegion, 1, 'last');
        
        t_start = bestX(idxStart);
        t_end   = bestX(idxEnd);
        
        % --- True fracture duration ---
        dt = t_end - t_start;
        
        % --- Full fracture energy ---
        energy_fracture = velocity * trapz(bestX(idxStart:idxEnd), ...
                                           forceY(idxStart:idxEnd));
    else
        t_start = NaN;
        t_end = NaN;
        dt = NaN;
        energy_fracture = NaN;
    end
    % --- Debug ---
    fprintf(['%s | dt=%.6f s | Peak=%.2f N | Max=%.2f N | ', ...
         'Thresh=%.2f N | Energy=%.4f J\n'], ...
         figFiles(k).name, dt, peakForce, maxForce, threshold, energy_fracture);

    % --- Store ---
    results(end+1,:) = { ...
        figFiles(k).name, ...
        dt, ...
        peakForce, ...
        maxForce, ...
        threshold, ...
        energy_fracture ...
    };
end

% --- Save ---
T = cell2table(results, ...
    'VariableNames', { ...
    'TrialName', ...
    'dt', ...
    'PeakForce_N', ...
    'MaxForce_N', ...
    'Threshold_N', ...
    'FractureEnergy_J' ...
});

writetable(T, outputCSV);

disp('Done');