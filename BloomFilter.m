function [filtroBloom, sintomasFiltrados] = bloomFilter(sintomasUnicos, sintomasInput, numHashFuncs, tamanhoFiltro)
    % Inicializar o filtro de Bloom
    filtroBloom = false(tamanhoFiltro, 1);

    % Função auxiliar para hash (usa múltiplas funções hash)
    function indices = bloomHashes(element, filtroSize, numFuncs)
        rng(123); % Para consistência dos hashes
        indices = zeros(1, numFuncs);
        for k = 1:numFuncs
            hash = string2hash(element, 'md5', k); 
            indices(k) = mod(hash, filtroSize) + 1;
        end
    end

    % Inserir sintomas únicos no filtro de Bloom
    for i = 1:length(sintomasUnicos)
        indices = bloomHashes(sintomasUnicos{i}, tamanhoFiltro, numHashFuncs);
        filtroBloom(indices) = true;
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
