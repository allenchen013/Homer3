function procResult = CalcSubj(subj, hListboxFiles, listboxFilesFuncPtr)

subj.procResult = procStreamCalcSubj(subj, hListboxFiles, listboxFilesFuncPtr);

saveSubj(subj);

procResult = subj.procResult;


