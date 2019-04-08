% ========================================================================
% ULL_Blind study | Iballa Burunat, Apri 2019
% SPM Preprocessing pipeline
% ========================================================================
% Create first subject-independent jobfile from GUI (SPM12 manual, 48.1.4)
% saved as job.m and point to it (jobfile)
% ------------------------------------------------------------------------
% paths
clear, clc, close all
root = '/Users/ibburuna/Desktop/data/ULL_Blind/';
NIFTI = fullfile(root, 'NIFTI/');
sdir = dir([NIFTI '*']);
sdir(strncmp({sdir.name}, '.', 1)) = [];
jobfile = {fullfile(root, 'scripts/SPMbatch/job.m')}; 
jobs = repmat(jobfile, 1, numel(sdir));

%--populate inputs----------------------------------
    % input{2}
    for s = 1:length(sdir)
        disp(['Subject:   ' num2str(s)])
        files{s} = cellstr(spm_select('FPList',[NIFTI sdir(s).name '/func/run_0001/'],'^.*\.nii$'));
    end
    % input{3}
    for s = 1:length(sdir)
        disp(['Subject:   ' num2str(s)])
        files2{s}={[NIFTI sdir(s).name '/anat/anatomy.nii', ',1']};
    end
%----------------------------------------------------
% put it together
t0=cputime;
clear inputs
inputs = cell(3, length(sdir)); % UNDEFINED fields = 3
tic
for s = 1:length(sdir)
    [s cputime-t0]
    inputs{1,s} = cellstr(fullfile(NIFTI,sdir(s).name)); % Named Directory Selector: Directory - cfg_files
    inputs{2,s} = files{s}; % Realign & Unwarp: Images - cfg_files
    inputs{3,s} = files2{s}; % Coregister: Estimate: Source Image - cfg_files
end
toc

% run job
disp('------Preprocessing started------');
spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run', jobs, inputs{:});
disp('------Preprocessing ended------');
