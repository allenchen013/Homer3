% This script checks for expected errors given the argument validation
% functions

% load test data file
fname = 'Example_RunFuncOffline/test.snirf';
data_nirs = {SnirfClass(fname)}; 
acquired = data_nirs{1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Error checks
%--------------------------------------------------------------------------
testCase = matlab.unittest.TestCase.forInteractiveUse;

% check hpf is non negative
verifyError(testCase,@() hmrR_BandpassFilt(acquired.data, 1i, 0.5), ...
    "MATLAB:validators:mustBeReal")
verifyError(testCase,@() hmrR_BandpassFilt(acquired.data, -1, 0.5), ...
    "MATLAB:validators:mustBeNonnegative")

% check hpf is numeric
verifyError(testCase,@() hmrR_BandpassFilt(acquired.data, 'h', 0.5), ...
    "MATLAB:validators:mustBeNumeric")
verifyError(testCase,@() hmrR_BandpassFilt(acquired.data, true, 0.5), ...
    "MATLAB:validators:mustBeNumeric")

% check lpf is numeric
verifyError(testCase,@() hmrR_BandpassFilt(acquired.data, 0.5, 'h'), ...
    "MATLAB:validators:mustBeNumeric")
verifyError(testCase,@() hmrR_BandpassFilt(acquired.data, 0.5, true), ...
    "MATLAB:validators:mustBeNumeric")


% check lpf is non negative
verifyError(testCase,@() hmrR_BandpassFilt(acquired.data, 0.05, 1i), ...
    "MATLAB:validators:mustBeReal")
verifyError(testCase,@() hmrR_BandpassFilt(acquired.data, 0.05, -1), ...
    "MATLAB:validators:mustBeNonnegative")

% check lpf > hpf
verifyError(testCase,@() hmrR_BandpassFilt(acquired.data, 0.05, 0.01), ...
    "Homer:InvalidFilterFrequency")

% check Nyquist
Fs = 1/diff(acquired.data.time(1:2));
lpf_nonNyq = Fs*.5 + 1;
hpf_nonNyq = Fs*5 + 1;

verifyError(testCase,@() hmrR_BandpassFilt(acquired.data, 0.05, hpf_nonNyq), ...
    "Homer:ExceedsNyquist")
verifyError(testCase,@() hmrR_BandpassFilt(acquired.data, lpf_nonNyq, 0.01), ...
    "Homer:ExceedsNyquist")


