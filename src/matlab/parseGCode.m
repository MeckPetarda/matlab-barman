function [res] = parseGCode(code)
    words = split(code, " ");
    res = [];

    for i = 1:size(words)
        parts = split(words(i), ";");
        res = cat(1, res, parts);
    end

end
