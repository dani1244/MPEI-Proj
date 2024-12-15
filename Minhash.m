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

    % Calculate inputMinhash for the input symptoms
    sintomasInputIds = arrayfun(@(x) find(strcmpi(sintomasUnicos, x)), sintomasInput);
    inputMinhash = zeros(1, totalPermutacoes);
    for h = 1:totalPermutacoes
        randomSeed = h * 42;
        rng(randomSeed);
        permutacoesAleatorias = randperm(length(sintomasUnicos));
        hashPermutado = sintomasUnicosHash(permutacoesAleatorias);
        inputMinhash(h) = min(hashPermutado(sintomasInputIds));
    end

    % Compare input MinHash signature to all diagnoses
    jaccardSimilarities = zeros(length(diagnosticos), 1);
    for d = 1:length(diagnosticos)
        numMatches = sum(treinoMinhash(d, :) == inputMinhash);
        jaccardSimilarities(d) = numMatches / totalPermutacoes;
    end

    % Aggregate similarities for unique diagnoses
    probs = zeros(length(doencas), 1);
    for i = 1:length(doencas)
        indices = strcmpi(diagnosticos, doencas{i});
        probs(i) = mean(jaccardSimilarities(indices));
    end

    respetivasProbs = cell(length(doencas), 2);
    for i = 1:length(doencas)
        respetivasProbs{i, 1} = doencas{i};
        respetivasProbs{i, 2} = probs(i);
    end

end
