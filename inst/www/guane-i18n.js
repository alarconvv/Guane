// Translate presentation text without rebuilding controls or discarding inputs.
const guaneTranslations = {
"MuSSE support is exploratory: unmodeled rate heterogeneity can mimic trait dependence. Multistate hidden-state null models are not implemented; the hidden-state card supports binary traits only.":["El soporte de MuSSE es exploratorio: la heterogeneidad de tasas no modelada puede imitar dependencia del carácter. No hay modelos nulos ocultos multiestado; la tarjeta de estados ocultos solo admite caracteres binarios.", "O suporte de MuSSE é exploratório: a heterogeneidade de taxas não modelada pode imitar dependência do caráter. Não há modelos nulos ocultos multiestado; o cartão de estados ocultos aceita apenas caracteres binários."],
"Rate point estimates; profile intervals are shown separately.":["Estimaciones puntuales de tasas; los intervalos de perfil se muestran por separado.", "Estimativas pontuais de taxas; os intervalos de perfil são mostrados separadamente."],
"Rates condition on one tree, observed states, sampling fractions and root treatment. Optional profile intervals require verified fits; calibrated likelihood-ratio tests are not provided.":["Las tasas se condicionan a un árbol, estados, muestreo y raíz. Los intervalos de perfil requieren ajustes verificados; no hay pruebas calibradas de razón de verosimilitudes.", "As taxas se condicionam a uma árvore, estados, amostragem e raiz. Intervalos de perfil exigem ajustes verificados; não há testes calibrados de razão de verossimilhanças."],
"Refined":["Refinada", "Refinada"],
"Wider":["Dominio ampliado", "Domínio ampliado"],
"FailedStarts":["Inicios fallidos", "Inícios falhos"],

"Independent optimizer verification":["Verificación independiente del optimizador", "Verificação independente do otimizador"],
"Fitted":["Ajustado", "Ajustado"],
"Verification":["Verificación", "Verificação"],
"NativeIterations":["Iteraciones nativas", "Iterações nativas"],
"Crossing":["Cruce del umbral", "Cruzamento do limiar"],
"Failed profile segment":["Tramo del perfil fallido", "Trecho do perfil falho"],
"Search limit reached":["Límite de búsqueda alcanzado", "Limite de busca atingido"],
"Fit requires review":["El ajuste requiere revisión", "O ajuste exige revisão"],
"Run a profile analysis first.":["Ejecute primero un análisis de perfil.", "Execute primeiro uma análise de perfil."],
"Run robustness refits first.":["Ejecute primero los reajustes de robustez.", "Execute primeiro os reajustes de robustez."],
"No comparable robustness refit; inspect diagnostics.":["No hay reajuste comparable; revise diagnósticos.", "Não há reajuste comparável; revise os diagnósticos."],
"Resolve failed fits before robustness refits.":["Resuelva los ajustes fallidos antes de los reajustes de robustez.", "Resolva os ajustes falhos antes dos reajustes de robustez."],
"No finite optimizer results to display.":["No hay resultados finitos del optimizador.", "Não há resultados finitos do otimizador."],
"Invalid optimizer verification settings.":["Configuración de verificación no válida.", "Configurações de verificação inválidas."],
"Optimizer capture requires the validated hisse version 2.1.11.":["La captura del optimizador requiere la versión validada hisse 2.1.11.", "A captura do otimizador exige a versão validada hisse 2.1.11."],
"HiSSE optimizer capture failed; no verified status is available.":["Falló la captura del optimizador HiSSE; no hay estado verificado.", "A captura do otimizador HiSSE falhou; não há estado verificado."],
"AIC weights require compatible, verified, repeatable interior fits. They do not establish causality.":["Los pesos AIC requieren ajustes compatibles, verificados, repetibles e interiores. No establecen causalidad.", "Os pesos AIC exigem ajustes compatíveis, verificados, repetíveis e interiores. Não estabelecem causalidade."],

"Verify with an independent optimizer":["Verificar con un optimizador independiente", "Verificar com um otimizador independente"],
"Maximum optimizer evaluations":["Máximo de evaluaciones del optimizador", "Máximo de avaliações do otimizador"],
"Optimizer status is retained. Weights require converged repeatable interior fits and agreement with an independent optimizer.":["Se conserva el estado del optimizador. Los pesos requieren ajustes convergentes, repetibles, interiores y acuerdo con un optimizador independiente.", "O estado do otimizador é mantido. Os pesos exigem ajustes convergentes, repetíveis, interiores e concordância com um otimizador independente."],
"Model weights withheld: inspect termination, verification, starts, boundaries and duplicate constraints.":["Pesos omitidos: revise terminación, verificación, inicios, límites y restricciones duplicadas.", "Pesos omitidos: revise término, verificação, inícios, limites e restrições duplicadas."],
"Model weights describe only the compatible verified candidate set; they do not establish causality.":["Los pesos describen solo el conjunto compatible y verificado; no establecen causalidad.", "Os pesos descrevem apenas o conjunto compatível e verificado; não estabelecem causalidade."],
"Independent optimizer verification failed or disagreed. Weights and intervals are withheld.":["La verificación independiente falló o discrepó. Se omiten pesos e intervalos.", "A verificação independente falhou ou discordou. Pesos e intervalos são omitidos."],
"Inspect termination and independent optimizer agreement in Diagnostics":["Revise terminación y acuerdo entre optimizadores en Diagnósticos", "Revise término e concordância entre otimizadores em Diagnósticos"],
"Bounded subplex retains its log-rate lower bound of -20. Evaluation limits are editable. Long runs are synchronous.":["Subplex conserva el límite inferior de log-tasa de -20. El límite de evaluaciones es editable. Los ajustes largos son síncronos.", "Subplex mantém o limite inferior de log-taxa de -20. O limite de avaliações é editável. Ajustes longos são síncronos."],
"Profile uncertainty":["Incertidumbre por perfil", "Incerteza por perfil"],
"Choose the model and parameter in Graph controls, then set the profile search bounds.":["Elija modelo y parámetro en Controles del gráfico y defina los límites de búsqueda del perfil.", "Escolha modelo e parâmetro nos Controles do gráfico e defina os limites de busca do perfil."],
"Profile lower search bound":["Límite inferior de búsqueda del perfil", "Limite inferior de busca do perfil"],
"Profile upper search bound":["Límite superior de búsqueda del perfil", "Limite superior de busca do perfil"],
"Profile grid points":["Puntos de la cuadrícula del perfil", "Pontos da grade do perfil"],
"Profile confidence level":["Nivel de confianza del perfil", "Nível de confiança do perfil"],
"Run profile uncertainty":["Calcular incertidumbre por perfil", "Calcular incerteza por perfil"],
"Profile likelihood":["Perfil de verosimilitud", "Perfil de verossimilhança"],
"Download profile CSV":["Descargar perfil CSV", "Baixar perfil CSV"],
"Download interval CSV":["Descargar intervalo CSV", "Baixar intervalo CSV"],
"Resolve fit diagnostics before calculating profile intervals.":["Resuelva los diagnósticos antes de calcular intervalos de perfil.", "Resolva os diagnósticos antes de calcular intervalos de perfil."],
"Select an estimated parameter group for profiling.":["Seleccione un grupo de parámetros estimado para el perfil.", "Selecione um grupo de parâmetros estimado para o perfil."],
"Profile bounds must enclose the estimate within its fitted bounds.":["Los límites del perfil deben rodear la estimación dentro de los límites del ajuste.", "Os limites do perfil devem envolver a estimativa dentro dos limites do ajuste."],
"Profile intervals use an approximate chi-square reference conditional on the tree and model. Failed segments and search limits have no interval endpoint.":["Los intervalos usan una referencia chi-cuadrado aproximada condicionada al árbol y modelo. Los tramos fallidos y límites de búsqueda no son extremos del intervalo.", "Os intervalos usam referência qui-quadrado aproximada condicionada à árvore e ao modelo. Trechos falhos e limites de busca não são extremos do intervalo."],
"Approximate profile intervals; inspect failed segments and search limits":["Intervalos de perfil aproximados; revise fallos y límites de búsqueda", "Intervalos de perfil aproximados; revise falhas e limites de busca"],
"A profile found a better likelihood. Refit before interpretation.":["El perfil encontró una verosimilitud mayor. Reajuste antes de interpretar.", "O perfil encontrou uma verossimilhança maior. Reajuste antes de interpretar."],
"Optional profile intervals require verified fits; calibrated likelihood-ratio tests are not provided.":["Los intervalos opcionales requieren ajustes verificados; no hay pruebas de razón de verosimilitudes calibradas.", "Os intervalos opcionais exigem ajustes verificados; não há testes de razão de verossimilhanças calibrados."],
"Robustness refits":["Reajustes de robustez", "Reajustes de robustez"],
"Domain widening factor":["Factor de ampliación del dominio", "Fator de ampliação do domínio"],
"Run grid and domain refits":["Ejecutar reajustes de cuadrícula y dominio", "Executar reajustes de grade e domínio"],
"Grid and domain refits":["Reajustes de cuadrícula y dominio", "Reajustes de grade e domínio"],
"Download robustness CSV":["Descargar robustez CSV", "Baixar robustez CSV"],
"Change in aligned log likelihood":["Cambio en log-verosimilitud alineada", "Mudança na log-verossimilhança alinhada"],
"Robustness refits preserve original estimates. Unresolved grid or domain sensitivity withholds weights; no uncertainty interval is implied.":["Los reajustes conservan las estimaciones originales. La sensibilidad no resuelta de cuadrícula o dominio impide pesos; no implica intervalos.", "Os reajustes preservam as estimativas originais. Sensibilidade não resolvida de grade ou domínio impede pesos; não implica intervalos."],
"Robustness requires nx at most 2048 and a widened domain multiplier at most 30.":["La robustez requiere nx máximo de 2048 y multiplicador ampliado del dominio máximo de 30.", "A robustez exige nx máximo de 2048 e multiplicador ampliado do domínio máximo de 30."],
"Verified":["Verificado", "Verificado"],
"VerificationStatus":["Estado de verificación", "Estado de verificação"],
"VerificationLogLik":["LogLik de verificación", "LogLik de verificação"],
"VerificationMessage":["Mensaje de verificación", "Mensagem de verificação"],
"OptimizerMessage":["Mensaje del optimizador", "Mensagem do otimizador"],
"Evaluations":["Evaluaciones", "Avaliações"],
"Repeatable":["Repetible", "Repetível"],
"LowerStatus":["Estado inferior", "Estado inferior"],
"UpperStatus":["Estado superior", "Estado superior"],
"Level":["Nivel", "Nível"],
"Comparable":["Comparable", "Comparável"],
"AlignedLogLik":["LogLik alineada", "LogLik alinhada"],
"Change":["Cambio", "Mudança"],

"State 0":["Estado 0", "Estado 0"],
"Sampling fraction: state 0":["Fracción de muestreo: estado 0", "Fração amostral: estado 0"],
"Sampling fraction: state 1":["Fracción de muestreo: estado 1", "Fração amostral: estado 1"],

"BiSSE support is exploratory. Use the Hidden-state and null models card to refit compatible binary candidates.":["El soporte de BiSSE es exploratorio. Use la tarjeta de estados ocultos y modelos nulos para reajustar candidatos binarios compatibles.", "O suporte de BiSSE é exploratório. Use o cartão de estados ocultos e modelos nulos para reajustar candidatos binários compatíveis."],
"Run hidden-state models":["Ejecutar modelos de estados ocultos", "Executar modelos de estados ocultos"],
"Extinction-fraction constraints":["Restricciones de fracción de extinción", "Restrições da fração de extinção"],
"Shared":["Compartida", "Compartilhada"],
"By diversification class":["Por clase de diversificación", "Por classe de diversificação"],
"Zero extinction":["Extinción cero", "Extinção zero"],
"Root conditioning":["Condicionamiento de la raíz", "Condicionamento da raiz"],
"Root weights":["Pesos de raíz", "Pesos da raiz"],
"Likelihood":["Verosimilitud", "Verossimilhança"],
"Given":["Especificados", "Especificados"],
"Given probability of observed state 0":["Probabilidad especificada del estado observado 0", "Probabilidade especificada do estado observado 0"],
"Given root weights divide each observed-state probability equally among hidden classes. All candidates share observed coding, sampling and root settings.":["Los pesos de raíz dividen cada probabilidad observada por igual entre clases ocultas. Los candidatos comparten codificación, muestreo y configuración de raíz.", "Os pesos da raiz dividem cada probabilidade observada igualmente entre classes ocultas. Os candidatos compartilham codificação, amostragem e ajustes da raiz."],
"Custom model constraints":["Restricciones del modelo personalizado", "Restrições do modelo personalizado"],
"Hidden classes in Custom":["Clases ocultas en Personalizado", "Classes ocultas em Personalizado"],
"Turnover indices (comma-separated)":["Índices de recambio (separados por comas)", "Índices de renovação (separados por vírgulas)"],
"Extinction-fraction indices (comma-separated)":["Índices de fracción de extinción (separados por comas)", "Índices de fração de extinção (separados por vírgulas)"],
"Fill custom constraints":["Completar restricciones personalizadas", "Preencher restrições personalizadas"],
"Transition indices (CSV, no header)":["Índices de transición (CSV sin encabezado)", "Índices de transição (CSV sem cabeçalho)"],
"Custom only: order 0A,1A,0B,1B, then 0C,1C,0D,1D for four classes. Consecutive positive indices share parameters. Zero fixes extinction fractions or transitions to zero. Simultaneous observed and hidden changes are forbidden.":["Solo Personalizado: orden 0A,1A,0B,1B y después 0C,1C,0D,1D para cuatro clases. Índices positivos consecutivos comparten parámetros. Cero fija fracciones de extinción o transiciones en cero. Se prohíben cambios observados y ocultos simultáneos.", "Apenas Personalizado: ordem 0A,1A,0B,1B e depois 0C,1C,0D,1D para quatro classes. Índices positivos consecutivos compartilham parâmetros. Zero fixa frações de extinção ou transições em zero. Mudanças observadas e ocultas simultâneas são proibidas."],
"CID models tie diversification across observed states within each hidden class. Hidden classes are not observed or assigned to tips.":["Los modelos CID ligan la diversificación entre estados observados dentro de cada clase oculta. Las clases ocultas no se observan ni se asignan a las puntas.", "Os modelos CID vinculam diversificação entre estados observados dentro de cada classe oculta. As classes ocultas não são observadas nem atribuídas às pontas."],
"Use simulated annealing":["Usar recocido simulado", "Usar recozimento simulado"],
"Annealing objective calls":["Evaluaciones del objetivo de recocido", "Avaliações do objetivo de recozimento"],
"Relative optimizer tolerance":["Tolerancia relativa del optimizador", "Tolerância relativa do otimizador"],
"Starting turnover":["Recambio inicial", "Renovação inicial"],
"Starting extinction fraction":["Fracción de extinción inicial", "Fração de extinção inicial"],
"Starting transition rate":["Tasa de transición inicial", "Taxa de transição inicial"],
"Turnover upper bound":["Límite superior de recambio", "Limite superior de renovação"],
"Extinction-fraction upper bound":["Límite superior de fracción de extinción", "Limite superior da fração de extinção"],
"Transition upper bound":["Límite superior de transición", "Limite superior de transição"],
"ODE rejection threshold":["Umbral de rechazo de ODE", "Limiar de rejeição de ODE"],
"Bounded native subplex uses up to 100000 evaluations and a log-rate lower bound of -20. These backend limits are not editable here. Long runs are synchronous.":["Subplex nativo acotado usa hasta 100000 evaluaciones y límite inferior de log-tasa -20. Estos límites no son editables aquí. Las ejecuciones largas son síncronas.", "Subplex nativo limitado usa até 100000 avaliações e limite inferior de log-taxa -20. Esses limites não são editáveis aqui. Execuções longas são síncronas."],
"HiSSE does not expose optimizer termination status. Finite fits are not confirmed convergence; automatic model weights are withheld.":["HiSSE no expone el estado de terminación del optimizador. Un ajuste finito no confirma convergencia; se omiten los pesos automáticos.", "HiSSE não expõe o estado de término do otimizador. Um ajuste finito não confirma convergência; os pesos automáticos são omitidos."],
"Turnover = lambda + mu; extinction fraction = mu / lambda. Hidden-state labels can exchange between fits. Rates use branch-length units.":["Recambio = lambda + mu; fracción de extinción = mu / lambda. Las etiquetas ocultas pueden intercambiarse entre ajustes. Las tasas usan unidades de longitud de rama.", "Renovação = lambda + mu; fração de extinção = mu / lambda. Rótulos ocultos podem trocar entre ajustes. As taxas usam unidades de comprimento de ramo."],
"Compare only models refitted in this card with the same data and likelihood settings. Do not combine AIC values from other cards.":["Compare solo modelos reajustados en esta tarjeta con los mismos datos y configuración de verosimilitud. No combine AIC de otras tarjetas.", "Compare apenas modelos reajustados neste cartão com os mesmos dados e ajustes de verossimilhança. Não combine AIC de outros cartões."],
"Select a binary trait and run hidden-state models.":["Seleccione un carácter binario y ejecute modelos de estados ocultos.", "Selecione um caráter binário e execute modelos de estados ocultos."],
"Hidden-state inputs changed. Run again to update results.":["Las entradas de estados ocultos cambiaron. Ejecute de nuevo para actualizar resultados.", "As entradas de estados ocultos mudaram. Execute novamente para atualizar resultados."],
"Fitting Hidden-state models":["Ajustando modelos de estados ocultos", "Ajustando modelos de estados ocultos"],
"Hidden-state fitting finished. Review finite fits, starts and backend limitations.":["Ajuste de estados ocultos terminado. Revise ajustes finitos, inicios y limitaciones del motor.", "Ajuste de estados ocultos concluído. Revise ajustes finitos, inícios e limitações do motor."],
"No finite hidden-state fit. Inspect diagnostics.":["No hay ajuste finito de estados ocultos. Revise diagnósticos.", "Nenhum ajuste finito de estados ocultos. Revise diagnósticos."],
"Hidden-state analysis completed.":["Análisis de estados ocultos completado.", "Análise de estados ocultos concluída."],
"AIC differences are provisional. Optimizer termination status is unavailable; no model weights are reported.":["Las diferencias de AIC son provisionales. El estado de terminación del optimizador no está disponible; no se informan pesos de modelos.", "As diferenças de AIC são provisórias. O estado de término do otimizador não está disponível; não são informados pesos de modelos."],
"Install the hisse R package to run hidden-state models.":["Instale el paquete R hisse para ejecutar modelos de estados ocultos.", "Instale o pacote R hisse para executar modelos de estados ocultos."],
"Invalid hidden-state model settings.":["Configuración de modelo de estados ocultos no válida.", "Configurações de modelo de estados ocultos inválidas."],
"Invalid parameter index vector.":["Vector de índices de parámetros no válido.", "Vetor de índices de parâmetros inválido."],
"Use consecutive parameter indices; zero is allowed only for extinction fractions.":["Use índices consecutivos; cero solo se permite para fracciones de extinción.", "Use índices consecutivos; zero é permitido apenas para frações de extinção."],
"Invalid hidden-state transition matrix.":["Matriz de transición de estados ocultos no válida.", "Matriz de transição de estados ocultos inválida."],
"Only single observed-state or hidden-class changes are supported; use zero elsewhere.":["Solo se admiten cambios simples de estado observado o clase oculta; use cero en las otras entradas.", "Apenas mudanças simples de estado observado ou classe oculta são suportadas; use zero nas demais entradas."],
"Transition indices must be consecutive positive integers; zero forbids a transition.":["Los índices de transición deben ser enteros positivos consecutivos; cero prohíbe una transición.", "Os índices de transição devem ser inteiros positivos consecutivos; zero proíbe uma transição."],
"Select supported hidden-state models.":["Seleccione modelos de estados ocultos admitidos.", "Selecione modelos de estados ocultos suportados."],
"Invalid hidden-state sampling or root settings.":["Configuración de muestreo o raíz de estados ocultos no válida.", "Configurações de amostragem ou raiz de estados ocultos inválidas."],
"Invalid hidden-state optimizer settings.":["Configuración del optimizador de estados ocultos no válida.", "Configurações do otimizador de estados ocultos inválidas."],
"Starts must be positive and below finite upper bounds.":["Los inicios deben ser positivos y menores que límites superiores finitos.", "Os inícios devem ser positivos e menores que limites superiores finitos."],
"Hidden classes are latent rate categories, not identified biological traits. No uncertainty intervals or calibrated likelihood-ratio tests are provided.":["Las clases ocultas son categorías latentes de tasas, no caracteres biológicos identificados. No se proporcionan intervalos de incertidumbre ni pruebas calibradas de razón de verosimilitud.", "As classes ocultas são categorias latentes de taxas, não caracteres biológicos identificados. Não são fornecidos intervalos de incerteza nem testes calibrados de razão de verossimilhança."],
"A hidden-state parameter reached a bound. Inspect identifiability and bounds.":["Un parámetro de estados ocultos alcanzó un límite. Revise identificabilidad y límites.", "Um parâmetro de estados ocultos atingiu um limite. Revise identificabilidade e limites."],
"Hidden-state starts disagree. Increase search effort before interpreting model differences.":["Los inicios de estados ocultos discrepan. Aumente la búsqueda antes de interpretar diferencias entre modelos.", "Os inícios de estados ocultos discordam. Aumente a busca antes de interpretar diferenças entre modelos."],
"HiSSE fits worse than its CID-2 submodel. Increase search effort before interpretation.":["HiSSE se ajusta peor que su submodelo CID-2. Aumente la búsqueda antes de interpretar.", "HiSSE ajusta pior que seu submodelo CID-2. Aumente a busca antes de interpretar."],
"Select a supported hidden-state graph.":["Seleccione un gráfico de estados ocultos admitido.", "Selecione um gráfico de estados ocultos suportado."],
"Finite likelihoods; optimizer termination status is unavailable":["Verosimilitudes finitas; terminación del optimizador no disponible", "Verossimilhanças finitas; término do otimizador indisponível"],
"Hidden categories are not identified biological traits":["Las categorías ocultas no son caracteres biológicos identificados", "As categorias ocultas não são caracteres biológicos identificados"],
"Destination state":["Estado de destino", "Estado de destino"],
"Source state":["Estado de origen", "Estado de origem"],
"Turnover":["Recambio", "Renovação"],
"ExtinctionFraction":["Fracción de extinción", "Fração de extinção"],
"Speciation":["Especiación", "Especiação"],
"Extinction":["Extinción", "Extinção"],
"NetDiversification":["Diversificación neta", "Diversificação líquida"],
"Finite":["Finito", "Finito"],
"Tied QuaSSE rates have incompatible fixed values or bounds.":["Las tasas QuaSSE ligadas tienen valores fijos o límites incompatibles.", "As taxas QuaSSE ligadas têm valores fixos ou limites incompatíveis."],
"A QuaSSE rate reached a bound. Inspect bounds and identifiability before interpretation.":["Una tasa QuaSSE alcanzó un límite. Revise límites e identificabilidad antes de interpretar.", "Uma taxa QuaSSE atingiu um limite. Revise limites e identificabilidade antes de interpretar."],
"QuaSSE likelihood changed under tighter integration tolerance. Ranking weights are withheld.":["La verosimilitud QuaSSE cambió con una tolerancia de integración más estricta. Se omiten los pesos.", "A verossimilhança QuaSSE mudou com tolerância de integração mais rigorosa. Os pesos são omitidos."],
"QuaSSE starts disagree or an unconverged attempt is better. Refit before interpreting model support.":["Los inicios de QuaSSE discrepan o un intento sin convergencia es mejor. Reajuste antes de interpretar el soporte.", "Os inícios de QuaSSE discordam ou uma tentativa sem convergência é melhor. Reajuste antes de interpretar o suporte."],
"Invalid QuaSSE graph settings.":["Configuración gráfica QuaSSE no válida.", "Configurações gráficas QuaSSE inválidas."],
"Non-finite QuaSSE likelihood.":["Verosimilitud QuaSSE no finita.", "Verossimilhança QuaSSE não finita."],
"Run QuaSSE":["Ejecutar QuaSSE", "Executar QuaSSE"],
"Measurement-error column":["Columna de error de medición", "Coluna de erro de medição"],
"Common standard error":["Error estándar común", "Erro padrão comum"],
"Common measurement standard error":["Error estándar de medición común", "Erro padrão de medição comum"],
"Supply standard errors of trait means in trait units. The common value is used only when no error column is selected; zero and missing errors are unsupported.":["Indique errores estándar de las medias en unidades del carácter. El valor común se usa solo sin columna de error; no se admiten ceros ni valores faltantes.", "Informe erros padrão das médias nas unidades do caráter. O valor comum é usado apenas sem coluna de erro; zeros e valores ausentes não são aceitos."],
"Speciation function":["Función de especiación", "Função de especiação"],
"Extinction function":["Función de extinción", "Função de extinção"],
"Compare with constant rates":["Comparar con tasas constantes", "Comparar com taxas constantes"],
"Constant":["Constante", "Constante"],
"Exponential":["Exponencial", "Exponencial"],
"Sigmoid":["Sigmoide", "Sigmoide"],
"Selected":["Seleccionado", "Selecionado"],
"Constant: c. Exponential: base * exp(slope * x). Sigmoid: y0 + (y1-y0) * plogis(r * (x-xmid)). Drift is fixed at zero by default; edit Fixed to estimate it.":["Constante: c. Exponencial: base * exp(slope * x). Sigmoide: y0 + (y1-y0) * plogis(r * (x-xmid)). La deriva se fija en cero inicialmente; edite Fixed para estimarla.", "Constante: c. Exponencial: base * exp(slope * x). Sigmoide: y0 + (y1-y0) * plogis(r * (x-xmid)). A deriva é fixada em zero inicialmente; edite Fixed para estimá-la."],
"Sampling fraction":["Fracción de muestreo", "Fração de amostragem"],
"Flat (ROOT.FLAT)":["Uniforme (ROOT.FLAT)", "Uniforme (ROOT.FLAT)"],
"Normal density (ROOT.GIVEN)":["Densidad normal (ROOT.GIVEN)", "Densidade normal (ROOT.GIVEN)"],
"Given root mean":["Media de raíz especificada", "Média da raiz especificada"],
"Given root standard deviation":["Desviación estándar de raíz especificada", "Desvio padrão da raiz especificado"],
"Given root settings apply only to ROOT.GIVEN. ROOT.OBS is likelihood-based; ROOT.FLAT is uniform on the numerical domain. Root settings are shared across candidates.":["Los ajustes de raíz especificados se usan solo en ROOT.GIVEN. ROOT.OBS se basa en verosimilitud; ROOT.FLAT es uniforme en el dominio numérico. Los candidatos comparten estos ajustes.", "Os ajustes da raiz especificados são usados apenas em ROOT.GIVEN. ROOT.OBS se baseia na verossimilhança; ROOT.FLAT é uniforme no domínio numérico. Os candidatos compartilham esses ajustes."],
"QuaSSE parameter table (CSV)":["Tabla de parámetros QuaSSE (CSV)", "Tabela de parâmetros QuaSSE (CSV)"],
"Columns: Parameter,Group,Fixed,Start,Lower,Upper. Equal groups tie parameters; numeric Fixed fixes the group. Signed slopes, midpoints and drift are allowed; diffusion must be positive. Clear the table after changing rate functions.":["Columnas: Parameter,Group,Fixed,Start,Lower,Upper. Grupos iguales ligan parámetros; Fixed numérico fija el grupo. Pendientes, puntos medios y deriva admiten signos; difusión debe ser positiva. Borre la tabla al cambiar funciones de tasas.", "Colunas: Parameter,Group,Fixed,Start,Lower,Upper. Grupos iguais vinculam parâmetros; Fixed numérico fixa o grupo. Inclinações, pontos médios e deriva admitem sinais; difusão deve ser positiva. Limpe a tabela ao alterar funções de taxas."],
"Numerical integration controls":["Controles de integración numérica", "Controles de integração numérica"],
"FFT backend":["Motor FFT", "Motor FFT"],
"Trait grid bins":["Celdas de la malla del carácter", "Células da grade do caráter"],
"Tip resolution multiplier":["Multiplicador de resolución en puntas", "Multiplicador da resolução nas pontas"],
"Maximum time step / tree depth":["Paso temporal máximo / profundidad del árbol", "Passo temporal máximo / profundidade da árvore"],
"Resolution switch / tree depth":["Cambio de resolución / profundidad del árbol", "Mudança de resolução / profundidade da árvore"],
"Trait range multiplier":["Multiplicador del rango del carácter", "Multiplicador da amplitude do caráter"],
"Grid midpoint (blank = observed midpoint)":["Centro de malla (vacío = centro observado)", "Centro da grade (vazio = centro observado)"],
"Convolution width (standard deviations)":["Ancho de convolución (desviaciones estándar)", "Largura da convolução (desvios padrão)"],
"Integrate tips together (fftC only)":["Integrar puntas juntas (solo fftC)", "Integrar pontas juntas (apenas fftC)"],
"Every fit is checked with twice the grid bins and half the time step. Unstable likelihoods suppress model weights. Increase resolution and refit when diagnostics fail.":["Cada ajuste se verifica duplicando las celdas y reduciendo a la mitad el paso temporal. La inestabilidad suprime pesos de modelos. Aumente resolución y reajuste si fallan los diagnósticos.", "Cada ajuste é verificado duplicando células e reduzindo pela metade o passo temporal. A instabilidade suprime pesos dos modelos. Aumente a resolução e reajuste se os diagnósticos falharem."],
"Rates versus trait":["Tasas frente al carácter", "Taxas em função do caráter"],
"Traits and measurement errors":["Caracteres y errores de medición", "Caracteres e erros de medição"],
"Rates use branch-length units; drift uses trait units per branch-length unit and diffusion uses squared trait units per branch-length unit. Curves cover the observed trait range only.":["Las tasas usan unidades de longitud de rama; la deriva usa unidades del carácter por unidad de rama y la difusión unidades del carácter al cuadrado por unidad de rama. Las curvas cubren solo el rango observado.", "As taxas usam unidades de comprimento de ramo; a deriva usa unidades do caráter por unidade de ramo e a difusão unidades do caráter ao quadrado por unidade de ramo. As curvas cobrem apenas a amplitude observada."],
"Select a continuous trait and run QuaSSE.":["Seleccione un carácter continuo y ejecute QuaSSE.", "Selecione um caráter contínuo e execute QuaSSE."],
"QuaSSE inputs changed. Run again to update results.":["Las entradas QuaSSE cambiaron. Ejecute de nuevo para actualizar resultados.", "As entradas QuaSSE mudaram. Execute novamente para atualizar resultados."],
"Fitting QuaSSE models":["Ajustando modelos QuaSSE", "Ajustando modelos QuaSSE"],
"QuaSSE completed. Review convergence and grid sensitivity.":["QuaSSE completado. Revise convergencia y sensibilidad a la malla.", "QuaSSE concluído. Revise convergência e sensibilidade à grade."],
"No valid QuaSSE fit. Inspect diagnostics.":["No hay ajuste QuaSSE válido. Revise los diagnósticos.", "Nenhum ajuste QuaSSE válido. Revise os diagnósticos."],
"QuaSSE analysis completed.":["Análisis QuaSSE completado.", "Análise QuaSSE concluída."],
"QuaSSE ranking weights are unavailable. Inspect individual fits and diagnostics.":["Los pesos QuaSSE no están disponibles. Revise ajustes individuales y diagnósticos.", "Os pesos QuaSSE não estão disponíveis. Revise ajustes individuais e diagnósticos."],
"Select supported QuaSSE rate functions.":["Seleccione funciones de tasas QuaSSE admitidas.", "Selecione funções de taxas QuaSSE suportadas."],
"QuaSSE requires a resolved binary tree with at least four tips.":["QuaSSE requiere un árbol binario resuelto con al menos cuatro puntas.", "QuaSSE exige uma árvore binária resolvida com pelo menos quatro pontas."],
"Select separate taxon and continuous-trait columns.":["Seleccione columnas distintas de taxón y carácter continuo.", "Selecione colunas distintas de táxon e caráter contínuo."],
"Match tree and trait taxa explicitly in Data before QuaSSE.":["Haga coincidir taxones del árbol y la tabla en Datos antes de QuaSSE.", "Faça corresponder táxons da árvore e tabela em Dados antes de QuaSSE."],
"QuaSSE requires finite, nonconstant continuous observations.":["QuaSSE requiere observaciones continuas finitas y no constantes.", "QuaSSE exige observações contínuas finitas e não constantes."],
"Select a valid measurement-error column.":["Seleccione una columna válida de error de medición.", "Selecione uma coluna válida de erro de medição."],
"QuaSSE measurement standard errors must be positive and finite.":["Los errores estándar de medición QuaSSE deben ser positivos y finitos.", "Os erros padrão de medição QuaSSE devem ser positivos e finitos."],
"Invalid QuaSSE integration settings.":["Configuración de integración QuaSSE no válida.", "Configurações de integração QuaSSE inválidas."],
"The QuaSSE grid must contain all observed trait values.":["La malla QuaSSE debe contener todos los valores observados.", "A grade QuaSSE deve conter todos os valores observados."],
"Invalid QuaSSE parameter table.":["Tabla de parámetros QuaSSE no válida.", "Tabela de parâmetros QuaSSE inválida."],
"QuaSSE starts, fixed parameters and bounds are inconsistent.":["Inicios, parámetros fijos y límites QuaSSE son inconsistentes.", "Inícios, parâmetros fixos e limites QuaSSE são inconsistentes."],
"Invalid QuaSSE sampling or root settings.":["Configuración de muestreo o raíz QuaSSE no válida.", "Configurações de amostragem ou raiz QuaSSE inválidas."],
"QuaSSE backend parameter order is incompatible.":["El orden de parámetros del motor QuaSSE es incompatible.", "A ordem dos parâmetros do motor QuaSSE é incompatível."],
"Invalid QuaSSE optimizer settings.":["Configuración del optimizador QuaSSE no válida.", "Configurações do otimizador QuaSSE inválidas."],
"QuaSSE is exploratory: hidden rate heterogeneity can mimic trait dependence. No uncertainty intervals or hidden-state null models are provided.":["QuaSSE es exploratorio: heterogeneidad oculta de tasas puede imitar dependencia del carácter. No se proporcionan intervalos de incertidumbre ni modelos nulos de estados ocultos.", "QuaSSE é exploratório: heterogeneidade oculta de taxas pode imitar dependência do caráter. Não são fornecidos intervalos de incerteza nem modelos nulos de estados ocultos."],
"Measurement errors are standard errors of trait means, in the supplied trait units. They are treated as known.":["Los errores de medición son errores estándar de las medias en las unidades suministradas y se consideran conocidos.", "Os erros de medição são erros padrão das médias nas unidades fornecidas e são considerados conhecidos."],
"Grid and time-step sensitivity checks evaluate fitted parameters without refitting. They do not guarantee numerical convergence.":["Las verificaciones de malla y paso temporal evalúan parámetros ajustados sin reajustar. No garantizan convergencia numérica.", "As verificações de grade e passo temporal avaliam parâmetros ajustados sem reajuste. Não garantem convergência numérica."],
"The tip grid is coarser than a measurement standard error. Increase resolution; model weights are withheld.":["La malla en puntas es más gruesa que un error estándar de medición. Aumente resolución; se retienen los pesos de modelos.", "A grade nas pontas é mais grossa que um erro padrão de medição. Aumente a resolução; os pesos dos modelos são omitidos."],
"Select a supported QuaSSE graph.":["Seleccione un gráfico QuaSSE admitido.", "Selecione um gráfico QuaSSE suportado."],
"Observed traits and measurement standard errors":["Caracteres observados y errores estándar de medición", "Caracteres observados e erros padrão de medição"],
"Bars show plus/minus one measurement standard error, not confidence intervals.":["Las barras muestran más/menos un error estándar de medición, no intervalos de confianza.", "As barras mostram mais/menos um erro padrão de medição, não intervalos de confiança."],
"QuaSSE likelihood changed after grid-normalized refinement. Model weights are withheld.":["La verosimilitud QuaSSE cambió tras refinar y normalizar la malla. Se omiten los pesos de modelos.", "A verossimilhança QuaSSE mudou após refinar e normalizar a grade. Os pesos dos modelos são omitidos."],
"Refined likelihoods account for the backend grid-spacing constant under survival conditioning. Raw refined values and the adjustment are shown separately; compare AIC only within this run.":["Las verosimilitudes refinadas consideran la constante del espaciado de malla del motor al condicionar por supervivencia. Se muestran valores brutos y ajuste por separado; compare AIC solo dentro de esta ejecución.", "As verossimilhanças refinadas consideram a constante do espaçamento da grade do motor ao condicionar por sobrevivência. Valores brutos e ajuste são mostrados separadamente; compare AIC apenas nesta execução."],
"RawRefinedLogLik":["LogLik refinado bruto", "LogLik refinado bruto"],
"GridNormalizationAdjustment":["Ajuste de normalización de malla", "Ajuste de normalização da grade"],
"Download estimates CSV":["Descargar estimaciones CSV", "Baixar estimativas CSV"],
"MuSSE parameter table (CSV)":["Tabla de parámetros MuSSE (CSV)", "Tabela de parâmetros MuSSE (CSV)"],
"Run MuSSE":["Ejecutar MuSSE", "Executar MuSSE"],
"MuSSE support is exploratory: unmodeled rate heterogeneity can mimic trait dependence. Hidden-state null models are not yet implemented.":["El soporte de MuSSE es exploratorio: la heterogeneidad de tasas no modelada puede imitar dependencia del carácter. Los modelos nulos de estados ocultos aún no están implementados.", "O suporte de MuSSE é exploratório: heterogeneidade de taxas não modelada pode imitar dependência do caráter. Modelos nulos de estados ocultos ainda não estão implementados."],
"MuSSE inputs changed. Run again to update results.":["Las entradas de MuSSE cambiaron. Ejecute de nuevo para actualizar resultados.", "As entradas de MuSSE mudaram. Execute novamente para atualizar resultados."],
"Fitting MuSSE models":["Ajustando modelos MuSSE", "Ajustando modelos MuSSE"],
"MuSSE completed. Review convergence, bounds and model assumptions.":["MuSSE completado. Revise convergencia, límites y supuestos del modelo.", "MuSSE concluído. Revise convergência, limites e pressupostos do modelo."],
"No valid MuSSE fit. Inspect diagnostics.":["No hay ajuste MuSSE válido. Revise los diagnósticos.", "Nenhum ajuste MuSSE válido. Revise os diagnósticos."],
"MuSSE analysis completed.":["Análisis MuSSE completado.", "Análise MuSSE concluída."],
"MuSSE ranking weights are unavailable. Inspect individual fits and diagnostics.":["Los pesos de clasificación MuSSE no están disponibles. Revise ajustes individuales y diagnósticos.", "Os pesos de classificação MuSSE não estão disponíveis. Revise ajustes individuais e diagnósticos."],
"MuSSE requires a resolved binary tree with at least four tips.":["MuSSE requiere un árbol binario resuelto con al menos cuatro puntas.", "MuSSE exige uma árvore binária resolvida com pelo menos quatro pontas."],
"Match tree and trait taxa explicitly in Data before MuSSE.":["Haga coincidir explícitamente los taxones del árbol y la tabla en Datos antes de MuSSE.", "Faça corresponder explicitamente os táxons da árvore e da tabela em Dados antes de MuSSE."],
"Invalid MuSSE parameter table.":["Tabla de parámetros MuSSE no válida.", "Tabela de parâmetros MuSSE inválida."],
"MuSSE starts and fixed rates must respect finite nonnegative bounds.":["Los inicios y tasas fijas de MuSSE deben respetar límites finitos no negativos.", "Os inícios e taxas fixas de MuSSE devem respeitar limites finitos não negativos."],
"Select supported MuSSE models.":["Seleccione modelos MuSSE admitidos.", "Selecione modelos MuSSE suportados."],
"Tied MuSSE rates have incompatible fixed values or bounds.":["Las tasas MuSSE ligadas tienen valores fijos o límites incompatibles.", "As taxas MuSSE ligadas têm valores fixos ou limites incompatíveis."],
"Invalid MuSSE likelihood settings.":["Configuración de verosimilitud MuSSE no válida.", "Configurações de verossimilhança MuSSE inválidas."],
"Invalid MuSSE optimizer settings.":["Configuración del optimizador MuSSE no válida.", "Configurações do otimizador MuSSE inválidas."],
"Invalid MuSSE integration settings.":["Configuración de integración MuSSE no válida.", "Configurações de integração MuSSE inválidas."],
"A MuSSE rate reached a bound. Inspect bounds and identifiability before interpretation.":["Una tasa MuSSE alcanzó un límite. Revise límites e identificabilidad antes de interpretar.", "Uma taxa MuSSE atingiu um limite. Revise limites e identificabilidade antes de interpretar."],
"MuSSE likelihood changed under tighter integration tolerance. Ranking weights are withheld.":["La verosimilitud MuSSE cambió con una tolerancia de integración más estricta. Se omiten los pesos.", "A verossimilhança MuSSE mudou com tolerância de integração mais rigorosa. Os pesos são omitidos."],
"MuSSE starts disagree or an unconverged attempt is better. Refit before interpreting model support.":["Los inicios de MuSSE discrepan o un intento sin convergencia es mejor. Reajuste antes de interpretar el soporte.", "Os inícios de MuSSE discordam ou uma tentativa sem convergência é melhor. Reajuste antes de interpretar o suporte."],
"Invalid MuSSE graph settings.":["Configuración gráfica MuSSE no válida.", "Configurações gráficas MuSSE inválidas."],
"MuSSE transition rates":["Tasas de transición MuSSE", "Taxas de transição MuSSE"],
"Discrete trait":["Carácter discreto", "Caráter discreto"],
"Fill state table":["Completar tabla de estados", "Preencher tabela de estados"],
"MuSSE state table (CSV)":["Tabla de estados MuSSE (CSV)", "Tabela de estados MuSSE (CSV)"],
"Columns: State,Sampling,RootWeight. Every observed state must occur once. Row order defines codes 1 to k. Blank uses sorted observed states, complete sampling and equal root weights. RootWeight is used only with ROOT.GIVEN.":["Columnas: State,Sampling,RootWeight. Cada estado observado debe aparecer una vez. El orden de filas define códigos de 1 a k. En blanco se usan estados ordenados, muestreo completo y pesos de raíz iguales. RootWeight se usa solo con ROOT.GIVEN.", "Colunas: State,Sampling,RootWeight. Cada estado observado deve aparecer uma vez. A ordem das linhas define códigos de 1 a k. Em branco, usam-se estados ordenados, amostragem completa e pesos da raiz iguais. RootWeight é usado apenas com ROOT.GIVEN."],
"MuSSE treats each label as one categorical state, not as polymorphism or uncertainty. Two to eight observed states are supported.":["MuSSE trata cada etiqueta como un estado categórico, no como polimorfismo o incertidumbre. Se admiten de dos a ocho estados observados.", "MuSSE trata cada rótulo como um estado categórico, não como polimorfismo ou incerteza. São suportados de dois a oito estados observados."],
"The default comparison shares one transition rate across states. Full and other constraints remain selectable.":["La comparación predeterminada comparte una tasa de transición entre estados. Completo y otras restricciones siguen disponibles.", "A comparação padrão compartilha uma taxa de transição entre estados. Completo e outras restrições continuam disponíveis."],
"Equilibrium-root weighting is unavailable in the installed multistate backend.":["La ponderación de raíz en equilibrio no está disponible en el motor multiestado instalado.", "A ponderação da raiz em equilíbrio não está disponível no mecanismo multiestado instalado."],
"Columns: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda1 through lambdak, mu1 through muk, and qij for directed transitions (source i, destination j). Blank uses tree-scaled defaults. Group and Fixed apply only to Custom; preset models use their own constraints. Shared Group values tie rates; a numeric Fixed value fixes the whole group.":["Columnas: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda1 a lambdak, mu1 a muk y qij para transiciones dirigidas (origen i, destino j). En blanco se usan valores ajustados al árbol. Group y Fixed solo se aplican a Personalizado. Un mismo Group iguala tasas; un Fixed numérico fija todo el grupo.", "Colunas: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda1 a lambdak, mu1 a muk e qij para transições direcionadas (origem i, destino j). Em branco, usam-se valores ajustados à árvore. Group e Fixed aplicam-se apenas a Personalizado. O mesmo Group iguala taxas; um Fixed numérico fixa todo o grupo."],
"lambdai is speciation, mui is extinction, and qij is the transition from state i to j. Rates are per branch-length unit.":["lambdai es especiación, mui es extinción y qij es la transición del estado i al j. Las tasas son por unidad de longitud de rama.", "lambdai é especiação, mui é extinção e qij é a transição do estado i para j. As taxas são por unidade de comprimento de ramo."],
"Equal diversification and transitions":["Diversificación y transiciones iguales", "Diversificação e transições iguais"],
"Symmetric transitions":["Transiciones simétricas", "Transições simétricas"],
"MuSSE supports two to eight observed states.":["MuSSE admite de dos a ocho estados observados.", "MuSSE suporta de dois a oito estados observados."],
"Select a discrete trait for MuSSE.":["Seleccione un carácter discreto para MuSSE.", "Selecione um caráter discreto para MuSSE."],
"Select a discrete trait and run MuSSE.":["Seleccione un carácter discreto y ejecute MuSSE.", "Selecione um caráter discreto e execute MuSSE."],
"MuSSE requires nonmissing finite categorical observations.":["MuSSE requiere observaciones categóricas finitas sin valores faltantes.", "MuSSE exige observações categóricas finitas sem valores ausentes."],
"Invalid MuSSE state table.":["Tabla de estados MuSSE no válida.", "Tabela de estados MuSSE inválida."],
"The MuSSE state table must list each observed state exactly once.":["La tabla MuSSE debe incluir cada estado observado exactamente una vez.", "A tabela MuSSE deve incluir cada estado observado exatamente uma vez."],
"MuSSE sampling fractions must be greater than zero and at most one.":["Las fracciones de muestreo MuSSE deben ser mayores que cero y como máximo uno.", "As frações de amostragem MuSSE devem ser maiores que zero e no máximo um."],
"Select separate taxon and discrete-trait columns.":["Seleccione columnas diferentes para taxones y carácter discreto.", "Selecione colunas diferentes para táxons e caráter discreto."],
"MuSSE supports observed, equal or given root weights; equilibrium roots are unavailable.":["MuSSE admite pesos de raíz observados, iguales o especificados; no admite raíces en equilibrio.", "MuSSE suporta pesos da raiz observados, iguais ou especificados; raízes em equilíbrio não estão disponíveis."],
"MuSSE backend parameter order is incompatible.":["El orden de parámetros del motor MuSSE es incompatible.", "A ordem dos parâmetros do mecanismo MuSSE é incompatível."],
"Few taxa or imbalanced states can give weakly identified rates. This is a screening warning, not a sufficiency threshold.":["Pocos taxones o estados desequilibrados pueden producir tasas débilmente identificadas. Esta advertencia no define un umbral de suficiencia.", "Poucos táxons ou estados desequilibrados podem produzir taxas fracamente identificadas. Este aviso não define um limiar de suficiência."],
"A candidate has at least as many free rates as observed tips. Interpretability is severely limited.":["Un candidato tiene al menos tantas tasas libres como puntas observadas. La interpretación está muy limitada.", "Um candidato tem pelo menos tantas taxas livres quanto pontas observadas. A interpretação é muito limitada."],
"Destination state code":["Código del estado de destino", "Código do estado de destino"],
"Source state code":["Código del estado de origen", "Código do estado de origem"],
"Sampling":["Muestreo", "Amostragem"],
"RootWeight":["Peso de raíz", "Peso da raiz"],
"Non-finite MuSSE likelihood.":["Verosimilitud MuSSE no finita.", "Verossimilhança MuSSE não finita."],
"The full MuSSE model fits worse than a constrained candidate. Increase starts or refine bounds.":["El modelo MuSSE completo ajusta peor que un candidato restringido. Aumente los inicios o refine los límites.", "O modelo MuSSE completo ajusta pior que um candidato restrito. Aumente os inícios ou refine os limites."],
"Non-finite BiSSE likelihood.":["Verosimilitud BiSSE no finita.","Verossimilhança BiSSE não finita."],
"ROOT.OBS uses likelihood-based root weights, not tip frequencies. Root treatment is shared by all candidates.":["ROOT.OBS usa pesos de raíz basados en la verosimilitud, no frecuencias de puntas. Todos los candidatos comparten el tratamiento de raíz.", "ROOT.OBS usa pesos da raiz baseados na verossimilhança, não frequências de pontas. Todos os candidatos compartilham o tratamento da raiz."],
"The full BiSSE model fits worse than a constrained candidate. Increase starts or refine bounds.":["El modelo BiSSE completo ajusta peor que un candidato restringido. Aumente los inicios o refine los límites.", "O modelo BiSSE completo ajusta pior que um candidato restrito. Aumente os inícios ou refine os limites."],
"Lower":["Inferior", "Inferior"],
"Upper":["Superior", "Superior"],
"Hidden-state and null models":["Modelos de estados ocultos y nulos", "Modelos de estados ocultos e nulos"],
"This SSE method is planned and has no implemented engine.":["Este método SSE está planificado y aún no tiene motor implementado.", "Este método SSE está planejado e ainda não tem mecanismo implementado."],
"Full":["Completo", "Completo"],
"Equal speciation":["Especiación igual", "Especiação igual"],
"Equal extinction":["Extinción igual", "Extinção igual"],
"Equal transitions":["Transiciones iguales", "Transições iguais"],
"Trait-independent diversification":["Diversificación independiente del carácter", "Diversificação independente do caráter"],
"No extinction":["Sin extinción", "Sem extinção"],
"Custom":["Personalizado", "Personalizado"],
"Binary trait":["Carácter binario", "Caráter binário"],
"Observed value coded as state 0":["Valor observado codificado como estado 0", "Valor observado codificado como estado 0"],
"The other observed value is coded as state 1. Resolve taxon mismatches in Data.":["El otro valor observado se codifica como estado 1. Resuelva las discrepancias de taxones en Datos.", "O outro valor observado é codificado como estado 1. Resolva as diferenças de táxons em Dados."],
"Sampling fraction for state 0":["Fracción de muestreo para el estado 0", "Fração de amostragem para o estado 0"],
"Sampling fraction for state 1":["Fracción de muestreo para el estado 1", "Fração de amostragem para o estado 1"],
"Sampling assumes random inclusion within each state; fractions are treated as known.":["El muestreo supone inclusión aleatoria dentro de cada estado; las fracciones se consideran conocidas.", "A amostragem pressupõe inclusão aleatória dentro de cada estado; as frações são consideradas conhecidas."],
"Root treatment":["Tratamiento de la raíz", "Tratamento da raiz"],
"Observed (ROOT.OBS)":["Observado (ROOT.OBS)", "Observado (ROOT.OBS)"],
"Equal (ROOT.FLAT)":["Igual (ROOT.FLAT)", "Igual (ROOT.FLAT)"],
"Equilibrium (ROOT.EQUI)":["Equilibrio (ROOT.EQUI)", "Equilíbrio (ROOT.EQUI)"],
"Given (ROOT.GIVEN)":["Especificado (ROOT.GIVEN)", "Especificado (ROOT.GIVEN)"],
"Root probability for state 0":["Probabilidad de raíz para el estado 0", "Probabilidade da raiz para o estado 0"],
"Fill parameter table":["Completar tabla de parámetros", "Preencher tabela de parâmetros"],
"BiSSE parameter table (CSV)":["Tabla de parámetros BiSSE (CSV)", "Tabela de parâmetros BiSSE (CSV)"],
"Columns: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda0, lambda1, mu0, mu1, q01, q10. Blank uses tree-scaled defaults. Group and Fixed apply only to Custom; preset models use their own constraints. Shared Group values tie rates; a numeric Fixed value fixes the whole group.":["Columnas: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda0, lambda1, mu0, mu1, q01, q10. En blanco se usan valores ajustados a la escala del árbol. Group y Fixed solo se aplican a Personalizado; los modelos predefinidos usan sus propias restricciones. Un mismo Group iguala tasas; un Fixed numérico fija todo el grupo.", "Colunas: Parameter,Group,Fixed,Start,Lower,Upper. Use lambda0, lambda1, mu0, mu1, q01, q10. Em branco, usam-se valores ajustados à escala da árvore. Group e Fixed aplicam-se apenas a Personalizado; modelos predefinidos usam suas próprias restrições. O mesmo Group iguala taxas; um Fixed numérico fixa todo o grupo."],
"Optimizer starts":["Inicios del optimizador", "Inícios do otimizador"],
"ODE backend":["Motor de EDO", "Mecanismo de EDO"],
"ODE tolerance":["Tolerancia de EDO", "Tolerância de EDO"],
"Integration retry threshold (eps)":["Umbral de reintento de integración (eps)", "Limiar de nova tentativa de integração (eps)"],
"Run BiSSE":["Ejecutar BiSSE", "Executar BiSSE"],
"BiSSE support is exploratory: unmodeled rate heterogeneity can mimic trait dependence. Hidden-state null models are not yet implemented.":["El soporte de BiSSE es exploratorio: la heterogeneidad de tasas no modelada puede imitar dependencia del carácter. Los modelos nulos de estados ocultos aún no están implementados.", "O suporte de BiSSE é exploratório: heterogeneidade de taxas não modelada pode imitar dependência do caráter. Modelos nulos de estados ocultos ainda não estão implementados."],
"Observed tip states":["Estados observados en las puntas", "Estados observados nas pontas"],
"Transition rates":["Tasas de transición", "Taxas de transição"],
"Figure width (inches)":["Ancho de figura (pulgadas)", "Largura da figura (polegadas)"],
"Figure height (inches)":["Alto de figura (pulgadas)", "Altura da figura (polegadas)"],
"lambda is speciation, mu is extinction, q01 and q10 are directional transitions. Rates are per branch-length unit.":["lambda es especiación, mu es extinción, q01 y q10 son transiciones direccionales. Las tasas son por unidad de longitud de rama.", "lambda é especiação, mu é extinção, q01 e q10 são transições direcionais. As taxas são por unidade de comprimento de ramo."],
"AIC compares candidates in this run only. Weights require converged, numerically stable fits with agreement across successful starts. Boundary fits still require caution. No causal conclusion follows from AIC support.":["AIC compara solo candidatos de esta ejecución. Los pesos requieren convergencia, estabilidad numérica y concordancia entre inicios exitosos. Los ajustes en los límites requieren cautela. El soporte AIC no implica causalidad.", "AIC compara apenas candidatos desta execução. Os pesos exigem convergência, estabilidade numérica e concordância entre inícios bem-sucedidos. Ajustes nos limites exigem cautela. Suporte AIC não implica causalidade."],
"Rates condition on one tree, observed states, sampling fractions and root treatment. No confidence intervals or calibrated likelihood-ratio tests are provided.":["Las tasas están condicionadas a un árbol, estados observados, fracciones de muestreo y tratamiento de raíz. No se proporcionan intervalos de confianza ni pruebas calibradas de razón de verosimilitud.", "As taxas são condicionadas a uma árvore, estados observados, frações de amostragem e tratamento da raiz. Não são fornecidos intervalos de confiança nem testes calibrados de razão de verossimilhança."],
"Likelihood slices hold other free rates fixed and respect tied parameters. They are not confidence intervals or nuisance-refitted profiles.":["Los cortes de verosimilitud mantienen fijas las demás tasas libres y respetan parámetros ligados. No son intervalos de confianza ni perfiles con reajuste de parámetros restantes.", "Os cortes de verossimilhança mantêm fixas as demais taxas livres e respeitam parâmetros ligados. Não são intervalos de confiança nem perfis com reajuste dos parâmetros restantes."],
"Effective parameter constraints":["Restricciones efectivas de parámetros", "Restrições efetivas dos parâmetros"],
"Select a binary trait and run BiSSE.":["Seleccione un carácter binario y ejecute BiSSE.", "Selecione um caráter binário e execute BiSSE."],
"BiSSE inputs changed. Run again to update results.":["Las entradas de BiSSE cambiaron. Ejecute de nuevo para actualizar resultados.", "As entradas de BiSSE mudaram. Execute novamente para atualizar resultados."],
"Fitting BiSSE models":["Ajustando modelos BiSSE", "Ajustando modelos BiSSE"],
"BiSSE completed. Review convergence, bounds and model assumptions.":["BiSSE completado. Revise convergencia, límites y supuestos del modelo.", "BiSSE concluído. Revise convergência, limites e pressupostos do modelo."],
"No valid BiSSE fit. Inspect diagnostics.":["No hay ajuste BiSSE válido. Revise los diagnósticos.", "Nenhum ajuste BiSSE válido. Revise os diagnósticos."],
"BiSSE analysis completed.":["Análisis BiSSE completado.", "Análise BiSSE concluída."],
"BiSSE ranking weights are unavailable. Inspect individual fits and diagnostics.":["Los pesos de clasificación BiSSE no están disponibles. Revise ajustes individuales y diagnósticos.", "Os pesos de classificação BiSSE não estão disponíveis. Revise ajustes individuais e diagnósticos."],
"BiSSE requires a resolved binary tree with at least four tips.":["BiSSE requiere un árbol binario resuelto con al menos cuatro puntas.", "BiSSE exige uma árvore binária resolvida com pelo menos quatro pontas."],
"Select a taxon column and a binary trait.":["Seleccione una columna de taxones y un carácter binario.", "Selecione uma coluna de táxons e um caráter binário."],
"Match tree and trait taxa explicitly in Data before BiSSE.":["Haga coincidir explícitamente los taxones del árbol y la tabla en Datos antes de BiSSE.", "Faça corresponder explicitamente os táxons da árvore e da tabela em Dados antes de BiSSE."],
"BiSSE requires two observed states, no missing values and an explicit state 0.":["BiSSE requiere dos estados observados, sin valores faltantes y un estado 0 explícito.", "BiSSE exige dois estados observados, sem valores ausentes e um estado 0 explícito."],
"Invalid BiSSE parameter table.":["Tabla de parámetros BiSSE no válida.", "Tabela de parâmetros BiSSE inválida."],
"BiSSE starts and fixed rates must respect finite nonnegative bounds.":["Los inicios y tasas fijas de BiSSE deben respetar límites finitos no negativos.", "Os inícios e taxas fixas de BiSSE devem respeitar limites finitos não negativos."],
"Select supported BiSSE models.":["Seleccione modelos BiSSE admitidos.", "Selecione modelos BiSSE suportados."],
"No extinction requires lower bounds of zero for mu.":["Sin extinción requiere límites inferiores de cero para mu.", "Sem extinção exige limites inferiores de zero para mu."],
"Tied BiSSE rates have incompatible fixed values or bounds.":["Las tasas BiSSE ligadas tienen valores fijos o límites incompatibles.", "As taxas BiSSE ligadas têm valores fixos ou limites incompatíveis."],
"Both state sampling fractions must be greater than zero and at most one.":["Ambas fracciones de muestreo deben ser mayores que cero y como máximo uno.", "Ambas as frações de amostragem devem ser maiores que zero e no máximo um."],
"Root probabilities must be nonnegative and sum to one.":["Las probabilidades de raíz deben ser no negativas y sumar uno.", "As probabilidades da raiz devem ser não negativas e somar um."],
"Invalid BiSSE likelihood settings.":["Configuración de verosimilitud BiSSE no válida.", "Configurações de verossimilhança BiSSE inválidas."],
"Invalid BiSSE optimizer settings.":["Configuración del optimizador BiSSE no válida.", "Configurações do otimizador BiSSE inválidas."],
"Invalid BiSSE integration settings.":["Configuración de integración BiSSE no válida.", "Configurações de integração BiSSE inválidas."],
"Few taxa or an imbalanced binary trait can give weakly identified rates. This is a screening warning, not a sufficiency threshold.":["Pocos taxones o un carácter binario desequilibrado pueden producir tasas débilmente identificadas. Esta advertencia no define un umbral de suficiencia.", "Poucos táxons ou um caráter binário desequilibrado podem produzir taxas fracamente identificadas. Este aviso não define um limiar de suficiência."],
"A BiSSE rate reached a bound. Inspect bounds and identifiability before interpretation.":["Una tasa BiSSE alcanzó un límite. Revise límites e identificabilidad antes de interpretar.", "Uma taxa BiSSE atingiu um limite. Revise limites e identificabilidade antes de interpretar."],
"BiSSE likelihood changed under tighter integration tolerance. Ranking weights are withheld.":["La verosimilitud BiSSE cambió con una tolerancia de integración más estricta. Se omiten los pesos.", "A verossimilhança BiSSE mudou com tolerância de integração mais rigorosa. Os pesos são omitidos."],
"BiSSE starts disagree or an unconverged attempt is better. Refit before interpreting model support.":["Los inicios de BiSSE discrepan o un intento sin convergencia es mejor. Reajuste antes de interpretar el soporte.", "Os inícios de BiSSE discordam ou uma tentativa sem convergência é melhor. Reajuste antes de interpretar o suporte."],
"A likelihood slice found a better point. Refit before interpreting model support.":["Un corte de verosimilitud encontró un punto mejor. Reajuste antes de interpretar el soporte.", "Um corte de verossimilhança encontrou um ponto melhor. Reajuste antes de interpretar o suporte."],
"Invalid BiSSE graph settings.":["Configuración gráfica BiSSE no válida.", "Configurações gráficas BiSSE inválidas."],
"Observed tip states; no ancestral reconstruction":["Estados observados en las puntas; sin reconstrucción ancestral", "Estados observados nas pontas; sem reconstrução ancestral"],
"Optimizer start":["Inicio del optimizador", "Início do otimizador"],
"Failed convergence":["Convergencia fallida", "Falha de convergência"],
"Rate per branch-length unit":["Tasa por unidad de longitud de rama", "Taxa por unidade de comprimento de ramo"],
"Point estimates only; uncertainty intervals are not available":["Solo estimaciones puntuales; no hay intervalos de incertidumbre", "Apenas estimativas pontuais; intervalos de incerteza indisponíveis"],
"BiSSE transition rates":["Tasas de transición BiSSE", "Taxas de transição BiSSE"],
"No likelihood slice for this parameter.":["No hay corte de verosimilitud para este parámetro.", "Nenhum corte de verossimilhança para este parâmetro."],
"Likelihood slice: other free rates fixed":["Corte de verosimilitud: otras tasas libres fijas", "Corte de verossimilhança: demais taxas livres fixas"],
"Code":["Código", "Código"],
"State":["Estado", "Estado"],
"Count":["Conteo", "Contagem"],
"Group":["Grupo", "Grupo"],
"Fixed":["Fijo", "Fixo"],
"TighterLogLik":["LogLik más preciso", "LogLik mais preciso"],
"AbsoluteDifference":["Diferencia absoluta", "Diferença absoluta"],
"StartSpread":["Dispersión entre inicios", "Dispersão entre inícios"],
"FailedEvaluations":["Evaluaciones fallidas", "Avaliações com falha"],
"Stable":["Estable", "Estável"],
"Initial":["Inicial", "Inicial"],
"Final":["Final", "Final"],
"Numerical instability: refine the fit before interpreting intervals.":["Inestabilidad numérica: refine el ajuste antes de interpretar intervalos.", "Instabilidade numérica: refine o ajuste antes de interpretar intervalos."],
"Numerical instability":["Inestabilidad numérica", "Instabilidade numérica"],
"Uncertainty model":["Modelo para incertidumbre", "Modelo para incerteza"],
"Profile parameter":["Parámetro del perfil", "Parâmetro do perfil"],
"Profile lower search limit":["Límite inferior de búsqueda del perfil", "Limite inferior de busca do perfil"],
"Profile upper search limit":["Límite superior de búsqueda del perfil", "Limite superior de busca do perfil"],
"Reference level":["Nivel de referencia", "Nível de referência"],
"Refit from multiple starts":["Reajustar desde múltiples valores iniciales", "Reajustar a partir de múltiplos valores iniciais"],
"Start multipliers":["Multiplicadores iniciales", "Multiplicadores iniciais"],
"Parametric bootstrap":["Bootstrap paramétrico", "Bootstrap paramétrico"],
"Seconds per bootstrap replicate":["Segundos por réplica bootstrap", "Segundos por réplica bootstrap"],
"Run uncertainty and robustness":["Ejecutar incertidumbre y robustez", "Executar incerteza e robustez"],
"Run uncertainty and robustness first.":["Ejecute primero incertidumbre y robustez.", "Execute primeiro incerteza e robustez."],
"Robustness refits":["Reajustes de robustez", "Reajustes de robustez"],
"Bootstrap distribution":["Distribución bootstrap", "Distribuição bootstrap"],
"Bootstrap parameter":["Parámetro bootstrap", "Parâmetro bootstrap"],
"Download bootstrap intervals CSV":["Descargar intervalos bootstrap CSV", "Baixar intervalos bootstrap CSV"],
"Failed profile point":["Punto del perfil fallido", "Ponto do perfil com falha"],
"Grid-interpolated crossing":["Cruce interpolado en la grilla", "Cruzamento interpolado na grade"],
"Search limit reached":["Límite de búsqueda alcanzado", "Limite de busca atingido"],
"Better likelihood found":["Se encontró mejor verosimilitud", "Encontrada melhor verossimilhança"],
"Better likelihood found. Refit before interpreting uncertainty.":["Se encontró mejor verosimilitud. Reajuste antes de interpretar incertidumbre.", "Encontrada melhor verossimilhança. Reajuste antes de interpretar incerteza."],
"Bootstrap intervals require at least 20 successful refits and 90% success.":["Los intervalos bootstrap requieren al menos 20 reajustes exitosos y 90% de éxito.", "Intervalos bootstrap exigem ao menos 20 reajustes bem-sucedidos e 90% de sucesso."],
"Bootstrap requires complete sampling and crown-survival conditioning (cond = 1).":["Bootstrap requiere muestreo completo y supervivencia de corona (cond = 1).", "Bootstrap exige amostragem completa e sobrevivência da coroa (cond = 1)."],
"Finite estimates are required for uncertainty analysis.":["Se requieren estimaciones finitas para analizar incertidumbre.", "São necessárias estimativas finitas para analisar incerteza."],
"Select an estimated parameter for profiling.":["Seleccione un parámetro estimado para el perfil.", "Selecione um parâmetro estimado para o perfil."],
"Profile limits must bracket the saved estimate.":["Los límites deben contener la estimación guardada.", "Os limites devem conter a estimativa salva."],
"Insufficient successful bootstrap refits.":["Reajustes bootstrap exitosos insuficientes.", "Reajustes bootstrap bem-sucedidos insuficientes."],
"Profiles use finite search limits and approximate chi-square reference levels. Bootstrap requires complete sampling and cond = 1; crown age is fixed, simulated tip counts vary. Intervals exclude tree and model-selection uncertainty.":["Los perfiles usan límites finitos y referencia chi-cuadrado aproximada. Bootstrap requiere muestreo completo y cond = 1; la edad de corona es fija y el número de puntas varía. Los intervalos excluyen incertidumbre del árbol y selección de modelos.", "Perfis usam limites finitos e referência qui-quadrado aproximada. Bootstrap exige amostragem completa e cond = 1; a idade da coroa é fixa e o número de pontas varia. Intervalos excluem incerteza da árvore e seleção de modelos."],
"AIC compares selected candidates in this card only. It conditions on the tree and missing-species count. Uncertainty is conditional and approximate.":["AIC compara candidatos solo en esta tarjeta, condicionado al árbol y especies faltantes. La incertidumbre es condicional y aproximada.", "AIC compara candidatos apenas neste cartão, condicionado à árvore e espécies ausentes. A incerteza é condicional e aproximada."],
"Run numerical diagnostics before interpreting AIC. Failed stability checks suppress ranking weights.":["Ejecute diagnósticos numéricos antes de interpretar AIC. La inestabilidad suprime los pesos.", "Execute diagnósticos numéricos antes de interpretar AIC. A instabilidade suprime os pesos."],
"1: linear lambda":["1: lambda lineal", "1: lambda linear"],
"1.3: linear lambda (K prime)":["1.3: lambda lineal (K prima)", "1.3: lambda linear (K linha)"],
"2: exponential lambda":["2: lambda exponencial", "2: lambda exponencial"],
"3: linear mu":["3: mu lineal", "3: mu linear"],
"4: exponential mu":["4: mu exponencial", "4: mu exponencial"],
"5: linear lambda + mu":["5: lambda + mu lineales", "5: lambda + mu lineares"],
"0: age":["0: edad", "0: idade"],
"1: age + survival":["1: edad + supervivencia", "1: idade + sobrevivência"],
"2: age + extant count":["2: edad + conteo actual", "2: idade + contagem atual"],
"3: extant count":["3: conteo actual", "3: contagem atual"],
"0: branching times":["0: tiempos de ramificación", "0: tempos de ramificação"],
"1: phylogeny":["1: filogenia", "1: filogenia"],
"Rate curves are invalid over the selected diversity range.":["Curvas de tasas no válidas para el rango de diversidad seleccionado.", "Curvas de taxas inválidas para o intervalo de diversidade selecionado."],
"Unsupported numerical method.":["Método numérico no admitido.", "Método numérico não suportado."],
"Install DDD to run this analysis.":["Instale DDD para ejecutar este análisis.", "Instale DDD para executar esta análise."],
"Select at least one estimated parameter for each model.":["Seleccione al menos un parámetro estimado por modelo.", "Selecione ao menos um parâmetro estimado por modelo."],
"Use positive lambda, K and r and nonnegative mu starting/fixed values and select estimated parameters.":["Use valores positivos de lambda, K y r y mu no negativo; seleccione parámetros estimados.", "Use valores positivos de lambda, K e r e mu não negativo; selecione parâmetros estimados."],
"Diversity-dependent models":["Modelos dependientes de la diversidad", "Modelos dependentes da diversidade"],
"Missing extant species":["Especies actuales faltantes", "Espécies atuais ausentes"],
"Estimated parameters":["Parámetros estimados", "Parâmetros estimados"],
"Run diversity-dependent models":["Ejecutar modelos dependientes de diversidad", "Executar modelos dependentes da diversidade"],
"Resolution multiplier":["Multiplicador de resolución", "Multiplicador de resolução"],
"Run numerical diagnostics":["Ejecutar diagnósticos numéricos", "Executar diagnósticos numéricos"],
"Rate versus diversity":["Tasa frente a diversidad", "Taxa em função da diversidade"],
"Observed reconstructed lineages":["Linajes reconstruidos observados", "Linhagens reconstruídas observadas"],
"Numerical stability":["Estabilidad numérica", "Estabilidade numérica"],
"Maximum displayed diversity":["Diversidad máxima mostrada", "Diversidade máxima exibida"],
"Species diversity":["Diversidad de especies", "Diversidade de espécies"],
"Rate per branch-length unit":["Tasa por unidad de longitud de rama", "Taxa por unidade de comprimento de ramo"],
"Likelihood change":["Cambio de verosimilitud", "Mudança de verossimilhança"],
"Analysis completed.":["Análisis completado.", "Análise concluída."],
"Inspect convergence and backend messages.":["Revise convergencia y mensajes del motor.", "Revise a convergência e as mensagens do mecanismo."],
"Invalid numeric settings.":["Configuración numérica no válida.", "Configurações numéricas inválidas."],
"Invalid model or likelihood settings.":["Configuración del modelo o verosimilitud no válida.", "Configurações de modelo ou verossimilhança inválidas."],
"Select a converged model.":["Seleccione un modelo convergente.", "Selecione um modelo convergente."],
"Run numerical diagnostics first.":["Ejecute primero los diagnósticos numéricos.", "Execute primeiro os diagnósticos numéricos."],
"Compatible converged fits are required for comparison.":["Se requieren ajustes compatibles y convergentes para comparar.", "São necessários ajustes compatíveis e convergentes para comparar."],
"Crown analysis (soc = 2). Missing species are a count, not a sampling fraction. Supplied stems are excluded.":["Análisis de corona (soc = 2). Las especies faltantes son un conteo, no una fracción de muestreo. Se excluye el tallo.", "Análise de coroa (soc = 2). Espécies ausentes são uma contagem, não uma fração amostral. O ramo-tronco é excluído."],
"K has a model-specific meaning. Model 1.3 uses diversity at zero speciation; models 1 and 2 use diversity at equal speciation and extinction.":["K depende del modelo. El modelo 1.3 usa diversidad con especiación cero; 1 y 2 usan diversidad con especiación y extinción iguales.", "K depende do modelo. O modelo 1.3 usa diversidade com especiação zero; 1 e 2 usam diversidade com especiação e extinção iguais."],
"Unchecked parameters use the supplied fixed values. r applies only to model 5. DDD does not expose arbitrary parameter bounds.":["Los parámetros no seleccionados usan valores fijos. r solo se aplica al modelo 5. DDD no permite límites arbitrarios.", "Parâmetros não selecionados usam valores fixos. r aplica-se apenas ao modelo 5. DDD não oferece limites arbitrários."],
"Reevaluate saved estimates with larger res and tighter integration tolerances. This is a numerical check, not an uncertainty interval.":["Reevalúe estimaciones con mayor res y tolerancias más estrictas. Es una comprobación numérica, no un intervalo de incertidumbre.", "Reavalie estimativas com maior res e tolerâncias mais estritas. É uma verificação numérica, não um intervalo de incerteza."],
"Rate curves describe dependence on diversity. The LTT shows observed surviving lineages, not reconstructed total historical diversity.":["Las curvas describen dependencia de la diversidad. LTT muestra linajes supervivientes observados, no diversidad histórica total.", "As curvas descrevem dependência da diversidade. LTT mostra linhagens sobreviventes observadas, não diversidade histórica total."],
"AIC compares selected candidates in this card only. It conditions on the tree and missing-species count. Confidence intervals are not estimated.":["AIC compara candidatos solo en esta tarjeta, condicionado al árbol y especies faltantes. No se estiman intervalos de confianza.", "AIC compara candidatos apenas neste cartão, condicionado à árvore e espécies ausentes. Intervalos de confiança não são estimados."],
"Constant-rate models":["Modelos de tasas constantes", "Modelos de taxas constantes"],
"Clade-specific models":["Modelos específicos de clados", "Modelos específicos de clados"],
"Model and data settings":["Configuración del modelo y los datos", "Configurações do modelo e dos dados"],
"Advanced fitting controls":["Controles avanzados de ajuste", "Controles avançados de ajuste"],
"Uncertainty and diagnostics":["Incertidumbre y diagnósticos", "Incerteza e diagnósticos"],
"Normal intervals cross zero for a nonnegative rate; those intervals are withheld.":["Los intervalos normales cruzan cero para una tasa no negativa; esos intervalos se omiten.","Os intervalos normais cruzam zero para uma taxa não negativa; esses intervalos são omitidos."],
"Non-finite split likelihood; inspect fixed rates, bounds and lambda = mu.":["Verosimilitud particionada no finita; revise tasas fijas, límites y lambda = mu.","Verossimilhança particionada não finita; examine taxas fixas, limites e lambda = mu."],
"Joint clade-dependent models":["Modelos conjuntos dependientes del clado","Modelos conjuntos dependentes do clado"],
"Joint shift nodes":["Nodos de cambio conjuntos","Nós de mudança conjuntos"],
"Shift placement: branch base (split.t = Inf). Other timings are unsupported by the installed backend. Nested regions are allowed; each region must retain at least two sampled tips.":["Posición del cambio: base de la rama (split.t = Inf). El motor instalado no admite otros tiempos. Se permiten regiones anidadas; cada región debe conservar al menos dos terminales muestreados.","Posição da mudança: base do ramo (split.t = Inf). O motor instalado não aceita outros tempos. Regiões aninhadas são permitidas; cada região deve manter pelo menos dois terminais amostrados."],
"Joint region sampling (CSV)":["Muestreo de regiones conjuntas (CSV)","Amostragem de regiões conjuntas (CSV)"],
"Fill joint region tables":["Completar tablas de regiones conjuntas","Preencher tabelas de regiões conjuntas"],
"Use Region,Sampling: background is 0; other region identifiers are shift nodes. Blank means sampling 1 everywhere. Whole-tree and separate-clade sampling controls do not apply.":["Use Region,Sampling: la región de fondo es 0; los otros identificadores son nodos de cambio. En blanco significa muestreo 1 en todas las regiones. No se aplican los controles de muestreo del árbol completo ni de clados separados.","Use Region,Sampling: a região de fundo é 0; os outros identificadores são nós de mudança. Em branco significa amostragem 1 em todas as regiões. Os controles de amostragem da árvore completa e de clados separados não se aplicam."],
"Joint candidates":["Modelos conjuntos candidatos","Modelos conjuntos candidatos"],
"SharedYule fixes extinction to zero. SharedBD shares both rates. ShiftLambda, ShiftMu and ShiftBoth vary the named rates across regions.":["SharedYule fija extinción en cero. SharedBD comparte ambas tasas. ShiftLambda, ShiftMu y ShiftBoth varían las tasas indicadas entre regiones.","SharedYule fixa extinção em zero. SharedBD compartilha ambas as taxas. ShiftLambda, ShiftMu e ShiftBoth variam as taxas indicadas entre regiões."],
"Custom joint constraints (CSV)":["Restricciones conjuntas personalizadas (CSV)","Restrições conjuntas personalizadas (CSV)"],
"Columns: Region,Lambda,Mu. Equal parameter names share a rate; numbers fix rates. Fixed speciation must be positive. Do not reuse a name across speciation and extinction. Used only for Custom.":["Columnas: Region,Lambda,Mu. Los nombres iguales comparten una tasa; los números fijan tasas. La especiación fija debe ser positiva. No reutilice nombres entre especiación y extinción. Solo se usa para Custom.","Colunas: Region,Lambda,Mu. Nomes iguais compartilham uma taxa; números fixam taxas. A especiação fixa deve ser positiva. Não reutilize nomes entre especiação e extinção. Usado apenas para Custom."],
"Joint parameter controls (CSV)":["Controles de parámetros conjuntos (CSV)","Controles de parâmetros conjuntos (CSV)"],
"Optional columns: Parameter,Start,Lower,Upper. Names appear in the constraints table. Unlisted parameters use derived starts and the upper bound above. Free speciation lower bounds must be positive; starts must lie strictly inside bounds.":["Columnas opcionales: Parameter,Start,Lower,Upper. Los nombres aparecen en la tabla de restricciones. Parámetros no listados usan inicios derivados y el límite superior indicado arriba. Los límites inferiores de especiación libre deben ser positivos; los inicios deben estar estrictamente dentro de los límites.","Colunas opcionais: Parameter,Start,Lower,Upper. Os nomes aparecem na tabela de restrições. Parâmetros não listados usam inícios derivados e o limite superior acima. Limites inferiores de especiação livre devem ser positivos; os inícios devem ficar estritamente dentro dos limites."],
"Joint models use conditioning, optimizer, maximum iterations, upper bound and curvature interval controls above. All candidates share one partitioned whole-tree likelihood. Shift positions and sampling are fixed, not estimated.":["Los modelos conjuntos usan los controles superiores de condicionamiento, optimizador, iteraciones máximas, límite superior e intervalos de curvatura. Todos comparten una verosimilitud del árbol completo particionado. Posiciones de cambio y muestreo son fijos, no estimados.","Os modelos conjuntos usam os controles acima de condicionamento, otimizador, iterações máximas, limite superior e intervalos de curvatura. Todos compartilham uma verossimilhança da árvore completa particionada. Posições de mudança e amostragem são fixas, não estimadas."],
"Preview joint regions":["Previsualizar regiones conjuntas","Visualizar regiões conjuntas"],
"Run joint models":["Ejecutar modelos conjuntos","Executar modelos conjuntos"],
"Joint diversification regions":["Regiones de diversificación conjunta","Regiões de diversificação conjunta"],
"Joint regional rates":["Tasas regionales conjuntas","Taxas regionais conjuntas"],
"Joint whole-tree model comparison":["Comparación conjunta en el árbol completo","Comparação conjunta na árvore completa"],
"Joint optimizer agreement":["Concordancia del optimizador conjunto","Concordância do otimizador conjunto"],
"Joint model to display":["Modelo conjunto a mostrar","Modelo conjunto a exibir"],
"Joint model results":["Resultados de modelos conjuntos","Resultados de modelos conjuntos"],
"Joint AIC compares these candidates on the same whole-tree likelihood only. It does not include uncertainty in shift selection, sampling or the tree. No calibrated likelihood-ratio p-value is reported.":["El AIC conjunto compara estos candidatos solo con la misma verosimilitud del árbol completo. No incluye incertidumbre en selección de cambios, muestreo o árbol. No se informa un valor p calibrado de razón de verosimilitudes.","O AIC conjunto compara estes candidatos apenas com a mesma verossimilhança da árvore completa. Não inclui incerteza na seleção de mudanças, amostragem ou árvore. Não é informado valor p calibrado de razão de verossimilhanças."],
"Download joint comparison CSV":["Descargar comparación conjunta CSV","Baixar comparação conjunta CSV"],
"Download joint estimates CSV":["Descargar estimaciones conjuntas CSV","Baixar estimativas conjuntas CSV"],
"Download joint membership CSV":["Descargar pertenencia regional conjunta CSV","Baixar composição regional conjunta CSV"],
"Download joint branch regions CSV":["Descargar regiones conjuntas por rama CSV","Baixar regiões conjuntas por ramo CSV"],
"Joint model diagnostics":["Diagnósticos de modelos conjuntos","Diagnósticos de modelos conjuntos"],
"Intervals are approximate curvature intervals, withheld at bounds or unstable curvature. Joint regions with little information can have weakly identified rates. Inspect all optimizer starts.":["Los intervalos de curvatura son aproximados y se omiten en límites o con curvatura inestable. Las tasas de regiones con poca información pueden estar débilmente identificadas. Revise todos los inicios del optimizador.","Os intervalos de curvatura são aproximados e omitidos nos limites ou com curvatura instável. As taxas de regiões com pouca informação podem ser fracamente identificadas. Examine todos os inícios do otimizador."],
"Download joint constraints CSV":["Descargar restricciones conjuntas CSV","Baixar restrições conjuntas CSV"],
"Download joint controls CSV":["Descargar controles conjuntos CSV","Baixar controles conjuntos CSV"],
"Download joint optimizer CSV":["Descargar optimización conjunta CSV","Baixar otimização conjunta CSV"],
"Download joint sampling CSV":["Descargar muestreo conjunto CSV","Baixar amostragem conjunta CSV"],
"Select joint shift nodes and run models.":["Seleccione nodos de cambio conjuntos y ejecute modelos.","Selecione nós de mudança conjuntos e execute modelos."],
"Joint inputs changed. Run joint models to update results.":["Las entradas conjuntas cambiaron. Ejecute modelos conjuntos para actualizar resultados.","As entradas conjuntas mudaram. Execute modelos conjuntos para atualizar os resultados."],
"Joint preview only. Run models to fit rates.":["Solo previsualización conjunta. Ejecute modelos para ajustar tasas.","Apenas visualização conjunta. Execute modelos para ajustar taxas."],
"Fitting joint diversification models":["Ajustando modelos conjuntos de diversificación","Ajustando modelos conjuntos de diversificação"],
"Joint fitting completed. Inspect convergence, boundaries and comparisons.":["Ajuste conjunto completado. Revise convergencia, límites y comparaciones.","Ajuste conjunto concluído. Examine convergência, limites e comparações."],
"Joint ranking is unavailable; inspect candidate diagnostics.":["La clasificación conjunta no está disponible; revise los diagnósticos.","A classificação conjunta está indisponível; examine os diagnósticos."],
"Lowest joint AIC:":["Menor AIC conjunto:","Menor AIC conjunto:"],
"Support is conditional on the selected shifts and candidate set.":["El apoyo está condicionado a los cambios y modelos candidatos seleccionados.","O suporte é condicionado às mudanças e aos modelos candidatos selecionados."],
"Choose one to four non-root shift nodes with at least four descendant tips.":["Elija de uno a cuatro nodos de cambio distintos de la raíz, con al menos cuatro terminales descendientes.","Escolha de um a quatro nós de mudança diferentes da raiz, com pelo menos quatro terminais descendentes."],
"This backend supports branch-base shifts only (split.t = Inf).":["Este motor solo admite cambios en la base de la rama (split.t = Inf).","Este motor aceita apenas mudanças na base do ramo (split.t = Inf)."],
"Each joint region, including the background, must retain at least two sampled tips.":["Cada región conjunta, incluido el fondo, debe conservar al menos dos terminales muestreados.","Cada região conjunta, incluindo o fundo, deve manter pelo menos dois terminais amostrados."],
"Use Region,Sampling with background 0 and every shift node exactly once; fractions must be in (0,1].":["Use Region,Sampling con fondo 0 y cada nodo de cambio exactamente una vez; fracciones en (0,1].","Use Region,Sampling com fundo 0 e cada nó de mudança exatamente uma vez; frações em (0,1]."],
"Invalid joint-model CSV table.":["Tabla CSV de modelos conjuntos no válida.","Tabela CSV de modelos conjuntos inválida."],
"Custom constraints require Region,Lambda,Mu for every region exactly once.":["Las restricciones personalizadas requieren Region,Lambda,Mu para cada región exactamente una vez.","As restrições personalizadas exigem Region,Lambda,Mu para cada região exatamente uma vez."],
"Constraints must be nonnegative fixed rates or parameter names; speciation must be positive.":["Las restricciones deben ser tasas fijas no negativas o nombres de parámetros; la especiación debe ser positiva.","As restrições devem ser taxas fixas não negativas ou nomes de parâmetros; a especiação deve ser positiva."],
"Do not share a parameter name between speciation and extinction.":["No comparta un nombre de parámetro entre especiación y extinción.","Não compartilhe um nome de parâmetro entre especiação e extinção."],
"Choose at least one supported joint model.":["Elija al menos un modelo conjunto compatible.","Escolha pelo menos um modelo conjunto compatível."],
"Parameter controls require Parameter,Start,Lower,Upper with unique free parameter names.":["Los controles requieren Parameter,Start,Lower,Upper con nombres únicos de parámetros libres.","Os controles exigem Parameter,Start,Lower,Upper com nomes únicos de parâmetros livres."],
"Joint starts must be strictly inside valid parameter bounds; free speciation lower bounds must be positive.":["Los inicios conjuntos deben estar estrictamente dentro de límites válidos; los límites inferiores de especiación libre deben ser positivos.","Os inícios conjuntos devem ficar estritamente dentro de limites válidos; os limites inferiores de especiação livre devem ser positivos."],
"Fixed rates exceed the supported tree scale.":["Las tasas fijas exceden la escala admitida del árbol.","As taxas fixas excedem a escala suportada da árvore."],
"A joint model failed; comparison weights are withheld.":["Un modelo conjunto falló; se omiten los pesos de comparación.","Um modelo conjunto falhou; os pesos de comparação são omitidos."],
"A joint estimate reaches a parameter bound; curvature intervals are withheld.":["Una estimación conjunta alcanza un límite; se omiten los intervalos de curvatura.","Uma estimativa conjunta atinge um limite; os intervalos de curvatura são omitidos."],
"Joint likelihood curvature is unstable; intervals are unavailable.":["La curvatura de verosimilitud conjunta es inestable; no hay intervalos disponibles.","A curvatura da verossimilhança conjunta é instável; os intervalos estão indisponíveis."],
"Joint optimizer starts disagree; inspect local optima.":["Los inicios del optimizador conjunto discrepan; revise óptimos locales.","Os inícios do otimizador conjunto divergem; examine ótimos locais."],
"Some joint optimizer starts failed; inspect all attempts.":["Algunos inicios del optimizador conjunto fallaron; revise todos los intentos.","Alguns inícios do otimizador conjunto falharam; examine todas as tentativas."],
"Equivalent joint constraints selected; comparison weights are withheld.":["Se seleccionaron restricciones conjuntas equivalentes; se omiten los pesos de comparación.","Restrições conjuntas equivalentes selecionadas; os pesos de comparação são omitidos."],
"Region 0 is background; shifts include the incoming branch.":["La región 0 es el fondo; los cambios incluyen la rama entrante.","A região 0 é o fundo; as mudanças incluem o ramo de entrada."],
"No valid joint likelihoods.":["No hay verosimilitudes conjuntas válidas.","Não há verossimilhanças conjuntas válidas."],
"Invalid joint graph settings.":["Ajustes del gráfico conjunto no válidos.","Configurações do gráfico conjunto inválidas."],
"Region":["Región","Região"],
"Shift_age":["Edad_cambio","Idade_mudança"],
"Parent":["Progenitor","Ancestral"],
"Child":["Descendiente","Descendente"],
"Length":["Longitud","Comprimento"],
"Clade-specific diversification":["Diversificación por clado","Diversificação por clado"],
"Select non-overlapping internal nodes. Each crown must contain at least four sampled tips. All descendants are retained; ancestral stems are excluded.":["Seleccione nodos internos sin solapamiento. Cada corona debe contener al menos cuatro terminales muestreados. Se conservan todos los descendientes; se excluyen las ramas ancestrales.","Selecione nós internos sem sobreposição. Cada coroa deve conter pelo menos quatro terminais amostrados. Todos os descendentes são mantidos; os ramos ancestrais são excluídos."],
"Crown nodes":["Nodos de corona","Nós da coroa"],
"Preview selected clades":["Previsualizar clados seleccionados","Visualizar clados selecionados"],
"Clade sampling fractions (CSV)":["Fracciones de muestreo por clado (CSV)","Frações de amostragem por clado (CSV)"],
"Fill sampling table":["Completar tabla de muestreo","Preencher tabela de amostragem"],
"Columns: Node,Sampling. Blank means complete sampling (1) for each selected clade. Enter the probability of random extant-taxon inclusion within each clade.":["Columnas: Node,Sampling. En blanco indica muestreo completo (1) por clado. Ingrese la probabilidad de inclusión aleatoria de taxones actuales dentro de cada clado.","Colunas: Node,Sampling. Em branco indica amostragem completa (1) por clado. Insira a probabilidade de inclusão aleatória de táxons atuais dentro de cada clado."],
"Clade fits use Models, conditioning, optimizer, bounds, starts and interval/slice controls above. Blank bounds and starts are derived separately for each crown. The whole-tree sampling fraction is not used.":["Los ajustes por clado usan los controles superiores de modelos, condicionamiento, optimizador, límites, inicios e intervalos/cortes. Límites e inicios en blanco se derivan por corona. No se usa la fracción de muestreo del árbol completo.","Os ajustes por clado usam os controles acima de modelos, condicionamento, otimizador, limites, inícios e intervalos/cortes. Limites e inícios em branco são derivados por coroa. A fração de amostragem da árvore completa não é usada."],
"Calculate clade profiles":["Calcular perfiles por clado","Calcular perfis por clado"],
"Clade profile reference level":["Nivel de referencia del perfil por clado","Nível de referência do perfil por clado"],
"Clade profile grid points":["Puntos de la malla del perfil por clado","Pontos da grade do perfil por clado"],
"Run clade models":["Ejecutar modelos por clado","Executar modelos por clado"],
"Selected crown clades":["Clados de corona seleccionados","Clados de coroa selecionados"],
"Clade-specific rate estimates":["Estimaciones de tasas por clado","Estimativas de taxas por clado"],
"Within-clade model comparison":["Comparación de modelos dentro del clado","Comparação de modelos dentro do clado"],
"Clade profile likelihood":["Perfil de verosimilitud por clado","Perfil de verossimilhança por clado"],
"Clade likelihood slice":["Corte de verosimilitud por clado","Corte de verossimilhança por clado"],
"Saved clade for diagnostics":["Clado guardado para diagnósticos","Clado salvo para diagnósticos"],
"Show clade tip labels":["Mostrar etiquetas terminales de clados","Mostrar rótulos terminais dos clados"],
"Show eligible node numbers":["Mostrar números de nodos elegibles","Mostrar números dos nós elegíveis"],
"Clade label size":["Tamaño de etiquetas de clados","Tamanho dos rótulos dos clados"],
"Clade-specific results":["Resultados por clado","Resultados por clado"],
"These are separate crown-clade fits, not a joint rate-shift test. DeltaAIC and weights compare models within each clade only. Do not rank likelihoods or AIC across different clades. Selecting clades after inspecting rates introduces selection bias.":["Son ajustes separados por corona, no una prueba conjunta de cambios de tasa. DeltaAIC y los pesos comparan modelos solo dentro de cada clado. No ordene verosimilitudes ni AIC entre clados distintos. Elegir clados después de examinar las tasas introduce sesgo de selección.","São ajustes separados por coroa, não um teste conjunto de mudanças de taxa. DeltaAIC e os pesos comparam modelos apenas dentro de cada clado. Não ordene verossimilhanças nem AIC entre clados distintos. Escolher clados após examinar as taxas introduz viés de seleção."],
"Download clade estimates CSV":["Descargar estimaciones por clado CSV","Baixar estimativas por clado CSV"],
"Download within-clade comparison CSV":["Descargar comparación dentro de clados CSV","Baixar comparação dentro dos clados CSV"],
"Download clade membership CSV":["Descargar pertenencia a clados CSV","Baixar composição dos clados CSV"],
"Download clade settings CSV":["Descargar ajustes por clado CSV","Baixar configurações por clado CSV"],
"Download selected crown trees":["Descargar árboles de corona seleccionados","Baixar árvores de coroa selecionadas"],
"Clade diagnostics":["Diagnósticos por clado","Diagnósticos por clado"],
"Small clades often provide weak information about extinction. Inspect boundaries, optimizer starts and profile search limits. Intervals condition on the chosen clades, topology, branch lengths and sampling fractions.":["Los clados pequeños suelen aportar poca información sobre extinción. Revise límites, inicios del optimizador y límites de búsqueda de perfiles. Los intervalos están condicionados a los clados elegidos, topología, longitudes de ramas y fracciones de muestreo.","Clados pequenos geralmente fornecem pouca informação sobre extinção. Examine limites, inícios do otimizador e limites de busca dos perfis. Os intervalos são condicionados aos clados escolhidos, topologia, comprimentos dos ramos e frações de amostragem."],
"Download clade audit CSV":["Descargar registro de clados CSV","Baixar registro dos clados CSV"],
"Download clade optimizer CSV":["Descargar optimización por clado CSV","Baixar otimização por clado CSV"],
"Download clade profiles CSV":["Descargar perfiles por clado CSV","Baixar perfis por clado CSV"],
"Download clade profile curves CSV":["Descargar curvas de perfiles por clado CSV","Baixar curvas de perfis por clado CSV"],
"Download clade slices CSV":["Descargar cortes por clado CSV","Baixar cortes por clado CSV"],
"Select crown nodes and run clade models.":["Seleccione nodos de corona y ejecute modelos por clado.","Selecione nós da coroa e execute modelos por clado."],
"Clade inputs changed. Run clade models to update results.":["Las entradas de clados cambiaron. Ejecute modelos por clado para actualizar resultados.","As entradas dos clados mudaram. Execute modelos por clado para atualizar os resultados."],
"Preview only. Run clade models to fit the selected crowns.":["Solo previsualización. Ejecute modelos por clado para ajustar las coronas seleccionadas.","Apenas visualização. Execute modelos por clado para ajustar as coroas selecionadas."],
"Fitting selected crown clades":["Ajustando clados de corona seleccionados","Ajustando clados de coroa selecionados"],
"Clade analysis completed. Review each clade separately.":["Análisis por clado completado. Revise cada clado por separado.","Análise por clado concluída. Examine cada clado separadamente."],
"No valid clade fits. Inspect the clade audit.":["No hay ajustes válidos por clado. Revise el registro de clados.","Não há ajustes válidos por clado. Examine o registro dos clados."],
"Successful clade-model fits:":["Ajustes clado-modelo exitosos:","Ajustes clado-modelo bem-sucedidos:"],
"Tips outside selected crowns:":["Terminales fuera de las coronas seleccionadas:","Terminais fora das coroas selecionadas:"],
"Rate differences are descriptive; no between-clade significance test is performed.":["Las diferencias de tasas son descriptivas; no se realiza una prueba de significancia entre clados.","As diferenças de taxas são descritivas; não é realizado teste de significância entre clados."],
"Select one to ten internal nodes with at least four descendant tips each.":["Seleccione entre uno y diez nodos internos con al menos cuatro terminales descendientes cada uno.","Selecione de um a dez nós internos com pelo menos quatro terminais descendentes cada."],
"Selected clades overlap. Choose non-overlapping crown clades.":["Los clados seleccionados se solapan. Elija clados de corona sin solapamiento.","Os clados selecionados se sobrepõem. Escolha clados de coroa sem sobreposição."],
"Sampling table must contain exactly Node,Sampling, one selected node per row and fractions in (0,1].":["La tabla debe contener exactamente Node,Sampling, un nodo seleccionado por fila y fracciones en (0,1].","A tabela deve conter exatamente Node,Sampling, um nó selecionado por linha e frações em (0,1]."],
"Invalid clade graph settings.":["Ajustes del gráfico de clados no válidos.","Configurações do gráfico de clados inválidas."],
"Run clade models and select a saved clade first.":["Primero ejecute modelos por clado y seleccione un clado guardado.","Primeiro execute modelos por clado e selecione um clado salvo."],
"Grey branches are outside selected crowns; stems are excluded.":["Las ramas grises están fuera de las coronas seleccionadas; se excluyen las ramas ancestrales.","Ramos cinza estão fora das coroas selecionadas; ramos ancestrais são excluídos."],
"No saved estimate for this parameter.":["No hay estimación guardada para este parámetro.","Não há estimativa salva para este parâmetro."],
"Branch-length units":["Unidades de longitud de rama","Unidades de comprimento de ramo"],
"Successful_models":["Modelos_exitosos","Modelos_bem_sucedidos"],
"Requested_models":["Modelos_solicitados","Modelos_solicitados"],
"Profile_available":["Perfil_disponible","Perfil_disponível"],
"Sampling":["Muestreo","Amostragem"],
"First_tip":["Primer_terminal","Primeiro_terminal"],
"Label":["Etiqueta","Rótulo"],
"Parameter":["Parámetro","Parâmetro"],
"Bayesian Mk ancestral reconstruction":["Reconstrucción ancestral Mk bayesiana", "Reconstrução ancestral Mk bayesiana"],
"Posterior mean transition rates per branch-length unit":["Tasas medias posteriores por unidad de longitud de rama", "Taxas médias posteriores por unidade de comprimento de ramo"],
"Root weights give no support to a state that can reach all observed states.":["Los pesos de raíz no apoyan ningún estado que pueda alcanzar todos los estados observados.", "Os pesos da raiz não apoiam nenhum estado capaz de alcançar todos os estados observados."],
"Root probabilities":["Probabilidades de raíz", "Probabilidades da raiz"],
"Equal":["Iguales", "Iguais"],
"Custom named weights":["Pesos personalizados por estado", "Pesos personalizados por estado"],
"Bayesian Mk (sample rates)":["Mk bayesiano (muestrear tasas)", "Mk bayesiano (amostrar taxas)"],
"Saved rate draws per chain":["Muestras de tasas guardadas por cadena", "Amostras de taxas salvas por cadeia"],
"Fill rate-prior table":["Completar tabla de priors de tasas", "Preencher tabela de priors das taxas"],
"Gamma priors and proposals (CSV)":["Priors gamma y propuestas (CSV)", "Priors gama e propostas (CSV)"],
"Root weights: state,weight":["Pesos de raíz: estado,peso", "Pesos da raiz: estado,peso"],
"Columns: Parameter, Shape, Rate, ProposalVariance. Use q1, q2, etc. for the displayed constraint indices. Blank uses gamma shape 1, rate 1 and proposal variance 0.1 for every rate.":["Columnas: Parameter, Shape, Rate, ProposalVariance. Use q1, q2, etc. para los índices mostrados. En blanco: forma gamma 1, tasa 1 y varianza de propuesta 0.1 por tasa.", "Colunas: Parameter, Shape, Rate, ProposalVariance. Use q1, q2 etc. para os índices exibidos. Em branco: forma gama 1, taxa 1 e variância de proposta 0.1 por taxa."],
"Empirical prior means from these data":["Medias de priors empíricos a partir de estos datos", "Médias de priors empíricos a partir destes dados"],
"Empirical mode replaces Shape with fitted rate times Rate. Otherwise priors are prespecified gamma distributions; Rate is the inverse-scale parameter. Chain starts are sampled from these priors.":["El modo empírico reemplaza Shape por la tasa ajustada multiplicada por Rate. En otro caso, los priors gamma se especifican previamente; Rate es la escala inversa. Los inicios de las cadenas se muestrean de estos priors.", "O modo empírico substitui Shape pela taxa ajustada multiplicada por Rate. Caso contrário, os priors gama são especificados previamente; Rate é a escala inversa. Os inícios das cadeias são amostrados destes priors."],
"One history is sampled per retained Q draw. Generations per chain equal burn-in plus saved draws times spacing. The backend does not return burn-in traces, acceptance counts or editable starting rates. Short runs are exploratory.":["Se muestrea una historia por muestra retenida de Q. Generaciones por cadena = calentamiento + muestras guardadas × intervalo. El motor no devuelve trazas del calentamiento, conteos de aceptación ni tasas iniciales editables. Las ejecuciones cortas son exploratorias.", "Uma história é amostrada por amostra retida de Q. Gerações por cadeia = descarte inicial + amostras salvas × intervalo. O motor não retorna traços do descarte inicial, contagens de aceitação ou taxas iniciais editáveis. Execuções curtas são exploratórias."],
"Equal or named root weights are held fixed. The tree and observed tip states are fixed; rate uncertainty is integrated. No AIC or Bayesian model comparison is performed.":["Los pesos de raíz iguales o nombrados se mantienen fijos. El árbol y los estados terminales observados son fijos; se integra la incertidumbre de tasas. No se calcula AIC ni comparación bayesiana de modelos.", "Pesos da raiz iguais ou nomeados permanecem fixos. A árvore e os estados terminais observados são fixos; a incerteza das taxas é integrada. Não se calcula AIC nem comparação bayesiana de modelos."],
"Node pies average conditional marginal probabilities over posterior rate draws. The displayed Q is the posterior mean. History intervals integrate rate and history uncertainty on the fixed tree; MCSE accounts for serial dependence. Inspect rate and node diagnostics.":["Los diagramas nodales promedian probabilidades marginales condicionadas sobre muestras posteriores de tasas. Q muestra la media posterior. Los intervalos de historias integran incertidumbre de tasas e historias en el árbol fijo; MCSE considera dependencia serial. Revise diagnósticos de tasas y nodos.", "Os gráficos nodais usam a média das probabilidades marginais condicionais nas amostras posteriores de taxas. Q exibe a média posterior. Os intervalos das histórias integram incerteza de taxas e histórias na árvore fixa; MCSE considera dependência serial. Examine diagnósticos de taxas e nós."],
"Diagnostics use retained rate draws: spectral ESS, classic split Rhat and MCSE, not rank-normalized Rhat or tail ESS. Passing thresholds is not proof of convergence. Constant sampled indicators do not establish zero uncertainty.":["Diagnósticos de muestras retenidas: ESS espectral, Rhat dividido clásico y MCSE; no Rhat normalizado por rangos ni ESS de colas. Superar umbrales no prueba convergencia. Indicadores muestreados constantes no demuestran incertidumbre nula.", "Diagnósticos das amostras retidas: ESS espectral, Rhat dividido clássico e MCSE; não Rhat normalizado por postos nem ESS de caudas. Passar limiares não comprova convergência. Indicadores amostrados constantes não demonstram incerteza nula."],
"Download effective rate priors CSV":["Descargar priors efectivos de tasas CSV", "Baixar priors efetivos das taxas CSV"],
"Download posterior node diagnostics CSV":["Descargar diagnósticos nodales posteriores CSV", "Baixar diagnósticos nodais posteriores CSV"],
"Bayesian Mk completed. Inspect rate and node diagnostics before interpretation.":["Mk bayesiano completado. Revise diagnósticos de tasas y nodos antes de interpretar.", "Mk bayesiano concluído. Examine diagnósticos de taxas e nós antes de interpretar."],
"Bayesian Mk rate sampling completed.":["Muestreo bayesiano de tasas Mk completado.", "Amostragem bayesiana de taxas Mk concluída."],
"Run Bayesian Mk reconstruction":["Ejecutar reconstrucción Mk bayesiana", "Executar reconstrução Mk bayesiana"],
"Posterior node probabilities":["Probabilidades nodales posteriores", "Probabilidades nodais posteriores"],
"Posterior mean Q":["Q media posterior", "Q média posterior"],
"Posterior stochastic history":["Historia estocástica posterior", "História estocástica posterior"],
"Posterior rate intervals":["Intervalos posteriores de tasas", "Intervalos posteriores de taxas"],
"Posterior mean and equal-tailed 95% interval":["Media posterior e intervalo del 95% de colas iguales", "Média posterior e intervalo de 95% de caudas iguais"],
"Retained MCMC trace (burn-in not saved)":["Traza MCMC retenida (calentamiento no guardado)", "Traço MCMC retido (descarte inicial não salvo)"],
"Rate-prior CSV requires Parameter, Shape, Rate, ProposalVariance and one row for each displayed q index.":["El CSV requiere Parameter, Shape, Rate, ProposalVariance y una fila por índice q mostrado.", "O CSV exige Parameter, Shape, Rate, ProposalVariance e uma linha por índice q exibido."],
"Gamma shape, gamma rate and proposal variances must be finite and positive.":["La forma y tasa gamma y las varianzas de propuesta deben ser finitas y positivas.", "A forma e taxa gama e as variâncias de proposta devem ser finitas e positivas."],
"Choose 20–2000 saved draws per chain, positive burn-in and spacing, 1–4 chains and a valid seed.":["Elija 20–2000 muestras guardadas por cadena, calentamiento e intervalo positivos, 1–4 cadenas y una semilla válida.", "Escolha 20–2000 amostras salvas por cadeia, descarte inicial e intervalo positivos, 1–4 cadeias e uma semente válida."],
"Invalid empirical-prior setting.":["Configuración de prior empírico no válida.", "Configuração de prior empírico inválida."],
"Empirical prior requires finite positive fitted rates; use explicit gamma priors.":["El prior empírico requiere tasas ajustadas finitas y positivas; use priors gamma explícitos.", "O prior empírico exige taxas ajustadas finitas e positivas; use priors gama explícitos."],
"Empirical Bayes: gamma prior means were estimated from these same data. This is not a fully prespecified prior analysis.":["Bayes empírico: las medias de priors gamma se estimaron con estos mismos datos. Los priors no fueron totalmente preespecificados.", "Bayes empírico: as médias dos priors gama foram estimadas com estes mesmos dados. Os priors não foram totalmente pré-especificados."],
"Sampled rates violate the selected Mk constraints.":["Las tasas muestreadas violan las restricciones Mk seleccionadas.", "As taxas amostradas violam as restrições Mk selecionadas."],
"Run Bayesian Mk reconstruction first.":["Ejecute primero la reconstrucción Mk bayesiana.", "Execute primeiro a reconstrução Mk bayesiana."],
"Select a saved posterior parameter.":["Seleccione un parámetro posterior guardado.", "Selecione um parâmetro posterior salvo."],
"SampledFrequency":["FrecuenciaMuestreada", "FrequênciaAmostrada"],
"Node MCSE and ESS describe SampledFrequency; Probability averages conditional marginals over Q draws.":["MCSE y ESS nodales describen SampledFrequency; Probability promedia marginales condicionadas sobre muestras de Q.", "MCSE e ESS nodais descrevem SampledFrequency; Probability calcula a média das marginais condicionais nas amostras de Q."],
"Download joint assignments CSV":["Descargar asignaciones conjuntas CSV", "Baixar atribuições conjuntas CSV"],
"Joint log likelihood conditional on fitted Q; AIC uses the marginal likelihood.":["Log-verosimilitud conjunta condicionada a Q ajustada; AIC usa la verosimilitud marginal.", "Log-verossimilhança conjunta condicionada a Q ajustada; AIC usa a verossimilhança marginal."],
"BM analytic ML (fastAnc)":["ML analítica BM (fastAnc)", "ML analítica BM (fastAnc)"],
"Joint ML (anc.ML)":["ML conjunta (anc.ML)", "ML conjunta (anc.ML)"],
"Bayesian BM":["BM bayesiano", "BM bayesiano"],
"Bayesian BM samples diffusion and ancestral states on a fixed tree. Tip observations are treated as exact; measurement-error settings from ML do not apply.":["BM bayesiano muestrea la difusión y los estados ancestrales sobre un árbol fijo. Las observaciones terminales se consideran exactas; no se aplican los ajustes de error de medición de ML.", "BM bayesiano amostra a difusão e os estados ancestrais em uma árvore fixa. As observações terminais são tratadas como exatas; as configurações de erro de medição de ML não se aplicam."],
"MCMC generations per chain":["Generaciones MCMC por cadena", "Gerações MCMC por cadeia"],
"Save every N generations":["Guardar cada N generaciones", "Salvar a cada N gerações"],
"Burn-in generations":["Generaciones de descarte inicial", "Gerações de descarte inicial"],
"Chains":["Cadenas", "Cadeias"],
"Chain":["Cadena", "Cadeia"],
"MCMC seed":["Semilla MCMC", "Semente MCMC"],
"Chain starting spread":["Dispersión inicial entre cadenas", "Dispersão inicial entre cadeias"],
"Only saved draws with generation greater than burn-in are retained. Short runs are exploratory; defaults do not guarantee convergence.":["Solo se retienen muestras guardadas con generación posterior al descarte inicial. Las ejecuciones cortas son exploratorias; los valores predeterminados no garantizan convergencia.", "Somente amostras salvas com geração posterior ao descarte inicial são retidas. Execuções curtas são exploratórias; os padrões não garantem convergência."],
"Fill Bayesian parameter table":["Rellenar tabla de parámetros bayesianos", "Preencher tabela de parâmetros bayesianos"],
"Priors, starts and proposals (CSV)":["Priors, valores iniciales y propuestas (CSV)", "Priors, valores iniciais e propostas (CSV)"],
"Rows: sig2, then root and internal node numbers. Columns: Parameter, Start, PriorMean, PriorVariance, ProposalVariance. The sig2 prior is exponential: its variance entry must be NA. Node priors are independent normal distributions. Proposal entries are variances, not standard deviations. Blank uses the displayed backend defaults.":["Filas: sig2, luego raíz y números de nodos internos. Columnas: Parameter, Start, PriorMean, PriorVariance, ProposalVariance. El prior de sig2 es exponencial: su varianza debe ser NA. Los priors de nodos son normales independientes. Las propuestas son varianzas, no desviaciones estándar. Vacío usa los valores predeterminados mostrados.", "Linhas: sig2, depois raiz e números dos nós internos. Colunas: Parameter, Start, PriorMean, PriorVariance, ProposalVariance. O prior de sig2 é exponencial: sua variância deve ser NA. Os priors dos nós são normais independentes. As propostas são variâncias, não desvios padrão. Vazio usa os padrões exibidos."],
"Effective Bayesian controls":["Controles bayesianos efectivos", "Controles bayesianos efetivos"],
"Posterior parameter":["Parámetro posterior", "Parâmetro posterior"],
"MCMC trace":["Traza MCMC", "Traço MCMC"],
"Posterior density":["Densidad posterior", "Densidade posterior"],
"Generation":["Generación", "Geração"],
"MCMC traces including burn-in":["Trazas MCMC incluido el descarte inicial", "Traços MCMC incluindo descarte inicial"],
"Retained posterior densities":["Densidades posteriores retenidas", "Densidades posteriores retidas"],
"Equal-tailed 95% credible intervals":["Intervalos creíbles del 95% con colas iguales", "Intervalos de credibilidade de 95% com caudas iguais"],
"Download retained posterior CSV":["Descargar muestras posteriores retenidas CSV", "Baixar amostras posteriores retidas CSV"],
"Download full chains and settings RDS":["Descargar cadenas completas y ajustes RDS", "Baixar cadeias completas e configurações RDS"],
"Download chain diagnostics CSV":["Descargar diagnósticos de cadenas CSV", "Baixar diagnósticos das cadeias CSV"],
"ESS is the summed per-chain spectral estimate. Classic split-Rhat is not rank-normalized. Values above 1.01, low ESS or stuck chains flag unreliable sampling; passing diagnostics does not prove convergence.":["ESS es la suma de estimaciones espectrales por cadena. Split-Rhat clásico no está normalizado por rangos. Valores superiores a 1.01, ESS bajo o cadenas estancadas indican muestreo poco fiable; superar los diagnósticos no demuestra convergencia.", "ESS é a soma das estimativas espectrais por cadeia. Split-Rhat clássico não é normalizado por postos. Valores acima de 1.01, ESS baixo ou cadeias estagnadas indicam amostragem não confiável; passar nos diagnósticos não comprova convergência."],
"Running ancestral reconstruction":["Ejecutando reconstrucción ancestral", "Executando reconstrução ancestral"],
"Retained draws per chain":["Muestras retenidas por cadena", "Amostras retidas por cadeia"],
"Invalid Bayesian parameter CSV.":["CSV de parámetros bayesianos no válido.", "CSV de parâmetros bayesianos inválido."],
"Provide exactly one Bayesian parameter row for sig2 and every internal node.":["Proporcione exactamente una fila para sig2 y cada nodo interno.", "Forneça exatamente uma linha para sig2 e cada nó interno."],
"Bayesian parameter values must be numeric; diffusion prior variance must be NA.":["Los parámetros bayesianos deben ser numéricos; la varianza del prior de difusión debe ser NA.", "Os parâmetros bayesianos devem ser numéricos; a variância do prior de difusão deve ser NA."],
"Invalid Bayesian priors, starts or proposal variances.":["Priors, valores iniciales o varianzas de propuestas no válidos.", "Priors, valores iniciais ou variâncias das propostas inválidos."],
"Invalid MCMC settings: generations must be divisible by sampling interval; choose 1–4 chains and a valid seed and burn-in.":["Ajustes MCMC no válidos: las generaciones deben ser divisibles por el intervalo de muestreo; elija 1–4 cadenas y semilla y descarte inicial válidos.", "Configurações MCMC inválidas: as gerações devem ser divisíveis pelo intervalo de amostragem; escolha 1–4 cadeias e semente e descarte inicial válidos."],
"Retain at least 20 saved draws per chain after burn-in.":["Retenga al menos 20 muestras por cadena después del descarte inicial.", "Retenha pelo menos 20 amostras por cadeia após o descarte inicial."],
"Chain starting spread must be between 0 and 10.":["La dispersión inicial debe estar entre 0 y 10.", "A dispersão inicial deve estar entre 0 e 10."],
"Requested Bayesian workload is too large; reduce generations, chains or saved draws.":["La carga bayesiana solicitada es demasiado grande; reduzca generaciones, cadenas o muestras guardadas.", "A carga bayesiana solicitada é muito grande; reduza gerações, cadeias ou amostras salvas."],
"Bayesian BM requires branch lengths above the numerical zero threshold.":["BM bayesiano requiere longitudes de ramas superiores al umbral numérico de cero.", "BM bayesiano requer comprimentos dos ramos acima do limiar numérico de zero."],
"The sampler returned invalid or incomplete posterior draws.":["El muestreador devolvió muestras posteriores no válidas o incompletas.", "O amostrador retornou amostras posteriores inválidas ou incompletas."],
"One chain cannot assess between-chain convergence; split-Rhat is unavailable.":["Una cadena no permite evaluar convergencia entre cadenas; split-Rhat no está disponible.", "Uma cadeia não permite avaliar convergência entre cadeias; split-Rhat está indisponível."],
"Split-Rhat exceeds 1.01 or is unavailable. Do not treat this run as converged.":["Split-Rhat supera 1.01 o no está disponible. No considere esta ejecución convergente.", "Split-Rhat excede 1.01 ou está indisponível. Não considere esta execução convergente."],
"Effective sample size is below 400 or unavailable. Longer or better-tuned chains are needed.":["El tamaño efectivo de muestra es inferior a 400 o no está disponible. Se requieren cadenas más largas o mejor ajustadas.", "O tamanho efetivo da amostra é inferior a 400 ou está indisponível. São necessárias cadeias mais longas ou melhor ajustadas."],
"Bayesian BM samples the joint posterior of diffusion and all ancestral states. No ML likelihood or AIC ranking is reported.":["BM bayesiano muestrea la posterior conjunta de difusión y todos los estados ancestrales. No se presenta verosimilitud ML ni clasificación AIC.", "BM bayesiano amostra a posterior conjunta da difusão e de todos os estados ancestrais. Não é apresentada verossimilhança ML nem classificação AIC."],
"Posterior means and equal-tailed 95% credible intervals integrate diffusion and ancestral-state uncertainty under the specified priors; the tree is fixed. Inspect chain diagnostics before interpretation.":["Las medias posteriores e intervalos creíbles del 95% con colas iguales integran incertidumbre de difusión y estados ancestrales bajo los priors especificados; el árbol es fijo. Revise los diagnósticos antes de interpretar.", "As médias posteriores e intervalos de credibilidade de 95% com caudas iguais integram incerteza da difusão e dos estados ancestrais sob os priors especificados; a árvore é fixa. Revise os diagnósticos antes de interpretar."],
"Choose a saved Bayesian parameter for this graph.":["Seleccione un parámetro bayesiano guardado para este gráfico.", "Selecione um parâmetro bayesiano salvo para este gráfico."],

"Conditional 95% prediction intervals": ["Intervalos de predicción condicionales del 95%","Intervalos de predição condicionais de 95%"],
"Set both bounds, or leave both blank for defaults. Shape means alpha for OU and r for EB, in inverse branch-length units.":["Defina ambos límites o deje ambos vacíos para usar los predeterminados. El parámetro es alpha para OU y r para EB, en unidades inversas de longitud de rama.", "Defina ambos os limites ou deixe ambos vazios para usar os padrões. O parâmetro é alpha para OU e r para EB, em unidades inversas de comprimento de ramo."],
"Use comparable marginal ML":["Usar máxima verosimilitud marginal comparable", "Usar máxima verossimilhança marginal comparável"],
"Known standard-error column":["Columna de errores estándar conocidos", "Coluna de erros padrão conhecidos"],
"None (zero error)":["Ninguno (error cero)", "Nenhum (erro zero)"],
"Supply standard errors, not variances, on the selected trait scale. Errors are squared once and added only to observed-tip variances; they are not automatically transformed.":["Proporcione errores estándar, no varianzas, en la escala del carácter seleccionado. Se elevan al cuadrado una vez y se suman solo a las varianzas terminales; no se transforman automáticamente.", "Forneça erros padrão, não variâncias, na escala do caráter selecionado. São elevados ao quadrado uma vez e somados apenas às variâncias terminais; não são transformados automaticamente."],
"Compare BM, OU and EB using marginal ML":["Comparar BM, OU y EB con verosimilitud marginal", "Comparar BM, OU e EB com verossimilhança marginal"],
"Shape lower bound (blank = default)":["Límite inferior del parámetro de forma (vacío = predeterminado)", "Limite inferior do parâmetro de forma (vazio = padrão)"],
"Shape upper bound (blank = default)":["Límite superior del parámetro de forma (vacío = predeterminado)", "Limite superior do parâmetro de forma (vazio = padrão)"],
"OU uses one optimum equal to the root mean. Prediction intervals condition on fitted covariance parameters. Comparison uses the same taxa, trait scale and known errors; other models use their default bounds.":["OU utiliza un óptimo igual a la media de la raíz. Los intervalos de predicción condicionan los parámetros de covarianza ajustados. La comparación usa los mismos taxones, escala y errores conocidos; los otros modelos usan sus límites predeterminados.", "OU usa um ótimo igual à média da raiz. Os intervalos de predição condicionam os parâmetros de covariância ajustados. A comparação usa os mesmos táxons, escala e erros conhecidos; os outros modelos usam seus limites padrão."],
"Legacy anc.ML has no OU intervals or enabled measurement error. Use marginal ML for these features.":["El motor anterior anc.ML no tiene intervalos OU ni error de medición habilitado. Use verosimilitud marginal para estas funciones.", "O motor anterior anc.ML não tem intervalos OU nem erro de medição habilitado. Use verossimilhança marginal para esses recursos."],
"Marginal model comparison":["Comparación marginal de modelos", "Comparação marginal de modelos"],
"Download model comparison CSV":["Descargar comparación de modelos CSV", "Baixar comparação de modelos CSV"],
"AIC weights describe the candidate set, not certainty that a model is true. Boundary fits require caution. Failed candidates remain visible; weights are withheld if any candidate fails.":["Los pesos AIC describen el conjunto candidato, no la certeza de que un modelo sea verdadero. Interprete con cautela los ajustes en límites. Los candidatos fallidos permanecen visibles; no se calculan pesos si alguno falla.", "Os pesos AIC descrevem o conjunto candidato, não a certeza de que um modelo é verdadeiro. Interprete com cautela os ajustes nos limites. Candidatos com falha permanecem visíveis; os pesos não são calculados se algum falhar."],
"fastAnc diagnostics show BM contrasts. Other engines show decorrelated tip residuals using the fitted covariance; these are exploratory, order-dependent checks, not a calibrated model-adequacy test.":["Los diagnósticos de fastAnc muestran contrastes BM. Otros motores muestran residuos terminales decorrelacionados mediante la covarianza ajustada; son verificaciones exploratorias dependientes del orden, no pruebas calibradas de adecuación.", "Os diagnósticos de fastAnc mostram contrastes BM. Outros motores mostram resíduos terminais descorrelacionados pela covariância ajustada; são verificações exploratórias dependentes da ordem, não testes calibrados de adequação."],
"Unknown continuous covariance model.":["Modelo de covarianza continua desconocido.", "Modelo de covariância contínua desconhecido."],
"Select a separate numeric standard-error column.":["Seleccione una columna numérica separada de errores estándar.", "Selecione uma coluna numérica separada de erros padrão."],
"Standard errors must be finite, nonnegative and on the selected trait scale.":["Los errores estándar deben ser finitos, no negativos y estar en la escala del carácter seleccionado.", "Os erros padrão devem ser finitos, não negativos e estar na escala do caráter selecionado."],
"Invalid shape bounds: OU must be nonnegative; scaled bounds must lie within -100 to 100.":["Límites no válidos: OU debe ser no negativo; los límites escalados deben estar entre -100 y 100.", "Limites inválidos: OU deve ser não negativo; os limites escalados devem estar entre -100 e 100."],
"The starting shape parameter must lie within its bounds.":["El parámetro inicial de forma debe estar dentro de sus límites.", "O parâmetro inicial de forma deve estar dentro dos limites."],
"No marginal-likelihood optimization start converged.":["Ningún inicio de optimización de verosimilitud marginal convergió.", "Nenhum início de otimização de verossimilhança marginal convergiu."],
"Invalid conditional node variance.":["Varianza condicional de nodo no válida.", "Variância condicional do nó inválida."],
"A marginal model parameter is at a search bound; inspect bounds and model identifiability.":["Un parámetro marginal está en un límite de búsqueda; revise los límites y la identificabilidad del modelo.", "Um parâmetro marginal está em um limite de busca; revise os limites e a identificabilidade do modelo."],
"Some optimization starts failed; the best converged start is reported.":["Algunos inicios de optimización fallaron; se presenta el mejor inicio convergente.", "Alguns inícios de otimização falharam; é apresentado o melhor início convergente."],
"Marginal Gaussian tip-data ML; same observations and known measurement errors across BM/OU/EB. OU root equals its single optimum.":["Verosimilitud marginal gaussiana de datos terminales; mismas observaciones y errores de medición conocidos para BM/OU/EB. La raíz OU es igual a su único óptimo.", "Verossimilhança marginal gaussiana dos dados terminais; mesmas observações e erros de medição conhecidos para BM/OU/EB. A raiz OU é igual ao seu único ótimo."],
"Approximate 95% conditional prediction intervals include mean-estimation uncertainty; covariance parameters and tree are fixed at their fitted values.":["Los intervalos de predicción condicionales aproximados del 95% incluyen la incertidumbre de estimación de la media; los parámetros de covarianza y el árbol se mantienen fijos.", "Os intervalos de predição condicionais aproximados de 95% incluem a incerteza de estimação da média; os parâmetros de covariância e a árvore permanecem fixos."],
"Measurement error and model comparison require Gaussian ML.":["El error de medición y la comparación de modelos requieren Gaussian ML.", "O erro de medição e a comparação de modelos exigem Gaussian ML."],
"Run Gaussian ML with model comparison enabled.":["Ejecute Gaussian ML con la comparación de modelos habilitada.", "Execute Gaussian ML com a comparação de modelos habilitada."],
"ShapeLower":["Límite inferior", "Limite inferior"],
"ShapeUpper":["Límite superior", "Limite superior"],
"Boundary":["En límite", "No limite"],
"DeltaAIC":["Delta AIC", "Delta AIC"],
"AkaikeWeight":["Peso de Akaike", "Peso de Akaike"],

"Model diagnostics": ["Diagnósticos del modelo", "Diagnósticos do modelo"],
"Ancestral reconstruction":["Reconstrucción ancestral", "Reconstrução ancestral"],
"Continuous reconstruction requires a rooted, bifurcating tree.":["La reconstrucción continua requiere un árbol enraizado y bifurcante.", "A reconstrução contínua requer uma árvore enraizada e bifurcante."],
"Continuous reconstruction requires finite, positive branch lengths.":["La reconstrucción continua requiere longitudes de ramas finitas y positivas.", "A reconstrução contínua requer comprimentos de ramos finitos e positivos."],
"Continuous reconstruction needs a finite, nonconstant numeric trait. No rows are removed automatically.":["La reconstrucción continua necesita un carácter numérico finito y no constante. No se eliminan filas automáticamente.", "A reconstrução contínua precisa de um caráter numérico finito e não constante. Nenhuma linha é removida automaticamente."],

"BM engine":["Motor BM", "Motor BM"],
"Ornstein–Uhlenbeck (OU)":["Ornstein–Uhlenbeck (OU)", "Ornstein–Uhlenbeck (OU)"],
"Early burst (EB)":["Explosión temprana (EB)", "Explosão inicial (EB)"],
"Maximum iterations (maxit)":["Iteraciones máximas (maxit)", "Máximo de iterações (maxit)"],
"Positive parameter lower bound (tol; blank = backend default)":["Límite inferior positivo (tol; vacío = valor del motor)", "Limite inferior positivo (tol; vazio = padrão do motor)"],
"Print optimizer trace":["Imprimir traza del optimizador", "Imprimir rastreamento do otimizador"],
"Calculate approximate 95% node intervals":["Calcular intervalos aproximados del 95% para nodos", "Calcular intervalos aproximados de 95% para nós"],
"Initial alpha (OU) or r (EB); blank = backend default":["alpha inicial (OU) o r (EB); vacío = valor del motor", "alpha inicial (OU) ou r (EB); vazio = padrão do motor"],
"OU provides no node intervals. EB allows increasing as well as decreasing rates. Measurement error is not enabled.":["OU no proporciona intervalos de nodos. EB permite tasas crecientes y decrecientes. El error de medición no está habilitado.", "OU não fornece intervalos dos nós. EB permite taxas crescentes e decrescentes. O erro de medição não está habilitado."],
"Run continuous reconstruction":["Ejecutar reconstrucción continua", "Executar reconstrução contínua"],
"Choose a numeric trait and run continuous reconstruction.":["Seleccione un carácter numérico y ejecute la reconstrucción continua.", "Selecione um caráter numérico e execute a reconstrução contínua."],
"Inputs changed. Run continuous reconstruction to update results.":["Las entradas cambiaron. Ejecute la reconstrucción continua para actualizar los resultados.", "As entradas mudaram. Execute a reconstrução contínua para atualizar os resultados."],
"This framework is planned. Choose maximum likelihood.":["Este marco está previsto. Seleccione máxima verosimilitud.", "Este método está planejado. Selecione máxima verossimilhança."],
"Continuous reconstruction completed. Review uncertainty and diagnostics.":["Reconstrucción continua completada. Revise la incertidumbre y los diagnósticos.", "Reconstrução contínua concluída. Revise a incerteza e os diagnósticos."],
"Branch colors and phenogram lines interpolate node estimates; they are not conditional evolutionary trajectories.":["Los colores de ramas y líneas del fenograma interpolan estimaciones de nodos; no son trayectorias evolutivas condicionales.", "As cores dos ramos e linhas do fenograma interpolam estimativas dos nós; não são trajetórias evolutivas condicionais."],
"Marginal tip-data likelihood; root and diffusion estimated by ML.":["Verosimilitud marginal de datos terminales; raíz y difusión estimadas por máxima verosimilitud.", "Verossimilhança marginal dos dados terminais; raiz e difusão estimadas por máxima verossimilhança."],
"Joint tip and ancestral-state density from anc.ML; not comparable to marginal tip-data likelihood. No AIC ranking.":["Densidad conjunta de estados terminales y ancestrales de anc.ML; no comparable con la verosimilitud marginal terminal. Sin clasificación AIC.", "Densidade conjunta dos estados terminais e ancestrais de anc.ML; não comparável à verossimilhança marginal terminal. Sem classificação AIC."],
"Approximate 95% fastAnc/Rohlf intervals; no tree or model uncertainty.":["Intervalos aproximados del 95% de fastAnc/Rohlf; sin incertidumbre del árbol o modelo.", "Intervalos aproximados de 95% de fastAnc/Rohlf; sem incerteza da árvore ou modelo."],
"Approximate 95% Hessian intervals; no tree or model uncertainty.":["Intervalos aproximados del 95% basados en la Hessiana; sin incertidumbre del árbol o modelo.", "Intervalos aproximados de 95% baseados na Hessiana; sem incerteza da árvore ou modelo."],
"OU node intervals are unavailable from this engine.":["Este motor no proporciona intervalos de nodos para OU.", "Este motor não fornece intervalos dos nós para OU."],
"Node intervals were not requested.":["No se solicitaron intervalos de nodos.", "Não foram solicitados intervalos dos nós."],
"Node estimates; intervals unavailable":["Estimaciones de nodos; intervalos no disponibles", "Estimativas dos nós; intervalos indisponíveis"],
"Fitted covariance residual diagnostic":["Diagnóstico de residuos con covarianza ajustada", "Diagnóstico de resíduos com covariância ajustada"],
"Decorrelated tip residuals":["Residuos terminales decorrelacionados", "Resíduos terminais descorrelacionados"],
"Diffusion parameter (sig2)":["Parámetro de difusión (sig2)", "Parâmetro de difusão (sig2)"],
"Log likelihood (engine basis)":["Log-verosimilitud (base del motor)", "Log-verossimilhança (base do motor)"],
"Optimizer convergence":["Convergencia del optimizador", "Convergência do otimizador"],
"fastAnc diagnostics show BM contrasts. anc.ML diagnostics show decorrelated tip residuals using the fitted covariance; these are exploratory, order-dependent checks, not a calibrated model-adequacy test.":["Los diagnósticos de fastAnc muestran contrastes BM. Los de anc.ML muestran residuos terminales decorrelacionados con la covarianza ajustada; son verificaciones exploratorias dependientes del orden, no una prueba calibrada de adecuación.", "Os diagnósticos de fastAnc mostram contrastes BM. Os de anc.ML mostram resíduos terminais descorrelacionados com a covariância ajustada; são verificações exploratórias dependentes da ordem, não um teste calibrado de adequação."],
"An estimated parameter is at its lower bound; interpret with caution.":["Un parámetro estimado está en su límite inferior; interprete con cautela.", "Um parâmetro estimado está no limite inferior; interprete com cautela."],
"The installed anc.ML documentation cautions that the OU implementation has not been thoroughly tested. No OU node intervals are supplied.":["La documentación instalada de anc.ML advierte que OU no ha sido probado exhaustivamente. No se proporcionan intervalos de nodos OU.", "A documentação instalada de anc.ML alerta que OU não foi testado exaustivamente. Não são fornecidos intervalos dos nós OU."],
"The fitted EB rate increases through time (r > 0); the backend does not constrain it to an early burst.":["La tasa EB ajustada aumenta con el tiempo (r > 0); el motor no la restringe a una explosión temprana.", "A taxa EB ajustada aumenta ao longo do tempo (r > 0); o motor não a restringe a uma explosão inicial."],
"Choose fastAnc for BM or anc.ML for BM, OU or EB.":["Seleccione fastAnc para BM o anc.ML para BM, OU o EB.", "Selecione fastAnc para BM ou anc.ML para BM, OU ou EB."],
"Invalid continuous-engine switches.":["Opciones del motor continuo no válidas.", "Opções do motor contínuo inválidas."],
"Maximum iterations must be an integer from 1 to 100000.":["El máximo de iteraciones debe ser un entero de 1 a 100000.", "O máximo de iterações deve ser um inteiro de 1 a 100000."],
"The positive parameter lower bound must be finite and greater than zero.":["El límite inferior positivo debe ser finito y mayor que cero.", "O limite inferior positivo deve ser finito e maior que zero."],
"Use a finite EB rate start or an OU alpha start at or above the lower bound.":["Use una tasa inicial EB finita o un alpha inicial OU igual o superior al límite inferior.", "Use uma taxa inicial EB finita ou um alpha inicial OU igual ou superior ao limite inferior."],
"Continuous optimization returned invalid estimates or likelihood.":["La optimización continua devolvió estimaciones o verosimilitud no válidas.", "A otimização contínua retornou estimativas ou verossimilhança inválidas."],
"Node uncertainty is invalid; inspect the model or rerun without intervals.":["La incertidumbre de nodos no es válida; revise el modelo o ejecute sin intervalos.", "A incerteza dos nós é inválida; revise o modelo ou execute sem intervalos."],

"Fan layouts are available for node trees. Colored histories and continuous maps use phylograms.":["El diseño en abanico está disponible para árboles de nodos. Las historias coloreadas y los mapas continuos usan filogramas.", "O formato em leque está disponível para árvores de nós. Histórias coloridas e mapas contínuos usam filogramas."],
"Colored histories and continuous maps currently require a phylogram layout.":["Las historias coloreadas y los mapas continuos requieren actualmente un filograma.", "Histórias coloridas e mapas contínuos atualmente exigem um filograma."],

"Figure size and appearance":["Tamaño y apariencia de la figura", "Tamanho e aparência da figura"],
"Figure width (inches)":["Ancho de figura (pulgadas)", "Largura da figura (polegadas)"],
"Figure height (inches)":["Alto de figura (pulgadas)", "Altura da figura (polegadas)"],
"PNG resolution (dpi)":["Resolución PNG (ppp)", "Resolução PNG (dpi)"],
"Figure proportions apply to the preview, PDF and R exports. DPI applies to PNG only.":["Las proporciones se aplican a la vista previa y a las exportaciones PDF y R. La resolución se aplica solo a PNG.", "As proporções se aplicam à prévia e às exportações PDF e R. A resolução se aplica apenas ao PNG."],
"Fan":["Abanico", "Leque"],
"Label font":["Fuente de etiquetas", "Fonte dos rótulos"],
"Plain":["Normal", "Normal"],
"Bold":["Negrita", "Negrito"],
"Italic":["Cursiva", "Itálico"],
"Bold italic":["Negrita cursiva", "Negrito itálico"],
"Label offset (tree-height fraction)":["Separación de etiquetas (fracción de altura del árbol)", "Deslocamento dos rótulos (fração da altura da árvore)"],
"Preserve underscores":["Conservar guiones bajos", "Preservar sublinhados"],
"Line width":["Grosor de línea", "Espessura da linha"],
"Line type":["Tipo de línea", "Tipo de linha"],
"Solid":["Continua", "Contínua"],
"Dashed":["Discontinua", "Tracejada"],
"Dotted":["Punteada", "Pontilhada"],
"Dot dash":["Punto y raya", "Ponto e traço"],
"Long dash":["Raya larga", "Traço longo"],
"Two dash":["Doble raya", "Traço duplo"],
"Show legend":["Mostrar leyenda", "Mostrar legenda"],
"Legend text size":["Tamaño del texto de leyenda", "Tamanho do texto da legenda"],
"Legend columns (0 = automatic)":["Columnas de leyenda (0 = automático)", "Colunas da legenda (0 = automático)"],
"Color-bar length (tree-height fraction)":["Longitud de barra de color (fracción de altura del árbol)", "Comprimento da barra de cores (fração da altura da árvore)"],
"Color-map grid resolution":["Resolución de la cuadrícula de colores", "Resolução da grade de cores"],
"Outline colored branches":["Delinear ramas coloreadas", "Contornar ramos coloridos"],
"Custom colors":["Colores personalizados", "Cores personalizadas"],
"Gradient colors (hex, separated by commas)":["Colores del gradiente (hex, separados por comas)", "Cores do gradiente (hex, separadas por vírgulas)"],
"Fill colors from palette":["Rellenar colores desde la paleta", "Preencher cores a partir da paleta"],
"State colors: state,#RRGGBB":["Colores de estados: estado,#RRGGBB", "Cores dos estados: estado,#RRGGBB"],
"Leave blank to use the selected palette. Custom colors are display settings only.":["Deje en blanco para usar la paleta seleccionada. Los colores personalizados solo modifican la visualización.", "Deixe em branco para usar a paleta selecionada. As cores personalizadas só alteram a visualização."],
"Node display":["Visualización de nodos", "Exibição dos nós"],
"Probability pies":["Círculos de probabilidades", "Gráficos de probabilidades"],
"Most-supported state":["Estado con mayor soporte", "Estado com maior suporte"],
"Minimum state support":["Soporte mínimo del estado", "Suporte mínimo do estado"],
"A cross marks a tie or support below the threshold. Probabilities remain unchanged.":["Una cruz marca un empate o soporte inferior al umbral. Las probabilidades no cambian.", "Uma cruz marca empate ou suporte abaixo do limiar. As probabilidades não mudam."],
"Q diagram settings":["Ajustes del diagrama Q", "Configurações do diagrama Q"],
"Rate significant digits":["Cifras significativas de tasas", "Algarismos significativos das taxas"],
"Hide rates below":["Ocultar tasas menores que", "Ocultar taxas abaixo de"],
"Show zero-rate arrows":["Mostrar flechas de tasa cero", "Mostrar setas de taxa zero"],
"Show rate text":["Mostrar texto de tasas", "Mostrar texto das taxas"],
"Scale arrow widths by rates":["Escalar grosor de flechas según tasas", "Escalar espessura das setas pelas taxas"],
"Maximum arrow width":["Grosor máximo de flecha", "Espessura máxima da seta"],
"Diagram rotation (degrees)":["Rotación del diagrama (grados)", "Rotação do diagrama (graus)"],
"Arrow spacing":["Separación de flechas", "Espaçamento das setas"],
"These controls change the diagram only; Q and model constraints are unchanged.":["Estos controles solo cambian el diagrama; Q y las restricciones del modelo no cambian.", "Estes controles só alteram o diagrama; Q e as restrições do modelo não mudam."],
"Inspect saved node":["Inspeccionar nodo guardado", "Inspecionar nó salvo"],
"No highlighted node":["Ningún nodo resaltado", "Nenhum nó destacado"],
"Selected node":["Nodo seleccionado", "Nó selecionado"],
"Selected state":["Estado seleccionado", "Estado selecionado"],
"Destination state":["Estado de destino", "Estado de destino"],
"Density colors show mean occupancy within each grid segment across saved histories, conditional on Q and the tree. This is a display projection, not a new binary analysis.":["Los colores muestran la ocupación media dentro de cada segmento de la cuadrícula entre las historias guardadas, condicionada a Q y al árbol. Es una proyección visual, no un nuevo análisis binario.", "As cores mostram a ocupação média dentro de cada segmento da grade entre as histórias salvas, condicionada a Q e à árvore. É uma projeção visual, não uma nova análise binária."],
"Reset graph controls":["Restablecer controles del gráfico", "Redefinir controles do gráfico"],
"Download graph PNG":["Descargar gráfico PNG", "Baixar gráfico PNG"],
"Download graph settings and result RDS":["Descargar ajustes gráficos y resultado RDS", "Baixar configurações gráficas e resultado RDS"],
"Download selected node CSV":["Descargar nodo seleccionado CSV", "Baixar nó selecionado CSV"],
"Download density segments CSV":["Descargar segmentos de densidad CSV", "Baixar segmentos de densidade CSV"],
"Selected-state density map":["Mapa de densidad del estado seleccionado", "Mapa de densidade do estado selecionado"],
"Selected transition distribution":["Distribución de la transición seleccionada", "Distribuição da transição selecionada"],
"Sampled occupancy":["Ocupación muestreada", "Ocupação amostrada"],
"Selected state versus all others":["Estado seleccionado frente a todos los demás", "Estado selecionado versus todos os outros"],
"Unknown graphical setting.":["Ajuste gráfico desconocido.", "Configuração gráfica desconhecida."],
"Graphical numeric setting is outside its allowed range.":["El ajuste gráfico numérico está fuera del rango permitido.", "A configuração gráfica numérica está fora do intervalo permitido."],
"Graphical count settings must be integers.":["Los conteos gráficos deben ser enteros.", "As contagens gráficas devem ser inteiras."],
"Invalid graphical switch.":["Opción gráfica no válida.", "Opção gráfica inválida."],
"Invalid graphical choice.":["Selección gráfica no válida.", "Seleção gráfica inválida."],
"Colors require one state,color row per allowed state, without a header.":["Los colores requieren una fila estado,color por estado permitido, sin encabezado.", "As cores exigem uma linha estado,cor por estado permitido, sem cabeçalho."],
"Provide every state once with a six-digit hexadecimal color, such as #2277AA.":["Incluya cada estado una vez con un color hexadecimal de seis dígitos, como #2277AA.", "Inclua cada estado uma vez com uma cor hexadecimal de seis dígitos, como #2277AA."],
"Use two to eight six-digit hexadecimal gradient colors.":["Use entre dos y ocho colores hexadecimales de seis dígitos.", "Use entre duas e oito cores hexadecimais de seis dígitos."],
"Select an internal node from the saved result.":["Seleccione un nodo interno del resultado guardado.", "Selecione um nó interno do resultado salvo."],
"Select a state from saved stochastic histories.":["Seleccione un estado de las historias estocásticas guardadas.", "Selecione um estado das histórias estocásticas salvas."],
"Density resolution must be an integer from 20 to 500.":["La resolución de densidad debe ser un entero entre 20 y 500.", "A resolução de densidade deve ser um inteiro entre 20 e 500."],
"Density maps require all saved histories.":["Los mapas de densidad requieren todas las historias guardadas.", "Os mapas de densidade exigem todas as histórias salvas."],
"Select two different states for a saved transition distribution.":["Seleccione dos estados distintos para una distribución de transiciones guardada.", "Selecione dois estados diferentes para uma distribuição de transições salva."],
"Probability":["Probabilidad", "Probabilidade"],
"Joint":["Conjunto", "Conjunto"],

"Selected Q matrix":["Matriz Q seleccionada", "Matriz Q selecionada"],
"Starting values and effective calls are recorded per model. Convergence does not establish identifiability or model adequacy. Near-boundary rates and different optima require caution.":["Los valores iniciales y las llamadas efectivas se registran por modelo. La convergencia no establece identificabilidad ni adecuación del modelo. Las tasas cerca de los límites y los óptimos diferentes requieren cautela.", "Os valores iniciais e as chamadas efetivas são registrados por modelo. A convergência não estabelece identificabilidade nem adequação do modelo. Taxas próximas aos limites e ótimos diferentes exigem cautela."],
"Histories are conditional on the fitted Q matrix, observed tips, tree and the selected root probabilities. Rates and trees are not sampled. There is no MCMC burn-in.":["Las historias están condicionadas a la matriz Q seleccionada, los estados observados, el árbol y las probabilidades de raíz seleccionadas. No se muestrean tasas ni árboles. No hay descarte inicial MCMC.", "As histórias são condicionadas à matriz Q selecionada, aos estados observados, à árvore e às probabilidades da raiz selecionadas. Taxas e árvores não são amostradas. Não há descarte inicial MCMC."],
"Node pies show marginal state probabilities conditional on the fitted rates, tree and the selected root probabilities. They do not integrate parameter or tree uncertainty and are not sampled evolutionary histories.":["Los círculos nodales muestran probabilidades marginales condicionadas a las tasas seleccionadas, el árbol y las probabilidades de raíz seleccionadas. No integran incertidumbre de parámetros o del árbol y no son historias evolutivas muestreadas.", "Os gráficos dos nós mostram probabilidades marginais condicionadas às taxas selecionadas, à árvore e às probabilidades da raiz selecionadas. Não integram incerteza dos parâmetros ou da árvore e não são histórias evolutivas amostradas."],
"AIC comparisons use the same taxa, trait, tree and the selected root probabilities. Weights describe only distinct converged candidates; equivalent constraints are omitted. Failed candidates remain visible. No model averaging is performed.":["Las comparaciones AIC usan los mismos taxones, rasgo, árbol y probabilidades de raíz seleccionadas. Los pesos describen candidatos distintos convergentes; se omiten restricciones equivalentes. Los candidatos fallidos permanecen visibles. No se promedian modelos.", "As comparações AIC usam os mesmos táxons, característica, árvore e probabilidades da raiz selecionadas. Os pesos descrevem candidatos distintos convergentes; restrições equivalentes são omitidas. Candidatos com falha permanecem visíveis. Não há média de modelos."],
"Comparisons use the same taxa, complete state space and the selected root probabilities. AIC weights cover converged candidates only; no model averaging is performed.":["Las comparaciones usan los mismos taxones, el espacio completo de estados y las probabilidades de raíz seleccionadas. Los pesos AIC incluyen solo candidatos convergentes; no se promedian modelos.", "As comparações usam os mesmos táxons, o espaço completo de estados e as probabilidades da raiz selecionadas. Os pesos AIC incluem apenas candidatos convergentes; não há média de modelos."],

 "Advanced analysis controls":["Controles avanzados del análisis", "Controles avançados da análise"],
 "Root probabilities (pi)":["Probabilidades de raíz (pi)", "Probabilidades da raiz (pi)"],
 "Equal weights":["Pesos iguales", "Pesos iguais"],
 "Named custom weights":["Pesos personalizados por estado", "Pesos personalizados por estado"],
 "Fill equal root weights":["Rellenar pesos iguales de raíz", "Preencher pesos iguais da raiz"],
 "Root weights: state,weight":["Pesos de raíz: estado,peso", "Pesos da raiz: estado,peso"],
 "One named row per allowed state; weights are normalized to sum to one.":["Una fila por estado permitido; los pesos se normalizan para sumar uno.", "Uma linha por estado permitido; os pesos são normalizados para somar um."],
 "Transition rates":["Tasas de transición", "Taxas de transição"],
 "Estimate rates":["Estimar tasas", "Estimar taxas"],
 "Supply fixed Q":["Proporcionar Q fija", "Fornecer Q fixa"],
 "Fill Q template from constraints":["Rellenar plantilla Q según restricciones", "Preencher modelo Q conforme restrições"],
 "Fixed Q: named CSV matrix":["Q fija: matriz CSV con nombres", "Q fixa: matriz CSV com nomes"],
 "Rows are sources, columns are destinations. Include headers and negative row-sum diagonals. Turn off comparison.":["Las filas son orígenes y las columnas destinos. Incluya encabezados y diagonales negativas de suma de tasas. Desactive la comparación.", "As linhas são origens e as colunas destinos. Inclua cabeçalhos e diagonais negativas da soma das taxas. Desative a comparação."],
 "Optimization settings":["Ajustes de optimización", "Configurações de otimização"],
 "Guane: three deterministic starts":["Guane: tres inicios deterministas", "Guane: três inícios determinísticos"],
 "Use backend defaults":["Usar valores predeterminados del motor", "Usar valores padrão do motor"],
 "Custom starting rates":["Tasas iniciales personalizadas", "Taxas iniciais personalizadas"],
 "Backend defaults omit q.init, min.q, max.q, logscale and opt.method. Bounds and optimizer controls below apply only to Guane or custom starts.":["Los valores predeterminados omiten q.init, min.q, max.q, logscale y opt.method. Los límites y el optimizador solo se aplican a inicios Guane o personalizados.", "Os valores padrão omitem q.init, min.q, max.q, logscale e opt.method. Os limites e o otimizador só se aplicam a inícios Guane ou personalizados."],
 "Lower rate bound (min.q)":["Límite inferior de tasa (min.q)", "Limite inferior da taxa (min.q)"],
 "Optimizer (opt.method)":["Optimizador (opt.method)", "Otimizador (opt.method)"],
 "Optimize log rates (logscale)":["Optimizar logaritmos de tasas (logscale)", "Otimizar logaritmos das taxas (logscale)"],
 "Starting rates (q.init)":["Tasas iniciales (q.init)", "Taxas iniciais (q.init)"],
 "Enter one rate or one per positive constraint index, in index order. Turn off comparison.":["Ingrese una tasa o una por índice positivo de restricción, en orden de índices. Desactive la comparación.", "Insira uma taxa ou uma por índice positivo de restrição, em ordem de índices. Desative a comparação."],
 "Reconstruction output":["Resultado de reconstrucción", "Resultado da reconstrução"],
 "Global marginal probabilities":["Probabilidades marginales globales", "Probabilidades marginais globais"],
 "Joint assignments and global marginals":["Asignaciones conjuntas y marginales globales", "Atribuições conjuntas e marginais globais"],
 "Joint tolerance (tol)":["Tolerancia conjunta (tol)", "Tolerância conjunta (tol)"],
 "Joint assignments maximize the simultaneous ancestral configuration. Ties may occur; assignments are not probabilities.":["Las asignaciones conjuntas maximizan la configuración ancestral simultánea. Puede haber empates; las asignaciones no son probabilidades.", "As atribuições conjuntas maximizam a configuração ancestral simultânea. Pode haver empates; as atribuições não são probabilidades."],
 "Effective settings preview":["Vista previa de ajustes efectivos", "Prévia das configurações efetivas"],
 "Joint ancestral assignments":["Asignaciones ancestrales conjuntas", "Atribuições ancestrais conjuntas"],
 "Download analysis RDS":["Descargar análisis RDS", "Baixar análise RDS"],
 "Unknown advanced Mk setting.":["Ajuste avanzado Mk desconocido.", "Configuração avançada Mk desconhecida."],
 "Invalid advanced Mk choice.":["Opción avanzada Mk no válida.", "Opção avançada Mk inválida."],
 "Root weights require one state,weight row per allowed state, without a header.":["Los pesos requieren una fila estado,peso por estado permitido, sin encabezado.", "Os pesos exigem uma linha estado,peso por estado permitido, sem cabeçalho."],
 "Root weights must name every allowed state once, be finite and nonnegative, and have a positive sum.":["Los pesos deben nombrar cada estado permitido una vez, ser finitos y no negativos, y tener suma positiva.", "Os pesos devem nomear cada estado permitido uma vez, ser finitos e não negativos, e ter soma positiva."],
 "Fixed Q requires a named numeric square CSV matrix with all allowed states as row and column headers.":["Q fija requiere una matriz CSV numérica cuadrada con todos los estados permitidos en los encabezados de filas y columnas.", "Q fixa exige uma matriz CSV numérica quadrada com todos os estados permitidos nos cabeçalhos de linhas e colunas."],
 "Fixed Q must have nonnegative off-diagonal rates, negative row-sum diagonals and preserve forbidden transitions.":["Q fija debe tener tasas no negativas fuera de la diagonal, diagonales negativas de suma de tasas y respetar las transiciones prohibidas.", "Q fixa deve ter taxas não negativas fora da diagonal, diagonais negativas da soma das taxas e respeitar transições proibidas."],
 "Fixed Q must preserve the selected model rate-sharing constraints.":["Q fija debe respetar las tasas compartidas del modelo seleccionado.", "Q fixa deve respeitar as taxas compartilhadas do modelo selecionado."],
 "Joint tolerance must be finite and positive.":["La tolerancia conjunta debe ser finita y positiva.", "A tolerância conjunta deve ser finita e positiva."],
 "Rate bounds must be positive and finite, with the upper bound greater than the lower bound and 1e-8.":["Los límites deben ser positivos y finitos; el superior debe superar al inferior y a 1e-8.", "Os limites devem ser positivos e finitos; o superior deve superar o inferior e 1e-8."],
 "Starting rates must be one number or one per rate index, within the bounds.":["Las tasas iniciales deben ser un número o uno por índice de tasa, dentro de los límites.", "As taxas iniciais devem ser um número ou um por índice de taxa, dentro dos limites."],
 "Fixed Q: no optimization.":["Q fija: sin optimización.", "Q fixa: sem otimização."],
 "Invalid joint ancestral reconstruction.":["Reconstrucción ancestral conjunta no válida.", "Reconstrução ancestral conjunta inválida."],
 "Run joint reconstruction before viewing assignments.":["Ejecute la reconstrucción conjunta antes de ver las asignaciones.", "Execute a reconstrução conjunta antes de ver as atribuições."],
 "Turn off model comparison when supplying fixed Q.":["Desactive la comparación de modelos al proporcionar Q fija.", "Desative a comparação de modelos ao fornecer Q fixa."],
 "Turn off model comparison when supplying custom starting rates.":["Desactive la comparación de modelos al proporcionar tasas iniciales personalizadas.", "Desative a comparação de modelos ao fornecer taxas iniciais personalizadas."],
 "Root probabilities apply to combined states, not to constituent states. A+B represents coexistence, not uncertain coding.":["Las probabilidades de raíz se aplican a estados combinados, no a estados constituyentes. A+B representa coexistencia, no codificación incierta.", "As probabilidades da raiz se aplicam a estados combinados, não a estados constituintes. A+B representa coexistência, não codificação incerta."],

 'Phylogenetic signal':['Señal filogenética','Sinal filogenético'],
 'Ancestral state reconstruction':['Reconstrucción ancestral','Reconstrução ancestral'],
 'Diversification':['Diversificación','Diversificação'], 'SSE models':['Modelos SSE','Modelos SSE'],
 'PLANNED':['PREVISTO','PREVISTO'], 'YOUR RESEARCH WORKSPACE':['TU ESPACIO DE INVESTIGACIÓN','SEU ESPAÇO DE PESQUISA'],
 'PHYLOGENETIC COMPARATIVE METHODS':['MÉTODOS COMPARATIVOS FILOGENÉTICOS','MÉTODOS COMPARATIVOS FILOGENÉTICOS'],
 '01 / DATA & PARAMETERS':['01 / DATOS Y PARÁMETROS','01 / DADOS E PARÂMETROS'],
 'Phylogenetic tree':['Árbol filogenético','Árvore filogenética'], 'Trait table · CSV':['Tabla de rasgos · CSV','Tabela de características · CSV'],
 'Load example data':['Cargar datos de ejemplo','Carregar dados de exemplo'], 'Taxon column':['Columna de taxones','Coluna de táxons'],
 'Numeric trait':['Rasgo numérico','Característica numérica'], 'Random seed':['Semilla aleatoria','Semente aleatória'],
 'K randomizations':['Aleatorizaciones de K','Aleatorizações de K'], 'Use matched taxa':['Usar taxones coincidentes','Usar táxons correspondentes'],
 'Prunes unmatched taxa from both inputs. Review diagnostics first.':['Elimina taxones sin correspondencia. Revisa primero el diagnóstico.','Remove táxons sem correspondência. Revise primeiro o diagnóstico.'],
 'Run signal analysis':['Analizar señal','Analisar sinal'], 'Reset workspace':['Reiniciar','Reiniciar'],
 'Tree preview':['Vista del árbol','Visualização da árvore'], 'Trait preview':['Vista de rasgos','Visualização de características'],
 'Signal results':['Resultados de señal','Resultados de sinal'], 'Live Code Mirror':['Código en vivo','Código ao vivo'],
 'Diagnostics & activity':['Diagnóstico y actividad','Diagnóstico e atividade'], 'Data structure':['Estructura de datos','Estrutura dos dados'],
 'Graphic controls':['Controles gráficos','Controles gráficos'], '02 / TREE APPEARANCE':['02 / APARIENCIA DEL ÁRBOL','02 / APARÊNCIA DA ÁRVORE'],
 'Tree layout':['Diseño del árbol','Formato da árvore'], 'Direction':['Dirección','Direção'],
 'Use branch lengths':['Usar longitudes de ramas','Usar comprimentos dos ramos'], 'Show tip labels':['Mostrar nombres de taxones','Mostrar nomes dos táxons'],
 'Show node numbers':['Mostrar números de nodos','Mostrar números dos nós'], 'Label size':['Tamaño del texto','Tamanho do texto'],
 'Edge width':['Grosor de ramas','Espessura dos ramos'], 'Export tree · PDF':['Exportar árbol · PDF','Exportar árvore · PDF'],
 'Display settings do not modify your analysis data.':['Los ajustes visuales no modifican los datos del análisis.','As opções visuais não modificam os dados da análise.'],
 'Export R script':['Exportar script R','Exportar script R'], 'Tree':['Árbol','Árvore'], 'Traits':['Rasgos','Características'],
 'TREE TIPS':['TAXONES','TÁXONS'], 'TRAIT ROWS':['FILAS DE RASGOS','LINHAS DE DADOS'],
 'Rooted tree':['Árbol enraizado','Árvore enraizada'], 'Unrooted tree':['Árbol sin raíz','Árvore sem raiz'],
 'No tree loaded':['No hay árbol cargado','Nenhuma árvore carregada'],
 '✓ All checks passed. Ready for signal analysis.':['✓ Validación completa. Listo para analizar.','✓ Validação concluída. Pronto para analisar.'],
 'Load a phylogenetic tree.':['Carga un árbol filogenético.','Carregue uma árvore filogenética.'],
 'Load a CSV trait table.':['Carga una tabla de rasgos CSV.','Carregue uma tabela CSV.'],
 'Load your files or explore the example dataset.':['Carga tus archivos o explora los datos de ejemplo.','Carregue seus arquivos ou explore os dados de exemplo.'],
 'Example loaded: 10 species and one continuous trait.':['Ejemplo cargado: 10 especies y un rasgo continuo.','Exemplo carregado: 10 espécies e uma característica contínua.'],
 'Signal analysis completed. Results correspond to the current inputs.':['Análisis completo. Los resultados corresponden a los datos actuales.','Análise concluída. Os resultados correspondem aos dados atuais.'],
 'Built for transparent, reproducible evolutionary research.':['Para una investigación evolutiva transparente y reproducible.','Para uma pesquisa evolutiva transparente e reproduzível.'],
 'Local workspace · No data leaves this session':['Espacio local · Los datos permanecen en esta sesión','Espaço local · Os dados permanecem nesta sessão']
};

