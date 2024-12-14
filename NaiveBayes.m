function [respetivasProbs] = NaiveBayes(dataset, printsIntermedios, sintomasInput)
    % Inicializar sintomas únicos
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

    % Configurar filtro de Bloom
    tamanhoFiltro = 10 * length(sintomasUnicos); % Tamanho do filtro
    numHashFuncs = 3; % Número de funções hash

    % Aplicar o filtro de Bloom
    [filtroBloom, sintomasFiltrados] = bloomFilter(sintomasUnicos, sintomasInput, numHashFuncs, tamanhoFiltro);

    % Verificar se algum sintoma passou pelo filtro
    if isempty(sintomasFiltrados)
        disp("Nenhum sintoma do input é conhecido no dataset.");
        respetivasProbs = [];
        return;
    end

    % Continuar com o Naive Bayes para sintomas filtrados
    % Criar a tabela de treino com sintomas únicos
    treino = zeros(length(diagnosticos), length(sintomasUnicos));
    
    for linha = 1:length(diagnosticos)
        sintomasLinha = dataset(linha, 2:end);
        
        for col = 1:length(sintomasUnicos)
            aux = sintomasUnicos{col};
    
            num_ocorrencias = sum(strcmpi(sintomasLinha, aux));
    
            treino(linha, col) = num_ocorrencias;
        end
    end

    if printsIntermedios
        disp("\n\n\nNAIVE BAYES");
        disp("Tabela de treino");
        disp(treino);
    end

    % Vetor com as probabilidades de cada doença
    probDoencas = zeros(length(doencas), 1);
    
    for diagnostico = 1:length(diagnosticos)
        for diagnosticoID = 1:length(doencas)
            if strcmpi(doencas{diagnosticoID}, diagnosticos{diagnostico})
                probDoencas(diagnosticoID) = probDoencas(diagnosticoID) + 1;
                break;
            end
        end
    end
    probDoencas = probDoencas / sum(probDoencas);

    if printsIntermedios
        disp("Probabilidade dos diagnósticos");
        disp(probDoencas);
    end

    % Calculo de probabilidade do input para cada doença
    probDoencasParaEsteInput = zeros(length(doencas), 1);

    % Juntar todas as linhas com o mesmo diagnóstico
    treinoParaDoencas = zeros(length(doencas), size(treino, 2));
    
    for i = 1:length(doencas)
        matchingRows = strcmpi(diagnosticos, doencas{i});
        
        treinoParaDoencas(i, :) = sum(treino(matchingRows, :), 1);
    end
    
    if printsIntermedios
        disp("Treino juntado por classes");
        disp(treinoParaDoencas);
    end

    % Transformar de contagem para probabilidade
    probSintomasParaDoencas = zeros(length(doencas), size(treino, 2));
    
    for i = 1:length(doencas)
        probSintomasParaDoencas(i, :) = (treinoParaDoencas(i, :) + 1) / (sum(treinoParaDoencas(i, :)) + length(sintomasUnicos));
    end

    if printsIntermedios
        disp("Probabilidade de cada sintoma após cada classe");
        disp(probSintomasParaDoencas);
    end

    % Finalmente as probabilidades para cada doença considerando o input
    for doencaID = 1:length(doencas)
        prob = probDoencas(doencaID); % Começa com P(classe)
        for i = 1:length(sintomasFiltrados)
            for y = 1:length(sintomasUnicos)
                if strcmpi(sintomasFiltrados{i}, sintomasUnicos{y})
                    prob = prob * probSintomasParaDoencas(doencaID, y);
                    break;
                end
            end
        end
        probDoencasParaEsteInput(doencaID) = prob;
    end
    
    probDoencasParaEsteInput = probDoencasParaEsteInput / sum(probDoencasParaEsteInput);

    respetivasProbs = cell(length(doencas), 2);
    for i = 1:length(doencas)
        respetivasProbs{i, 1} = doencas{i};
        respetivasProbs{i, 2} = probDoencasParaEsteInput(i);
    end
end
