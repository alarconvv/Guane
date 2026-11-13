# Guane phylogenetic signal: open in RStudio and Source.
# Prepared inputs and plotting functions are embedded. Edit plot_settings below.
# Install once if needed: install.packages(c("ape", "phytools"))
# R 4.6.0; ape 5.8.1; phytools 2.5.2
guane_dictionary <- local({
dictionary <- structure(list(c("El soporte de MuSSE es exploratorio: la heterogeneidad de tasas no modelada puede imitar dependencia del carácter. No hay modelos nulos ocultos multiestado; la tarjeta de estados ocultos solo admite caracteres binarios.", 
"O suporte de MuSSE é exploratório: a heterogeneidade de taxas não modelada pode imitar dependência do caráter. Não há modelos nulos ocultos multiestado; o cartão de estados ocultos aceita apenas caracteres binários."
), c("Estimaciones puntuales de tasas; los intervalos de perfil se muestran por separado.", 
"Estimativas pontuais de taxas; os intervalos de perfil são mostrados separadamente."
), c("Las tasas se condicionan a un árbol, estados, muestreo y raíz. Los intervalos de perfil requieren ajustes verificados; no hay pruebas calibradas de razón de verosimilitudes.", 
"As taxas se condicionam a uma árvore, estados, amostragem e raiz. Intervalos de perfil exigem ajustes verificados; não há testes calibrados de razão de verossimilhanças."
), c("Refinada", "Refinada"), c("Dominio ampliado", "Domínio ampliado"
), c("Inicios fallidos", "Inícios falhos"), c("Verificación independiente del optimizador", 
"Verificação independente do otimizador"), c("Ajustado", "Ajustado"
), c("Verificación", "Verificação"), c("Iteraciones nativas", 
"Iterações nativas"), c("Cruce del umbral", "Cruzamento do limiar"
), c("Tramo del perfil fallido", "Trecho do perfil falho"), c("Límite de búsqueda alcanzado", 
"Limite de busca atingido"), c("El ajuste requiere revisión", 
"O ajuste exige revisão"), c("Ejecute primero un análisis de perfil.", 
"Execute primeiro uma análise de perfil."), c("Ejecute primero los reajustes de robustez.", 
"Execute primeiro os reajustes de robustez."), c("No hay reajuste comparable; revise diagnósticos.", 
"Não há reajuste comparável; revise os diagnósticos."), c("Resuelva los ajustes fallidos antes de los reajustes de robustez.", 
"Resolva os ajustes falhos antes dos reajustes de robustez."), 
    c("No hay resultados finitos del optimizador.", "Não há resultados finitos do otimizador."
    ), c("Configuración de verificación no válida.", "Configurações de verificação inválidas."
    ), c("La captura del optimizador requiere la versión validada hisse 2.1.11.", 
    "A captura do otimizador exige a versão validada hisse 2.1.11."
    ), c("Falló la captura del optimizador HiSSE; no hay estado verificado.", 
    "A captura do otimizador HiSSE falhou; não há estado verificado."
    ), c("Los pesos AIC requieren ajustes compatibles, verificados, repetibles e interiores. No establecen causalidad.", 
    "Os pesos AIC exigem ajustes compatíveis, verificados, repetíveis e interiores. Não estabelecem causalidade."
    ), c("Verificar con un optimizador independiente", "Verificar com um otimizador independente"
    ), c("Máximo de evaluaciones del optimizador", "Máximo de avaliações do otimizador"
    ), c("Se conserva el estado del optimizador. Los pesos requieren ajustes convergentes, repetibles, interiores y acuerdo con un optimizador independiente.", 
    "O estado do otimizador é mantido. Os pesos exigem ajustes convergentes, repetíveis, interiores e concordância com um otimizador independente."
    ), c("Pesos omitidos: revise terminación, verificación, inicios, límites y restricciones duplicadas.", 
    "Pesos omitidos: revise término, verificação, inícios, limites e restrições duplicadas."
    ), c("Los pesos describen solo el conjunto compatible y verificado; no establecen causalidad.", 
    "Os pesos descrevem apenas o conjunto compatível e verificado; não estabelecem causalidade."
    ), c("La verificación independiente falló o discrepó. Se omiten pesos e intervalos.", 
    "A verificação independente falhou ou discordou. Pesos e intervalos são omitidos."
    ), c("Revise terminación y acuerdo entre optimizadores en Diagnósticos", 
    "Revise término e concordância entre otimizadores em Diagnósticos"
    ), c("Subplex conserva el límite inferior de log-tasa de -20. El límite de evaluaciones es editable. Los ajustes largos son síncronos.", 
    "Subplex mantém o limite inferior de log-taxa de -20. O limite de avaliações é editável. Ajustes longos são síncronos."
    ), c("Incertidumbre por perfil", "Incerteza por perfil"), 
    c("Elija modelo y parámetro en Controles del gráfico y defina los límites de búsqueda del perfil.", 
    "Escolha modelo e parâmetro nos Controles do gráfico e defina os limites de busca do perfil."
    ), c("Límite inferior de búsqueda del perfil", "Limite inferior de busca do perfil"
    ), c("Límite superior de búsqueda del perfil", "Limite superior de busca do perfil"
    ), c("Puntos de la cuadrícula del perfil", "Pontos da grade do perfil"
    ), c("Nivel de confianza del perfil", "Nível de confiança do perfil"
    ), c("Calcular incertidumbre por perfil", "Calcular incerteza por perfil"
    ), c("Perfil de verosimilitud", "Perfil de verossimilhança"
    ), c("Descargar perfil CSV", "Baixar perfil CSV"), c("Descargar intervalo CSV", 
    "Baixar intervalo CSV"), c("Resuelva los diagnósticos antes de calcular intervalos de perfil.", 
    "Resolva os diagnósticos antes de calcular intervalos de perfil."
    ), c("Seleccione un grupo de parámetros estimado para el perfil.", 
    "Selecione um grupo de parâmetros estimado para o perfil."
    ), c("Los límites del perfil deben rodear la estimación dentro de los límites del ajuste.", 
    "Os limites do perfil devem envolver a estimativa dentro dos limites do ajuste."
    ), c("Los intervalos usan una referencia chi-cuadrado aproximada condicionada al árbol y modelo. Los tramos fallidos y límites de búsqueda no son extremos del intervalo.", 
    "Os intervalos usam referência qui-quadrado aproximada condicionada à árvore e ao modelo. Trechos falhos e limites de busca não são extremos do intervalo."
    ), c("Intervalos de perfil aproximados; revise fallos y límites de búsqueda", 
    "Intervalos de perfil aproximados; revise falhas e limites de busca"
    ), c("El perfil encontró una verosimilitud mayor. Reajuste antes de interpretar.", 
    "O perfil encontrou uma verossimilhança maior. Reajuste antes de interpretar."
    ), c("Los intervalos opcionales requieren ajustes verificados; no hay pruebas de razón de verosimilitudes calibradas.", 
    "Os intervalos opcionais exigem ajustes verificados; não há testes de razão de verossimilhanças calibrados."
    ), c("Reajustes de robustez", "Reajustes de robustez"), c("Factor de ampliación del dominio", 
    "Fator de ampliação do domínio"), c("Ejecutar reajustes de cuadrícula y dominio", 
    "Executar reajustes de grade e domínio"), c("Reajustes de cuadrícula y dominio", 
    "Reajustes de grade e domínio"), c("Descargar robustez CSV", 
    "Baixar robustez CSV"), c("Cambio en log-verosimilitud alineada", 
    "Mudança na log-verossimilhança alinhada"), c("Los reajustes conservan las estimaciones originales. La sensibilidad no resuelta de cuadrícula o dominio impide pesos; no implica intervalos.", 
    "Os reajustes preservam as estimativas originais. Sensibilidade não resolvida de grade ou domínio impede pesos; não implica intervalos."
    ), c("La robustez requiere nx máximo de 2048 y multiplicador ampliado del dominio máximo de 30.", 
    "A robustez exige nx máximo de 2048 e multiplicador ampliado do domínio máximo de 30."
    ), c("Verificado", "Verificado"), c("Estado de verificación", 
    "Estado de verificação"), c("LogLik de verificación", 
    "LogLik de verificação"), c("Mensaje de verificación", 
    "Mensagem de verificação"), c("Mensaje del optimizador", 
    "Mensagem do otimizador"), c("Evaluaciones", "Avaliações"
    ), c("Repetible", "Repetível"), c("Estado inferior", "Estado inferior"
    ), c("Estado superior", "Estado superior"), c("Nivel", "Nível"
    ), c("Comparable", "Comparável"), c("LogLik alineada", "LogLik alinhada"
    ), c("Cambio", "Mudança"), c("Estado 0", "Estado 0"), c("Fracción de muestreo: estado 0", 
    "Fração amostral: estado 0"), c("Fracción de muestreo: estado 1", 
    "Fração amostral: estado 1"), c("El soporte de BiSSE es exploratorio. Use la tarjeta de estados ocultos y modelos nulos para reajustar candidatos binarios compatibles.", 
    "O suporte de BiSSE é exploratório. Use o cartão de estados ocultos e modelos nulos para reajustar candidatos binários compatíveis."
    ), c("Ejecutar modelos de estados ocultos", "Executar modelos de estados ocultos"
    ), c("Restricciones de fracción de extinción", "Restrições da fração de extinção"
    ), c("Compartida", "Compartilhada"), c("Por clase de diversificación", 
    "Por classe de diversificação"), c("Extinción cero", "Extinção zero"
    ), c("Condicionamiento de la raíz", "Condicionamento da raiz"
    ), c("Pesos de raíz", "Pesos da raiz"), c("Verosimilitud", 
    "Verossimilhança"), c("Especificados", "Especificados"), 
    c("Probabilidad especificada del estado observado 0", "Probabilidade especificada do estado observado 0"
    ), c("Los pesos de raíz dividen cada probabilidad observada por igual entre clases ocultas. Los candidatos comparten codificación, muestreo y configuración de raíz.", 
    "Os pesos da raiz dividem cada probabilidade observada igualmente entre classes ocultas. Os candidatos compartilham codificação, amostragem e ajustes da raiz."
    ), c("Restricciones del modelo personalizado", "Restrições do modelo personalizado"
    ), c("Clases ocultas en Personalizado", "Classes ocultas em Personalizado"
    ), c("Índices de recambio (separados por comas)", "Índices de renovação (separados por vírgulas)"
    ), c("Índices de fracción de extinción (separados por comas)", 
    "Índices de fração de extinção (separados por vírgulas)"
    ), c("Completar restricciones personalizadas", "Preencher restrições personalizadas"
    ), c("Índices de transición (CSV sin encabezado)", "Índices de transição (CSV sem cabeçalho)"
    ), c("Solo Personalizado: orden 0A,1A,0B,1B y después 0C,1C,0D,1D para cuatro clases. Índices positivos consecutivos comparten parámetros. Cero fija fracciones de extinción o transiciones en cero. Se prohíben cambios observados y ocultos simultáneos.", 
    "Apenas Personalizado: ordem 0A,1A,0B,1B e depois 0C,1C,0D,1D para quatro classes. Índices positivos consecutivos compartilham parâmetros. Zero fixa frações de extinção ou transições em zero. Mudanças observadas e ocultas simultâneas são proibidas."
    ), c("Los modelos CID ligan la diversificación entre estados observados dentro de cada clase oculta. Las clases ocultas no se observan ni se asignan a las puntas.", 
    "Os modelos CID vinculam diversificação entre estados observados dentro de cada classe oculta. As classes ocultas não são observadas nem atribuídas às pontas."
    ), c("Usar recocido simulado", "Usar recozimento simulado"
    ), c("Evaluaciones del objetivo de recocido", "Avaliações do objetivo de recozimento"
    ), c("Tolerancia relativa del optimizador", "Tolerância relativa do otimizador"
    ), c("Recambio inicial", "Renovação inicial"), c("Fracción de extinción inicial", 
    "Fração de extinção inicial"), c("Tasa de transición inicial", 
    "Taxa de transição inicial"), c("Límite superior de recambio", 
    "Limite superior de renovação"), c("Límite superior de fracción de extinción", 
    "Limite superior da fração de extinção"), c("Límite superior de transición", 
    "Limite superior de transição"), c("Umbral de rechazo de ODE", 
    "Limiar de rejeição de ODE"), c("Subplex nativo acotado usa hasta 100000 evaluaciones y límite inferior de log-tasa -20. Estos límites no son editables aquí. Las ejecuciones largas son síncronas.", 
    "Subplex nativo limitado usa até 100000 avaliações e limite inferior de log-taxa -20. Esses limites não são editáveis aqui. Execuções longas são síncronas."
    ), c("HiSSE no expone el estado de terminación del optimizador. Un ajuste finito no confirma convergencia; se omiten los pesos automáticos.", 
    "HiSSE não expõe o estado de término do otimizador. Um ajuste finito não confirma convergência; os pesos automáticos são omitidos."
    ), c("Recambio = lambda + mu; fracción de extinción = mu / lambda. Las etiquetas ocultas pueden intercambiarse entre ajustes. Las tasas usan unidades de longitud de rama.", 
    "Renovação = lambda + mu; fração de extinção = mu / lambda. Rótulos ocultos podem trocar entre ajustes. As taxas usam unidades de comprimento de ramo."
    ), c("Compare solo modelos reajustados en esta tarjeta con los mismos datos y configuración de verosimilitud. No combine AIC de otras tarjetas.", 
    "Compare apenas modelos reajustados neste cartão com os mesmos dados e ajustes de verossimilhança. Não combine AIC de outros cartões."
    ), c("Seleccione un carácter binario y ejecute modelos de estados ocultos.", 
    "Selecione um caráter binário e execute modelos de estados ocultos."
    ), c("Las entradas de estados ocultos cambiaron. Ejecute de nuevo para actualizar resultados.", 
    "As entradas de estados ocultos mudaram. Execute novamente para atualizar resultados."
    ), c("Ajustando modelos de estados ocultos", "Ajustando modelos de estados ocultos"
    ), c("Ajuste de estados ocultos terminado. Revise ajustes finitos, inicios y limitaciones del motor.", 
    "Ajuste de estados ocultos concluído. Revise ajustes finitos, inícios e limitações do motor."
    ), c("No hay ajuste finito de estados ocultos. Revise diagnósticos.", 
    "Nenhum ajuste finito de estados ocultos. Revise diagnósticos."
    ), c("Análisis de estados ocultos completado.", "Análise de estados ocultos concluída."
    ), c("Las diferencias de AIC son provisionales. El estado de terminación del optimizador no está disponible; no se informan pesos de modelos.", 
    "As diferenças de AIC são provisórias. O estado de término do otimizador não está disponível; não são informados pesos de modelos."
    ), c("Instale el paquete R hisse para ejecutar modelos de estados ocultos.", 
    "Instale o pacote R hisse para executar modelos de estados ocultos."
    ), c("Configuración de modelo de estados ocultos no válida.", 
    "Configurações de modelo de estados ocultos inválidas."
    ), c("Vector de índices de parámetros no válido.", "Vetor de índices de parâmetros inválido."
    ), c("Use índices consecutivos; cero solo se permite para fracciones de extinción.", 
    "Use índices consecutivos; zero é permitido apenas para frações de extinção."
    ), c("Matriz de transición de estados ocultos no válida.", 
    "Matriz de transição de estados ocultos inválida."), c("Solo se admiten cambios simples de estado observado o clase oculta; use cero en las otras entradas.", 
    "Apenas mudanças simples de estado observado ou classe oculta são suportadas; use zero nas demais entradas."
    ), c("Los índices de transición deben ser enteros positivos consecutivos; cero prohíbe una transición.", 
    "Os índices de transição devem ser inteiros positivos consecutivos; zero proíbe uma transição."
    ), c("Seleccione modelos de estados ocultos admitidos.", 
    "Selecione modelos de estados ocultos suportados."), c("Configuración de muestreo o raíz de estados ocultos no válida.", 
    "Configurações de amostragem ou raiz de estados ocultos inválidas."
    ), c("Configuración del optimizador de estados ocultos no válida.", 
    "Configurações do otimizador de estados ocultos inválidas."
    ), c("Los inicios deben ser positivos y menores que límites superiores finitos.", 
    "Os inícios devem ser positivos e menores que limites superiores finitos."
    ), c("Las clases ocultas son categorías latentes de tasas, no caracteres biológicos identificados. No se proporcionan intervalos de incertidumbre ni pruebas calibradas de razón de verosimilitud.", 
    "As classes ocultas são categorias latentes de taxas, não caracteres biológicos identificados. Não são fornecidos intervalos de incerteza nem testes calibrados de razão de verossimilhança."
    ), c("Un parámetro de estados ocultos alcanzó un límite. Revise identificabilidad y límites.", 
    "Um parâmetro de estados ocultos atingiu um limite. Revise identificabilidade e limites."
    ), c("Los inicios de estados ocultos discrepan. Aumente la búsqueda antes de interpretar diferencias entre modelos.", 
    "Os inícios de estados ocultos discordam. Aumente a busca antes de interpretar diferenças entre modelos."
    ), c("HiSSE se ajusta peor que su submodelo CID-2. Aumente la búsqueda antes de interpretar.", 
    "HiSSE ajusta pior que seu submodelo CID-2. Aumente a busca antes de interpretar."
    ), c("Seleccione un gráfico de estados ocultos admitido.", 
    "Selecione um gráfico de estados ocultos suportado."), c("Verosimilitudes finitas; terminación del optimizador no disponible", 
    "Verossimilhanças finitas; término do otimizador indisponível"
    ), c("Las categorías ocultas no son caracteres biológicos identificados", 
    "As categorias ocultas não são caracteres biológicos identificados"
    ), c("Estado de destino", "Estado de destino"), c("Estado de origen", 
    "Estado de origem"), c("Recambio", "Renovação"), c("Fracción de extinción", 
    "Fração de extinção"), c("Especiación", "Especiação"
    ), c("Extinción", "Extinção"), c("Diversificación neta", 
    "Diversificação líquida"), c("Finito", "Finito"), c("Las tasas QuaSSE ligadas tienen valores fijos o límites incompatibles.", 
    "As taxas QuaSSE ligadas têm valores fixos ou limites incompatíveis."
    ), c("Una tasa QuaSSE alcanzó un límite. Revise límites e identificabilidad antes de interpretar.", 
    "Uma taxa QuaSSE atingiu um limite. Revise limites e identificabilidade antes de interpretar."
    ), c("La verosimilitud QuaSSE cambió con una tolerancia de integración más estricta. Se omiten los pesos.", 
    "A verossimilhança QuaSSE mudou com tolerância de integração mais rigorosa. Os pesos são omitidos."
    ), c("Los inicios de QuaSSE discrepan o un intento sin convergencia es mejor. Reajuste antes de interpretar el soporte.", 
    "Os inícios de QuaSSE discordam ou uma tentativa sem convergência é melhor. Reajuste antes de interpretar o suporte."
    ), c("Configuración gráfica QuaSSE no válida.", "Configurações gráficas QuaSSE inválidas."
    ), c("Verosimilitud QuaSSE no finita.", "Verossimilhança QuaSSE não finita."
    ), c("Ejecutar QuaSSE", "Executar QuaSSE"), c("Columna de error de medición", 
    "Coluna de erro de medição"), c("Error estándar común", 
    "Erro padrão comum"), c("Error estándar de medición común", 
    "Erro padrão de medição comum"), c("Indique errores estándar de las medias en unidades del carácter. El valor común se usa solo sin columna de error; no se admiten ceros ni valores faltantes.", 
    "Informe erros padrão das médias nas unidades do caráter. O valor comum é usado apenas sem coluna de erro; zeros e valores ausentes não são aceitos."
    ), c("Función de especiación", "Função de especiação"
    ), c("Función de extinción", "Função de extinção"), 
    c("Comparar con tasas constantes", "Comparar com taxas constantes"
    ), c("Constante", "Constante"), c("Exponencial", "Exponencial"
    ), c("Sigmoide", "Sigmoide"), c("Seleccionado", "Selecionado"
    ), c("Constante: c. Exponencial: base * exp(slope * x). Sigmoide: y0 + (y1-y0) * plogis(r * (x-xmid)). La deriva se fija en cero inicialmente; edite Fixed para estimarla.", 
    "Constante: c. Exponencial: base * exp(slope * x). Sigmoide: y0 + (y1-y0) * plogis(r * (x-xmid)). A deriva é fixada em zero inicialmente; edite Fixed para estimá-la."
    ), c("Fracción de muestreo", "Fração de amostragem"), 
    c("Uniforme (ROOT.FLAT)", "Uniforme (ROOT.FLAT)"), c("Densidad normal (ROOT.GIVEN)", 
    "Densidade normal (ROOT.GIVEN)"), c("Media de raíz especificada", 
    "Média da raiz especificada"), c("Desviación estándar de raíz especificada", 
    "Desvio padrão da raiz especificado"), c("Los ajustes de raíz especificados se usan solo en ROOT.GIVEN. ROOT.OBS se basa en verosimilitud; ROOT.FLAT es uniforme en el dominio numérico. Los candidatos comparten estos ajustes.", 
    "Os ajustes da raiz especificados são usados apenas em ROOT.GIVEN. ROOT.OBS se baseia na verossimilhança; ROOT.FLAT é uniforme no domínio numérico. Os candidatos compartilham esses ajustes."
    ), c("Tabla de parámetros QuaSSE (CSV)", "Tabela de parâmetros QuaSSE (CSV)"
    ), c("Columnas: Parameter,Group,Fixed,Start,Lower,Upper. Grupos iguales ligan parámetros; Fixed numérico fija el grupo. Pendientes, puntos medios y deriva admiten signos; difusión debe ser positiva. Borre la tabla al cambiar funciones de tasas.", 
    "Colunas: Parameter,Group,Fixed,Start,Lower,Upper. Grupos iguais vinculam parâmetros; Fixed numérico fixa o grupo. Inclinações, pontos médios e deriva admitem sinais; difusão deve ser positiva. Limpe a tabela ao alterar funções de taxas."
    ), c("Controles de integración numérica", "Controles de integração numérica"
    ), c("Motor FFT", "Motor FFT"), c("Celdas de la malla del carácter", 
    "Células da grade do caráter"), c("Multiplicador de resolución en puntas", 
    "Multiplicador da resolução nas pontas"), c("Paso temporal máximo / profundidad del árbol", 
    "Passo temporal máximo / profundidade da árvore"), c("Cambio de resolución / profundidad del árbol", 
    "Mudança de resolução / profundidade da árvore"), c("Multiplicador del rango del carácter", 
    "Multiplicador da amplitude do caráter"), c("Centro de malla (vacío = centro observado)", 
    "Centro da grade (vazio = centro observado)"), c("Ancho de convolución (desviaciones estándar)", 
    "Largura da convolução (desvios padrão)"), c("Integrar puntas juntas (solo fftC)", 
    "Integrar pontas juntas (apenas fftC)"), c("Cada ajuste se verifica duplicando las celdas y reduciendo a la mitad el paso temporal. La inestabilidad suprime pesos de modelos. Aumente resolución y reajuste si fallan los diagnósticos.", 
    "Cada ajuste é verificado duplicando células e reduzindo pela metade o passo temporal. A instabilidade suprime pesos dos modelos. Aumente a resolução e reajuste se os diagnósticos falharem."
    ), c("Tasas frente al carácter", "Taxas em função do caráter"
    ), c("Caracteres y errores de medición", "Caracteres e erros de medição"
    ), c("Las tasas usan unidades de longitud de rama; la deriva usa unidades del carácter por unidad de rama y la difusión unidades del carácter al cuadrado por unidad de rama. Las curvas cubren solo el rango observado.", 
    "As taxas usam unidades de comprimento de ramo; a deriva usa unidades do caráter por unidade de ramo e a difusão unidades do caráter ao quadrado por unidade de ramo. As curvas cobrem apenas a amplitude observada."
    ), c("Seleccione un carácter continuo y ejecute QuaSSE.", 
    "Selecione um caráter contínuo e execute QuaSSE."), c("Las entradas QuaSSE cambiaron. Ejecute de nuevo para actualizar resultados.", 
    "As entradas QuaSSE mudaram. Execute novamente para atualizar resultados."
    ), c("Ajustando modelos QuaSSE", "Ajustando modelos QuaSSE"
    ), c("QuaSSE completado. Revise convergencia y sensibilidad a la malla.", 
    "QuaSSE concluído. Revise convergência e sensibilidade à grade."
    ), c("No hay ajuste QuaSSE válido. Revise los diagnósticos.", 
    "Nenhum ajuste QuaSSE válido. Revise os diagnósticos."), 
    c("Análisis QuaSSE completado.", "Análise QuaSSE concluída."
    ), c("Los pesos QuaSSE no están disponibles. Revise ajustes individuales y diagnósticos.", 
    "Os pesos QuaSSE não estão disponíveis. Revise ajustes individuais e diagnósticos."
    ), c("Seleccione funciones de tasas QuaSSE admitidas.", "Selecione funções de taxas QuaSSE suportadas."
    ), c("QuaSSE requiere un árbol binario resuelto con al menos cuatro puntas.", 
    "QuaSSE exige uma árvore binária resolvida com pelo menos quatro pontas."
    ), c("Seleccione columnas distintas de taxón y carácter continuo.", 
    "Selecione colunas distintas de táxon e caráter contínuo."
    ), c("Haga coincidir taxones del árbol y la tabla en Datos antes de QuaSSE.", 
    "Faça corresponder táxons da árvore e tabela em Dados antes de QuaSSE."
    ), c("QuaSSE requiere observaciones continuas finitas y no constantes.", 
    "QuaSSE exige observações contínuas finitas e não constantes."
    ), c("Seleccione una columna válida de error de medición.", 
    "Selecione uma coluna válida de erro de medição."), c("Los errores estándar de medición QuaSSE deben ser positivos y finitos.", 
    "Os erros padrão de medição QuaSSE devem ser positivos e finitos."
    ), c("Configuración de integración QuaSSE no válida.", 
    "Configurações de integração QuaSSE inválidas."), c("La malla QuaSSE debe contener todos los valores observados.", 
    "A grade QuaSSE deve conter todos os valores observados."
    ), c("Tabla de parámetros QuaSSE no válida.", "Tabela de parâmetros QuaSSE inválida."
    ), c("Inicios, parámetros fijos y límites QuaSSE son inconsistentes.", 
    "Inícios, parâmetros fixos e limites QuaSSE são inconsistentes."
    ), c("Configuración de muestreo o raíz QuaSSE no válida.", 
    "Configurações de amostragem ou raiz QuaSSE inválidas."
    ), c("El orden de parámetros del motor QuaSSE es incompatible.", 
    "A ordem dos parâmetros do motor QuaSSE é incompatível."
    ), c("Configuración del optimizador QuaSSE no válida.", 
    "Configurações do otimizador QuaSSE inválidas."), c("QuaSSE es exploratorio: heterogeneidad oculta de tasas puede imitar dependencia del carácter. No se proporcionan intervalos de incertidumbre ni modelos nulos de estados ocultos.", 
    "QuaSSE é exploratório: heterogeneidade oculta de taxas pode imitar dependência do caráter. Não são fornecidos intervalos de incerteza nem modelos nulos de estados ocultos."
    ), c("Los errores de medición son errores estándar de las medias en las unidades suministradas y se consideran conocidos.", 
    "Os erros de medição são erros padrão das médias nas unidades fornecidas e são considerados conhecidos."
    ), c("Las verificaciones de malla y paso temporal evalúan parámetros ajustados sin reajustar. No garantizan convergencia numérica.", 
    "As verificações de grade e passo temporal avaliam parâmetros ajustados sem reajuste. Não garantem convergência numérica."
    ), c("La malla en puntas es más gruesa que un error estándar de medición. Aumente resolución; se retienen los pesos de modelos.", 
    "A grade nas pontas é mais grossa que um erro padrão de medição. Aumente a resolução; os pesos dos modelos são omitidos."
    ), c("Seleccione un gráfico QuaSSE admitido.", "Selecione um gráfico QuaSSE suportado."
    ), c("Caracteres observados y errores estándar de medición", 
    "Caracteres observados e erros padrão de medição"), c("Las barras muestran más/menos un error estándar de medición, no intervalos de confianza.", 
    "As barras mostram mais/menos um erro padrão de medição, não intervalos de confiança."
    ), c("La verosimilitud QuaSSE cambió tras refinar y normalizar la malla. Se omiten los pesos de modelos.", 
    "A verossimilhança QuaSSE mudou após refinar e normalizar a grade. Os pesos dos modelos são omitidos."
    ), c("Las verosimilitudes refinadas consideran la constante del espaciado de malla del motor al condicionar por supervivencia. Se muestran valores brutos y ajuste por separado; compare AIC solo dentro de esta ejecución.", 
    "As verossimilhanças refinadas consideram a constante do espaçamento da grade do motor ao condicionar por sobrevivência. Valores brutos e ajuste são mostrados separadamente; compare AIC apenas nesta execução."
    ), c("LogLik refinado bruto", "LogLik refinado bruto"), c("Ajuste de normalización de malla", 
    "Ajuste de normalização da grade"), c("Descargar estimaciones CSV", 
    "Baixar estimativas CSV"), c("Tabla de parámetros MuSSE (CSV)", 
    "Tabela de parâmetros MuSSE (CSV)"), c("Ejecutar MuSSE", 
    "Executar MuSSE"), c("El soporte de MuSSE es exploratorio: la heterogeneidad de tasas no modelada puede imitar dependencia del carácter. Los modelos nulos de estados ocultos aún no están implementados.", 
    "O suporte de MuSSE é exploratório: heterogeneidade de taxas não modelada pode imitar dependência do caráter. Modelos nulos de estados ocultos ainda não estão implementados."
    ), c("Las entradas de MuSSE cambiaron. Ejecute de nuevo para actualizar resultados.", 
    "As entradas de MuSSE mudaram. Execute novamente para atualizar resultados."
    ), c("Ajustando modelos MuSSE", "Ajustando modelos MuSSE"
    ), c("MuSSE completado. Revise convergencia, límites y supuestos del modelo.", 
    "MuSSE concluído. Revise convergência, limites e pressupostos do modelo."
    ), c("No hay ajuste MuSSE válido. Revise los diagnósticos.", 
    "Nenhum ajuste MuSSE válido. Revise os diagnósticos."), 
    c("Análisis MuSSE completado.", "Análise MuSSE concluída."
    ), c("Los pesos de clasificación MuSSE no están disponibles. Revise ajustes individuales y diagnósticos.", 
    "Os pesos de classificação MuSSE não estão disponíveis. Revise ajustes individuais e diagnósticos."
    ), c("MuSSE requiere un árbol binario resuelto con al menos cuatro puntas.", 
    "MuSSE exige uma árvore binária resolvida com pelo menos quatro pontas."
    ), c("Haga coincidir explícitamente los taxones del árbol y la tabla en Datos antes de MuSSE.", 
    "Faça corresponder explicitamente os táxons da árvore e da tabela em Dados antes de MuSSE."
    ), c("Tabla de parámetros MuSSE no válida.", "Tabela de parâmetros MuSSE inválida."
    ), c("Los inicios y tasas fijas de MuSSE deben respetar límites finitos no negativos.", 
    "Os inícios e taxas fixas de MuSSE devem respeitar limites finitos não negativos."
    ), c("Seleccione modelos MuSSE admitidos.", "Selecione modelos MuSSE suportados."
    ), c("Las tasas MuSSE ligadas tienen valores fijos o límites incompatibles.", 
    "As taxas MuSSE ligadas têm valores fixos ou limites incompatíveis."
    ), c("Configuración de verosimilitud MuSSE no válida.", 
    "Configurações de verossimilhança MuSSE inválidas."), 
    c("Configuración del optimizador MuSSE no válida.", "Configurações do otimizador MuSSE inválidas."
    ), c("Configuración de integración MuSSE no válida.", 
    "Configurações de integração MuSSE inválidas."), c("Una tasa MuSSE alcanzó un límite. Revise límites e identificabilidad antes de interpretar.", 
    "Uma taxa MuSSE atingiu um limite. Revise limites e identificabilidade antes de interpretar."
    ), c("La verosimilitud MuSSE cambió con una tolerancia de integración más estricta. Se omiten los pesos.", 
    "A verossimilhança MuSSE mudou com tolerância de integração mais rigorosa. Os pesos são omitidos."
    ), c("Los inicios de MuSSE discrepan o un intento sin convergencia es mejor. Reajuste antes de interpretar el soporte.", 
    "Os inícios de MuSSE discordam ou uma tentativa sem convergência é melhor. Reajuste antes de interpretar o suporte."
    ), c("Configuración gráfica MuSSE no válida.", "Configurações gráficas MuSSE inválidas."
    ), c("Tasas de transición MuSSE", "Taxas de transição MuSSE"
    ), c("Carácter discreto", "Caráter discreto"), c("Completar tabla de estados", 
    "Preencher tabela de estados"), c("Tabla de estados MuSSE (CSV)", 
    "Tabela de estados MuSSE (CSV)"), c("Columnas: State,Sampling,RootWeight. Cada estado observado debe aparecer una vez. El orden de filas define códigos de 1 a k. En blanco se usan estados ordenados, muestreo completo y pesos de raíz iguales. RootWeight se usa solo con ROOT.GIVEN.", 
    "Colunas: State,Sampling,RootWeight. Cada estado observado deve aparecer uma vez. A ordem das linhas define códigos de 1 a k. Em branco, usam-se estados ordenados, amostragem completa e pesos da raiz iguais. RootWeight é usado apenas com ROOT.GIVEN."
    ), c("MuSSE trata cada etiqueta como un estado categórico, no como polimorfismo o incertidumbre. Se admiten de dos a ocho estados observados.", 
    "MuSSE trata cada rótulo como um estado categórico, não como polimorfismo ou incerteza. São suportados de dois a oito estados observados."
    ), c("La comparación predeterminada comparte una tasa de transición entre estados. Completo y otras restricciones siguen disponibles.", 
    "A comparação padrão compartilha uma taxa de transição entre estados. Completo e outras restrições continuam disponíveis."
    ), c("La ponderación de raíz en equilibrio no está disponible en el motor multiestado instalado.", 
    "A ponderação da raiz em equilíbrio não está disponível no mecanismo multiestado instalado."
    ), c("Columnas: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda1 a lambdak, mu1 a muk y qij para transiciones dirigidas (origen i, destino j). En blanco se usan valores ajustados al árbol. Group y Fixed solo se aplican a Personalizado. Un mismo Group iguala tasas; un Fixed numérico fija todo el grupo.", 
    "Colunas: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda1 a lambdak, mu1 a muk e qij para transições direcionadas (origem i, destino j). Em branco, usam-se valores ajustados à árvore. Group e Fixed aplicam-se apenas a Personalizado. O mesmo Group iguala taxas; um Fixed numérico fixa todo o grupo."
    ), c("lambdai es especiación, mui es extinción y qij es la transición del estado i al j. Las tasas son por unidad de longitud de rama.", 
    "lambdai é especiação, mui é extinção e qij é a transição do estado i para j. As taxas são por unidade de comprimento de ramo."
    ), c("Diversificación y transiciones iguales", "Diversificação e transições iguais"
    ), c("Transiciones simétricas", "Transições simétricas"
    ), c("MuSSE admite de dos a ocho estados observados.", "MuSSE suporta de dois a oito estados observados."
    ), c("Seleccione un carácter discreto para MuSSE.", "Selecione um caráter discreto para MuSSE."
    ), c("Seleccione un carácter discreto y ejecute MuSSE.", 
    "Selecione um caráter discreto e execute MuSSE."), c("MuSSE requiere observaciones categóricas finitas sin valores faltantes.", 
    "MuSSE exige observações categóricas finitas sem valores ausentes."
    ), c("Tabla de estados MuSSE no válida.", "Tabela de estados MuSSE inválida."
    ), c("La tabla MuSSE debe incluir cada estado observado exactamente una vez.", 
    "A tabela MuSSE deve incluir cada estado observado exatamente uma vez."
    ), c("Las fracciones de muestreo MuSSE deben ser mayores que cero y como máximo uno.", 
    "As frações de amostragem MuSSE devem ser maiores que zero e no máximo um."
    ), c("Seleccione columnas diferentes para taxones y carácter discreto.", 
    "Selecione colunas diferentes para táxons e caráter discreto."
    ), c("MuSSE admite pesos de raíz observados, iguales o especificados; no admite raíces en equilibrio.", 
    "MuSSE suporta pesos da raiz observados, iguais ou especificados; raízes em equilíbrio não estão disponíveis."
    ), c("El orden de parámetros del motor MuSSE es incompatible.", 
    "A ordem dos parâmetros do mecanismo MuSSE é incompatível."
    ), c("Pocos taxones o estados desequilibrados pueden producir tasas débilmente identificadas. Esta advertencia no define un umbral de suficiencia.", 
    "Poucos táxons ou estados desequilibrados podem produzir taxas fracamente identificadas. Este aviso não define um limiar de suficiência."
    ), c("Un candidato tiene al menos tantas tasas libres como puntas observadas. La interpretación está muy limitada.", 
    "Um candidato tem pelo menos tantas taxas livres quanto pontas observadas. A interpretação é muito limitada."
    ), c("Código del estado de destino", "Código do estado de destino"
    ), c("Código del estado de origen", "Código do estado de origem"
    ), c("Muestreo", "Amostragem"), c("Peso de raíz", "Peso da raiz"
    ), c("Verosimilitud MuSSE no finita.", "Verossimilhança MuSSE não finita."
    ), c("El modelo MuSSE completo ajusta peor que un candidato restringido. Aumente los inicios o refine los límites.", 
    "O modelo MuSSE completo ajusta pior que um candidato restrito. Aumente os inícios ou refine os limites."
    ), c("Verosimilitud BiSSE no finita.", "Verossimilhança BiSSE não finita."
    ), c("ROOT.OBS usa pesos de raíz basados en la verosimilitud, no frecuencias de puntas. Todos los candidatos comparten el tratamiento de raíz.", 
    "ROOT.OBS usa pesos da raiz baseados na verossimilhança, não frequências de pontas. Todos os candidatos compartilham o tratamento da raiz."
    ), c("El modelo BiSSE completo ajusta peor que un candidato restringido. Aumente los inicios o refine los límites.", 
    "O modelo BiSSE completo ajusta pior que um candidato restrito. Aumente os inícios ou refine os limites."
    ), c("Inferior", "Inferior"), c("Superior", "Superior"), 
    c("Modelos de estados ocultos y nulos", "Modelos de estados ocultos e nulos"
    ), c("Este método SSE está planificado y aún no tiene motor implementado.", 
    "Este método SSE está planejado e ainda não tem mecanismo implementado."
    ), c("Completo", "Completo"), c("Especiación igual", "Especiação igual"
    ), c("Extinción igual", "Extinção igual"), c("Transiciones iguales", 
    "Transições iguais"), c("Diversificación independiente del carácter", 
    "Diversificação independente do caráter"), c("Sin extinción", 
    "Sem extinção"), c("Personalizado", "Personalizado"), c("Carácter binario", 
    "Caráter binário"), c("Valor observado codificado como estado 0", 
    "Valor observado codificado como estado 0"), c("El otro valor observado se codifica como estado 1. Resuelva las discrepancias de taxones en Datos.", 
    "O outro valor observado é codificado como estado 1. Resolva as diferenças de táxons em Dados."
    ), c("Fracción de muestreo para el estado 0", "Fração de amostragem para o estado 0"
    ), c("Fracción de muestreo para el estado 1", "Fração de amostragem para o estado 1"
    ), c("El muestreo supone inclusión aleatoria dentro de cada estado; las fracciones se consideran conocidas.", 
    "A amostragem pressupõe inclusão aleatória dentro de cada estado; as frações são consideradas conhecidas."
    ), c("Tratamiento de la raíz", "Tratamento da raiz"), c("Observado (ROOT.OBS)", 
    "Observado (ROOT.OBS)"), c("Igual (ROOT.FLAT)", "Igual (ROOT.FLAT)"
    ), c("Equilibrio (ROOT.EQUI)", "Equilíbrio (ROOT.EQUI)"), 
    c("Especificado (ROOT.GIVEN)", "Especificado (ROOT.GIVEN)"
    ), c("Probabilidad de raíz para el estado 0", "Probabilidade da raiz para o estado 0"
    ), c("Completar tabla de parámetros", "Preencher tabela de parâmetros"
    ), c("Tabla de parámetros BiSSE (CSV)", "Tabela de parâmetros BiSSE (CSV)"
    ), c("Columnas: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda0, lambda1, mu0, mu1, q01, q10. En blanco se usan valores ajustados a la escala del árbol. Group y Fixed solo se aplican a Personalizado; los modelos predefinidos usan sus propias restricciones. Un mismo Group iguala tasas; un Fixed numérico fija todo el grupo.", 
    "Colunas: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda0, lambda1, mu0, mu1, q01, q10. Em branco, usam-se valores ajustados à escala da árvore. Group e Fixed aplicam-se apenas a Personalizado; modelos predefinidos usam suas próprias restrições. O mesmo Group iguala taxas; um Fixed numérico fixa todo o grupo."
    ), c("Inicios del optimizador", "Inícios do otimizador"), 
    c("Motor de EDO", "Mecanismo de EDO"), c("Tolerancia de EDO", 
    "Tolerância de EDO"), c("Umbral de reintento de integración (eps)", 
    "Limiar de nova tentativa de integração (eps)"), c("Ejecutar BiSSE", 
    "Executar BiSSE"), c("El soporte de BiSSE es exploratorio: la heterogeneidad de tasas no modelada puede imitar dependencia del carácter. Los modelos nulos de estados ocultos aún no están implementados.", 
    "O suporte de BiSSE é exploratório: heterogeneidade de taxas não modelada pode imitar dependência do caráter. Modelos nulos de estados ocultos ainda não estão implementados."
    ), c("Estados observados en las puntas", "Estados observados nas pontas"
    ), c("Tasas de transición", "Taxas de transição"), c("Ancho de figura (pulgadas)", 
    "Largura da figura (polegadas)"), c("Alto de figura (pulgadas)", 
    "Altura da figura (polegadas)"), c("lambda es especiación, mu es extinción, q01 y q10 son transiciones direccionales. Las tasas son por unidad de longitud de rama.", 
    "lambda é especiação, mu é extinção, q01 e q10 são transições direcionais. As taxas são por unidade de comprimento de ramo."
    ), c("AIC compara solo candidatos de esta ejecución. Los pesos requieren convergencia, estabilidad numérica y concordancia entre inicios exitosos. Los ajustes en los límites requieren cautela. El soporte AIC no implica causalidad.", 
    "AIC compara apenas candidatos desta execução. Os pesos exigem convergência, estabilidade numérica e concordância entre inícios bem-sucedidos. Ajustes nos limites exigem cautela. Suporte AIC não implica causalidade."
    ), c("Las tasas están condicionadas a un árbol, estados observados, fracciones de muestreo y tratamiento de raíz. No se proporcionan intervalos de confianza ni pruebas calibradas de razón de verosimilitud.", 
    "As taxas são condicionadas a uma árvore, estados observados, frações de amostragem e tratamento da raiz. Não são fornecidos intervalos de confiança nem testes calibrados de razão de verossimilhança."
    ), c("Los cortes de verosimilitud mantienen fijas las demás tasas libres y respetan parámetros ligados. No son intervalos de confianza ni perfiles con reajuste de parámetros restantes.", 
    "Os cortes de verossimilhança mantêm fixas as demais taxas livres e respeitam parâmetros ligados. Não são intervalos de confiança nem perfis com reajuste dos parâmetros restantes."
    ), c("Restricciones efectivas de parámetros", "Restrições efetivas dos parâmetros"
    ), c("Seleccione un carácter binario y ejecute BiSSE.", 
    "Selecione um caráter binário e execute BiSSE."), c("Las entradas de BiSSE cambiaron. Ejecute de nuevo para actualizar resultados.", 
    "As entradas de BiSSE mudaram. Execute novamente para atualizar resultados."
    ), c("Ajustando modelos BiSSE", "Ajustando modelos BiSSE"
    ), c("BiSSE completado. Revise convergencia, límites y supuestos del modelo.", 
    "BiSSE concluído. Revise convergência, limites e pressupostos do modelo."
    ), c("No hay ajuste BiSSE válido. Revise los diagnósticos.", 
    "Nenhum ajuste BiSSE válido. Revise os diagnósticos."), 
    c("Análisis BiSSE completado.", "Análise BiSSE concluída."
    ), c("Los pesos de clasificación BiSSE no están disponibles. Revise ajustes individuales y diagnósticos.", 
    "Os pesos de classificação BiSSE não estão disponíveis. Revise ajustes individuais e diagnósticos."
    ), c("BiSSE requiere un árbol binario resuelto con al menos cuatro puntas.", 
    "BiSSE exige uma árvore binária resolvida com pelo menos quatro pontas."
    ), c("Seleccione una columna de taxones y un carácter binario.", 
    "Selecione uma coluna de táxons e um caráter binário."
    ), c("Haga coincidir explícitamente los taxones del árbol y la tabla en Datos antes de BiSSE.", 
    "Faça corresponder explicitamente os táxons da árvore e da tabela em Dados antes de BiSSE."
    ), c("BiSSE requiere dos estados observados, sin valores faltantes y un estado 0 explícito.", 
    "BiSSE exige dois estados observados, sem valores ausentes e um estado 0 explícito."
    ), c("Tabla de parámetros BiSSE no válida.", "Tabela de parâmetros BiSSE inválida."
    ), c("Los inicios y tasas fijas de BiSSE deben respetar límites finitos no negativos.", 
    "Os inícios e taxas fixas de BiSSE devem respeitar limites finitos não negativos."
    ), c("Seleccione modelos BiSSE admitidos.", "Selecione modelos BiSSE suportados."
    ), c("Sin extinción requiere límites inferiores de cero para mu.", 
    "Sem extinção exige limites inferiores de zero para mu."
    ), c("Las tasas BiSSE ligadas tienen valores fijos o límites incompatibles.", 
    "As taxas BiSSE ligadas têm valores fixos ou limites incompatíveis."
    ), c("Ambas fracciones de muestreo deben ser mayores que cero y como máximo uno.", 
    "Ambas as frações de amostragem devem ser maiores que zero e no máximo um."
    ), c("Las probabilidades de raíz deben ser no negativas y sumar uno.", 
    "As probabilidades da raiz devem ser não negativas e somar um."
    ), c("Configuración de verosimilitud BiSSE no válida.", 
    "Configurações de verossimilhança BiSSE inválidas."), 
    c("Configuración del optimizador BiSSE no válida.", "Configurações do otimizador BiSSE inválidas."
    ), c("Configuración de integración BiSSE no válida.", 
    "Configurações de integração BiSSE inválidas."), c("Pocos taxones o un carácter binario desequilibrado pueden producir tasas débilmente identificadas. Esta advertencia no define un umbral de suficiencia.", 
    "Poucos táxons ou um caráter binário desequilibrado podem produzir taxas fracamente identificadas. Este aviso não define um limiar de suficiência."
    ), c("Una tasa BiSSE alcanzó un límite. Revise límites e identificabilidad antes de interpretar.", 
    "Uma taxa BiSSE atingiu um limite. Revise limites e identificabilidade antes de interpretar."
    ), c("La verosimilitud BiSSE cambió con una tolerancia de integración más estricta. Se omiten los pesos.", 
    "A verossimilhança BiSSE mudou com tolerância de integração mais rigorosa. Os pesos são omitidos."
    ), c("Los inicios de BiSSE discrepan o un intento sin convergencia es mejor. Reajuste antes de interpretar el soporte.", 
    "Os inícios de BiSSE discordam ou uma tentativa sem convergência é melhor. Reajuste antes de interpretar o suporte."
    ), c("Un corte de verosimilitud encontró un punto mejor. Reajuste antes de interpretar el soporte.", 
    "Um corte de verossimilhança encontrou um ponto melhor. Reajuste antes de interpretar o suporte."
    ), c("Configuración gráfica BiSSE no válida.", "Configurações gráficas BiSSE inválidas."
    ), c("Estados observados en las puntas; sin reconstrucción ancestral", 
    "Estados observados nas pontas; sem reconstrução ancestral"
    ), c("Inicio del optimizador", "Início do otimizador"), 
    c("Convergencia fallida", "Falha de convergência"), c("Tasa por unidad de longitud de rama", 
    "Taxa por unidade de comprimento de ramo"), c("Solo estimaciones puntuales; no hay intervalos de incertidumbre", 
    "Apenas estimativas pontuais; intervalos de incerteza indisponíveis"
    ), c("Tasas de transición BiSSE", "Taxas de transição BiSSE"
    ), c("No hay corte de verosimilitud para este parámetro.", 
    "Nenhum corte de verossimilhança para este parâmetro."), 
    c("Corte de verosimilitud: otras tasas libres fijas", "Corte de verossimilhança: demais taxas livres fixas"
    ), c("Código", "Código"), c("Estado", "Estado"), c("Conteo", 
    "Contagem"), c("Grupo", "Grupo"), c("Fijo", "Fixo"), c("LogLik más preciso", 
    "LogLik mais preciso"), c("Diferencia absoluta", "Diferença absoluta"
    ), c("Dispersión entre inicios", "Dispersão entre inícios"
    ), c("Evaluaciones fallidas", "Avaliações com falha"), 
    c("Estable", "Estável"), c("Inicial", "Inicial"), c("Final", 
    "Final"), c("Inestabilidad numérica: refine el ajuste antes de interpretar intervalos.", 
    "Instabilidade numérica: refine o ajuste antes de interpretar intervalos."
    ), c("Inestabilidad numérica", "Instabilidade numérica"
    ), c("Modelo para incertidumbre", "Modelo para incerteza"
    ), c("Parámetro del perfil", "Parâmetro do perfil"), c("Límite inferior de búsqueda del perfil", 
    "Limite inferior de busca do perfil"), c("Límite superior de búsqueda del perfil", 
    "Limite superior de busca do perfil"), c("Nivel de referencia", 
    "Nível de referência"), c("Reajustar desde múltiples valores iniciales", 
    "Reajustar a partir de múltiplos valores iniciais"), c("Multiplicadores iniciales", 
    "Multiplicadores iniciais"), c("Bootstrap paramétrico", 
    "Bootstrap paramétrico"), c("Segundos por réplica bootstrap", 
    "Segundos por réplica bootstrap"), c("Ejecutar incertidumbre y robustez", 
    "Executar incerteza e robustez"), c("Ejecute primero incertidumbre y robustez.", 
    "Execute primeiro incerteza e robustez."), c("Distribución bootstrap", 
    "Distribuição bootstrap"), c("Parámetro bootstrap", "Parâmetro bootstrap"
    ), c("Descargar intervalos bootstrap CSV", "Baixar intervalos bootstrap CSV"
    ), c("Punto del perfil fallido", "Ponto do perfil com falha"
    ), c("Cruce interpolado en la grilla", "Cruzamento interpolado na grade"
    ), c("Se encontró mejor verosimilitud", "Encontrada melhor verossimilhança"
    ), c("Se encontró mejor verosimilitud. Reajuste antes de interpretar incertidumbre.", 
    "Encontrada melhor verossimilhança. Reajuste antes de interpretar incerteza."
    ), c("Los intervalos bootstrap requieren al menos 20 reajustes exitosos y 90% de éxito.", 
    "Intervalos bootstrap exigem ao menos 20 reajustes bem-sucedidos e 90% de sucesso."
    ), c("Bootstrap requiere muestreo completo y supervivencia de corona (cond = 1).", 
    "Bootstrap exige amostragem completa e sobrevivência da coroa (cond = 1)."
    ), c("Se requieren estimaciones finitas para analizar incertidumbre.", 
    "São necessárias estimativas finitas para analisar incerteza."
    ), c("Seleccione un parámetro estimado para el perfil.", 
    "Selecione um parâmetro estimado para o perfil."), c("Los límites deben contener la estimación guardada.", 
    "Os limites devem conter a estimativa salva."), c("Reajustes bootstrap exitosos insuficientes.", 
    "Reajustes bootstrap bem-sucedidos insuficientes."), c("Los perfiles usan límites finitos y referencia chi-cuadrado aproximada. Bootstrap requiere muestreo completo y cond = 1; la edad de corona es fija y el número de puntas varía. Los intervalos excluyen incertidumbre del árbol y selección de modelos.", 
    "Perfis usam limites finitos e referência qui-quadrado aproximada. Bootstrap exige amostragem completa e cond = 1; a idade da coroa é fixa e o número de pontas varia. Intervalos excluem incerteza da árvore e seleção de modelos."
    ), c("AIC compara candidatos solo en esta tarjeta, condicionado al árbol y especies faltantes. La incertidumbre es condicional y aproximada.", 
    "AIC compara candidatos apenas neste cartão, condicionado à árvore e espécies ausentes. A incerteza é condicional e aproximada."
    ), c("Ejecute diagnósticos numéricos antes de interpretar AIC. La inestabilidad suprime los pesos.", 
    "Execute diagnósticos numéricos antes de interpretar AIC. A instabilidade suprime os pesos."
    ), c("1: lambda lineal", "1: lambda linear"), c("1.3: lambda lineal (K prima)", 
    "1.3: lambda linear (K linha)"), c("2: lambda exponencial", 
    "2: lambda exponencial"), c("3: mu lineal", "3: mu linear"
    ), c("4: mu exponencial", "4: mu exponencial"), c("5: lambda + mu lineales", 
    "5: lambda + mu lineares"), c("0: edad", "0: idade"), c("1: edad + supervivencia", 
    "1: idade + sobrevivência"), c("2: edad + conteo actual", 
    "2: idade + contagem atual"), c("3: conteo actual", "3: contagem atual"
    ), c("0: tiempos de ramificación", "0: tempos de ramificação"
    ), c("1: filogenia", "1: filogenia"), c("Curvas de tasas no válidas para el rango de diversidad seleccionado.", 
    "Curvas de taxas inválidas para o intervalo de diversidade selecionado."
    ), c("Método numérico no admitido.", "Método numérico não suportado."
    ), c("Instale DDD para ejecutar este análisis.", "Instale DDD para executar esta análise."
    ), c("Seleccione al menos un parámetro estimado por modelo.", 
    "Selecione ao menos um parâmetro estimado por modelo."), 
    c("Use valores positivos de lambda, K y r y mu no negativo; seleccione parámetros estimados.", 
    "Use valores positivos de lambda, K e r e mu não negativo; selecione parâmetros estimados."
    ), c("Modelos dependientes de la diversidad", "Modelos dependentes da diversidade"
    ), c("Especies actuales faltantes", "Espécies atuais ausentes"
    ), c("Parámetros estimados", "Parâmetros estimados"), c("Ejecutar modelos dependientes de diversidad", 
    "Executar modelos dependentes da diversidade"), c("Multiplicador de resolución", 
    "Multiplicador de resolução"), c("Ejecutar diagnósticos numéricos", 
    "Executar diagnósticos numéricos"), c("Tasa frente a diversidad", 
    "Taxa em função da diversidade"), c("Linajes reconstruidos observados", 
    "Linhagens reconstruídas observadas"), c("Estabilidad numérica", 
    "Estabilidade numérica"), c("Diversidad máxima mostrada", 
    "Diversidade máxima exibida"), c("Diversidad de especies", 
    "Diversidade de espécies"), c("Cambio de verosimilitud", 
    "Mudança de verossimilhança"), c("Análisis completado.", 
    "Análise concluída."), c("Revise convergencia y mensajes del motor.", 
    "Revise a convergência e as mensagens do mecanismo."), c("Configuración numérica no válida.", 
    "Configurações numéricas inválidas."), c("Configuración del modelo o verosimilitud no válida.", 
    "Configurações de modelo ou verossimilhança inválidas."
    ), c("Seleccione un modelo convergente.", "Selecione um modelo convergente."
    ), c("Ejecute primero los diagnósticos numéricos.", "Execute primeiro os diagnósticos numéricos."
    ), c("Se requieren ajustes compatibles y convergentes para comparar.", 
    "São necessários ajustes compatíveis e convergentes para comparar."
    ), c("Análisis de corona (soc = 2). Las especies faltantes son un conteo, no una fracción de muestreo. Se excluye el tallo.", 
    "Análise de coroa (soc = 2). Espécies ausentes são uma contagem, não uma fração amostral. O ramo-tronco é excluído."
    ), c("K depende del modelo. El modelo 1.3 usa diversidad con especiación cero; 1 y 2 usan diversidad con especiación y extinción iguales.", 
    "K depende do modelo. O modelo 1.3 usa diversidade com especiação zero; 1 e 2 usam diversidade com especiação e extinção iguais."
    ), c("Los parámetros no seleccionados usan valores fijos. r solo se aplica al modelo 5. DDD no permite límites arbitrarios.", 
    "Parâmetros não selecionados usam valores fixos. r aplica-se apenas ao modelo 5. DDD não oferece limites arbitrários."
    ), c("Reevalúe estimaciones con mayor res y tolerancias más estrictas. Es una comprobación numérica, no un intervalo de incertidumbre.", 
    "Reavalie estimativas com maior res e tolerâncias mais estritas. É uma verificação numérica, não um intervalo de incerteza."
    ), c("Las curvas describen dependencia de la diversidad. LTT muestra linajes supervivientes observados, no diversidad histórica total.", 
    "As curvas descrevem dependência da diversidade. LTT mostra linhagens sobreviventes observadas, não diversidade histórica total."
    ), c("AIC compara candidatos solo en esta tarjeta, condicionado al árbol y especies faltantes. No se estiman intervalos de confianza.", 
    "AIC compara candidatos apenas neste cartão, condicionado à árvore e espécies ausentes. Intervalos de confiança não são estimados."
    ), c("Modelos de tasas constantes", "Modelos de taxas constantes"
    ), c("Modelos específicos de clados", "Modelos específicos de clados"
    ), c("Configuración del modelo y los datos", "Configurações do modelo e dos dados"
    ), c("Controles avanzados de ajuste", "Controles avançados de ajuste"
    ), c("Incertidumbre y diagnósticos", "Incerteza e diagnósticos"
    ), c("Los intervalos normales cruzan cero para una tasa no negativa; esos intervalos se omiten.", 
    "Os intervalos normais cruzam zero para uma taxa não negativa; esses intervalos são omitidos."
    ), c("Verosimilitud particionada no finita; revise tasas fijas, límites y lambda = mu.", 
    "Verossimilhança particionada não finita; examine taxas fixas, limites e lambda = mu."
    ), c("Modelos conjuntos dependientes del clado", "Modelos conjuntos dependentes do clado"
    ), c("Nodos de cambio conjuntos", "Nós de mudança conjuntos"
    ), c("Posición del cambio: base de la rama (split.t = Inf). El motor instalado no admite otros tiempos. Se permiten regiones anidadas; cada región debe conservar al menos dos terminales muestreados.", 
    "Posição da mudança: base do ramo (split.t = Inf). O motor instalado não aceita outros tempos. Regiões aninhadas são permitidas; cada região deve manter pelo menos dois terminais amostrados."
    ), c("Muestreo de regiones conjuntas (CSV)", "Amostragem de regiões conjuntas (CSV)"
    ), c("Completar tablas de regiones conjuntas", "Preencher tabelas de regiões conjuntas"
    ), c("Use Region,Sampling: la región de fondo es 0; los otros identificadores son nodos de cambio. En blanco significa muestreo 1 en todas las regiones. No se aplican los controles de muestreo del árbol completo ni de clados separados.", 
    "Use Region,Sampling: a região de fundo é 0; os outros identificadores são nós de mudança. Em branco significa amostragem 1 em todas as regiões. Os controles de amostragem da árvore completa e de clados separados não se aplicam."
    ), c("Modelos conjuntos candidatos", "Modelos conjuntos candidatos"
    ), c("SharedYule fija extinción en cero. SharedBD comparte ambas tasas. ShiftLambda, ShiftMu y ShiftBoth varían las tasas indicadas entre regiones.", 
    "SharedYule fixa extinção em zero. SharedBD compartilha ambas as taxas. ShiftLambda, ShiftMu e ShiftBoth variam as taxas indicadas entre regiões."
    ), c("Restricciones conjuntas personalizadas (CSV)", "Restrições conjuntas personalizadas (CSV)"
    ), c("Columnas: Region,Lambda,Mu. Los nombres iguales comparten una tasa; los números fijan tasas. La especiación fija debe ser positiva. No reutilice nombres entre especiación y extinción. Solo se usa para Custom.", 
    "Colunas: Region,Lambda,Mu. Nomes iguais compartilham uma taxa; números fixam taxas. A especiação fixa deve ser positiva. Não reutilize nomes entre especiação e extinção. Usado apenas para Custom."
    ), c("Controles de parámetros conjuntos (CSV)", "Controles de parâmetros conjuntos (CSV)"
    ), c("Columnas opcionales: Parameter,Start,Lower,Upper. Los nombres aparecen en la tabla de restricciones. Parámetros no listados usan inicios derivados y el límite superior indicado arriba. Los límites inferiores de especiación libre deben ser positivos; los inicios deben estar estrictamente dentro de los límites.", 
    "Colunas opcionais: Parameter,Start,Lower,Upper. Os nomes aparecem na tabela de restrições. Parâmetros não listados usam inícios derivados e o limite superior acima. Limites inferiores de especiação livre devem ser positivos; os inícios devem ficar estritamente dentro dos limites."
    ), c("Los modelos conjuntos usan los controles superiores de condicionamiento, optimizador, iteraciones máximas, límite superior e intervalos de curvatura. Todos comparten una verosimilitud del árbol completo particionado. Posiciones de cambio y muestreo son fijos, no estimados.", 
    "Os modelos conjuntos usam os controles acima de condicionamento, otimizador, iterações máximas, limite superior e intervalos de curvatura. Todos compartilham uma verossimilhança da árvore completa particionada. Posições de mudança e amostragem são fixas, não estimadas."
    ), c("Previsualizar regiones conjuntas", "Visualizar regiões conjuntas"
    ), c("Ejecutar modelos conjuntos", "Executar modelos conjuntos"
    ), c("Regiones de diversificación conjunta", "Regiões de diversificação conjunta"
    ), c("Tasas regionales conjuntas", "Taxas regionais conjuntas"
    ), c("Comparación conjunta en el árbol completo", "Comparação conjunta na árvore completa"
    ), c("Concordancia del optimizador conjunto", "Concordância do otimizador conjunto"
    ), c("Modelo conjunto a mostrar", "Modelo conjunto a exibir"
    ), c("Resultados de modelos conjuntos", "Resultados de modelos conjuntos"
    ), c("El AIC conjunto compara estos candidatos solo con la misma verosimilitud del árbol completo. No incluye incertidumbre en selección de cambios, muestreo o árbol. No se informa un valor p calibrado de razón de verosimilitudes.", 
    "O AIC conjunto compara estes candidatos apenas com a mesma verossimilhança da árvore completa. Não inclui incerteza na seleção de mudanças, amostragem ou árvore. Não é informado valor p calibrado de razão de verossimilhanças."
    ), c("Descargar comparación conjunta CSV", "Baixar comparação conjunta CSV"
    ), c("Descargar estimaciones conjuntas CSV", "Baixar estimativas conjuntas CSV"
    ), c("Descargar pertenencia regional conjunta CSV", "Baixar composição regional conjunta CSV"
    ), c("Descargar regiones conjuntas por rama CSV", "Baixar regiões conjuntas por ramo CSV"
    ), c("Diagnósticos de modelos conjuntos", "Diagnósticos de modelos conjuntos"
    ), c("Los intervalos de curvatura son aproximados y se omiten en límites o con curvatura inestable. Las tasas de regiones con poca información pueden estar débilmente identificadas. Revise todos los inicios del optimizador.", 
    "Os intervalos de curvatura são aproximados e omitidos nos limites ou com curvatura instável. As taxas de regiões com pouca informação podem ser fracamente identificadas. Examine todos os inícios do otimizador."
    ), c("Descargar restricciones conjuntas CSV", "Baixar restrições conjuntas CSV"
    ), c("Descargar controles conjuntos CSV", "Baixar controles conjuntos CSV"
    ), c("Descargar optimización conjunta CSV", "Baixar otimização conjunta CSV"
    ), c("Descargar muestreo conjunto CSV", "Baixar amostragem conjunta CSV"
    ), c("Seleccione nodos de cambio conjuntos y ejecute modelos.", 
    "Selecione nós de mudança conjuntos e execute modelos."
    ), c("Las entradas conjuntas cambiaron. Ejecute modelos conjuntos para actualizar resultados.", 
    "As entradas conjuntas mudaram. Execute modelos conjuntos para atualizar os resultados."
    ), c("Solo previsualización conjunta. Ejecute modelos para ajustar tasas.", 
    "Apenas visualização conjunta. Execute modelos para ajustar taxas."
    ), c("Ajustando modelos conjuntos de diversificación", "Ajustando modelos conjuntos de diversificação"
    ), c("Ajuste conjunto completado. Revise convergencia, límites y comparaciones.", 
    "Ajuste conjunto concluído. Examine convergência, limites e comparações."
    ), c("La clasificación conjunta no está disponible; revise los diagnósticos.", 
    "A classificação conjunta está indisponível; examine os diagnósticos."
    ), c("Menor AIC conjunto:", "Menor AIC conjunto:"), c("El apoyo está condicionado a los cambios y modelos candidatos seleccionados.", 
    "O suporte é condicionado às mudanças e aos modelos candidatos selecionados."
    ), c("Elija de uno a cuatro nodos de cambio distintos de la raíz, con al menos cuatro terminales descendientes.", 
    "Escolha de um a quatro nós de mudança diferentes da raiz, com pelo menos quatro terminais descendentes."
    ), c("Este motor solo admite cambios en la base de la rama (split.t = Inf).", 
    "Este motor aceita apenas mudanças na base do ramo (split.t = Inf)."
    ), c("Cada región conjunta, incluido el fondo, debe conservar al menos dos terminales muestreados.", 
    "Cada região conjunta, incluindo o fundo, deve manter pelo menos dois terminais amostrados."
    ), c("Use Region,Sampling con fondo 0 y cada nodo de cambio exactamente una vez; fracciones en (0,1].", 
    "Use Region,Sampling com fundo 0 e cada nó de mudança exatamente uma vez; frações em (0,1]."
    ), c("Tabla CSV de modelos conjuntos no válida.", "Tabela CSV de modelos conjuntos inválida."
    ), c("Las restricciones personalizadas requieren Region,Lambda,Mu para cada región exactamente una vez.", 
    "As restrições personalizadas exigem Region,Lambda,Mu para cada região exatamente uma vez."
    ), c("Las restricciones deben ser tasas fijas no negativas o nombres de parámetros; la especiación debe ser positiva.", 
    "As restrições devem ser taxas fixas não negativas ou nomes de parâmetros; a especiação deve ser positiva."
    ), c("No comparta un nombre de parámetro entre especiación y extinción.", 
    "Não compartilhe um nome de parâmetro entre especiação e extinção."
    ), c("Elija al menos un modelo conjunto compatible.", "Escolha pelo menos um modelo conjunto compatível."
    ), c("Los controles requieren Parameter,Start,Lower,Upper con nombres únicos de parámetros libres.", 
    "Os controles exigem Parameter,Start,Lower,Upper com nomes únicos de parâmetros livres."
    ), c("Los inicios conjuntos deben estar estrictamente dentro de límites válidos; los límites inferiores de especiación libre deben ser positivos.", 
    "Os inícios conjuntos devem ficar estritamente dentro de limites válidos; os limites inferiores de especiação livre devem ser positivos."
    ), c("Las tasas fijas exceden la escala admitida del árbol.", 
    "As taxas fixas excedem a escala suportada da árvore."), 
    c("Un modelo conjunto falló; se omiten los pesos de comparación.", 
    "Um modelo conjunto falhou; os pesos de comparação são omitidos."
    ), c("Una estimación conjunta alcanza un límite; se omiten los intervalos de curvatura.", 
    "Uma estimativa conjunta atinge um limite; os intervalos de curvatura são omitidos."
    ), c("La curvatura de verosimilitud conjunta es inestable; no hay intervalos disponibles.", 
    "A curvatura da verossimilhança conjunta é instável; os intervalos estão indisponíveis."
    ), c("Los inicios del optimizador conjunto discrepan; revise óptimos locales.", 
    "Os inícios do otimizador conjunto divergem; examine ótimos locais."
    ), c("Algunos inicios del optimizador conjunto fallaron; revise todos los intentos.", 
    "Alguns inícios do otimizador conjunto falharam; examine todas as tentativas."
    ), c("Se seleccionaron restricciones conjuntas equivalentes; se omiten los pesos de comparación.", 
    "Restrições conjuntas equivalentes selecionadas; os pesos de comparação são omitidos."
    ), c("La región 0 es el fondo; los cambios incluyen la rama entrante.", 
    "A região 0 é o fundo; as mudanças incluem o ramo de entrada."
    ), c("No hay verosimilitudes conjuntas válidas.", "Não há verossimilhanças conjuntas válidas."
    ), c("Ajustes del gráfico conjunto no válidos.", "Configurações do gráfico conjunto inválidas."
    ), c("Región", "Região"), c("Edad_cambio", "Idade_mudança"
    ), c("Progenitor", "Ancestral"), c("Descendiente", "Descendente"
    ), c("Longitud", "Comprimento"), c("Diversificación por clado", 
    "Diversificação por clado"), c("Seleccione nodos internos sin solapamiento. Cada corona debe contener al menos cuatro terminales muestreados. Se conservan todos los descendientes; se excluyen las ramas ancestrales.", 
    "Selecione nós internos sem sobreposição. Cada coroa deve conter pelo menos quatro terminais amostrados. Todos os descendentes são mantidos; os ramos ancestrais são excluídos."
    ), c("Nodos de corona", "Nós da coroa"), c("Previsualizar clados seleccionados", 
    "Visualizar clados selecionados"), c("Fracciones de muestreo por clado (CSV)", 
    "Frações de amostragem por clado (CSV)"), c("Completar tabla de muestreo", 
    "Preencher tabela de amostragem"), c("Columnas: Node,Sampling. En blanco indica muestreo completo (1) por clado. Ingrese la probabilidad de inclusión aleatoria de taxones actuales dentro de cada clado.", 
    "Colunas: Node,Sampling. Em branco indica amostragem completa (1) por clado. Insira a probabilidade de inclusão aleatória de táxons atuais dentro de cada clado."
    ), c("Los ajustes por clado usan los controles superiores de modelos, condicionamiento, optimizador, límites, inicios e intervalos/cortes. Límites e inicios en blanco se derivan por corona. No se usa la fracción de muestreo del árbol completo.", 
    "Os ajustes por clado usam os controles acima de modelos, condicionamento, otimizador, limites, inícios e intervalos/cortes. Limites e inícios em branco são derivados por coroa. A fração de amostragem da árvore completa não é usada."
    ), c("Calcular perfiles por clado", "Calcular perfis por clado"
    ), c("Nivel de referencia del perfil por clado", "Nível de referência do perfil por clado"
    ), c("Puntos de la malla del perfil por clado", "Pontos da grade do perfil por clado"
    ), c("Ejecutar modelos por clado", "Executar modelos por clado"
    ), c("Clados de corona seleccionados", "Clados de coroa selecionados"
    ), c("Estimaciones de tasas por clado", "Estimativas de taxas por clado"
    ), c("Comparación de modelos dentro del clado", "Comparação de modelos dentro do clado"
    ), c("Perfil de verosimilitud por clado", "Perfil de verossimilhança por clado"
    ), c("Corte de verosimilitud por clado", "Corte de verossimilhança por clado"
    ), c("Clado guardado para diagnósticos", "Clado salvo para diagnósticos"
    ), c("Mostrar etiquetas terminales de clados", "Mostrar rótulos terminais dos clados"
    ), c("Mostrar números de nodos elegibles", "Mostrar números dos nós elegíveis"
    ), c("Tamaño de etiquetas de clados", "Tamanho dos rótulos dos clados"
    ), c("Resultados por clado", "Resultados por clado"), c("Son ajustes separados por corona, no una prueba conjunta de cambios de tasa. DeltaAIC y los pesos comparan modelos solo dentro de cada clado. No ordene verosimilitudes ni AIC entre clados distintos. Elegir clados después de examinar las tasas introduce sesgo de selección.", 
    "São ajustes separados por coroa, não um teste conjunto de mudanças de taxa. DeltaAIC e os pesos comparam modelos apenas dentro de cada clado. Não ordene verossimilhanças nem AIC entre clados distintos. Escolher clados após examinar as taxas introduz viés de seleção."
    ), c("Descargar estimaciones por clado CSV", "Baixar estimativas por clado CSV"
    ), c("Descargar comparación dentro de clados CSV", "Baixar comparação dentro dos clados CSV"
    ), c("Descargar pertenencia a clados CSV", "Baixar composição dos clados CSV"
    ), c("Descargar ajustes por clado CSV", "Baixar configurações por clado CSV"
    ), c("Descargar árboles de corona seleccionados", "Baixar árvores de coroa selecionadas"
    ), c("Diagnósticos por clado", "Diagnósticos por clado"
    ), c("Los clados pequeños suelen aportar poca información sobre extinción. Revise límites, inicios del optimizador y límites de búsqueda de perfiles. Los intervalos están condicionados a los clados elegidos, topología, longitudes de ramas y fracciones de muestreo.", 
    "Clados pequenos geralmente fornecem pouca informação sobre extinção. Examine limites, inícios do otimizador e limites de busca dos perfis. Os intervalos são condicionados aos clados escolhidos, topologia, comprimentos dos ramos e frações de amostragem."
    ), c("Descargar registro de clados CSV", "Baixar registro dos clados CSV"
    ), c("Descargar optimización por clado CSV", "Baixar otimização por clado CSV"
    ), c("Descargar perfiles por clado CSV", "Baixar perfis por clado CSV"
    ), c("Descargar curvas de perfiles por clado CSV", "Baixar curvas de perfis por clado CSV"
    ), c("Descargar cortes por clado CSV", "Baixar cortes por clado CSV"
    ), c("Seleccione nodos de corona y ejecute modelos por clado.", 
    "Selecione nós da coroa e execute modelos por clado."), 
    c("Las entradas de clados cambiaron. Ejecute modelos por clado para actualizar resultados.", 
    "As entradas dos clados mudaram. Execute modelos por clado para atualizar os resultados."
    ), c("Solo previsualización. Ejecute modelos por clado para ajustar las coronas seleccionadas.", 
    "Apenas visualização. Execute modelos por clado para ajustar as coroas selecionadas."
    ), c("Ajustando clados de corona seleccionados", "Ajustando clados de coroa selecionados"
    ), c("Análisis por clado completado. Revise cada clado por separado.", 
    "Análise por clado concluída. Examine cada clado separadamente."
    ), c("No hay ajustes válidos por clado. Revise el registro de clados.", 
    "Não há ajustes válidos por clado. Examine o registro dos clados."
    ), c("Ajustes clado-modelo exitosos:", "Ajustes clado-modelo bem-sucedidos:"
    ), c("Terminales fuera de las coronas seleccionadas:", "Terminais fora das coroas selecionadas:"
    ), c("Las diferencias de tasas son descriptivas; no se realiza una prueba de significancia entre clados.", 
    "As diferenças de taxas são descritivas; não é realizado teste de significância entre clados."
    ), c("Seleccione entre uno y diez nodos internos con al menos cuatro terminales descendientes cada uno.", 
    "Selecione de um a dez nós internos com pelo menos quatro terminais descendentes cada."
    ), c("Los clados seleccionados se solapan. Elija clados de corona sin solapamiento.", 
    "Os clados selecionados se sobrepõem. Escolha clados de coroa sem sobreposição."
    ), c("La tabla debe contener exactamente Node,Sampling, un nodo seleccionado por fila y fracciones en (0,1].", 
    "A tabela deve conter exatamente Node,Sampling, um nó selecionado por linha e frações em (0,1]."
    ), c("Ajustes del gráfico de clados no válidos.", "Configurações do gráfico de clados inválidas."
    ), c("Primero ejecute modelos por clado y seleccione un clado guardado.", 
    "Primeiro execute modelos por clado e selecione um clado salvo."
    ), c("Las ramas grises están fuera de las coronas seleccionadas; se excluyen las ramas ancestrales.", 
    "Ramos cinza estão fora das coroas selecionadas; ramos ancestrais são excluídos."
    ), c("No hay estimación guardada para este parámetro.", 
    "Não há estimativa salva para este parâmetro."), c("Unidades de longitud de rama", 
    "Unidades de comprimento de ramo"), c("Modelos_exitosos", 
    "Modelos_bem_sucedidos"), c("Modelos_solicitados", "Modelos_solicitados"
    ), c("Perfil_disponible", "Perfil_disponível"), c("Primer_terminal", 
    "Primeiro_terminal"), c("Etiqueta", "Rótulo"), c("Parámetro", 
    "Parâmetro"), c("Reconstrucción ancestral Mk bayesiana", 
    "Reconstrução ancestral Mk bayesiana"), c("Tasas medias posteriores por unidad de longitud de rama", 
    "Taxas médias posteriores por unidade de comprimento de ramo"
    ), c("Los pesos de raíz no apoyan ningún estado que pueda alcanzar todos los estados observados.", 
    "Os pesos da raiz não apoiam nenhum estado capaz de alcançar todos os estados observados."
    ), c("Probabilidades de raíz", "Probabilidades da raiz"), 
    c("Iguales", "Iguais"), c("Pesos personalizados por estado", 
    "Pesos personalizados por estado"), c("Mk bayesiano (muestrear tasas)", 
    "Mk bayesiano (amostrar taxas)"), c("Muestras de tasas guardadas por cadena", 
    "Amostras de taxas salvas por cadeia"), c("Completar tabla de priors de tasas", 
    "Preencher tabela de priors das taxas"), c("Priors gamma y propuestas (CSV)", 
    "Priors gama e propostas (CSV)"), c("Pesos de raíz: estado,peso", 
    "Pesos da raiz: estado,peso"), c("Columnas: Parameter, Shape, Rate, ProposalVariance. Use q1, q2, etc. para los índices mostrados. En blanco: forma gamma 1, tasa 1 y varianza de propuesta 0.1 por tasa.", 
    "Colunas: Parameter, Shape, Rate, ProposalVariance. Use q1, q2 etc. para os índices exibidos. Em branco: forma gama 1, taxa 1 e variância de proposta 0.1 por taxa."
    ), c("Medias de priors empíricos a partir de estos datos", 
    "Médias de priors empíricos a partir destes dados"), c("El modo empírico reemplaza Shape por la tasa ajustada multiplicada por Rate. En otro caso, los priors gamma se especifican previamente; Rate es la escala inversa. Los inicios de las cadenas se muestrean de estos priors.", 
    "O modo empírico substitui Shape pela taxa ajustada multiplicada por Rate. Caso contrário, os priors gama são especificados previamente; Rate é a escala inversa. Os inícios das cadeias são amostrados destes priors."
    ), c("Se muestrea una historia por muestra retenida de Q. Generaciones por cadena = calentamiento + muestras guardadas × intervalo. El motor no devuelve trazas del calentamiento, conteos de aceptación ni tasas iniciales editables. Las ejecuciones cortas son exploratorias.", 
    "Uma história é amostrada por amostra retida de Q. Gerações por cadeia = descarte inicial + amostras salvas × intervalo. O motor não retorna traços do descarte inicial, contagens de aceitação ou taxas iniciais editáveis. Execuções curtas são exploratórias."
    ), c("Los pesos de raíz iguales o nombrados se mantienen fijos. El árbol y los estados terminales observados son fijos; se integra la incertidumbre de tasas. No se calcula AIC ni comparación bayesiana de modelos.", 
    "Pesos da raiz iguais ou nomeados permanecem fixos. A árvore e os estados terminais observados são fixos; a incerteza das taxas é integrada. Não se calcula AIC nem comparação bayesiana de modelos."
    ), c("Los diagramas nodales promedian probabilidades marginales condicionadas sobre muestras posteriores de tasas. Q muestra la media posterior. Los intervalos de historias integran incertidumbre de tasas e historias en el árbol fijo; MCSE considera dependencia serial. Revise diagnósticos de tasas y nodos.", 
    "Os gráficos nodais usam a média das probabilidades marginais condicionais nas amostras posteriores de taxas. Q exibe a média posterior. Os intervalos das histórias integram incerteza de taxas e histórias na árvore fixa; MCSE considera dependência serial. Examine diagnósticos de taxas e nós."
    ), c("Diagnósticos de muestras retenidas: ESS espectral, Rhat dividido clásico y MCSE; no Rhat normalizado por rangos ni ESS de colas. Superar umbrales no prueba convergencia. Indicadores muestreados constantes no demuestran incertidumbre nula.", 
    "Diagnósticos das amostras retidas: ESS espectral, Rhat dividido clássico e MCSE; não Rhat normalizado por postos nem ESS de caudas. Passar limiares não comprova convergência. Indicadores amostrados constantes não demonstram incerteza nula."
    ), c("Descargar priors efectivos de tasas CSV", "Baixar priors efetivos das taxas CSV"
    ), c("Descargar diagnósticos nodales posteriores CSV", "Baixar diagnósticos nodais posteriores CSV"
    ), c("Mk bayesiano completado. Revise diagnósticos de tasas y nodos antes de interpretar.", 
    "Mk bayesiano concluído. Examine diagnósticos de taxas e nós antes de interpretar."
    ), c("Muestreo bayesiano de tasas Mk completado.", "Amostragem bayesiana de taxas Mk concluída."
    ), c("Ejecutar reconstrucción Mk bayesiana", "Executar reconstrução Mk bayesiana"
    ), c("Probabilidades nodales posteriores", "Probabilidades nodais posteriores"
    ), c("Q media posterior", "Q média posterior"), c("Historia estocástica posterior", 
    "História estocástica posterior"), c("Intervalos posteriores de tasas", 
    "Intervalos posteriores de taxas"), c("Media posterior e intervalo del 95% de colas iguales", 
    "Média posterior e intervalo de 95% de caudas iguais"), 
    c("Traza MCMC retenida (calentamiento no guardado)", "Traço MCMC retido (descarte inicial não salvo)"
    ), c("El CSV requiere Parameter, Shape, Rate, ProposalVariance y una fila por índice q mostrado.", 
    "O CSV exige Parameter, Shape, Rate, ProposalVariance e uma linha por índice q exibido."
    ), c("La forma y tasa gamma y las varianzas de propuesta deben ser finitas y positivas.", 
    "A forma e taxa gama e as variâncias de proposta devem ser finitas e positivas."
    ), c("Elija 20–2000 muestras guardadas por cadena, calentamiento e intervalo positivos, 1–4 cadenas y una semilla válida.", 
    "Escolha 20–2000 amostras salvas por cadeia, descarte inicial e intervalo positivos, 1–4 cadeias e uma semente válida."
    ), c("Configuración de prior empírico no válida.", "Configuração de prior empírico inválida."
    ), c("El prior empírico requiere tasas ajustadas finitas y positivas; use priors gamma explícitos.", 
    "O prior empírico exige taxas ajustadas finitas e positivas; use priors gama explícitos."
    ), c("Bayes empírico: las medias de priors gamma se estimaron con estos mismos datos. Los priors no fueron totalmente preespecificados.", 
    "Bayes empírico: as médias dos priors gama foram estimadas com estes mesmos dados. Os priors não foram totalmente pré-especificados."
    ), c("Las tasas muestreadas violan las restricciones Mk seleccionadas.", 
    "As taxas amostradas violam as restrições Mk selecionadas."
    ), c("Ejecute primero la reconstrucción Mk bayesiana.", 
    "Execute primeiro a reconstrução Mk bayesiana."), c("Seleccione un parámetro posterior guardado.", 
    "Selecione um parâmetro posterior salvo."), c("FrecuenciaMuestreada", 
    "FrequênciaAmostrada"), c("MCSE y ESS nodales describen SampledFrequency; Probability promedia marginales condicionadas sobre muestras de Q.", 
    "MCSE e ESS nodais descrevem SampledFrequency; Probability calcula a média das marginais condicionais nas amostras de Q."
    ), c("Descargar asignaciones conjuntas CSV", "Baixar atribuições conjuntas CSV"
    ), c("Log-verosimilitud conjunta condicionada a Q ajustada; AIC usa la verosimilitud marginal.", 
    "Log-verossimilhança conjunta condicionada a Q ajustada; AIC usa a verossimilhança marginal."
    ), c("ML analítica BM (fastAnc)", "ML analítica BM (fastAnc)"
    ), c("ML conjunta (anc.ML)", "ML conjunta (anc.ML)"), c("BM bayesiano", 
    "BM bayesiano"), c("BM bayesiano muestrea la difusión y los estados ancestrales sobre un árbol fijo. Las observaciones terminales se consideran exactas; no se aplican los ajustes de error de medición de ML.", 
    "BM bayesiano amostra a difusão e os estados ancestrais em uma árvore fixa. As observações terminais são tratadas como exatas; as configurações de erro de medição de ML não se aplicam."
    ), c("Generaciones MCMC por cadena", "Gerações MCMC por cadeia"
    ), c("Guardar cada N generaciones", "Salvar a cada N gerações"
    ), c("Generaciones de descarte inicial", "Gerações de descarte inicial"
    ), c("Cadenas", "Cadeias"), c("Cadena", "Cadeia"), c("Semilla MCMC", 
    "Semente MCMC"), c("Dispersión inicial entre cadenas", "Dispersão inicial entre cadeias"
    ), c("Solo se retienen muestras guardadas con generación posterior al descarte inicial. Las ejecuciones cortas son exploratorias; los valores predeterminados no garantizan convergencia.", 
    "Somente amostras salvas com geração posterior ao descarte inicial são retidas. Execuções curtas são exploratórias; os padrões não garantem convergência."
    ), c("Rellenar tabla de parámetros bayesianos", "Preencher tabela de parâmetros bayesianos"
    ), c("Priors, valores iniciales y propuestas (CSV)", "Priors, valores iniciais e propostas (CSV)"
    ), c("Filas: sig2, luego raíz y números de nodos internos. Columnas: Parameter, Start, PriorMean, PriorVariance, ProposalVariance. El prior de sig2 es exponencial: su varianza debe ser NA. Los priors de nodos son normales independientes. Las propuestas son varianzas, no desviaciones estándar. Vacío usa los valores predeterminados mostrados.", 
    "Linhas: sig2, depois raiz e números dos nós internos. Colunas: Parameter, Start, PriorMean, PriorVariance, ProposalVariance. O prior de sig2 é exponencial: sua variância deve ser NA. Os priors dos nós são normais independentes. As propostas são variâncias, não desvios padrão. Vazio usa os padrões exibidos."
    ), c("Controles bayesianos efectivos", "Controles bayesianos efetivos"
    ), c("Parámetro posterior", "Parâmetro posterior"), c("Traza MCMC", 
    "Traço MCMC"), c("Densidad posterior", "Densidade posterior"
    ), c("Generación", "Geração"), c("Trazas MCMC incluido el descarte inicial", 
    "Traços MCMC incluindo descarte inicial"), c("Densidades posteriores retenidas", 
    "Densidades posteriores retidas"), c("Intervalos creíbles del 95% con colas iguales", 
    "Intervalos de credibilidade de 95% com caudas iguais"), 
    c("Descargar muestras posteriores retenidas CSV", "Baixar amostras posteriores retidas CSV"
    ), c("Descargar cadenas completas y ajustes RDS", "Baixar cadeias completas e configurações RDS"
    ), c("Descargar diagnósticos de cadenas CSV", "Baixar diagnósticos das cadeias CSV"
    ), c("ESS es la suma de estimaciones espectrales por cadena. Split-Rhat clásico no está normalizado por rangos. Valores superiores a 1.01, ESS bajo o cadenas estancadas indican muestreo poco fiable; superar los diagnósticos no demuestra convergencia.", 
    "ESS é a soma das estimativas espectrais por cadeia. Split-Rhat clássico não é normalizado por postos. Valores acima de 1.01, ESS baixo ou cadeias estagnadas indicam amostragem não confiável; passar nos diagnósticos não comprova convergência."
    ), c("Ejecutando reconstrucción ancestral", "Executando reconstrução ancestral"
    ), c("Muestras retenidas por cadena", "Amostras retidas por cadeia"
    ), c("CSV de parámetros bayesianos no válido.", "CSV de parâmetros bayesianos inválido."
    ), c("Proporcione exactamente una fila para sig2 y cada nodo interno.", 
    "Forneça exatamente uma linha para sig2 e cada nó interno."
    ), c("Los parámetros bayesianos deben ser numéricos; la varianza del prior de difusión debe ser NA.", 
    "Os parâmetros bayesianos devem ser numéricos; a variância do prior de difusão deve ser NA."
    ), c("Priors, valores iniciales o varianzas de propuestas no válidos.", 
    "Priors, valores iniciais ou variâncias das propostas inválidos."
    ), c("Ajustes MCMC no válidos: las generaciones deben ser divisibles por el intervalo de muestreo; elija 1–4 cadenas y semilla y descarte inicial válidos.", 
    "Configurações MCMC inválidas: as gerações devem ser divisíveis pelo intervalo de amostragem; escolha 1–4 cadeias e semente e descarte inicial válidos."
    ), c("Retenga al menos 20 muestras por cadena después del descarte inicial.", 
    "Retenha pelo menos 20 amostras por cadeia após o descarte inicial."
    ), c("La dispersión inicial debe estar entre 0 y 10.", "A dispersão inicial deve estar entre 0 e 10."
    ), c("La carga bayesiana solicitada es demasiado grande; reduzca generaciones, cadenas o muestras guardadas.", 
    "A carga bayesiana solicitada é muito grande; reduza gerações, cadeias ou amostras salvas."
    ), c("BM bayesiano requiere longitudes de ramas superiores al umbral numérico de cero.", 
    "BM bayesiano requer comprimentos dos ramos acima do limiar numérico de zero."
    ), c("El muestreador devolvió muestras posteriores no válidas o incompletas.", 
    "O amostrador retornou amostras posteriores inválidas ou incompletas."
    ), c("Una cadena no permite evaluar convergencia entre cadenas; split-Rhat no está disponible.", 
    "Uma cadeia não permite avaliar convergência entre cadeias; split-Rhat está indisponível."
    ), c("Split-Rhat supera 1.01 o no está disponible. No considere esta ejecución convergente.", 
    "Split-Rhat excede 1.01 ou está indisponível. Não considere esta execução convergente."
    ), c("El tamaño efectivo de muestra es inferior a 400 o no está disponible. Se requieren cadenas más largas o mejor ajustadas.", 
    "O tamanho efetivo da amostra é inferior a 400 ou está indisponível. São necessárias cadeias mais longas ou melhor ajustadas."
    ), c("BM bayesiano muestrea la posterior conjunta de difusión y todos los estados ancestrales. No se presenta verosimilitud ML ni clasificación AIC.", 
    "BM bayesiano amostra a posterior conjunta da difusão e de todos os estados ancestrais. Não é apresentada verossimilhança ML nem classificação AIC."
    ), c("Las medias posteriores e intervalos creíbles del 95% con colas iguales integran incertidumbre de difusión y estados ancestrales bajo los priors especificados; el árbol es fijo. Revise los diagnósticos antes de interpretar.", 
    "As médias posteriores e intervalos de credibilidade de 95% com caudas iguais integram incerteza da difusão e dos estados ancestrais sob os priors especificados; a árvore é fixa. Revise os diagnósticos antes de interpretar."
    ), c("Seleccione un parámetro bayesiano guardado para este gráfico.", 
    "Selecione um parâmetro bayesiano salvo para este gráfico."
    ), c("Intervalos de predicción condicionales del 95%", "Intervalos de predição condicionais de 95%"
    ), c("Defina ambos límites o deje ambos vacíos para usar los predeterminados. El parámetro es alpha para OU y r para EB, en unidades inversas de longitud de rama.", 
    "Defina ambos os limites ou deixe ambos vazios para usar os padrões. O parâmetro é alpha para OU e r para EB, em unidades inversas de comprimento de ramo."
    ), c("Usar máxima verosimilitud marginal comparable", "Usar máxima verossimilhança marginal comparável"
    ), c("Columna de errores estándar conocidos", "Coluna de erros padrão conhecidos"
    ), c("Ninguno (error cero)", "Nenhum (erro zero)"), c("Proporcione errores estándar, no varianzas, en la escala del carácter seleccionado. Se elevan al cuadrado una vez y se suman solo a las varianzas terminales; no se transforman automáticamente.", 
    "Forneça erros padrão, não variâncias, na escala do caráter selecionado. São elevados ao quadrado uma vez e somados apenas às variâncias terminais; não são transformados automaticamente."
    ), c("Comparar BM, OU y EB con verosimilitud marginal", "Comparar BM, OU e EB com verossimilhança marginal"
    ), c("Límite inferior del parámetro de forma (vacío = predeterminado)", 
    "Limite inferior do parâmetro de forma (vazio = padrão)"
    ), c("Límite superior del parámetro de forma (vacío = predeterminado)", 
    "Limite superior do parâmetro de forma (vazio = padrão)"
    ), c("OU utiliza un óptimo igual a la media de la raíz. Los intervalos de predicción condicionan los parámetros de covarianza ajustados. La comparación usa los mismos taxones, escala y errores conocidos; los otros modelos usan sus límites predeterminados.", 
    "OU usa um ótimo igual à média da raiz. Os intervalos de predição condicionam os parâmetros de covariância ajustados. A comparação usa os mesmos táxons, escala e erros conhecidos; os outros modelos usam seus limites padrão."
    ), c("El motor anterior anc.ML no tiene intervalos OU ni error de medición habilitado. Use verosimilitud marginal para estas funciones.", 
    "O motor anterior anc.ML não tem intervalos OU nem erro de medição habilitado. Use verossimilhança marginal para esses recursos."
    ), c("Comparación marginal de modelos", "Comparação marginal de modelos"
    ), c("Descargar comparación de modelos CSV", "Baixar comparação de modelos CSV"
    ), c("Los pesos AIC describen el conjunto candidato, no la certeza de que un modelo sea verdadero. Interprete con cautela los ajustes en límites. Los candidatos fallidos permanecen visibles; no se calculan pesos si alguno falla.", 
    "Os pesos AIC descrevem o conjunto candidato, não a certeza de que um modelo é verdadeiro. Interprete com cautela os ajustes nos limites. Candidatos com falha permanecem visíveis; os pesos não são calculados se algum falhar."
    ), c("Los diagnósticos de fastAnc muestran contrastes BM. Otros motores muestran residuos terminales decorrelacionados mediante la covarianza ajustada; son verificaciones exploratorias dependientes del orden, no pruebas calibradas de adecuación.", 
    "Os diagnósticos de fastAnc mostram contrastes BM. Outros motores mostram resíduos terminais descorrelacionados pela covariância ajustada; são verificações exploratórias dependentes da ordem, não testes calibrados de adequação."
    ), c("Modelo de covarianza continua desconocido.", "Modelo de covariância contínua desconhecido."
    ), c("Seleccione una columna numérica separada de errores estándar.", 
    "Selecione uma coluna numérica separada de erros padrão."
    ), c("Los errores estándar deben ser finitos, no negativos y estar en la escala del carácter seleccionado.", 
    "Os erros padrão devem ser finitos, não negativos e estar na escala do caráter selecionado."
    ), c("Límites no válidos: OU debe ser no negativo; los límites escalados deben estar entre -100 y 100.", 
    "Limites inválidos: OU deve ser não negativo; os limites escalados devem estar entre -100 e 100."
    ), c("El parámetro inicial de forma debe estar dentro de sus límites.", 
    "O parâmetro inicial de forma deve estar dentro dos limites."
    ), c("Ningún inicio de optimización de verosimilitud marginal convergió.", 
    "Nenhum início de otimização de verossimilhança marginal convergiu."
    ), c("Varianza condicional de nodo no válida.", "Variância condicional do nó inválida."
    ), c("Un parámetro marginal está en un límite de búsqueda; revise los límites y la identificabilidad del modelo.", 
    "Um parâmetro marginal está em um limite de busca; revise os limites e a identificabilidade do modelo."
    ), c("Algunos inicios de optimización fallaron; se presenta el mejor inicio convergente.", 
    "Alguns inícios de otimização falharam; é apresentado o melhor início convergente."
    ), c("Verosimilitud marginal gaussiana de datos terminales; mismas observaciones y errores de medición conocidos para BM/OU/EB. La raíz OU es igual a su único óptimo.", 
    "Verossimilhança marginal gaussiana dos dados terminais; mesmas observações e erros de medição conhecidos para BM/OU/EB. A raiz OU é igual ao seu único ótimo."
    ), c("Los intervalos de predicción condicionales aproximados del 95% incluyen la incertidumbre de estimación de la media; los parámetros de covarianza y el árbol se mantienen fijos.", 
    "Os intervalos de predição condicionais aproximados de 95% incluem a incerteza de estimação da média; os parâmetros de covariância e a árvore permanecem fixos."
    ), c("El error de medición y la comparación de modelos requieren Gaussian ML.", 
    "O erro de medição e a comparação de modelos exigem Gaussian ML."
    ), c("Ejecute Gaussian ML con la comparación de modelos habilitada.", 
    "Execute Gaussian ML com a comparação de modelos habilitada."
    ), c("Límite inferior", "Limite inferior"), c("Límite superior", 
    "Limite superior"), c("En límite", "No limite"), c("Delta AIC", 
    "Delta AIC"), c("Peso de Akaike", "Peso de Akaike"), c("Diagnósticos del modelo", 
    "Diagnósticos do modelo"), c("Reconstrucción ancestral", 
    "Reconstrução ancestral"), c("La reconstrucción continua requiere un árbol enraizado y bifurcante.", 
    "A reconstrução contínua requer uma árvore enraizada e bifurcante."
    ), c("La reconstrucción continua requiere longitudes de ramas finitas y positivas.", 
    "A reconstrução contínua requer comprimentos de ramos finitos e positivos."
    ), c("La reconstrucción continua necesita un carácter numérico finito y no constante. No se eliminan filas automáticamente.", 
    "A reconstrução contínua precisa de um caráter numérico finito e não constante. Nenhuma linha é removida automaticamente."
    ), c("Motor BM", "Motor BM"), c("Ornstein–Uhlenbeck (OU)", 
    "Ornstein–Uhlenbeck (OU)"), c("Explosión temprana (EB)", 
    "Explosão inicial (EB)"), c("Iteraciones máximas (maxit)", 
    "Máximo de iterações (maxit)"), c("Límite inferior positivo (tol; vacío = valor del motor)", 
    "Limite inferior positivo (tol; vazio = padrão do motor)"
    ), c("Imprimir traza del optimizador", "Imprimir rastreamento do otimizador"
    ), c("Calcular intervalos aproximados del 95% para nodos", 
    "Calcular intervalos aproximados de 95% para nós"), c("alpha inicial (OU) o r (EB); vacío = valor del motor", 
    "alpha inicial (OU) ou r (EB); vazio = padrão do motor"), 
    c("OU no proporciona intervalos de nodos. EB permite tasas crecientes y decrecientes. El error de medición no está habilitado.", 
    "OU não fornece intervalos dos nós. EB permite taxas crescentes e decrescentes. O erro de medição não está habilitado."
    ), c("Ejecutar reconstrucción continua", "Executar reconstrução contínua"
    ), c("Seleccione un carácter numérico y ejecute la reconstrucción continua.", 
    "Selecione um caráter numérico e execute a reconstrução contínua."
    ), c("Las entradas cambiaron. Ejecute la reconstrucción continua para actualizar los resultados.", 
    "As entradas mudaram. Execute a reconstrução contínua para atualizar os resultados."
    ), c("Este marco está previsto. Seleccione máxima verosimilitud.", 
    "Este método está planejado. Selecione máxima verossimilhança."
    ), c("Reconstrucción continua completada. Revise la incertidumbre y los diagnósticos.", 
    "Reconstrução contínua concluída. Revise a incerteza e os diagnósticos."
    ), c("Los colores de ramas y líneas del fenograma interpolan estimaciones de nodos; no son trayectorias evolutivas condicionales.", 
    "As cores dos ramos e linhas do fenograma interpolam estimativas dos nós; não são trajetórias evolutivas condicionais."
    ), c("Verosimilitud marginal de datos terminales; raíz y difusión estimadas por máxima verosimilitud.", 
    "Verossimilhança marginal dos dados terminais; raiz e difusão estimadas por máxima verossimilhança."
    ), c("Densidad conjunta de estados terminales y ancestrales de anc.ML; no comparable con la verosimilitud marginal terminal. Sin clasificación AIC.", 
    "Densidade conjunta dos estados terminais e ancestrais de anc.ML; não comparável à verossimilhança marginal terminal. Sem classificação AIC."
    ), c("Intervalos aproximados del 95% de fastAnc/Rohlf; sin incertidumbre del árbol o modelo.", 
    "Intervalos aproximados de 95% de fastAnc/Rohlf; sem incerteza da árvore ou modelo."
    ), c("Intervalos aproximados del 95% basados en la Hessiana; sin incertidumbre del árbol o modelo.", 
    "Intervalos aproximados de 95% baseados na Hessiana; sem incerteza da árvore ou modelo."
    ), c("Este motor no proporciona intervalos de nodos para OU.", 
    "Este motor não fornece intervalos dos nós para OU."), 
    c("No se solicitaron intervalos de nodos.", "Não foram solicitados intervalos dos nós."
    ), c("Estimaciones de nodos; intervalos no disponibles", 
    "Estimativas dos nós; intervalos indisponíveis"), c("Diagnóstico de residuos con covarianza ajustada", 
    "Diagnóstico de resíduos com covariância ajustada"), c("Residuos terminales decorrelacionados", 
    "Resíduos terminais descorrelacionados"), c("Parámetro de difusión (sig2)", 
    "Parâmetro de difusão (sig2)"), c("Log-verosimilitud (base del motor)", 
    "Log-verossimilhança (base do motor)"), c("Convergencia del optimizador", 
    "Convergência do otimizador"), c("Los diagnósticos de fastAnc muestran contrastes BM. Los de anc.ML muestran residuos terminales decorrelacionados con la covarianza ajustada; son verificaciones exploratorias dependientes del orden, no una prueba calibrada de adecuación.", 
    "Os diagnósticos de fastAnc mostram contrastes BM. Os de anc.ML mostram resíduos terminais descorrelacionados com a covariância ajustada; são verificações exploratórias dependentes da ordem, não um teste calibrado de adequação."
    ), c("Un parámetro estimado está en su límite inferior; interprete con cautela.", 
    "Um parâmetro estimado está no limite inferior; interprete com cautela."
    ), c("La documentación instalada de anc.ML advierte que OU no ha sido probado exhaustivamente. No se proporcionan intervalos de nodos OU.", 
    "A documentação instalada de anc.ML alerta que OU não foi testado exaustivamente. Não são fornecidos intervalos dos nós OU."
    ), c("La tasa EB ajustada aumenta con el tiempo (r > 0); el motor no la restringe a una explosión temprana.", 
    "A taxa EB ajustada aumenta ao longo do tempo (r > 0); o motor não a restringe a uma explosão inicial."
    ), c("Seleccione fastAnc para BM o anc.ML para BM, OU o EB.", 
    "Selecione fastAnc para BM ou anc.ML para BM, OU ou EB."), 
    c("Opciones del motor continuo no válidas.", "Opções do motor contínuo inválidas."
    ), c("El máximo de iteraciones debe ser un entero de 1 a 100000.", 
    "O máximo de iterações deve ser um inteiro de 1 a 100000."
    ), c("El límite inferior positivo debe ser finito y mayor que cero.", 
    "O limite inferior positivo deve ser finito e maior que zero."
    ), c("Use una tasa inicial EB finita o un alpha inicial OU igual o superior al límite inferior.", 
    "Use uma taxa inicial EB finita ou um alpha inicial OU igual ou superior ao limite inferior."
    ), c("La optimización continua devolvió estimaciones o verosimilitud no válidas.", 
    "A otimização contínua retornou estimativas ou verossimilhança inválidas."
    ), c("La incertidumbre de nodos no es válida; revise el modelo o ejecute sin intervalos.", 
    "A incerteza dos nós é inválida; revise o modelo ou execute sem intervalos."
    ), c("El diseño en abanico está disponible para árboles de nodos. Las historias coloreadas y los mapas continuos usan filogramas.", 
    "O formato em leque está disponível para árvores de nós. Histórias coloridas e mapas contínuos usam filogramas."
    ), c("Las historias coloreadas y los mapas continuos requieren actualmente un filograma.", 
    "Histórias coloridas e mapas contínuos atualmente exigem um filograma."
    ), c("Tamaño y apariencia de la figura", "Tamanho e aparência da figura"
    ), c("Resolución PNG (ppp)", "Resolução PNG (dpi)"), c("Las proporciones se aplican a la vista previa y a las exportaciones PDF y R. La resolución se aplica solo a PNG.", 
    "As proporções se aplicam à prévia e às exportações PDF e R. A resolução se aplica apenas ao PNG."
    ), c("Abanico", "Leque"), c("Fuente de etiquetas", "Fonte dos rótulos"
    ), c("Normal", "Normal"), c("Negrita", "Negrito"), c("Cursiva", 
    "Itálico"), c("Negrita cursiva", "Negrito itálico"), c("Separación de etiquetas (fracción de altura del árbol)", 
    "Deslocamento dos rótulos (fração da altura da árvore)"
    ), c("Conservar guiones bajos", "Preservar sublinhados"), 
    c("Grosor de línea", "Espessura da linha"), c("Tipo de línea", 
    "Tipo de linha"), c("Continua", "Contínua"), c("Discontinua", 
    "Tracejada"), c("Punteada", "Pontilhada"), c("Punto y raya", 
    "Ponto e traço"), c("Raya larga", "Traço longo"), c("Doble raya", 
    "Traço duplo"), c("Mostrar leyenda", "Mostrar legenda"), 
    c("Tamaño del texto de leyenda", "Tamanho do texto da legenda"
    ), c("Columnas de leyenda (0 = automático)", "Colunas da legenda (0 = automático)"
    ), c("Longitud de barra de color (fracción de altura del árbol)", 
    "Comprimento da barra de cores (fração da altura da árvore)"
    ), c("Resolución de la cuadrícula de colores", "Resolução da grade de cores"
    ), c("Delinear ramas coloreadas", "Contornar ramos coloridos"
    ), c("Colores personalizados", "Cores personalizadas"), c("Colores del gradiente (hex, separados por comas)", 
    "Cores do gradiente (hex, separadas por vírgulas)"), c("Rellenar colores desde la paleta", 
    "Preencher cores a partir da paleta"), c("Colores de estados: estado,#RRGGBB", 
    "Cores dos estados: estado,#RRGGBB"), c("Deje en blanco para usar la paleta seleccionada. Los colores personalizados solo modifican la visualización.", 
    "Deixe em branco para usar a paleta selecionada. As cores personalizadas só alteram a visualização."
    ), c("Visualización de nodos", "Exibição dos nós"), c("Círculos de probabilidades", 
    "Gráficos de probabilidades"), c("Estado con mayor soporte", 
    "Estado com maior suporte"), c("Soporte mínimo del estado", 
    "Suporte mínimo do estado"), c("Una cruz marca un empate o soporte inferior al umbral. Las probabilidades no cambian.", 
    "Uma cruz marca empate ou suporte abaixo do limiar. As probabilidades não mudam."
    ), c("Ajustes del diagrama Q", "Configurações do diagrama Q"
    ), c("Cifras significativas de tasas", "Algarismos significativos das taxas"
    ), c("Ocultar tasas menores que", "Ocultar taxas abaixo de"
    ), c("Mostrar flechas de tasa cero", "Mostrar setas de taxa zero"
    ), c("Mostrar texto de tasas", "Mostrar texto das taxas"), 
    c("Escalar grosor de flechas según tasas", "Escalar espessura das setas pelas taxas"
    ), c("Grosor máximo de flecha", "Espessura máxima da seta"
    ), c("Rotación del diagrama (grados)", "Rotação do diagrama (graus)"
    ), c("Separación de flechas", "Espaçamento das setas"), 
    c("Estos controles solo cambian el diagrama; Q y las restricciones del modelo no cambian.", 
    "Estes controles só alteram o diagrama; Q e as restrições do modelo não mudam."
    ), c("Inspeccionar nodo guardado", "Inspecionar nó salvo"
    ), c("Ningún nodo resaltado", "Nenhum nó destacado"), c("Nodo seleccionado", 
    "Nó selecionado"), c("Estado seleccionado", "Estado selecionado"
    ), c("Los colores muestran la ocupación media dentro de cada segmento de la cuadrícula entre las historias guardadas, condicionada a Q y al árbol. Es una proyección visual, no un nuevo análisis binario.", 
    "As cores mostram a ocupação média dentro de cada segmento da grade entre as histórias salvas, condicionada a Q e à árvore. É uma projeção visual, não uma nova análise binária."
    ), c("Restablecer controles del gráfico", "Redefinir controles do gráfico"
    ), c("Descargar gráfico PNG", "Baixar gráfico PNG"), c("Descargar ajustes gráficos y resultado RDS", 
    "Baixar configurações gráficas e resultado RDS"), c("Descargar nodo seleccionado CSV", 
    "Baixar nó selecionado CSV"), c("Descargar segmentos de densidad CSV", 
    "Baixar segmentos de densidade CSV"), c("Mapa de densidad del estado seleccionado", 
    "Mapa de densidade do estado selecionado"), c("Distribución de la transición seleccionada", 
    "Distribuição da transição selecionada"), c("Ocupación muestreada", 
    "Ocupação amostrada"), c("Estado seleccionado frente a todos los demás", 
    "Estado selecionado versus todos os outros"), c("Ajuste gráfico desconocido.", 
    "Configuração gráfica desconhecida."), c("El ajuste gráfico numérico está fuera del rango permitido.", 
    "A configuração gráfica numérica está fora do intervalo permitido."
    ), c("Los conteos gráficos deben ser enteros.", "As contagens gráficas devem ser inteiras."
    ), c("Opción gráfica no válida.", "Opção gráfica inválida."
    ), c("Selección gráfica no válida.", "Seleção gráfica inválida."
    ), c("Los colores requieren una fila estado,color por estado permitido, sin encabezado.", 
    "As cores exigem uma linha estado,cor por estado permitido, sem cabeçalho."
    ), c("Incluya cada estado una vez con un color hexadecimal de seis dígitos, como #2277AA.", 
    "Inclua cada estado uma vez com uma cor hexadecimal de seis dígitos, como #2277AA."
    ), c("Use entre dos y ocho colores hexadecimales de seis dígitos.", 
    "Use entre duas e oito cores hexadecimais de seis dígitos."
    ), c("Seleccione un nodo interno del resultado guardado.", 
    "Selecione um nó interno do resultado salvo."), c("Seleccione un estado de las historias estocásticas guardadas.", 
    "Selecione um estado das histórias estocásticas salvas."
    ), c("La resolución de densidad debe ser un entero entre 20 y 500.", 
    "A resolução de densidade deve ser um inteiro entre 20 e 500."
    ), c("Los mapas de densidad requieren todas las historias guardadas.", 
    "Os mapas de densidade exigem todas as histórias salvas."
    ), c("Seleccione dos estados distintos para una distribución de transiciones guardada.", 
    "Selecione dois estados diferentes para uma distribuição de transições salva."
    ), c("Probabilidad", "Probabilidade"), c("Conjunto", "Conjunto"
    ), c("Matriz Q seleccionada", "Matriz Q selecionada"), c("Los valores iniciales y las llamadas efectivas se registran por modelo. La convergencia no establece identificabilidad ni adecuación del modelo. Las tasas cerca de los límites y los óptimos diferentes requieren cautela.", 
    "Os valores iniciais e as chamadas efetivas são registrados por modelo. A convergência não estabelece identificabilidade nem adequação do modelo. Taxas próximas aos limites e ótimos diferentes exigem cautela."
    ), c("Las historias están condicionadas a la matriz Q seleccionada, los estados observados, el árbol y las probabilidades de raíz seleccionadas. No se muestrean tasas ni árboles. No hay descarte inicial MCMC.", 
    "As histórias são condicionadas à matriz Q selecionada, aos estados observados, à árvore e às probabilidades da raiz selecionadas. Taxas e árvores não são amostradas. Não há descarte inicial MCMC."
    ), c("Los círculos nodales muestran probabilidades marginales condicionadas a las tasas seleccionadas, el árbol y las probabilidades de raíz seleccionadas. No integran incertidumbre de parámetros o del árbol y no son historias evolutivas muestreadas.", 
    "Os gráficos dos nós mostram probabilidades marginais condicionadas às taxas selecionadas, à árvore e às probabilidades da raiz selecionadas. Não integram incerteza dos parâmetros ou da árvore e não são histórias evolutivas amostradas."
    ), c("Las comparaciones AIC usan los mismos taxones, rasgo, árbol y probabilidades de raíz seleccionadas. Los pesos describen candidatos distintos convergentes; se omiten restricciones equivalentes. Los candidatos fallidos permanecen visibles. No se promedian modelos.", 
    "As comparações AIC usam os mesmos táxons, característica, árvore e probabilidades da raiz selecionadas. Os pesos descrevem candidatos distintos convergentes; restrições equivalentes são omitidas. Candidatos com falha permanecem visíveis. Não há média de modelos."
    ), c("Las comparaciones usan los mismos taxones, el espacio completo de estados y las probabilidades de raíz seleccionadas. Los pesos AIC incluyen solo candidatos convergentes; no se promedian modelos.", 
    "As comparações usam os mesmos táxons, o espaço completo de estados e as probabilidades da raiz selecionadas. Os pesos AIC incluem apenas candidatos convergentes; não há média de modelos."
    ), c("Controles avanzados del análisis", "Controles avançados da análise"
    ), c("Probabilidades de raíz (pi)", "Probabilidades da raiz (pi)"
    ), c("Pesos iguales", "Pesos iguais"), c("Pesos personalizados por estado", 
    "Pesos personalizados por estado"), c("Rellenar pesos iguales de raíz", 
    "Preencher pesos iguais da raiz"), c("Una fila por estado permitido; los pesos se normalizan para sumar uno.", 
    "Uma linha por estado permitido; os pesos são normalizados para somar um."
    ), c("Estimar tasas", "Estimar taxas"), c("Proporcionar Q fija", 
    "Fornecer Q fixa"), c("Rellenar plantilla Q según restricciones", 
    "Preencher modelo Q conforme restrições"), c("Q fija: matriz CSV con nombres", 
    "Q fixa: matriz CSV com nomes"), c("Las filas son orígenes y las columnas destinos. Incluya encabezados y diagonales negativas de suma de tasas. Desactive la comparación.", 
    "As linhas são origens e as colunas destinos. Inclua cabeçalhos e diagonais negativas da soma das taxas. Desative a comparação."
    ), c("Ajustes de optimización", "Configurações de otimização"
    ), c("Guane: tres inicios deterministas", "Guane: três inícios determinísticos"
    ), c("Usar valores predeterminados del motor", "Usar valores padrão do motor"
    ), c("Tasas iniciales personalizadas", "Taxas iniciais personalizadas"
    ), c("Los valores predeterminados omiten q.init, min.q, max.q, logscale y opt.method. Los límites y el optimizador solo se aplican a inicios Guane o personalizados.", 
    "Os valores padrão omitem q.init, min.q, max.q, logscale e opt.method. Os limites e o otimizador só se aplicam a inícios Guane ou personalizados."
    ), c("Límite inferior de tasa (min.q)", "Limite inferior da taxa (min.q)"
    ), c("Optimizador (opt.method)", "Otimizador (opt.method)"
    ), c("Optimizar logaritmos de tasas (logscale)", "Otimizar logaritmos das taxas (logscale)"
    ), c("Tasas iniciales (q.init)", "Taxas iniciais (q.init)"
    ), c("Ingrese una tasa o una por índice positivo de restricción, en orden de índices. Desactive la comparación.", 
    "Insira uma taxa ou uma por índice positivo de restrição, em ordem de índices. Desative a comparação."
    ), c("Resultado de reconstrucción", "Resultado da reconstrução"
    ), c("Probabilidades marginales globales", "Probabilidades marginais globais"
    ), c("Asignaciones conjuntas y marginales globales", "Atribuições conjuntas e marginais globais"
    ), c("Tolerancia conjunta (tol)", "Tolerância conjunta (tol)"
    ), c("Las asignaciones conjuntas maximizan la configuración ancestral simultánea. Puede haber empates; las asignaciones no son probabilidades.", 
    "As atribuições conjuntas maximizam a configuração ancestral simultânea. Pode haver empates; as atribuições não são probabilidades."
    ), c("Vista previa de ajustes efectivos", "Prévia das configurações efetivas"
    ), c("Asignaciones ancestrales conjuntas", "Atribuições ancestrais conjuntas"
    ), c("Descargar análisis RDS", "Baixar análise RDS"), c("Ajuste avanzado Mk desconocido.", 
    "Configuração avançada Mk desconhecida."), c("Opción avanzada Mk no válida.", 
    "Opção avançada Mk inválida."), c("Los pesos requieren una fila estado,peso por estado permitido, sin encabezado.", 
    "Os pesos exigem uma linha estado,peso por estado permitido, sem cabeçalho."
    ), c("Los pesos deben nombrar cada estado permitido una vez, ser finitos y no negativos, y tener suma positiva.", 
    "Os pesos devem nomear cada estado permitido uma vez, ser finitos e não negativos, e ter soma positiva."
    ), c("Q fija requiere una matriz CSV numérica cuadrada con todos los estados permitidos en los encabezados de filas y columnas.", 
    "Q fixa exige uma matriz CSV numérica quadrada com todos os estados permitidos nos cabeçalhos de linhas e colunas."
    ), c("Q fija debe tener tasas no negativas fuera de la diagonal, diagonales negativas de suma de tasas y respetar las transiciones prohibidas.", 
    "Q fixa deve ter taxas não negativas fora da diagonal, diagonais negativas da soma das taxas e respeitar transições proibidas."
    ), c("Q fija debe respetar las tasas compartidas del modelo seleccionado.", 
    "Q fixa deve respeitar as taxas compartilhadas do modelo selecionado."
    ), c("La tolerancia conjunta debe ser finita y positiva.", 
    "A tolerância conjunta deve ser finita e positiva."), c("Los límites deben ser positivos y finitos; el superior debe superar al inferior y a 1e-8.", 
    "Os limites devem ser positivos e finitos; o superior deve superar o inferior e 1e-8."
    ), c("Las tasas iniciales deben ser un número o uno por índice de tasa, dentro de los límites.", 
    "As taxas iniciais devem ser um número ou um por índice de taxa, dentro dos limites."
    ), c("Q fija: sin optimización.", "Q fixa: sem otimização."
    ), c("Reconstrucción ancestral conjunta no válida.", "Reconstrução ancestral conjunta inválida."
    ), c("Ejecute la reconstrucción conjunta antes de ver las asignaciones.", 
    "Execute a reconstrução conjunta antes de ver as atribuições."
    ), c("Desactive la comparación de modelos al proporcionar Q fija.", 
    "Desative a comparação de modelos ao fornecer Q fixa."), 
    c("Desactive la comparación de modelos al proporcionar tasas iniciales personalizadas.", 
    "Desative a comparação de modelos ao fornecer taxas iniciais personalizadas."
    ), c("Las probabilidades de raíz se aplican a estados combinados, no a estados constituyentes. A+B representa coexistencia, no codificación incierta.", 
    "As probabilidades da raiz se aplicam a estados combinados, não a estados constituintes. A+B representa coexistência, não codificação incerta."
    ), c("Señal filogenética", "Sinal filogenético"), c("Reconstrucción ancestral", 
    "Reconstrução ancestral"), c("Diversificación", "Diversificação"
    ), c("Modelos SSE", "Modelos SSE"), c("PREVISTO", "PREVISTO"
    ), c("TU ESPACIO DE INVESTIGACIÓN", "SEU ESPAÇO DE PESQUISA"
    ), c("MÉTODOS COMPARATIVOS FILOGENÉTICOS", "MÉTODOS COMPARATIVOS FILOGENÉTICOS"
    ), c("01 / DATOS Y PARÁMETROS", "01 / DADOS E PARÂMETROS"
    ), c("Árbol filogenético", "Árvore filogenética"), c("Tabla de rasgos · CSV", 
    "Tabela de características · CSV"), c("Cargar datos de ejemplo", 
    "Carregar dados de exemplo"), c("Columna de taxones", "Coluna de táxons"
    ), c("Rasgo numérico", "Característica numérica"), c("Semilla aleatoria", 
    "Semente aleatória"), c("Aleatorizaciones de K", "Aleatorizações de K"
    ), c("Usar taxones coincidentes", "Usar táxons correspondentes"
    ), c("Elimina taxones sin correspondencia. Revisa primero el diagnóstico.", 
    "Remove táxons sem correspondência. Revise primeiro o diagnóstico."
    ), c("Analizar señal", "Analisar sinal"), c("Reiniciar", 
    "Reiniciar"), c("Vista del árbol", "Visualização da árvore"
    ), c("Vista de rasgos", "Visualização de características"
    ), c("Resultados de señal", "Resultados de sinal"), c("Código en vivo", 
    "Código ao vivo"), c("Diagnóstico y actividad", "Diagnóstico e atividade"
    ), c("Estructura de datos", "Estrutura dos dados"), c("Controles gráficos", 
    "Controles gráficos"), c("02 / APARIENCIA DEL ÁRBOL", "02 / APARÊNCIA DA ÁRVORE"
    ), c("Diseño del árbol", "Formato da árvore"), c("Dirección", 
    "Direção"), c("Usar longitudes de ramas", "Usar comprimentos dos ramos"
    ), c("Mostrar nombres de taxones", "Mostrar nomes dos táxons"
    ), c("Mostrar números de nodos", "Mostrar números dos nós"
    ), c("Tamaño del texto", "Tamanho do texto"), c("Grosor de ramas", 
    "Espessura dos ramos"), c("Exportar árbol · PDF", "Exportar árvore · PDF"
    ), c("Los ajustes visuales no modifican los datos del análisis.", 
    "As opções visuais não modificam os dados da análise."
    ), c("Exportar script R", "Exportar script R"), c("Árbol", 
    "Árvore"), c("Rasgos", "Características"), c("TAXONES", 
    "TÁXONS"), c("FILAS DE RASGOS", "LINHAS DE DADOS"), c("Árbol enraizado", 
    "Árvore enraizada"), c("Árbol sin raíz", "Árvore sem raiz"
    ), c("No hay árbol cargado", "Nenhuma árvore carregada"
    ), c("✓ Validación completa. Listo para analizar.", "✓ Validação concluída. Pronto para analisar."
    ), c("Carga un árbol filogenético.", "Carregue uma árvore filogenética."
    ), c("Carga una tabla de rasgos CSV.", "Carregue uma tabela CSV."
    ), c("Carga tus archivos o explora los datos de ejemplo.", 
    "Carregue seus arquivos ou explore os dados de exemplo."), 
    c("Ejemplo cargado: 10 especies y un rasgo continuo.", "Exemplo carregado: 10 espécies e uma característica contínua."
    ), c("Análisis completo. Los resultados corresponden a los datos actuales.", 
    "Análise concluída. Os resultados correspondem aos dados atuais."
    ), c("Para una investigación evolutiva transparente y reproducible.", 
    "Para uma pesquisa evolutiva transparente e reproduzível."
    ), c("Espacio local · Los datos permanecen en esta sesión", 
    "Espaço local · Os dados permanecem nesta sessão"), c("Rasgos filogenéticos", 
    "Características filogenéticas"), c("Métodos Comparativos Filogenéticos", 
    "Métodos Comparativos Filogenéticos"), c("Configuración", 
    "Configuração"), c("Cargar árbol individual", "Carregar árvore individual"
    ), c("Cargar rasgos · CSV", "Carregar características · CSV"
    ), c("Semilla", "Semente"), c("Revisa las discrepancias antes de podar. Los cambios se registran en el registro de diagnóstico.", 
    "Revise as divergências antes da poda. As alterações ficam no registro de diagnóstico."
    ), c("Restablecer controles", "Redefinir controles"), c("Datos", 
    "Dados"), c("Verificación de datos", "Verificação dos dados"
    ), c("Registro de diagnóstico", "Registro de diagnóstico"
    ), c("Exportar registro de diagnóstico", "Exportar registro de diagnóstico"
    ), c("Descripción / Mensajes", "Descrição / Mensagens"
    ), c("Estructura", "Estrutura"), c("Controles de tabla", 
    "Controles da tabela"), c("Filas de vista previa", "Linhas na visualização"
    ), c("Exportar rasgos", "Exportar características"), c("Exportar árbol", 
    "Exportar árvore"), c("Correlación de Pagel", "Correlação de Pagel"
    ), c("Rasgos discretos", "Características discretas"), c("Rasgos continuos", 
    "Características contínuas"), c("Rasgos polimórficos", 
    "Características polimórficas"), c("Tasas de diversificación", 
    "Taxas de diversificação"), c("Diversificación dependiente del carácter", 
    "Diversificação dependente do caráter"), c("Espacio de análisis", 
    "Espaço de análise"), c("La ejecución del análisis aún no está implementada. Prepara e inspecciona los datos en la tarjeta Datos.", 
    "A execução da análise ainda não está implementada. Prepare e inspecione os dados no cartão Dados."
    ), c("Los datos provienen de la tarjeta Datos. Cambiar datos o parámetros borra los resultados anteriores.", 
    "Os dados vêm do cartão Dados. Alterar dados ou parâmetros limpa os resultados anteriores."
    ), c("La normalidad de un rasgo no establece la normalidad de los residuos de regresión. Revisa los diagnósticos después del ajuste.", 
    "A normalidade de uma característica não estabelece a normalidade dos resíduos da regressão. Inspecione os diagnósticos após o ajuste."
    ), c("Prueba de normalidad de Shapiro–Wilk", "Teste de normalidade de Shapiro–Wilk"
    ), c("Transformación", "Transformação"), c("Logaritmo natural", 
    "Logaritmo natural"), c("Cuadrática", "Quadrática"), c("Recíproca", 
    "Recíproca"), c("Crear columna transformada", "Criar coluna transformada"
    ), c("Calcular contrastes independientes · ape", "Calcular contrastes independentes · ape"
    ), c("Los contrastes son datos por nodo, separados de la tabla de especies. Su regresión debe ajustarse pasando por el origen.", 
    "Os contrastes são dados por nó, separados da tabela de espécies. Sua regressão deve ser ajustada passando pela origem."
    ), c("Filograma", "Filograma"), c("Cladograma", "Cladograma"
    ), c("Izquierda a derecha", "Esquerda para direita"), c("Derecha a izquierda", 
    "Direita para esquerda"), c("Arriba hacia abajo", "De cima para baixo"
    ), c("Examinar...", "Procurar..."), c("Ningún archivo seleccionado", 
    "Nenhum arquivo selecionado"), c("Fecha y hora", "Data e hora"
    ), c("Acción", "Ação"), c("Métrica", "Métrica"), c("Estimación", 
    "Estimativa"), c("Valor p", "Valor p"), c("Prueba", "Teste"
    ), c("Requerido:", "Obrigatório:"), c("Error:", "Erro:"), 
    c("Advertencia:", "Aviso:"), c("Nota:", "Nota:"), c("Árbol cargado.", 
    "Árvore carregada."), c("Tabla de rasgos cargada.", "Tabela de características carregada."
    ), c("Espacio restablecido. Carga archivos nuevos o datos de ejemplo.", 
    "Espaço redefinido. Carregue novos arquivos ou dados de exemplo."
    ), c("Ejecuta un análisis con datos validados para ver resultados.", 
    "Execute uma análise com dados validados para ver resultados."
    ), c("Estimando la señal filogenética", "Estimando o sinal filogenético"
    ), c("Los nombres de los taxones del árbol deben ser únicos.", 
    "Os nomes dos táxons da árvore devem ser únicos."), c("El árbol contiene nombres de taxones vacíos.", 
    "A árvore contém nomes de táxons vazios."), c("El análisis requiere longitudes de ramas finitas y positivas.", 
    "A análise requer comprimentos de ramos finitos e positivos."
    ), c("Enraíza el árbol antes del análisis de señal.", 
    "Enraíze a árvore antes da análise de sinal."), c("El árbol contiene politomías; revisa su significado biológico.", 
    "A árvore contém politomias; examine seu significado biológico."
    ), c("El árbol no es ultramétrico. Puede usarse para señal; verifica las unidades de las ramas.", 
    "A árvore não é ultramétrica. Pode ser usada para sinal; verifique as unidades dos ramos."
    ), c("Selecciona la columna de taxones.", "Selecione a coluna de táxons."
    ), c("La tabla contiene nombres de taxones vacíos.", "A tabela contém nomes de táxons vazios."
    ), c("Los nombres de taxones de la tabla deben ser únicos.", 
    "Os nomes dos táxons da tabela devem ser únicos."), c("Selecciona un rasgo numérico.", 
    "Selecione uma característica numérica."), c("El rasgo debe contener valores numéricos finitos; corrige los valores ausentes antes del análisis.", 
    "A característica deve conter valores numéricos finitos; corrija valores ausentes antes da análise."
    ), c("El rasgo seleccionado no tiene variación.", "A característica selecionada não tem variação."
    ), c("Se requieren al menos cuatro taxones coincidentes.", 
    "São necessários pelo menos quatro táxons correspondentes."
    ), c("Corrige primero los valores no finitos.", "Corrija primeiro os valores não finitos."
    ), c("El logaritmo requiere valores positivos.", "O logaritmo requer valores positivos."
    ), c("La recíproca requiere valores distintos de cero.", 
    "A recíproca requer valores diferentes de zero."), c("La transformación produjo valores no finitos.", 
    "A transformação produziu valores não finitos."), c("La columna derivada ya existe. Selecciona otra fuente o restablece los datos.", 
    "A coluna derivada já existe. Selecione outra origem ou redefina os dados."
    ), c("Resuelve los problemas de datos antes de calcular contrastes.", 
    "Resolva os problemas dos dados antes de calcular contrastes."
    ), c("Los contrastes independientes requieren un árbol bifurcante.", 
    "Os contrastes independentes requerem uma árvore bifurcante."
    ), c("Corrige nombres de taxones duplicados o ausentes antes de emparejar.", 
    "Corrija nomes de táxons duplicados ou ausentes antes de combinar."
    ), c("Coinciden menos de cuatro taxones; carga datos compatibles.", 
    "Menos de quatro táxons correspondem; carregue dados compatíveis."
    ), c("Elige entre 99 y 9999 aleatorizaciones enteras.", "Escolha entre 99 e 9999 aleatorizações inteiras."
    ), c("Elige una semilla entera no negativa hasta 2147483647.", 
    "Escolha uma semente inteira não negativa até 2147483647."
    ), c("Shapiro-Wilk requiere entre 3 y 5000 valores finitos y no constantes.", 
    "Shapiro-Wilk requer entre 3 e 5000 valores finitos e não constantes."
    ), c("Correlación de Pagel: evaluar dos rasgos binarios.", 
    "Correlação de Pagel: testar duas características binárias."
    ), c("gls(): estructuras de correlación de movimiento browniano, Grafen, Pagel y Blomberg.", 
    "gls(): estruturas de correlação de movimento browniano, Grafen, Pagel e Blomberg."
    ), c("phylolm / brms: modelos logísticos, Poisson y binomiales con múltiples predictores.", 
    "phylolm / brms: modelos logísticos, Poisson e binomiais com múltiplos preditores."
    ), c("Linajes a través del tiempo", "Linhagens ao longo do tempo"
    ), c("Usa el árbol de Datos; no requiere tabla de rasgos.", 
    "Usa a árvore de Dados; não requer tabela de características."
    ), c("Ejecutar LTT", "Executar LTT"), c("Eje de linajes logarítmico", 
    "Eixo de linhagens logarítmico"), c("Exportar tabla LTT", 
    "Exportar tabela LTT"), c("Exportar script LTT", "Exportar script LTT"
    ), c("Curva de linajes a través del tiempo calculada.", 
    "Curva de linhagens ao longo do tempo calculada."), c("Árbol bifurcante", 
    "Árvore bifurcante"), c("Árbol ultramétrico", "Árvore ultramétrica"
    ), c("No ultramétrico", "Não ultramétrica"), c("El árbol contiene politomías", 
    "A árvore contém politomias"), c("Describe la ramificación en el tiempo. El muestreo incompleto puede sesgar el patrón; no estima tasas de especiación o extinción.", 
    "Descreve a ramificação no tempo. A amostragem incompleta pode enviesar o padrão; não estima taxas de especiação ou extinção."
    ), c("Controles de análisis", "Controles da análise"), 
    c("Resultados", "Resultados"), c("Diagnósticos", "Diagnósticos"
    ), c("El código aparecerá cuando se implemente el análisis.", 
    "O código aparecerá quando a análise for implementada."
    ), c("Distribución de datos", "Distribuição dos dados"
    ), c("Gráfico de distribución", "Gráfico de distribuição"
    ), c("Histograma", "Histograma"), c("Densidad", "Densidade"
    ), c("Q–Q normal", "Q–Q normal"), c("Intervalos del histograma", 
    "Intervalos do histograma"), c("Mostrar observaciones individuales", 
    "Mostrar observações individuais"), c("Exportar distribución · PDF", 
    "Exportar distribuição · PDF"), c("Columna para visualizar", 
    "Coluna para visualizar"), c("Deshacer cambio de datos", 
    "Desfazer alteração dos dados"), c("Restaurar datos originales", 
    "Restaurar dados originais"), c("No hay cambios para deshacer.", 
    "Não há alterações para desfazer."), c("Exportar script de preparación", 
    "Exportar script de preparação"), c("Respuesta", "Resposta"
    ), c("Predictores", "Preditores"), c("Estructura de correlación", 
    "Estrutura de correlação"), c("Parámetro inicial o fijo (rho / lambda / g)", 
    "Parâmetro inicial ou fixo (rho / lambda / g)"), c("Mantener fijo el parámetro de correlación", 
    "Manter fixo o parâmetro de correlação"), c("Método de estimación", 
    "Método de estimação"), c("Usa datos preparados de especies. No introduzca valores PIC. Esta versión requiere un árbol ultramétrico.", 
    "Usa dados preparados de espécies. Não forneça valores PIC. Esta versão requer uma árvore ultramétrica."
    ), c("Grafen reemplaza las longitudes de rama según la topología; el árbol cargado permanece intacto.", 
    "Grafen substitui os comprimentos dos ramos usando a topologia; a árvore carregada permanece intacta."
    ), c("Ejecutar PGLS", "Executar PGLS"), c("Controles del gráfico", 
    "Controles do gráfico"), c("Gráfico", "Gráfico"), c("Observado frente a ajustado", 
    "Observado versus ajustado"), c("Intervalos de coeficientes", 
    "Intervalos dos coeficientes"), c("Diagnóstico de residuos", 
    "Diagnóstico de resíduos"), c("Color del gráfico", "Cor do gráfico"
    ), c("Verde Guane", "Verde Guane"), c("Cian clásico", "Ciano clássico"
    ), c("Escala de grises", "Escala de cinza"), c("Mostrar etiquetas de taxones", 
    "Mostrar rótulos dos táxons"), c("Descargar gráfico PDF", 
    "Baixar gráfico PDF"), c("Descargar código R del gráfico", 
    "Baixar código R do gráfico"), c("Descargar coeficientes CSV", 
    "Baixar coeficientes CSV"), c("Los intervalos t del 95% son condicionales a la covarianza ajustada. La diagonal discontinua representa concordancia perfecta, no una recta de regresión.", 
    "Os intervalos t de 95% são condicionais à covariância ajustada. A diagonal tracejada representa concordância perfeita, não uma reta de regressão."
    ), c("Cada coeficiente describe el cambio de respuesta por unidad del predictor, manteniendo constantes los demás predictores. La asociación no establece causalidad.", 
    "Cada coeficiente descreve a mudança na resposta por unidade do preditor, mantendo constantes os demais preditores. Associação não estabelece causalidade."
    ), c("Inspeccione patrones y desviaciones Q-Q en los residuos normalizados. La normalidad del rasgo no es la normalidad residual.", 
    "Inspecione padrões e desvios Q-Q nos resíduos normalizados. A normalidade da característica não é a normalidade residual."
    ), c("El script R incluye los datos preparados, vuelve a ajustar el modelo y dibuja el gráfico seleccionado. Edítelo en RStudio sin Guane.", 
    "O script R inclui os dados preparados, reajusta o modelo e desenha o gráfico selecionado. Edite-o no RStudio sem Guane."
    ), c("Seleccione variables y ejecute PGLS.", "Selecione variáveis e execute PGLS."
    ), c("Los datos cambiaron. Ejecute PGLS para actualizar los resultados.", 
    "Os dados mudaram. Execute PGLS para atualizar os resultados."
    ), c("PGLS completado. Revise el diagnóstico de residuos y las advertencias del ajuste.", 
    "PGLS concluído. Revise os diagnósticos de resíduos e os avisos do ajuste."
    ), c("No se informaron advertencias de ajuste. Revise los diagnósticos antes de interpretar.", 
    "Nenhum aviso de ajuste. Revise os diagnósticos antes de interpretar."
    ), c("PGLS requiere un árbol enraizado y bifurcante.", "PGLS requer uma árvore enraizada e bifurcante."
    ), c("PGLS requiere longitudes de rama finitas y positivas.", 
    "PGLS requer comprimentos de ramos finitos e positivos."), 
    c("Esta implementación de PGLS requiere un árbol ultramétrico.", 
    "Esta implementação de PGLS requer uma árvore ultramétrica."
    ), c("Seleccione una columna única de taxones en la tabla.", 
    "Selecione uma coluna única de táxons na tabela."), c("Empareje etiquetas de taxones únicas y no vacías en Datos antes de PGLS.", 
    "Associe rótulos de táxons únicos e não vazios em Dados antes de PGLS."
    ), c("Seleccione una respuesta y predictores numéricos distintos.", 
    "Selecione uma resposta e preditores numéricos distintos."
    ), c("Las variables PGLS deben ser finitas, numéricas y no constantes. No se eliminan filas automáticamente.", 
    "As variáveis PGLS devem ser finitas, numéricas e não constantes. Nenhuma linha é removida automaticamente."
    ), c("PGLS necesita al menos cuatro taxones y dos grados de libertad residuales.", 
    "PGLS precisa de pelo menos quatro táxons e dois graus de liberdade residuais."
    ), c("Use lambda entre 0 y 1, o rho o g positivos.", "Use lambda entre 0 e 1, ou rho ou g positivos."
    ), c("Los predictores son colineales. Seleccione un conjunto independiente.", 
    "Os preditores são colineares. Selecione um conjunto independente."
    ), c("PGLS produjo un ajuste inválido; inspeccione los datos y la configuración de correlación.", 
    "PGLS produziu um ajuste inválido; inspecione os dados e as configurações de correlação."
    ), c("La lambda estimada está fuera del intervalo admitido [0, 1]. Pruebe un valor fijo u otra estructura.", 
    "O lambda estimado está fora do intervalo aceito [0, 1]. Tente um valor fixo ou outra estrutura."
    ), c("Valores ajustados", "Valores ajustados"), c("Valores observados", 
    "Valores observados"), c("Estimación del coeficiente", "Estimativa do coeficiente"
    ), c("Intervalos de coeficientes del 95%", "Intervalos dos coeficientes de 95%"
    ), c("Residuos normalizados", "Resíduos normalizados"), 
    c("Prueba de correlación discreta de Pagel (1994)", "Teste de correlação discreta de Pagel (1994)"
    ), c("Evalúa la evolución correlacionada de dos rasgos binarios comparando modelos evolutivos independientes y dependientes.", 
    "Testa a evolução correlacionada de duas características binárias comparando modelos evolutivos independentes e dependentes."
    ), c("Muestras de la prueba K (incluida la observada)", "Amostras do teste K (incluindo a observada)"
    ), c("La prueba K usa una muestra observada y las restantes aleatorizadas.", 
    "O teste K usa uma amostra observada e as demais aleatorizadas."
    ), c("Valores observados en las puntas", "Valores observados nas pontas"
    ), c("Valores K aleatorizados", "Valores K aleatorizados"
    ), c("K observado", "K observado"), c("Paleta", "Paleta"), 
    c("Semilla:", "Semente:"), c("Muestras de la prueba K:", 
    "Amostras do teste K:"), c("Muestras aleatorizadas:", "Amostras aleatorizadas:"
    ), c("Los colores de las puntas representan valores observados del rasgo, no estados ancestrales reconstruidos.", 
    "As cores das pontas representam valores observados da característica, não estados ancestrais reconstruídos."
    ), c("K compara la similitud del rasgo con las expectativas del movimiento browniano: K = 1 es la referencia; valores mayores indican mayor similitud entre parientes. Su prueba de aleatorización evalúa la asignación aleatoria de valores a las puntas.", 
    "K compara a similaridade da característica com as expectativas do movimento browniano: K = 1 é a referência; valores maiores indicam maior similaridade entre parentes. Seu teste de aleatorização avalia a atribuição aleatória de valores às pontas."
    ), c("Lambda mide la escala de la covarianza filogenética. La prueba de razón de verosimilitudes compara la lambda ajustada con lambda = 0. Un valor p pequeño respalda la señal filogenética bajo este modelo.", 
    "Lambda mede a escala da covariância filogenética. O teste da razão de verossimilhanças compara o lambda ajustado com lambda = 0. Um valor p pequeno apoia o sinal filogenético sob este modelo."
    ), c("El histograma excluye la muestra observada. La línea discontinua marca K observado. Los valores p conservan la convención de la prueba del paquete, que incluye la muestra observada.", 
    "O histograma exclui a amostra observada. A linha tracejada marca K observado. Os valores p mantêm a convenção do teste do pacote, que inclui a amostra observada."
    ), c("No se ajusta un modelo de error de medición. Inspeccione la calidad del rasgo y los supuestos del árbol antes de interpretar las pruebas.", 
    "Não é ajustado um modelo de erro de medição. Inspecione a qualidade da característica e os pressupostos da árvore antes de interpretar os testes."
    ), c("El script R incluye los datos preparados, repite las pruebas y reproduce el gráfico seleccionado. Edite la configuración gráfica en RStudio.", 
    "O script R inclui os dados preparados, repete os testes e reproduz o gráfico selecionado. Edite as configurações gráficas no RStudio."
    ), c("Descargar resultados CSV", "Baixar resultados CSV"), 
    c("El análisis de señal produjo estimaciones no finitas. Inspeccione los datos.", 
    "A análise de sinal produziu estimativas não finitas. Inspecione os dados."
    ), c("Rasgo binario X", "Característica binária X"), c("Rasgo binario Y", 
    "Característica binária Y"), c("Inicios de optimización", 
    "Inicializações da otimização"), c("Tasa máxima por unidad de longitud de rama", 
    "Taxa máxima por unidade de comprimento de ramo"), c("Modelos ARD: cuatro tasas independientes frente a ocho dependientes. Probabilidades iguales en la raíz para los cuatro estados conjuntos.", 
    "Modelos ARD: quatro taxas independentes versus oito dependentes. Probabilidades iguais na raiz para os quatro estados conjuntos."
    ), c("Ejecutar correlación de Pagel", "Executar correlação de Pagel"
    ), c("Modelo evolutivo", "Modelo evolutivo"), c("Evolución dependiente", 
    "Evolução dependente"), c("Evolución independiente", "Evolução independente"
    ), c("Escalar flechas por tasa", "Dimensionar setas pela taxa"
    ), c("Codificación de estados binarios", "Codificação dos estados binários"
    ), c("Comparación de modelos", "Comparação de modelos"
    ), c("Prueba de razón de verosimilitudes", "Teste da razão de verossimilhanças"
    ), c("Un valor p asintótico pequeño respalda la evolución dependiente bajo estos modelos; no establece causalidad ni una dirección de influencia.", 
    "Um valor p assintótico pequeno apoia a evolução dependente sob estes modelos; não estabelece causalidade nem direção de influência."
    ), c("Compare AIC solo entre modelos con los mismos datos y supuestos de raíz. Las tasas en cero y los estados escasos pueden afectar la aproximación chi-cuadrado.", 
    "Compare AIC apenas entre modelos com os mesmos dados e pressupostos de raiz. Taxas em zero e estados raros podem comprometer a aproximação qui-quadrado."
    ), c("Descargar tasas de transición CSV", "Baixar taxas de transição CSV"
    ), c("Conteos de estados conjuntos", "Contagens dos estados conjuntos"
    ), c("Intentos de optimización", "Tentativas de otimização"
    ), c("Se requiere código de convergencia 0. Cada modelo conserva su mayor verosimilitud convergida entre los inicios solicitados.", 
    "É necessário o código de convergência 0. Cada modelo mantém sua maior verossimilhança convergida entre as inicializações solicitadas."
    ), c("Las tasas no tienen intervalos de incertidumbre en esta versión. No están implementados el bootstrap paramétrico ni los modelos direccionales.", 
    "As taxas não têm intervalos de incerteza nesta versão. Bootstrap paramétrico e modelos direcionais não estão implementados."
    ), c("El script incluye los datos binarios preparados, reajusta ambos modelos y reproduce el diagrama seleccionado en RStudio.", 
    "O script inclui os dados binários preparados, reajusta ambos os modelos e reproduz o diagrama selecionado no RStudio."
    ), c("Seleccione dos rasgos binarios y ejecute la prueba.", 
    "Selecione duas características binárias e execute o teste."
    ), c("Los datos cambiaron. Ejecute la prueba de correlación para actualizar los resultados.", 
    "Os dados mudaram. Execute o teste de correlação para atualizar os resultados."
    ), c("Ajustando la correlación de Pagel", "Ajustando a correlação de Pagel"
    ), c("Prueba de correlación completada. Revise la convergencia y los conteos de estados.", 
    "Teste de correlação concluído. Revise a convergência e as contagens dos estados."
    ), c("Pagel requiere un árbol enraizado y bifurcante.", 
    "Pagel requer uma árvore enraizada e bifurcante."), c("Pagel requiere longitudes de rama finitas y positivas.", 
    "Pagel requer comprimentos de ramos finitos e positivos."
    ), c("Seleccione dos columnas distintas de rasgos binarios.", 
    "Selecione duas colunas distintas de características binárias."
    ), c("Pagel requiere al menos cuatro taxones con etiquetas únicas y coincidentes. Revise la coincidencia en Datos.", 
    "Pagel requer pelo menos quatro táxons com rótulos únicos e correspondentes. Revise a correspondência em Dados."
    ), c("Cada rasgo debe tener exactamente dos estados observados sin datos faltantes. No se realiza binarización ni eliminación automática de filas.", 
    "Cada característica deve ter exatamente dois estados observados sem dados ausentes. Não há binarização nem remoção automática de linhas."
    ), c("Elija de uno a cinco inicios de optimización.", "Escolha de uma a cinco inicializações da otimização."
    ), c("La tasa máxima de transición debe ser positiva y finita.", 
    "A taxa máxima de transição deve ser positiva e finita."
    ), c("El ajuste dependiente es peor que el ajuste independiente anidado. Aumente los inicios o inspeccione el límite de tasas.", 
    "O ajuste dependente é pior que o ajuste independente aninhado. Aumente as inicializações ou inspecione o limite das taxas."
    ), c("Algunos estados conjuntos están ausentes; las tasas pueden estar mal identificadas y la prueba asintótica ser poco fiable.", 
    "Alguns estados conjuntos estão ausentes; as taxas podem estar mal identificadas e o teste assintótico ser pouco confiável."
    ), c("Una tasa ajustada está en un límite o cerca de él. Inspeccione la sensibilidad al límite de tasas y a los valores iniciales.", 
    "Uma taxa ajustada está em um limite ou próxima dele. Inspecione a sensibilidade ao limite das taxas e aos valores iniciais."
    ), c("Algunos intentos de optimización fallaron. Solo los ajustes convergidos fueron elegibles.", 
    "Algumas tentativas de otimização falharam. Apenas ajustes convergidos foram elegíveis."
    ), c("Tasas por unidad de longitud de rama; códigos de nodos XY.", 
    "Taxas por unidade de comprimento de ramo; códigos dos nós XY."
    ), c("Rasgo", "Característica"), c("Estado 0", "Estado 0"
    ), c("Estado 1", "Estado 1"), c("independiente", "independente"
    ), c("dependiente", "dependente"), c("Los valores binarios deben ser finitos y no faltantes.", 
    "Os valores binários devem ser finitos e não ausentes."
    ), c("Conjunto de ejemplo", "Conjunto de exemplo"), c("Rasgo continuo", 
    "Característica contínua"), c("Rasgos binarios sintéticos", 
    "Características binárias sintéticas"), c("Ejemplo sintético cargado: 16 especies y dos rasgos binarios.", 
    "Exemplo sintético carregado: 16 espécies e duas características binárias."
    ), c("Ejemplo sintético: 20 puntas y 19 filas de rasgos. Sp20 se omite intencionalmente de la tabla.", 
    "Exemplo sintético: 20 pontas e 19 linhas de características. Sp20 está intencionalmente ausente da tabela."
    ), c("Ejemplo sintético cargado: 20 puntas y 19 filas de rasgos. Revise la discrepancia intencional de Sp20 en Comprobar datos.", 
    "Exemplo sintético carregado: 20 pontas e 19 linhas de características. Revise a discrepância intencional de Sp20 em Verificar dados."
    ), c("Rasgo para señal", "Característica para sinal"), 
    c("Seleccione una columna numérica original o transformada de Datos. Los PIC son contrastes de nodos y no se usan como rasgos de especies.", 
    "Selecione uma coluna numérica original ou transformada de Dados. PICs são contrastes de nós e não são usados como características de espécies."
    ), c("Cargue un árbol y rasgos en Datos. Seleccione dos columnas binarias distintas.", 
    "Carregue uma árvore e características em Dados. Selecione duas colunas binárias distintas."
    ), c("Se requieren dos columnas binarias, cada una con exactamente dos estados observados y sin valores faltantes.", 
    "São necessárias duas colunas binárias, cada uma com exatamente dois estados observados e sem valores ausentes."
    ), c("Hay dos rasgos binarios disponibles. Resuelva las diferencias de taxones en Datos antes de ejecutar.", 
    "Há duas características binárias disponíveis. Resolva as diferenças de táxons em Dados antes de executar."
    ), c("Ejecute la prueba de correlación con datos coincidentes para mostrar resultados.", 
    "Execute o teste de correlação com dados correspondentes para exibir resultados."
    ), c("Regresión logística filogenética", "Regressão logística filogenética"
    ), c("Respuesta Bernoulli con enlace logit; múltiples predictores numéricos.", 
    "Resposta Bernoulli com ligação logit; múltiplos preditores numéricos."
    ), c("Respuesta binaria", "Resposta binária"), c("Estado del evento (1)", 
    "Estado do evento (1)"), c("Ejecutar PGLM", "Executar PGLM"
    ), c("Los modelos Poisson, binomial agrupado y bayesianos están previstos.", 
    "Modelos Poisson, binomial agrupado e bayesianos estão previstos."
    ), c("Resultados observados y probabilidades ajustadas", 
    "Resultados observados e probabilidades ajustadas"), c("Intervalos de Wald condicionales del 95%", 
    "Intervalos de Wald condicionais de 95%"), c("Residuo de Pearson", 
    "Resíduo de Pearson"), c("Probabilidad ajustada del evento", 
    "Probabilidade ajustada do evento"), c("Coeficiente de log-odds", 
    "Coeficiente de log-odds"), c("Los coeficientes describen cambios en log-odds manteniendo constantes los demás predictores. Los intervalos y errores estándar son condicionales al alfa estimado.", 
    "Os coeficientes descrevem mudanças em log-odds mantendo os demais preditores constantes. Os intervalos e erros padrão são condicionais ao alfa estimado."
    ), c("Descargar probabilidades ajustadas CSV", "Baixar probabilidades ajustadas CSV"
    ), c("Los residuos binarios no tienen distribución normal. Este gráfico permite revisar patrones; no es una prueba de normalidad ni de bondad de ajuste calibrada.", 
    "Resíduos binários não têm distribuição normal. Este gráfico permite verificar padrões; não é um teste de normalidade nem de qualidade do ajuste calibrado."
    ), c("El script incluye datos preparados y configuraciones y reproduce el gráfico seleccionado en RStudio.", 
    "O script inclui dados preparados e configurações e reproduz o gráfico selecionado no RStudio."
    ), c("Seleccione una respuesta binaria, un estado del evento y predictores.", 
    "Selecione uma resposta binária, um estado do evento e preditores."
    ), c("Los datos cambiaron. Ejecute PGLM para actualizar los resultados.", 
    "Os dados mudaram. Execute PGLM para atualizar os resultados."
    ), c("PGLM completado. Revise los diagnósticos y las advertencias del ajuste.", 
    "PGLM concluído. Revise os diagnósticos e os avisos do ajuste."
    ), c("Ejecute PGLM con datos coincidentes para mostrar resultados.", 
    "Execute PGLM com dados correspondentes para exibir resultados."
    ), c("PGLM requiere un árbol enraizado y bifurcante.", "PGLM requer uma árvore enraizada e bifurcante."
    ), c("PGLM requiere longitudes de ramas finitas y positivas.", 
    "PGLM requer comprimentos de ramos finitos e positivos."), 
    c("Haga coincidir etiquetas únicas y no vacías de taxones en Datos antes de PGLM.", 
    "Faça corresponder rótulos únicos e não vazios de táxons em Dados antes do PGLM."
    ), c("Seleccione una respuesta binaria y predictores numéricos distintos.", 
    "Selecione uma resposta binária e preditores numéricos distintos."
    ), c("Seleccione el estado del evento de una respuesta con exactamente dos estados no faltantes.", 
    "Selecione o estado do evento de uma resposta com exatamente dois estados não ausentes."
    ), c("Los predictores PGLM deben ser finitos, numéricos y no constantes. No se eliminan filas automáticamente.", 
    "Os preditores PGLM devem ser finitos, numéricos e não constantes. Nenhuma linha é removida automaticamente."
    ), c("PGLM necesita al menos seis taxones, dos observaciones por estado y dos grados de libertad residuales.", 
    "PGLM precisa de pelo menos seis táxons, duas observações por estado e dois graus de liberdade residuais."
    ), c("La optimización PGLM no convergió. Revise las variables y la configuración del modelo.", 
    "A otimização PGLM não convergiu. Revise as variáveis e as configurações do modelo."
    ), c("PGLM produjo estimaciones o errores estándar no válidos.", 
    "PGLM produziu estimativas ou erros padrão inválidos."), 
    c("PGLM produjo probabilidades ajustadas no válidas.", "PGLM produziu probabilidades ajustadas inválidas."
    ), c("Alfa está cerca de su límite de optimización; revise la sensibilidad antes de inferir.", 
    "Alfa está perto de seu limite de otimização; revise a sensibilidade antes da inferência."
    ), c("Detalles del modelo", "Detalhes do modelo"), c("Modelos lineales generalizados filogenéticos", 
    "Modelos lineares generalizados filogenéticos"), c("Familia de respuesta", 
    "Família da resposta"), c("Binaria (Bernoulli / logit)", 
    "Binária (Bernoulli / logit)"), c("Conteos (Poisson GEE / log)", 
    "Contagens (Poisson GEE / log)"), c("Los modelos binomiales agrupados y bayesianos están previstos.", 
    "Modelos binomiais agrupados e bayesianos estão previstos."
    ), c("Valores observados y ajustados", "Valores observados e ajustados"
    ), c("Descargar valores ajustados CSV", "Baixar valores ajustados CSV"
    ), c("Seleccione una familia de respuesta, una respuesta y predictores.", 
    "Selecione uma família da resposta, uma resposta e preditores."
    ), c("Poisson GEE con enlace log y múltiples predictores numéricos. Seleccione una columna de conteos enteros no negativos.", 
    "Poisson GEE com ligação log e múltiplos preditores numéricos. Selecione uma coluna de contagens inteiras não negativas."
    ), c("Los conteos requieren un esfuerzo de observación comparable. No se admiten offsets de exposición ni modelos con inflación de ceros o binomiales negativos.", 
    "As contagens exigem esforço de observação comparável. Não há suporte a offsets de exposição nem a modelos com inflação de zeros ou binomiais negativos."
    ), c("Los coeficientes describen cambios en el logaritmo del conteo medio, manteniendo constantes los demás predictores; exp(coeficiente) es la razón de conteos esperados por unidad del predictor.", 
    "Os coeficientes descrevem mudanças no logaritmo da contagem média, mantendo os demais preditores constantes; exp(coeficiente) é a razão das contagens esperadas por unidade do preditor."
    ), c("Los intervalos GEE usan errores estándar basados en el modelo y ajustados por escala, no errores robustos sandwich ni bootstrap. La correlación filogenética está fijada por el árbol. No hay verosimilitud ni AIC disponibles.", 
    "Os intervalos GEE usam erros padrão baseados no modelo e ajustados pela escala, não erros robustos sandwich ou bootstrap. A correlação filogenética é fixada pela árvore. Verossimilhança e AIC não estão disponíveis."
    ), c("Los residuos de Pearson usan (observado - ajustado) / sqrt(ajustado), sin ajuste por dispersión. Los patrones pueden revelar una especificación inadecuada; no se asume normalidad residual.", 
    "Os resíduos de Pearson usam (observado - ajustado) / sqrt(ajustado), sem ajuste por dispersão. Os padrões podem revelar especificação inadequada; não se assume normalidade residual."
    ), c("La dispersión es la suma de residuos de Pearson al cuadrado dividida por los grados de libertad residuales. Valores superiores a uno indican variación adicional respecto a la varianza de trabajo Poisson; es descriptivo, no una prueba calibrada.", 
    "A dispersão é a soma dos resíduos de Pearson ao quadrado dividida pelos graus de liberdade residuais. Valores acima de um indicam variação adicional em relação à variância de trabalho Poisson; é descritivo, não um teste calibrado."
    ), c("Las respuestas de conteo deben ser enteros finitos no negativos con al menos dos valores distintos. No se redondean valores ni se eliminan filas automáticamente.", 
    "As respostas de contagem devem ser inteiros finitos não negativos com pelo menos dois valores diferentes. Não há arredondamento nem remoção automática de linhas."
    ), c("PGLM necesita al menos seis taxones y dos grados de libertad residuales.", 
    "PGLM precisa de pelo menos seis táxons e dois graus de liberdade residuais."
    ), c("PGLM produjo una estimación de dispersión no válida.", 
    "PGLM produziu uma estimativa de dispersão inválida."), 
    c("PGLM produjo conteos ajustados no válidos.", "PGLM produziu contagens ajustadas inválidas."
    ), c("Los taxones ajustados por PGLM no coinciden con el árbol de entrada.", 
    "Os táxons ajustados pelo PGLM não correspondem à árvore de entrada."
    ), c("Coeficiente del logaritmo de la media", "Coeficiente do logaritmo da média"
    ), c("Intervalos de Wald GEE del 95%", "Intervalos de Wald GEE de 95%"
    ), c("Conteo medio ajustado", "Contagem média ajustada"), 
    c("Conteo observado", "Contagem observada"), c("Conteos observados y ajustados", 
    "Contagens observadas e ajustadas"), c("Taxones", "Táxons"
    ), c("Ceros observados", "Zeros observados"), c("Grados de libertad residuales", 
    "Graus de liberdade residuais"), c("Dispersión", "Dispersão"
    ), c("Código de convergencia", "Código de convergência"
    ), c("Valor", "Valor"), c("Binomial agrupada (GEE / logit)", 
    "Binomial agrupada (GEE / logit)"), c("Respuesta / éxitos", 
    "Resposta / sucessos"), c("Ensayos totales", "Tentativas totais"
    ), c("Éxitos totales", "Sucessos totais"), c("Los modelos bayesianos están previstos.", 
    "Modelos bayesianos estão previstos."), c("Seleccione éxitos y ensayos totales por especie. Los ensayos deben ser enteros positivos; los éxitos pueden variar de cero al total de ensayos.", 
    "Selecione sucessos e tentativas totais por espécie. As tentativas devem ser inteiros positivos; os sucessos podem variar de zero ao total de tentativas."
    ), c("La GEE binomial agrupada usa un enlace logit y una correlación de trabajo fija derivada del árbol. No se expanden los ensayos ni se redondean las proporciones.", 
    "A GEE binomial agrupada usa ligação logit e uma correlação de trabalho fixa derivada da árvore. Não há expansão de tentativas nem arredondamento de proporções."
    ), c("Los coeficientes describen cambios en log-odds manteniendo constantes los demás predictores. Los intervalos usan covarianza basada en el modelo con escala binomial fijada en uno.", 
    "Os coeficientes descrevem mudanças em log-odds mantendo os demais preditores constantes. Os intervalos usam covariância baseada no modelo com escala binomial fixada em um."
    ), c("Una filogenia es un grupo correlacionado. No se presentan intervalos robustos sandwich, verosimilitud ni AIC. No se ajusta variación extrabinomial.", 
    "Uma filogenia é um grupo correlacionado. Não são apresentados intervalos robustos sandwich, verossimilhança ou AIC. Não se ajusta variação extrabinomial."
    ), c("Los residuos de Pearson comparan los éxitos observados con ensayos por probabilidad ajustada, usando varianza binomial. La dispersión es descriptiva y no reescala los intervalos ajustados.", 
    "Os resíduos de Pearson comparam os sucessos observados com tentativas vezes probabilidade ajustada, usando variância binomial. A dispersão é descritiva e não redimensiona os intervalos ajustados."
    ), c("Dispersión de Pearson (descriptiva)", "Dispersão de Pearson (descritiva)"
    ), c("Seleccione una columna de ensayos totales distinta de los éxitos y predictores.", 
    "Selecione uma coluna de tentativas totais diferente dos sucessos e preditores."
    ), c("La binomial agrupada requiere conteos enteros con ensayos positivos y 0 <= éxitos <= ensayos. No se eliminan filas automáticamente.", 
    "A binomial agrupada exige contagens inteiras com tentativas positivas e 0 <= sucessos <= tentativas. Nenhuma linha é removida automaticamente."
    ), c("La binomial agrupada necesita al menos un éxito y un fracaso entre las especies.", 
    "A binomial agrupada precisa de pelo menos um sucesso e um fracasso entre as espécies."
    ), c("Las probabilidades binomiales ajustadas están en un límite. Revise la separación y la complejidad del modelo.", 
    "As probabilidades binomiais ajustadas estão em um limite. Verifique a separação e a complexidade do modelo."
    ), c("La correlación filogenética de trabajo no es válida.", 
    "A correlação filogenética de trabalho é inválida."), 
    c("La GEE binomial agrupada no convergió. Revise los datos y la complejidad del modelo.", 
    "A GEE binomial agrupada não convergiu. Revise os dados e a complexidade do modelo."
    ), c("Probabilidad de éxito ajustada", "Probabilidade de sucesso ajustada"
    ), c("Proporción de éxito observada", "Proporção de sucesso observada"
    ), c("Proporciones observadas y ajustadas", "Proporções observadas e ajustadas"
    ), c("Predictores categóricos", "Preditores categóricos"
    ), c("Categoría de referencia", "Categoria de referência"
    ), c("Marque explícitamente los predictores categóricos, incluidos los códigos numéricos de estados. Los demás predictores son continuos.", 
    "Marque explicitamente os preditores categóricos, incluindo códigos numéricos de estados. Os demais preditores são contínuos."
    ), c("Los coeficientes categóricos comparan cada estado con su referencia, manteniendo constantes los demás predictores.", 
    "Os coeficientes categóricos comparam cada estado com sua referência, mantendo os demais preditores constantes."
    ), c("Las columnas categóricas deben ser predictores seleccionados.", 
    "As colunas categóricas devem ser preditores selecionados."
    ), c("Los predictores categóricos no pueden tener estados vacíos o faltantes.", 
    "Os preditores categóricos não podem ter estados vazios ou ausentes."
    ), c("Los predictores categóricos necesitan al menos dos estados observados.", 
    "Os preditores categóricos precisam de pelo menos dois estados observados."
    ), c("Elija una categoría de referencia observada para cada predictor categórico.", 
    "Escolha uma categoria de referência observada para cada preditor categórico."
    ), c("Algunas categorías contienen menos de tres taxones; las estimaciones pueden ser inestables.", 
    "Algumas categorias contêm menos de três táxons; as estimativas podem ser instáveis."
    ), c("Seleccione una respuesta y predictores distintos.", 
    "Selecione uma resposta e preditores distintos."), c("GEE de Poisson con enlace log y predictores numéricos o categóricos. Seleccione una columna de conteos enteros no negativos.", 
    "GEE de Poisson com ligação log e preditores numéricos ou categóricos. Selecione uma coluna de contagens inteiras não negativas."
    ), c("Respuesta Bernoulli con enlace logit; múltiples predictores numéricos o categóricos.", 
    "Resposta Bernoulli com ligação logit; múltiplos preditores numéricos ou categóricos."
    ), c("Comparar modelos de covarianza (ML)", "Comparar modelos de covariância (ML)"
    ), c("La comparación usa los mismos datos y predictores para las cuatro estructuras, con ML y el parámetro fijo o inicial actual.", 
    "A comparação usa os mesmos dados e preditores para as quatro estruturas, com ML e o parâmetro fixo ou inicial atual."
    ), c("Comparación de modelos de covarianza", "Comparação de modelos de covariância"
    ), c("Los pesos AIC indican apoyo relativo entre los modelos ajustados, no probabilidades de que sean verdaderos. Se muestran los fallos. No se realizan pruebas de razón de verosimilitud ni promedios de modelos.", 
    "Os pesos AIC indicam suporte relativo entre os modelos ajustados, não probabilidades de serem verdadeiros. As falhas são listadas. Não são feitos testes de razão de verossimilhança nem médias de modelos."
    ), c("Comparación terminada. Revise los modelos fallidos y las advertencias.", 
    "Comparação concluída. Revise os modelos com falhas e os avisos."
    ), c("Ejecutar diagnóstico de influencia de taxones", "Executar diagnóstico de influência dos táxons"
    ), c("Reajusta el modelo una vez por taxón en copias podadas temporales. Los datos preparados no cambian. Los conjuntos grandes pueden tardar.", 
    "Reajusta o modelo uma vez por táxon em cópias podadas temporárias. Os dados preparados não mudam. Conjuntos grandes podem demorar."
    ), c("Evaluaciones diagnósticas", "Avaliações diagnósticas"
    ), c("LargeResidual indica residuos absolutos de Pearson mayores que 2; Sparse indica menos de 3 taxones. OneOutcome indica una categoría con solo éxitos o fracasos. Son evaluaciones descriptivas, no pruebas ni exclusiones automáticas; la ausencia de señales no descarta separación.", 
    "LargeResidual indica resíduos absolutos de Pearson acima de 2; Sparse indica menos de 3 táxons. OneOutcome indica uma categoria apenas com sucessos ou fracassos. São avaliações descritivas, não testes nem exclusões automáticas; a ausência de sinais não descarta separação."
    ), c("Influencia de taxones", "Influência dos táxons"), 
    c("La influencia es el mayor cambio absoluto de coeficiente dividido por su error estándar del ajuste completo. Revise los reajustes fallidos y las advertencias. Es un análisis de sensibilidad, no una prueba calibrada ni validación cruzada.", 
    "A influência é a maior mudança absoluta de coeficiente dividida pelo erro padrão do ajuste completo. Revise os reajustes com falhas e os avisos. É uma análise de sensibilidade, não um teste calibrado nem validação cruzada."
    ), c("Se necesitan al menos dos modelos válidos para comparar.", 
    "São necessários pelo menos dois modelos válidos para comparar."
    ), c("Delta AIC (ML)", "Delta AIC (ML)"), c("No hay reajustes diagnósticos válidos.", 
    "Não há reajustes diagnósticos válidos."), c("Índice de taxón (ver tabla)", 
    "Índice do táxon (ver tabela)"), c("Cambio máximo de coeficiente / SE completo", 
    "Mudança máxima do coeficiente / SE completo"), c("Descargar comparación CSV", 
    "Baixar comparação CSV"), c("Descargar comparación PDF", 
    "Baixar comparação PDF"), c("Descargar comparación código R", 
    "Baixar comparação código R"), c("Descargar influencia CSV", 
    "Baixar influência CSV"), c("Descargar influencia PDF", 
    "Baixar influência PDF"), c("Descargar influencia código R", 
    "Baixar influência código R"), c("Rasgo para reconstrucción", 
    "Característica para reconstrução"), c("Marco de inferencia", 
    "Estrutura de inferência"), c("Máxima verosimilitud", "Máxima verossimilhança"
    ), c("Bayesiano / estocástico — previsto", "Bayesiano / estocástico — previsto"
    ), c("Parsimonia — prevista", "Parcimônia — prevista"
    ), c("Movimiento browniano (BM)", "Movimento browniano (BM)"
    ), c("Elija un rasgo numérico original o transformado. La reconstrucción permanece en esa escala; no se aplica una transformación inversa automática.", 
    "Escolha uma característica numérica original ou transformada. A reconstrução permanece nessa escala; não há transformação inversa automática."
    ), c("Ejecutar reconstrucción BM", "Executar reconstrução BM"
    ), c("Mapa del rasgo", "Mapa da característica"), c("Fenograma", 
    "Fenograma"), c("Intervalos de nodos", "Intervalos dos nós"
    ), c("Diagnósticos de contrastes", "Diagnósticos de contrastes"
    ), c("Las estimaciones nodales son reconstrucciones BM de máxima verosimilitud. Los colores de ramas y líneas del fenograma interpolan estimaciones; no son historias evolutivas observadas ni muestreadas.", 
    "As estimativas nodais são reconstruções BM de máxima verossimilhança. As cores dos ramos e linhas do fenograma interpolam estimativas; não são histórias evolutivas observadas nem amostradas."
    ), c("Los intervalos nodales analíticos aproximados del 95% provienen de fastAnc (varianza de Rohlf). No son intervalos creíbles bayesianos ni bandas simultáneas; no incluyen incertidumbre del árbol o del modelo.", 
    "Os intervalos nodais analíticos aproximados de 95% vêm de fastAnc (variância de Rohlf). Não são intervalos de credibilidade bayesianos nem bandas simultâneas; não incluem incerteza da árvore ou do modelo."
    ), c("Descargar estimaciones nodales CSV", "Baixar estimativas nodais CSV"
    ), c("El gráfico Q-Q evalúa contrastes independientes estandarizados bajo BM. No demuestra adecuación del modelo. La tasa de difusión y log-verosimilitud usan ML marginal de datos terminales; los intervalos nodales usan la varianza de fastAnc.", 
    "O gráfico Q-Q avalia contrastes independentes padronizados sob BM. Não comprova adequação do modelo. A taxa de difusão e log-verossimilhança usam ML marginal dos dados terminais; os intervalos nodais usam a variância de fastAnc."
    ), c("Elija un rasgo numérico y ejecute la reconstrucción BM.", 
    "Escolha uma característica numérica e execute a reconstrução BM."
    ), c("Los datos cambiaron. Ejecute la reconstrucción BM para actualizar resultados.", 
    "Os dados mudaram. Execute a reconstrução BM para atualizar os resultados."
    ), c("Este marco está previsto. Solo se ha implementado BM de máxima verosimilitud.", 
    "Esta estrutura está prevista. Apenas BM de máxima verossimilhança está implementado."
    ), c("Reconstrucción BM completada. Revise la incertidumbre y los diagnósticos.", 
    "Reconstrução BM concluída. Revise a incerteza e os diagnósticos."
    ), c("La reconstrucción BM requiere un árbol enraizado y bifurcante.", 
    "A reconstrução BM exige uma árvore enraizada e bifurcante."
    ), c("La reconstrucción BM requiere longitudes de rama finitas y positivas.", 
    "A reconstrução BM exige comprimentos de ramo finitos e positivos."
    ), c("Seleccione columnas distintas de taxón y rasgo numérico.", 
    "Selecione colunas distintas de táxon e característica numérica."
    ), c("Haga coincidir etiquetas únicas de taxones explícitamente en Datos antes de reconstruir; se requieren al menos tres taxones.", 
    "Faça corresponder rótulos únicos de táxons explicitamente em Dados antes da reconstrução; são necessários pelo menos três táxons."
    ), c("La reconstrucción BM necesita un rasgo numérico finito y no constante. No se eliminan filas automáticamente.", 
    "A reconstrução BM precisa de uma característica numérica finita e não constante. Nenhuma linha é removida automaticamente."
    ), c("La reconstrucción BM devolvió estimaciones nodales o incertidumbre no válidas.", 
    "A reconstrução BM retornou estimativas nodais ou incerteza inválidas."
    ), c("La reconstrucción BM devolvió una tasa de difusión no válida.", 
    "A reconstrução BM retornou uma taxa de difusão inválida."
    ), c("Reconstrucción ancestral BM", "Reconstrução ancestral BM"
    ), c("Distancia desde la raíz (unidades de rama)", "Distância da raiz (unidades de ramo)"
    ), c("Intervalos nodales aproximados del 95%", "Intervalos nodais aproximados de 95%"
    ), c("Diagnóstico de contrastes BM", "Diagnóstico de contrastes BM"
    ), c("Contrastes estandarizados", "Contrastes padronizados"
    ), c("Nodo", "Nó"), c("Varianza", "Variância"), c("Nodos internos", 
    "Nós internos"), c("Estimación de la raíz", "Estimativa da raiz"
    ), c("Tasa de difusión BM (ML)", "Taxa de difusão BM (ML)"
    ), c("Log-verosimilitud (ML)", "Log-verossimilhança (ML)"
    ), c("Modelo", "Modelo"), c("ER comparte todas las tasas; SYM comparte tasas inversas; ARD estima cada tasa dirigida.", 
    "ER compartilha todas as taxas; SYM compartilha taxas reversas; ARD estima cada taxa dirigida."
    ), c("Use de 2 a 10 estados observados. Los estados numéricos deben ser enteros. Los caracteres polimórficos tienen su propia tarjeta.", 
    "Use de 2 a 10 estados observados. Estados numéricos devem ser inteiros. Características polimórficas têm seu próprio cartão."
    ), c("Las probabilidades de estados en la raíz son iguales para todos los estados observados.", 
    "As probabilidades dos estados na raiz são iguais para todos os estados observados."
    ), c("Orden de estados", "Ordem dos estados"), c("Iniciar matriz personalizada desde", 
    "Iniciar matriz personalizada a partir de"), c("Llenar matriz personalizada", 
    "Preencher matriz personalizada"), c("Restricciones de tasas personalizadas", 
    "Restrições de taxas personalizadas"), c("Las filas son estados de origen y las columnas de destino, en el orden mostrado. Use 0 para transiciones prohibidas y la diagonal. Enteros positivos iguales comparten una tasa; use índices consecutivos desde 1. Introduzca filas separadas por comas, sin encabezados.", 
    "As linhas são estados de origem e as colunas de destino, na ordem exibida. Use 0 para transições proibidas e na diagonal. Inteiros positivos iguais compartilham uma taxa; use índices consecutivos a partir de 1. Insira linhas separadas por vírgulas, sem cabeçalhos."
    ), c("Límite superior de tasa", "Limite superior da taxa"
    ), c("Comparar con ER, SYM y ARD", "Comparar com ER, SYM e ARD"
    ), c("Ejecutar reconstrucción Mk", "Executar reconstrução Mk"
    ), c("Árbol con probabilidades nodales", "Árvore com probabilidades nodais"
    ), c("Diagrama de tasas de transición", "Diagrama de taxas de transição"
    ), c("Probabilidades marginales de estados", "Probabilidades marginais dos estados"
    ), c("Tamaño de círculos nodales", "Tamanho dos gráficos de nós"
    ), c("Los círculos nodales muestran probabilidades marginales condicionadas a las tasas estimadas, el árbol y probabilidades iguales en la raíz. No integran incertidumbre de parámetros o del árbol y no son historias evolutivas muestreadas.", 
    "Os gráficos dos nós mostram probabilidades marginais condicionadas às taxas estimadas, à árvore e a probabilidades iguais na raiz. Não integram incerteza dos parâmetros ou da árvore e não são histórias evolutivas amostradas."
    ), c("Descargar probabilidades nodales CSV", "Baixar probabilidades nodais CSV"
    ), c("Matriz Q estimada", "Matriz Q estimada"), c("Las filas son estados de origen y las columnas de destino. Las tasas fuera de la diagonal son por unidad de longitud de rama; la diagonal es la suma negativa de cada fila.", 
    "As linhas são estados de origem e as colunas de destino. As taxas fora da diagonal são por unidade de comprimento de ramo; a diagonal é a soma negativa de cada linha."
    ), c("Descargar matriz de tasas CSV", "Baixar matriz de taxas CSV"
    ), c("Se ajustan tres inicios deterministas por modelo. La convergencia no establece identificabilidad ni adecuación del modelo. Las tasas cerca de los límites y óptimos diferentes requieren cautela.", 
    "São ajustados três inícios determinísticos por modelo. Convergência não estabelece identificabilidade nem adequação do modelo. Taxas próximas aos limites e ótimos diferentes exigem cautela."
    ), c("Las comparaciones AIC usan los mismos taxones, rasgo, árbol y probabilidades iguales en la raíz. Los pesos describen solo candidatos distintos convergentes; se omiten restricciones equivalentes. Los candidatos fallidos permanecen visibles. No se promedian modelos.", 
    "As comparações AIC usam os mesmos táxons, característica, árvore e probabilidades iguais na raiz. Os pesos descrevem apenas candidatos distintos convergentes; restrições equivalentes são omitidas. Candidatos falhos permanecem visíveis. Não há média de modelos."
    ), c("Descargar diagnósticos del optimizador CSV", "Baixar diagnósticos do otimizador CSV"
    ), c("Seleccione Comparación de modelos o Inicios del optimizador en Controles del gráfico para ver y exportar gráficos diagnósticos.", 
    "Selecione Comparação de modelos ou Inícios do otimizador em Controles do gráfico para visualizar e exportar gráficos diagnósticos."
    ), c("Elija un rasgo discreto y ejecute la reconstrucción Mk.", 
    "Escolha uma característica discreta e execute a reconstrução Mk."
    ), c("Las restricciones personalizadas son válidas.", "As restrições personalizadas são válidas."
    ), c("Los datos cambiaron. Ejecute la reconstrucción Mk para actualizar resultados.", 
    "Os dados mudaram. Execute a reconstrução Mk para atualizar os resultados."
    ), c("Este marco está previsto. Solo se ha implementado Mk de máxima verosimilitud.", 
    "Esta estrutura está prevista. Apenas Mk de máxima verossimilhança está implementado."
    ), c("Reconstrucción Mk completada. Revise los diagnósticos del optimizador y los supuestos del modelo.", 
    "Reconstrução Mk concluída. Revise os diagnósticos do otimizador e os pressupostos do modelo."
    ), c("Seleccione un rasgo discreto con 2 a 10 estados observados.", 
    "Selecione uma característica discreta com 2 a 10 estados observados."
    ), c("La matriz personalizada debe tener una fila y columna por estado, sin encabezados.", 
    "A matriz personalizada deve ter uma linha e coluna por estado, sem cabeçalhos."
    ), c("La matriz personalizada requiere índices enteros no negativos y una diagonal de ceros.", 
    "A matriz personalizada exige índices inteiros não negativos e diagonal zero."
    ), c("Los nombres de la matriz deben coincidir con el orden de estados mostrado.", 
    "Os nomes da matriz devem corresponder à ordem dos estados exibida."
    ), c("Los índices positivos de tasas deben ser consecutivos: 1, 2, 3, etc.", 
    "Os índices positivos das taxas devem ser consecutivos: 1, 2, 3, etc."
    ), c("Ningún estado ancestral puede alcanzar todos los estados observados con este modelo personalizado.", 
    "Nenhum estado ancestral pode alcançar todos os estados observados com este modelo personalizado."
    ), c("La reconstrucción Mk requiere un árbol enraizado y bifurcante.", 
    "A reconstrução Mk exige uma árvore enraizada e bifurcante."
    ), c("La reconstrucción Mk requiere longitudes de rama finitas y positivas.", 
    "A reconstrução Mk exige comprimentos de ramo finitos e positivos."
    ), c("Seleccione columnas distintas de taxón y rasgo discreto.", 
    "Selecione colunas distintas de táxon e característica discreta."
    ), c("Los estados discretos numéricos deben ser enteros finitos; los valores continuos no se agrupan.", 
    "Os estados discretos numéricos devem ser inteiros finitos; valores contínuos não são agrupados."
    ), c("Use un estado inequívoco por taxón. Aquí no se admiten estados faltantes ni polimórficos.", 
    "Use um estado inequívoco por táxon. Estados ausentes e polimórficos não são aceitos aqui."
    ), c("El límite superior de tasa debe ser finito y mayor que 1e-8.", 
    "O limite superior da taxa deve ser finito e maior que 1e-8."
    ), c("No hay un ajuste finito convergente. Revise los mensajes del optimizador.", 
    "Não há ajuste finito convergente. Revise as mensagens do otimizador."
    ), c("Algunos valores iniciales fallaron. Revise los mensajes del optimizador.", 
    "Alguns valores iniciais falharam. Revise as mensagens do otimizador."
    ), c("Una tasa está cerca de un límite de optimización. Las estimaciones y clasificaciones de modelos pueden ser inestables.", 
    "Uma taxa está próxima de um limite de otimização. Estimativas e classificações de modelos podem ser instáveis."
    ), c("Los valores iniciales alcanzaron verosimilitudes diferentes. Se muestra la mayor verosimilitud convergente; no se garantiza un óptimo global.", 
    "Os valores iniciais alcançaram verossimilhanças diferentes. A maior verossimilhança convergente é exibida; não há garantia de ótimo global."
    ), c("Hay muchos parámetros de tasa respecto a los taxones. Interprete este ajuste con cautela.", 
    "Há muitos parâmetros de taxa em relação aos táxons. Interprete este ajuste com cautela."
    ), c("Algunos estados tienen menos de tres taxones observados.", 
    "Alguns estados têm menos de três táxons observados."), 
    c("Probabilidades marginales no válidas o verosimilitud de reconstrucción inconsistente.", 
    "Probabilidades marginais inválidas ou verossimilhança de reconstrução inconsistente."
    ), c("Reconstrucción ancestral Mk", "Reconstrução ancestral Mk"
    ), c("Tasas de transición por unidad de longitud de rama", 
    "Taxas de transição por unidade de comprimento de ramo"
    ), c("Convergente", "Convergente"), c("Fallido", "Falhou"
    ), c("Inicio", "Início"), c("Convergencia", "Convergência"
    ), c("Válido", "Válido"), c("Estado", "Situação"), c("Delta_AIC", 
    "Delta_AIC"), c("LogLik", "LogLik"), c("Equivalente", "Equivalente"
    ), c("Los modelos equivalentes comparten una entrada de comparación.", 
    "Modelos equivalentes compartilham uma entrada de comparação."
    ), c("nodos tienen un estado con mayor apoyo cuya probabilidad es al menos 0.90. Es apoyo condicional, no certeza.", 
    "nós têm um estado de maior suporte com probabilidade de pelo menos 0.90. É suporte condicional, não certeza."
    ), c("Mapeo estocástico (tasas estimadas fijas)", "Mapeamento estocástico (taxas estimadas fixas)"
    ), c("Muestreo bayesiano de tasas — previsto", "Amostragem bayesiana de taxas — prevista"
    ), c("Número de historias", "Número de histórias"), c("Semilla del mapeo", 
    "Semente do mapeamento"), c("Historia para visualizar", "História para visualizar"
    ), c("Las historias están condicionadas a la matriz Q estimada, los estados terminales, el árbol y probabilidades iguales en la raíz. No se muestrean tasas ni árboles. No hay descarte inicial MCMC.", 
    "As histórias são condicionadas à matriz Q estimada, aos estados terminais, à árvore e a probabilidades iguais na raiz. Taxas e árvores não são amostradas. Não há descarte inicial MCMC."
    ), c("Los rangos de simulación describen el 95% central de las historias muestreadas, no intervalos de confianza de la media ni incertidumbre de las tasas estimadas. MCSE mide la precisión Monte Carlo; muestras pequeñas y cero eventos muestreados pueden ser engañosos.", 
    "Os intervalos de simulação descrevem os 95% centrais das histórias amostradas, não intervalos de confiança da média nem incerteza das taxas estimadas. MCSE mede a precisão Monte Carlo; amostras pequenas e zero eventos amostrados podem ser enganosos."
    ), c("Conteos de transiciones", "Contagens de transições"
    ), c("Ocupación de estados", "Ocupação dos estados"), 
    c("Descargar resumen de transiciones CSV", "Baixar resumo de transições CSV"
    ), c("Descargar ocupación de estados CSV", "Baixar ocupação dos estados CSV"
    ), c("Descargar frecuencias nodales muestreadas CSV", "Baixar frequências nodais amostradas CSV"
    ), c("Descargar historias y resúmenes RDS", "Baixar histórias e resumos RDS"
    ), c("Concordancia Monte Carlo", "Concordância Monte Carlo"
    ), c("Compare frecuencias nodales muestreadas con probabilidades marginales analíticas. Las diferencias deberían disminuir con más historias independientes; este gráfico no es una prueba de convergencia MCMC ni de adecuación del modelo.", 
    "Compare frequências nodais amostradas com probabilidades marginais analíticas. As diferenças devem diminuir com mais histórias independentes; este gráfico não é um teste de convergência MCMC nem de adequação do modelo."
    ), c("Elija un número entero de historias entre 2 y 500.", 
    "Escolha um número inteiro de histórias entre 2 e 500."
    ), c("Elija una semilla entera entre 0 y 2147483646.", "Escolha uma semente inteira entre 0 e 2147483646."
    ), c("El mapeo requiere una matriz Q estimada válida con el orden de estados mostrado.", 
    "O mapeamento exige uma matriz Q estimada válida na ordem de estados exibida."
    ), c("La carga de mapeo solicitada es demasiado grande. Reduzca el número de historias.", 
    "A carga de mapeamento solicitada é muito grande. Reduza o número de histórias."
    ), c("El mapeo no devolvió el número solicitado de historias.", 
    "O mapeamento não retornou o número solicitado de histórias."
    ), c("Una historia muestreada no coincide con el modelo estimado o los taxones.", 
    "Uma história amostrada não corresponde ao modelo estimado ou aos táxons."
    ), c("Una historia muestreada tiene segmentos de rama no válidos.", 
    "Uma história amostrada tem segmentos de ramo inválidos."
    ), c("Una historia muestreada contiene una transición prohibida.", 
    "Uma história amostrada contém uma transição proibida."
    ), c("Una historia muestreada es inconsistente en nodos o estados terminales.", 
    "Uma história amostrada é inconsistente nos nós ou estados terminais."
    ), c("Ejecute el mapeo estocástico antes de visualizar resúmenes de historias.", 
    "Execute o mapeamento estocástico antes de visualizar resumos de histórias."
    ), c("Elija un número de historia guardada dentro del rango simulado.", 
    "Escolha um número de história salva dentro do intervalo simulado."
    ), c("Frecuencias nodales muestreadas", "Frequências nodais amostradas"
    ), c("Historia estocástica condicional", "História estocástica condicional"
    ), c("Transiciones por historia", "Transições por história"
    ), c("Longitud total de ramas en el estado", "Comprimento total de ramos no estado"
    ), c("Media y rango central del 95% de simulación", "Média e intervalo central de 95% da simulação"
    ), c("Probabilidad marginal analítica", "Probabilidade marginal analítica"
    ), c("Frecuencia muestreada de estado nodal", "Frequência amostrada do estado nodal"
    ), c("Este marco está previsto. Elija ML o mapeo estocástico con tasas fijas.", 
    "Esta estrutura está prevista. Escolha ML ou mapeamento estocástico com taxas fixas."
    ), c("Simulando historias condicionales", "Simulando histórias condicionais"
    ), c("Mapeo estocástico completado. Revise la precisión de simulación y las advertencias de tasas estimadas.", 
    "Mapeamento estocástico concluído. Revise a precisão da simulação e os avisos das taxas estimadas."
    ), c("Mapeo estocástico condicional completado.", "Mapeamento estocástico condicional concluído."
    ), c("Historias guardadas", "Histórias salvas"), c("Origen", 
    "Origem"), c("Destino", "Destino"), c("Media", "Média"), 
    c("DE", "DP"), c("MCSE", "MCSE"), c("Frecuencia", "Frequência"
    ), c("Analítica", "Analítica"), c("Diferencia", "Diferença"
    ), c("Ejecutar mapeo estocástico", "Executar mapeamento estocástico"
    ), c("Reconstrucción ancestral polimórfica", "Reconstrução ancestral polimórfica"
    ), c("Codifique estados coexistentes con +, como A+B. No se admiten estados faltantes, ambiguos ni vacíos.", 
    "Codifique estados coexistentes com +, como A+B. Estados ausentes, ambíguos ou vazios não são aceitos."
    ), c("Use dos o tres estados constituyentes y al menos un taxón polimórfico.", 
    "Use dois ou três estados constituintes e pelo menos um táxon polimórfico."
    ), c("Use nombres de estado únicos sin espacios alrededor en cada combinación.", 
    "Use nomes de estado únicos sem espaços ao redor em cada combinação."
    ), c("Modelo polimórfico desconocido.", "Modelo polimórfico desconhecido."
    ), c("Modelo no ordenado: las transiciones añaden o pierden un estado constituyente. Se incluyen todas las combinaciones, incluso no observadas. No se permiten sustituciones monomórficas directas.", 
    "Modelo não ordenado: as transições adicionam ou perdem um estado constituinte. Todas as combinações são incluídas, mesmo não observadas. Substituições monomórficas diretas são proibidas."
    ), c("ER comparte tasas permitidas; SYM iguala tasas inversas; ARD separa direcciones; transient usa una tasa de pérdida y una de ganancia.", 
    "ER compartilha taxas permitidas; SYM iguala taxas reversas; ARD separa direções; transient usa uma taxa de perda e uma de ganho."
    ), c("Las probabilidades iguales en la raíz se aplican a estados combinados, no a estados constituyentes. A+B representa coexistencia, no codificación incierta.", 
    "As probabilidades iguais na raiz se aplicam a estados combinados, não a estados constituintes. A+B representa coexistência, não codificação incerta."
    ), c("Comparar modelos polimórficos", "Comparar modelos polimórficos"
    ), c("Ejecutar reconstrucción polimórfica", "Executar reconstrução polimórfica"
    ), c("Auditoría de codificación", "Auditoria da codificação"
    ), c("El orden de las combinaciones se estandariza para el ajuste; los datos originales no cambian.", 
    "A ordem das combinações é padronizada para o ajuste; os dados originais permanecem inalterados."
    ), c("Descargar auditoría de codificación CSV", "Baixar auditoria da codificação CSV"
    ), c("Restricciones de tasas", "Restrições de taxas"), 
    c("Las comparaciones usan los mismos taxones, el espacio completo de estados y probabilidades iguales en la raíz. Los pesos AIC incluyen solo candidatos convergentes; no se promedian modelos.", 
    "As comparações usam os mesmos táxons, o espaço completo de estados e probabilidades iguais na raiz. Os pesos AIC incluem apenas candidatos convergentes; não há média de modelos."
    ), c("Elija un rasgo polimórfico y ejecute la reconstrucción.", 
    "Escolha uma característica polimórfica e execute a reconstrução."
    ), c("Los datos cambiaron. Ejecute la reconstrucción polimórfica para actualizar resultados.", 
    "Os dados mudaram. Execute a reconstrução polimórfica para atualizar os resultados."
    ), c("Este marco está previsto. Solo se implementó máxima verosimilitud polimórfica.", 
    "Esta estrutura está prevista. Apenas máxima verossimilhança polimórfica está implementada."
    ), c("Reconstrucción polimórfica completada. Revise la codificación, las restricciones y los diagnósticos.", 
    "Reconstrução polimórfica concluída. Revise a codificação, as restrições e os diagnósticos."
    ), c("Reconstrucción polimórfica completada. La codificación está registrada en la auditoría del análisis; los datos fuente no cambian.", 
    "Reconstrução polimórfica concluída. A codificação está registrada na auditoria da análise; os dados originais permanecem inalterados."
    ), c("Original", "Original"), c("Canónico", "Canônico"), 
    c("Polimorfismo ordenado", "Polimorfismo ordenado"), c("Polimorfismo no ordenado", 
    "Polimorfismo não ordenado"), c("Orden de estados constituyentes (uno por línea)", 
    "Ordem dos estados constituintes (um por linha)"), c("Polimorfismo máximo", 
    "Polimorfismo máximo"), c("Solo se permiten combinaciones contiguas en el orden especificado. El polimorfismo máximo limita el número de estados coexistentes. No se infiere ningún orden automáticamente.", 
    "Apenas combinações contíguas na ordem especificada são permitidas. O polimorfismo máximo limita o número de estados coexistentes. Nenhuma ordem é inferida automaticamente."
    ), c("Vista previa de transiciones", "Prévia das transições"
    ), c("Las filas son estados de origen; las columnas son destinos. Cero prohíbe una transición; índices positivos iguales comparten una tasa. Esta vista previa no ajusta un modelo.", 
    "As linhas são estados de origem; as colunas são destinos. Zero proíbe uma transição; índices positivos iguais compartilham uma taxa. Esta prévia não ajusta um modelo."
    ), c("Las restricciones son válidas. Revise las transiciones permitidas antes de ejecutar.", 
    "As restrições são válidas. Revise as transições permitidas antes de executar."
    ), c("Elija polimorfismo ordenado o no ordenado.", "Escolha polimorfismo ordenado ou não ordenado."
    ), c("El orden debe contener cada estado constituyente exactamente una vez.", 
    "A ordem deve conter cada estado constituinte exatamente uma vez."
    ), c("El polimorfismo máximo debe ser un entero entre 2 y el número de estados constituyentes.", 
    "O polimorfismo máximo deve ser um inteiro entre 2 e o número de estados constituintes."
    ), c("Las combinaciones observadas incumplen el orden o el polimorfismo máximo. Cambie los ajustes del modelo; no se eliminan taxones.", 
    "As combinações observadas violam a ordem ou o polimorfismo máximo. Altere as configurações do modelo; nenhum táxon é removido."
    ), c("Origen de árboles", "Origem das árvores"), c("Árbol de Datos", 
    "Árvore de Dados"), c("Conjunto de árboles cargados", "Conjunto de árvores carregadas"
    ), c("Archivos Newick (uno o más árboles)", "Arquivos Newick (uma ou mais árvores)"
    ), c("Hasta 25 árboles; todos deben pasar la validación. Los árboles cargados permanecen en esta tarjeta.", 
    "Até 25 árvores; todas devem passar pela validação. As árvores carregadas permanecem neste cartão."
    ), c("Incluir rama basal (root.edge)", "Incluir ramo basal (root.edge)"
    ), c("Tolerancia ultramétrica", "Tolerância ultramétrica"
    ), c("Este flujo no acepta árboles no ultramétricos. No se enraíza, poda, resuelve ni recalibra automáticamente.", 
    "Este fluxo não aceita árvores não ultramétricas. Nenhum enraizamento, poda, resolução ou recalibração é automático."
    ), c("La rama basal se omite salvo inclusión explícita. Sin ella, la curva comienza en la raíz de la corona.", 
    "O ramo basal é omitido salvo inclusão explícita. Sem ele, a curva começa na raiz da coroa."
    ), c("Dirección temporal", "Direção temporal"), c("Desde el origen", 
    "Desde a origem"), c("Antes del presente", "Antes do presente"
    ), c("Tiempo antes del presente (unidades de longitud de rama)", 
    "Tempo antes do presente (unidades de comprimento de ramo)"
    ), c("Tiempo desde el origen (unidades de longitud de rama)", 
    "Tempo desde a origem (unidades de comprimento de ramo)"), 
    c("Punto y guion", "Ponto e traço"), c("Guiones largos", 
    "Traços longos"), c("Guiones dobles", "Traços duplos"), 
    c("Ancho (pulgadas)", "Largura (polegadas)"), c("Altura (pulgadas)", 
    "Altura (polegadas)"), c("Las superposiciones son curvas individuales, no bandas de confianza. Compare árboles solo con unidades y muestreo compatibles.", 
    "As sobreposições são curvas individuais, não faixas de confiança. Compare árvores apenas com unidades e amostragem compatíveis."
    ), c("Coordenadas LTT (primeras 100 filas)", "Coordenadas LTT (primeiras 100 linhas)"
    ), c("Elija árboles y ejecute LTT.", "Escolha árvores e execute LTT."
    ), c("Las entradas cambiaron. Ejecute LTT para actualizar los resultados.", 
    "As entradas mudaram. Execute LTT para atualizar os resultados."
    ), c("Cargue primero árboles Newick.", "Carregue primeiro árvores Newick."
    ), c("LTT completado. Revise las edades de los árboles y los supuestos de muestreo.", 
    "LTT concluído. Revise as idades das árvores e os pressupostos de amostragem."
    ), c("Árboles enraizados ultramétricos validados; no se modificaron taxones ni ramas.", 
    "Árvores enraizadas ultramétricas validadas; nenhum táxon ou ramo foi alterado."
    ), c("Terminales", "Terminais"), c("Edad_corona", "Idade_coroa"
    ), c("Rama_basal", "Ramo_basal"), c("Rango_profundidad_terminal", 
    "Amplitude_profundidade_terminal"), c("Eventos", "Eventos"
    ), c("LTT requiere al menos dos terminales con nombres únicos.", 
    "LTT exige pelo menos dois terminais com nomes únicos."), 
    c("Estructura del árbol no válida para LTT.", "Estrutura da árvore inválida para LTT."
    ), c("LTT requiere un árbol explícitamente enraizado.", 
    "LTT exige uma árvore explicitamente enraizada."), c("LTT requiere longitudes de rama finitas y positivas.", 
    "LTT exige comprimentos de ramo finitos e positivos."), c("La tolerancia LTT debe ser positiva y como máximo 0.001.", 
    "A tolerância LTT deve ser positiva e no máximo 0.001."
    ), c("LTT requiere un árbol ultramétrico; calíbrelo antes del análisis.", 
    "LTT exige uma árvore ultramétrica; calibre-a antes da análise."
    ), c("Ajuste de rama basal no válido.", "Configuração do ramo basal inválida."
    ), c("La longitud basal debe ser finita y no negativa.", 
    "O comprimento basal deve ser finito e não negativo."), 
    c("Elija entre uno y 25 árboles para LTT.", "Escolha entre uma e 25 árvores para LTT."
    ), c("No se encontraron árboles en el archivo Newick.", 
    "Nenhuma árvore encontrada no arquivo Newick."), c("Ajustes del gráfico LTT no válidos.", 
    "Configurações do gráfico LTT inválidas."), c("Modelos", 
    "Modelos"), c("Nacimiento-muerte", "Nascimento-morte"), c("Fracción de muestreo aleatorio de especies actuales", 
    "Fração de amostragem aleatória de espécies atuais"), 
    c("Condicionar a la supervivencia de la corona y la división de la raíz", 
    "Condicionar à sobrevivência da coroa e à divisão da raiz"
    ), c("El muestreo supone la inclusión aleatoria e independiente de especies actuales. No se modela el muestreo no aleatorio o diversificado.", 
    "A amostragem pressupõe inclusão aleatória e independente de espécies atuais. A amostragem não aleatória ou diversificada não é modelada."
    ), c("Verosimilitud del árbol corona; se excluyen las ramas basales suministradas. Sin condicionamiento al número de terminales. Ambos modelos usan el mismo muestreo y condicionamiento.", 
    "Verossimilhança da árvore coroa; ramos basais fornecidos são excluídos. Sem condicionamento ao número de terminais. Ambos os modelos usam a mesma amostragem e condicionamento."
    ), c("Optimizador", "Otimizador"), c("Máximo de iteraciones", 
    "Máximo de iterações"), c("Límite superior de tasa (vacío = 100 / edad corona)", 
    "Limite superior da taxa (vazio = 100 / idade da coroa)"), 
    c("lambda inicial (vacío = calculado)", "lambda inicial (vazio = calculado)"
    ), c("mu inicial (vacío = lambda / 2)", "mu inicial (vazio = lambda / 2)"
    ), c("Se prueban varios inicios deterministas. La extinción puede superar la especiación; no se impone diversificación neta positiva.", 
    "São testados vários inícios determinísticos. A extinção pode superar a especiação; não se exige diversificação líquida positiva."
    ), c("Calcular intervalos aproximados por curvatura", "Calcular intervalos aproximados por curvatura"
    ), c("Guardar cortes de verosimilitud", "Salvar cortes de verossimilhança"
    ), c("Ejecutar modelos de diversificación", "Executar modelos de diversificação"
    ), c("Estimaciones de tasas", "Estimativas de taxas"), c("Corte de verosimilitud", 
    "Corte de verossimilhança"), c("lambda es especiación, mu es extinción y net es lambda menos mu. Las tasas son por unidad de longitud de rama, no automáticamente por millón de años.", 
    "lambda é especiação, mu é extinção e net é lambda menos mu. As taxas são por unidade de comprimento de ramo, não automaticamente por milhão de anos."
    ), c("Los intervalos normales aproximados del 95% se basan en la curvatura de la verosimilitud. NA indica que no están disponibles: tasas fijas, estimaciones en límites, curvatura inestable o límites negativos de tasas. Excluyen la incertidumbre del muestreo y del árbol.", 
    "Os intervalos normais aproximados de 95% se baseiam na curvatura da verossimilhança. NA indica indisponibilidade: taxas fixas, estimativas nos limites, curvatura instável ou limites negativos de taxas. Excluem a incerteza da amostragem e da árvore."
    ), c("Los pesos AIC comparan solo los modelos seleccionados con la misma base de verosimilitud. No se muestran si falla un candidato. Los ajustes en límites y las estimaciones de extinción requieren cautela; no se informa un valor p de razón de verosimilitudes.", 
    "Os pesos AIC comparam apenas os modelos selecionados na mesma base de verossimilhança. Não são exibidos se um candidato falhar. Ajustes nos limites e estimativas de extinção exigem cautela; não se informa valor p de razão de verossimilhanças."
    ), c("Los cortes mantienen fija la otra tasa. Muestran la curvatura local, pero no son perfiles de verosimilitud ni intervalos de confianza. Seleccione Corte de verosimilitud en Controles del gráfico para verlos y exportarlos.", 
    "Os cortes mantêm a outra taxa fixa. Mostram a curvatura local, mas não são perfis de verossimilhança nem intervalos de confiança. Selecione Corte de verossimilhança em Controles do gráfico para visualizar e exportar."
    ), c("Descargar cortes de verosimilitud CSV", "Baixar cortes de verossimilhança CSV"
    ), c("Las tasas requieren un árbol binario, enraizado y ultramétrico con al menos cuatro terminales.", 
    "As taxas exigem uma árvore binária, enraizada e ultramétrica com pelo menos quatro terminais."
    ), c("Elija Yule, nacimiento-muerte o ambos modelos.", "Escolha Yule, nascimento-morte ou ambos os modelos."
    ), c("La fracción de muestreo debe ser mayor que cero y como máximo uno.", 
    "A fração de amostragem deve ser maior que zero e no máximo um."
    ), c("Ajustes del análisis de tasas no válidos.", "Configurações da análise de taxas inválidas."
    ), c("Ajustes del optimizador no válidos.", "Configurações do otimizador inválidas."
    ), c("El límite superior de tasa debe ser positivo y compatible con la escala del árbol.", 
    "O limite superior da taxa deve ser positivo e compatível com a escala da árvore."
    ), c("Las tasas iniciales deben estar dentro de los límites seleccionados.", 
    "As taxas iniciais devem estar dentro dos limites selecionados."
    ), c("Un modelo no convergió; no se muestran los pesos de comparación.", 
    "Um modelo não convergiu; os pesos de comparação não são exibidos."
    ), c("Una tasa está en un límite de optimización. No se muestran intervalos; revise los límites y la identificabilidad de la extinción.", 
    "Uma taxa está em um limite de otimização. Os intervalos não são exibidos; revise os limites e a identificabilidade da extinção."
    ), c("Algunos inicios del optimizador fallaron; revise la tabla completa.", 
    "Alguns inícios do otimizador falharam; revise a tabela completa."
    ), c("Los inicios alcanzaron diferentes verosimilitudes; no se garantiza un óptimo global.", 
    "Os inícios atingiram diferentes verossimilhanças; não se garante um ótimo global."
    ), c("La curvatura de la verosimilitud es inestable; los intervalos aproximados no están disponibles.", 
    "A curvatura da verossimilhança é instável; os intervalos aproximados estão indisponíveis."
    ), c("No hay un ajuste válido. Cambie los ajustes y ejecute de nuevo.", 
    "Nenhum ajuste válido. Altere as configurações e execute novamente."
    ), c("Se excluyó la rama basal; este análisis usa una verosimilitud del árbol corona.", 
    "O ramo basal foi excluído; esta análise usa uma verossimilhança da árvore coroa."
    ), c("Se requieren al menos dos ajustes compatibles y convergentes para comparar.", 
    "São necessários pelo menos dois ajustes compatíveis e convergentes para comparar."
    ), c("Comparación de modelos de tasa constante", "Comparação de modelos de taxa constante"
    ), c("No hay un corte de verosimilitud guardado para esta selección.", 
    "Não há corte de verossimilhança salvo para esta seleção."
    ), c("por unidad de longitud de rama", "por unidade de comprimento de ramo"
    ), c("Corte de verosimilitud: otra tasa fija", "Corte de verossimilhança: outra taxa fixa"
    ), c("Tasas por unidad de longitud de rama", "Taxas por unidade de comprimento de ramo"
    ), c("Estimaciones de tasa constante", "Estimativas de taxa constante"
    ), c("Elija los ajustes y ejecute los modelos de diversificación.", 
    "Escolha as configurações e execute os modelos de diversificação."
    ), c("Las entradas cambiaron. Ejecute los modelos de diversificación para actualizar los resultados.", 
    "As entradas mudaram. Execute os modelos de diversificação para atualizar os resultados."
    ), c("Ajustando modelos de diversificación", "Ajustando modelos de diversificação"
    ), c("Análisis de tasas completado. Revise la convergencia, los límites y la incertidumbre.", 
    "Análise de taxas concluída. Revise a convergência, os limites e a incerteza."
    ), c("Análisis de diversificación de tasa constante completado.", 
    "Análise de diversificação de taxa constante concluída."
    ), c("Parámetros", "Parâmetros"), c("Mensaje", "Mensagem"
    ), c("Peso", "Peso"), c("Barras: intervalos aproximados del 95% por curvatura cuando están disponibles", 
    "Barras: intervalos aproximados de 95% por curvatura quando disponíveis"
    ), c("La clasificación requiere dos candidatos convergentes. Revise las estimaciones individuales y los diagnósticos.", 
    "A classificação exige dois candidatos convergentes. Revise as estimativas individuais e os diagnósticos."
    ), c("Menor AIC entre los modelos seleccionados:", "Menor AIC entre os modelos selecionados:"
    ), c("La diferencia de AIC es pequeña; estos datos no distinguen claramente los modelos seleccionados.", 
    "A diferença de AIC é pequena; estes dados não distinguem claramente os modelos selecionados."
    ), c("El apoyo relativo de AIC no establece que el modelo seleccionado describa adecuadamente los datos.", 
    "O suporte relativo de AIC não estabelece que o modelo selecionado descreva adequadamente os dados."
    ), c("Incertidumbre y diagnósticos del modelo", "Incerteza e diagnósticos do modelo"
    ), c("Calcular perfiles de verosimilitud", "Calcular perfis de verossimilhança"
    ), c("Nivel de referencia del perfil", "Nível de referência do perfil"
    ), c("Simular curvas LTT condicionales", "Simular curvas LTT condicionais"
    ), c("Réplicas de simulación", "Réplicas de simulação"
    ), c("Semilla de simulación", "Semente de simulação"), 
    c("Ejecutar incertidumbre y diagnósticos", "Executar incerteza e diagnósticos"
    ), c("Ejecute primero los modelos. Los ajustes de diagnóstico borran solo los diagnósticos; vuelva a ejecutarlos después de cambiarlos.", 
    "Execute os modelos primeiro. As configurações de diagnóstico apagam apenas os diagnósticos; execute-os novamente após alterá-las."
    ), c("Verificación LTT condicional", "Verificação LTT condicional"
    ), c("Referencia de discrepancia condicional", "Referência de discrepância condicional"
    ), c("Los perfiles reoptimizan la otra tasa dentro de los límites del ajuste. La referencia chi-cuadrado es aproximada; la cobertura en fronteras no está calibrada. Los límites de búsqueda no son límites de confianza infinitos. Nuisance_bound indica dependencia del límite superior de tasa.", 
    "Os perfis reotimizam a outra taxa dentro dos limites do ajuste. A referência qui-quadrado é aproximada; a cobertura nas fronteiras não é calibrada. Limites de busca não são limites de confiança infinitos. Nuisance_bound indica dependência do limite superior da taxa."
    ), c("Descargar intervalos de perfil CSV", "Baixar intervalos de perfil CSV"
    ), c("Descargar curvas de perfil CSV", "Baixar curvas de perfil CSV"
    ), c("Verificación de simulación condicional", "Verificação de simulação condicional"
    ), c("Las simulaciones fijan las tasas estimadas, la fracción de muestreo aleatorio, la edad corona y el número de terminales muestreados. Evalúan el patrón de tiempos de ramificación, no el tamaño o la edad del árbol. La envolvente del 95% es puntual, no simultánea, y excluye la incertidumbre de parámetros y del árbol.", 
    "As simulações fixam as taxas estimadas, a fração de amostragem aleatória, a idade da coroa e o número de terminais amostrados. Avaliam o padrão dos tempos de ramificação, não o tamanho ou a idade da árvore. O envelope de 95% é pontual, não simultâneo, e exclui a incerteza dos parâmetros e da árvore."
    ), c("La fracción de cola de referencia compara una discrepancia de la distribución de tiempos de ramificación con simulaciones a tasas estimadas. Es descriptiva, no un valor p calibrado; no se reajustan tasas por réplica. Seleccione un gráfico de diagnóstico en Resultados para verlo y exportarlo.", 
    "A fração de cauda de referência compara uma discrepância da distribuição dos tempos de ramificação com simulações nas taxas estimadas. É descritiva, não um valor p calibrado; as taxas não são reajustadas por réplica. Selecione um gráfico de diagnóstico em Resultados para visualizar e exportar."
    ), c("Descargar envolvente de simulación CSV", "Baixar envelope de simulação CSV"
    ), c("Descargar tiempos de ramificación simulados CSV", 
    "Baixar tempos de ramificação simulados CSV"), c("Ajustes de perfil no válidos.", 
    "Configurações de perfil inválidas."), c("Cruce del umbral", 
    "Cruzamento do limiar"), c("Frontera física", "Fronteira física"
    ), c("Fallo numérico del perfil u óptimo mejor", "Falha numérica do perfil ou ótimo melhor"
    ), c("Soporte desconectado; revise el perfil", "Suporte desconectado; revise o perfil"
    ), c("Parámetros de simulación no válidos.", "Parâmetros de simulação inválidos."
    ), c("Tiempos de simulación no válidos.", "Tempos de simulação inválidos."
    ), c("Probabilidades de simulación no válidas.", "Probabilidades de simulação inválidas."
    ), c("Fallo numérico de simulación.", "Falha numérica da simulação."
    ), c("Ajustes de simulación no válidos.", "Configurações de simulação inválidas."
    ), c("Ajustes de diagnóstico no válidos.", "Configurações de diagnóstico inválidas."
    ), c("Ejecute primero los diagnósticos de perfil.", "Execute primeiro os diagnósticos de perfil."
    ), c("No hay perfil para un parámetro fijo o fallido.", 
    "Não há perfil para um parâmetro fixo ou com falha."), 
    c("Perfil de verosimilitud: otra tasa reoptimizada", "Perfil de verossimilhança: outra taxa reotimizada"
    ), c("La cobertura en fronteras no está calibrada.", "A cobertura nas fronteiras não é calibrada."
    ), c("Ejecute primero los diagnósticos de simulación.", 
    "Execute primeiro os diagnósticos de simulação."), c("No hay simulaciones para este modelo.", 
    "Não há simulações para este modelo."), c("Tiempo desde la corona (unidades de longitud de rama)", 
    "Tempo desde a coroa (unidades de comprimento de ramo)"), 
    c("Mediana de simulación", "Mediana da simulação"), c("Envolvente puntual del 95% de simulación", 
    "Envelope pontual de 95% da simulação"), c("Ejecutando incertidumbre y diagnósticos de simulación", 
    "Executando incerteza e diagnósticos de simulação"), c("Diagnósticos completados. Revise los límites del perfil y los supuestos de simulación.", 
    "Diagnósticos concluídos. Revise os limites do perfil e os pressupostos da simulação."
    ), c("Estado_inferior", "Estado_inferior"), c("Estado_superior", 
    "Estado_superior"), c("Límite_otra_tasa", "Limite_outra_taxa"
    ), c("Simulaciones", "Simulações"), c("D_observado", "D_observado"
    ), c("Fracción_cola_referencia", "Fração_cauda_referência"
    ), c("Observado", "Observado"), c("Demasiados tiempos de ramificación simulados; reduzca las réplicas.", 
    "Tempos de ramificação simulados em excesso; reduza as réplicas."
    ), c("Una tasa está en un límite de optimización. No se muestran intervalos por curvatura; revise los límites y la identificabilidad de la extinción.", 
    "Uma taxa está em um limite de otimização. Os intervalos por curvatura não são exibidos; revise os limites e a identificabilidade da extinção."
    ), c("Modelos variables en el tiempo", "Modelos variáveis no tempo"
    ), c("Candidatos para comparación temporal", "Candidatos para comparação temporal"
    ), c("ExpYule: especiación exponencial, extinción cero. ExpBD: especiación exponencial, extinción constante. lambda(t) = lambda0 * exp(-beta * t), con t medido hacia el pasado desde el presente. beta positivo indica especiación creciente hacia el presente.", 
    "ExpYule: especiação exponencial, extinção zero. ExpBD: especiação exponencial, extinção constante. lambda(t) = lambda0 * exp(-beta * t), com t medido para o passado a partir do presente. beta positivo indica especiação crescente em direção ao presente."
    ), c("beta inicial (por unidad de longitud de rama)", "beta inicial (por unidade de comprimento de ramo)"
    ), c("Límite absoluto de beta por edad corona", "Limite absoluto de beta vezes idade da coroa"
    ), c("Solucionador ODE", "Solucionador ODE"), c("Usa el muestreo, condicionamiento, optimizador y tasas iniciales anteriores. El límite superior restringe la especiación actual y la extinción constante; la especiación ancestral puede superarlo. Todos los candidatos usan la misma verosimilitud ODE.", 
    "Usa a amostragem, o condicionamento, o otimizador e as taxas iniciais acima. O limite superior restringe a especiação atual e a extinção constante; a especiação ancestral pode superá-lo. Todos os candidatos usam a mesma verossimilhança ODE."
    ), c("Ejecutar comparación temporal", "Executar comparação temporal"
    ), c("Tasas a través del tiempo", "Taxas ao longo do tempo"
    ), c("Comparación de modelos temporales", "Comparação de modelos temporais"
    ), c("Resultados de modelos temporales", "Resultados de modelos temporais"
    ), c("Las trayectorias temporales son estimaciones ajustadas sin bandas de incertidumbre. Los perfiles y simulaciones de tasa constante no se aplican a los ajustes variables. Los pesos AIC describen este conjunto de candidatos, no la adecuación del modelo.", 
    "As trajetórias temporais são estimativas ajustadas sem faixas de incerteza. Perfis e simulações de taxa constante não se aplicam aos ajustes variáveis. Os pesos AIC descrevem este conjunto de candidatos, não a adequação do modelo."
    ), c("Descargar comparación temporal CSV", "Baixar comparação temporal CSV"
    ), c("Descargar trayectorias de tasas CSV", "Baixar trajetórias de taxas CSV"
    ), c("Diagnósticos de modelos temporales", "Diagnósticos de modelos temporais"
    ), c("Tolerance_delta compara la verosimilitud guardada con una tolerancia ODE diez veces más estricta. No se muestran pesos si supera 0.0001 o falla. Revise todos los inicios y límites.", 
    "Tolerance_delta compara a verossimilhança salva com uma tolerância ODE dez vezes mais estrita. Os pesos não são exibidos se superar 0.0001 ou falhar. Revise todos os inícios e limites."
    ), c("Descargar optimizador temporal CSV", "Baixar otimizador temporal CSV"
    ), c("Seleccione modelos válidos para la comparación temporal.", 
    "Selecione modelos válidos para a comparação temporal."
    ), c("beta inicial debe estar dentro del límite positivo escalado de beta (máximo 10).", 
    "beta inicial deve estar dentro do limite positivo escalado de beta (máximo 10)."
    ), c("Ajustes del solucionador ODE no válidos.", "Configurações do solucionador ODE inválidas."
    ), c("Un modelo temporal falló; no se muestran pesos de comparación.", 
    "Um modelo temporal falhou; os pesos de comparação não são exibidos."
    ), c("Se detectó sensibilidad a la tolerancia ODE; no se muestran pesos.", 
    "Sensibilidade à tolerância ODE detectada; os pesos não são exibidos."
    ), c("Un parámetro temporal se acerca a un límite de búsqueda; reajuste con límites revisados.", 
    "Um parâmetro temporal se aproxima de um limite de busca; reajuste com limites revisados."
    ), c("Algunos inicios temporales fallaron. Revise los diagnósticos del optimizador.", 
    "Alguns inícios temporais falharam. Revise os diagnósticos do otimizador."
    ), c("Los inicios temporales alcanzaron óptimos diferentes.", 
    "Os inícios temporais atingiram ótimos diferentes."), c("Se requieren ajustes compatibles, convergentes y numéricamente estables.", 
    "São necessários ajustes compatíveis, convergentes e numericamente estáveis."
    ), c("Parámetro del gráfico no válido.", "Parâmetro do gráfico inválido."
    ), c("Tasas ajustadas a través del tiempo", "Taxas ajustadas ao longo do tempo"
    ), c("Trayectorias ajustadas; no se estiman bandas de incertidumbre.", 
    "Trajetórias ajustadas; faixas de incerteza não são estimadas."
    ), c("Ajustando modelos variables en el tiempo", "Ajustando modelos variáveis no tempo"
    ), c("Análisis temporal completado. Revise diagnósticos y límites.", 
    "Análise temporal concluída. Revise diagnósticos e limites."
    ), c("Los ajustes temporales cambiaron. Ejecute de nuevo la comparación temporal.", 
    "As configurações temporais mudaram. Execute novamente a comparação temporal."
    ), c("Menor AIC entre candidatos temporales:", "Menor AIC entre candidatos temporais:"
    ), c("Incertidumbre y robustez del modelo temporal", "Incerteza e robustez do modelo temporal"
    ), c("Modelo temporal para diagnosticar", "Modelo temporal para diagnosticar"
    ), c("Perfiles del modelo temporal", "Perfis do modelo temporal"
    ), c("Puntos de malla del perfil temporal", "Pontos da grade do perfil temporal"
    ), c("Bootstrap paramétrico condicional", "Bootstrap paramétrico condicional"
    ), c("Réplicas bootstrap", "Réplicas bootstrap"), c("Verificar inicios, límites y tolerancia", 
    "Verificar inícios, limites e tolerância"), c("Multiplicador de límites para robustez", 
    "Multiplicador de limites para robustez"), c("Ejecutar incertidumbre del modelo temporal", 
    "Executar incerteza do modelo temporal"), c("Perfil de verosimilitud temporal", 
    "Perfil de verossimilhança temporal"), c("Reajustes bootstrap condicionales", 
    "Reajustes bootstrap condicionais"), c("Robustez del modelo temporal", 
    "Robustez do modelo temporal"), c("Los perfiles temporales reoptimizan los parámetros restantes dentro de los límites guardados. Los límites de búsqueda y avisos de parámetros en límites no son intervalos infinitos. La cobertura de referencia es aproximada, especialmente en fronteras.", 
    "Os perfis temporais reotimizam os demais parâmetros dentro dos limites salvos. Os limites de busca e avisos de parâmetros nos limites não são intervalos infinitos. A cobertura de referência é aproximada, especialmente nas fronteiras."
    ), c("Descargar intervalos de perfil temporal CSV", "Baixar intervalos de perfil temporal CSV"
    ), c("Descargar curvas de perfil temporal CSV", "Baixar curvas de perfil temporal CSV"
    ), c("Los reajustes bootstrap fijan la edad corona, el número de terminales muestreados y la fracción de muestreo. La envolvente puntual del 95% resume reajustes condicionales exitosos, no cobertura de confianza calibrada ni incertidumbre de selección de modelos. Se requieren al menos 20 reajustes exitosos y 90% de éxito. Revise fallos y frecuencia de límites.", 
    "Os reajustes bootstrap fixam a idade da coroa, o número de terminais amostrados e a fração de amostragem. O envelope pontual de 95% resume reajustes condicionais bem-sucedidos, não cobertura de confiança calibrada nem incerteza de seleção de modelos. São necessários pelo menos 20 reajustes bem-sucedidos e 90% de sucesso. Revise falhas e frequência de limites."
    ), c("Descargar reajustes bootstrap CSV", "Baixar reajustes bootstrap CSV"
    ), c("Descargar bandas bootstrap CSV", "Baixar faixas bootstrap CSV"
    ), c("Los reajustes de robustez cambian inicios, amplían límites y reducen la tolerancia ODE por separado. Una mejor verosimilitud exige revisar el ajuste original. Estos escenarios no prueban un óptimo global.", 
    "Os reajustes de robustez alteram inícios, ampliam limites e reduzem a tolerância ODE separadamente. Uma verossimilhança melhor exige revisar o ajuste original. Esses cenários não provam um ótimo global."
    ), c("Seleccione un modelo temporal convergente y numéricamente estable.", 
    "Selecione um modelo temporal convergente e numericamente estável."
    ), c("Parámetros de simulación bootstrap no válidos.", 
    "Parâmetros de simulação bootstrap inválidos."), c("Falló la integración de la distribución bootstrap.", 
    "Falha na integração da distribuição bootstrap."), c("Edades de ramificación bootstrap no válidas.", 
    "Idades de ramificação bootstrap inválidas."), c("Ajustes bootstrap no válidos.", 
    "Configurações bootstrap inválidas."), c("La malla de la distribución bootstrap no es suficientemente precisa.", 
    "A grade da distribuição bootstrap não é suficientemente precisa."
    ), c("El multiplicador debe ser mayor que uno y como máximo cuatro.", 
    "O multiplicador deve ser maior que um e no máximo quatro."
    ), c("Inicios alternativos", "Inícios alternativos"), c("Límites ampliados", 
    "Limites ampliados"), c("Tolerancia más estricta", "Tolerância mais estrita"
    ), c("Ejecute primero la incertidumbre del modelo temporal.", 
    "Execute primeiro a incerteza do modelo temporal."), c("Seleccione lambda, beta o mu con un perfil ajustado.", 
    "Selecione lambda, beta ou mu com um perfil ajustado."), 
    c("Ejecute primero las verificaciones de robustez.", "Execute primeiro as verificações de robustez."
    ), c("Sensibilidad respecto al ajuste guardado", "Sensibilidade em relação ao ajuste salvo"
    ), c("Bandas bootstrap no disponibles; revise fallos de reajuste.", 
    "Faixas bootstrap indisponíveis; revise falhas de reajuste."
    ), c("Seleccione lambda, mu o net para curvas bootstrap.", 
    "Selecione lambda, mu ou net para curvas bootstrap."), c("Ajuste guardado", 
    "Ajuste salvo"), c("Mediana bootstrap", "Mediana bootstrap"
    ), c("Envolvente puntual del 95% de reajustes condicionales; cobertura no calibrada.", 
    "Envelope pontual de 95% dos reajustes condicionais; cobertura não calibrada."
    ), c("Los ajustes de incertidumbre temporal cambiaron. Ejecute de nuevo la incertidumbre temporal.", 
    "As configurações de incerteza temporal mudaram. Execute novamente a incerteza temporal."
    ), c("Calculando incertidumbre del modelo temporal", "Calculando incerteza do modelo temporal"
    ), c("Incertidumbre temporal completada. Revise límites, fallos y robustez.", 
    "Incerteza temporal concluída. Revise limites, falhas e robustez."
    ), c("Reajustes exitosos", "Reajustes bem-sucedidos"), c("Un reajuste de robustez mejoró la verosimilitud; revise el ajuste original antes de interpretar.", 
    "Um reajuste de robustez melhorou a verossimilhança; revise o ajuste original antes de interpretar."
    ), c("Algunos reajustes bootstrap fallaron; los resúmenes condicionan los reajustes exitosos.", 
    "Alguns reajustes bootstrap falharam; os resumos condicionam os reajustes bem-sucedidos."
    ), c("Escenario", "Cenário"), c("Réplica", "Réplica"), 
    c("Éxito", "Sucesso"), c("Tasas a través del tiempo muestra trayectorias ajustadas. Las bandas bootstrap condicionales están disponibles después de Ejecutar incertidumbre del modelo temporal. Los pesos AIC describen el conjunto seleccionado, no la adecuación del modelo.", 
    "Taxas ao longo do tempo mostra trajetórias ajustadas. As faixas bootstrap condicionais estão disponíveis após Executar incerteza do modelo temporal. Os pesos AIC descrevem o conjunto selecionado, não a adequação do modelo."
    ), c("Otro candidato proporciona un punto factible mejor. Vuelva a ajustar antes de interpretar el soporte del modelo.", 
    "Outro candidato fornece um ponto viável melhor. Reajuste antes de interpretar o suporte do modelo."
    ), c("Término", "Termo"), c("Cuantiles teóricos", "Quantis teóricos"
    ), c("Tu árbol aparecerá aquí", "Sua árvore aparecerá aqui"
    ), c("Carga un árbol o comienza con los datos de ejemplo", 
    "Carregue uma árvore ou comece com os dados de exemplo"), 
    c("No hay observaciones numéricas finitas", "Não há observações numéricas finitas"
    ), c("La densidad requiere observaciones variables", "A densidade requer observações variáveis"
    ), c("Tiempo desde la raíz (unidades de longitud de rama)", 
    "Tempo desde a raiz (unidades de comprimento de ramo)"), 
    c("Linajes", "Linhagens"), c("Prueba de normalidad de Shapiro-Wilk", 
    "Teste de normalidade de Shapiro-Wilk"), c("La normalidad del rasgo no establece la normalidad de los residuos del modelo.", 
    "A normalidade da característica não estabelece a normalidade dos resíduos do modelo."
    ), c("Predictor", "Preditor"), c("Referencia", "Referência"
    ), c("Índice", "Índice"), c("Taxón", "Táxon"), c("Los ajustes de diagnóstico cambiaron. Ejecute de nuevo la incertidumbre y los diagnósticos.", 
    "As configurações de diagnóstico mudaram. Execute novamente a incerteza e os diagnósticos."
    ), c("Nivel_referencia", "Nível_referência"), c("Análisis en ejecución en segundo plano. Puede seguir explorando otros resultados.", 
    "Análise em execução em segundo plano. Você pode continuar explorando outros resultados."
    ), c("Ya hay un análisis en ejecución. Espere a que termine.", 
    "Já há uma análise em execução. Aguarde até que termine."
    ), c("El análisis superó el límite de tiempo del servidor. Reduzca su tamaño o ejecute localmente el script de R exportado.", 
    "A análise excedeu o limite de tempo do servidor. Reduza seu tamanho ou execute localmente o script de R exportado."
    ), c("El proceso del análisis se detuvo inesperadamente, posiblemente por falta de memoria. Reduzca el tamaño del análisis y ejecútelo de nuevo.", 
    "O processo da análise parou inesperadamente, possivelmente por falta de memória. Reduza o tamanho da análise e execute-a novamente."
    ), c("Análisis cancelado.", "Análise cancelada."), c("Los modelos dependientes de la diversidad en este servidor admiten como máximo 4998 especies, incluidas las especies faltantes.", 
    "Os modelos dependentes da diversidade neste servidor aceitam no máximo 4998 espécies, incluindo as espécies ausentes."
    ), c("El servicio de análisis en segundo plano no está disponible temporalmente. Inténtelo de nuevo en un momento.", 
    "O serviço de análise em segundo plano está temporariamente indisponível. Tente novamente em instantes."
    ), c("Este árbol supera el número máximo de puntas admitido en este servidor. Ejecute localmente el script de R exportado para árboles más grandes.", 
    "Esta árvore excede o número máximo de pontas suportado neste servidor. Execute localmente o script de R exportado para árvores maiores."
    ), c("Esta tabla de rasgos supera el tamaño máximo admitido en este servidor.", 
    "Esta tabela de características excede o tamanho máximo suportado neste servidor."
    ), c("Elija valores enteros de mapeo dentro del intervalo permitido.", 
    "Escolha valores inteiros de mapeamento dentro do intervalo permitido."
    ), c("Los modelos dependientes de la diversidad requieren DDD 5.2.5 o posterior. Actualice DDD y ejecute de nuevo.", 
    "Os modelos dependentes da diversidade exigem DDD 5.2.5 ou posterior. Atualize o DDD e execute novamente."
    ), c("La correlación de Pagel requiere phytools 2.5-2 o posterior. Actualice phytools y ejecute de nuevo.", 
    "A correlação de Pagel exige phytools 2.5-2 ou posterior. Atualize o phytools e execute novamente."
    )), names = c("MuSSE support is exploratory: unmodeled rate heterogeneity can mimic trait dependence. Multistate hidden-state null models are not implemented; the hidden-state card supports binary traits only.", 
"Rate point estimates; profile intervals are shown separately.", 
"Rates condition on one tree, observed states, sampling fractions and root treatment. Optional profile intervals require verified fits; calibrated likelihood-ratio tests are not provided.", 
"Refined", "Wider", "FailedStarts", "Independent optimizer verification", 
"Fitted", "Verification", "NativeIterations", "Crossing", "Failed profile segment", 
"Search limit reached", "Fit requires review", "Run a profile analysis first.", 
"Run robustness refits first.", "No comparable robustness refit; inspect diagnostics.", 
"Resolve failed fits before robustness refits.", "No finite optimizer results to display.", 
"Invalid optimizer verification settings.", "Optimizer capture requires the validated hisse version 2.1.11.", 
"HiSSE optimizer capture failed; no verified status is available.", 
"AIC weights require compatible, verified, repeatable interior fits. They do not establish causality.", 
"Verify with an independent optimizer", "Maximum optimizer evaluations", 
"Optimizer status is retained. Weights require converged repeatable interior fits and agreement with an independent optimizer.", 
"Model weights withheld: inspect termination, verification, starts, boundaries and duplicate constraints.", 
"Model weights describe only the compatible verified candidate set; they do not establish causality.", 
"Independent optimizer verification failed or disagreed. Weights and intervals are withheld.", 
"Inspect termination and independent optimizer agreement in Diagnostics", 
"Bounded subplex retains its log-rate lower bound of -20. Evaluation limits are editable. Long runs are synchronous.", 
"Profile uncertainty", "Choose the model and parameter in Graph controls, then set the profile search bounds.", 
"Profile lower search bound", "Profile upper search bound", "Profile grid points", 
"Profile confidence level", "Run profile uncertainty", "Profile likelihood", 
"Download profile CSV", "Download interval CSV", "Resolve fit diagnostics before calculating profile intervals.", 
"Select an estimated parameter group for profiling.", "Profile bounds must enclose the estimate within its fitted bounds.", 
"Profile intervals use an approximate chi-square reference conditional on the tree and model. Failed segments and search limits have no interval endpoint.", 
"Approximate profile intervals; inspect failed segments and search limits", 
"A profile found a better likelihood. Refit before interpretation.", 
"Optional profile intervals require verified fits; calibrated likelihood-ratio tests are not provided.", 
"Robustness refits", "Domain widening factor", "Run grid and domain refits", 
"Grid and domain refits", "Download robustness CSV", "Change in aligned log likelihood", 
"Robustness refits preserve original estimates. Unresolved grid or domain sensitivity withholds weights; no uncertainty interval is implied.", 
"Robustness requires nx at most 2048 and a widened domain multiplier at most 30.", 
"Verified", "VerificationStatus", "VerificationLogLik", "VerificationMessage", 
"OptimizerMessage", "Evaluations", "Repeatable", "LowerStatus", 
"UpperStatus", "Level", "Comparable", "AlignedLogLik", "Change", 
"State 0", "Sampling fraction: state 0", "Sampling fraction: state 1", 
"BiSSE support is exploratory. Use the Hidden-state and null models card to refit compatible binary candidates.", 
"Run hidden-state models", "Extinction-fraction constraints", 
"Shared", "By diversification class", "Zero extinction", "Root conditioning", 
"Root weights", "Likelihood", "Given", "Given probability of observed state 0", 
"Given root weights divide each observed-state probability equally among hidden classes. All candidates share observed coding, sampling and root settings.", 
"Custom model constraints", "Hidden classes in Custom", "Turnover indices (comma-separated)", 
"Extinction-fraction indices (comma-separated)", "Fill custom constraints", 
"Transition indices (CSV, no header)", "Custom only: order 0A,1A,0B,1B, then 0C,1C,0D,1D for four classes. Consecutive positive indices share parameters. Zero fixes extinction fractions or transitions to zero. Simultaneous observed and hidden changes are forbidden.", 
"CID models tie diversification across observed states within each hidden class. Hidden classes are not observed or assigned to tips.", 
"Use simulated annealing", "Annealing objective calls", "Relative optimizer tolerance", 
"Starting turnover", "Starting extinction fraction", "Starting transition rate", 
"Turnover upper bound", "Extinction-fraction upper bound", "Transition upper bound", 
"ODE rejection threshold", "Bounded native subplex uses up to 100000 evaluations and a log-rate lower bound of -20. These backend limits are not editable here. Long runs are synchronous.", 
"HiSSE does not expose optimizer termination status. Finite fits are not confirmed convergence; automatic model weights are withheld.", 
"Turnover = lambda + mu; extinction fraction = mu / lambda. Hidden-state labels can exchange between fits. Rates use branch-length units.", 
"Compare only models refitted in this card with the same data and likelihood settings. Do not combine AIC values from other cards.", 
"Select a binary trait and run hidden-state models.", "Hidden-state inputs changed. Run again to update results.", 
"Fitting Hidden-state models", "Hidden-state fitting finished. Review finite fits, starts and backend limitations.", 
"No finite hidden-state fit. Inspect diagnostics.", "Hidden-state analysis completed.", 
"AIC differences are provisional. Optimizer termination status is unavailable; no model weights are reported.", 
"Install the hisse R package to run hidden-state models.", "Invalid hidden-state model settings.", 
"Invalid parameter index vector.", "Use consecutive parameter indices; zero is allowed only for extinction fractions.", 
"Invalid hidden-state transition matrix.", "Only single observed-state or hidden-class changes are supported; use zero elsewhere.", 
"Transition indices must be consecutive positive integers; zero forbids a transition.", 
"Select supported hidden-state models.", "Invalid hidden-state sampling or root settings.", 
"Invalid hidden-state optimizer settings.", "Starts must be positive and below finite upper bounds.", 
"Hidden classes are latent rate categories, not identified biological traits. No uncertainty intervals or calibrated likelihood-ratio tests are provided.", 
"A hidden-state parameter reached a bound. Inspect identifiability and bounds.", 
"Hidden-state starts disagree. Increase search effort before interpreting model differences.", 
"HiSSE fits worse than its CID-2 submodel. Increase search effort before interpretation.", 
"Select a supported hidden-state graph.", "Finite likelihoods; optimizer termination status is unavailable", 
"Hidden categories are not identified biological traits", "Destination state", 
"Source state", "Turnover", "ExtinctionFraction", "Speciation", 
"Extinction", "NetDiversification", "Finite", "Tied QuaSSE rates have incompatible fixed values or bounds.", 
"A QuaSSE rate reached a bound. Inspect bounds and identifiability before interpretation.", 
"QuaSSE likelihood changed under tighter integration tolerance. Ranking weights are withheld.", 
"QuaSSE starts disagree or an unconverged attempt is better. Refit before interpreting model support.", 
"Invalid QuaSSE graph settings.", "Non-finite QuaSSE likelihood.", 
"Run QuaSSE", "Measurement-error column", "Common standard error", 
"Common measurement standard error", "Supply standard errors of trait means in trait units. The common value is used only when no error column is selected; zero and missing errors are unsupported.", 
"Speciation function", "Extinction function", "Compare with constant rates", 
"Constant", "Exponential", "Sigmoid", "Selected", "Constant: c. Exponential: base * exp(slope * x). Sigmoid: y0 + (y1-y0) * plogis(r * (x-xmid)). Drift is fixed at zero by default; edit Fixed to estimate it.", 
"Sampling fraction", "Flat (ROOT.FLAT)", "Normal density (ROOT.GIVEN)", 
"Given root mean", "Given root standard deviation", "Given root settings apply only to ROOT.GIVEN. ROOT.OBS is likelihood-based; ROOT.FLAT is uniform on the numerical domain. Root settings are shared across candidates.", 
"QuaSSE parameter table (CSV)", "Columns: Parameter,Group,Fixed,Start,Lower,Upper. Equal groups tie parameters; numeric Fixed fixes the group. Signed slopes, midpoints and drift are allowed; diffusion must be positive. Clear the table after changing rate functions.", 
"Numerical integration controls", "FFT backend", "Trait grid bins", 
"Tip resolution multiplier", "Maximum time step / tree depth", 
"Resolution switch / tree depth", "Trait range multiplier", "Grid midpoint (blank = observed midpoint)", 
"Convolution width (standard deviations)", "Integrate tips together (fftC only)", 
"Every fit is checked with twice the grid bins and half the time step. Unstable likelihoods suppress model weights. Increase resolution and refit when diagnostics fail.", 
"Rates versus trait", "Traits and measurement errors", "Rates use branch-length units; drift uses trait units per branch-length unit and diffusion uses squared trait units per branch-length unit. Curves cover the observed trait range only.", 
"Select a continuous trait and run QuaSSE.", "QuaSSE inputs changed. Run again to update results.", 
"Fitting QuaSSE models", "QuaSSE completed. Review convergence and grid sensitivity.", 
"No valid QuaSSE fit. Inspect diagnostics.", "QuaSSE analysis completed.", 
"QuaSSE ranking weights are unavailable. Inspect individual fits and diagnostics.", 
"Select supported QuaSSE rate functions.", "QuaSSE requires a resolved binary tree with at least four tips.", 
"Select separate taxon and continuous-trait columns.", "Match tree and trait taxa explicitly in Data before QuaSSE.", 
"QuaSSE requires finite, nonconstant continuous observations.", 
"Select a valid measurement-error column.", "QuaSSE measurement standard errors must be positive and finite.", 
"Invalid QuaSSE integration settings.", "The QuaSSE grid must contain all observed trait values.", 
"Invalid QuaSSE parameter table.", "QuaSSE starts, fixed parameters and bounds are inconsistent.", 
"Invalid QuaSSE sampling or root settings.", "QuaSSE backend parameter order is incompatible.", 
"Invalid QuaSSE optimizer settings.", "QuaSSE is exploratory: hidden rate heterogeneity can mimic trait dependence. No uncertainty intervals or hidden-state null models are provided.", 
"Measurement errors are standard errors of trait means, in the supplied trait units. They are treated as known.", 
"Grid and time-step sensitivity checks evaluate fitted parameters without refitting. They do not guarantee numerical convergence.", 
"The tip grid is coarser than a measurement standard error. Increase resolution; model weights are withheld.", 
"Select a supported QuaSSE graph.", "Observed traits and measurement standard errors", 
"Bars show plus/minus one measurement standard error, not confidence intervals.", 
"QuaSSE likelihood changed after grid-normalized refinement. Model weights are withheld.", 
"Refined likelihoods account for the backend grid-spacing constant under survival conditioning. Raw refined values and the adjustment are shown separately; compare AIC only within this run.", 
"RawRefinedLogLik", "GridNormalizationAdjustment", "Download estimates CSV", 
"MuSSE parameter table (CSV)", "Run MuSSE", "MuSSE support is exploratory: unmodeled rate heterogeneity can mimic trait dependence. Hidden-state null models are not yet implemented.", 
"MuSSE inputs changed. Run again to update results.", "Fitting MuSSE models", 
"MuSSE completed. Review convergence, bounds and model assumptions.", 
"No valid MuSSE fit. Inspect diagnostics.", "MuSSE analysis completed.", 
"MuSSE ranking weights are unavailable. Inspect individual fits and diagnostics.", 
"MuSSE requires a resolved binary tree with at least four tips.", 
"Match tree and trait taxa explicitly in Data before MuSSE.", 
"Invalid MuSSE parameter table.", "MuSSE starts and fixed rates must respect finite nonnegative bounds.", 
"Select supported MuSSE models.", "Tied MuSSE rates have incompatible fixed values or bounds.", 
"Invalid MuSSE likelihood settings.", "Invalid MuSSE optimizer settings.", 
"Invalid MuSSE integration settings.", "A MuSSE rate reached a bound. Inspect bounds and identifiability before interpretation.", 
"MuSSE likelihood changed under tighter integration tolerance. Ranking weights are withheld.", 
"MuSSE starts disagree or an unconverged attempt is better. Refit before interpreting model support.", 
"Invalid MuSSE graph settings.", "MuSSE transition rates", "Discrete trait", 
"Fill state table", "MuSSE state table (CSV)", "Columns: State,Sampling,RootWeight. Every observed state must occur once. Row order defines codes 1 to k. Blank uses sorted observed states, complete sampling and equal root weights. RootWeight is used only with ROOT.GIVEN.", 
"MuSSE treats each label as one categorical state, not as polymorphism or uncertainty. Two to eight observed states are supported.", 
"The default comparison shares one transition rate across states. Full and other constraints remain selectable.", 
"Equilibrium-root weighting is unavailable in the installed multistate backend.", 
"Columns: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda1 through lambdak, mu1 through muk, and qij for directed transitions (source i, destination j). Blank uses tree-scaled defaults. Group and Fixed apply only to Custom; preset models use their own constraints. Shared Group values tie rates; a numeric Fixed value fixes the whole group.", 
"lambdai is speciation, mui is extinction, and qij is the transition from state i to j. Rates are per branch-length unit.", 
"Equal diversification and transitions", "Symmetric transitions", 
"MuSSE supports two to eight observed states.", "Select a discrete trait for MuSSE.", 
"Select a discrete trait and run MuSSE.", "MuSSE requires nonmissing finite categorical observations.", 
"Invalid MuSSE state table.", "The MuSSE state table must list each observed state exactly once.", 
"MuSSE sampling fractions must be greater than zero and at most one.", 
"Select separate taxon and discrete-trait columns.", "MuSSE supports observed, equal or given root weights; equilibrium roots are unavailable.", 
"MuSSE backend parameter order is incompatible.", "Few taxa or imbalanced states can give weakly identified rates. This is a screening warning, not a sufficiency threshold.", 
"A candidate has at least as many free rates as observed tips. Interpretability is severely limited.", 
"Destination state code", "Source state code", "Sampling", "RootWeight", 
"Non-finite MuSSE likelihood.", "The full MuSSE model fits worse than a constrained candidate. Increase starts or refine bounds.", 
"Non-finite BiSSE likelihood.", "ROOT.OBS uses likelihood-based root weights, not tip frequencies. Root treatment is shared by all candidates.", 
"The full BiSSE model fits worse than a constrained candidate. Increase starts or refine bounds.", 
"Lower", "Upper", "Hidden-state and null models", "This SSE method is planned and has no implemented engine.", 
"Full", "Equal speciation", "Equal extinction", "Equal transitions", 
"Trait-independent diversification", "No extinction", "Custom", 
"Binary trait", "Observed value coded as state 0", "The other observed value is coded as state 1. Resolve taxon mismatches in Data.", 
"Sampling fraction for state 0", "Sampling fraction for state 1", 
"Sampling assumes random inclusion within each state; fractions are treated as known.", 
"Root treatment", "Observed (ROOT.OBS)", "Equal (ROOT.FLAT)", 
"Equilibrium (ROOT.EQUI)", "Given (ROOT.GIVEN)", "Root probability for state 0", 
"Fill parameter table", "BiSSE parameter table (CSV)", "Columns: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda0, lambda1, mu0, mu1, q01, q10. Blank uses tree-scaled defaults. Group and Fixed apply only to Custom; preset models use their own constraints. Shared Group values tie rates; a numeric Fixed value fixes the whole group.", 
"Optimizer starts", "ODE backend", "ODE tolerance", "Integration retry threshold (eps)", 
"Run BiSSE", "BiSSE support is exploratory: unmodeled rate heterogeneity can mimic trait dependence. Hidden-state null models are not yet implemented.", 
"Observed tip states", "Transition rates", "Figure width (inches)", 
"Figure height (inches)", "lambda is speciation, mu is extinction, q01 and q10 are directional transitions. Rates are per branch-length unit.", 
"AIC compares candidates in this run only. Weights require converged, numerically stable fits with agreement across successful starts. Boundary fits still require caution. No causal conclusion follows from AIC support.", 
"Rates condition on one tree, observed states, sampling fractions and root treatment. No confidence intervals or calibrated likelihood-ratio tests are provided.", 
"Likelihood slices hold other free rates fixed and respect tied parameters. They are not confidence intervals or nuisance-refitted profiles.", 
"Effective parameter constraints", "Select a binary trait and run BiSSE.", 
"BiSSE inputs changed. Run again to update results.", "Fitting BiSSE models", 
"BiSSE completed. Review convergence, bounds and model assumptions.", 
"No valid BiSSE fit. Inspect diagnostics.", "BiSSE analysis completed.", 
"BiSSE ranking weights are unavailable. Inspect individual fits and diagnostics.", 
"BiSSE requires a resolved binary tree with at least four tips.", 
"Select a taxon column and a binary trait.", "Match tree and trait taxa explicitly in Data before BiSSE.", 
"BiSSE requires two observed states, no missing values and an explicit state 0.", 
"Invalid BiSSE parameter table.", "BiSSE starts and fixed rates must respect finite nonnegative bounds.", 
"Select supported BiSSE models.", "No extinction requires lower bounds of zero for mu.", 
"Tied BiSSE rates have incompatible fixed values or bounds.", 
"Both state sampling fractions must be greater than zero and at most one.", 
"Root probabilities must be nonnegative and sum to one.", "Invalid BiSSE likelihood settings.", 
"Invalid BiSSE optimizer settings.", "Invalid BiSSE integration settings.", 
"Few taxa or an imbalanced binary trait can give weakly identified rates. This is a screening warning, not a sufficiency threshold.", 
"A BiSSE rate reached a bound. Inspect bounds and identifiability before interpretation.", 
"BiSSE likelihood changed under tighter integration tolerance. Ranking weights are withheld.", 
"BiSSE starts disagree or an unconverged attempt is better. Refit before interpreting model support.", 
"A likelihood slice found a better point. Refit before interpreting model support.", 
"Invalid BiSSE graph settings.", "Observed tip states; no ancestral reconstruction", 
"Optimizer start", "Failed convergence", "Rate per branch-length unit", 
"Point estimates only; uncertainty intervals are not available", 
"BiSSE transition rates", "No likelihood slice for this parameter.", 
"Likelihood slice: other free rates fixed", "Code", "State", 
"Count", "Group", "Fixed", "TighterLogLik", "AbsoluteDifference", 
"StartSpread", "FailedEvaluations", "Stable", "Initial", "Final", 
"Numerical instability: refine the fit before interpreting intervals.", 
"Numerical instability", "Uncertainty model", "Profile parameter", 
"Profile lower search limit", "Profile upper search limit", "Reference level", 
"Refit from multiple starts", "Start multipliers", "Parametric bootstrap", 
"Seconds per bootstrap replicate", "Run uncertainty and robustness", 
"Run uncertainty and robustness first.", "Bootstrap distribution", 
"Bootstrap parameter", "Download bootstrap intervals CSV", "Failed profile point", 
"Grid-interpolated crossing", "Better likelihood found", "Better likelihood found. Refit before interpreting uncertainty.", 
"Bootstrap intervals require at least 20 successful refits and 90% success.", 
"Bootstrap requires complete sampling and crown-survival conditioning (cond = 1).", 
"Finite estimates are required for uncertainty analysis.", "Select an estimated parameter for profiling.", 
"Profile limits must bracket the saved estimate.", "Insufficient successful bootstrap refits.", 
"Profiles use finite search limits and approximate chi-square reference levels. Bootstrap requires complete sampling and cond = 1; crown age is fixed, simulated tip counts vary. Intervals exclude tree and model-selection uncertainty.", 
"AIC compares selected candidates in this card only. It conditions on the tree and missing-species count. Uncertainty is conditional and approximate.", 
"Run numerical diagnostics before interpreting AIC. Failed stability checks suppress ranking weights.", 
"1: linear lambda", "1.3: linear lambda (K prime)", "2: exponential lambda", 
"3: linear mu", "4: exponential mu", "5: linear lambda + mu", 
"0: age", "1: age + survival", "2: age + extant count", "3: extant count", 
"0: branching times", "1: phylogeny", "Rate curves are invalid over the selected diversity range.", 
"Unsupported numerical method.", "Install DDD to run this analysis.", 
"Select at least one estimated parameter for each model.", "Use positive lambda, K and r and nonnegative mu starting/fixed values and select estimated parameters.", 
"Diversity-dependent models", "Missing extant species", "Estimated parameters", 
"Run diversity-dependent models", "Resolution multiplier", "Run numerical diagnostics", 
"Rate versus diversity", "Observed reconstructed lineages", "Numerical stability", 
"Maximum displayed diversity", "Species diversity", "Likelihood change", 
"Analysis completed.", "Inspect convergence and backend messages.", 
"Invalid numeric settings.", "Invalid model or likelihood settings.", 
"Select a converged model.", "Run numerical diagnostics first.", 
"Compatible converged fits are required for comparison.", "Crown analysis (soc = 2). Missing species are a count, not a sampling fraction. Supplied stems are excluded.", 
"K has a model-specific meaning. Model 1.3 uses diversity at zero speciation; models 1 and 2 use diversity at equal speciation and extinction.", 
"Unchecked parameters use the supplied fixed values. r applies only to model 5. DDD does not expose arbitrary parameter bounds.", 
"Reevaluate saved estimates with larger res and tighter integration tolerances. This is a numerical check, not an uncertainty interval.", 
"Rate curves describe dependence on diversity. The LTT shows observed surviving lineages, not reconstructed total historical diversity.", 
"AIC compares selected candidates in this card only. It conditions on the tree and missing-species count. Confidence intervals are not estimated.", 
"Constant-rate models", "Clade-specific models", "Model and data settings", 
"Advanced fitting controls", "Uncertainty and diagnostics", "Normal intervals cross zero for a nonnegative rate; those intervals are withheld.", 
"Non-finite split likelihood; inspect fixed rates, bounds and lambda = mu.", 
"Joint clade-dependent models", "Joint shift nodes", "Shift placement: branch base (split.t = Inf). Other timings are unsupported by the installed backend. Nested regions are allowed; each region must retain at least two sampled tips.", 
"Joint region sampling (CSV)", "Fill joint region tables", "Use Region,Sampling: background is 0; other region identifiers are shift nodes. Blank means sampling 1 everywhere. Whole-tree and separate-clade sampling controls do not apply.", 
"Joint candidates", "SharedYule fixes extinction to zero. SharedBD shares both rates. ShiftLambda, ShiftMu and ShiftBoth vary the named rates across regions.", 
"Custom joint constraints (CSV)", "Columns: Region,Lambda,Mu. Equal parameter names share a rate; numbers fix rates. Fixed speciation must be positive. Do not reuse a name across speciation and extinction. Used only for Custom.", 
"Joint parameter controls (CSV)", "Optional columns: Parameter,Start,Lower,Upper. Names appear in the constraints table. Unlisted parameters use derived starts and the upper bound above. Free speciation lower bounds must be positive; starts must lie strictly inside bounds.", 
"Joint models use conditioning, optimizer, maximum iterations, upper bound and curvature interval controls above. All candidates share one partitioned whole-tree likelihood. Shift positions and sampling are fixed, not estimated.", 
"Preview joint regions", "Run joint models", "Joint diversification regions", 
"Joint regional rates", "Joint whole-tree model comparison", 
"Joint optimizer agreement", "Joint model to display", "Joint model results", 
"Joint AIC compares these candidates on the same whole-tree likelihood only. It does not include uncertainty in shift selection, sampling or the tree. No calibrated likelihood-ratio p-value is reported.", 
"Download joint comparison CSV", "Download joint estimates CSV", 
"Download joint membership CSV", "Download joint branch regions CSV", 
"Joint model diagnostics", "Intervals are approximate curvature intervals, withheld at bounds or unstable curvature. Joint regions with little information can have weakly identified rates. Inspect all optimizer starts.", 
"Download joint constraints CSV", "Download joint controls CSV", 
"Download joint optimizer CSV", "Download joint sampling CSV", 
"Select joint shift nodes and run models.", "Joint inputs changed. Run joint models to update results.", 
"Joint preview only. Run models to fit rates.", "Fitting joint diversification models", 
"Joint fitting completed. Inspect convergence, boundaries and comparisons.", 
"Joint ranking is unavailable; inspect candidate diagnostics.", 
"Lowest joint AIC:", "Support is conditional on the selected shifts and candidate set.", 
"Choose one to four non-root shift nodes with at least four descendant tips.", 
"This backend supports branch-base shifts only (split.t = Inf).", 
"Each joint region, including the background, must retain at least two sampled tips.", 
"Use Region,Sampling with background 0 and every shift node exactly once; fractions must be in (0,1].", 
"Invalid joint-model CSV table.", "Custom constraints require Region,Lambda,Mu for every region exactly once.", 
"Constraints must be nonnegative fixed rates or parameter names; speciation must be positive.", 
"Do not share a parameter name between speciation and extinction.", 
"Choose at least one supported joint model.", "Parameter controls require Parameter,Start,Lower,Upper with unique free parameter names.", 
"Joint starts must be strictly inside valid parameter bounds; free speciation lower bounds must be positive.", 
"Fixed rates exceed the supported tree scale.", "A joint model failed; comparison weights are withheld.", 
"A joint estimate reaches a parameter bound; curvature intervals are withheld.", 
"Joint likelihood curvature is unstable; intervals are unavailable.", 
"Joint optimizer starts disagree; inspect local optima.", "Some joint optimizer starts failed; inspect all attempts.", 
"Equivalent joint constraints selected; comparison weights are withheld.", 
"Region 0 is background; shifts include the incoming branch.", 
"No valid joint likelihoods.", "Invalid joint graph settings.", 
"Region", "Shift_age", "Parent", "Child", "Length", "Clade-specific diversification", 
"Select non-overlapping internal nodes. Each crown must contain at least four sampled tips. All descendants are retained; ancestral stems are excluded.", 
"Crown nodes", "Preview selected clades", "Clade sampling fractions (CSV)", 
"Fill sampling table", "Columns: Node,Sampling. Blank means complete sampling (1) for each selected clade. Enter the probability of random extant-taxon inclusion within each clade.", 
"Clade fits use Models, conditioning, optimizer, bounds, starts and interval/slice controls above. Blank bounds and starts are derived separately for each crown. The whole-tree sampling fraction is not used.", 
"Calculate clade profiles", "Clade profile reference level", 
"Clade profile grid points", "Run clade models", "Selected crown clades", 
"Clade-specific rate estimates", "Within-clade model comparison", 
"Clade profile likelihood", "Clade likelihood slice", "Saved clade for diagnostics", 
"Show clade tip labels", "Show eligible node numbers", "Clade label size", 
"Clade-specific results", "These are separate crown-clade fits, not a joint rate-shift test. DeltaAIC and weights compare models within each clade only. Do not rank likelihoods or AIC across different clades. Selecting clades after inspecting rates introduces selection bias.", 
"Download clade estimates CSV", "Download within-clade comparison CSV", 
"Download clade membership CSV", "Download clade settings CSV", 
"Download selected crown trees", "Clade diagnostics", "Small clades often provide weak information about extinction. Inspect boundaries, optimizer starts and profile search limits. Intervals condition on the chosen clades, topology, branch lengths and sampling fractions.", 
"Download clade audit CSV", "Download clade optimizer CSV", "Download clade profiles CSV", 
"Download clade profile curves CSV", "Download clade slices CSV", 
"Select crown nodes and run clade models.", "Clade inputs changed. Run clade models to update results.", 
"Preview only. Run clade models to fit the selected crowns.", 
"Fitting selected crown clades", "Clade analysis completed. Review each clade separately.", 
"No valid clade fits. Inspect the clade audit.", "Successful clade-model fits:", 
"Tips outside selected crowns:", "Rate differences are descriptive; no between-clade significance test is performed.", 
"Select one to ten internal nodes with at least four descendant tips each.", 
"Selected clades overlap. Choose non-overlapping crown clades.", 
"Sampling table must contain exactly Node,Sampling, one selected node per row and fractions in (0,1].", 
"Invalid clade graph settings.", "Run clade models and select a saved clade first.", 
"Grey branches are outside selected crowns; stems are excluded.", 
"No saved estimate for this parameter.", "Branch-length units", 
"Successful_models", "Requested_models", "Profile_available", 
"First_tip", "Label", "Parameter", "Bayesian Mk ancestral reconstruction", 
"Posterior mean transition rates per branch-length unit", "Root weights give no support to a state that can reach all observed states.", 
"Root probabilities", "Equal", "Custom named weights", "Bayesian Mk (sample rates)", 
"Saved rate draws per chain", "Fill rate-prior table", "Gamma priors and proposals (CSV)", 
"Root weights: state,weight", "Columns: Parameter, Shape, Rate, ProposalVariance. Use q1, q2, etc. for the displayed constraint indices. Blank uses gamma shape 1, rate 1 and proposal variance 0.1 for every rate.", 
"Empirical prior means from these data", "Empirical mode replaces Shape with fitted rate times Rate. Otherwise priors are prespecified gamma distributions; Rate is the inverse-scale parameter. Chain starts are sampled from these priors.", 
"One history is sampled per retained Q draw. Generations per chain equal burn-in plus saved draws times spacing. The backend does not return burn-in traces, acceptance counts or editable starting rates. Short runs are exploratory.", 
"Equal or named root weights are held fixed. The tree and observed tip states are fixed; rate uncertainty is integrated. No AIC or Bayesian model comparison is performed.", 
"Node pies average conditional marginal probabilities over posterior rate draws. The displayed Q is the posterior mean. History intervals integrate rate and history uncertainty on the fixed tree; MCSE accounts for serial dependence. Inspect rate and node diagnostics.", 
"Diagnostics use retained rate draws: spectral ESS, classic split Rhat and MCSE, not rank-normalized Rhat or tail ESS. Passing thresholds is not proof of convergence. Constant sampled indicators do not establish zero uncertainty.", 
"Download effective rate priors CSV", "Download posterior node diagnostics CSV", 
"Bayesian Mk completed. Inspect rate and node diagnostics before interpretation.", 
"Bayesian Mk rate sampling completed.", "Run Bayesian Mk reconstruction", 
"Posterior node probabilities", "Posterior mean Q", "Posterior stochastic history", 
"Posterior rate intervals", "Posterior mean and equal-tailed 95% interval", 
"Retained MCMC trace (burn-in not saved)", "Rate-prior CSV requires Parameter, Shape, Rate, ProposalVariance and one row for each displayed q index.", 
"Gamma shape, gamma rate and proposal variances must be finite and positive.", 
"Choose 20–2000 saved draws per chain, positive burn-in and spacing, 1–4 chains and a valid seed.", 
"Invalid empirical-prior setting.", "Empirical prior requires finite positive fitted rates; use explicit gamma priors.", 
"Empirical Bayes: gamma prior means were estimated from these same data. This is not a fully prespecified prior analysis.", 
"Sampled rates violate the selected Mk constraints.", "Run Bayesian Mk reconstruction first.", 
"Select a saved posterior parameter.", "SampledFrequency", "Node MCSE and ESS describe SampledFrequency; Probability averages conditional marginals over Q draws.", 
"Download joint assignments CSV", "Joint log likelihood conditional on fitted Q; AIC uses the marginal likelihood.", 
"BM analytic ML (fastAnc)", "Joint ML (anc.ML)", "Bayesian BM", 
"Bayesian BM samples diffusion and ancestral states on a fixed tree. Tip observations are treated as exact; measurement-error settings from ML do not apply.", 
"MCMC generations per chain", "Save every N generations", "Burn-in generations", 
"Chains", "Chain", "MCMC seed", "Chain starting spread", "Only saved draws with generation greater than burn-in are retained. Short runs are exploratory; defaults do not guarantee convergence.", 
"Fill Bayesian parameter table", "Priors, starts and proposals (CSV)", 
"Rows: sig2, then root and internal node numbers. Columns: Parameter, Start, PriorMean, PriorVariance, ProposalVariance. The sig2 prior is exponential: its variance entry must be NA. Node priors are independent normal distributions. Proposal entries are variances, not standard deviations. Blank uses the displayed backend defaults.", 
"Effective Bayesian controls", "Posterior parameter", "MCMC trace", 
"Posterior density", "Generation", "MCMC traces including burn-in", 
"Retained posterior densities", "Equal-tailed 95% credible intervals", 
"Download retained posterior CSV", "Download full chains and settings RDS", 
"Download chain diagnostics CSV", "ESS is the summed per-chain spectral estimate. Classic split-Rhat is not rank-normalized. Values above 1.01, low ESS or stuck chains flag unreliable sampling; passing diagnostics does not prove convergence.", 
"Running ancestral reconstruction", "Retained draws per chain", 
"Invalid Bayesian parameter CSV.", "Provide exactly one Bayesian parameter row for sig2 and every internal node.", 
"Bayesian parameter values must be numeric; diffusion prior variance must be NA.", 
"Invalid Bayesian priors, starts or proposal variances.", "Invalid MCMC settings: generations must be divisible by sampling interval; choose 1–4 chains and a valid seed and burn-in.", 
"Retain at least 20 saved draws per chain after burn-in.", "Chain starting spread must be between 0 and 10.", 
"Requested Bayesian workload is too large; reduce generations, chains or saved draws.", 
"Bayesian BM requires branch lengths above the numerical zero threshold.", 
"The sampler returned invalid or incomplete posterior draws.", 
"One chain cannot assess between-chain convergence; split-Rhat is unavailable.", 
"Split-Rhat exceeds 1.01 or is unavailable. Do not treat this run as converged.", 
"Effective sample size is below 400 or unavailable. Longer or better-tuned chains are needed.", 
"Bayesian BM samples the joint posterior of diffusion and all ancestral states. No ML likelihood or AIC ranking is reported.", 
"Posterior means and equal-tailed 95% credible intervals integrate diffusion and ancestral-state uncertainty under the specified priors; the tree is fixed. Inspect chain diagnostics before interpretation.", 
"Choose a saved Bayesian parameter for this graph.", "Conditional 95% prediction intervals", 
"Set both bounds, or leave both blank for defaults. Shape means alpha for OU and r for EB, in inverse branch-length units.", 
"Use comparable marginal ML", "Known standard-error column", 
"None (zero error)", "Supply standard errors, not variances, on the selected trait scale. Errors are squared once and added only to observed-tip variances; they are not automatically transformed.", 
"Compare BM, OU and EB using marginal ML", "Shape lower bound (blank = default)", 
"Shape upper bound (blank = default)", "OU uses one optimum equal to the root mean. Prediction intervals condition on fitted covariance parameters. Comparison uses the same taxa, trait scale and known errors; other models use their default bounds.", 
"Legacy anc.ML has no OU intervals or enabled measurement error. Use marginal ML for these features.", 
"Marginal model comparison", "Download model comparison CSV", 
"AIC weights describe the candidate set, not certainty that a model is true. Boundary fits require caution. Failed candidates remain visible; weights are withheld if any candidate fails.", 
"fastAnc diagnostics show BM contrasts. Other engines show decorrelated tip residuals using the fitted covariance; these are exploratory, order-dependent checks, not a calibrated model-adequacy test.", 
"Unknown continuous covariance model.", "Select a separate numeric standard-error column.", 
"Standard errors must be finite, nonnegative and on the selected trait scale.", 
"Invalid shape bounds: OU must be nonnegative; scaled bounds must lie within -100 to 100.", 
"The starting shape parameter must lie within its bounds.", "No marginal-likelihood optimization start converged.", 
"Invalid conditional node variance.", "A marginal model parameter is at a search bound; inspect bounds and model identifiability.", 
"Some optimization starts failed; the best converged start is reported.", 
"Marginal Gaussian tip-data ML; same observations and known measurement errors across BM/OU/EB. OU root equals its single optimum.", 
"Approximate 95% conditional prediction intervals include mean-estimation uncertainty; covariance parameters and tree are fixed at their fitted values.", 
"Measurement error and model comparison require Gaussian ML.", 
"Run Gaussian ML with model comparison enabled.", "ShapeLower", 
"ShapeUpper", "Boundary", "DeltaAIC", "AkaikeWeight", "Model diagnostics", 
"Ancestral reconstruction", "Continuous reconstruction requires a rooted, bifurcating tree.", 
"Continuous reconstruction requires finite, positive branch lengths.", 
"Continuous reconstruction needs a finite, nonconstant numeric trait. No rows are removed automatically.", 
"BM engine", "Ornstein–Uhlenbeck (OU)", "Early burst (EB)", 
"Maximum iterations (maxit)", "Positive parameter lower bound (tol; blank = backend default)", 
"Print optimizer trace", "Calculate approximate 95% node intervals", 
"Initial alpha (OU) or r (EB); blank = backend default", "OU provides no node intervals. EB allows increasing as well as decreasing rates. Measurement error is not enabled.", 
"Run continuous reconstruction", "Choose a numeric trait and run continuous reconstruction.", 
"Inputs changed. Run continuous reconstruction to update results.", 
"This framework is planned. Choose maximum likelihood.", "Continuous reconstruction completed. Review uncertainty and diagnostics.", 
"Branch colors and phenogram lines interpolate node estimates; they are not conditional evolutionary trajectories.", 
"Marginal tip-data likelihood; root and diffusion estimated by ML.", 
"Joint tip and ancestral-state density from anc.ML; not comparable to marginal tip-data likelihood. No AIC ranking.", 
"Approximate 95% fastAnc/Rohlf intervals; no tree or model uncertainty.", 
"Approximate 95% Hessian intervals; no tree or model uncertainty.", 
"OU node intervals are unavailable from this engine.", "Node intervals were not requested.", 
"Node estimates; intervals unavailable", "Fitted covariance residual diagnostic", 
"Decorrelated tip residuals", "Diffusion parameter (sig2)", "Log likelihood (engine basis)", 
"Optimizer convergence", "fastAnc diagnostics show BM contrasts. anc.ML diagnostics show decorrelated tip residuals using the fitted covariance; these are exploratory, order-dependent checks, not a calibrated model-adequacy test.", 
"An estimated parameter is at its lower bound; interpret with caution.", 
"The installed anc.ML documentation cautions that the OU implementation has not been thoroughly tested. No OU node intervals are supplied.", 
"The fitted EB rate increases through time (r > 0); the backend does not constrain it to an early burst.", 
"Choose fastAnc for BM or anc.ML for BM, OU or EB.", "Invalid continuous-engine switches.", 
"Maximum iterations must be an integer from 1 to 100000.", "The positive parameter lower bound must be finite and greater than zero.", 
"Use a finite EB rate start or an OU alpha start at or above the lower bound.", 
"Continuous optimization returned invalid estimates or likelihood.", 
"Node uncertainty is invalid; inspect the model or rerun without intervals.", 
"Fan layouts are available for node trees. Colored histories and continuous maps use phylograms.", 
"Colored histories and continuous maps currently require a phylogram layout.", 
"Figure size and appearance", "PNG resolution (dpi)", "Figure proportions apply to the preview, PDF and R exports. DPI applies to PNG only.", 
"Fan", "Label font", "Plain", "Bold", "Italic", "Bold italic", 
"Label offset (tree-height fraction)", "Preserve underscores", 
"Line width", "Line type", "Solid", "Dashed", "Dotted", "Dot dash", 
"Long dash", "Two dash", "Show legend", "Legend text size", "Legend columns (0 = automatic)", 
"Color-bar length (tree-height fraction)", "Color-map grid resolution", 
"Outline colored branches", "Custom colors", "Gradient colors (hex, separated by commas)", 
"Fill colors from palette", "State colors: state,#RRGGBB", "Leave blank to use the selected palette. Custom colors are display settings only.", 
"Node display", "Probability pies", "Most-supported state", "Minimum state support", 
"A cross marks a tie or support below the threshold. Probabilities remain unchanged.", 
"Q diagram settings", "Rate significant digits", "Hide rates below", 
"Show zero-rate arrows", "Show rate text", "Scale arrow widths by rates", 
"Maximum arrow width", "Diagram rotation (degrees)", "Arrow spacing", 
"These controls change the diagram only; Q and model constraints are unchanged.", 
"Inspect saved node", "No highlighted node", "Selected node", 
"Selected state", "Density colors show mean occupancy within each grid segment across saved histories, conditional on Q and the tree. This is a display projection, not a new binary analysis.", 
"Reset graph controls", "Download graph PNG", "Download graph settings and result RDS", 
"Download selected node CSV", "Download density segments CSV", 
"Selected-state density map", "Selected transition distribution", 
"Sampled occupancy", "Selected state versus all others", "Unknown graphical setting.", 
"Graphical numeric setting is outside its allowed range.", "Graphical count settings must be integers.", 
"Invalid graphical switch.", "Invalid graphical choice.", "Colors require one state,color row per allowed state, without a header.", 
"Provide every state once with a six-digit hexadecimal color, such as #2277AA.", 
"Use two to eight six-digit hexadecimal gradient colors.", "Select an internal node from the saved result.", 
"Select a state from saved stochastic histories.", "Density resolution must be an integer from 20 to 500.", 
"Density maps require all saved histories.", "Select two different states for a saved transition distribution.", 
"Probability", "Joint", "Selected Q matrix", "Starting values and effective calls are recorded per model. Convergence does not establish identifiability or model adequacy. Near-boundary rates and different optima require caution.", 
"Histories are conditional on the fitted Q matrix, observed tips, tree and the selected root probabilities. Rates and trees are not sampled. There is no MCMC burn-in.", 
"Node pies show marginal state probabilities conditional on the fitted rates, tree and the selected root probabilities. They do not integrate parameter or tree uncertainty and are not sampled evolutionary histories.", 
"AIC comparisons use the same taxa, trait, tree and the selected root probabilities. Weights describe only distinct converged candidates; equivalent constraints are omitted. Failed candidates remain visible. No model averaging is performed.", 
"Comparisons use the same taxa, complete state space and the selected root probabilities. AIC weights cover converged candidates only; no model averaging is performed.", 
"Advanced analysis controls", "Root probabilities (pi)", "Equal weights", 
"Named custom weights", "Fill equal root weights", "One named row per allowed state; weights are normalized to sum to one.", 
"Estimate rates", "Supply fixed Q", "Fill Q template from constraints", 
"Fixed Q: named CSV matrix", "Rows are sources, columns are destinations. Include headers and negative row-sum diagonals. Turn off comparison.", 
"Optimization settings", "Guane: three deterministic starts", 
"Use backend defaults", "Custom starting rates", "Backend defaults omit q.init, min.q, max.q, logscale and opt.method. Bounds and optimizer controls below apply only to Guane or custom starts.", 
"Lower rate bound (min.q)", "Optimizer (opt.method)", "Optimize log rates (logscale)", 
"Starting rates (q.init)", "Enter one rate or one per positive constraint index, in index order. Turn off comparison.", 
"Reconstruction output", "Global marginal probabilities", "Joint assignments and global marginals", 
"Joint tolerance (tol)", "Joint assignments maximize the simultaneous ancestral configuration. Ties may occur; assignments are not probabilities.", 
"Effective settings preview", "Joint ancestral assignments", 
"Download analysis RDS", "Unknown advanced Mk setting.", "Invalid advanced Mk choice.", 
"Root weights require one state,weight row per allowed state, without a header.", 
"Root weights must name every allowed state once, be finite and nonnegative, and have a positive sum.", 
"Fixed Q requires a named numeric square CSV matrix with all allowed states as row and column headers.", 
"Fixed Q must have nonnegative off-diagonal rates, negative row-sum diagonals and preserve forbidden transitions.", 
"Fixed Q must preserve the selected model rate-sharing constraints.", 
"Joint tolerance must be finite and positive.", "Rate bounds must be positive and finite, with the upper bound greater than the lower bound and 1e-8.", 
"Starting rates must be one number or one per rate index, within the bounds.", 
"Fixed Q: no optimization.", "Invalid joint ancestral reconstruction.", 
"Run joint reconstruction before viewing assignments.", "Turn off model comparison when supplying fixed Q.", 
"Turn off model comparison when supplying custom starting rates.", 
"Root probabilities apply to combined states, not to constituent states. A+B represents coexistence, not uncertain coding.", 
"Phylogenetic signal", "Ancestral state reconstruction", "Diversification", 
"SSE models", "PLANNED", "YOUR RESEARCH WORKSPACE", "PHYLOGENETIC COMPARATIVE METHODS", 
"01 / DATA & PARAMETERS", "Phylogenetic tree", "Trait table · CSV", 
"Load example data", "Taxon column", "Numeric trait", "Random seed", 
"K randomizations", "Use matched taxa", "Prunes unmatched taxa from both inputs. Review diagnostics first.", 
"Run signal analysis", "Reset workspace", "Tree preview", "Trait preview", 
"Signal results", "Live Code Mirror", "Diagnostics & activity", 
"Data structure", "Graphic controls", "02 / TREE APPEARANCE", 
"Tree layout", "Direction", "Use branch lengths", "Show tip labels", 
"Show node numbers", "Label size", "Edge width", "Export tree · PDF", 
"Display settings do not modify your analysis data.", "Export R script", 
"Tree", "Traits", "TREE TIPS", "TRAIT ROWS", "Rooted tree", "Unrooted tree", 
"No tree loaded", "✓ All checks passed. Ready for signal analysis.", 
"Load a phylogenetic tree.", "Load a CSV trait table.", "Load your files or explore the example dataset.", 
"Example loaded: 10 species and one continuous trait.", "Signal analysis completed. Results correspond to the current inputs.", 
"Built for transparent, reproducible evolutionary research.", 
"Local workspace · No data leaves this session", "Phylo traits", 
"Phylogenetic Comparative Methods", "Setting up", "Load single tree", 
"Load traits · CSV", "Seed", "Review mismatches before pruning. Changes are recorded in Diagnosis log.", 
"Reset controls", "Data", "Checking data", "Diagnosis log", "Export diagnosis log", 
"Description / Messages", "Structure", "Table controls", "Preview rows", 
"Export traits", "Export tree", "Pagel's correlation", "Discrete traits", 
"Continuous traits", "Polymorphic traits", "Diversification rates", 
"Character-dependent diversification", "Analysis workspace", 
"Analysis execution is not implemented yet. Prepare and inspect inputs in the Data card.", 
"Inputs come from the Data card. Changing data or analytical settings clears previous results.", 
"Normality of a trait does not establish normality of regression residuals. Inspect model diagnostics after fitting.", 
"Shapiro–Wilk normality test", "Transformation", "Natural log", 
"Quadratic", "Reciprocal", "Create transformed column", "Compute independent contrasts · ape", 
"Contrasts are node-level data, separate from the species table. Contrast regression must be fitted through the origin.", 
"Phylogram", "Cladogram", "Left to right", "Right to left", "Top to bottom", 
"Browse...", "No file selected", "Time", "Action", "Metric", 
"Estimate", "P_value", "Test", "Required:", "Error:", "Warning:", 
"Note:", "Tree loaded.", "Trait table loaded.", "Workspace reset. Load new files or example data.", 
"Run an analysis on validated data to see results.", "Estimating phylogenetic signal", 
"Tree tip labels must be unique.", "Tree contains empty taxon labels.", 
"Signal analysis requires finite, positive branch lengths.", 
"Root the tree before signal analysis.", "Tree contains polytomies; inspect their biological meaning.", 
"Tree is not ultrametric. Signal analysis can use it; verify branch-length units.", 
"Select the taxon column.", "Trait table contains empty taxon labels.", 
"Trait taxon labels must be unique.", "Select a numeric trait.", 
"Selected trait must contain only finite numeric values; correct missing values before running.", 
"Selected trait has no variation.", "At least four matched taxa are required.", 
"Correct nonfinite values first.", "Log requires positive values.", 
"Reciprocal requires nonzero values.", "Transformation produced nonfinite values.", 
"That derived column already exists. Select another source or reset.", 
"Resolve data issues before computing contrasts.", "Independent contrasts require a bifurcating tree.", 
"Correct duplicate or missing taxon labels before matching.", 
"Fewer than four taxa overlap; upload compatible data.", "Choose 99–9999 integer randomizations.", 
"Choose a nonnegative integer seed up to 2147483647.", "Shapiro-Wilk requires 3–5000 finite, nonconstant values.", 
"Pagel's correlation: test two binary traits.", "gls(): Brownian motion, Grafen, Pagel and Blomberg correlation structures.", 
"phylolm / brms: logistic, Poisson and binomial models with multiple predictors.", 
"Lineage through time", "Uses the tree from Data; a trait table is not required.", 
"Run LTT", "Logarithmic lineage axis", "Export LTT table", "Export LTT script", 
"Computed lineage-through-time curve.", "Bifurcating tree", "Ultrametric tree", 
"Not ultrametric", "Tree contains polytomies", "Describes branching through time. Incomplete sampling can bias this pattern; this is not an estimate of speciation or extinction rates.", 
"Analysis controls", "Results", "Diagnostics", "Code will appear when this analysis is implemented.", 
"Data distribution", "Distribution plot", "Histogram", "Density", 
"Normal Q–Q", "Histogram bins", "Show individual observations", 
"Export distribution · PDF", "Column to display", "Undo data change", 
"Restore original inputs", "No data changes to undo.", "Export preparation script", 
"Response", "Predictors", "Correlation structure", "Initial or fixed parameter (rho / lambda / g)", 
"Keep correlation parameter fixed", "Estimation method", "Uses prepared species data. Do not supply PIC values. This version requires an ultrametric tree.", 
"Grafen replaces branch lengths using topology; the uploaded tree remains unchanged.", 
"Run PGLS", "Graph controls", "Graph", "Observed versus fitted", 
"Coefficient intervals", "Residual diagnostics", "Plot color", 
"Guane green", "Legacy cyan", "Grayscale", "Show taxon labels", 
"Download graph PDF", "Download graph R code", "Download coefficients CSV", 
"Intervals are 95% t intervals conditional on the fitted covariance. The dashed diagonal represents perfect agreement, not a regression line.", 
"Each coefficient describes the response change per predictor unit, holding other predictors constant. Association does not establish causation.", 
"Inspect normalized residuals for patterns and Q-Q departures. Trait normality is not residual normality.", 
"The graph R script embeds prepared inputs, refits the model and draws the selected graph. Edit it in RStudio without Guane.", 
"Choose variables and run PGLS.", "Inputs changed. Run PGLS to update results.", 
"PGLS completed. Review residual diagnostics and fit warnings.", 
"No fitting warnings reported. Inspect diagnostics before interpretation.", 
"PGLS requires a rooted, bifurcating tree.", "PGLS requires finite, positive branch lengths.", 
"This PGLS implementation requires an ultrametric tree.", "Select a unique taxon column in the trait table.", 
"Match unique, nonempty taxon labels explicitly in Data before PGLS.", 
"Select a response and distinct numeric predictors.", "PGLS variables must be finite, numeric and nonconstant. No rows are removed automatically.", 
"PGLS needs at least four taxa and at least two residual degrees of freedom.", 
"Use lambda between 0 and 1, or a positive rho or g.", "Predictors are collinear. Choose an independent set of predictors.", 
"PGLS returned an invalid fit; inspect inputs and correlation settings.", 
"Estimated lambda is outside the supported interval [0, 1]. Try a fixed value or another structure.", 
"Fitted values", "Observed values", "Coefficient estimate", "95% coefficient intervals", 
"Normalized residuals", "Pagel's 1994 Discrete Correlation Test", 
"Tests correlated evolution of two binary traits by comparing independent and dependent evolutionary models.", 
"K test draws (including observed)", "The K test uses one observed draw and the remaining randomized draws.", 
"Observed tip values", "Randomized K values", "Observed K", "Palette", 
"Seed:", "K test draws:", "Randomized draws:", "Tip colors represent observed trait values, not reconstructed ancestral states.", 
"K compares trait similarity with Brownian-motion expectations: K = 1 is the reference; larger values indicate greater similarity among relatives. Its randomization test evaluates random assignment of values to tips.", 
"Lambda measures phylogenetic covariance scaling. The likelihood-ratio test compares the fitted lambda with lambda = 0. A small p-value supports phylogenetic signal under this model.", 
"The histogram excludes the observed draw. The dashed line marks observed K. P-values retain the package test convention, which includes the observed draw.", 
"No measurement-error model is fitted. Inspect trait quality and tree assumptions before interpreting the tests.", 
"The R script embeds prepared inputs, repeats the tests and reproduces the selected graph. Edit the plotting settings in RStudio.", 
"Download results CSV", "Signal analysis returned nonfinite estimates. Inspect the inputs.", 
"Binary trait X", "Binary trait Y", "Optimization starts", "Maximum rate per branch-length unit", 
"ARD models: four independent rates versus eight dependent rates. Equal root probabilities for all four joint states.", 
"Run Pagel's correlation", "Evolution model", "Dependent evolution", 
"Independent evolution", "Scale arrows by rate", "Binary state mapping", 
"Model comparison", "Likelihood-ratio test", "A small asymptotic p-value supports dependent evolution under these models; it does not establish causation or a direction of influence.", 
"Compare AIC only for models fitted to the same data and root assumptions. Zero-rate boundaries and sparse states can undermine the chi-squared approximation.", 
"Download transition rates CSV", "Joint state counts", "Optimization attempts", 
"Convergence code 0 is required. Each model retains its highest converged likelihood across the requested starts.", 
"Rates have no uncertainty intervals in this version. Parametric bootstrap and directional models are not implemented.", 
"The script embeds prepared binary inputs, refits both models and reproduces the selected diagram in RStudio.", 
"Select two binary traits and run the test.", "Inputs changed. Run the correlation test to update results.", 
"Fitting Pagel's correlation", "Correlation test completed. Review convergence and state counts.", 
"Pagel requires a rooted, bifurcating tree.", "Pagel requires finite, positive branch lengths.", 
"Select two different binary trait columns.", "Pagel requires at least four taxa with unique, matching labels. Review matching in Data.", 
"Each trait must have exactly two observed, nonmissing states. No automatic binarization or row removal is performed.", 
"Choose one to five optimization starts.", "The maximum transition rate must be positive and finite.", 
"The dependent fit is worse than the nested independent fit. Increase starts or inspect the rate bound.", 
"Some joint states are absent; rates may be poorly identified and the asymptotic test unreliable.", 
"A fitted rate is at or near a boundary. Inspect sensitivity to the rate bound and initial values.", 
"Some optimization attempts failed. Only converged fits were eligible for selection.", 
"Rates per branch-length unit; node codes are XY.", "Trait", 
"State0", "State1", "independent", "dependent", "Binary trait values must be finite and nonmissing.", 
"Example dataset", "Continuous trait", "Synthetic binary traits", 
"Synthetic example loaded: 16 species and two binary traits.", 
"Synthetic example: 20 tree tips and 19 trait rows. Sp20 is intentionally absent from the table.", 
"Synthetic example loaded: 20 tree tips, 19 trait rows. Review the intentional Sp20 mismatch in Checking data.", 
"Trait for signal", "Choose an original or transformed numeric column from Data. PICs are node contrasts and are not used as species traits.", 
"Load a tree and traits in Data. Select two distinct binary columns.", 
"Two binary columns are required. Each must contain exactly two observed states and no missing values.", 
"Two binary traits are available. Resolve taxon mismatches in Data before running.", 
"Run the correlation test on matched data to display results.", 
"Phylogenetic logistic regression", "Bernoulli response with logit link; multiple numeric predictors.", 
"Binary response", "Event state (1)", "Run PGLM", "Poisson, grouped binomial and Bayesian models are planned.", 
"Observed outcomes and fitted probabilities", "Conditional 95% Wald intervals", 
"Pearson residual", "Fitted event probability", "Log-odds coefficient", 
"Coefficients describe log-odds changes holding other predictors constant. Intervals and standard errors are conditional on estimated alpha.", 
"Download fitted probabilities CSV", "Binary residuals are not normally distributed. This plot checks patterns; it is not a normality test or a calibrated goodness-of-fit test.", 
"The script embeds prepared data and settings and reproduces the selected graph in RStudio.", 
"Choose a binary response, event state and predictors.", "Inputs changed. Run PGLM to update results.", 
"PGLM completed. Review diagnostics and fitting warnings.", "Run PGLM on matched data to display results.", 
"PGLM requires a rooted, bifurcating tree.", "PGLM requires finite, positive branch lengths.", 
"Match unique, nonempty taxon labels explicitly in Data before PGLM.", 
"Select a binary response and distinct numeric predictors.", 
"Select the event state from a response with exactly two nonmissing states.", 
"PGLM predictors must be finite, numeric and nonconstant. No rows are removed automatically.", 
"PGLM needs at least six taxa, two observations per state and two residual degrees of freedom.", 
"PGLM optimization did not converge. Review variables and model settings.", 
"PGLM returned invalid estimates or standard errors.", "PGLM returned invalid fitted probabilities.", 
"Alpha is near its optimization boundary; inspect sensitivity before inference.", 
"Model details", "Phylogenetic generalized linear models", "Response family", 
"Binary (Bernoulli / logit)", "Counts (Poisson GEE / log)", "Grouped binomial and Bayesian models are planned.", 
"Observed and fitted values", "Download fitted values CSV", "Choose a response family, response and predictors.", 
"Poisson GEE with log link and multiple numeric predictors. Select a nonnegative integer count column.", 
"Counts require comparable observation effort. Exposure offsets, zero-inflation and negative-binomial models are not supported.", 
"Coefficients describe log mean-count changes holding other predictors constant; exp(coefficient) is the expected count ratio per predictor unit.", 
"GEE intervals use scale-adjusted model-based standard errors, not robust sandwich or bootstrap errors. Phylogenetic correlation is fixed by the tree. Likelihood and AIC are not available.", 
"Pearson residuals use (observed - fitted) / sqrt(fitted), without dispersion scaling. Patterns may reveal misspecification; residual normality is not assumed.", 
"Dispersion is the sum of squared Pearson residuals divided by residual degrees of freedom. Values above one indicate extra variation relative to the Poisson working variance; this is descriptive, not a calibrated test.", 
"Count responses must be finite, nonnegative integers with at least two different values. No rounding or row removal is automatic.", 
"PGLM needs at least six taxa and two residual degrees of freedom.", 
"PGLM returned an invalid dispersion estimate.", "PGLM returned invalid fitted counts.", 
"PGLM fitted taxa do not match the input tree.", "Log-mean coefficient", 
"GEE 95% Wald intervals", "Fitted mean count", "Observed count", 
"Observed and fitted counts", "Taxa", "Observed zeros", "Residual degrees of freedom", 
"Dispersion", "Convergence code", "Value", "Grouped binomial (GEE / logit)", 
"Response / successes", "Total trials", "Total successes", "Bayesian models are planned.", 
"Select successes and total trials per species. Trials must be positive integers; successes may range from zero to trials.", 
"Grouped-binomial GEE uses a logit link and a fixed tree-derived working correlation. No trial expansion or proportion rounding is performed.", 
"Coefficients describe log-odds changes holding other predictors constant. Intervals use model-based covariance with binomial scale fixed at one.", 
"One phylogeny is one correlated cluster. Robust sandwich intervals, likelihood and AIC are not reported. Extra-binomial variation is not fitted.", 
"Pearson residuals compare observed successes with trials times fitted probability, using binomial variance. Dispersion is descriptive and does not rescale the fitted intervals.", 
"Pearson dispersion (descriptive)", "Select a distinct total-trials column, separate from successes and predictors.", 
"Grouped binomial requires integer counts with positive trials and 0 <= successes <= trials. No rows are removed automatically.", 
"Grouped binomial needs at least one success and one failure across species.", 
"Grouped binomial fitted probabilities are at a boundary. Check separation and model complexity.", 
"The phylogenetic working correlation is invalid.", "Grouped binomial GEE did not converge. Review the inputs and model complexity.", 
"Fitted success probability", "Observed success proportion", 
"Observed and fitted proportions", "Categorical predictors", 
"Reference category", "Mark categorical predictors explicitly, including numeric state codes. Other predictors are continuous.", 
"Category coefficients compare each state with its reference, holding other predictors constant.", 
"Categorical columns must be selected predictors.", "Categorical predictors must have nonmissing, nonempty states.", 
"Categorical predictors need at least two observed states.", 
"Choose an observed reference category for every categorical predictor.", 
"Some predictor categories contain fewer than three taxa; estimates may be unstable.", 
"Select a response and distinct predictors.", "Poisson GEE with log link and multiple numeric or categorical predictors. Select a nonnegative integer count column.", 
"Bernoulli response with logit link; multiple numeric or categorical predictors.", 
"Compare covariance models (ML)", "Comparison uses the same data and predictors for all four structures, with ML and the current fixed or initial parameter setting.", 
"Covariance model comparison", "AIC weights describe relative support within the successful candidate set, not probabilities that models are true. Failed models remain listed. No likelihood-ratio tests or model averaging are performed.", 
"Comparison finished. Review failed models and warnings.", "Run taxon influence diagnostics", 
"Refits the current model once per taxon on temporary pruned copies. Prepared data stay unchanged. Large datasets may take time.", 
"Diagnostic screens", "LargeResidual marks absolute Pearson residuals above 2; Sparse marks fewer than 3 taxa. OneOutcome marks a category with only successes or failures. These are descriptive screens, not tests or automatic exclusions; absence of flags does not rule out separation.", 
"Taxon influence", "Influence is the largest absolute coefficient change divided by its full-fit standard error. Inspect failed refits and warnings. This is sensitivity analysis, not a calibrated test or cross-validation.", 
"At least two valid models are needed for comparison.", "Delta AIC (ML)", 
"No valid diagnostic refits.", "Taxon index (see table)", "Maximum coefficient shift / full-fit SE", 
"Download comparison CSV", "Download comparison PDF", "Download comparison R code", 
"Download influence CSV", "Download influence PDF", "Download influence R code", 
"Trait for reconstruction", "Framework", "Maximum likelihood", 
"Bayesian / stochastic — planned", "Parsimony — planned", 
"Brownian motion (BM)", "Choose an original or transformed numeric trait. Reconstruction stays on that scale; no automatic back-transformation is applied.", 
"Run BM reconstruction", "Trait map", "Phenogram", "Node intervals", 
"Contrast diagnostics", "Node estimates are BM maximum-likelihood reconstructions. Branch colors and phenogram lines interpolate estimates; they are not observed or sampled evolutionary histories.", 
"Intervals are approximate 95% analytic node intervals from fastAnc (Rohlf variance). They are not Bayesian credible intervals or simultaneous bands and do not include tree or model uncertainty.", 
"Download node estimates CSV", "The Q-Q plot screens standardized independent contrasts under BM. It does not prove model adequacy. The diffusion rate and log likelihood use a marginal tip-data ML calculation; node intervals use fastAnc variance.", 
"Choose a numeric trait and run BM reconstruction.", "Inputs changed. Run BM reconstruction to update results.", 
"This framework is planned. Only maximum-likelihood BM is implemented.", 
"BM reconstruction completed. Review uncertainty and diagnostics.", 
"BM reconstruction requires a rooted, bifurcating tree.", "BM reconstruction requires finite, positive branch lengths.", 
"Select distinct taxon and numeric trait columns.", "Match unique taxon labels explicitly in Data before reconstruction; at least three taxa are required.", 
"BM reconstruction needs a finite, nonconstant numeric trait. No rows are removed automatically.", 
"BM reconstruction returned invalid node estimates or uncertainty.", 
"BM reconstruction returned an invalid diffusion rate.", "BM ancestral reconstruction", 
"Distance from root (branch-length units)", "Approximate 95% node intervals", 
"BM contrast diagnostic", "Standardized contrasts", "Node", "Variance", 
"Internal nodes", "Root estimate", "BM diffusion rate (ML)", 
"Log likelihood (ML)", "Model", "ER shares all rates; SYM shares reverse rates; ARD estimates each directed rate.", 
"Use 2 to 10 observed states. Numeric states must be integers. Polymorphic characters belong in their own card.", 
"Root-state probabilities are fixed equal across observed states.", 
"State order", "Start custom matrix from", "Fill custom matrix", 
"Custom rate constraints", "Rows are source states; columns are destination states, in the displayed order. Use 0 for forbidden transitions and the diagonal. Equal positive integers share a rate; use consecutive indices starting at 1. Enter comma-separated rows without headers.", 
"Upper rate bound", "Compare with ER, SYM and ARD", "Run Mk reconstruction", 
"Node probability tree", "Transition-rate diagram", "Marginal state probabilities", 
"Node pie size", "Node pies show marginal state probabilities conditional on the fitted rates, tree and equal root probabilities. They do not integrate parameter or tree uncertainty and are not sampled evolutionary histories.", 
"Download node probabilities CSV", "Fitted Q matrix", "Rows are source states; columns are destination states. Off-diagonal rates are per branch-length unit; diagonal entries are negative row sums.", 
"Download rate matrix CSV", "Three deterministic starts are fitted per model. Convergence does not establish identifiability or model adequacy. Near-boundary rates and different optima require caution.", 
"AIC comparisons use the same taxa, trait, tree and equal root probabilities. Weights describe only distinct converged candidates; equivalent constraints are omitted. Failed candidates remain visible. No model averaging is performed.", 
"Download optimizer diagnostics CSV", "Select Model comparison or Optimizer starts in Graph controls to view and export diagnostic plots.", 
"Choose a discrete trait and run Mk reconstruction.", "Custom constraints are valid.", 
"Inputs changed. Run Mk reconstruction to update results.", "This framework is planned. Only maximum-likelihood Mk is implemented.", 
"Mk reconstruction completed. Review optimizer diagnostics and model assumptions.", 
"Select a discrete trait with 2 to 10 observed states.", "Custom matrix must have one row and column per state, without headers.", 
"Custom matrix requires nonnegative integer indices and a zero diagonal.", 
"Custom matrix names must match the displayed state order.", 
"Positive rate indices must be consecutive: 1, 2, 3, and so on.", 
"No ancestral state can reach all observed states under this custom model.", 
"Mk reconstruction requires a rooted, bifurcating tree.", "Mk reconstruction requires finite, positive branch lengths.", 
"Select distinct taxon and discrete trait columns.", "Numeric discrete states must be finite integers; continuous values are not binned.", 
"Use one unambiguous state per taxon. Missing and polymorphic states are not supported here.", 
"The upper rate bound must be finite and greater than 1e-8.", 
"No converged finite fit. Inspect optimizer messages.", "Some starting values failed. Inspect optimizer messages.", 
"A rate is near an optimization bound. Estimates and model rankings may be unstable.", 
"Starting values reached different likelihoods. The highest converged likelihood is shown; a global optimum is not guaranteed.", 
"There are many rate parameters relative to taxa. Interpret this fit cautiously.", 
"Some states have fewer than three observed taxa.", "Invalid marginal probabilities or inconsistent reconstruction likelihood.", 
"Mk ancestral reconstruction", "Transition rates per branch-length unit", 
"Converged", "Failed", "Start", "Convergence", "Valid", "Status", 
"Delta_AIC", "LogLik", "Equivalent", "Equivalent models share one comparison entry.", 
"nodes have a most-supported state with probability at least 0.90. This is conditional support, not certainty.", 
"Stochastic mapping (fixed fitted rates)", "Bayesian rate sampling — planned", 
"Number of histories", "Mapping seed", "History to display", 
"Histories are conditional on the fitted Q matrix, observed tips, tree and equal root probabilities. Rates and trees are not sampled. There is no MCMC burn-in.", 
"Simulation ranges describe the central 95% of sampled histories, not confidence intervals for the mean or uncertainty in fitted rates. MCSE measures Monte Carlo precision; small samples and zero sampled events can be misleading.", 
"Transition counts", "State occupancy", "Download transition summary CSV", 
"Download state occupancy CSV", "Download sampled node frequencies CSV", 
"Download histories and summaries RDS", "Monte Carlo agreement", 
"Compare sampled node frequencies with analytic marginal probabilities. Differences should decrease with more independent histories; this plot is not an MCMC convergence or model-adequacy test.", 
"Choose an integer number of histories between 2 and 500.", "Choose an integer seed between 0 and 2147483646.", 
"Mapping requires a valid fitted Q matrix in the displayed state order.", 
"Requested mapping workload is too large. Reduce the number of histories.", 
"Mapping did not return the requested number of histories.", 
"A sampled history does not match the fitted model or taxa.", 
"A sampled history has invalid branch segments.", "A sampled history contains a forbidden transition.", 
"A sampled history is inconsistent at nodes or observed tips.", 
"Run stochastic mapping before viewing history summaries.", "Choose a saved history number within the simulated range.", 
"Sampled node frequencies", "Conditional stochastic history", 
"Transitions per history", "Total branch length in state", "Mean and central 95% simulation range", 
"Analytic marginal probability", "Sampled node-state frequency", 
"This framework is planned. Choose ML or fixed-rate stochastic mapping.", 
"Simulating conditional histories", "Stochastic mapping completed. Review simulation precision and fitted-rate warnings.", 
"Conditional stochastic mapping completed.", "Saved histories", 
"From", "To", "Mean", "SD", "MCSE", "Frequency", "Analytic", 
"Difference", "Run stochastic mapping", "Polymorphic ancestral reconstruction", 
"Code coexisting states with +, such as A+B. Missing, ambiguous and empty states are not supported.", 
"Use two or three constituent states and at least one polymorphic taxon.", 
"Use unique state names without surrounding spaces in each combination.", 
"Unknown polymorphic model.", "Unordered model: transitions add or lose one constituent state. All combinations are included, even if unobserved. Direct monomorphic substitutions are forbidden.", 
"ER shares allowed rates; SYM ties reverse rates; ARD separates directions; transient uses one loss rate and one gain rate.", 
"Equal root probabilities apply to combined states, not to constituent states. A+B represents coexistence, not uncertain coding.", 
"Compare polymorphic models", "Run polymorphic reconstruction", 
"Coding audit", "Combination order is canonicalized for fitting; original data remain unchanged.", 
"Download coding audit CSV", "Rate constraints", "Comparisons use the same taxa, complete state space and equal root probabilities. AIC weights cover converged candidates only; no model averaging is performed.", 
"Choose a polymorphic trait and run reconstruction.", "Inputs changed. Run polymorphic reconstruction to update results.", 
"This framework is planned. Only polymorphic maximum likelihood is implemented.", 
"Polymorphic reconstruction completed. Review coding, constraints and diagnostics.", 
"Polymorphic reconstruction completed. Combination coding is recorded in the analysis audit; source data are unchanged.", 
"Original", "Canonical", "Ordered polymorphism", "Unordered polymorphism", 
"Constituent order (one state per line)", "Maximum polymorphism", 
"Only contiguous combinations in the specified order are allowed. Maximum polymorphism limits the number of coexisting states. No order is inferred automatically.", 
"Transition preview", "Rows are source states; columns are destinations. Zero forbids a transition; equal positive indices share a rate. This preview does not fit a model.", 
"Constraints are valid. Review allowed transitions before running.", 
"Choose ordered or unordered polymorphism.", "State order must contain every constituent exactly once.", 
"Maximum polymorphism must be an integer from 2 to the number of constituent states.", 
"Observed combinations violate the state order or maximum polymorphism. Change the model settings; no taxa are removed.", 
"Tree source", "Data tree", "Uploaded tree set", "Newick files (one or more trees)", 
"Up to 25 trees; every tree must pass validation. Uploaded trees remain local to this card.", 
"Include stem (root.edge)", "Ultrametric tolerance", "Non-ultrametric trees are not accepted in this workflow. No rooting, pruning, resolution or recalibration is automatic.", 
"Stem lengths are omitted unless explicitly included. Without a supplied stem, the curve begins at the crown root.", 
"Time direction", "Since origin", "Before present", "Time before present (branch-length units)", 
"Time since origin (branch-length units)", "Dotdash", "Longdash", 
"Twodash", "Width (inches)", "Height (inches)", "Overlays are individual curves, not confidence bands. Compare trees only when branch-length units and sampling are compatible.", 
"LTT coordinates (first 100 rows)", "Choose trees and run LTT.", 
"Inputs changed. Run LTT to update results.", "Upload Newick trees first.", 
"LTT completed. Review tree ages and sampling assumptions.", 
"Validated rooted ultrametric trees; no taxa or branches were changed.", 
"Tips", "Crown_age", "Stem", "Tip_depth_range", "Events", "LTT requires at least two uniquely named tips.", 
"Invalid tree structure for LTT.", "LTT requires an explicitly rooted tree.", 
"LTT requires finite, positive branch lengths.", "LTT tolerance must be positive and at most 0.001.", 
"LTT requires an ultrametric tree; calibrate it before analysis.", 
"Invalid stem setting.", "Stem length must be finite and nonnegative.", 
"Choose one to 25 trees for LTT.", "No trees found in the uploaded Newick file.", 
"Invalid LTT graph settings.", "Models", "Birth-death", "Random extant sampling fraction", 
"Condition on crown survival and root split", "Sampling assumes independent random inclusion of extant species. Nonrandom or diversified sampling is not modeled.", 
"Crown-tree likelihood; supplied stems are excluded. No tip-number conditioning. Both models use the same sampling and conditioning settings.", 
"Optimizer", "Maximum iterations", "Rate upper bound (blank = 100 / crown age)", 
"Initial lambda (blank = derived)", "Initial mu (blank = lambda / 2)", 
"Several deterministic starts are tried. Extinction may exceed speciation; no positive net-diversification constraint is imposed.", 
"Calculate approximate curvature intervals", "Save likelihood slices", 
"Run diversification models", "Rate estimates", "Likelihood slice", 
"lambda is speciation, mu is extinction, and net is lambda minus mu. Rates are per branch-length unit, not automatically per million years.", 
"Intervals are approximate 95% normal intervals from likelihood curvature. NA means unavailable, including fixed rates, boundary estimates, unstable curvature or negative rate limits. They exclude uncertainty in sampling fraction and tree.", 
"AIC weights compare only the selected models on the same likelihood basis. Weights are withheld if a candidate fails. Boundary fits and extinction estimates need caution; no likelihood-ratio p-value is reported.", 
"Likelihood slices hold the other rate fixed. They reveal local curvature but are not profile likelihoods or confidence intervals. Select Likelihood slice in Graph controls to view and export them.", 
"Download likelihood slices CSV", "Rates require a rooted binary ultrametric tree with at least four tips.", 
"Choose Yule, birth-death, or both models.", "Sampling fraction must be greater than zero and at most one.", 
"Invalid rate analysis settings.", "Invalid optimizer settings.", 
"Rate upper bound must be positive and compatible with the tree scale.", 
"Starting rates must lie inside the selected rate bounds.", "A model failed to converge; model comparison weights are withheld.", 
"A rate lies on an optimization boundary. Intervals are withheld; inspect bounds and extinction identifiability.", 
"Some optimizer starts failed; inspect the full optimizer table.", 
"Optimizer starts reached different likelihoods; a global optimum is not guaranteed.", 
"Likelihood curvature is unstable; approximate intervals are unavailable.", 
"No valid model fit. Change settings and run again.", "Supplied stem excluded; this analysis uses a crown-tree likelihood.", 
"At least two converged compatible fits are required for comparison.", 
"Constant-rate model comparison", "No saved likelihood slice for this selection.", 
"per branch-length unit", "Likelihood slice: other rate held fixed", 
"Rates per branch-length unit", "Constant-rate estimates", "Choose settings and run diversification models.", 
"Inputs changed. Run diversification models to update results.", 
"Fitting diversification models", "Rate analysis completed. Inspect convergence, bounds and uncertainty.", 
"Constant-rate diversification analysis completed.", "Parameters", 
"Message", "Weight", "Bars: approximate 95% curvature intervals where available", 
"Model ranking requires two converged candidates. Inspect individual estimates and diagnostics.", 
"Lowest AIC among selected models:", "The AIC difference is small; these data do not clearly distinguish the selected models.", 
"Relative AIC support does not establish that the selected model adequately describes the data.", 
"Uncertainty and model diagnostics", "Calculate profile likelihoods", 
"Profile reference level", "Simulate conditional LTT curves", 
"Simulation replicates", "Simulation seed", "Run uncertainty and diagnostics", 
"Run models first. Diagnostic settings clear only diagnostics; rerun diagnostics after changing them.", 
"Conditional LTT check", "Conditional discrepancy reference", 
"Profiles reoptimize the nuisance rate within the fitted bounds. The chi-square reference is approximate; coverage at boundaries is not calibrated. Search limits are not infinite confidence limits. Nuisance_bound flags dependence on the upper rate bound.", 
"Download profile intervals CSV", "Download profile curves CSV", 
"Conditional simulation check", "Simulations fix fitted rates, random sampling fraction, crown age and sampled tip count. They test branching-time shape, not tree size or age. The 95% envelope is pointwise, not simultaneous, and excludes parameter and tree uncertainty.", 
"The reference tail fraction compares a branching-time CDF discrepancy with simulations at fitted rates. It is descriptive, not a calibrated p-value; rates are not refitted per replicate. Select a diagnostic graph in Results to view and export it.", 
"Download simulation envelope CSV", "Download simulated branching times CSV", 
"Invalid profile settings.", "Threshold crossing", "Physical boundary", 
"Profile numerical failure or better optimum", "Disconnected support; inspect profile", 
"Invalid simulation parameters.", "Invalid simulation times.", 
"Invalid simulation probabilities.", "Simulation numerical failure.", 
"Invalid simulation settings.", "Invalid diagnostic settings.", 
"Run profile diagnostics first.", "No profile for a fixed or failed parameter.", 
"Profile likelihood: nuisance rate reoptimized", "Boundary coverage is not calibrated.", 
"Run simulation diagnostics first.", "No simulations for this model.", 
"Time since crown (branch-length units)", "Simulation median", 
"Pointwise 95% simulation envelope", "Running uncertainty and simulation diagnostics", 
"Diagnostics completed. Review profile limits and simulation assumptions.", 
"Lower_status", "Upper_status", "Nuisance_bound", "Simulations", 
"Observed_D", "Reference_tail_fraction", "Observed", "Too many simulated branching times; reduce replicates.", 
"A rate lies on an optimization boundary. Curvature intervals are withheld; inspect bounds and extinction identifiability.", 
"Time-varying models", "Time-comparison candidates", "ExpYule: exponential speciation, zero extinction. ExpBD: exponential speciation, constant extinction. lambda(t) = lambda0 * exp(-beta * t), with t measured backward from the present. Positive beta means increasing speciation toward the present.", 
"Initial beta (per branch-length unit)", "Absolute bound on beta times crown age", 
"ODE solver", "Uses the sampling, conditioning, optimizer and rate starts above. The rate upper bound limits present-day speciation and constant extinction; ancestral speciation can exceed it. All comparison candidates use the same ODE likelihood.", 
"Run time-varying comparison", "Rates through time", "Time-model comparison", 
"Time-model results", "Time-model trajectories are fitted estimates without uncertainty bands. Constant-rate profiles and simulations do not apply to the time-varying fits. AIC weights describe this candidate set, not model adequacy.", 
"Download time comparison CSV", "Download rate trajectories CSV", 
"Time-model diagnostics", "Tolerance_delta compares the saved likelihood with a tenfold tighter ODE tolerance. Weights are withheld above 0.0001 or on failure. Inspect all starts and boundary flags.", 
"Download time optimizer CSV", "Select valid time-comparison models.", 
"Beta start must be within the positive scaled beta bound (at most 10).", 
"Invalid ODE solver settings.", "A time model failed; comparison weights are withheld.", 
"ODE tolerance sensitivity detected; comparison weights are withheld.", 
"A time-model parameter approaches a search bound; refit with reviewed bounds.", 
"Some time-model starts failed. Inspect optimizer diagnostics.", 
"Time-model starts reached different optima.", "Compatible converged and numerically stable fits are required.", 
"Invalid graph parameter.", "Fitted rates through time", "Fitted trajectories; uncertainty bands are not estimated.", 
"Fitting time-varying models", "Time-model analysis completed. Inspect diagnostics and bounds.", 
"Time-model settings changed. Run time-varying comparison again.", 
"Lowest AIC among time candidates:", "Time-model uncertainty and robustness", 
"Time model to diagnose", "Time-model profiles", "Time profile grid points", 
"Conditional parametric bootstrap", "Bootstrap replicates", "Check starts, bounds and tolerance", 
"Robustness bound multiplier", "Run time-model uncertainty", 
"Time-model profile likelihood", "Conditional bootstrap refits", 
"Time-model robustness", "Time profiles reoptimize nuisance parameters within saved bounds. Search limits and nuisance-bound flags are not infinite intervals. Reference coverage is approximate, especially at boundaries.", 
"Download time profile intervals CSV", "Download time profile curves CSV", 
"Bootstrap refits fix crown age, sampled tip count and sampling fraction. The pointwise 95% envelope summarizes successful conditional refits, not calibrated confidence coverage or model-selection uncertainty. Bands require at least 20 successful refits and 90% success. Inspect failures and boundary frequency.", 
"Download bootstrap refits CSV", "Download bootstrap bands CSV", 
"Robustness refits change starts, expand bounds and tighten ODE tolerance separately. A better likelihood means the original fit needs review. These scenarios do not prove a global optimum.", 
"Select a converged and numerically stable time model.", "Invalid bootstrap simulation parameters.", 
"Bootstrap CDF integration failed.", "Invalid bootstrap branching ages.", 
"Invalid bootstrap settings.", "Bootstrap CDF grid is not accurate enough.", 
"Robustness bound multiplier must be greater than one and at most four.", 
"Alternate starts", "Wider bounds", "Tighter tolerance", "Run time-model uncertainty first.", 
"Select lambda, beta or mu with a fitted profile.", "Run robustness checks first.", 
"Sensitivity relative to saved fit", "Bootstrap bands unavailable; inspect refit failures.", 
"Select lambda, mu or net for bootstrap curves.", "Saved fit", 
"Bootstrap median", "Pointwise 95% conditional refit envelope; not calibrated coverage.", 
"Time uncertainty settings changed. Run time uncertainty again.", 
"Computing time-model uncertainty", "Time uncertainty completed. Review limits, failures and robustness.", 
"Successful refits", "A robustness refit improved the likelihood; review the original fit before interpretation.", 
"Some bootstrap refits failed; summaries condition on successful refits.", 
"Scenario", "Replicate", "Success", "Rates through time shows fitted trajectories. Conditional bootstrap bands are available after Run time-model uncertainty. AIC weights describe the selected candidate set, not model adequacy.", 
"Another candidate supplies a better feasible point. Refit before interpreting model support.", 
"Term", "Theoretical quantiles", "Your tree will appear here", 
"Load a tree or start with the example dataset", "No finite numeric observations", 
"Density requires varying observations", "Time since root (branch-length units)", 
"Lineages", "Shapiro-Wilk normality test", "Trait normality does not establish model residual normality.", 
"Predictor", "Reference", "Index", "Taxon", "Diagnostic settings changed. Run uncertainty and diagnostics again.", 
"Reference_level", "Analysis running in the background. You can keep exploring other results.", 
"An analysis is already running. Wait for it to finish.", "The analysis exceeded the server time limit. Reduce its size or run the exported R script locally.", 
"The analysis process stopped unexpectedly, possibly because it ran out of memory. Reduce the analysis size and run it again.", 
"Analysis cancelled.", "Diversity-dependent models on this server support at most 4998 species including missing species.", 
"The background analysis service is temporarily unavailable. Try again in a moment.", 
"This tree exceeds the maximum number of tips supported on this server. Run the exported R script locally for larger trees.", 
"This trait table exceeds the maximum size supported on this server.", 
"Choose integer mapping settings within the allowed range.", 
"Diversity-dependent models require DDD 5.2.5 or newer. Update DDD and run again.", 
"Pagel's correlation requires phytools 2.5-2 or newer. Update phytools and run again."
))
function() dictionary
})
guane_task_setting <- function (option, env, default, lower = -Inf, upper = Inf) 
{
    value <- getOption(option)
    if (is.null(value)) {
        value <- Sys.getenv(env, "")
        if (!nzchar(value)) 
            return(default)
    }
    if (is.logical(default)) {
        if (is.logical(value) && length(value) == 1 && !is.na(value)) 
            return(value)
        key <- tolower(trimws(as.character(value)[1]))
        if (key %in% c("true", "t", "yes", "y", "1", "on")) 
            return(TRUE)
        if (key %in% c("false", "f", "no", "n", "0", "off")) 
            return(FALSE)
        message("Guane: ignoring invalid value for ", env, "; using ", 
            default, ".")
        return(default)
    }
    number <- suppressWarnings(as.numeric(value)[1])
    if (!is.finite(number)) {
        message("Guane: ignoring invalid value for ", env, "; using ", 
            default, ".")
        return(default)
    }
    min(max(number, lower), upper)
}
guane_limits <- function () 
{
    list(tips = guane_task_setting("guane.max_tips", "GUANE_MAX_TIPS", 
        5000, 4, 1e+06), rows = guane_task_setting("guane.max_rows", 
        "GUANE_MAX_ROWS", 50000, 4, 1e+07), columns = guane_task_setting("guane.max_columns", 
        "GUANE_MAX_COLUMNS", 500, 2, 1e+05))
}
guane_validate <- function (tree, traits, taxon, trait) 
{
    issues <- data.frame(level = character(), message = character())
    add <- function(level, message) issues[nrow(issues) + 1L, 
        ] <<- c(level, message)
    if (is.null(tree)) 
        add("Required", "Load a phylogenetic tree.")
    if (is.null(traits)) 
        add("Required", "Load a CSV trait table.")
    if (!is.null(tree)) {
        if (length(tree$tip.label) > guane_limits()$tips) 
            add("Error", "This tree exceeds the maximum number of tips supported on this server. Run the exported R script locally for larger trees.")
        if (anyDuplicated(tree$tip.label)) 
            add("Error", "Tree tip labels must be unique.")
        if (anyNA(tree$tip.label) || any(!nzchar(trimws(tree$tip.label)))) 
            add("Error", "Tree contains empty taxon labels.")
        if (is.null(tree$edge.length) || any(!is.finite(tree$edge.length)) || 
            any(tree$edge.length <= 0)) 
            add("Error", "Signal analysis requires finite, positive branch lengths.")
        if (!ape::is.rooted(tree)) 
            add("Error", "Root the tree before signal analysis.")
        if (!ape::is.binary(tree)) 
            add("Warning", "Tree contains polytomies; inspect their biological meaning.")
        if (!is.null(tree$edge.length) && !ape::is.ultrametric(tree)) 
            add("Note", "Tree is not ultrametric. Signal analysis can use it; verify branch-length units.")
    }
    if (!is.null(traits)) {
        if (is.null(taxon) || !taxon %in% names(traits)) 
            add("Required", "Select the taxon column.")
        else {
            ids <- as.character(traits[[taxon]])
            if (anyNA(ids) || any(!nzchar(trimws(ids)))) 
                add("Error", "Trait table contains empty taxon labels.")
            if (anyDuplicated(ids)) 
                add("Error", "Trait taxon labels must be unique.")
            if (!is.null(tree) && !setequal(ids, tree$tip.label)) 
                add("Error", paste0("Taxon mismatch: ", length(setdiff(tree$tip.label, 
                  ids)), " tree tips without traits; ", length(setdiff(ids, 
                  tree$tip.label)), " table taxa outside tree. Use matched taxa only after reviewing this report."))
        }
        if (is.null(trait) || !trait %in% names(traits)) 
            add("Required", "Select a numeric trait.")
        else {
            x <- traits[[trait]]
            if (!is.numeric(x) || any(!is.finite(x))) 
                add("Error", "Selected trait must contain only finite numeric values; correct missing values before running.")
            else if (length(unique(x)) < 2) 
                add("Error", "Selected trait has no variation.")
        }
    }
    if (!is.null(tree) && length(tree$tip.label) < 4) 
        add("Error", "At least four matched taxa are required.")
    issues
}
guane_signal <- function (tree, traits, taxon, trait, seed = 999, nsim = 999) 
{
    if (length(nsim) != 1 || !is.finite(nsim) || nsim < 99 || 
        nsim > 9999 || nsim != floor(nsim)) 
        stop("Choose 99–9999 integer randomizations.")
    if (length(seed) != 1 || !is.finite(seed) || seed < 0 || 
        seed > 2147483647 || seed != floor(seed)) 
        stop("Choose a nonnegative integer seed up to 2147483647.")
    issues <- guane_validate(tree, traits, taxon, trait)
    if (any(issues$level %in% c("Error", "Required"))) 
        stop("Resolve data issues before running.")
    x <- setNames(traits[[trait]], as.character(traits[[taxon]]))[tree$tip.label]
    had <- exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
    oldkind <- RNGkind()
    if (had) 
        oldseed <- get(".Random.seed", envir = .GlobalEnv)
    on.exit({
        do.call(RNGkind, as.list(oldkind))
        if (had) assign(".Random.seed", oldseed, envir = .GlobalEnv) else if (exists(".Random.seed", 
            envir = .GlobalEnv, inherits = FALSE)) rm(".Random.seed", 
            envir = .GlobalEnv)
    }, add = TRUE)
    set.seed(seed, kind = "Mersenne-Twister", normal.kind = "Inversion", 
        sample.kind = "Rejection")
    k <- phytools::phylosig(tree, x, method = "K", test = TRUE, 
        nsim = nsim)
    lambda <- phytools::phylosig(tree, x, method = "lambda", 
        test = TRUE)
    if (any(!is.finite(c(k$K, k$P, lambda$lambda, lambda$P, lambda$logL, 
        lambda$logL0)))) 
        stop("Signal analysis returned nonfinite estimates. Inspect the inputs.")
    answer <- data.frame(Metric = c("Blomberg's K", "Pagel's lambda"), 
        Estimate = c(k$K, lambda$lambda), P_value = c(k$P, lambda$P), 
        Test = c(paste(nsim, "test draws (including observed)"), 
            "Likelihood ratio: lambda = 0"))
    attr(answer, "snapshot") <- list(tree = tree, traits = traits[match(tree$tip.label, 
        as.character(traits[[taxon]])), c(taxon, trait), drop = FALSE], 
        taxon = taxon, trait = trait, seed = seed, nsim = nsim, 
        x = x)
    attr(answer, "randomized_K") <- k$sim.K[-1]
    answer
}
guane_text <- function (text, lang = "en") 
{
    i <- match(lang, c("es", "pt"))
    if (length(i) != 1 || is.na(i) || !is.character(text) || 
        length(text) != 1) 
        return(text)
    entry <- guane_dictionary()[[text]]
    if (is.null(entry)) 
        text
    else entry[[i]]
}
guane_signal_plot <- function (result, type = "tree", palette = "Guane", font = 0.8, 
    lang = "en") 
{
    snapshot <- attr(result, "snapshot")
    x <- snapshot$x
    tree <- snapshot$tree
    colors <- (grDevices::colorRampPalette(if (palette == "Grayscale") 
        c("#eeeeee", "#222222")
    else c("#e4f1cf", "#54a37a", "#0d5368")))(256)
    old <- graphics::par(no.readonly = TRUE)
    on.exit(graphics::par(old))
    if (type == "null") {
        values <- attr(result, "randomized_K")
        graphics::par(mar = c(5, 5, 3, 1))
        graphics::hist(values, breaks = "FD", xlim = range(c(values, 
            result$Estimate[1])), main = guane_text("Randomized K values", 
            lang), xlab = "Blomberg's K", ylab = guane_text("Frequency", 
            lang), col = colors[150], border = "white")
        graphics::abline(v = result$Estimate[1], lwd = 2, lty = 2, 
            col = colors[256])
        graphics::legend("topright", legend = paste(guane_text("Observed K", 
            lang), formatC(result$Estimate[1], digits = 4, format = "fg")), 
            lty = 2, lwd = 2, col = colors[256], bty = "n")
    }
    else {
        limits <- range(x)
        indices <- pmax(1, pmin(256, 1 + floor((x - limits[1])/diff(limits) * 
            255)))
        reserve <- max(3, length(x) * 0.15)
        graphics::par(mar = c(1, 1, 2, 1))
        ape::plot.phylo(tree, tip.color = "#345747", cex = font, 
            edge.color = "#607369", edge.width = 1.5, no.margin = FALSE, 
            y.lim = c(-reserve, length(x) + 1), label.offset = max(ape::node.depth.edgelength(tree)) * 
                0.02)
        ape::tiplabels(pch = 21, bg = colors[indices], col = "#345747", 
            cex = 1)
        graphics::title(main = guane_text("Observed tip values", 
            lang), cex.main = 1)
        bounds <- graphics::par("usr")[1:2]
        width <- diff(bounds)
        positions <- seq(bounds[1] + width * 0.08, bounds[2] - 
            width * 0.08, length.out = 257)
        graphics::rect(positions[-257], -reserve * 0.35, positions[-1], 
            -reserve * 0.15, col = colors, border = NA)
        anchors <- seq(1, 257, length.out = 5)
        graphics::text(positions[anchors], -reserve * 0.53, labels = format(signif(seq(limits[1], 
            limits[2], length.out = 5), 3)), cex = 0.8)
        graphics::text(mean(positions), -reserve * 0.83, labels = snapshot$trait, 
            cex = 0.85)
    }
    invisible(x)
}
inputs <- structure(list(structure(list(structure(c(14L, 15L, 16L, 17L, 
18L, 19L, 20L, 21L, 22L, 22L, 21L, 20L, 19L, 18L, 17L, 23L, 23L, 
24L, 25L, 25L, 24L, 16L, 15L, 14L, 15L, 16L, 17L, 18L, 19L, 20L, 
21L, 22L, 1L, 2L, 3L, 4L, 5L, 6L, 23L, 7L, 24L, 25L, 8L, 9L, 
10L, 11L, 12L, 13L), dim = c(24L, 2L)), c(0x1.935fc3b4f6167p-5, 
0x1.18f1d3ed527e5p-4, 0x1.12839042d8c2ap-3, 0x1.a7c5ac471b478p-4, 
0x1.22d0e56041893p-5, 0x1.2c7b890d5a5b9p-7, 0x1.2c5c13fd0d068p-4, 
0x1.c28f5c28f5c29p-5, 0x1.c28f5c28f5c29p-5, 0x1.c28f5c28f5c29p-5, 
0x1.c28f5c28f5c29p-4, 0x1.7775b81301648p-3, 0x1.8a3d70a3d70a4p-3, 
0x1.d2f1a9fbe76c9p-3, 0x1.f55475a31a4bep-3, 0x1.630014f8b588ep-4, 
0x1.a747d805e5f31p-5, 0x1.eb851eb851eb8p-7, 0x1.47ae147ae147bp-6, 
0x1.47ae147ae147bp-6, 0x1.1eb851eb851ecp-5, 0x1.dcac083126e98p-2, 
0x1.11743e963dc48p-1, 0x1.2aaa3ad18d25fp-1), 12L, c("fuliginosa", 
"fortis", "magnirostris", "conirostris", "scandens", "difficilis", 
"pallida", "parvulus", "psittacula", "pauper", "Platyspiza", 
"fusca", "Pinaroloxias")), names = c("edge", "edge.length", "Nnode", 
"tip.label"), class = "phylo", order = "cladewise"), structure(list(
    c("fuliginosa", "fortis", "magnirostris", "conirostris", 
    "scandens", "difficilis", "pallida", "parvulus", "psittacula", 
    "pauper", "Platyspiza", "fusca", "Pinaroloxias"), c(0x1.f0efaa4766c6ep+0, 
    0x1.2e6b93ccd0fe9p+1, 0x1.6971327243138p+1, 0x1.41c432ca57a78p+1, 
    0x1.12858793dd97fp+1, 0x1.016bb98c7e282p+1, 0x1.0217c1bda511ap+1, 
    0x1.dfa05143bf727p+0, 0x1.1d71f36262cbap+1, 0x1.09652bd3c3611p+1, 
    0x1.2c79ee02a77a3p+1, 0x1.30f6ad70e6f2fp+0, 0x1.8c28f5c28f5c3p+0
    )), names = c("taxon", "beakD"), row.names = c(6L, 5L, 1L, 
2L, 4L, 3L, 7L, 9L, 13L, 10L, 12L, 8L, 11L), class = "data.frame"), 
    "taxon", "beakD", 20261201L, 999L), names = c("tree", "traits", 
"taxon", "trait", "seed", "nsim"))
result <- do.call(guane_signal, inputs)
print(result)
plot_settings <- structure(list("tree", "Guane", 0x1.999999999999ap-1, "en"), names = c("type", 
"palette", "font", "lang"))
figure_height <- 0x1.cp+2
do.call(guane_signal_plot, c(list(result=result), plot_settings))
# Optional PDF using the same settings:
# pdf("guane-signal.pdf", width=9, height=figure_height)
# do.call(guane_signal_plot, c(list(result=result), plot_settings)); dev.off()
sessionInfo()