Object.assign(guaneTranslations,{
  "Phylo traits": [
    "Rasgos filogenéticos",
    "Características filogenéticas"
  ],
  "Phylogenetic Comparative Methods": [
    "Métodos Comparativos Filogenéticos",
    "Métodos Comparativos Filogenéticos"
  ],
  "Setting up": [
    "Configuración",
    "Configuração"
  ],
  "Load single tree": [
    "Cargar árbol individual",
    "Carregar árvore individual"
  ],
  "Load traits · CSV": [
    "Cargar rasgos · CSV",
    "Carregar características · CSV"
  ],
  "Seed": [
    "Semilla",
    "Semente"
  ],
  "Review mismatches before pruning. Changes are recorded in Diagnosis log.": [
    "Revisa las discrepancias antes de podar. Los cambios se registran en el registro de diagnóstico.",
    "Revise as divergências antes da poda. As alterações ficam no registro de diagnóstico."
  ],
  "Reset controls": [
    "Restablecer controles",
    "Redefinir controles"
  ],
  "Data": [
    "Datos",
    "Dados"
  ],
  "Checking data": [
    "Verificación de datos",
    "Verificação dos dados"
  ],
  "Diagnosis log": [
    "Registro de diagnóstico",
    "Registro de diagnóstico"
  ],
  "Export diagnosis log": [
    "Exportar registro de diagnóstico",
    "Exportar registro de diagnóstico"
  ],
  "Description / Messages": [
    "Descripción / Mensajes",
    "Descrição / Mensagens"
  ],
  "Structure": [
    "Estructura",
    "Estrutura"
  ],
  "Table controls": [
    "Controles de tabla",
    "Controles da tabela"
  ],
  "Preview rows": [
    "Filas de vista previa",
    "Linhas na visualização"
  ],
  "Export traits": [
    "Exportar rasgos",
    "Exportar características"
  ],
  "Export tree": [
    "Exportar árbol",
    "Exportar árvore"
  ],
  "Pagel's correlation": [
    "Correlación de Pagel",
    "Correlação de Pagel"
  ],
  "Discrete traits": [
    "Rasgos discretos",
    "Características discretas"
  ],
  "Continuous traits": [
    "Rasgos continuos",
    "Características contínuas"
  ],
  "Polymorphic traits": [
    "Rasgos polimórficos",
    "Características polimórficas"
  ],
  "Diversification rates": [
    "Tasas de diversificación",
    "Taxas de diversificação"
  ],
  "Character-dependent diversification": [
    "Diversificación dependiente del carácter",
    "Diversificação dependente do caráter"
  ],
  "Analysis workspace": [
    "Espacio de análisis",
    "Espaço de análise"
  ],
  "Analysis execution is not implemented yet. Prepare and inspect inputs in the Data card.": [
    "La ejecución del análisis aún no está implementada. Prepara e inspecciona los datos en la tarjeta Datos.",
    "A execução da análise ainda não está implementada. Prepare e inspecione os dados no cartão Dados."
  ],
  "Inputs come from the Data card. Changing data or analytical settings clears previous results.": [
    "Los datos provienen de la tarjeta Datos. Cambiar datos o parámetros borra los resultados anteriores.",
    "Os dados vêm do cartão Dados. Alterar dados ou parâmetros limpa os resultados anteriores."
  ],
  "Normality of a trait does not establish normality of regression residuals. Inspect model diagnostics after fitting.": [
    "La normalidad de un rasgo no establece la normalidad de los residuos de regresión. Revisa los diagnósticos después del ajuste.",
    "A normalidade de uma característica não estabelece a normalidade dos resíduos da regressão. Inspecione os diagnósticos após o ajuste."
  ],
  "Shapiro–Wilk normality test": [
    "Prueba de normalidad de Shapiro–Wilk",
    "Teste de normalidade de Shapiro–Wilk"
  ],
  "Transformation": [
    "Transformación",
    "Transformação"
  ],
  "Natural log": [
    "Logaritmo natural",
    "Logaritmo natural"
  ],
  "Exponential": [
    "Exponencial",
    "Exponencial"
  ],
  "Quadratic": [
    "Cuadrática",
    "Quadrática"
  ],
  "Reciprocal": [
    "Recíproca",
    "Recíproca"
  ],
  "Create transformed column": [
    "Crear columna transformada",
    "Criar coluna transformada"
  ],
  "Compute independent contrasts · ape": [
    "Calcular contrastes independientes · ape",
    "Calcular contrastes independentes · ape"
  ],
  "Contrasts are node-level data, separate from the species table. Contrast regression must be fitted through the origin.": [
    "Los contrastes son datos por nodo, separados de la tabla de especies. Su regresión debe ajustarse pasando por el origen.",
    "Os contrastes são dados por nó, separados da tabela de espécies. Sua regressão deve ser ajustada passando pela origem."
  ],
  "Phylogram": [
    "Filograma",
    "Filograma"
  ],
  "Cladogram": [
    "Cladograma",
    "Cladograma"
  ],
  "Fan": [
    "Abanico",
    "Leque"
  ],
  "Left to right": [
    "Izquierda a derecha",
    "Esquerda para direita"
  ],
  "Right to left": [
    "Derecha a izquierda",
    "Direita para esquerda"
  ],
  "Top to bottom": [
    "Arriba hacia abajo",
    "De cima para baixo"
  ],
  "Browse...": [
    "Examinar...",
    "Procurar..."
  ],
  "No file selected": [
    "Ningún archivo seleccionado",
    "Nenhum arquivo selecionado"
  ],
  "Time": [
    "Fecha y hora",
    "Data e hora"
  ],
  "Action": [
    "Acción",
    "Ação"
  ],
  "Metric": [
    "Métrica",
    "Métrica"
  ],
  "Estimate": [
    "Estimación",
    "Estimativa"
  ],
  "P_value": [
    "Valor p",
    "Valor p"
  ],
  "Test": [
    "Prueba",
    "Teste"
  ],
  "Required:": [
    "Requerido:",
    "Obrigatório:"
  ],
  "Error:": [
    "Error:",
    "Erro:"
  ],
  "Warning:": [
    "Advertencia:",
    "Aviso:"
  ],
  "Note:": [
    "Nota:",
    "Nota:"
  ],
  "Tree loaded.": [
    "Árbol cargado.",
    "Árvore carregada."
  ],
  "Trait table loaded.": [
    "Tabla de rasgos cargada.",
    "Tabela de características carregada."
  ],
  "Workspace reset. Load new files or example data.": [
    "Espacio restablecido. Carga archivos nuevos o datos de ejemplo.",
    "Espaço redefinido. Carregue novos arquivos ou dados de exemplo."
  ],
  "Run an analysis on validated data to see results.": [
    "Ejecuta un análisis con datos validados para ver resultados.",
    "Execute uma análise com dados validados para ver resultados."
  ],
  "Estimating phylogenetic signal": [
    "Estimando la señal filogenética",
    "Estimando o sinal filogenético"
  ],
  "Tree tip labels must be unique.": [
    "Los nombres de los taxones del árbol deben ser únicos.",
    "Os nomes dos táxons da árvore devem ser únicos."
  ],
  "Tree contains empty taxon labels.": [
    "El árbol contiene nombres de taxones vacíos.",
    "A árvore contém nomes de táxons vazios."
  ],
  "Signal analysis requires finite, positive branch lengths.": [
    "El análisis requiere longitudes de ramas finitas y positivas.",
    "A análise requer comprimentos de ramos finitos e positivos."
  ],
  "Root the tree before signal analysis.": [
    "Enraíza el árbol antes del análisis de señal.",
    "Enraíze a árvore antes da análise de sinal."
  ],
  "Tree contains polytomies; inspect their biological meaning.": [
    "El árbol contiene politomías; revisa su significado biológico.",
    "A árvore contém politomias; examine seu significado biológico."
  ],
  "Tree is not ultrametric. Signal analysis can use it; verify branch-length units.": [
    "El árbol no es ultramétrico. Puede usarse para señal; verifica las unidades de las ramas.",
    "A árvore não é ultramétrica. Pode ser usada para sinal; verifique as unidades dos ramos."
  ],
  "Select the taxon column.": [
    "Selecciona la columna de taxones.",
    "Selecione a coluna de táxons."
  ],
  "Trait table contains empty taxon labels.": [
    "La tabla contiene nombres de taxones vacíos.",
    "A tabela contém nomes de táxons vazios."
  ],
  "Trait taxon labels must be unique.": [
    "Los nombres de taxones de la tabla deben ser únicos.",
    "Os nomes dos táxons da tabela devem ser únicos."
  ],
  "Select a numeric trait.": [
    "Selecciona un rasgo numérico.",
    "Selecione uma característica numérica."
  ],
  "Selected trait must contain only finite numeric values; correct missing values before running.": [
    "El rasgo debe contener valores numéricos finitos; corrige los valores ausentes antes del análisis.",
    "A característica deve conter valores numéricos finitos; corrija valores ausentes antes da análise."
  ],
  "Selected trait has no variation.": [
    "El rasgo seleccionado no tiene variación.",
    "A característica selecionada não tem variação."
  ],
  "At least four matched taxa are required.": [
    "Se requieren al menos cuatro taxones coincidentes.",
    "São necessários pelo menos quatro táxons correspondentes."
  ],
  "Correct nonfinite values first.": [
    "Corrige primero los valores no finitos.",
    "Corrija primeiro os valores não finitos."
  ],
  "Log requires positive values.": [
    "El logaritmo requiere valores positivos.",
    "O logaritmo requer valores positivos."
  ],
  "Reciprocal requires nonzero values.": [
    "La recíproca requiere valores distintos de cero.",
    "A recíproca requer valores diferentes de zero."
  ],
  "Transformation produced nonfinite values.": [
    "La transformación produjo valores no finitos.",
    "A transformação produziu valores não finitos."
  ],
  "That derived column already exists. Select another source or reset.": [
    "La columna derivada ya existe. Selecciona otra fuente o restablece los datos.",
    "A coluna derivada já existe. Selecione outra origem ou redefina os dados."
  ],
  "Resolve data issues before computing contrasts.": [
    "Resuelve los problemas de datos antes de calcular contrastes.",
    "Resolva os problemas dos dados antes de calcular contrastes."
  ],
  "Independent contrasts require a bifurcating tree.": [
    "Los contrastes independientes requieren un árbol bifurcante.",
    "Os contrastes independentes requerem uma árvore bifurcante."
  ],
  "Correct duplicate or missing taxon labels before matching.": [
    "Corrige nombres de taxones duplicados o ausentes antes de emparejar.",
    "Corrija nomes de táxons duplicados ou ausentes antes de combinar."
  ],
  "Fewer than four taxa overlap; upload compatible data.": [
    "Coinciden menos de cuatro taxones; carga datos compatibles.",
    "Menos de quatro táxons correspondem; carregue dados compatíveis."
  ],
  "Choose 99–9999 integer randomizations.": [
    "Elige entre 99 y 9999 aleatorizaciones enteras.",
    "Escolha entre 99 e 9999 aleatorizações inteiras."
  ],
  "Choose a nonnegative integer seed up to 2147483647.": [
    "Elige una semilla entera no negativa hasta 2147483647.",
    "Escolha uma semente inteira não negativa até 2147483647."
  ],
  "Shapiro-Wilk requires 3–5000 finite, nonconstant values.": [
    "Shapiro-Wilk requiere entre 3 y 5000 valores finitos y no constantes.",
    "Shapiro-Wilk requer entre 3 e 5000 valores finitos e não constantes."
  ],
  "Pagel's correlation: test two binary traits.": [
    "Correlación de Pagel: evaluar dos rasgos binarios.",
    "Correlação de Pagel: testar duas características binárias."
  ],
  "gls(): Brownian motion, Grafen, Pagel and Blomberg correlation structures.": [
    "gls(): estructuras de correlación de movimiento browniano, Grafen, Pagel y Blomberg.",
    "gls(): estruturas de correlação de movimento browniano, Grafen, Pagel e Blomberg."
  ],
  "phylolm / brms: logistic, Poisson and binomial models with multiple predictors.": [
    "phylolm / brms: modelos logísticos, Poisson y binomiales con múltiples predictores.",
    "phylolm / brms: modelos logísticos, Poisson e binomiais com múltiplos preditores."
  ]
});

