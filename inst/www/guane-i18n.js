// Translate presentation text without rebuilding controls or discarding inputs.
// Shared with R's guane_text(): inst/i18n/translations.json, embedded by app_ui().
const guaneTranslations = JSON.parse(document.getElementById('guane-translations').textContent);
// Own-property lookup: data such as "constructor" or "__proto__" is never translated.
function guaneLookup(key) { return Object.prototype.hasOwnProperty.call(guaneTranslations, key) ? guaneTranslations[key] : null; }
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
   const entry=guaneLookup(saved.key) || dynamicTranslation(saved.key); if(!entry) continue;
   const next=lang==='es'?entry[0]:lang==='pt'?entry[1]:saved.key;
   if(current!==next) node.textContent=node.textContent.replace(current,next);
   originals.set(node,{key:saved.key,last:next});
  }
  document.querySelectorAll('input[placeholder]').forEach(el=>{
   if(!el.dataset.originalPlaceholder) el.dataset.originalPlaceholder=el.placeholder;
   const key=el.dataset.originalPlaceholder,entry=guaneLookup(key);
   if(entry) el.placeholder=lang==='es'?entry[0]:lang==='pt'?entry[1]:key;
  });
 }
 new MutationObserver(translate).observe(document.body,{childList:true,subtree:true,characterData:true});
 document.getElementById('lang').addEventListener('change',translate);
 translate();
});
