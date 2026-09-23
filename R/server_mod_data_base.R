server_mod_data_base <- function(input, output, session, lang=function() 'en') {
    state <- reactiveValues(log=data.frame(Time=character(),Action=character()),original=list(tree=NULL,traits=NULL),undo=list(),steps=list(),checks=NULL,tree=NULL,traits=NULL,activity='Load your files or explore the example dataset.')
    record <- function(message) {
      state$log <- rbind(state$log, data.frame(Time=format(Sys.time(), '%Y-%m-%d %H:%M:%S'),Action=message))
    }
    snapshot <- function(action) {
      state$undo<-append(state$undo,list(list(tree=state$tree,traits=state$traits,steps=state$steps,action=action)))
      record(action)
    }
    observeEvent(input$undo_data,{
      if(!length(state$undo)) {showNotification('No data changes to undo.');return()}
      previous<-tail(state$undo,1)[[1]]
      state$undo<-head(state$undo,-1)
      state$steps<-previous$steps;state$tree<-previous$tree;state$traits<-previous$traits;refresh()
      record(paste('Undo:',previous$action))
    })
    observeEvent(input$restore_data,{
      snapshot('Restore original inputs')
      state$steps<-append(state$steps,list(c('# Restore original inputs',guane_r_assignment('tree',state$original$tree),guane_r_assignment('traits',state$original$traits))))
      state$tree<-state$original$tree;state$traits<-state$original$traits;refresh()
    })
    observeEvent(list(input$taxon,input$trait),{record(paste('Selected taxon column:',input$taxon,'; trait:',input$trait))},ignoreInit=TRUE)
    observeEvent(state$activity,{record(state$activity)},ignoreInit=FALSE)
    output$history <- renderTable(state$log)
    output$log_download <- downloadHandler('guane-diagnosis.csv',function(file) write.csv(state$log,file,row.names=FALSE))
    output$preparation_script<-downloadHandler('guane-preparation.R',function(file) writeLines(guane_preparation_script(state$steps),file))
    output$checks <- renderPrint({x<-state$checks;if(inherits(x,'htest')) {cat(guane_text('Shapiro-Wilk normality test',lang()),'\n');cat('W =',unname(x$statistic),'; p =',x$p.value,'\n');cat(guane_text('Trait normality does not establish model residual normality.',lang()))} else print(x)})
    observeEvent(input$normality,{attempt({req(state$traits,input$trait);x<-state$traits[[input$trait]]
      state$checks <- guane_normality(x);record(paste('Shapiro-Wilk test:',input$trait))
    })})
    observeEvent(input$transform,{attempt({req(state$traits,input$trait,input$transformation)
      name<-input$trait
      transformed<-guane_transform(state$traits,name,input$transformation)
      dest<-transformed$column;snapshot(paste('Transform:',name,'->',dest,'method:',input$transformation));state$steps<-append(state$steps,list(sprintf('traits[[%s]] <- %s',deparse(dest),switch(input$transformation,log=sprintf('log(traits[[%s]])',deparse(name)),exp=sprintf('exp(traits[[%s]])',deparse(name)),quadratic=sprintf('traits[[%s]]^2',deparse(name)),reciprocal=sprintf('1/traits[[%s]]',deparse(name))))));state$traits<-transformed$traits;refresh(dest);state$checks<-NULL
      state$activity<-paste('Created',dest,'from',name,'using',input$transformation,'; original column preserved.')
    })})
    observeEvent(input$pic,{attempt({req(state$tree,state$traits,input$trait,input$taxon)
      state$checks<-guane_pic(state$tree,state$traits,input$taxon,input$trait)
      record(paste('Computed ape::pic for',input$trait,'; contrasts retained separately from species data.'))
    })})
    refresh <- function(distribution_column=NULL) {
      cols <- names(state$traits)
      updateSelectInput(session,'taxon',choices=cols,selected=cols[1])
      numeric <- cols[vapply(state$traits,is.numeric,logical(1))]
      updateSelectInput(session,'trait',choices=numeric,selected=numeric[1])
      selected<-if(!is.null(distribution_column)) distribution_column else if(!is.null(input$dist_column) && input$dist_column %in% numeric) input$dist_column else numeric[1]
      updateSelectInput(session,'dist_column',choices=numeric,selected=selected)
    }
    attempt <- function(expr) tryCatch(withCallingHandlers(expr,warning=function(w) {record(paste('Warning:',conditionMessage(w)));showNotification(conditionMessage(w),type='warning');invokeRestart('muffleWarning')}),error=function(e) {state$activity <- conditionMessage(e); showNotification(conditionMessage(e),type='error')})
    observeEvent(input$example,{d <- guane_example();state$original<-d;state$steps<-list(guane_r_assignment('tree',d$tree),guane_r_assignment('traits',d$traits));state$undo<-list();record('Loaded example inputs; undo history restarted.');state$tree <- d$tree;state$traits <- d$traits;refresh();state$activity <- 'Synthetic example loaded: 20 tree tips, 19 trait rows. Review the intentional Sp20 mismatch in Checking data.'})
    observeEvent(input$tree_file,{attempt({
      tree<-guane_read_tree(input$tree_file$datapath)
      state$steps<-append(state$steps,list(guane_r_assignment('tree',tree)));state$original$tree<-tree;state$tree<-tree;state$undo<-list()
      record(paste('Loaded tree:',input$tree_file$name,'; undo history restarted.'))
      state$activity<-'Tree loaded.'
    })})
    observeEvent(input$traits_file,{attempt({
      traits<-read.csv(input$traits_file$datapath,check.names=FALSE)
      state$steps<-append(state$steps,list(guane_r_assignment('traits',traits)));state$original$traits<-traits;state$traits<-traits;state$undo<-list();refresh()
      record(paste('Loaded traits:',input$traits_file$name,'; undo history restarted.'))
      state$activity<-'Trait table loaded.'
    })})
    issues <- reactive(guane_validate(state$tree,state$traits,input$taxon,input$trait))
    observeEvent(list(state$tree,state$traits,input$taxon,input$trait,input$seed),{state$checks <- NULL},ignoreInit=TRUE)
    observeEvent(input$match,{req(state$tree,state$traits,input$taxon);attempt({
      ids <- as.character(state$traits[[input$taxon]])
      if(anyDuplicated(ids) || anyNA(ids)) stop('Correct duplicate or missing taxon labels before matching.')
      keep <- intersect(state$tree$tip.label,ids)
      if(length(keep)<4) stop('Fewer than four taxa overlap; upload compatible data.')
      removed <- length(setdiff(state$tree$tip.label,keep))+sum(!ids %in% keep)
      matched_tree<-ape::keep.tip(state$tree,keep)
      snapshot(paste('Match taxa; tree exclusions:',paste(setdiff(state$tree$tip.label,keep),collapse=', '),'; table exclusions:',paste(setdiff(ids,keep),collapse=', ')))
      state$steps<-append(state$steps,list(c(guane_r_assignment('keep',keep),'tree <- ape::keep.tip(tree, keep)',sprintf('traits <- traits[as.character(traits[[%s]]) %%in%% keep, , drop=FALSE]',deparse(input$taxon)))))
      state$tree <- matched_tree;state$traits <- state$traits[ids %in% keep,,drop=FALSE]
      state$activity <- paste('User requested matching;',removed,'unmatched entries removed. Export the standardized inputs with your script.')
    })})
    observeEvent(input$reset,{snapshot('Reset workspace');state$steps<-append(state$steps,list('tree <- NULL; traits <- NULL'));state$tree<-NULL;state$traits<-NULL;refresh();state$activity<-'Workspace reset. Load new files or example data.'})
    output$activity <- renderText(state$activity)
    output$diagnostics <- renderUI({d<-issues();if(!nrow(d)) return(div(class='success','✓ All checks passed. Ready for signal analysis.'));tagList(lapply(seq_len(nrow(d)),function(i) div(class=paste('issue',tolower(d$level[i])),strong(paste0(d$level[i],': ')),d$message[i])))})
    output$structure <- renderUI({if(is.null(state$tree)) return(p(class='muted','No tree loaded'));tagList(div(class='stat',strong(length(state$tree$tip.label)),span('TREE TIPS')),div(class='stat',strong(if(is.null(state$traits)) 0 else nrow(state$traits)),span('TRAIT ROWS')),p(if(ape::is.rooted(state$tree)) 'Rooted tree' else 'Unrooted tree'),p(paste('Internal nodes:',state$tree$Nnode)),p(if(ape::is.binary(state$tree)) 'Bifurcating tree' else 'Tree contains polytomies'),p(if(!is.null(state$tree$edge.length) && ape::is.ultrametric(state$tree)) 'Ultrametric tree' else 'Not ultrametric'),downloadButton(session$ns('data_tree_export'),'Export tree'))})
    draw <- function() guane_plot_tree(state$tree,input$layout,input$direction,input$lengths,input$labels,input$font,input$edge,input$nodes,lang())
    output$tree_plot <- renderPlot({draw()},res=110)
    output$tree_script<-downloadHandler('guane-tree-graph.R',function(file){req(state$tree);writeLines(guane_data_plot_script('tree',list(tree=state$tree,layout=input$layout,direction=input$direction,lengths=input$lengths,labels=input$labels,font=input$font,edge=input$edge,nodes=input$nodes,lang=lang())),file)})

    distribution_values<-reactive({req(state$traits,input$dist_column);req(input$dist_column %in% names(state$traits));state$traits[[input$dist_column]]})
    draw_distribution<-function() guane_plot_distribution(distribution_values(),
      if(is.null(input$dist_type)) 'hist' else input$dist_type,
      if(is.null(input$dist_bins)) 15 else input$dist_bins,isTRUE(input$dist_rug),input$dist_column,lang())
    output$distribution<-renderPlot({draw_distribution()},res=110)
    output$distribution_script<-downloadHandler('guane-distribution-graph.R',function(file){writeLines(guane_data_plot_script('distribution',list(x=distribution_values(),type=if(is.null(input$dist_type)) 'hist' else input$dist_type,bins=if(is.null(input$dist_bins)) 15 else input$dist_bins,rug=isTRUE(input$dist_rug),label=input$dist_column,lang=lang())),file)})

    output$distribution_note<-renderText({d<-guane_distribution(distribution_values());paste('Displayed observations:',length(d$values),'; nonfinite values excluded from plot:',d$excluded)})
    output$dist_export<-downloadHandler('guane-distribution.pdf',function(file){req(state$traits,input$dist_column);pdf(file,width=8,height=6);on.exit(dev.off());draw_distribution()})
    output$traits_table <- renderTable({req(state$traits);head(state$traits,if(is.null(input$rows)) 25 else max(1,min(1000,input$rows)))},rownames=FALSE)
    output$data_tree_export <- downloadHandler('guane-tree.nwk',function(file){req(state$tree);ape::write.tree(state$tree,file)})
    output$traits_download <- downloadHandler('guane-traits.csv',function(file){req(state$traits);write.csv(state$traits,file,row.names=FALSE)})
    output$plot_download <- downloadHandler('guane-tree.pdf',function(file){req(state$tree);pdf(file,width=10,height=7);on.exit(dev.off());draw()})
  list(lang=lang, state=state, record=record, attempt=attempt,
       taxon=shiny::reactive(input$taxon), trait=shiny::reactive(input$trait), seed=shiny::reactive(input$seed))
}
