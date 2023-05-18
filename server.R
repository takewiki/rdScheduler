

source("sampleData.R")
source("utils.R")

function(input, output, session) {
  #sheet1-基本图形------
  output$timelineBasic <- renderTimevis({
    config <- list(
      editable = TRUE,
      showTooltips	=TRUE,
      align = "center",
      orientation = "both",
      snap = NULL,
      margin = list(item = 30, axis = 50)
    )

    data = rdSchedulePkg::projectData_basic()
    timevis(data,groups = groups2 ,zoomFactor = 1,options = config)
  })
  
  #自定义样式--------
  output$timelineCustom <- renderTimevis({
    config <- list(
      editable = TRUE,
      showTooltips	=TRUE,
      align = "center",
      orientation = "both",
      snap = NULL,
      margin = list(item = 30, axis = 50)
    )
    data = rdSchedulePkg::projectData_basic()
    timevis(data,groups = groups2 ,zoomFactor = 1, options = config)
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
  output$table <- renderTable({
    data <- input$timelineBasic_data
    data$start <- prettyDate(data$start)
    if(!is.null(data$end)) {
      data$end <- prettyDate(data$end)
    }
    data
  })
  #可供选择项目列表-----
  output$selectIdsOutput <- renderUI({
    selectInput("selectIds", tags$h4("可供选择项目列表:"), input$timelineBasic_ids,
                multiple = TRUE)
  })
  #可供删除的项目-----
  output$removeIdsOutput <- renderUI({
    selectInput("removeIds", tags$h4("可供删除的项目列表"), input$timelineBasic_ids)
  })
  #显示所有项目------
  observeEvent(input$fit, {
    fitWindow("timelineBasic")
  })
  #显示指定时间范围内的窗口，带动画------
  observeEvent(input$setWindowAnim, {
    setWindow("timelineBasic", "2023-05-15", "2023-05-28")
  })
  #显示指定时间范围内的窗口，不带动画-------
  observeEvent(input$setWindowNoAnim, {
    setWindow("timelineBasic", "2023-05-15", "2023-05-28",
              options = list(animation = FALSE))
  })
  #跳转到指定日期的项目--------
  observeEvent(input$center, {
    centerTime("timelineBasic", tsdo::getDate())
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
                 options = list(focus = input$selectFocus))
  })
  #添加项目------
  observeEvent(input$addBtn, {
    addItem("timelineBasic",
            data = list(id = randomID(),
                        content = input$addText,
                        start = input$addDate))
  })
  #
  observeEvent(input$removeItem, {
    removeItem("timelineBasic", input$removeIds)
  })

}
