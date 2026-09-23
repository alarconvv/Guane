// Translate presentation text without rebuilding controls or discarding inputs.
const guaneTranslations = {
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
  "Pagel regression": [
    "Regresión de Pagel",
    "Regressão de Pagel"
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
  "Pagel regression: contrast two traits.": [
    "Regresión de Pagel: contrastar dos rasgos.",
    "Regressão de Pagel: contrastar duas características."
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
   if (el.closest('script,style,pre,code,#lang,[id$="-traits_table"],[id$="-taxon"],[id$="-trait"]') ||
       (el.closest('.selectize-control') && el.closest('.shiny-input-container')?.querySelector('select')?.id?.match(/-(taxon|trait)$/))) continue;
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
