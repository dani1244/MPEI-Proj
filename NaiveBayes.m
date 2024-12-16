function [respetivasProbs] = NaiveBayes(dataset,printsIntermedios,sintomasInput)
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

    if printsIntermedios
        disp("Tabela de treino")
        disp(treino);
    end



    %%VETOR COM AS PROBABILIDADES DE CADA DOENÇA (CALCULADO ATRAVÉS DO
    %%NUMERO DE PRESENÇAS NO DATASET)
    probDoencas = zeros(length(doencas), 1);
    
    for diagnostico = 1:length(diagnosticos)
        for diagnosticoID = 1:length(doencas)
            if strcmpi(doencas{diagnosticoID}, diagnosticos{diagnostico})
                probDoencas(diagnosticoID) = probDoencas(diagnosticoID) +1;
                break
            end
        end
    end
    probDoencas = probDoencas/sum(probDoencas);

    if printsIntermedios
        disp("Probabilidade dos diagnosticos")
        disp(probDoencas);
    end



    %%AGORA O CALCULO DE PROBABILIDADE DO NOSSO INPUT PARA CADA DOENÇA
    probDoencasParaSintomas = zeros(length(doencas),1);

    %Juntar todas as linhas com o mesmo diagnostico
    treinoParaDoencas = zeros(length(doencas), size(treino, 2));
    
    for i = 1:length(doencas)
        matchingRows = strcmpi(diagnosticos, doencas{i});
        
        treinoParaDoencas(i, :) = sum(treino(matchingRows, :), 1);
    end
    
    if printsIntermedios
        disp("Treino juntado por classes")
        disp(treinoParaDoencas);
    end

    %Mudar de contagem para probabilidade
    probSintomasParaDoencas = zeros(length(doencas), size(treino, 2));
    
    for i = 1:length(doencas)
        probSintomasParaDoencas(i,:) = (treinoParaDoencas(i,:)+1)/(sum(treinoParaDoencas(i,:))+length(sintomasUnicos));
    end

    if printsIntermedios
        disp("Prabilidade de cada sintoma apos cada classe")
        disp(probSintomasParaDoencas);
    end

    %Finalmente as probabilidades para cada doença tendo em conta o input
    for doencaID = 1:length(doencas)
        prob = probDoencas(doencaID); %Começamos com P(classe)
        for i = 1:length(sintomasInput)
            for y = 1:length(sintomasUnicos)
                if strcmpi(sintomasInput(i),sintomasUnicos(y))
                    prob = prob * probSintomasParaDoencas(doencaID,y);
                    break
                end
            end
        end
        probDoencasParaEsteInput(doencaID) = prob;
    end
    
    probDoencasParaEsteInput = probDoencasParaEsteInput/sum(probDoencasParaEsteInput);

    respetivasProbs = cell(length(doencas), 2);
    for i = 1:length(doencas)
        respetivasProbs{i, 1} = doencas{i};
        respetivasProbs{i, 2} = probDoencasParaEsteInput(i);
    end
end