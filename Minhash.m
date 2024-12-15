function [respetivasProbs] = Minhash(dataset, sintomasInput)
    diagnosticos = dataset(:, 1);
    doencas = unique(diagnosticos);
    sintomas = dataset(:, 2:end);

    totalSintomas = {};
    for i = 1:numel(sintomas)
        if ~ismissing(sintomas{i})
            totalSintomas = [totalSintomas; sintomas{i}];
        end
    end
    sintomasUnicos = unique(totalSintomas);



    %TABELA COM TODOS OS DIAGNOTICOS(COM REPETIÇÃO) E OS SINTOMAS REGISTADOS
    treino = zeros(length(diagnosticos),length(sintomasUnicos));
    
    for linha = 1:length(diagnosticos)
        sintomas = dataset(linha, 2:end);
        
        for col = 1:length(sintomasUnicos)
            aux = sintomasUnicos{col};
    
            num_ocorrencias = sum(strcmpi(sintomas,aux));
    
            treino(linha,col) = num_ocorrencias;
        end
    end

    %Passar os sintomas pelo string2hash
    sintomasUnicosHash = zeros(1, length(sintomasUnicos));
    for i = 1:length(sintomasUnicos)
        sintomasUnicosHash(i) = string2hash(sintomasUnicos{i});
    end

    % Permutações aleatorias
    totalPermutacoes = 100;
    treinoMinhash = inf(length(diagnosticos), totalPermutacoes);

    for d = 1:length(diagnosticos)
        sintomasIds = find(treino(d, :) == 1);
        if ~isempty(sintomasIds)
            for h = 1:totalPermutacoes
                randomSeed = h * 42;
                rng(randomSeed);
                permutacoesAleatorias = randperm(length(sintomasUnicos));
                hashPermutado = sintomasUnicosHash(permutacoesAleatorias);
                treinoMinhash(d, h) = min(hashPermutado(sintomasIds));
            end
        end
    end

    sintomasInputIds = arrayfun(@(x) find(strcmpi(sintomasUnicos, x)), sintomasInput, 'UniformOutput', false);
    %Na maior parte das situações, o bloom filter faz isto redudante
    sintomasExistentes = cell2mat(sintomasInputIds(~cellfun('isempty', sintomasInputIds)));
    inputMinhash = zeros(1, totalPermutacoes);
    if ~isempty(sintomasExistentes)
        for h = 1:totalPermutacoes
            randomSeed = h * 42;
            rng(randomSeed);
            permutacoesAleatorias = randperm(length(sintomasUnicos));
            hashPermutado = sintomasUnicosHash(permutacoesAleatorias);
            inputMinhash(h) = min(hashPermutado(sintomasExistentes));
        end
    else
        inputMinhash(:) = NaN; % or zeros, depending on your preference
    end

    % Compare input MinHash signature to all diagnoses
    jaccardSimilaridades = zeros(length(diagnosticos), 1);
    for d = 1:length(diagnosticos)
        numeroCorrespondencias = sum(treinoMinhash(d, :) == inputMinhash);
        jaccardSimilaridades(d) = numeroCorrespondencias / totalPermutacoes;
    end

    respetivasProbs = cell(length(doencas), 2);
    for i = 1:length(diagnosticos)
        respetivasProbs{i, 1} = diagnosticos{i};
        respetivasProbs{i, 2} = jaccardSimilaridades(i);
    end
end