Object.assign(guaneTranslations,{"Lineage through time": ["Linajes a través del tiempo", "Linhagens ao longo do tempo"], "Uses the tree from Data; a trait table is not required.": ["Usa el árbol de Datos; no requiere tabla de rasgos.", "Usa a árvore de Dados; não requer tabela de características."], "Run LTT": ["Ejecutar LTT", "Executar LTT"], "Logarithmic lineage axis": ["Eje de linajes logarítmico", "Eixo de linhagens logarítmico"], "Export LTT table": ["Exportar tabla LTT", "Exportar tabela LTT"], "Export LTT script": ["Exportar script LTT", "Exportar script LTT"], "Computed lineage-through-time curve.": ["Curva de linajes a través del tiempo calculada.", "Curva de linhagens ao longo do tempo calculada."], "Bifurcating tree": ["Árbol bifurcante", "Árvore bifurcante"], "Ultrametric tree": ["Árbol ultramétrico", "Árvore ultramétrica"], "Not ultrametric": ["No ultramétrico", "Não ultramétrica"], "Tree contains polytomies": ["El árbol contiene politomías", "A árvore contém politomias"], "Describes branching through time. Incomplete sampling can bias this pattern; this is not an estimate of speciation or extinction rates.": ["Describe la ramificación en el tiempo. El muestreo incompleto puede sesgar el patrón; no estima tasas de especiación o extinción.", "Descreve a ramificação no tempo. A amostragem incompleta pode enviesar o padrão; não estima taxas de especiação ou extinção."]});
function dynamicTranslation(text) {
 const signalDraws = text.match(/^(\d+) test draws \(including observed\)$/);
 if (signalDraws) return [`${signalDraws[1]} muestras de prueba (incluida la observada)`, `${signalDraws[1]} amostras do teste (incluindo a observada)`];
 let m;
 if((m=text.match(/^Selected taxon column: (.*) ; trait: (.*)$/))) return [`Columna de taxones: ${m[1]}; rasgo: ${m[2]}`,`Coluna de táxons: ${m[1]}; característica: ${m[2]}`];
 if((m=text.match(/^Created (.*) from (.*) using (.*) ; original column preserved\.$/))) return [`Columna ${m[1]} creada a partir de ${m[2]} mediante ${m[3]}; columna original conservada.`,`Coluna ${m[1]} criada a partir de ${m[2]} usando ${m[3]}; coluna original preservada.`];
 if((m=text.match(/^Shapiro-Wilk test: (.*)$/))) return [`Prueba de Shapiro-Wilk: ${m[1]}`,`Teste de Shapiro-Wilk: ${m[1]}`];
 if((m=text.match(/^Computed ape::pic for (.*) ; contrasts retained separately from species data\.$/))) return [`ape::pic calculado para ${m[1]}; contrastes separados de los datos de especies.`,`ape::pic calculado para ${m[1]}; contrastes separados dos dados de espécies.`];
 if((m=text.match(/^User requested matching; (\d+) unmatched entries removed\. Export the standardized inputs with your script\.$/))) return [`Emparejamiento solicitado: ${m[1]} entradas sin correspondencia eliminadas. Exporta los datos estandarizados con el script.`,`Correspondência solicitada: ${m[1]} entradas sem correspondência removidas. Exporte os dados padronizados com o script.`];
 if((m=text.match(/^(\d+) randomizations$/))) return [`${m[1]} aleatorizaciones`,`${m[1]} aleatorizações`];
 if(text==='Likelihood ratio: lambda = 0') return ['Razón de verosimilitud: lambda = 0','Razão de verossimilhança: lambda = 0'];
 if((m=text.match(/^Taxon mismatch: (\d+) tree tips without traits; (\d+) table taxa outside tree\. Use matched taxa only after reviewing this report\.$/))) return [`Discrepancia de taxones: ${m[1]} taxones del árbol sin rasgos; ${m[2]} taxones de la tabla fuera del árbol. Revisa este informe antes de emparejar.`,`Divergência de táxons: ${m[1]} táxons da árvore sem características; ${m[2]} táxons da tabela fora da árvore. Revise este relatório antes de combinar.`];
 return null;
}
window.addEventListener('DOMContentLoaded', () => {
 const originals = new WeakMap();
 function translate() {
  const lang = document.getElementById('lang')?.value || 'en';
  document.documentElement.lang = lang;
  const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT); let node;
  while ((node = walker.nextNode())) {
   const el=node.parentElement;
   // Never translate research data, identifiers, code, or language names.
   if (el.closest('script,style,pre,code,#lang,[id$="-traits_table"],[id$="-pgls_coefficients"],[id$="-pgls_metadata"],[id$="-pagel_mapping"],[id$="-pglm_coefficients"],[id$="-pglm_response"],[id$="-pglm_event"],[id$="-pglm_trials"],[id$="-pglm_predictors"],[id$="-pglm_categorical"],[id$="-pglm_coding"],[id$="-poly_order"],[id$="-poly_preview"],[id$="-poly_transitions"],[id$="-poly_occupancy"],[id$="-poly_mc_table"],[id$="-poly_trait"],[id$="-poly_coding"],[id$="-poly_constraints"],[id$="-poly_probabilities"],[id$="-poly_q"],[id$="-poly_metadata"],[id$="-poly_comparison"],[id$="-poly_attempts"],[id$="-mk_trait"],[id$="-mk_states"],[id$="-mk_matrix"],[id$="-mk_probabilities"],[id$="-mk_q"],[id$="-mk_transitions"],[id$="-mk_occupancy"],[id$="-mk_mc_table"],[id$="-mk_metadata"],[id$="-mk_comparison"],[id$="-mk_attempts"],[id$="-bm_trait"],[id$="-bm_metadata"],[id$="-bm_estimates"],[id$="-bm_summary"],[id$="-pgls_comparison"],[id$="-pglm_taxa_screen"],[id$="-pglm_category_screen"],[id$="-pglm_influence_table"],[id$="-pglm_references"] strong,[id$="-signal_trait"],[id$="-pagel_x"],[id$="-pagel_y"],[id$="-signal_metadata"] strong,[id$="-pgls_response"],[id$="-pgls_predictors"],[id$="-taxon"],[id$="-trait"]') ||
       (el.closest('.selectize-control') && el.closest('.shiny-input-container')?.querySelector('select')?.id?.match(/-(taxon|trait|dist_column|pgls_response|pgls_predictors|pagel_x|pagel_y|signal_trait|pglm_response|pglm_event|pglm_predictors|pglm_categorical|pglm_ref_[0-9]+|pglm_trials|bm_trait|mk_trait|poly_trait)$/))) continue;
   const current=node.textContent.trim();
   let saved=originals.get(node);
   if (!saved || current!==saved.last) saved={key:current,last:current};
   const entry=guaneTranslations[saved.key] || dynamicTranslation(saved.key); if(!entry) continue;
   const next=lang==='es'?entry[0]:lang==='pt'?entry[1]:saved.key;
   if(current!==next) node.textContent=node.textContent.replace(current,next);
   originals.set(node,{key:saved.key,last:next});
  }
  document.querySelectorAll('input[placeholder]').forEach(el=>{
   if(!el.dataset.originalPlaceholder) el.dataset.originalPlaceholder=el.placeholder;
   const key=el.dataset.originalPlaceholder,entry=guaneTranslations[key];
   if(entry) el.placeholder=lang==='es'?entry[0]:lang==='pt'?entry[1]:key;
  });
 }
 new MutationObserver(translate).observe(document.body,{childList:true,subtree:true,characterData:true});
 document.getElementById('lang').addEventListener('change',translate);
 translate();
});

