
source("ui-helpers.R")

fluidPage(
  title = "rdScheduler-棱星项目管理软件",
  tags$head(
    tags$link(href = "style.css", rel = "stylesheet"),

 
    # Facebook OpenGraph tags
    tags$meta(property = "og:title", content = 'rdScheduler-棱星项目管理软件'),
    tags$meta(property = "og:type", content = "website"),
    tags$meta(property = "og:url", content = share$url),
    tags$meta(property = "og:image", content = share$image),
    tags$meta(property = "og:description", content = share$description),

    # Twitter summary cards
    tags$meta(name = "twitter:card", content = "summary"),
    tags$meta(name = "twitter:site", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:creator", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:title", content = share$title),
    tags$meta(name = "twitter:description", content = share$description),
    tags$meta(name = "twitter:image", content = share$image)
  ),
  tags$a(
    href="https://github.com/takewiki/rdScheduler",
    tags$img(style="position: absolute; top: 0; right: 0; border: 0;",
             src="github-orange-right.png",
             alt="Fork me on GitHub")
  ),
  div(id = "header",
    div(id = "title",
      "rdScheduler"
    ),
    div(id = "subtitle",
        "棱星项目管理排产软件"),
    div(id = "subsubtitle",
        "Copyright @2023 By ",
        tags$a(href = "http://reshapedata.com/", "上海棱星数据技术有限公司"),
        HTML("&bull;")
    )
  ),
  tabsetPanel(
    id = "mainnav",
    tabPanel(
      div(icon("calendar"), "基本情况"),
      timevisOutput("timelineBasic")
    ),

    tabPanel(
      div(icon("cog"), "自定义样式"),
      timevisOutput("timelineCustom")
    ),

    tabPanel(
      div(icon("trophy"), "世界杯"),
      timevisOutput("timelineWC")
    ),

    tabPanel(
      div(icon("users"), "分组"),
      timevisOutput("timelineGroups")
    ),

    tabPanel(
      div(icon("sliders"), "项目看板"),
      fluidRow(
        column(
          8,
          fluidRow(column(12,
            timevisOutput("timelineInteractive1")
          )),
          fluidRow(
            column(
              12,
              div(id = "interactiveActions",
                  class = "optionsSection",
                  tags$h4("操作列表:"),
                  actionButton("fit", "显示所有项目"),
                  actionButton("setWindowAnim", "显示2016-01-07 到2016-01-25期间项目(带动画)"),
                  actionButton("setWindowNoAnim", "显示2016-01-07 到2016-01-25期间项目(不带动画)"),
                  actionButton("center", "跳转至2016-01-23"),
                  actionButton("focus2", "跳转至项目4"),
                  actionButton("focusSelection", "聚焦至当前选择的项目"),
                  actionButton("addTime", "在2016-01-17附近添加一条可移动的垂直分隔线")
              )
            )
          ),
          fluidRow(
            column(
              4,
              div(class = "optionsSection",
                  uiOutput("selectIdsOutput", inline = TRUE),
                  actionButton("selectItems", "选择项目"),
                  checkboxInput("selectFocus", "选中项目时聚焦", FALSE)
              )
            ),
            column(
              4,
              div(class = "optionsSection",
                  textInput("addText", tags$h4("添加项目:"), "新项目"),
                  dateInput("addDate", NULL, "2016-01-15"),
                  actionButton("addBtn", "添加项目")
              )
            ),
            column(
              4,
              div(class = "optionsSection",
                  uiOutput("removeIdsOutput", inline = TRUE),
                  actionButton("removeItem", "删除指定项目")
              )
            )
          )
        ),
        column(4,
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