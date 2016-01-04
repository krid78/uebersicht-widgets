# vim: ts=2:sts=2:sw=2
# show topmost processes, colors indicate ram usage

command: "ps -amcwwwxo \"command rss %mem\""

# refersh every 5 seconds
refreshFrequency: 5000

style: """
  the-bg = "dark"
  bgcol(a=1)
    if the-bg == "light"
      base3(a)
    else
      base03(a)
  bghcol(a=1)
    if the-bg == "light"
      base2(a)
    else
      base02(a)
  fgcol(a=1)
    if the-bg == "light"
      base0(a)
    else
      base00(a)
  fghcol(a=1)
    if the-bg == "light"
      base01(a)
    else
      base1(a)
  comment(a=1)
    if the-bg == "light"
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
  bottom 1%
  left 20%
  //transform translate(-50%, 0)

  // Statistics text settings
  color fgcol()
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px

  .container
    width 220px

  .widget-title
    text-align: center
    padding 4px 6px
    margin-bottom 1ex
    font-size  1.17em
    font-weight 200
    //border-top solid 1px bghcol(.25)
    //border-bottom solid 1px bghcol(.25)
    //background-color bghcol(.5)
    //border-radius 5px

  table
    border-collapse collapse
    width 100%
    //table-layout fixed

  .process
    text-align left
    width 50%

  .memstr
    text-align right

  .mempl
    text-align right
    width 6px

  .memp
    text-align right

  .mempr
    text-align left
    width 15px

  .memp-xhuge
    color sred()

  .memp-huge
    color smagenta()

  .memp-high
    color sorange()

  .memp-increased
    color syellow()

  .memp-raised
    color fghcol()

  .memp-normal
    color fgcol()


"""

render: -> """
  <div class="container">
    <div class="widget-title">Top RAM Processes</div>
    <table class="ramstats">
      <tbody>
      </tbody>
    </table>
  </div>
"""

updateBody: (tbody, rows) ->
  for row in rows
    tableRow = $("<tr></tr>").appendTo(tbody)

    cells = row.split(/\s+/)

    process = cells[0..-3]
    if process.length > 15
      process = process[0..12] + "..."

    mem = parseInt(cells[-2..-1])
    if mem > 1048576
      memstr = (mem/1048576.0).toFixed(2) + "G"
    else if mem > 1024
      memstr = (mem/1024.0).toFixed(2) + "M"
    else
      memstr = mem.toFixed(2) + "k"

    memp = parseFloat(cells[-1..]).toFixed(1)
    if memp > 50
      tableRow.addClass("memp-xhuge")
    else if memp > 35
      tableRow.addClass("memp-huge")
    else if memp > 20
      tableRow.addClass("memp-high")
    else if memp > 10
      tableRow.addClass("memp-increased")
    else if memp > 5
      tableRow.addClass("memp-raised")
    else
      tableRow.addClass("memp-normal")


    tableRow.append "<td class=\"process\">#{cells[0]}</td>"
    tableRow.append "<td class=\"memstr\">#{memstr}</td>"
    tableRow.append "<td class=\"mempl\">(</td>"
    tableRow.append "<td class=\"memp\">#{memp}</td>"
    tableRow.append "<td class=\"mempr\">%)</td>"

update: (output, domEl) ->
  table = $(domEl).find("table")
  tbody = table.find("tbody")
  tbody.empty()

  lines = output.split("\n")

  @updateBody(tbody, lines[1..10])

# vim: ts=2:sts=2:sw=2