Object.assign(guaneTranslations,{'Analysis controls':['Controles de análisis','Controles da análise'],'Results':['Resultados','Resultados'],'Diagnostics':['Diagnósticos','Diagnósticos'],'Chatbot is planned. No messages are sent and no AI service is connected.':['Chatbot previsto. No se envían mensajes ni hay un servicio de IA conectado.','Chatbot previsto. Nenhuma mensagem é enviada e nenhum serviço de IA está conectado.'],'Code will appear when this analysis is implemented.':['El código aparecerá cuando se implemente el análisis.','O código aparecerá quando a análise for implementada.']});

Object.assign(guaneTranslations,{'Data distribution':['Distribución de datos','Distribuição dos dados'],'Distribution plot':['Gráfico de distribución','Gráfico de distribuição'],'Histogram':['Histograma','Histograma'],'Density':['Densidad','Densidade'],'Normal Q–Q':['Q–Q normal','Q–Q normal'],'Histogram bins':['Intervalos del histograma','Intervalos do histograma'],'Show individual observations':['Mostrar observaciones individuales','Mostrar observações individuais'],'Export distribution · PDF':['Exportar distribución · PDF','Exportar distribuição · PDF']});

Object.assign(guaneTranslations,{'Column to display':['Columna para visualizar','Coluna para visualizar']});

