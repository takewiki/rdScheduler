

source("sampleData.R")
source("utils.R")

function(input, output, session) {
  #sheet1-基本图形------
  output$timelineBasic <- renderTimevis({

    data = rdSchedulePkg::projectData_basic()
    timevis(data)
  })
  
  #自定义样式--------
  output$timelineCustom <- renderTimevis({
    config <- list(
      editable = TRUE,
      align = "center",
      orientation = "top",
      snap = NULL,
      margin = list(item = 30, axis = 50)
    )
    timevis(dataBasic, zoomFactor = 1, options = config)
  })
  
  
  #世界杯----
  output$timelineWC <- renderTimevis({
    timevis(dataWC)
  })

  output$timelineGroups <- renderTimevis({
    timevis(data = dataGroups, groups = groups, options = list(editable = TRUE,showTooltips	=TRUE))
  })


  output$timelineInteractive1 <- renderTimevis({
    config <- list(
      editable = TRUE,
      multiselect = TRUE
    )
    timevis(dataBasic, options = config)
  })

  output$selected <- renderText(
    paste(input$timelineInteractive1_selected, collapse = " ")
  )
  output$window <- renderText(
    paste(prettyDate(input$timelineInteractive1_window[1]),
          "to",
          prettyDate(input$timelineInteractive1_window[2]))
  )
  
  #项目数据列表-------
  output$table <- renderTable({
    data <- input$timelineInteractive1_data
    data$start <- prettyDate(data$start)
    if(!is.null(data$end)) {
      data$end <- prettyDate(data$end)
    }
    data
  })
  #可供选择项目列表-----
  output$selectIdsOutput <- renderUI({
    selectInput("selectIds", tags$h4("可供选择项目列表:"), input$timelineInteractive1_ids,
                multiple = TRUE)
  })
  #可供删除的项目-----
  output$removeIdsOutput <- renderUI({
    selectInput("removeIds", tags$h4("可供删除的项目列表"), input$timelineInteractive1_ids)
  })
  #显示所有项目------
  observeEvent(input$fit, {
    fitWindow("timelineInteractive1")
  })
  #显示指定时间范围内的窗口，带动画------
  observeEvent(input$setWindowAnim, {
    setWindow("timelineInteractive1", "2016-01-07", "2016-01-25")
  })
  #显示指定时间范围内的窗口，不带动画-------
  observeEvent(input$setWindowNoAnim, {
    setWindow("timelineInteractive1", "2016-01-07", "2016-01-25",
              options = list(animation = FALSE))
  })
  #跳转到指定日期的项目--------
  observeEvent(input$center, {
    centerTime("timelineInteractive1", "2016-01-23")
  })
  #跳转至指定ID的项目，也相当于按ID号进行了搜索-----
  observeEvent(input$focus2, {
    centerItem("timelineInteractive1", 4)
  })
  #跳转到已指定的项目，通过选择器进行选择或鼠标进行选择------
  observeEvent(input$focusSelection, {
    centerItem("timelineInteractive1", input$timelineInteractive1_selected)
  })
  #在2016-01-17附近添加一条可移动的垂直分隔线-----
  observeEvent(input$addTime, {
    addCustomTime("timelineInteractive1", "2016-01-17", randomID())
  })
  #选中项目，当选中时自动聚焦----------
  observeEvent(input$selectItems, {
    setSelection("timelineInteractive1", input$selectIds,
                 options = list(focus = input$selectFocus))
  })
  #添加项目------
  observeEvent(input$addBtn, {
    addItem("timelineInteractive1",
            data = list(id = randomID(),
                        content = input$addText,
                        start = input$addDate))
  })
  #
  observeEvent(input$removeItem, {
    removeItem("timelineInteractive1", input$removeIds)
  })

}
