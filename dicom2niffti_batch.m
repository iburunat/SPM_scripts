% ========================================================================
% DICOM to NIFTI conversion using dicom2nifti
% dicominfo('dicom_file_name')
% ========================================================================
% set origin & target folders
ddir='/Users/ibburuna/Desktop/data/ULL_Blind/DICOM/'; % DICOM files
sdir='/Users/ibburuna/Desktop/data/ULL_Blind/NIFTI/'; % NIFTI target

cd(ddir)
di=dir('*');
di(strncmp({di.name}, '.', 1)) = []; 

t0=cputime;
tic
for k=1:length(di)
    [k cputime-t0]
    dicom2nifti('dicom_dir', [ddir di(k).name], 'subject_dir', [sdir di(k).name],...
        'autodetect', 'yes'); % creates sdir if ~exist
end
toc