Object.assign(guaneTranslations,{'Undo data change':['Deshacer cambio de datos','Desfazer alteração dos dados'],'Restore original inputs':['Restaurar datos originales','Restaurar dados originais'],'No data changes to undo.':['No hay cambios para deshacer.','Não há alterações para desfazer.']});

Object.assign(guaneTranslations,{'Export preparation script':['Exportar script de preparación','Exportar script de preparação']});

Object.assign(guaneTranslations, {
 "Response": [
  "Respuesta",
  "Resposta"
 ],
 "Predictors": [
  "Predictores",
  "Preditores"
 ],
 "Correlation structure": [
  "Estructura de correlación",
  "Estrutura de correlação"
 ],
 "Initial or fixed parameter (rho / lambda / g)": [
  "Parámetro inicial o fijo (rho / lambda / g)",
  "Parâmetro inicial ou fixo (rho / lambda / g)"
 ],
 "Keep correlation parameter fixed": [
  "Mantener fijo el parámetro de correlación",
  "Manter fixo o parâmetro de correlação"
 ],
 "Estimation method": [
  "Método de estimación",
  "Método de estimação"
 ],
 "Uses prepared species data. Do not supply PIC values. This version requires an ultrametric tree.": [
  "Usa datos preparados de especies. No introduzca valores PIC. Esta versión requiere un árbol ultramétrico.",
  "Usa dados preparados de espécies. Não forneça valores PIC. Esta versão requer uma árvore ultramétrica."
 ],
 "Grafen replaces branch lengths using topology; the uploaded tree remains unchanged.": [
  "Grafen reemplaza las longitudes de rama según la topología; el árbol cargado permanece intacto.",
  "Grafen substitui os comprimentos dos ramos usando a topologia; a árvore carregada permanece intacta."
 ],
 "Run PGLS": [
  "Ejecutar PGLS",
  "Executar PGLS"
 ],
 "Graph controls": [
  "Controles del gráfico",
  "Controles do gráfico"
 ],
 "Graph": [
  "Gráfico",
  "Gráfico"
 ],
 "Observed versus fitted": [
  "Observado frente a ajustado",
  "Observado versus ajustado"
 ],
 "Coefficient intervals": [
  "Intervalos de coeficientes",
  "Intervalos dos coeficientes"
 ],
 "Residual diagnostics": [
  "Diagnóstico de residuos",
  "Diagnóstico de resíduos"
 ],
 "Plot color": [
  "Color del gráfico",
  "Cor do gráfico"
 ],
 "Guane green": [
  "Verde Guane",
  "Verde Guane"
 ],
 "Legacy cyan": [
  "Cian clásico",
  "Ciano clássico"
 ],
 "Grayscale": [
  "Escala de grises",
  "Escala de cinza"
 ],
 "Show taxon labels": [
  "Mostrar etiquetas de taxones",
  "Mostrar rótulos dos táxons"
 ],
 "Download graph PDF": [
  "Descargar gráfico PDF",
  "Baixar gráfico PDF"
 ],
 "Download graph R code": [
  "Descargar código R del gráfico",
  "Baixar código R do gráfico"
 ],
 "Download coefficients CSV": [
  "Descargar coeficientes CSV",
  "Baixar coeficientes CSV"
 ],
 "Intervals are 95% t intervals conditional on the fitted covariance. The dashed diagonal represents perfect agreement, not a regression line.": [
  "Los intervalos t del 95% son condicionales a la covarianza ajustada. La diagonal discontinua representa concordancia perfecta, no una recta de regresión.",
  "Os intervalos t de 95% são condicionais à covariância ajustada. A diagonal tracejada representa concordância perfeita, não uma reta de regressão."
 ],
 "Each coefficient describes the response change per predictor unit, holding other predictors constant. Association does not establish causation.": [
  "Cada coeficiente describe el cambio de respuesta por unidad del predictor, manteniendo constantes los demás predictores. La asociación no establece causalidad.",
  "Cada coeficiente descreve a mudança na resposta por unidade do preditor, mantendo constantes os demais preditores. Associação não estabelece causalidade."
 ],
 "Inspect normalized residuals for patterns and Q-Q departures. Trait normality is not residual normality.": [
  "Inspeccione patrones y desviaciones Q-Q en los residuos normalizados. La normalidad del rasgo no es la normalidad residual.",
  "Inspecione padrões e desvios Q-Q nos resíduos normalizados. A normalidade da característica não é a normalidade residual."
 ],
 "The graph R script embeds prepared inputs, refits the model and draws the selected graph. Edit it in RStudio without Guane.": [
  "El script R incluye los datos preparados, vuelve a ajustar el modelo y dibuja el gráfico seleccionado. Edítelo en RStudio sin Guane.",
  "O script R inclui os dados preparados, reajusta o modelo e desenha o gráfico selecionado. Edite-o no RStudio sem Guane."
 ],
 "Choose variables and run PGLS.": [
  "Seleccione variables y ejecute PGLS.",
  "Selecione variáveis e execute PGLS."
 ],
 "Inputs changed. Run PGLS to update results.": [
  "Los datos cambiaron. Ejecute PGLS para actualizar los resultados.",
  "Os dados mudaram. Execute PGLS para atualizar os resultados."
 ],
 "PGLS completed. Review residual diagnostics and fit warnings.": [
  "PGLS completado. Revise el diagnóstico de residuos y las advertencias del ajuste.",
  "PGLS concluído. Revise os diagnósticos de resíduos e os avisos do ajuste."
 ],
 "No fitting warnings reported. Inspect diagnostics before interpretation.": [
  "No se notificaron advertencias del ajuste. Inspeccione los diagnósticos antes de interpretar.",
  "Nenhum aviso de ajuste relatado. Inspecione os diagnósticos antes de interpretar."
 ],
 "PGLS requires a rooted, bifurcating tree.": [
  "PGLS requiere un árbol enraizado y bifurcante.",
  "PGLS requer uma árvore enraizada e bifurcante."
 ],
 "PGLS requires finite, positive branch lengths.": [
  "PGLS requiere longitudes de rama finitas y positivas.",
  "PGLS requer comprimentos de ramos finitos e positivos."
 ],
 "This PGLS implementation requires an ultrametric tree.": [
  "Esta implementación de PGLS requiere un árbol ultramétrico.",
  "Esta implementação de PGLS requer uma árvore ultramétrica."
 ],
 "Select a unique taxon column in the trait table.": [
  "Seleccione una columna única de taxones en la tabla.",
  "Selecione uma coluna única de táxons na tabela."
 ],
 "Match unique, nonempty taxon labels explicitly in Data before PGLS.": [
  "Empareje etiquetas de taxones únicas y no vacías en Datos antes de PGLS.",
  "Associe rótulos de táxons únicos e não vazios em Dados antes de PGLS."
 ],
 "Select a response and distinct numeric predictors.": [
  "Seleccione una respuesta y predictores numéricos distintos.",
  "Selecione uma resposta e preditores numéricos distintos."
 ],
 "PGLS variables must be finite, numeric and nonconstant. No rows are removed automatically.": [
  "Las variables PGLS deben ser finitas, numéricas y no constantes. No se eliminan filas automáticamente.",
  "As variáveis PGLS devem ser finitas, numéricas e não constantes. Nenhuma linha é removida automaticamente."
 ],
 "PGLS needs at least four taxa and at least two residual degrees of freedom.": [
  "PGLS necesita al menos cuatro taxones y dos grados de libertad residuales.",
  "PGLS precisa de pelo menos quatro táxons e dois graus de liberdade residuais."
 ],
 "Use lambda between 0 and 1, or a positive rho or g.": [
  "Use lambda entre 0 y 1, o rho o g positivos.",
  "Use lambda entre 0 e 1, ou rho ou g positivos."
 ],
 "Predictors are collinear. Choose an independent set of predictors.": [
  "Los predictores son colineales. Seleccione un conjunto independiente.",
  "Os preditores são colineares. Selecione um conjunto independente."
 ],
 "PGLS returned an invalid fit; inspect inputs and correlation settings.": [
  "PGLS produjo un ajuste inválido; inspeccione los datos y la configuración de correlación.",
  "PGLS produziu um ajuste inválido; inspecione os dados e as configurações de correlação."
 ],
 "Estimated lambda is outside the supported interval [0, 1]. Try a fixed value or another structure.": [
  "La lambda estimada está fuera del intervalo admitido [0, 1]. Pruebe un valor fijo u otra estructura.",
  "O lambda estimado está fora do intervalo aceito [0, 1]. Tente um valor fixo ou outra estrutura."
 ],
 "Fitted values": [
  "Valores ajustados",
  "Valores ajustados"
 ],
 "Observed values": [
  "Valores observados",
  "Valores observados"
 ],
 "Coefficient estimate": [
  "Estimación del coeficiente",
  "Estimativa do coeficiente"
 ],
 "95% coefficient intervals": [
  "Intervalos de coeficientes del 95%",
  "Intervalos dos coeficientes de 95%"
 ],
 "Normalized residuals": [
  "Residuos normalizados",
  "Resíduos normalizados"
 ]
});

Object.assign(guaneTranslations, {"Pagel's 1994 Discrete Correlation Test": ["Prueba de correlación discreta de Pagel (1994)", "Teste de correlação discreta de Pagel (1994)"], "Tests correlated evolution of two binary traits by comparing independent and dependent evolutionary models.": ["Evalúa la evolución correlacionada de dos rasgos binarios comparando modelos evolutivos independientes y dependientes.", "Testa a evolução correlacionada de duas características binárias comparando modelos evolutivos independentes e dependentes."]});

