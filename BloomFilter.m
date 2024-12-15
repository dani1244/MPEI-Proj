function [filtroBloom, sintomasFiltrados] = BloomFilter(dataset, sintomasInput)
    % Extrair sintomas únicos do dataset
    totalSintomas = {};
    for i = 1:size(dataset, 1)
        linhaAtual = dataset(i, 2:end); % Pega os sintomas da linha atual
        linhaAtual = linhaAtual(~ismissing(linhaAtual)); % Remove valores 'missing'
        linhaAtual = linhaAtual(~cellfun(@isempty, linhaAtual)); % Remove células vazias
        totalSintomas = [totalSintomas, linhaAtual];
    end
    
    % Garantir que totalSintomas contém apenas valores válidos
    sintomasLimpos = {};
    for i = 1:length(totalSintomas)
        if ~ismissing(totalSintomas{i}) & ~isempty(totalSintomas{i})
            sintomasLimpos{end+1} = totalSintomas{i};
        end
    end
 
    % Atualizar totalSintomas
    totalSintomas = sintomasLimpos;
    
    % Converter para strings (caso necessário)
    totalSintomas = cellfun(@char, totalSintomas, 'UniformOutput', false);
    
    % Extrair valores únicos
    sintomasUnicos = unique(totalSintomas);

    numHashFuncs = 3; % Número de funções hash
    tamanhoFiltro = 10 * length(sintomasUnicos); % Tamanho do filtro


    % Inicializar o filtro de Bloom
    filtroBloom = false(tamanhoFiltro, 1);

    % Função auxiliar para gerar múltiplos hashes
    function indices = bloomHashes(element, filtroSize, numFuncs)
        indices = zeros(1, numFuncs); % Inicializa os índices
        for k = 1:numFuncs
            % Concatena o índice k à string e calcula o hash
            hash = string2hash([element, num2str(k)], 'djb2');
            indices(k) = mod(hash, filtroSize) + 1; % Garante que o índice está dentro do filtro
        end
    end

    % Inserir sintomas únicos no filtro de Bloom
    for i = 1:length(sintomasUnicos)
        indices = bloomHashes(sintomasUnicos{i}, tamanhoFiltro, numHashFuncs);
        filtroBloom(indices) = true; % Marca as posições correspondentes no filtro
    end

    % Filtrar sintomas de entrada
    sintomasFiltrados = {};
    for i = 1:length(sintomasInput)
        indices = bloomHashes(sintomasInput{i}, tamanhoFiltro, numHashFuncs);
        if all(filtroBloom(indices)) % Se todos os índices estão marcados, passa no filtro
            sintomasFiltrados = [sintomasFiltrados; sintomasInput{i}];
        end
    end
end
