function commies = combineLayers(layers, hu)

%Find the length we are going tu have in the end
len = 0;
for i=1:length(layers)
    len = len + length(hu)^(layers(i));
end

%Pre-index
commies = cell(len,1);
index = 1;
for i=1:length(layers)
    m = permn(hu, layers(i));
    for j=1:length(m)
        commies{index} = m(j,:);
        index = index + 1;
    end      
end
end