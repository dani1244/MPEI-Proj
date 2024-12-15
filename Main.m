defaultDataset = readcell("SmallTestData.csv")
defaultDataset = defaultDataset(2:end, :);

defaultTestDataset = readcell("Sintomas.csv")

resposta = input('Usar testes predefinidos? (s para sim)','s');
if resposta == 's'
    for i = 1:size(defaultTestDataset,1) %Para cada linha do dataset teste, chamar os modulos
        MainLoop(defaultDataset,defaultTestDataset(i,:));

        resposta = input('Continuar? (n para não)','s');
        if resposta == 'n'
            break
        end
    end
    disp("Fim do Sintomas.csv");
else
    MainLoop(defaultDataset,{'S1', 'S3','S4'});
end




function [] = MainLoop(dataset,sintomasInput)
    sintomasInputLimpo = {}; %Remover <missing>
    for i = 1:numel(sintomasInput)
        if ~ismissing(sintomasInput{i})
            sintomasInputLimpo = [sintomasInputLimpo; sintomasInput{i}];
        end
    end
    disp("-----------------------------------------------------------------")
    disp("Input:")
    disp(sintomasInputLimpo)

    [~, sintomasFiltrados] = BloomFilter(dataset, sintomasInputLimpo);

    
    disp("Sintomas filtrados pelo BloomFilter ")
    disp(sintomasFiltrados)
    disp("Probabilidade para cada doença segundo o Naive Bayes")
    disp(NaiveBayes(dataset, false,sintomasFiltrados));
    disp("Distancias de Jaccard entre diagnosticos existentes e os sintomas inseridos, segundo o minhash")
    disp(Minhash(dataset,sintomasFiltrados));
end