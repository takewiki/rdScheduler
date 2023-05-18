
source("ui-helpers.R")

fluidPage(
  title = "rdScheduler-棱星项目管理软件",
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
      div(icon("calendar"), "基本情况"),
      fluidRow(
        column(
          8,
          div(id = "interactiveActions",
              class = "optionsSection",
              tags$h4("操作列表:"),
              actionButton("fit", "显示所有报告中的项目"),
              actionButton("setWindowAnim", "显示2023-05-15 到2023-05-28期间项目(带动画)"),
              actionButton("setWindowNoAnim", "显示2023-05-15 到2023-05-28期间项目(不带动画)"),
              actionButton("center", "跳转至今天"),
              actionButton("focus2", "跳转至项目A0018"),
              actionButton("focusSelection", "聚焦至当前选择的项目"),
              actionButton("addTime", "在2023-05-21附近添加一条可移动的垂直分隔线")
           
          )
        ),
        column(4,   div(class = "optionsSection",
                        uiOutput("selectIdsOutput", inline = TRUE),
                        actionButton("selectItems", "选择项目"),
                        checkboxInput("selectFocus", "选中项目时聚焦", TRUE)
        ))
      ),
      timevisOutput("timelineBasic")
    
    ),

    tabPanel(
      div(icon("cog"), "自定义样式"),
      timevisOutput("timelineCustom")
    ),
    
    tabPanel(
      div(icon("cog"), "添加项目"),
      div(class = "optionsSection",
          textInput("addText", tags$h4("添加项目:"), "新项目"),
          dateInput("addDate", NULL, "2016-01-15"),
          actionButton("addBtn", "添加项目")
      )
    ),

    tabPanel(
      div(icon("cog"), "删除项目"),
      div(class = "optionsSection",
          uiOutput("removeIdsOutput", inline = TRUE),
          actionButton("removeItem", "删除指定项目")
      )
    ),


    tabPanel(
      div(icon("sliders"), "项目看板"),
      fluidRow(
  
        column(12,
           div(
             id = "timelinedata",
             class = "optionsSection",
             tags$h4("项目数据列表:"),
             tableOutput("table"),
             hr(),
             div(tags$strong("可见窗口范围:"),
                 textOutput("window", inline = TRUE)),
             div(tags$strong("当前选中项目的ID为:"),
                 textOutput("selected", inline = TRUE))
           )
        )
      )
    )
  )
)