Object.assign(guaneTranslations, {"K test draws (including observed)": ["Muestras de la prueba K (incluida la observada)", "Amostras do teste K (incluindo a observada)"], "The K test uses one observed draw and the remaining randomized draws.": ["La prueba K usa una muestra observada y las restantes aleatorizadas.", "O teste K usa uma amostra observada e as demais aleatorizadas."], "Observed tip values": ["Valores observados en las puntas", "Valores observados nas pontas"], "Randomized K values": ["Valores K aleatorizados", "Valores K aleatorizados"], "Observed K": ["K observado", "K observado"], "Palette": ["Paleta", "Paleta"], "Figure height (inches)": ["Altura de la figura (pulgadas)", "Altura da figura (polegadas)"], "Seed:": ["Semilla:", "Semente:"], "K test draws:": ["Muestras de la prueba K:", "Amostras do teste K:"], "Randomized draws:": ["Muestras aleatorizadas:", "Amostras aleatorizadas:"], "Tip colors represent observed trait values, not reconstructed ancestral states.": ["Los colores de las puntas representan valores observados del rasgo, no estados ancestrales reconstruidos.", "As cores das pontas representam valores observados da característica, não estados ancestrais reconstruídos."], "K compares trait similarity with Brownian-motion expectations: K = 1 is the reference; larger values indicate greater similarity among relatives. Its randomization test evaluates random assignment of values to tips.": ["K compara la similitud del rasgo con las expectativas del movimiento browniano: K = 1 es la referencia; valores mayores indican mayor similitud entre parientes. Su prueba de aleatorización evalúa la asignación aleatoria de valores a las puntas.", "K compara a similaridade da característica com as expectativas do movimento browniano: K = 1 é a referência; valores maiores indicam maior similaridade entre parentes. Seu teste de aleatorização avalia a atribuição aleatória de valores às pontas."], "Lambda measures phylogenetic covariance scaling. The likelihood-ratio test compares the fitted lambda with lambda = 0. A small p-value supports phylogenetic signal under this model.": ["Lambda mide la escala de la covarianza filogenética. La prueba de razón de verosimilitudes compara la lambda ajustada con lambda = 0. Un valor p pequeño respalda la señal filogenética bajo este modelo.", "Lambda mede a escala da covariância filogenética. O teste da razão de verossimilhanças compara o lambda ajustado com lambda = 0. Um valor p pequeno apoia o sinal filogenético sob este modelo."], "The histogram excludes the observed draw. The dashed line marks observed K. P-values retain the package test convention, which includes the observed draw.": ["El histograma excluye la muestra observada. La línea discontinua marca K observado. Los valores p conservan la convención de la prueba del paquete, que incluye la muestra observada.", "O histograma exclui a amostra observada. A linha tracejada marca K observado. Os valores p mantêm a convenção do teste do pacote, que inclui a amostra observada."], "No measurement-error model is fitted. Inspect trait quality and tree assumptions before interpreting the tests.": ["No se ajusta un modelo de error de medición. Inspeccione la calidad del rasgo y los supuestos del árbol antes de interpretar las pruebas.", "Não é ajustado um modelo de erro de medição. Inspecione a qualidade da característica e os pressupostos da árvore antes de interpretar os testes."], "The R script embeds prepared inputs, repeats the tests and reproduces the selected graph. Edit the plotting settings in RStudio.": ["El script R incluye los datos preparados, repite las pruebas y reproduce el gráfico seleccionado. Edite la configuración gráfica en RStudio.", "O script R inclui os dados preparados, repete os testes e reproduz o gráfico selecionado. Edite as configurações gráficas no RStudio."], "Download results CSV": ["Descargar resultados CSV", "Baixar resultados CSV"], "Signal analysis returned nonfinite estimates. Inspect the inputs.": ["El análisis de señal produjo estimaciones no finitas. Inspeccione los datos.", "A análise de sinal produziu estimativas não finitas. Inspecione os dados."]});

Object.assign(guaneTranslations, {"Binary trait X": ["Rasgo binario X", "Característica binária X"], "Binary trait Y": ["Rasgo binario Y", "Característica binária Y"], "Optimization starts": ["Inicios de optimización", "Inicializações da otimização"], "Maximum rate per branch-length unit": ["Tasa máxima por unidad de longitud de rama", "Taxa máxima por unidade de comprimento de ramo"], "ARD models: four independent rates versus eight dependent rates. Equal root probabilities for all four joint states.": ["Modelos ARD: cuatro tasas independientes frente a ocho dependientes. Probabilidades iguales en la raíz para los cuatro estados conjuntos.", "Modelos ARD: quatro taxas independentes versus oito dependentes. Probabilidades iguais na raiz para os quatro estados conjuntos."], "Run Pagel's correlation": ["Ejecutar correlación de Pagel", "Executar correlação de Pagel"], "Evolution model": ["Modelo evolutivo", "Modelo evolutivo"], "Dependent evolution": ["Evolución dependiente", "Evolução dependente"], "Independent evolution": ["Evolución independiente", "Evolução independente"], "Scale arrows by rate": ["Escalar flechas por tasa", "Dimensionar setas pela taxa"], "Binary state mapping": ["Codificación de estados binarios", "Codificação dos estados binários"], "Model comparison": ["Comparación de modelos", "Comparação de modelos"], "Likelihood-ratio test": ["Prueba de razón de verosimilitudes", "Teste da razão de verossimilhanças"], "A small asymptotic p-value supports dependent evolution under these models; it does not establish causation or a direction of influence.": ["Un valor p asintótico pequeño respalda la evolución dependiente bajo estos modelos; no establece causalidad ni una dirección de influencia.", "Um valor p assintótico pequeno apoia a evolução dependente sob estes modelos; não estabelece causalidade nem direção de influência."], "Compare AIC only for models fitted to the same data and root assumptions. Zero-rate boundaries and sparse states can undermine the chi-squared approximation.": ["Compare AIC solo entre modelos con los mismos datos y supuestos de raíz. Las tasas en cero y los estados escasos pueden afectar la aproximación chi-cuadrado.", "Compare AIC apenas entre modelos com os mesmos dados e pressupostos de raiz. Taxas em zero e estados raros podem comprometer a aproximação qui-quadrado."], "Download transition rates CSV": ["Descargar tasas de transición CSV", "Baixar taxas de transição CSV"], "Joint state counts": ["Conteos de estados conjuntos", "Contagens dos estados conjuntos"], "Optimization attempts": ["Intentos de optimización", "Tentativas de otimização"], "Convergence code 0 is required. Each model retains its highest converged likelihood across the requested starts.": ["Se requiere código de convergencia 0. Cada modelo conserva su mayor verosimilitud convergida entre los inicios solicitados.", "É necessário o código de convergência 0. Cada modelo mantém sua maior verossimilhança convergida entre as inicializações solicitadas."], "Rates have no uncertainty intervals in this version. Parametric bootstrap and directional models are not implemented.": ["Las tasas no tienen intervalos de incertidumbre en esta versión. No están implementados el bootstrap paramétrico ni los modelos direccionales.", "As taxas não têm intervalos de incerteza nesta versão. Bootstrap paramétrico e modelos direcionais não estão implementados."], "The script embeds prepared binary inputs, refits both models and reproduces the selected diagram in RStudio.": ["El script incluye los datos binarios preparados, reajusta ambos modelos y reproduce el diagrama seleccionado en RStudio.", "O script inclui os dados binários preparados, reajusta ambos os modelos e reproduz o diagrama selecionado no RStudio."], "Select two binary traits and run the test.": ["Seleccione dos rasgos binarios y ejecute la prueba.", "Selecione duas características binárias e execute o teste."], "Inputs changed. Run the correlation test to update results.": ["Los datos cambiaron. Ejecute la prueba de correlación para actualizar los resultados.", "Os dados mudaram. Execute o teste de correlação para atualizar os resultados."], "Fitting Pagel's correlation": ["Ajustando la correlación de Pagel", "Ajustando a correlação de Pagel"], "Correlation test completed. Review convergence and state counts.": ["Prueba de correlación completada. Revise la convergencia y los conteos de estados.", "Teste de correlação concluído. Revise a convergência e as contagens dos estados."], "Pagel requires a rooted, bifurcating tree.": ["Pagel requiere un árbol enraizado y bifurcante.", "Pagel requer uma árvore enraizada e bifurcante."], "Pagel requires finite, positive branch lengths.": ["Pagel requiere longitudes de rama finitas y positivas.", "Pagel requer comprimentos de ramos finitos e positivos."], "Select two different binary trait columns.": ["Seleccione dos columnas distintas de rasgos binarios.", "Selecione duas colunas distintas de características binárias."], "Pagel requires at least four taxa with unique, matching labels. Review matching in Data.": ["Pagel requiere al menos cuatro taxones con etiquetas únicas y coincidentes. Revise la coincidencia en Datos.", "Pagel requer pelo menos quatro táxons com rótulos únicos e correspondentes. Revise a correspondência em Dados."], "Each trait must have exactly two observed, nonmissing states. No automatic binarization or row removal is performed.": ["Cada rasgo debe tener exactamente dos estados observados sin datos faltantes. No se realiza binarización ni eliminación automática de filas.", "Cada característica deve ter exatamente dois estados observados sem dados ausentes. Não há binarização nem remoção automática de linhas."], "Choose one to five optimization starts.": ["Elija de uno a cinco inicios de optimización.", "Escolha de uma a cinco inicializações da otimização."], "The maximum transition rate must be positive and finite.": ["La tasa máxima de transición debe ser positiva y finita.", "A taxa máxima de transição deve ser positiva e finita."], "The dependent fit is worse than the nested independent fit. Increase starts or inspect the rate bound.": ["El ajuste dependiente es peor que el ajuste independiente anidado. Aumente los inicios o inspeccione el límite de tasas.", "O ajuste dependente é pior que o ajuste independente aninhado. Aumente as inicializações ou inspecione o limite das taxas."], "Some joint states are absent; rates may be poorly identified and the asymptotic test unreliable.": ["Algunos estados conjuntos están ausentes; las tasas pueden estar mal identificadas y la prueba asintótica ser poco fiable.", "Alguns estados conjuntos estão ausentes; as taxas podem estar mal identificadas e o teste assintótico ser pouco confiável."], "A fitted rate is at or near a boundary. Inspect sensitivity to the rate bound and initial values.": ["Una tasa ajustada está en un límite o cerca de él. Inspeccione la sensibilidad al límite de tasas y a los valores iniciales.", "Uma taxa ajustada está em um limite ou próxima dele. Inspecione a sensibilidade ao limite das taxas e aos valores iniciais."], "Some optimization attempts failed. Only converged fits were eligible for selection.": ["Algunos intentos de optimización fallaron. Solo los ajustes convergidos fueron elegibles.", "Algumas tentativas de otimização falharam. Apenas ajustes convergidos foram elegíveis."], "Rates per branch-length unit; node codes are XY.": ["Tasas por unidad de longitud de rama; códigos de nodos XY.", "Taxas por unidade de comprimento de ramo; códigos dos nós XY."], "Trait": ["Rasgo", "Característica"], "Code": ["Código", "Código"], "State0": ["Estado 0", "Estado 0"], "State1": ["Estado 1", "Estado 1"], "independent": ["independiente", "independente"], "dependent": ["dependiente", "dependente"]});

Object.assign(guaneTranslations, {
 "Download model comparison CSV": ["Descargar comparación de modelos CSV", "Baixar comparação de modelos CSV"],
 "Binary trait values must be finite and nonmissing.": ["Los valores binarios deben ser finitos y no faltantes.", "Os valores binários devem ser finitos e não ausentes."]
});

Object.assign(guaneTranslations, {
 "Example dataset": ["Conjunto de ejemplo", "Conjunto de exemplo"],
 "Continuous trait": ["Rasgo continuo", "Característica contínua"],
 "Synthetic binary traits": ["Rasgos binarios sintéticos", "Características binárias sintéticas"],
 "Synthetic example loaded: 16 species and two binary traits.": ["Ejemplo sintético cargado: 16 especies y dos rasgos binarios.", "Exemplo sintético carregado: 16 espécies e duas características binárias."]
});

Object.assign(guaneTranslations, {
 "Synthetic example: 20 tree tips and 19 trait rows. Sp20 is intentionally absent from the table.": ["Ejemplo sintético: 20 puntas y 19 filas de rasgos. Sp20 se omite intencionalmente de la tabla.", "Exemplo sintético: 20 pontas e 19 linhas de características. Sp20 está intencionalmente ausente da tabela."],
 "Synthetic example loaded: 20 tree tips, 19 trait rows. Review the intentional Sp20 mismatch in Checking data.": ["Ejemplo sintético cargado: 20 puntas y 19 filas de rasgos. Revise la discrepancia intencional de Sp20 en Comprobar datos.", "Exemplo sintético carregado: 20 pontas e 19 linhas de características. Revise a discrepância intencional de Sp20 em Verificar dados."]
});

Object.assign(guaneTranslations,{"Trait for signal": ["Rasgo para señal", "Característica para sinal"], "Choose an original or transformed numeric column from Data. PICs are node contrasts and are not used as species traits.": ["Seleccione una columna numérica original o transformada de Datos. Los PIC son contrastes de nodos y no se usan como rasgos de especies.", "Selecione uma coluna numérica original ou transformada de Dados. PICs são contrastes de nós e não são usados como características de espécies."], "Transition rates": ["Tasas de transición", "Taxas de transição"], "Load a tree and traits in Data. Select two distinct binary columns.": ["Cargue un árbol y rasgos en Datos. Seleccione dos columnas binarias distintas.", "Carregue uma árvore e características em Dados. Selecione duas colunas binárias distintas."], "Two binary columns are required. Each must contain exactly two observed states and no missing values.": ["Se requieren dos columnas binarias, cada una con exactamente dos estados observados y sin valores faltantes.", "São necessárias duas colunas binárias, cada uma com exatamente dois estados observados e sem valores ausentes."], "Two binary traits are available. Resolve taxon mismatches in Data before running.": ["Hay dos rasgos binarios disponibles. Resuelva las diferencias de taxones en Datos antes de ejecutar.", "Há duas características binárias disponíveis. Resolva as diferenças de táxons em Dados antes de executar."], "Run the correlation test on matched data to display results.": ["Ejecute la prueba de correlación con datos coincidentes para mostrar resultados.", "Execute o teste de correlação com dados correspondentes para exibir resultados."], "Phylogenetic logistic regression": ["Regresión logística filogenética", "Regressão logística filogenética"], "Bernoulli response with logit link; multiple numeric predictors.": ["Respuesta Bernoulli con enlace logit; múltiples predictores numéricos.", "Resposta Bernoulli com ligação logit; múltiplos preditores numéricos."], "Binary response": ["Respuesta binaria", "Resposta binária"], "Event state (1)": ["Estado del evento (1)", "Estado do evento (1)"], "Estimation method": ["Método de estimación", "Método de estimação"], "Run PGLM": ["Ejecutar PGLM", "Executar PGLM"], "Poisson, grouped binomial and Bayesian models are planned.": ["Los modelos Poisson, binomial agrupado y bayesianos están previstos.", "Modelos Poisson, binomial agrupado e bayesianos estão previstos."], "Observed outcomes and fitted probabilities": ["Resultados observados y probabilidades ajustadas", "Resultados observados e probabilidades ajustadas"], "Conditional 95% Wald intervals": ["Intervalos de Wald condicionales del 95%", "Intervalos de Wald condicionais de 95%"], "Pearson residual": ["Residuo de Pearson", "Resíduo de Pearson"], "Fitted event probability": ["Probabilidad ajustada del evento", "Probabilidade ajustada do evento"], "Log-odds coefficient": ["Coeficiente de log-odds", "Coeficiente de log-odds"], "Coefficients describe log-odds changes holding other predictors constant. Intervals and standard errors are conditional on estimated alpha.": ["Los coeficientes describen cambios en log-odds manteniendo constantes los demás predictores. Los intervalos y errores estándar son condicionales al alfa estimado.", "Os coeficientes descrevem mudanças em log-odds mantendo os demais preditores constantes. Os intervalos e erros padrão são condicionais ao alfa estimado."], "Download fitted probabilities CSV": ["Descargar probabilidades ajustadas CSV", "Baixar probabilidades ajustadas CSV"], "Binary residuals are not normally distributed. This plot checks patterns; it is not a normality test or a calibrated goodness-of-fit test.": ["Los residuos binarios no tienen distribución normal. Este gráfico permite revisar patrones; no es una prueba de normalidad ni de bondad de ajuste calibrada.", "Resíduos binários não têm distribuição normal. Este gráfico permite verificar padrões; não é um teste de normalidade nem de qualidade do ajuste calibrado."], "The script embeds prepared data and settings and reproduces the selected graph in RStudio.": ["El script incluye datos preparados y configuraciones y reproduce el gráfico seleccionado en RStudio.", "O script inclui dados preparados e configurações e reproduz o gráfico selecionado no RStudio."], "Choose a binary response, event state and predictors.": ["Seleccione una respuesta binaria, un estado del evento y predictores.", "Selecione uma resposta binária, um estado do evento e preditores."], "Inputs changed. Run PGLM to update results.": ["Los datos cambiaron. Ejecute PGLM para actualizar los resultados.", "Os dados mudaram. Execute PGLM para atualizar os resultados."], "PGLM completed. Review diagnostics and fitting warnings.": ["PGLM completado. Revise los diagnósticos y las advertencias del ajuste.", "PGLM concluído. Revise os diagnósticos e os avisos do ajuste."], "Run PGLM on matched data to display results.": ["Ejecute PGLM con datos coincidentes para mostrar resultados.", "Execute PGLM com dados correspondentes para exibir resultados."], "PGLM requires a rooted, bifurcating tree.": ["PGLM requiere un árbol enraizado y bifurcante.", "PGLM requer uma árvore enraizada e bifurcante."], "PGLM requires finite, positive branch lengths.": ["PGLM requiere longitudes de ramas finitas y positivas.", "PGLM requer comprimentos de ramos finitos e positivos."], "Match unique, nonempty taxon labels explicitly in Data before PGLM.": ["Haga coincidir etiquetas únicas y no vacías de taxones en Datos antes de PGLM.", "Faça corresponder rótulos únicos e não vazios de táxons em Dados antes do PGLM."], "Select a binary response and distinct numeric predictors.": ["Seleccione una respuesta binaria y predictores numéricos distintos.", "Selecione uma resposta binária e preditores numéricos distintos."], "Select the event state from a response with exactly two nonmissing states.": ["Seleccione el estado del evento de una respuesta con exactamente dos estados no faltantes.", "Selecione o estado do evento de uma resposta com exatamente dois estados não ausentes."], "PGLM predictors must be finite, numeric and nonconstant. No rows are removed automatically.": ["Los predictores PGLM deben ser finitos, numéricos y no constantes. No se eliminan filas automáticamente.", "Os preditores PGLM devem ser finitos, numéricos e não constantes. Nenhuma linha é removida automaticamente."], "PGLM needs at least six taxa, two observations per state and two residual degrees of freedom.": ["PGLM necesita al menos seis taxones, dos observaciones por estado y dos grados de libertad residuales.", "PGLM precisa de pelo menos seis táxons, duas observações por estado e dois graus de liberdade residuais."], "PGLM optimization did not converge. Review variables and model settings.": ["La optimización PGLM no convergió. Revise las variables y la configuración del modelo.", "A otimização PGLM não convergiu. Revise as variáveis e as configurações do modelo."], "PGLM returned invalid estimates or standard errors.": ["PGLM produjo estimaciones o errores estándar no válidos.", "PGLM produziu estimativas ou erros padrão inválidos."], "PGLM returned invalid fitted probabilities.": ["PGLM produjo probabilidades ajustadas no válidas.", "PGLM produziu probabilidades ajustadas inválidas."], "Alpha is near its optimization boundary; inspect sensitivity before inference.": ["Alfa está cerca de su límite de optimización; revise la sensibilidad antes de inferir.", "Alfa está perto de seu limite de otimização; revise a sensibilidade antes da inferência."]});

Object.assign(guaneTranslations,{'Model details':['Detalles del modelo','Detalhes do modelo']});

Object.assign(guaneTranslations,{"Phylogenetic generalized linear models": ["Modelos lineales generalizados filogenéticos", "Modelos lineares generalizados filogenéticos"], "Response family": ["Familia de respuesta", "Família da resposta"], "Binary (Bernoulli / logit)": ["Binaria (Bernoulli / logit)", "Binária (Bernoulli / logit)"], "Counts (Poisson GEE / log)": ["Conteos (Poisson GEE / log)", "Contagens (Poisson GEE / log)"], "Response": ["Respuesta", "Resposta"], "Grouped binomial and Bayesian models are planned.": ["Los modelos binomiales agrupados y bayesianos están previstos.", "Modelos binomiais agrupados e bayesianos estão previstos."], "Observed and fitted values": ["Valores observados y ajustados", "Valores observados e ajustados"], "Coefficient intervals": ["Intervalos de coeficientes", "Intervalos dos coeficientes"], "Download fitted values CSV": ["Descargar valores ajustados CSV", "Baixar valores ajustados CSV"], "Choose a response family, response and predictors.": ["Seleccione una familia de respuesta, una respuesta y predictores.", "Selecione uma família da resposta, uma resposta e preditores."], "Poisson GEE with log link and multiple numeric predictors. Select a nonnegative integer count column.": ["Poisson GEE con enlace log y múltiples predictores numéricos. Seleccione una columna de conteos enteros no negativos.", "Poisson GEE com ligação log e múltiplos preditores numéricos. Selecione uma coluna de contagens inteiras não negativas."], "Counts require comparable observation effort. Exposure offsets, zero-inflation and negative-binomial models are not supported.": ["Los conteos requieren un esfuerzo de observación comparable. No se admiten offsets de exposición ni modelos con inflación de ceros o binomiales negativos.", "As contagens exigem esforço de observação comparável. Não há suporte a offsets de exposição nem a modelos com inflação de zeros ou binomiais negativos."], "Coefficients describe log mean-count changes holding other predictors constant; exp(coefficient) is the expected count ratio per predictor unit.": ["Los coeficientes describen cambios en el logaritmo del conteo medio, manteniendo constantes los demás predictores; exp(coeficiente) es la razón de conteos esperados por unidad del predictor.", "Os coeficientes descrevem mudanças no logaritmo da contagem média, mantendo os demais preditores constantes; exp(coeficiente) é a razão das contagens esperadas por unidade do preditor."], "GEE intervals use scale-adjusted model-based standard errors, not robust sandwich or bootstrap errors. Phylogenetic correlation is fixed by the tree. Likelihood and AIC are not available.": ["Los intervalos GEE usan errores estándar basados en el modelo y ajustados por escala, no errores robustos sandwich ni bootstrap. La correlación filogenética está fijada por el árbol. No hay verosimilitud ni AIC disponibles.", "Os intervalos GEE usam erros padrão baseados no modelo e ajustados pela escala, não erros robustos sandwich ou bootstrap. A correlação filogenética é fixada pela árvore. Verossimilhança e AIC não estão disponíveis."], "Pearson residuals use (observed - fitted) / sqrt(fitted), without dispersion scaling. Patterns may reveal misspecification; residual normality is not assumed.": ["Los residuos de Pearson usan (observado - ajustado) / sqrt(ajustado), sin ajuste por dispersión. Los patrones pueden revelar una especificación inadecuada; no se asume normalidad residual.", "Os resíduos de Pearson usam (observado - ajustado) / sqrt(ajustado), sem ajuste por dispersão. Os padrões podem revelar especificação inadequada; não se assume normalidade residual."], "Dispersion is the sum of squared Pearson residuals divided by residual degrees of freedom. Values above one indicate extra variation relative to the Poisson working variance; this is descriptive, not a calibrated test.": ["La dispersión es la suma de residuos de Pearson al cuadrado dividida por los grados de libertad residuales. Valores superiores a uno indican variación adicional respecto a la varianza de trabajo Poisson; es descriptivo, no una prueba calibrada.", "A dispersão é a soma dos resíduos de Pearson ao quadrado dividida pelos graus de liberdade residuais. Valores acima de um indicam variação adicional em relação à variância de trabalho Poisson; é descritivo, não um teste calibrado."], "Count responses must be finite, nonnegative integers with at least two different values. No rounding or row removal is automatic.": ["Las respuestas de conteo deben ser enteros finitos no negativos con al menos dos valores distintos. No se redondean valores ni se eliminan filas automáticamente.", "As respostas de contagem devem ser inteiros finitos não negativos com pelo menos dois valores diferentes. Não há arredondamento nem remoção automática de linhas."], "PGLM needs at least six taxa and two residual degrees of freedom.": ["PGLM necesita al menos seis taxones y dos grados de libertad residuales.", "PGLM precisa de pelo menos seis táxons e dois graus de liberdade residuais."], "PGLM returned an invalid dispersion estimate.": ["PGLM produjo una estimación de dispersión no válida.", "PGLM produziu uma estimativa de dispersão inválida."], "PGLM returned invalid fitted counts.": ["PGLM produjo conteos ajustados no válidos.", "PGLM produziu contagens ajustadas inválidas."], "PGLM fitted taxa do not match the input tree.": ["Los taxones ajustados por PGLM no coinciden con el árbol de entrada.", "Os táxons ajustados pelo PGLM não correspondem à árvore de entrada."], "Log-mean coefficient": ["Coeficiente del logaritmo de la media", "Coeficiente do logaritmo da média"], "GEE 95% Wald intervals": ["Intervalos de Wald GEE del 95%", "Intervalos de Wald GEE de 95%"], "Fitted mean count": ["Conteo medio ajustado", "Contagem média ajustada"], "Observed count": ["Conteo observado", "Contagem observada"], "Observed and fitted counts": ["Conteos observados y ajustados", "Contagens observadas e ajustadas"], "Taxa": ["Taxones", "Táxons"], "Observed zeros": ["Ceros observados", "Zeros observados"], "Residual degrees of freedom": ["Grados de libertad residuales", "Graus de liberdade residuais"], "Dispersion": ["Dispersión", "Dispersão"], "Convergence code": ["Código de convergencia", "Código de convergência"], "Metric": ["Métrica", "Métrica"], "Value": ["Valor", "Valor"]});

Object.assign(guaneTranslations,{"Grouped binomial (GEE / logit)": ["Binomial agrupada (GEE / logit)", "Binomial agrupada (GEE / logit)"], "Response / successes": ["Respuesta / éxitos", "Resposta / sucessos"], "Total trials": ["Ensayos totales", "Tentativas totais"], "Total successes": ["Éxitos totales", "Sucessos totais"], "Bayesian models are planned.": ["Los modelos bayesianos están previstos.", "Modelos bayesianos estão previstos."], "Select successes and total trials per species. Trials must be positive integers; successes may range from zero to trials.": ["Seleccione éxitos y ensayos totales por especie. Los ensayos deben ser enteros positivos; los éxitos pueden variar de cero al total de ensayos.", "Selecione sucessos e tentativas totais por espécie. As tentativas devem ser inteiros positivos; os sucessos podem variar de zero ao total de tentativas."], "Grouped-binomial GEE uses a logit link and a fixed tree-derived working correlation. No trial expansion or proportion rounding is performed.": ["La GEE binomial agrupada usa un enlace logit y una correlación de trabajo fija derivada del árbol. No se expanden los ensayos ni se redondean las proporciones.", "A GEE binomial agrupada usa ligação logit e uma correlação de trabalho fixa derivada da árvore. Não há expansão de tentativas nem arredondamento de proporções."], "Coefficients describe log-odds changes holding other predictors constant. Intervals use model-based covariance with binomial scale fixed at one.": ["Los coeficientes describen cambios en log-odds manteniendo constantes los demás predictores. Los intervalos usan covarianza basada en el modelo con escala binomial fijada en uno.", "Os coeficientes descrevem mudanças em log-odds mantendo os demais preditores constantes. Os intervalos usam covariância baseada no modelo com escala binomial fixada em um."], "One phylogeny is one correlated cluster. Robust sandwich intervals, likelihood and AIC are not reported. Extra-binomial variation is not fitted.": ["Una filogenia es un grupo correlacionado. No se presentan intervalos robustos sandwich, verosimilitud ni AIC. No se ajusta variación extrabinomial.", "Uma filogenia é um grupo correlacionado. Não são apresentados intervalos robustos sandwich, verossimilhança ou AIC. Não se ajusta variação extrabinomial."], "Pearson residuals compare observed successes with trials times fitted probability, using binomial variance. Dispersion is descriptive and does not rescale the fitted intervals.": ["Los residuos de Pearson comparan los éxitos observados con ensayos por probabilidad ajustada, usando varianza binomial. La dispersión es descriptiva y no reescala los intervalos ajustados.", "Os resíduos de Pearson comparam os sucessos observados com tentativas vezes probabilidade ajustada, usando variância binomial. A dispersão é descritiva e não redimensiona os intervalos ajustados."], "Pearson dispersion (descriptive)": ["Dispersión de Pearson (descriptiva)", "Dispersão de Pearson (descritiva)"], "Select a distinct total-trials column, separate from successes and predictors.": ["Seleccione una columna de ensayos totales distinta de los éxitos y predictores.", "Selecione uma coluna de tentativas totais diferente dos sucessos e preditores."], "Grouped binomial requires integer counts with positive trials and 0 <= successes <= trials. No rows are removed automatically.": ["La binomial agrupada requiere conteos enteros con ensayos positivos y 0 <= éxitos <= ensayos. No se eliminan filas automáticamente.", "A binomial agrupada exige contagens inteiras com tentativas positivas e 0 <= sucessos <= tentativas. Nenhuma linha é removida automaticamente."], "Grouped binomial needs at least one success and one failure across species.": ["La binomial agrupada necesita al menos un éxito y un fracaso entre las especies.", "A binomial agrupada precisa de pelo menos um sucesso e um fracasso entre as espécies."], "Grouped binomial fitted probabilities are at a boundary. Check separation and model complexity.": ["Las probabilidades binomiales ajustadas están en un límite. Revise la separación y la complejidad del modelo.", "As probabilidades binomiais ajustadas estão em um limite. Verifique a separação e a complexidade do modelo."], "The phylogenetic working correlation is invalid.": ["La correlación filogenética de trabajo no es válida.", "A correlação filogenética de trabalho é inválida."], "Grouped binomial GEE did not converge. Review the inputs and model complexity.": ["La GEE binomial agrupada no convergió. Revise los datos y la complejidad del modelo.", "A GEE binomial agrupada não convergiu. Revise os dados e a complexidade do modelo."], "Fitted success probability": ["Probabilidad de éxito ajustada", "Probabilidade de sucesso ajustada"], "Observed success proportion": ["Proporción de éxito observada", "Proporção de sucesso observada"], "Observed and fitted proportions": ["Proporciones observadas y ajustadas", "Proporções observadas e ajustadas"]});

Object.assign(guaneTranslations,{"Categorical predictors": ["Predictores categóricos", "Preditores categóricos"], "Reference category": ["Categoría de referencia", "Categoria de referência"], "Mark categorical predictors explicitly, including numeric state codes. Other predictors are continuous.": ["Marque explícitamente los predictores categóricos, incluidos los códigos numéricos de estados. Los demás predictores son continuos.", "Marque explicitamente os preditores categóricos, incluindo códigos numéricos de estados. Os demais preditores são contínuos."], "Category coefficients compare each state with its reference, holding other predictors constant.": ["Los coeficientes categóricos comparan cada estado con su referencia, manteniendo constantes los demás predictores.", "Os coeficientes categóricos comparam cada estado com sua referência, mantendo os demais preditores constantes."], "Categorical columns must be selected predictors.": ["Las columnas categóricas deben ser predictores seleccionados.", "As colunas categóricas devem ser preditores selecionados."], "Categorical predictors must have nonmissing, nonempty states.": ["Los predictores categóricos no pueden tener estados vacíos o faltantes.", "Os preditores categóricos não podem ter estados vazios ou ausentes."], "Categorical predictors need at least two observed states.": ["Los predictores categóricos necesitan al menos dos estados observados.", "Os preditores categóricos precisam de pelo menos dois estados observados."], "Choose an observed reference category for every categorical predictor.": ["Elija una categoría de referencia observada para cada predictor categórico.", "Escolha uma categoria de referência observada para cada preditor categórico."], "Some predictor categories contain fewer than three taxa; estimates may be unstable.": ["Algunas categorías contienen menos de tres taxones; las estimaciones pueden ser inestables.", "Algumas categorias contêm menos de três táxons; as estimativas podem ser instáveis."], "Select a response and distinct predictors.": ["Seleccione una respuesta y predictores distintos.", "Selecione uma resposta e preditores distintos."], "Poisson GEE with log link and multiple numeric or categorical predictors. Select a nonnegative integer count column.": ["GEE de Poisson con enlace log y predictores numéricos o categóricos. Seleccione una columna de conteos enteros no negativos.", "GEE de Poisson com ligação log e preditores numéricos ou categóricos. Selecione uma coluna de contagens inteiras não negativas."], "Bernoulli response with logit link; multiple numeric or categorical predictors.": ["Respuesta Bernoulli con enlace logit; múltiples predictores numéricos o categóricos.", "Resposta Bernoulli com ligação logit; múltiplos preditores numéricos ou categóricos."]});

Object.assign(guaneTranslations,{"Compare covariance models (ML)": ["Comparar modelos de covarianza (ML)", "Comparar modelos de covariância (ML)"], "Comparison uses the same data and predictors for all four structures, with ML and the current fixed or initial parameter setting.": ["La comparación usa los mismos datos y predictores para las cuatro estructuras, con ML y el parámetro fijo o inicial actual.", "A comparação usa os mesmos dados e preditores para as quatro estruturas, com ML e o parâmetro fixo ou inicial atual."], "Covariance model comparison": ["Comparación de modelos de covarianza", "Comparação de modelos de covariância"], "AIC weights describe relative support within the successful candidate set, not probabilities that models are true. Failed models remain listed. No likelihood-ratio tests or model averaging are performed.": ["Los pesos AIC indican apoyo relativo entre los modelos ajustados, no probabilidades de que sean verdaderos. Se muestran los fallos. No se realizan pruebas de razón de verosimilitud ni promedios de modelos.", "Os pesos AIC indicam suporte relativo entre os modelos ajustados, não probabilidades de serem verdadeiros. As falhas são listadas. Não são feitos testes de razão de verossimilhança nem médias de modelos."], "Comparison finished. Review failed models and warnings.": ["Comparación terminada. Revise los modelos fallidos y las advertencias.", "Comparação concluída. Revise os modelos com falhas e os avisos."], "Run taxon influence diagnostics": ["Ejecutar diagnóstico de influencia de taxones", "Executar diagnóstico de influência dos táxons"], "Refits the current model once per taxon on temporary pruned copies. Prepared data stay unchanged. Large datasets may take time.": ["Reajusta el modelo una vez por taxón en copias podadas temporales. Los datos preparados no cambian. Los conjuntos grandes pueden tardar.", "Reajusta o modelo uma vez por táxon em cópias podadas temporárias. Os dados preparados não mudam. Conjuntos grandes podem demorar."], "Diagnostic screens": ["Evaluaciones diagnósticas", "Avaliações diagnósticas"], "LargeResidual marks absolute Pearson residuals above 2; Sparse marks fewer than 3 taxa. OneOutcome marks a category with only successes or failures. These are descriptive screens, not tests or automatic exclusions; absence of flags does not rule out separation.": ["LargeResidual indica residuos absolutos de Pearson mayores que 2; Sparse indica menos de 3 taxones. OneOutcome indica una categoría con solo éxitos o fracasos. Son evaluaciones descriptivas, no pruebas ni exclusiones automáticas; la ausencia de señales no descarta separación.", "LargeResidual indica resíduos absolutos de Pearson acima de 2; Sparse indica menos de 3 táxons. OneOutcome indica uma categoria apenas com sucessos ou fracassos. São avaliações descritivas, não testes nem exclusões automáticas; a ausência de sinais não descarta separação."], "Taxon influence": ["Influencia de taxones", "Influência dos táxons"], "Influence is the largest absolute coefficient change divided by its full-fit standard error. Inspect failed refits and warnings. This is sensitivity analysis, not a calibrated test or cross-validation.": ["La influencia es el mayor cambio absoluto de coeficiente dividido por su error estándar del ajuste completo. Revise los reajustes fallidos y las advertencias. Es un análisis de sensibilidad, no una prueba calibrada ni validación cruzada.", "A influência é a maior mudança absoluta de coeficiente dividida pelo erro padrão do ajuste completo. Revise os reajustes com falhas e os avisos. É uma análise de sensibilidade, não um teste calibrado nem validação cruzada."], "At least two valid models are needed for comparison.": ["Se necesitan al menos dos modelos válidos para comparar.", "São necessários pelo menos dois modelos válidos para comparar."], "Delta AIC (ML)": ["Delta AIC (ML)", "Delta AIC (ML)"], "No valid diagnostic refits.": ["No hay reajustes diagnósticos válidos.", "Não há reajustes diagnósticos válidos."], "Taxon index (see table)": ["Índice de taxón (ver tabla)", "Índice do táxon (ver tabela)"], "Maximum coefficient shift / full-fit SE": ["Cambio máximo de coeficiente / SE completo", "Mudança máxima do coeficiente / SE completo"], "Download comparison CSV": ["Descargar comparación CSV", "Baixar comparação CSV"], "Download comparison PDF": ["Descargar comparación PDF", "Baixar comparação PDF"], "Download comparison R code": ["Descargar comparación código R", "Baixar comparação código R"], "Download influence CSV": ["Descargar influencia CSV", "Baixar influência CSV"], "Download influence PDF": ["Descargar influencia PDF", "Baixar influência PDF"], "Download influence R code": ["Descargar influencia código R", "Baixar influência código R"]});

