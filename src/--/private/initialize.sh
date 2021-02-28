specs -- private loadDefaultConfigVariables
# specs -- extensions initAll
# ^--- NOTE extensions will get init called TWICE if they provided themselves as environment variables. After configFile loading, we init AGAIN