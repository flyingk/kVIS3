%*************************************************************************%
% Project Name : LiliumModelSim
% Author       : Felix Schweighofer <felix.schweighofer@lilium.com>
% Description  : This function attempts to extract metainformation from a
%                signal name conforming to the Lilium naming scheme.
%
% Copyright Lilium GmbH 2018
%*************************************************************************%
function [ SignalInfo ] = kVIS_extractInfoFromSignalName(Name)

    SignalInfo = struct();

    %% Signal name parser
    % The parser is a finite state machine that processes the signal name step
    % by step instead of searching for certain substrings.
    % Signal attributes are gathered in the SignalInfo struct; subsequently,
    % TeX code is generated from the recorded information.
    %
    % Example: consider the signal name '  V_x_dot_K_UNIT_m_d_s_FRAME_O'
    % First, the signal name is stripped of whitespace and split into tokens
    % delimited by '_':
    %   {'V', 'x', 'dot', 'K', 'UNIT', 'm', 'd', 's', 'FRAME', 'O'}
    % The tokens are then processed sequentially; at any point of the process,
    % the ParserState variable indicates what to do with the next token. The
    % parser starts in the ParsingSymbol state and records 'V' as symbol.
    % Once the symbol has been read, the parser switches to ParsingAxis state,
    % since an axis specification is expected after the symbol.
    % In this mode, if the next token is 'x', 'y' or 'z', the axis is recorded.
    % After that (or directly, if no axis is found), the parser switches to
    % ParsingModifiers state, where it expects modifiers like 'dot' and
    % arbitrary subscripts like 'K'. These are recorded.
    % Once either 'UNIT' or 'FRAME' is found, the parser switches to the
    % corresponding state.
    % In ParsingUnit mode, unit symbols are recorded, replacing 'd' by '/' etc,
    % which in this case leads to 'm/s'.
    % In ParsingFrame mode, the next token is interpreted as a reference frame
    % designation, in this case 'O'.
    % Unit and frame may appear in arbitrary order, but each element can only
    % be given once.
    % After frame and unit, no further input is accepted.

    Name = strip(Name);
    Name = strip(Name, '<');
    Name = strip(Name, '>');
    
    % Display name generation ( just cut off the UNIT/FRAME tokens )
    k1 = strfind(Name, 'UNIT');
    k2 = strfind(Name, 'FRAME');
    
    if ~isempty(k1) || ~isempty(k2)
        
        if k1 > k2
            DispName = Name(1:k2-2);
        else
            DispName = Name(1:k1-2);
        end
        
    else
        
        DispName = Name;
        
    end
    
    % Tex string generation
    Tokens = strsplit(Name, '_');

    assert(numel(Tokens) > 0);

    Flags = struct();
    Flags.HasAxis  = false;
    Flags.HasTilde = false;
    Flags.HasHat   = false;
    Flags.HasDot   = false;
    Flags.HasBar   = false;
    Flags.HasSubscripts = false;
    Flags.HasUnit  = false;
    Flags.HasFrame = false;
    Flags.ShouldNotBeInterpreted = false;

    Data = struct();
    Data.RawName    = Name;
    Data.Symbol     = '';
    Data.Axis       = '';
    Data.Unit       = '';
    Data.Frame      = '';
    Data.Subscripts = {};

    I = 1;
    State = struct();
    State.ParsingSymbol    = I; I = I + 1;
    State.ParsingAxis      = I; I = I + 1;
    State.ParsingModifiers = I; I = I + 1;
    State.ParsingUnit      = I; I = I + 1;
    State.ParsingFrame     = I; I = I + 1;
    State.Finished         = I;

    ParserState = State.ParsingSymbol;
    I = 0;
    while I < numel(Tokens)

        I = I + 1;
        Item = Tokens{I};

        switch ParserState

        case State.ParsingSymbol
            switch Item
            case {'UNIT', 'FRAME'}
                error('Missing symbol: %s', Name);
            case {'enable', 'Enable', 'warning', 'Warning'}
                Flags.ShouldNotBeInterpreted = true;
            end
            Data.Symbol = Item;
            ParserState = State.ParsingAxis;

        case State.ParsingAxis
            switch Item
            case {'x', 'y', 'z'}
                Flags.HasAxis = true;
                Data.Axis = Item;
            otherwise
                I = I - 1; % process again
            end
            ParserState = State.ParsingModifiers;

        case State.ParsingModifiers
            switch Item
            case 'UNIT'
                ParserState = State.ParsingUnit;
            case 'FRAME'
                ParserState = State.ParsingFrame;
            case 'tilde'
                Flags.HasTilde = true;
            case 'hat'
                Flags.HasHat = true;
            case 'dot'
                Flags.HasDot = true;
            case 'bar'
                Flags.HasBar = true;
            otherwise
                Flags.HasSubscripts = true;
                Data.Subscripts{end+1} = Item;
            end

        case State.ParsingUnit
            Flags.HasUnit = true;
            switch Item
            case 'FRAME'
                ParserState = State.ParsingFrame;
            case 'UNIT'
                error('Multiple UNIT specifications: %s', Name);
            case 'none'
                Data.Unit = [Data.Unit, '-'];
            case 'd'
                Data.Unit = [Data.Unit, '/'];
            case 'deg'
                Data.Unit = [Data.Unit, 'deg'];
            otherwise
                Tmp = regexprep(Item, '(\d+)', '^$1');
                Data.Unit = [Data.Unit, Tmp]; % TODO: multi-char units like deg/rad
            end

        case State.ParsingFrame
            Flags.HasFrame = true;
            switch Item
            case 'UNIT'
                ParserState = State.ParsingUnit;
            case 'FRAME'
                error('Multiple FRAME specifications: %s', Name);
            otherwise
                Data.Frame = Item;
                ParserState = State.Finished;
            end

        case State.Finished
            %error('Signal name parser finished before end of input: %s', Name);
            Flags.ShouldNotBeInterpreted = true;
            break;

        otherwise
            error('Invalid parser state: %d', ParserState);

        end

    end

    SignalInfo.Flags = Flags;
    SignalInfo.Data  = Data;

    %% TeX code assembly
    % The SignalInfo recorded by the signal name parser is used to generate TeX
    % code for rendering in plots.
    % Since symbol, modifiers like 'dot' and subscripts are recorded
    % separately, the code can be assembled easily.
    TeXfont = '\mathsf';

    GreekLetters = { ...
        'alpha', 'beta', 'gamma', 'delta', 'epsilon', 'zeta', 'eta', ...
        'theta', 'iota', 'kappa', 'lambda', 'mu', 'nu', 'xi', 'pi', ...
        'rho', 'sigma', 'tau', 'upsilon', 'phi', 'chi', 'psi', 'omega' ...
    };
    GreekLetters = [ ...
        GreekLetters, ...
        cellfun(@(x) [x(1)-32, x(2:end)], GreekLetters, 'UniformOutput', false) ...
    ];

    if Flags.ShouldNotBeInterpreted

        % Escape special characters
        TeX = TeX_escape(Name);
        
    else

        if any(strcmp(GreekLetters, Data.Symbol))
            TeX = ['\', TeX_escape(lower(Data.Symbol))];
        else
            TeX = TeX_escape(Data.Symbol);
        end

        % TODO: Preserve order of modifiers
        if Flags.HasTilde
            TeX = ['\tilde{', TeX, '}'];
        end
        if Flags.HasHat
            TeX = ['\hat{', TeX, '}'];
        end

        if Flags.HasAxis
            TeX = [TeX, '_{', TeX_escape(Data.Axis), '}'];
        end

        if Flags.HasSubscripts
            
            TeX_Sub = cell(size(Data.Subscripts));
            
            for I = 1 : numel(Data.Subscripts)
                Sub = Data.Subscripts{I};
                if any(strcmp(GreekLetters, Sub))
                    Sub = ['\', TeX_escape(Sub)]; 
                end
                TeX_Sub{I} = TeX_escape(Sub);
            end
            
            if Flags.HasAxis
                TeX = ['{(', TeX, ')}_{', strjoin(TeX_Sub, ','), '}'];
            else
                TeX = ['{', TeX, '}_{', strjoin(TeX_Sub, ','), '}'];
            end
        end
        
        if Flags.HasDot
            TeX = ['\dot{', TeX, '}']; % not supported by \mathsf
            TeXfont = '\mathbf';
        end
        
        if Flags.HasBar
            TeX = ['\bar{', TeX, '}'];
        end

        if Flags.HasFrame
            TeX = ['(', TeX, ')_{', TeX_escape(Data.Frame), '}'];
        end

        TeX = ['$ ' TeXfont '{', TeX, '} $']; % add whitespace to avoid '$$'

    end

    if isempty(Data.Unit)
        TeX_Unit = [];
    else
        TeX_Unit = ['$ ' TeXfont '{[\, ' Data.Unit ' \,]} $']; % TODO
    end

    %% Output struct
    SignalInfo.TeX_Name = TeX;
    SignalInfo.TeX_Unit = TeX_Unit;
    SignalInfo.DispName = DispName;

end

function [escaped_text] = TeX_escape(text)

    escaped_text = text;
    escaped_text = strrep(escaped_text, '_', '\_');
    escaped_text = strrep(escaped_text, '#', '\#');
    escaped_text = strrep(escaped_text, '%', '\%');
    escaped_text = strrep(escaped_text, ' ', '\;');
end
