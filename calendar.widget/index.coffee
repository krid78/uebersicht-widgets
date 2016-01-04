# vim: ts=2:sts=2:sw=2
# show calendar of this month

command: 'python calendar.widget/cal.py monday'

# refersh every 30 minutes
refreshFrequency: 1800000

style: """
  bgcol(l=1, a=1)
    if l == 1
      base3(a)
    else
      base03(a)
  bghcol(l=1, a=1)
    if l == 1
      base2(a)
    else
      base02(a)
  fgcol(l=1, a=1)
    if l == 1
      base0(a)
    else
      base00(a)
  fghcol(l=1, a=1)
    if l == 1
      base01(a)
    else
      base1(a)
  comment(l=1, a=1)
    if l == 1
      base1(a)
    else
      base01(a)
  base03(a=1)
    rgba(00,43,54,a)    // #002b36 dark: bg
  base02(a=1)
    rgba(07,54,66,a)    // #073642 dark: bg highlight
  base01(a=1)
    rgba(88,110,117,a)  // #586e75 light: emphasized; dark: comment
  base00(a=1)
    rgba(101,123,131,a) // #657b83 light: std. text
  base0(a=1)
    rgba(131,148,150,a) // #839496 dark: std. text
  base1(a=1)
    rgba(147,161,161,a) // #93a1a1 light: comment; dark: emphasized
  base2(a=1)
    rgba(238,232,213,a) // #eee8d5 light: bg highlight
  base3(a=1)
    rgba(253,246,227,a) // #fdf6e3 light: bg
  syellow(a=1)
    rgba(181,137,0,a) // #b58900
  sorange(a=1)
    rgba(203,75,22,a) // #cb4b16
  sred(a=1)
    rgba(220,50,47,a) // #dc322f
  smagenta(a=1)
    rgba(211,54,130,a) // #d33682
  sviolet(a=1)
    rgba(108,113,196,a) // #6c71c4
  sblue(a=1)
    rgba(38,139,210,a) // #268bd2
  scyan(a=1)
    rgba(42,161,152,a) // #2aa198
  sgreen(a=1)
    rgba(133,153,0,a) // #859900

  // Position this where you want
  top 1%
  right 10%
  //transform translate(-50%, 0)

  // Statistics text settings
  color: fgcol(1)
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px

  table
    border-collapse: collapse
    table-layout: fixed

  td
    text-align: center
    padding: 4px 6px
    //text-shadow: 0 0 1px rgba(#000, 0.5)

  thead tr
    &:first-child td
      font-size  1.17em
      font-weight 200
    //border-top solid 1px bghcol(.25)
    //border-bottom solid 1px bghcol(.25)

    &:last-child td
      font-size: 0.95em
      padding-bottom: 10px
      font-weight: 500

  tbody td
    font-size: 1em

  .today
    font-weight bold
    //background bghcol(.5)
    background rgba(#000,.25)
    border-radius 45%
"""

render: -> """
  <table>
    <thead>
    </thead>
    <tbody>
    </tbody>
  </table>
"""

updateHeader: (rows, table) ->
  thead = table.find("thead")
  thead.empty()

  thead.append "<tr><td colspan='7'>#{rows[0]}</td></tr>"
  tableRow = $("<tr></tr>").appendTo(thead)
  daysOfWeek = rows[1].split(/\s+/)

  for dayOfWeek in daysOfWeek
    tableRow.append "<td>#{dayOfWeek}</td>"

updateBody: (rows, table) ->
  tbody = table.find("tbody")
  tbody.empty()

  rows.splice 0, 2
  rows.pop()
  today = rows.pop().split(/\s+/)[2]

  for week, i in rows
    days = week.split(/\s+/).filter (day) -> day.length > 0
    tableRow = $("<tr></tr>").appendTo(tbody)

    if i == 0 and days.length < 7
      for j in [days.length...7]
        tableRow.append "<td></td>"

    for day in days
      cell = $("<td>#{day}</td>").appendTo(tableRow)
      cell.addClass("today") if day == today

update: (output, domEl) ->
  rows = output.split("\n")
  table = $(domEl).find("table")

  @updateHeader rows, table
  @updateBody rows, table