Object.assign(guaneTranslations,{"Trait for reconstruction": ["Rasgo para reconstrucción", "Característica para reconstrução"], "Framework": ["Marco de inferencia", "Estrutura de inferência"], "Maximum likelihood": ["Máxima verosimilitud", "Máxima verossimilhança"], "Bayesian / stochastic — planned": ["Bayesiano / estocástico — previsto", "Bayesiano / estocástico — previsto"], "Parsimony — planned": ["Parsimonia — prevista", "Parcimônia — prevista"], "Brownian motion (BM)": ["Movimiento browniano (BM)", "Movimento browniano (BM)"], "Choose an original or transformed numeric trait. Reconstruction stays on that scale; no automatic back-transformation is applied.": ["Elija un rasgo numérico original o transformado. La reconstrucción permanece en esa escala; no se aplica una transformación inversa automática.", "Escolha uma característica numérica original ou transformada. A reconstrução permanece nessa escala; não há transformação inversa automática."], "Run BM reconstruction": ["Ejecutar reconstrucción BM", "Executar reconstrução BM"], "Trait map": ["Mapa del rasgo", "Mapa da característica"], "Phenogram": ["Fenograma", "Fenograma"], "Node intervals": ["Intervalos de nodos", "Intervalos dos nós"], "Contrast diagnostics": ["Diagnósticos de contrastes", "Diagnósticos de contrastes"], "Node estimates are BM maximum-likelihood reconstructions. Branch colors and phenogram lines interpolate estimates; they are not observed or sampled evolutionary histories.": ["Las estimaciones nodales son reconstrucciones BM de máxima verosimilitud. Los colores de ramas y líneas del fenograma interpolan estimaciones; no son historias evolutivas observadas ni muestreadas.", "As estimativas nodais são reconstruções BM de máxima verossimilhança. As cores dos ramos e linhas do fenograma interpolam estimativas; não são histórias evolutivas observadas nem amostradas."], "Intervals are approximate 95% analytic node intervals from fastAnc (Rohlf variance). They are not Bayesian credible intervals or simultaneous bands and do not include tree or model uncertainty.": ["Los intervalos nodales analíticos aproximados del 95% provienen de fastAnc (varianza de Rohlf). No son intervalos creíbles bayesianos ni bandas simultáneas; no incluyen incertidumbre del árbol o del modelo.", "Os intervalos nodais analíticos aproximados de 95% vêm de fastAnc (variância de Rohlf). Não são intervalos de credibilidade bayesianos nem bandas simultâneas; não incluem incerteza da árvore ou do modelo."], "Download node estimates CSV": ["Descargar estimaciones nodales CSV", "Baixar estimativas nodais CSV"], "The Q-Q plot screens standardized independent contrasts under BM. It does not prove model adequacy. The diffusion rate and log likelihood use a marginal tip-data ML calculation; node intervals use fastAnc variance.": ["El gráfico Q-Q evalúa contrastes independientes estandarizados bajo BM. No demuestra adecuación del modelo. La tasa de difusión y log-verosimilitud usan ML marginal de datos terminales; los intervalos nodales usan la varianza de fastAnc.", "O gráfico Q-Q avalia contrastes independentes padronizados sob BM. Não comprova adequação do modelo. A taxa de difusão e log-verossimilhança usam ML marginal dos dados terminais; os intervalos nodais usam a variância de fastAnc."], "Choose a numeric trait and run BM reconstruction.": ["Elija un rasgo numérico y ejecute la reconstrucción BM.", "Escolha uma característica numérica e execute a reconstrução BM."], "Inputs changed. Run BM reconstruction to update results.": ["Los datos cambiaron. Ejecute la reconstrucción BM para actualizar resultados.", "Os dados mudaram. Execute a reconstrução BM para atualizar os resultados."], "This framework is planned. Only maximum-likelihood BM is implemented.": ["Este marco está previsto. Solo se ha implementado BM de máxima verosimilitud.", "Esta estrutura está prevista. Apenas BM de máxima verossimilhança está implementado."], "BM reconstruction completed. Review uncertainty and diagnostics.": ["Reconstrucción BM completada. Revise la incertidumbre y los diagnósticos.", "Reconstrução BM concluída. Revise a incerteza e os diagnósticos."], "BM reconstruction requires a rooted, bifurcating tree.": ["La reconstrucción BM requiere un árbol enraizado y bifurcante.", "A reconstrução BM exige uma árvore enraizada e bifurcante."], "BM reconstruction requires finite, positive branch lengths.": ["La reconstrucción BM requiere longitudes de rama finitas y positivas.", "A reconstrução BM exige comprimentos de ramo finitos e positivos."], "Select distinct taxon and numeric trait columns.": ["Seleccione columnas distintas de taxón y rasgo numérico.", "Selecione colunas distintas de táxon e característica numérica."], "Match unique taxon labels explicitly in Data before reconstruction; at least three taxa are required.": ["Haga coincidir etiquetas únicas de taxones explícitamente en Datos antes de reconstruir; se requieren al menos tres taxones.", "Faça corresponder rótulos únicos de táxons explicitamente em Dados antes da reconstrução; são necessários pelo menos três táxons."], "BM reconstruction needs a finite, nonconstant numeric trait. No rows are removed automatically.": ["La reconstrucción BM necesita un rasgo numérico finito y no constante. No se eliminan filas automáticamente.", "A reconstrução BM precisa de uma característica numérica finita e não constante. Nenhuma linha é removida automaticamente."], "BM reconstruction returned invalid node estimates or uncertainty.": ["La reconstrucción BM devolvió estimaciones nodales o incertidumbre no válidas.", "A reconstrução BM retornou estimativas nodais ou incerteza inválidas."], "BM reconstruction returned an invalid diffusion rate.": ["La reconstrucción BM devolvió una tasa de difusión no válida.", "A reconstrução BM retornou uma taxa de difusão inválida."], "BM ancestral reconstruction": ["Reconstrucción ancestral BM", "Reconstrução ancestral BM"], "Distance from root (branch-length units)": ["Distancia desde la raíz (unidades de rama)", "Distância da raiz (unidades de ramo)"], "Approximate 95% node intervals": ["Intervalos nodales aproximados del 95%", "Intervalos nodais aproximados de 95%"], "BM contrast diagnostic": ["Diagnóstico de contrastes BM", "Diagnóstico de contrastes BM"], "Standardized contrasts": ["Contrastes estandarizados", "Contrastes padronizados"], "Node": ["Nodo", "Nó"], "Variance": ["Varianza", "Variância"], "Internal nodes": ["Nodos internos", "Nós internos"], "Root estimate": ["Estimación de la raíz", "Estimativa da raiz"], "BM diffusion rate (ML)": ["Tasa de difusión BM (ML)", "Taxa de difusão BM (ML)"], "Log likelihood (ML)": ["Log-verosimilitud (ML)", "Log-verossimilhança (ML)"]});

Object.assign(guaneTranslations, {"Model": ["Modelo", "Modelo"]});

Object.assign(guaneTranslations, {"Custom": ["Personalizado", "Personalizado"], "ER shares all rates; SYM shares reverse rates; ARD estimates each directed rate.": ["ER comparte todas las tasas; SYM comparte tasas inversas; ARD estima cada tasa dirigida.", "ER compartilha todas as taxas; SYM compartilha taxas reversas; ARD estima cada taxa dirigida."], "Use 2 to 10 observed states. Numeric states must be integers. Polymorphic characters belong in their own card.": ["Use de 2 a 10 estados observados. Los estados numéricos deben ser enteros. Los caracteres polimórficos tienen su propia tarjeta.", "Use de 2 a 10 estados observados. Estados numéricos devem ser inteiros. Características polimórficas têm seu próprio cartão."], "Root-state probabilities are fixed equal across observed states.": ["Las probabilidades de estados en la raíz son iguales para todos los estados observados.", "As probabilidades dos estados na raiz são iguais para todos os estados observados."], "State order": ["Orden de estados", "Ordem dos estados"], "Start custom matrix from": ["Iniciar matriz personalizada desde", "Iniciar matriz personalizada a partir de"], "Fill custom matrix": ["Llenar matriz personalizada", "Preencher matriz personalizada"], "Custom rate constraints": ["Restricciones de tasas personalizadas", "Restrições de taxas personalizadas"], "Rows are source states; columns are destination states, in the displayed order. Use 0 for forbidden transitions and the diagonal. Equal positive integers share a rate; use consecutive indices starting at 1. Enter comma-separated rows without headers.": ["Las filas son estados de origen y las columnas de destino, en el orden mostrado. Use 0 para transiciones prohibidas y la diagonal. Enteros positivos iguales comparten una tasa; use índices consecutivos desde 1. Introduzca filas separadas por comas, sin encabezados.", "As linhas são estados de origem e as colunas de destino, na ordem exibida. Use 0 para transições proibidas e na diagonal. Inteiros positivos iguais compartilham uma taxa; use índices consecutivos a partir de 1. Insira linhas separadas por vírgulas, sem cabeçalhos."], "Upper rate bound": ["Límite superior de tasa", "Limite superior da taxa"], "Compare with ER, SYM and ARD": ["Comparar con ER, SYM y ARD", "Comparar com ER, SYM e ARD"], "Run Mk reconstruction": ["Ejecutar reconstrucción Mk", "Executar reconstrução Mk"], "Node probability tree": ["Árbol con probabilidades nodales", "Árvore com probabilidades nodais"], "Transition-rate diagram": ["Diagrama de tasas de transición", "Diagrama de taxas de transição"], "Marginal state probabilities": ["Probabilidades marginales de estados", "Probabilidades marginais dos estados"], "Model comparison": ["Comparación de modelos", "Comparação de modelos"], "Optimizer starts": ["Inicios del optimizador", "Inícios do otimizador"], "Node pie size": ["Tamaño de círculos nodales", "Tamanho dos gráficos de nós"], "Node pies show marginal state probabilities conditional on the fitted rates, tree and equal root probabilities. They do not integrate parameter or tree uncertainty and are not sampled evolutionary histories.": ["Los círculos nodales muestran probabilidades marginales condicionadas a las tasas estimadas, el árbol y probabilidades iguales en la raíz. No integran incertidumbre de parámetros o del árbol y no son historias evolutivas muestreadas.", "Os gráficos dos nós mostram probabilidades marginais condicionadas às taxas estimadas, à árvore e a probabilidades iguais na raiz. Não integram incerteza dos parâmetros ou da árvore e não são histórias evolutivas amostradas."], "Download node probabilities CSV": ["Descargar probabilidades nodales CSV", "Baixar probabilidades nodais CSV"], "Fitted Q matrix": ["Matriz Q estimada", "Matriz Q estimada"], "Rows are source states; columns are destination states. Off-diagonal rates are per branch-length unit; diagonal entries are negative row sums.": ["Las filas son estados de origen y las columnas de destino. Las tasas fuera de la diagonal son por unidad de longitud de rama; la diagonal es la suma negativa de cada fila.", "As linhas são estados de origem e as colunas de destino. As taxas fora da diagonal são por unidade de comprimento de ramo; a diagonal é a soma negativa de cada linha."], "Download rate matrix CSV": ["Descargar matriz de tasas CSV", "Baixar matriz de taxas CSV"], "Three deterministic starts are fitted per model. Convergence does not establish identifiability or model adequacy. Near-boundary rates and different optima require caution.": ["Se ajustan tres inicios deterministas por modelo. La convergencia no establece identificabilidad ni adecuación del modelo. Las tasas cerca de los límites y óptimos diferentes requieren cautela.", "São ajustados três inícios determinísticos por modelo. Convergência não estabelece identificabilidade nem adequação do modelo. Taxas próximas aos limites e ótimos diferentes exigem cautela."], "AIC comparisons use the same taxa, trait, tree and equal root probabilities. Weights describe only distinct converged candidates; equivalent constraints are omitted. Failed candidates remain visible. No model averaging is performed.": ["Las comparaciones AIC usan los mismos taxones, rasgo, árbol y probabilidades iguales en la raíz. Los pesos describen solo candidatos distintos convergentes; se omiten restricciones equivalentes. Los candidatos fallidos permanecen visibles. No se promedian modelos.", "As comparações AIC usam os mesmos táxons, característica, árvore e probabilidades iguais na raiz. Os pesos descrevem apenas candidatos distintos convergentes; restrições equivalentes são omitidas. Candidatos falhos permanecem visíveis. Não há média de modelos."], "Download model comparison CSV": ["Descargar comparación de modelos CSV", "Baixar comparação de modelos CSV"], "Download optimizer diagnostics CSV": ["Descargar diagnósticos del optimizador CSV", "Baixar diagnósticos do otimizador CSV"], "Select Model comparison or Optimizer starts in Graph controls to view and export diagnostic plots.": ["Seleccione Comparación de modelos o Inicios del optimizador en Controles del gráfico para ver y exportar gráficos diagnósticos.", "Selecione Comparação de modelos ou Inícios do otimizador em Controles do gráfico para visualizar e exportar gráficos diagnósticos."], "Choose a discrete trait and run Mk reconstruction.": ["Elija un rasgo discreto y ejecute la reconstrucción Mk.", "Escolha uma característica discreta e execute a reconstrução Mk."], "Custom constraints are valid.": ["Las restricciones personalizadas son válidas.", "As restrições personalizadas são válidas."], "Inputs changed. Run Mk reconstruction to update results.": ["Los datos cambiaron. Ejecute la reconstrucción Mk para actualizar resultados.", "Os dados mudaram. Execute a reconstrução Mk para atualizar os resultados."], "This framework is planned. Only maximum-likelihood Mk is implemented.": ["Este marco está previsto. Solo se ha implementado Mk de máxima verosimilitud.", "Esta estrutura está prevista. Apenas Mk de máxima verossimilhança está implementado."], "Mk reconstruction completed. Review optimizer diagnostics and model assumptions.": ["Reconstrucción Mk completada. Revise los diagnósticos del optimizador y los supuestos del modelo.", "Reconstrução Mk concluída. Revise os diagnósticos do otimizador e os pressupostos do modelo."], "Select a discrete trait with 2 to 10 observed states.": ["Seleccione un rasgo discreto con 2 a 10 estados observados.", "Selecione uma característica discreta com 2 a 10 estados observados."], "Custom matrix must have one row and column per state, without headers.": ["La matriz personalizada debe tener una fila y columna por estado, sin encabezados.", "A matriz personalizada deve ter uma linha e coluna por estado, sem cabeçalhos."], "Custom matrix requires nonnegative integer indices and a zero diagonal.": ["La matriz personalizada requiere índices enteros no negativos y una diagonal de ceros.", "A matriz personalizada exige índices inteiros não negativos e diagonal zero."], "Custom matrix names must match the displayed state order.": ["Los nombres de la matriz deben coincidir con el orden de estados mostrado.", "Os nomes da matriz devem corresponder à ordem dos estados exibida."], "Positive rate indices must be consecutive: 1, 2, 3, and so on.": ["Los índices positivos de tasas deben ser consecutivos: 1, 2, 3, etc.", "Os índices positivos das taxas devem ser consecutivos: 1, 2, 3, etc."], "No ancestral state can reach all observed states under this custom model.": ["Ningún estado ancestral puede alcanzar todos los estados observados con este modelo personalizado.", "Nenhum estado ancestral pode alcançar todos os estados observados com este modelo personalizado."], "Mk reconstruction requires a rooted, bifurcating tree.": ["La reconstrucción Mk requiere un árbol enraizado y bifurcante.", "A reconstrução Mk exige uma árvore enraizada e bifurcante."], "Mk reconstruction requires finite, positive branch lengths.": ["La reconstrucción Mk requiere longitudes de rama finitas y positivas.", "A reconstrução Mk exige comprimentos de ramo finitos e positivos."], "Select distinct taxon and discrete trait columns.": ["Seleccione columnas distintas de taxón y rasgo discreto.", "Selecione colunas distintas de táxon e característica discreta."], "Numeric discrete states must be finite integers; continuous values are not binned.": ["Los estados discretos numéricos deben ser enteros finitos; los valores continuos no se agrupan.", "Os estados discretos numéricos devem ser inteiros finitos; valores contínuos não são agrupados."], "Use one unambiguous state per taxon. Missing and polymorphic states are not supported here.": ["Use un estado inequívoco por taxón. Aquí no se admiten estados faltantes ni polimórficos.", "Use um estado inequívoco por táxon. Estados ausentes e polimórficos não são aceitos aqui."], "The upper rate bound must be finite and greater than 1e-8.": ["El límite superior de tasa debe ser finito y mayor que 1e-8.", "O limite superior da taxa deve ser finito e maior que 1e-8."], "No converged finite fit. Inspect optimizer messages.": ["No hay un ajuste finito convergente. Revise los mensajes del optimizador.", "Não há ajuste finito convergente. Revise as mensagens do otimizador."], "Some starting values failed. Inspect optimizer messages.": ["Algunos valores iniciales fallaron. Revise los mensajes del optimizador.", "Alguns valores iniciais falharam. Revise as mensagens do otimizador."], "A rate is near an optimization bound. Estimates and model rankings may be unstable.": ["Una tasa está cerca de un límite de optimización. Las estimaciones y clasificaciones de modelos pueden ser inestables.", "Uma taxa está próxima de um limite de otimização. Estimativas e classificações de modelos podem ser instáveis."], "Starting values reached different likelihoods. The highest converged likelihood is shown; a global optimum is not guaranteed.": ["Los valores iniciales alcanzaron verosimilitudes diferentes. Se muestra la mayor verosimilitud convergente; no se garantiza un óptimo global.", "Os valores iniciais alcançaram verossimilhanças diferentes. A maior verossimilhança convergente é exibida; não há garantia de ótimo global."], "There are many rate parameters relative to taxa. Interpret this fit cautiously.": ["Hay muchos parámetros de tasa respecto a los taxones. Interprete este ajuste con cautela.", "Há muitos parâmetros de taxa em relação aos táxons. Interprete este ajuste com cautela."], "Some states have fewer than three observed taxa.": ["Algunos estados tienen menos de tres taxones observados.", "Alguns estados têm menos de três táxons observados."], "Invalid marginal probabilities or inconsistent reconstruction likelihood.": ["Probabilidades marginales no válidas o verosimilitud de reconstrucción inconsistente.", "Probabilidades marginais inválidas ou verossimilhança de reconstrução inconsistente."], "Mk ancestral reconstruction": ["Reconstrucción ancestral Mk", "Reconstrução ancestral Mk"], "Transition rates per branch-length unit": ["Tasas de transición por unidad de longitud de rama", "Taxas de transição por unidade de comprimento de ramo"], "Converged": ["Convergente", "Convergente"], "Failed": ["Fallido", "Falhou"], "Start": ["Inicio", "Início"], "Initial": ["Inicial", "Inicial"], "Convergence": ["Convergencia", "Convergência"], "Valid": ["Válido", "Válido"], "Status": ["Estado", "Situação"], "Delta_AIC": ["Delta_AIC", "Delta_AIC"], "LogLik": ["LogLik", "LogLik"]});

Object.assign(guaneTranslations, {"Equivalent": ["Equivalente", "Equivalente"], "Equivalent models share one comparison entry.": ["Los modelos equivalentes comparten una entrada de comparación.", "Modelos equivalentes compartilham uma entrada de comparação."], "nodes have a most-supported state with probability at least 0.90. This is conditional support, not certainty.": ["nodos tienen un estado con mayor apoyo cuya probabilidad es al menos 0.90. Es apoyo condicional, no certeza.", "nós têm um estado de maior suporte com probabilidade de pelo menos 0.90. É suporte condicional, não certeza."]});

Object.assign(guaneTranslations, {"Stochastic mapping (fixed fitted rates)": ["Mapeo estocástico (tasas estimadas fijas)", "Mapeamento estocástico (taxas estimadas fixas)"], "Bayesian rate sampling — planned": ["Muestreo bayesiano de tasas — previsto", "Amostragem bayesiana de taxas — prevista"], "Number of histories": ["Número de historias", "Número de histórias"], "Mapping seed": ["Semilla del mapeo", "Semente do mapeamento"], "History to display": ["Historia para visualizar", "História para visualizar"], "Histories are conditional on the fitted Q matrix, observed tips, tree and equal root probabilities. Rates and trees are not sampled. There is no MCMC burn-in.": ["Las historias están condicionadas a la matriz Q estimada, los estados terminales, el árbol y probabilidades iguales en la raíz. No se muestrean tasas ni árboles. No hay descarte inicial MCMC.", "As histórias são condicionadas à matriz Q estimada, aos estados terminais, à árvore e a probabilidades iguais na raiz. Taxas e árvores não são amostradas. Não há descarte inicial MCMC."], "Simulation ranges describe the central 95% of sampled histories, not confidence intervals for the mean or uncertainty in fitted rates. MCSE measures Monte Carlo precision; small samples and zero sampled events can be misleading.": ["Los rangos de simulación describen el 95% central de las historias muestreadas, no intervalos de confianza de la media ni incertidumbre de las tasas estimadas. MCSE mide la precisión Monte Carlo; muestras pequeñas y cero eventos muestreados pueden ser engañosos.", "Os intervalos de simulação descrevem os 95% centrais das histórias amostradas, não intervalos de confiança da média nem incerteza das taxas estimadas. MCSE mede a precisão Monte Carlo; amostras pequenas e zero eventos amostrados podem ser enganosos."], "Transition counts": ["Conteos de transiciones", "Contagens de transições"], "State occupancy": ["Ocupación de estados", "Ocupação dos estados"], "Download transition summary CSV": ["Descargar resumen de transiciones CSV", "Baixar resumo de transições CSV"], "Download state occupancy CSV": ["Descargar ocupación de estados CSV", "Baixar ocupação dos estados CSV"], "Download sampled node frequencies CSV": ["Descargar frecuencias nodales muestreadas CSV", "Baixar frequências nodais amostradas CSV"], "Download histories and summaries RDS": ["Descargar historias y resúmenes RDS", "Baixar histórias e resumos RDS"], "Monte Carlo agreement": ["Concordancia Monte Carlo", "Concordância Monte Carlo"], "Compare sampled node frequencies with analytic marginal probabilities. Differences should decrease with more independent histories; this plot is not an MCMC convergence or model-adequacy test.": ["Compare frecuencias nodales muestreadas con probabilidades marginales analíticas. Las diferencias deberían disminuir con más historias independientes; este gráfico no es una prueba de convergencia MCMC ni de adecuación del modelo.", "Compare frequências nodais amostradas com probabilidades marginais analíticas. As diferenças devem diminuir com mais histórias independentes; este gráfico não é um teste de convergência MCMC nem de adequação do modelo."], "Choose an integer number of histories between 2 and 500.": ["Elija un número entero de historias entre 2 y 500.", "Escolha um número inteiro de histórias entre 2 e 500."], "Choose an integer seed between 0 and 2147483646.": ["Elija una semilla entera entre 0 y 2147483646.", "Escolha uma semente inteira entre 0 e 2147483646."], "Mapping requires a valid fitted Q matrix in the displayed state order.": ["El mapeo requiere una matriz Q estimada válida con el orden de estados mostrado.", "O mapeamento exige uma matriz Q estimada válida na ordem de estados exibida."], "Requested mapping workload is too large. Reduce the number of histories.": ["La carga de mapeo solicitada es demasiado grande. Reduzca el número de historias.", "A carga de mapeamento solicitada é muito grande. Reduza o número de histórias."], "Mapping did not return the requested number of histories.": ["El mapeo no devolvió el número solicitado de historias.", "O mapeamento não retornou o número solicitado de histórias."], "A sampled history does not match the fitted model or taxa.": ["Una historia muestreada no coincide con el modelo estimado o los taxones.", "Uma história amostrada não corresponde ao modelo estimado ou aos táxons."], "A sampled history has invalid branch segments.": ["Una historia muestreada tiene segmentos de rama no válidos.", "Uma história amostrada tem segmentos de ramo inválidos."], "A sampled history contains a forbidden transition.": ["Una historia muestreada contiene una transición prohibida.", "Uma história amostrada contém uma transição proibida."], "A sampled history is inconsistent at nodes or observed tips.": ["Una historia muestreada es inconsistente en nodos o estados terminales.", "Uma história amostrada é inconsistente nos nós ou estados terminais."], "Run stochastic mapping before viewing history summaries.": ["Ejecute el mapeo estocástico antes de visualizar resúmenes de historias.", "Execute o mapeamento estocástico antes de visualizar resumos de histórias."], "Choose a saved history number within the simulated range.": ["Elija un número de historia guardada dentro del rango simulado.", "Escolha um número de história salva dentro do intervalo simulado."], "Sampled node frequencies": ["Frecuencias nodales muestreadas", "Frequências nodais amostradas"], "Conditional stochastic history": ["Historia estocástica condicional", "História estocástica condicional"], "Transitions per history": ["Transiciones por historia", "Transições por história"], "Total branch length in state": ["Longitud total de ramas en el estado", "Comprimento total de ramos no estado"], "Mean and central 95% simulation range": ["Media y rango central del 95% de simulación", "Média e intervalo central de 95% da simulação"], "Analytic marginal probability": ["Probabilidad marginal analítica", "Probabilidade marginal analítica"], "Sampled node-state frequency": ["Frecuencia muestreada de estado nodal", "Frequência amostrada do estado nodal"], "This framework is planned. Choose ML or fixed-rate stochastic mapping.": ["Este marco está previsto. Elija ML o mapeo estocástico con tasas fijas.", "Esta estrutura está prevista. Escolha ML ou mapeamento estocástico com taxas fixas."], "Simulating conditional histories": ["Simulando historias condicionales", "Simulando histórias condicionais"], "Stochastic mapping completed. Review simulation precision and fitted-rate warnings.": ["Mapeo estocástico completado. Revise la precisión de simulación y las advertencias de tasas estimadas.", "Mapeamento estocástico concluído. Revise a precisão da simulação e os avisos das taxas estimadas."], "Conditional stochastic mapping completed.": ["Mapeo estocástico condicional completado.", "Mapeamento estocástico condicional concluído."], "Saved histories": ["Historias guardadas", "Histórias salvas"], "From": ["Origen", "Origem"], "To": ["Destino", "Destino"], "State": ["Estado", "Estado"], "Mean": ["Media", "Média"], "SD": ["DE", "DP"], "MCSE": ["MCSE", "MCSE"], "Frequency": ["Frecuencia", "Frequência"], "Analytic": ["Analítica", "Analítica"], "Difference": ["Diferencia", "Diferença"]});

Object.assign(guaneTranslations, {"Run stochastic mapping": ["Ejecutar mapeo estocástico", "Executar mapeamento estocástico"]});

Object.assign(guaneTranslations, {"Polymorphic ancestral reconstruction": ["Reconstrucción ancestral polimórfica", "Reconstrução ancestral polimórfica"], "Code coexisting states with +, such as A+B. Missing, ambiguous and empty states are not supported.": ["Codifique estados coexistentes con +, como A+B. No se admiten estados faltantes, ambiguos ni vacíos.", "Codifique estados coexistentes com +, como A+B. Estados ausentes, ambíguos ou vazios não são aceitos."], "Use two or three constituent states and at least one polymorphic taxon.": ["Use dos o tres estados constituyentes y al menos un taxón polimórfico.", "Use dois ou três estados constituintes e pelo menos um táxon polimórfico."], "Use unique state names without surrounding spaces in each combination.": ["Use nombres de estado únicos sin espacios alrededor en cada combinación.", "Use nomes de estado únicos sem espaços ao redor em cada combinação."], "Unknown polymorphic model.": ["Modelo polimórfico desconocido.", "Modelo polimórfico desconhecido."], "Unordered model: transitions add or lose one constituent state. All combinations are included, even if unobserved. Direct monomorphic substitutions are forbidden.": ["Modelo no ordenado: las transiciones añaden o pierden un estado constituyente. Se incluyen todas las combinaciones, incluso no observadas. No se permiten sustituciones monomórficas directas.", "Modelo não ordenado: as transições adicionam ou perdem um estado constituinte. Todas as combinações são incluídas, mesmo não observadas. Substituições monomórficas diretas são proibidas."], "ER shares allowed rates; SYM ties reverse rates; ARD separates directions; transient uses one loss rate and one gain rate.": ["ER comparte tasas permitidas; SYM iguala tasas inversas; ARD separa direcciones; transient usa una tasa de pérdida y una de ganancia.", "ER compartilha taxas permitidas; SYM iguala taxas reversas; ARD separa direções; transient usa uma taxa de perda e uma de ganho."], "Equal root probabilities apply to combined states, not to constituent states. A+B represents coexistence, not uncertain coding.": ["Las probabilidades iguales en la raíz se aplican a estados combinados, no a estados constituyentes. A+B representa coexistencia, no codificación incierta.", "As probabilidades iguais na raiz se aplicam a estados combinados, não a estados constituintes. A+B representa coexistência, não codificação incerta."], "Compare polymorphic models": ["Comparar modelos polimórficos", "Comparar modelos polimórficos"], "Run polymorphic reconstruction": ["Ejecutar reconstrucción polimórfica", "Executar reconstrução polimórfica"], "Coding audit": ["Auditoría de codificación", "Auditoria da codificação"], "Combination order is canonicalized for fitting; original data remain unchanged.": ["El orden de las combinaciones se estandariza para el ajuste; los datos originales no cambian.", "A ordem das combinações é padronizada para o ajuste; os dados originais permanecem inalterados."], "Download coding audit CSV": ["Descargar auditoría de codificación CSV", "Baixar auditoria da codificação CSV"], "Rate constraints": ["Restricciones de tasas", "Restrições de taxas"], "Comparisons use the same taxa, complete state space and equal root probabilities. AIC weights cover converged candidates only; no model averaging is performed.": ["Las comparaciones usan los mismos taxones, el espacio completo de estados y probabilidades iguales en la raíz. Los pesos AIC incluyen solo candidatos convergentes; no se promedian modelos.", "As comparações usam os mesmos táxons, o espaço completo de estados e probabilidades iguais na raiz. Os pesos AIC incluem apenas candidatos convergentes; não há média de modelos."], "Choose a polymorphic trait and run reconstruction.": ["Elija un rasgo polimórfico y ejecute la reconstrucción.", "Escolha uma característica polimórfica e execute a reconstrução."], "Inputs changed. Run polymorphic reconstruction to update results.": ["Los datos cambiaron. Ejecute la reconstrucción polimórfica para actualizar resultados.", "Os dados mudaram. Execute a reconstrução polimórfica para atualizar os resultados."], "This framework is planned. Only polymorphic maximum likelihood is implemented.": ["Este marco está previsto. Solo se implementó máxima verosimilitud polimórfica.", "Esta estrutura está prevista. Apenas máxima verossimilhança polimórfica está implementada."], "Polymorphic reconstruction completed. Review coding, constraints and diagnostics.": ["Reconstrucción polimórfica completada. Revise la codificación, las restricciones y los diagnósticos.", "Reconstrução polimórfica concluída. Revise a codificação, as restrições e os diagnósticos."], "Polymorphic reconstruction completed. Combination coding is recorded in the analysis audit; source data are unchanged.": ["Reconstrucción polimórfica completada. La codificación está registrada en la auditoría del análisis; los datos fuente no cambian.", "Reconstrução polimórfica concluída. A codificação está registrada na auditoria da análise; os dados originais permanecem inalterados."], "Original": ["Original", "Original"], "Canonical": ["Canónico", "Canônico"]});

Object.assign(guaneTranslations,{"Ordered polymorphism": ["Polimorfismo ordenado", "Polimorfismo ordenado"], "Unordered polymorphism": ["Polimorfismo no ordenado", "Polimorfismo não ordenado"], "Constituent order (one state per line)": ["Orden de estados constituyentes (uno por línea)", "Ordem dos estados constituintes (um por linha)"], "Maximum polymorphism": ["Polimorfismo máximo", "Polimorfismo máximo"], "Only contiguous combinations in the specified order are allowed. Maximum polymorphism limits the number of coexisting states. No order is inferred automatically.": ["Solo se permiten combinaciones contiguas en el orden especificado. El polimorfismo máximo limita el número de estados coexistentes. No se infiere ningún orden automáticamente.", "Apenas combinações contíguas na ordem especificada são permitidas. O polimorfismo máximo limita o número de estados coexistentes. Nenhuma ordem é inferida automaticamente."], "Transition preview": ["Vista previa de transiciones", "Prévia das transições"], "Rows are source states; columns are destinations. Zero forbids a transition; equal positive indices share a rate. This preview does not fit a model.": ["Las filas son estados de origen; las columnas son destinos. Cero prohíbe una transición; índices positivos iguales comparten una tasa. Esta vista previa no ajusta un modelo.", "As linhas são estados de origem; as colunas são destinos. Zero proíbe uma transição; índices positivos iguais compartilham uma taxa. Esta prévia não ajusta um modelo."], "Constraints are valid. Review allowed transitions before running.": ["Las restricciones son válidas. Revise las transiciones permitidas antes de ejecutar.", "As restrições são válidas. Revise as transições permitidas antes de executar."], "Choose ordered or unordered polymorphism.": ["Elija polimorfismo ordenado o no ordenado.", "Escolha polimorfismo ordenado ou não ordenado."], "State order must contain every constituent exactly once.": ["El orden debe contener cada estado constituyente exactamente una vez.", "A ordem deve conter cada estado constituinte exatamente uma vez."], "Maximum polymorphism must be an integer from 2 to the number of constituent states.": ["El polimorfismo máximo debe ser un entero entre 2 y el número de estados constituyentes.", "O polimorfismo máximo deve ser um inteiro entre 2 e o número de estados constituintes."], "Observed combinations violate the state order or maximum polymorphism. Change the model settings; no taxa are removed.": ["Las combinaciones observadas incumplen el orden o el polimorfismo máximo. Cambie los ajustes del modelo; no se eliminan taxones.", "As combinações observadas violam a ordem ou o polimorfismo máximo. Altere as configurações do modelo; nenhum táxon é removido."]});

Object.assign(guaneTranslations,{"Tree source": ["Origen de árboles", "Origem das árvores"], "Data tree": ["Árbol de Datos", "Árvore de Dados"], "Uploaded tree set": ["Conjunto de árboles cargados", "Conjunto de árvores carregadas"], "Newick files (one or more trees)": ["Archivos Newick (uno o más árboles)", "Arquivos Newick (uma ou mais árvores)"], "Up to 25 trees; every tree must pass validation. Uploaded trees remain local to this card.": ["Hasta 25 árboles; todos deben pasar la validación. Los árboles cargados permanecen en esta tarjeta.", "Até 25 árvores; todas devem passar pela validação. As árvores carregadas permanecem neste cartão."], "Include stem (root.edge)": ["Incluir rama basal (root.edge)", "Incluir ramo basal (root.edge)"], "Ultrametric tolerance": ["Tolerancia ultramétrica", "Tolerância ultramétrica"], "Non-ultrametric trees are not accepted in this workflow. No rooting, pruning, resolution or recalibration is automatic.": ["Este flujo no acepta árboles no ultramétricos. No se enraíza, poda, resuelve ni recalibra automáticamente.", "Este fluxo não aceita árvores não ultramétricas. Nenhum enraizamento, poda, resolução ou recalibração é automático."], "Stem lengths are omitted unless explicitly included. Without a supplied stem, the curve begins at the crown root.": ["La rama basal se omite salvo inclusión explícita. Sin ella, la curva comienza en la raíz de la corona.", "O ramo basal é omitido salvo inclusão explícita. Sem ele, a curva começa na raiz da coroa."], "Time direction": ["Dirección temporal", "Direção temporal"], "Since origin": ["Desde el origen", "Desde a origem"], "Before present": ["Antes del presente", "Antes do presente"], "Time before present (branch-length units)": ["Tiempo antes del presente (unidades de longitud de rama)", "Tempo antes do presente (unidades de comprimento de ramo)"], "Time since origin (branch-length units)": ["Tiempo desde el origen (unidades de longitud de rama)", "Tempo desde a origem (unidades de comprimento de ramo)"], "Line width": ["Grosor de línea", "Espessura da linha"], "Line type": ["Tipo de línea", "Tipo de linha"], "Solid": ["Continua", "Contínua"], "Dashed": ["Discontinua", "Tracejada"], "Dotted": ["Punteada", "Pontilhada"], "Dotdash": ["Punto y guion", "Ponto e traço"], "Longdash": ["Guiones largos", "Traços longos"], "Twodash": ["Guiones dobles", "Traços duplos"], "Width (inches)": ["Ancho (pulgadas)", "Largura (polegadas)"], "Height (inches)": ["Altura (pulgadas)", "Altura (polegadas)"], "PNG resolution (dpi)": ["Resolución PNG (dpi)", "Resolução PNG (dpi)"], "Overlays are individual curves, not confidence bands. Compare trees only when branch-length units and sampling are compatible.": ["Las superposiciones son curvas individuales, no bandas de confianza. Compare árboles solo con unidades y muestreo compatibles.", "As sobreposições são curvas individuais, não faixas de confiança. Compare árvores apenas com unidades e amostragem compatíveis."], "LTT coordinates (first 100 rows)": ["Coordenadas LTT (primeras 100 filas)", "Coordenadas LTT (primeiras 100 linhas)"], "Choose trees and run LTT.": ["Elija árboles y ejecute LTT.", "Escolha árvores e execute LTT."], "Inputs changed. Run LTT to update results.": ["Las entradas cambiaron. Ejecute LTT para actualizar los resultados.", "As entradas mudaram. Execute LTT para atualizar os resultados."], "Upload Newick trees first.": ["Cargue primero árboles Newick.", "Carregue primeiro árvores Newick."], "LTT completed. Review tree ages and sampling assumptions.": ["LTT completado. Revise las edades de los árboles y los supuestos de muestreo.", "LTT concluído. Revise as idades das árvores e os pressupostos de amostragem."], "Validated rooted ultrametric trees; no taxa or branches were changed.": ["Árboles enraizados ultramétricos validados; no se modificaron taxones ni ramas.", "Árvores enraizadas ultramétricas validadas; nenhum táxon ou ramo foi alterado."], "Tree": ["Árbol", "Árvore"], "Tips": ["Terminales", "Terminais"], "Crown_age": ["Edad_corona", "Idade_coroa"], "Stem": ["Rama_basal", "Ramo_basal"], "Tip_depth_range": ["Rango_profundidad_terminal", "Amplitude_profundidade_terminal"], "Events": ["Eventos", "Eventos"], "LTT requires at least two uniquely named tips.": ["LTT requiere al menos dos terminales con nombres únicos.", "LTT exige pelo menos dois terminais com nomes únicos."], "Invalid tree structure for LTT.": ["Estructura del árbol no válida para LTT.", "Estrutura da árvore inválida para LTT."], "LTT requires an explicitly rooted tree.": ["LTT requiere un árbol explícitamente enraizado.", "LTT exige uma árvore explicitamente enraizada."], "LTT requires finite, positive branch lengths.": ["LTT requiere longitudes de rama finitas y positivas.", "LTT exige comprimentos de ramo finitos e positivos."], "LTT tolerance must be positive and at most 0.001.": ["La tolerancia LTT debe ser positiva y como máximo 0.001.", "A tolerância LTT deve ser positiva e no máximo 0.001."], "LTT requires an ultrametric tree; calibrate it before analysis.": ["LTT requiere un árbol ultramétrico; calíbrelo antes del análisis.", "LTT exige uma árvore ultramétrica; calibre-a antes da análise."], "Invalid stem setting.": ["Ajuste de rama basal no válido.", "Configuração do ramo basal inválida."], "Stem length must be finite and nonnegative.": ["La longitud basal debe ser finita y no negativa.", "O comprimento basal deve ser finito e não negativo."], "Choose one to 25 trees for LTT.": ["Elija entre uno y 25 árboles para LTT.", "Escolha entre uma e 25 árvores para LTT."], "No trees found in the uploaded Newick file.": ["No se encontraron árboles en el archivo Newick.", "Nenhuma árvore encontrada no arquivo Newick."], "Invalid LTT graph settings.": ["Ajustes del gráfico LTT no válidos.", "Configurações do gráfico LTT inválidas."]});

