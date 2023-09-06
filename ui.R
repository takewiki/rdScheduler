
source("ui-helpers.R")

fluidPage(
  title = "rdScheduler-棱星项目管理软件",tsui::use_pop(),
  tags$head(
    tags$link(href = "style.css", rel = "stylesheet")


  ),
  tags$a(
    href="https://github.com/takewiki/rdScheduler",
    tags$img(style="position: absolute; top: 0; right: 0; border: 0;",
             src="github-orange-right.png",
             alt="Fork me on GitHub")
  ),
  div(id = "header",
    div(id = "title",
      "rdScheduler-棱星项目排产管理软件"
    )
  ),
  tabsetPanel(
    id = "mainnav",
    tabPanel(
      div(icon("calendar"), "处理中"),
      
        fluidRow(column(2,     dropdownButton(
          inputId = "opt_global",
          label = '查看选项',
          icon = icon("cog"),
          status = "primary",
          circle = FALSE,
          tsui::mdl_dateRange(id = 'open_dateRange',label = '请选择时间范围'),
          fluidRow(column(6,actionButton("fit", "所有任务")),
                   column(6, actionButton("setWindowAnim", "期间任务"))),
          br(),
          hr(),
          fluidRow(column(6,actionButton("center", "今天任务")),column(6,NULL))
        )),column(2   ,  dropdownButton(
          inputId = "opt_close_normal",
          label = '任务汇报',
          icon = icon("cog"),
          status = "primary",
          circle = FALSE,
          uiOutput("selectIdsOutput", inline = TRUE),
          br(),
          tsui::mdl_ListChoose1(id = 'taskRptStaus',label = '任务状态',choiceNames = list('进行中','已完成'),choiceValues = list('open','close'),selected = 'open'),
    
          shinyDatetimePickers::datetimeMaterialPickerInput(inputId = 'taskClose_startDate',label = '实际开始时间',value = tsdo::getTime_offSet(offset = -60*60*2,timeZone = 8),disableFuture = T),
          br(),
          shinyDatetimePickers::datetimeMaterialPickerInput(inputId = 'taskClose_endDate',label = '实际完成时间',value = tsdo::getTime_offSet(timeZone = 8),disableFuture = T),
          br(),
          textAreaInput('taskClose_note',label = '任务完成情况说明',value = '正常完成',rows = 4,cols = 50),
          tsui::layout_2C(x =shinyWidgets::actionBttn("selectItems", "查看任务") ,
                          y = shinyWidgets::actionBttn("setTaskDone", "汇报任务") )
          
         
        
        )),
        column(2,dropdownButton(inputId = 'opt_task_change',label = '任务变更',icon = icon('cog'),status = 'primary',circle = FALSE,
                                tags$h4('任务时间变更'),
                                tsui::mdl_password(id = 'taskChange_password',label = '请输入管理员密码'),
                                uiOutput("selectIdsOutput_change", inline = TRUE),
                                shinyDatetimePickers::datetimeMaterialPickerInput(inputId = 'taskChange_endDate',label = '变更后完成时间',value = tsdo::getTime_offSet(timeZone = 8),disablePast = TRUE),
                                br(),
                                textAreaInput('taskChange_note',label = '任务变更说明',value = '请填写变更原因:',rows = 4,cols = 50),
                                br(),
                                shinyWidgets::actionBttn(inputId = 'taskchange_setEndDate',label = '变更完成时间')
                                
                      
                                
                                )
               ),
        column(6,NULL)),
   
   
   
      
     

      timevisOutput("timelineBasic")

    
    
    ),
    tabPanel(
      div(icon("sliders"), "数据列表-处理中"),
      fluidRow(
        
        column(12,
               div(
                 id = "timelinedata",
                 class = "optionsSection",
                 tags$h4("项目数据列表:"),
                 tableOutput("table_open"),
                 hr(),
                 div(tags$strong("可见窗口范围:"),
                     textOutput("window_open", inline = TRUE)),
                 div(tags$strong("当前选中项目的ID为:"),
                     textOutput("open_selected", inline = TRUE))
               )
        )
      )
    ),

    tabPanel(
      div(icon("calendar"), "已逾期"),
      timevisOutput("timelineCustom")
    ),
    tabPanel(
      div(icon("sliders"), "数据列表-已逾期"),
      fluidRow(
        
        column(12,
               div(
                 id = "timelinedata",
                 class = "optionsSection",
                 tags$h4("项目数据列表:"),
                 tableOutput("table_overDue"),
                 hr(),
                 div(tags$strong("可见窗口范围:"),
                     textOutput("window_overDue", inline = TRUE)),
                 div(tags$strong("当前选中项目的ID为:"),
                     textOutput("overDue_selected", inline = TRUE))
               )
        )
      )
    ),
    tabPanel(
      div(icon("calendar"), "已完成"),
      timevisOutput("timelineFinished")
    ),
    tabPanel(
      div(icon("sliders"), "数据列表-已完成"),
      fluidRow(
        
        column(12,
               div(
                 id = "timelinedata",
                 class = "optionsSection",
                 tags$h4("项目数据列表:"),
                 tableOutput("table_close"),
                 hr(),
                 div(tags$strong("可见窗口范围:"),
                     textOutput("window_close", inline = TRUE)),
                 div(tags$strong("当前选中项目的ID为:"),
                     textOutput("close_selected", inline = TRUE))
               )
        )
      )
    ),
    
    tabPanel(
      div(icon("sliders"), "添加任务-WBS类"),
      div(class = "optionsSection",
          fluidRow(column(4, tsui::uiTemplate('dataWBS'),
                          h4('请下载以上WBS类任务上传模板,参照前3行示例整理数据'),
                          shinyWidgets::actionBttn(inputId = 'btn_wbs_getMaxNumber',label = '获取最新WBS任务ID'),
                          verbatimTextOutput('txt_wbs_getMaxNumber'),
                          h4('请以上述编码作为您新增的第1个任务ID,逐行+1进行编码'),
                          h4('记得删除前3行的示例数据,系统也将自动删除'),
                          tsui::mdl_file(id = 'file_wbs',label = '选择WBS文件'),
                          actionButton("btn_task_wbs_preview", "预览WBS任务数据"),
                          actionButton("btn_task_wbs_upload", "上传WBS任务数据")),
                   column(8, tsui::uiScrollX(tsui::mdl_dataTable('dt_task_wbs'))))
        
         
      )
    ),

    
    tabPanel(
      div(icon("sliders"), "添加任务-QA类"),
      div(class = "optionsSection",
          fluidRow(column(4, tsui::uiTemplate('dataQA'),
                          h4('请下载以上QA类任务上传模板,参照前3行示例整理数据'),
                          shinyWidgets::actionBttn(inputId = 'btn_qa_getMaxNumber',label = '获取最新QA任务ID'),
                          verbatimTextOutput('txt_qa_getMaxNumber'),
                          h4('请以上述编码作为您新增的第1个任务ID,逐行+1进行编码'),
                          h4('记得删除前3行的示例数据,系统也将自动删除'),
                          tsui::mdl_file(id = 'file_qa',label = '选择QA文件'),
                          actionButton("btn_task_qa_preview", "预览QA任务数据"),
                          actionButton("btn_task_qa_upload", "上传QA任务数据"),
                          ),
                   column(8,tsui::uiScrollX(tsui::mdl_dataTable('dt_task_qa'))))
         
      )
    ),
    tabPanel(
      div(icon("sliders"), "工作日报"),
      div(class = "optionsSection",
          fluidRow(column(3, h4('查询当天的日报数据,请及时查询及下载'),
                          actionButton("btn_task_dailyRpt_query", "查询日报"),
                          tsui::mdl_download_button(id = 'btn_task_dailyRpt_dl',label = '下载日报')
          ),
          column(9,tsui::uiScrollX(tsui::mdl_dataTable('dt_task_dailyRpt_dataView'))))
          
      )
    )
    
    # tabPanel(
    #   div(icon("cog"), "删除项目"),
    #   div(class = "optionsSection",
    #       uiOutput("removeIdsOutput", inline = TRUE),
    #       actionButton("removeItem", "删除指定项目")
    #   )
    # ),


   
  

  )
)
