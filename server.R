

source("sampleData.R")
source("utils.R")

function(input, output, session) {
  #添加自动舒心控制
  auto_refresh <- reactiveTimer(60000,session = session)
  #sheet1-基本图形------
  output$timelineBasic <- renderTimevis({
    
    auto_refresh()
    config <- list(
      editable = TRUE,
      showTooltips	=TRUE,
      align = "center",
      orientation = "both",
      snap = NULL,
      margin = list(item = 30, axis = 50)
    )

    data = rdSchedulePkg::data_query(status = 'open')
    timevis(data,groups = groups2 ,zoomFactor = 1,options = config,fit = FALSE)
    #
  })
  #centerTime("timelineBasic", tsdo::getTime())
  
  #逾期中--------
  output$timelineCustom <- renderTimevis({
    #设置自动更新
    config <- list(
      editable = TRUE,
      showTooltips	=TRUE,
      align = "center",
      orientation = "both",
      snap = NULL,
      margin = list(item = 30, axis = 50)
    )
    data = rdSchedulePkg::data_overDue()
    #data = rdSchedulePkg::data_query(status = 'close')
    timevis(data,groups = groups2 ,zoomFactor = 1, options = config,fit = FALSE)
  })
  
  #已完成
  output$timelineFinished <- renderTimevis({
    config <- list(
      editable = TRUE,
      showTooltips	=TRUE,
      align = "center",
      orientation = "both",
      snap = NULL,
      margin = list(item = 30, axis = 50)
    )
    
    #data = rdSchedulePkg::data_overDue()
    data = rdSchedulePkg::data_query(status = 'close')
    timevis(data,groups = groups2 ,zoomFactor = 1,options = config)
  })
  

  


  output$timelineGroups <- renderTimevis({
    timevis(data = dataGroups, groups = groups, options = list(editable = TRUE,showTooltips	=TRUE))
  })




  output$selected <- renderText(
    paste(input$timelineBasic_selected, collapse = " ")
  )
  output$window <- renderText(
    paste(prettyDate(input$timelineBasic_window[1]),
          "至",
          prettyDate(input$timelineBasic_window[2]))
  )
  
  #项目数据列表-------
  output$table_open <- renderTable({
    data <- input$timelineBasic_data
    data$start <- prettyDate(data$start)
    start
    if(!is.null(data$end)) {
      data$end <- prettyDate(data$end)
    }
    print(str(data))
   
   
    data
  })
  output$table_overDue <- renderTable({
    data <- input$timelineCustom_data
    data$start <- prettyDate(data$start)
    if(!is.null(data$end)) {
      data$end <- prettyDate(data$end)
    }
    data
  })
  output$table_close <- renderTable({
    data <- input$timelineFinished_data
    data$start <- prettyDate(data$start)
    if(!is.null(data$end)) {
      data$end <- prettyDate(data$end)
    }
    data
  })
  #可供选择项目列表-----
  output$selectIdsOutput <- renderUI({
    selectInput("selectIds", tags$h4("执行中任务列表:"), input$timelineBasic_ids,
                multiple = FALSE)
  })
  #可供删除的项目-----
  output$removeIdsOutput <- renderUI({
    selectInput("removeIds", tags$h4("可供删除的项目列表"), input$timelineBasic_ids)
  })
  
  #设置任务已完成--------
  observeEvent(input$setTaskDone,{
    #直接使用列表进行选择,更准确一点---
    id = input$selectIds
    #print(id)
    start =as.character(input$taskClose_startDate)
    
    #print(as.character(input$taskClose_startDate))
    end = as.character(input$taskClose_endDate)
    # print(as.character(input$taskClose_endDate))
    note = input$taskClose_note
    # print(input$taskClose_note)
     rdSchedulePkg::task_close(FId = id,FStart = start,FEnd = end,FNote = note)
     #更新处理中的状态,包括处理中及逾期部分
     removeItem("timelineBasic", id)
     try(removeItem("timelineCustom", id))
     #更新所有项目窗口
     fitWindow("timelineBasic")
     fitWindow("timelineCustom")
     #通知用户
     tsui::pop_notice(paste0(id,"汇报完成,数据已更新！"))
   
    
  })
  #显示所有项目------
  observeEvent(input$fit, {
    fitWindow("timelineBasic")
  })
  #显示指定时间范围内的窗口，带动画------
  open_dates = tsui::var_dateRange('open_dateRange')
  observeEvent(input$setWindowAnim, {
    dates = open_dates()
    setWindow("timelineBasic", dates[1], dates[2])
  })
  #显示指定时间范围内的窗口，不带动画-------
  observeEvent(input$setWindowNoAnim, {
    setWindow("timelineBasic", "2023-05-15", "2023-05-28",
              options = list(animation = FALSE))
  })
  #跳转到指定日期的项目--------
  observeEvent(input$center, {
    #auto_refresh()
    centerTime("timelineBasic", tsdo::getTime())
  })
  #跳转至指定ID的项目，也相当于按ID号进行了搜索-----
  observeEvent(input$focus2, {
    centerItem("timelineBasic", 'A0018')
  })
  #跳转到已指定的项目，通过选择器进行选择或鼠标进行选择------
  observeEvent(input$focusSelection, {
    centerItem("timelineBasic", input$timelineBasic_selected)
  })
  #在2016-01-17附近添加一条可移动的垂直分隔线-----
  observeEvent(input$addTime, {
    addCustomTime("timelineBasic", "2023-05-21", randomID())
  })
  #选中项目，当选中时自动聚焦----------
  observeEvent(input$selectItems, {
    setSelection("timelineBasic", input$selectIds,
                 options = list(focus = TRUE))
  })
  #添加项目------
  observeEvent(input$addBtn, {
    addItem("timelineBasic",
            data = list(id = randomID(),
                        content = input$addText,
                        start = input$addDate))
  })
  #删除项目
  observeEvent(input$removeItem, {
    removeItem("timelineBasic", input$removeIds)
  })
  
  #上传WBS任务数据
  var_file_wbs = tsui::var_file('file_wbs')
  
  observeEvent(input$btn_task_wbs_preview,{
    #预览数据
    file_name = var_file_wbs()
    #print(file_name)
    if(is.null(file_name)){
      tsui::pop_notice('请选择一个WBS节点任务的Excel文件进行上传!')
    }else{
      data = rdSchedulePkg::data_read(file_name = file_name,type = 'WBS')
      tsui::run_dataTable2(id = 'dt_task_wbs',data = data)
    }

    
  })
  observeEvent(input$btn_task_wbs_upload,{
    #上传数据
    file_name = var_file_wbs()
    if(is.null(file_name)){
      tsui::pop_notice('请选择一个WBS节点任务的Excel文件进行上传!')
    }else{
      tryCatch({
        rdSchedulePkg::data_upload(file_name = file_name ,type = 'WBS')
        tsui::pop_notice(msg = 'WBS新任务上传完成')
      }
        
       ,error = function(e){
         tsui::pop_notice(paste0("数据库写入发生错误,详细错误描述如下:\n",e$message))
       }
               )
    
   
    }
    
    
  })
  
  
  #上传QA任务数据
  var_file_qa = tsui::var_file('file_qa')
  
  observeEvent(input$btn_task_qa_preview,{
    #预览数据
    file_name = var_file_qa()
    #print(file_name)
    if(is.null(file_name)){
      tsui::pop_notice('请选择一个QA节点任务的Excel文件进行上传!')
    }else{
      data = rdSchedulePkg::data_read(file_name = file_name,type = 'QA')
      tsui::run_dataTable2(id = 'dt_task_qa',data = data)
    }
    
    
  })
  observeEvent(input$btn_task_qa_upload,{
    #上传数据
    file_name = var_file_qa()
    if(is.null(file_name)){
      tsui::pop_notice('请选择一个QA节点任务的Excel文件进行上传!')
    }else{
      tryCatch({
        rdSchedulePkg::data_upload(file_name = file_name,type = 'QA' )
        tsui::pop_notice(msg = 'QA新任务上传完成')
      }
      
      ,error = function(e){
        tsui::pop_notice(paste0("数据库写入发生错误,详细错误描述如下:\n",e$message))
      }
      )
      
      
    }
    
    
  })
  
  #返回相关值WBS----
  observeEvent(input$btn_wbs_getMaxNumber,{
    output$txt_wbs_getMaxNumber <- renderText({
      rdSchedulePkg::taskId_NextValue(type = 'WBS')
    })
  })
  
  observeEvent(input$btn_qa_getMaxNumber,{
    output$txt_qa_getMaxNumber <- renderText({
      rdSchedulePkg::taskId_NextValue(type = 'QA')
    })
  })

}
