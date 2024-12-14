function bloomFilter = createBloomFilter(sintomasUnicos, m, k)
    % m: tamanho do vetor de bits
    % k: número de funções hash
    bloomFilter = zeros(m, 1);
    hashFunctions = cell(k, 1);
    for i = 1:k
        hashFunctions{i} = @(x) mod(sum(double(x)), m) + 1; % Função hash simples, pode ser refinada
    end

    for i = 1:length(sintomasUnicos)
        for j = 1:k
            index = hashFunctions{j}(sintomasUnicos{i});
            bloomFilter(index) = 1;
        end
    end
end


% Verificar se um sintoma está no filtro
function isPresent = checkBloomFilter(sintoma, bloomFilter, hashFunctions)
    isPresent = true;
    for i = 1:length(hashFunctions)
        index = hashFunctions{i}(sintoma);
        if bloomFilter(index) == 0
            isPresent = false;
            break;
        end
    end
end