Object.assign(guaneTranslations,{"Lineage through time":["Linajes a través del tiempo","Linhagens ao longo do tempo"]});

Object.assign(guaneTranslations,{"Models": ["Modelos", "Modelos"], "Birth-death": ["Nacimiento-muerte", "Nascimento-morte"], "Random extant sampling fraction": ["Fracción de muestreo aleatorio de especies actuales", "Fração de amostragem aleatória de espécies atuais"], "Condition on crown survival and root split": ["Condicionar a la supervivencia de la corona y la división de la raíz", "Condicionar à sobrevivência da coroa e à divisão da raiz"], "Sampling assumes independent random inclusion of extant species. Nonrandom or diversified sampling is not modeled.": ["El muestreo supone la inclusión aleatoria e independiente de especies actuales. No se modela el muestreo no aleatorio o diversificado.", "A amostragem pressupõe inclusão aleatória e independente de espécies atuais. A amostragem não aleatória ou diversificada não é modelada."], "Crown-tree likelihood; supplied stems are excluded. No tip-number conditioning. Both models use the same sampling and conditioning settings.": ["Verosimilitud del árbol corona; se excluyen las ramas basales suministradas. Sin condicionamiento al número de terminales. Ambos modelos usan el mismo muestreo y condicionamiento.", "Verossimilhança da árvore coroa; ramos basais fornecidos são excluídos. Sem condicionamento ao número de terminais. Ambos os modelos usam a mesma amostragem e condicionamento."], "Optimizer": ["Optimizador", "Otimizador"], "Maximum iterations": ["Máximo de iteraciones", "Máximo de iterações"], "Rate upper bound (blank = 100 / crown age)": ["Límite superior de tasa (vacío = 100 / edad corona)", "Limite superior da taxa (vazio = 100 / idade da coroa)"], "Initial lambda (blank = derived)": ["lambda inicial (vacío = calculado)", "lambda inicial (vazio = calculado)"], "Initial mu (blank = lambda / 2)": ["mu inicial (vacío = lambda / 2)", "mu inicial (vazio = lambda / 2)"], "Several deterministic starts are tried. Extinction may exceed speciation; no positive net-diversification constraint is imposed.": ["Se prueban varios inicios deterministas. La extinción puede superar la especiación; no se impone diversificación neta positiva.", "São testados vários inícios determinísticos. A extinção pode superar a especiação; não se exige diversificação líquida positiva."], "Calculate approximate curvature intervals": ["Calcular intervalos aproximados por curvatura", "Calcular intervalos aproximados por curvatura"], "Save likelihood slices": ["Guardar cortes de verosimilitud", "Salvar cortes de verossimilhança"], "Run diversification models": ["Ejecutar modelos de diversificación", "Executar modelos de diversificação"], "Rate estimates": ["Estimaciones de tasas", "Estimativas de taxas"], "Likelihood slice": ["Corte de verosimilitud", "Corte de verossimilhança"], "lambda is speciation, mu is extinction, and net is lambda minus mu. Rates are per branch-length unit, not automatically per million years.": ["lambda es especiación, mu es extinción y net es lambda menos mu. Las tasas son por unidad de longitud de rama, no automáticamente por millón de años.", "lambda é especiação, mu é extinção e net é lambda menos mu. As taxas são por unidade de comprimento de ramo, não automaticamente por milhão de anos."], "Intervals are approximate 95% normal intervals from likelihood curvature. NA means unavailable, including fixed rates, boundary estimates, unstable curvature or negative rate limits. They exclude uncertainty in sampling fraction and tree.": ["Los intervalos normales aproximados del 95% se basan en la curvatura de la verosimilitud. NA indica que no están disponibles: tasas fijas, estimaciones en límites, curvatura inestable o límites negativos de tasas. Excluyen la incertidumbre del muestreo y del árbol.", "Os intervalos normais aproximados de 95% se baseiam na curvatura da verossimilhança. NA indica indisponibilidade: taxas fixas, estimativas nos limites, curvatura instável ou limites negativos de taxas. Excluem a incerteza da amostragem e da árvore."], "AIC weights compare only the selected models on the same likelihood basis. Weights are withheld if a candidate fails. Boundary fits and extinction estimates need caution; no likelihood-ratio p-value is reported.": ["Los pesos AIC comparan solo los modelos seleccionados con la misma base de verosimilitud. No se muestran si falla un candidato. Los ajustes en límites y las estimaciones de extinción requieren cautela; no se informa un valor p de razón de verosimilitudes.", "Os pesos AIC comparam apenas os modelos selecionados na mesma base de verossimilhança. Não são exibidos se um candidato falhar. Ajustes nos limites e estimativas de extinção exigem cautela; não se informa valor p de razão de verossimilhanças."], "Likelihood slices hold the other rate fixed. They reveal local curvature but are not profile likelihoods or confidence intervals. Select Likelihood slice in Graph controls to view and export them.": ["Los cortes mantienen fija la otra tasa. Muestran la curvatura local, pero no son perfiles de verosimilitud ni intervalos de confianza. Seleccione Corte de verosimilitud en Controles del gráfico para verlos y exportarlos.", "Os cortes mantêm a outra taxa fixa. Mostram a curvatura local, mas não são perfis de verossimilhança nem intervalos de confiança. Selecione Corte de verossimilhança em Controles do gráfico para visualizar e exportar."], "Download likelihood slices CSV": ["Descargar cortes de verosimilitud CSV", "Baixar cortes de verossimilhança CSV"], "Download optimizer diagnostics CSV": ["Descargar diagnósticos del optimizador CSV", "Baixar diagnósticos do otimizador CSV"], "Rates require a rooted binary ultrametric tree with at least four tips.": ["Las tasas requieren un árbol binario, enraizado y ultramétrico con al menos cuatro terminales.", "As taxas exigem uma árvore binária, enraizada e ultramétrica com pelo menos quatro terminais."], "Choose Yule, birth-death, or both models.": ["Elija Yule, nacimiento-muerte o ambos modelos.", "Escolha Yule, nascimento-morte ou ambos os modelos."], "Sampling fraction must be greater than zero and at most one.": ["La fracción de muestreo debe ser mayor que cero y como máximo uno.", "A fração de amostragem deve ser maior que zero e no máximo um."], "Invalid rate analysis settings.": ["Ajustes del análisis de tasas no válidos.", "Configurações da análise de taxas inválidas."], "Invalid optimizer settings.": ["Ajustes del optimizador no válidos.", "Configurações do otimizador inválidas."], "Rate upper bound must be positive and compatible with the tree scale.": ["El límite superior de tasa debe ser positivo y compatible con la escala del árbol.", "O limite superior da taxa deve ser positivo e compatível com a escala da árvore."], "Starting rates must lie inside the selected rate bounds.": ["Las tasas iniciales deben estar dentro de los límites seleccionados.", "As taxas iniciais devem estar dentro dos limites selecionados."], "A model failed to converge; model comparison weights are withheld.": ["Un modelo no convergió; no se muestran los pesos de comparación.", "Um modelo não convergiu; os pesos de comparação não são exibidos."], "A rate lies on an optimization boundary. Intervals are withheld; inspect bounds and extinction identifiability.": ["Una tasa está en un límite de optimización. No se muestran intervalos; revise los límites y la identificabilidad de la extinción.", "Uma taxa está em um limite de otimização. Os intervalos não são exibidos; revise os limites e a identificabilidade da extinção."], "Some optimizer starts failed; inspect the full optimizer table.": ["Algunos inicios del optimizador fallaron; revise la tabla completa.", "Alguns inícios do otimizador falharam; revise a tabela completa."], "Optimizer starts reached different likelihoods; a global optimum is not guaranteed.": ["Los inicios alcanzaron diferentes verosimilitudes; no se garantiza un óptimo global.", "Os inícios atingiram diferentes verossimilhanças; não se garante um ótimo global."], "Likelihood curvature is unstable; approximate intervals are unavailable.": ["La curvatura de la verosimilitud es inestable; los intervalos aproximados no están disponibles.", "A curvatura da verossimilhança é instável; os intervalos aproximados estão indisponíveis."], "No valid model fit. Change settings and run again.": ["No hay un ajuste válido. Cambie los ajustes y ejecute de nuevo.", "Nenhum ajuste válido. Altere as configurações e execute novamente."], "Supplied stem excluded; this analysis uses a crown-tree likelihood.": ["Se excluyó la rama basal; este análisis usa una verosimilitud del árbol corona.", "O ramo basal foi excluído; esta análise usa uma verossimilhança da árvore coroa."], "At least two converged compatible fits are required for comparison.": ["Se requieren al menos dos ajustes compatibles y convergentes para comparar.", "São necessários pelo menos dois ajustes compatíveis e convergentes para comparar."], "Constant-rate model comparison": ["Comparación de modelos de tasa constante", "Comparação de modelos de taxa constante"], "No saved likelihood slice for this selection.": ["No hay un corte de verosimilitud guardado para esta selección.", "Não há corte de verossimilhança salvo para esta seleção."], "per branch-length unit": ["por unidad de longitud de rama", "por unidade de comprimento de ramo"], "Likelihood slice: other rate held fixed": ["Corte de verosimilitud: otra tasa fija", "Corte de verossimilhança: outra taxa fixa"], "Rates per branch-length unit": ["Tasas por unidad de longitud de rama", "Taxas por unidade de comprimento de ramo"], "Constant-rate estimates": ["Estimaciones de tasa constante", "Estimativas de taxa constante"], "Choose settings and run diversification models.": ["Elija los ajustes y ejecute los modelos de diversificación.", "Escolha as configurações e execute os modelos de diversificação."], "Inputs changed. Run diversification models to update results.": ["Las entradas cambiaron. Ejecute los modelos de diversificación para actualizar los resultados.", "As entradas mudaram. Execute os modelos de diversificação para atualizar os resultados."], "Fitting diversification models": ["Ajustando modelos de diversificación", "Ajustando modelos de diversificação"], "Rate analysis completed. Inspect convergence, bounds and uncertainty.": ["Análisis de tasas completado. Revise la convergencia, los límites y la incertidumbre.", "Análise de taxas concluída. Revise a convergência, os limites e a incerteza."], "Constant-rate diversification analysis completed.": ["Análisis de diversificación de tasa constante completado.", "Análise de diversificação de taxa constante concluída."], "No fitting warnings reported. Inspect diagnostics before interpretation.": ["No se informaron advertencias de ajuste. Revise los diagnósticos antes de interpretar.", "Nenhum aviso de ajuste. Revise os diagnósticos antes de interpretar."], "Fixed": ["Fijo", "Fixo"], "Boundary": ["Límite", "Limite"], "Converged": ["Convergió", "Convergiu"], "Parameters": ["Parámetros", "Parâmetros"], "Start": ["Inicio", "Início"], "Message": ["Mensaje", "Mensagem"], "Weight": ["Peso", "Peso"]});

Object.assign(guaneTranslations,{"Bars: approximate 95% curvature intervals where available": ["Barras: intervalos aproximados del 95% por curvatura cuando están disponibles", "Barras: intervalos aproximados de 95% por curvatura quando disponíveis"], "Model ranking requires two converged candidates. Inspect individual estimates and diagnostics.": ["La clasificación requiere dos candidatos convergentes. Revise las estimaciones individuales y los diagnósticos.", "A classificação exige dois candidatos convergentes. Revise as estimativas individuais e os diagnósticos."], "Lowest AIC among selected models:": ["Menor AIC entre los modelos seleccionados:", "Menor AIC entre os modelos selecionados:"], "The AIC difference is small; these data do not clearly distinguish the selected models.": ["La diferencia de AIC es pequeña; estos datos no distinguen claramente los modelos seleccionados.", "A diferença de AIC é pequena; estes dados não distinguem claramente os modelos selecionados."], "Relative AIC support does not establish that the selected model adequately describes the data.": ["El apoyo relativo de AIC no establece que el modelo seleccionado describa adecuadamente los datos.", "O suporte relativo de AIC não estabelece que o modelo selecionado descreva adequadamente os dados."]});

Object.assign(guaneTranslations,{"Uncertainty and model diagnostics": ["Incertidumbre y diagnósticos del modelo", "Incerteza e diagnósticos do modelo"], "Calculate profile likelihoods": ["Calcular perfiles de verosimilitud", "Calcular perfis de verossimilhança"], "Profile reference level": ["Nivel de referencia del perfil", "Nível de referência do perfil"], "Profile grid points": ["Puntos de la malla del perfil", "Pontos da grade do perfil"], "Simulate conditional LTT curves": ["Simular curvas LTT condicionales", "Simular curvas LTT condicionais"], "Simulation replicates": ["Réplicas de simulación", "Réplicas de simulação"], "Simulation seed": ["Semilla de simulación", "Semente de simulação"], "Run uncertainty and diagnostics": ["Ejecutar incertidumbre y diagnósticos", "Executar incerteza e diagnósticos"], "Run models first. Diagnostic settings clear only diagnostics; rerun diagnostics after changing them.": ["Ejecute primero los modelos. Los ajustes de diagnóstico borran solo los diagnósticos; vuelva a ejecutarlos después de cambiarlos.", "Execute os modelos primeiro. As configurações de diagnóstico apagam apenas os diagnósticos; execute-os novamente após alterá-las."], "Profile likelihood": ["Perfil de verosimilitud", "Perfil de verossimilhança"], "Conditional LTT check": ["Verificación LTT condicional", "Verificação LTT condicional"], "Conditional discrepancy reference": ["Referencia de discrepancia condicional", "Referência de discrepância condicional"], "Profile uncertainty": ["Incertidumbre por perfil", "Incerteza por perfil"], "Profiles reoptimize the nuisance rate within the fitted bounds. The chi-square reference is approximate; coverage at boundaries is not calibrated. Search limits are not infinite confidence limits. Nuisance_bound flags dependence on the upper rate bound.": ["Los perfiles reoptimizan la otra tasa dentro de los límites del ajuste. La referencia chi-cuadrado es aproximada; la cobertura en fronteras no está calibrada. Los límites de búsqueda no son límites de confianza infinitos. Nuisance_bound indica dependencia del límite superior de tasa.", "Os perfis reotimizam a outra taxa dentro dos limites do ajuste. A referência qui-quadrado é aproximada; a cobertura nas fronteiras não é calibrada. Limites de busca não são limites de confiança infinitos. Nuisance_bound indica dependência do limite superior da taxa."], "Download profile intervals CSV": ["Descargar intervalos de perfil CSV", "Baixar intervalos de perfil CSV"], "Download profile curves CSV": ["Descargar curvas de perfil CSV", "Baixar curvas de perfil CSV"], "Conditional simulation check": ["Verificación de simulación condicional", "Verificação de simulação condicional"], "Simulations fix fitted rates, random sampling fraction, crown age and sampled tip count. They test branching-time shape, not tree size or age. The 95% envelope is pointwise, not simultaneous, and excludes parameter and tree uncertainty.": ["Las simulaciones fijan las tasas estimadas, la fracción de muestreo aleatorio, la edad corona y el número de terminales muestreados. Evalúan el patrón de tiempos de ramificación, no el tamaño o la edad del árbol. La envolvente del 95% es puntual, no simultánea, y excluye la incertidumbre de parámetros y del árbol.", "As simulações fixam as taxas estimadas, a fração de amostragem aleatória, a idade da coroa e o número de terminais amostrados. Avaliam o padrão dos tempos de ramificação, não o tamanho ou a idade da árvore. O envelope de 95% é pontual, não simultâneo, e exclui a incerteza dos parâmetros e da árvore."], "The reference tail fraction compares a branching-time CDF discrepancy with simulations at fitted rates. It is descriptive, not a calibrated p-value; rates are not refitted per replicate. Select a diagnostic graph in Results to view and export it.": ["La fracción de cola de referencia compara una discrepancia de la distribución de tiempos de ramificación con simulaciones a tasas estimadas. Es descriptiva, no un valor p calibrado; no se reajustan tasas por réplica. Seleccione un gráfico de diagnóstico en Resultados para verlo y exportarlo.", "A fração de cauda de referência compara uma discrepância da distribuição dos tempos de ramificação com simulações nas taxas estimadas. É descritiva, não um valor p calibrado; as taxas não são reajustadas por réplica. Selecione um gráfico de diagnóstico em Resultados para visualizar e exportar."], "Download simulation envelope CSV": ["Descargar envolvente de simulación CSV", "Baixar envelope de simulação CSV"], "Download simulated branching times CSV": ["Descargar tiempos de ramificación simulados CSV", "Baixar tempos de ramificação simulados CSV"], "Invalid profile settings.": ["Ajustes de perfil no válidos.", "Configurações de perfil inválidas."], "Threshold crossing": ["Cruce del umbral", "Cruzamento do limiar"], "Physical boundary": ["Frontera física", "Fronteira física"], "Search limit reached": ["Límite de búsqueda alcanzado", "Limite de busca atingido"], "Profile numerical failure or better optimum": ["Fallo numérico del perfil u óptimo mejor", "Falha numérica do perfil ou ótimo melhor"], "Disconnected support; inspect profile": ["Soporte desconectado; revise el perfil", "Suporte desconectado; revise o perfil"], "Invalid simulation parameters.": ["Parámetros de simulación no válidos.", "Parâmetros de simulação inválidos."], "Invalid simulation times.": ["Tiempos de simulación no válidos.", "Tempos de simulação inválidos."], "Invalid simulation probabilities.": ["Probabilidades de simulación no válidas.", "Probabilidades de simulação inválidas."], "Simulation numerical failure.": ["Fallo numérico de simulación.", "Falha numérica da simulação."], "Invalid simulation settings.": ["Ajustes de simulación no válidos.", "Configurações de simulação inválidas."], "Invalid diagnostic settings.": ["Ajustes de diagnóstico no válidos.", "Configurações de diagnóstico inválidas."], "Run profile diagnostics first.": ["Ejecute primero los diagnósticos de perfil.", "Execute primeiro os diagnósticos de perfil."], "No profile for a fixed or failed parameter.": ["No hay perfil para un parámetro fijo o fallido.", "Não há perfil para um parâmetro fixo ou com falha."], "Profile likelihood: nuisance rate reoptimized": ["Perfil de verosimilitud: otra tasa reoptimizada", "Perfil de verossimilhança: outra taxa reotimizada"], "Reference level": ["Nivel de referencia", "Nível de referência"], "Boundary coverage is not calibrated.": ["La cobertura en fronteras no está calibrada.", "A cobertura nas fronteiras não é calibrada."], "Run simulation diagnostics first.": ["Ejecute primero los diagnósticos de simulación.", "Execute primeiro os diagnósticos de simulação."], "No simulations for this model.": ["No hay simulaciones para este modelo.", "Não há simulações para este modelo."], "Time since crown (branch-length units)": ["Tiempo desde la corona (unidades de longitud de rama)", "Tempo desde a coroa (unidades de comprimento de ramo)"], "Simulation median": ["Mediana de simulación", "Mediana da simulação"], "Pointwise 95% simulation envelope": ["Envolvente puntual del 95% de simulación", "Envelope pontual de 95% da simulação"], "Running uncertainty and simulation diagnostics": ["Ejecutando incertidumbre y diagnósticos de simulación", "Executando incerteza e diagnósticos de simulação"], "Diagnostics completed. Review profile limits and simulation assumptions.": ["Diagnósticos completados. Revise los límites del perfil y los supuestos de simulación.", "Diagnósticos concluídos. Revise os limites do perfil e os pressupostos da simulação."], "Lower_status": ["Estado_inferior", "Estado_inferior"], "Upper_status": ["Estado_superior", "Estado_superior"], "Level": ["Nivel", "Nível"], "Nuisance_bound": ["Límite_otra_tasa", "Limite_outra_taxa"], "Simulations": ["Simulaciones", "Simulações"], "Observed_D": ["D_observado", "D_observado"], "Reference_tail_fraction": ["Fracción_cola_referencia", "Fração_cauda_referência"]});

Object.assign(guaneTranslations,{"Observed": ["Observado", "Observado"], "Frequency": ["Frecuencia", "Frequência"], "Too many simulated branching times; reduce replicates.": ["Demasiados tiempos de ramificación simulados; reduzca las réplicas.", "Tempos de ramificação simulados em excesso; reduza as réplicas."], "A rate lies on an optimization boundary. Curvature intervals are withheld; inspect bounds and extinction identifiability.": ["Una tasa está en un límite de optimización. No se muestran intervalos por curvatura; revise los límites y la identificabilidad de la extinción.", "Uma taxa está em um limite de otimização. Os intervalos por curvatura não são exibidos; revise os limites e a identificabilidade da extinção."]});

Object.assign(guaneTranslations,{"Time-varying models": ["Modelos variables en el tiempo", "Modelos variáveis no tempo"], "Time-comparison candidates": ["Candidatos para comparación temporal", "Candidatos para comparação temporal"], "ExpYule: exponential speciation, zero extinction. ExpBD: exponential speciation, constant extinction. lambda(t) = lambda0 * exp(-beta * t), with t measured backward from the present. Positive beta means increasing speciation toward the present.": ["ExpYule: especiación exponencial, extinción cero. ExpBD: especiación exponencial, extinción constante. lambda(t) = lambda0 * exp(-beta * t), con t medido hacia el pasado desde el presente. beta positivo indica especiación creciente hacia el presente.", "ExpYule: especiação exponencial, extinção zero. ExpBD: especiação exponencial, extinção constante. lambda(t) = lambda0 * exp(-beta * t), com t medido para o passado a partir do presente. beta positivo indica especiação crescente em direção ao presente."], "Initial beta (per branch-length unit)": ["beta inicial (por unidad de longitud de rama)", "beta inicial (por unidade de comprimento de ramo)"], "Absolute bound on beta times crown age": ["Límite absoluto de beta por edad corona", "Limite absoluto de beta vezes idade da coroa"], "ODE tolerance": ["Tolerancia ODE", "Tolerância ODE"], "ODE solver": ["Solucionador ODE", "Solucionador ODE"], "Uses the sampling, conditioning, optimizer and rate starts above. The rate upper bound limits present-day speciation and constant extinction; ancestral speciation can exceed it. All comparison candidates use the same ODE likelihood.": ["Usa el muestreo, condicionamiento, optimizador y tasas iniciales anteriores. El límite superior restringe la especiación actual y la extinción constante; la especiación ancestral puede superarlo. Todos los candidatos usan la misma verosimilitud ODE.", "Usa a amostragem, o condicionamento, o otimizador e as taxas iniciais acima. O limite superior restringe a especiação atual e a extinção constante; a especiação ancestral pode superá-lo. Todos os candidatos usam a mesma verossimilhança ODE."], "Run time-varying comparison": ["Ejecutar comparación temporal", "Executar comparação temporal"], "Rates through time": ["Tasas a través del tiempo", "Taxas ao longo do tempo"], "Time-model comparison": ["Comparación de modelos temporales", "Comparação de modelos temporais"], "Time-model results": ["Resultados de modelos temporales", "Resultados de modelos temporais"], "Time-model trajectories are fitted estimates without uncertainty bands. Constant-rate profiles and simulations do not apply to the time-varying fits. AIC weights describe this candidate set, not model adequacy.": ["Las trayectorias temporales son estimaciones ajustadas sin bandas de incertidumbre. Los perfiles y simulaciones de tasa constante no se aplican a los ajustes variables. Los pesos AIC describen este conjunto de candidatos, no la adecuación del modelo.", "As trajetórias temporais são estimativas ajustadas sem faixas de incerteza. Perfis e simulações de taxa constante não se aplicam aos ajustes variáveis. Os pesos AIC descrevem este conjunto de candidatos, não a adequação do modelo."], "Download time comparison CSV": ["Descargar comparación temporal CSV", "Baixar comparação temporal CSV"], "Download rate trajectories CSV": ["Descargar trayectorias de tasas CSV", "Baixar trajetórias de taxas CSV"], "Time-model diagnostics": ["Diagnósticos de modelos temporales", "Diagnósticos de modelos temporais"], "Tolerance_delta compares the saved likelihood with a tenfold tighter ODE tolerance. Weights are withheld above 0.0001 or on failure. Inspect all starts and boundary flags.": ["Tolerance_delta compara la verosimilitud guardada con una tolerancia ODE diez veces más estricta. No se muestran pesos si supera 0.0001 o falla. Revise todos los inicios y límites.", "Tolerance_delta compara a verossimilhança salva com uma tolerância ODE dez vezes mais estrita. Os pesos não são exibidos se superar 0.0001 ou falhar. Revise todos os inícios e limites."], "Download time optimizer CSV": ["Descargar optimizador temporal CSV", "Baixar otimizador temporal CSV"], "Select valid time-comparison models.": ["Seleccione modelos válidos para la comparación temporal.", "Selecione modelos válidos para a comparação temporal."], "Beta start must be within the positive scaled beta bound (at most 10).": ["beta inicial debe estar dentro del límite positivo escalado de beta (máximo 10).", "beta inicial deve estar dentro do limite positivo escalado de beta (máximo 10)."], "Invalid ODE solver settings.": ["Ajustes del solucionador ODE no válidos.", "Configurações do solucionador ODE inválidas."], "A time model failed; comparison weights are withheld.": ["Un modelo temporal falló; no se muestran pesos de comparación.", "Um modelo temporal falhou; os pesos de comparação não são exibidos."], "ODE tolerance sensitivity detected; comparison weights are withheld.": ["Se detectó sensibilidad a la tolerancia ODE; no se muestran pesos.", "Sensibilidade à tolerância ODE detectada; os pesos não são exibidos."], "A time-model parameter approaches a search bound; refit with reviewed bounds.": ["Un parámetro temporal se acerca a un límite de búsqueda; reajuste con límites revisados.", "Um parâmetro temporal se aproxima de um limite de busca; reajuste com limites revisados."], "Some time-model starts failed. Inspect optimizer diagnostics.": ["Algunos inicios temporales fallaron. Revise los diagnósticos del optimizador.", "Alguns inícios temporais falharam. Revise os diagnósticos do otimizador."], "Time-model starts reached different optima.": ["Los inicios temporales alcanzaron óptimos diferentes.", "Os inícios temporais atingiram ótimos diferentes."], "Compatible converged and numerically stable fits are required.": ["Se requieren ajustes compatibles, convergentes y numéricamente estables.", "São necessários ajustes compatíveis, convergentes e numericamente estáveis."], "Invalid graph parameter.": ["Parámetro del gráfico no válido.", "Parâmetro do gráfico inválido."], "Time before present (branch-length units)": ["Tiempo antes del presente (unidades de longitud de rama)", "Tempo antes do presente (unidades de comprimento de ramo)"], "Fitted rates through time": ["Tasas ajustadas a través del tiempo", "Taxas ajustadas ao longo do tempo"], "Fitted trajectories; uncertainty bands are not estimated.": ["Trayectorias ajustadas; no se estiman bandas de incertidumbre.", "Trajetórias ajustadas; faixas de incerteza não são estimadas."], "Fitting time-varying models": ["Ajustando modelos variables en el tiempo", "Ajustando modelos variáveis no tempo"], "Time-model analysis completed. Inspect diagnostics and bounds.": ["Análisis temporal completado. Revise diagnósticos y límites.", "Análise temporal concluída. Revise diagnósticos e limites."], "Time-model settings changed. Run time-varying comparison again.": ["Los ajustes temporales cambiaron. Ejecute de nuevo la comparación temporal.", "As configurações temporais mudaram. Execute novamente a comparação temporal."], "Lowest AIC among time candidates:": ["Menor AIC entre candidatos temporales:", "Menor AIC entre candidatos temporais:"]});

Object.assign(guaneTranslations,{"Time-model uncertainty and robustness": ["Incertidumbre y robustez del modelo temporal", "Incerteza e robustez do modelo temporal"], "Time model to diagnose": ["Modelo temporal para diagnosticar", "Modelo temporal para diagnosticar"], "Time-model profiles": ["Perfiles del modelo temporal", "Perfis do modelo temporal"], "Time profile grid points": ["Puntos de malla del perfil temporal", "Pontos da grade do perfil temporal"], "Conditional parametric bootstrap": ["Bootstrap paramétrico condicional", "Bootstrap paramétrico condicional"], "Bootstrap replicates": ["Réplicas bootstrap", "Réplicas bootstrap"], "Check starts, bounds and tolerance": ["Verificar inicios, límites y tolerancia", "Verificar inícios, limites e tolerância"], "Robustness bound multiplier": ["Multiplicador de límites para robustez", "Multiplicador de limites para robustez"], "Run time-model uncertainty": ["Ejecutar incertidumbre del modelo temporal", "Executar incerteza do modelo temporal"], "Time-model profile likelihood": ["Perfil de verosimilitud temporal", "Perfil de verossimilhança temporal"], "Conditional bootstrap refits": ["Reajustes bootstrap condicionales", "Reajustes bootstrap condicionais"], "Time-model robustness": ["Robustez del modelo temporal", "Robustez do modelo temporal"], "Time profiles reoptimize nuisance parameters within saved bounds. Search limits and nuisance-bound flags are not infinite intervals. Reference coverage is approximate, especially at boundaries.": ["Los perfiles temporales reoptimizan los parámetros restantes dentro de los límites guardados. Los límites de búsqueda y avisos de parámetros en límites no son intervalos infinitos. La cobertura de referencia es aproximada, especialmente en fronteras.", "Os perfis temporais reotimizam os demais parâmetros dentro dos limites salvos. Os limites de busca e avisos de parâmetros nos limites não são intervalos infinitos. A cobertura de referência é aproximada, especialmente nas fronteiras."], "Download time profile intervals CSV": ["Descargar intervalos de perfil temporal CSV", "Baixar intervalos de perfil temporal CSV"], "Download time profile curves CSV": ["Descargar curvas de perfil temporal CSV", "Baixar curvas de perfil temporal CSV"], "Bootstrap refits fix crown age, sampled tip count and sampling fraction. The pointwise 95% envelope summarizes successful conditional refits, not calibrated confidence coverage or model-selection uncertainty. Bands require at least 20 successful refits and 90% success. Inspect failures and boundary frequency.": ["Los reajustes bootstrap fijan la edad corona, el número de terminales muestreados y la fracción de muestreo. La envolvente puntual del 95% resume reajustes condicionales exitosos, no cobertura de confianza calibrada ni incertidumbre de selección de modelos. Se requieren al menos 20 reajustes exitosos y 90% de éxito. Revise fallos y frecuencia de límites.", "Os reajustes bootstrap fixam a idade da coroa, o número de terminais amostrados e a fração de amostragem. O envelope pontual de 95% resume reajustes condicionais bem-sucedidos, não cobertura de confiança calibrada nem incerteza de seleção de modelos. São necessários pelo menos 20 reajustes bem-sucedidos e 90% de sucesso. Revise falhas e frequência de limites."], "Download bootstrap refits CSV": ["Descargar reajustes bootstrap CSV", "Baixar reajustes bootstrap CSV"], "Download bootstrap bands CSV": ["Descargar bandas bootstrap CSV", "Baixar faixas bootstrap CSV"], "Robustness refits change starts, expand bounds and tighten ODE tolerance separately. A better likelihood means the original fit needs review. These scenarios do not prove a global optimum.": ["Los reajustes de robustez cambian inicios, amplían límites y reducen la tolerancia ODE por separado. Una mejor verosimilitud exige revisar el ajuste original. Estos escenarios no prueban un óptimo global.", "Os reajustes de robustez alteram inícios, ampliam limites e reduzem a tolerância ODE separadamente. Uma verossimilhança melhor exige revisar o ajuste original. Esses cenários não provam um ótimo global."], "Download robustness CSV": ["Descargar robustez CSV", "Baixar robustez CSV"], "Select a converged and numerically stable time model.": ["Seleccione un modelo temporal convergente y numéricamente estable.", "Selecione um modelo temporal convergente e numericamente estável."], "Invalid bootstrap simulation parameters.": ["Parámetros de simulación bootstrap no válidos.", "Parâmetros de simulação bootstrap inválidos."], "Bootstrap CDF integration failed.": ["Falló la integración de la distribución bootstrap.", "Falha na integração da distribuição bootstrap."], "Invalid bootstrap branching ages.": ["Edades de ramificación bootstrap no válidas.", "Idades de ramificação bootstrap inválidas."], "Invalid bootstrap settings.": ["Ajustes bootstrap no válidos.", "Configurações bootstrap inválidas."], "Bootstrap CDF grid is not accurate enough.": ["La malla de la distribución bootstrap no es suficientemente precisa.", "A grade da distribuição bootstrap não é suficientemente precisa."], "Robustness bound multiplier must be greater than one and at most four.": ["El multiplicador debe ser mayor que uno y como máximo cuatro.", "O multiplicador deve ser maior que um e no máximo quatro."], "Alternate starts": ["Inicios alternativos", "Inícios alternativos"], "Wider bounds": ["Límites ampliados", "Limites ampliados"], "Tighter tolerance": ["Tolerancia más estricta", "Tolerância mais estrita"], "Run time-model uncertainty first.": ["Ejecute primero la incertidumbre del modelo temporal.", "Execute primeiro a incerteza do modelo temporal."], "Select lambda, beta or mu with a fitted profile.": ["Seleccione lambda, beta o mu con un perfil ajustado.", "Selecione lambda, beta ou mu com um perfil ajustado."], "Run robustness checks first.": ["Ejecute primero las verificaciones de robustez.", "Execute primeiro as verificações de robustez."], "Sensitivity relative to saved fit": ["Sensibilidad respecto al ajuste guardado", "Sensibilidade em relação ao ajuste salvo"], "Bootstrap bands unavailable; inspect refit failures.": ["Bandas bootstrap no disponibles; revise fallos de reajuste.", "Faixas bootstrap indisponíveis; revise falhas de reajuste."], "Select lambda, mu or net for bootstrap curves.": ["Seleccione lambda, mu o net para curvas bootstrap.", "Selecione lambda, mu ou net para curvas bootstrap."], "Saved fit": ["Ajuste guardado", "Ajuste salvo"], "Bootstrap median": ["Mediana bootstrap", "Mediana bootstrap"], "Pointwise 95% conditional refit envelope; not calibrated coverage.": ["Envolvente puntual del 95% de reajustes condicionales; cobertura no calibrada.", "Envelope pontual de 95% dos reajustes condicionais; cobertura não calibrada."], "Time uncertainty settings changed. Run time uncertainty again.": ["Los ajustes de incertidumbre temporal cambiaron. Ejecute de nuevo la incertidumbre temporal.", "As configurações de incerteza temporal mudaram. Execute novamente a incerteza temporal."], "Computing time-model uncertainty": ["Calculando incertidumbre del modelo temporal", "Calculando incerteza do modelo temporal"], "Time uncertainty completed. Review limits, failures and robustness.": ["Incertidumbre temporal completada. Revise límites, fallos y robustez.", "Incerteza temporal concluída. Revise limites, falhas e robustez."], "Successful refits": ["Reajustes exitosos", "Reajustes bem-sucedidos"], "A robustness refit improved the likelihood; review the original fit before interpretation.": ["Un reajuste de robustez mejoró la verosimilitud; revise el ajuste original antes de interpretar.", "Um reajuste de robustez melhorou a verossimilhança; revise o ajuste original antes de interpretar."], "Some bootstrap refits failed; summaries condition on successful refits.": ["Algunos reajustes bootstrap fallaron; los resúmenes condicionan los reajustes exitosos.", "Alguns reajustes bootstrap falharam; os resumos condicionam os reajustes bem-sucedidos."], "Scenario": ["Escenario", "Cenário"], "Replicate": ["Réplica", "Réplica"], "Success": ["Éxito", "Sucesso"]});

Object.assign(guaneTranslations,{"Rates through time shows fitted trajectories. Conditional bootstrap bands are available after Run time-model uncertainty. AIC weights describe the selected candidate set, not model adequacy.": ["Tasas a través del tiempo muestra trayectorias ajustadas. Las bandas bootstrap condicionales están disponibles después de Ejecutar incertidumbre del modelo temporal. Los pesos AIC describen el conjunto seleccionado, no la adecuación del modelo.", "Taxas ao longo do tempo mostra trajetórias ajustadas. As faixas bootstrap condicionais estão disponíveis após Executar incerteza do modelo temporal. Os pesos AIC descrevem o conjunto selecionado, não a adequação do modelo."]});
