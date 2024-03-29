# Simple timeline with 4 items
dataBasic <- data.frame(
  id = 1:4,
  content = c("Item one", "Item two" ,"Ranged item", "Item four"),
  start   = c("2016-01-10", "2016-01-11", "2016-01-20", "2016-02-14"),
  end    = c(NA, NA, "2016-02-04", NA)
)

dataBasic2 <- data.frame(
  id = 1:4,
  content = c("A0014-业务流程", "A0015-数据流图" ,"A0017-数据字典", "A0018-接口说明"),
  start   = c("2023-05-17 09:00:00", "2023-05-17 11:00:00", "2023-05-17 14:00:00", "2023-05-17 16:00:00"),
  end    = c("2023-05-17 11:00:00", "2023-05-17 14:00:00", "2023-05-17 16:00:00", "2023-05-17 18:00:00")
)


# Template for world cup HTML of each item
templateWC <- function(stage, team1, team2, score1, score2) {
  sprintf(
    '<table><tbody>
      <tr><td colspan="3"><em>%s</em></td></tr>
      <tr>
        <td>%s</td>
        <th>&nbsp;%s - %s&nbsp;</th>
        <td>%s</td>
      </tr>
      <tr>
        <td><img src="flags/%s.png" width="31" height="20" alt="%s"></td>
        <th></th>
        <td><img src="flags/%s.png" width="31" height="20" alt="%s"></td>
      </tr>
    </tbody></table>',
    stage, team1, score1, score2, team2, gsub("\\s", "", tolower(team1)),
    team1, gsub("\\s", "", tolower(team2)), team2
  )
}

# Data for world cup 2014
dataWC <- data.frame(
  id = 1:7,
  start = c(
    "2014-07-04 13:00",
    "2014-07-04 17:00",
    "2014-07-05 13:00",
    "2014-07-05 17:00",
    "2014-07-08 17:00",
    "2014-07-09 17:00",
    "2014-07-13 16:00"
  ),
  content = c(
    templateWC("quarter-finals", "France", "Germany", 0, 1),
    templateWC("quarter-finals", "Brazil", "Colombia", 2, 1),
    templateWC("quarter-finals", "Argentina", "Belgium", 1, 0),
    templateWC("quarter-finals", "Netherlands", "Costa Rica", "0 (4)", "0 (3)"),
    templateWC("semi-finals", "Brazil", "Germany", 1, 7),
    templateWC("semi-finals", "Netherlands", "Argentina", "0 (2)", "0 (4)"),
    templateWC("final", "Germany", "Argentina", 1, 0)
  )
)

# Data for groups example
dataGroups <- data.frame(
  id = 1:11,
  content = c("Open", "Open",
              "Open", "Open", "Half price entry",
              "Staff meeting", "Open", "Adults only", "Open", "Hot tub closes",
              "Siesta"),
  title = c("项目1的备注我想看一下有多少内容;再试一下,看一下可以显示多少内容啊", "Open",
              "Open", "Open", "Half price entry",
              "Staff meeting", "Open", "Adults only", "Open", "Hot tub closes",
              "Siesta"),
  start = c("2016-05-01 07:30:00", "2016-05-01 14:00:00",
            "2016-05-01 06:00:00", "2016-05-01 14:00:00", "2016-05-01 08:00:00",
            "2016-05-01 08:00:00", "2016-05-01 08:30:00", "2016-05-01 14:00:00",
            "2016-05-01 16:00:00", "2016-05-01 19:30:00",
            "2016-05-01 12:00:00"),
  end   = c("2016-05-01 12:00:00", "2016-05-01 20:00:00",
            "2016-05-01 12:00:00", "2016-05-01 22:00:00", "2016-05-01 10:00:00",
            "2016-05-01 08:30:00", "2016-05-01 12:00:00", "2016-05-01 16:00:00",
            "2016-05-01 20:00:00", NA,
            "2016-05-01 14:00:00"),
  group = c(rep("卢晓益", 2), rep("肖桃", 3), rep("张志", 5), '张超阳'),
  type = c(rep("range", 9), "point", "background")
)

groups <- data.frame(
  id = c("卢晓益", "肖桃", "张志","张超阳"),
  content = c("卢晓益1", "肖桃2", "张志3","张超阳4")
)



groups2 <- data.frame(
  id = c('胡立磊',
         '胡歌',
         '刘倩文',
         '刘丹',
         '张欣',
         '郑佳'
        
        
  ),
  content = c('胡立磊',
              '胡歌',
              '刘倩文',
              '刘丹',
              '张欣',
              '郑佳'
              
            
  )
)
