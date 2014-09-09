command: "ps -arcwwwxo \"command %cpu\""

refreshFrequency: 5000

style: """
  //@import 'calendar.widget/solarized.styl'
  base03(a=1)
    rgba(00,43,54,a) // #002b36
  base02(a=1)
    rgba(07,54,66,a) // #073642
  base01(a=1)
    rgba(88,110,117,a) // #586e75
  base00(a=1)
    rgba(101,123,131,a) // #657b83
  base0(a=1)
    rgba(131,148,150,a) // #839496
  base1(a=1)
    rgba(147,161,161,a) // #93a1a1
  base2(a=1)
    rgba(238,232,213,a) // #eee8d5
  base3(a=1)
    rgba(253,246,227,a) // #fdf6e3
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
  bottom 1%
  left 2%

  // Statistics text settings
  color: base0()
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px

  .container
    width 180px

  .widget-title
    text-align: center
    padding 4px 6px
    margin-bottom 1ex
    font-size  1.17em
    font-weight 200
    border-top solid 1px base02()
    border-bottom solid 1px base02()
    //background-color base02()
    //border-radius 5px

  table
    border-collapse collapse
    width 100%

  .process
    text-align left

  .loadl
    text-align right
    width 6px

  .load
    text-align right
    width 15px

  .loadr
    text-align right
    width 15px

  .load-xhuge
    color sred()

  .load-huge
    color smagenta()

  .load-high
    color sorange()

  .load-increased
    color syellow()

  .load-raised
    color base1()

  .load-normal
    color base0()


"""

render: -> """
  <div class="container">
    <div class="widget-title">Top CPU Processes</div>
    <table class="cpustats">
      <tbody>
      </tbody>
    </table>
  </div>
"""

updateBody: (tbody, rows) ->
  for row in rows
    tableRow = $("<tr></tr>").appendTo(tbody)

    cells = row.split(/\s+/)

    process = cells[0..-2]
    if process.length > 15
      process = process[0..12] + "..."

    load = parseFloat(cells[-1..]).toFixed(1)
    if load > 100
      tableRow.addClass("load-xhuge")
    else if load > 80
      tableRow.addClass("load-huge")
    else if load > 60
      tableRow.addClass("load-high")
    else if load > 40
      tableRow.addClass("load-increased")
    else if load > 20
      tableRow.addClass("load-raised")
    else
      tableRow.addClass("load-normal")


    tableRow.append "<td class=\"process\">#{cells[0]}</td>"
    tableRow.append "<td class=\"loadl\">(</td>"
    tableRow.append "<td class=\"load\">#{load}</td>"
    tableRow.append "<td class=\"loadr\">%)</td>"

update: (output, domEl) ->
  table = $(domEl).find("table")
  tbody = table.find("tbody")
  tbody.empty()

  lines = output.split("\n")

  @updateBody(tbody, lines[1..10])

# vim: ts=2:sts=2:sw=2
