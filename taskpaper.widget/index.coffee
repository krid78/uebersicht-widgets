# vim: ts=2:sts=2:sw=2
# show taskpaper tasks

command: "python taskpaper.widget/taskpaperdaily.py --json --all"

# refersh every 15 minutes
refreshFrequency: 900000

style: """
  // the base color selector light or dark
  the-bg = "dark"

  // the actual color definition. For base16, its done in a quite generic way...
  base00(a=1)     // dark: bg
    rgba(00,43,54,a)    // #002b36
  base01(a=1)     // dark: bg highlight
    rgba(07,54,66,a)    // #073642
  base02(a=1)     // light: emphasized; dark: comment
    rgba(88,110,117,a)  // #586e75
  base03(a=1)     // light: std. text
    rgba(101,123,131,a) // #657b83
  base04(a=1)     // dark: std. text
    rgba(131,148,150,a) // #839496
  base05(a=1)     // light: comment; dark: emphasized
    rgba(147,161,161,a) // #93a1a1
  base06(a=1)     // light: bg highlight
    rgba(238,232,213,a) // #eee8d5
  base07(a=1)     // light: bg
    rgba(253,246,227,a) // #fdf6e3
  base08(a=1)     // syellow
    rgba(181,137,0,a)   // #b58900
  base09(a=1)     // sorange
    rgba(203,75,22,a)   // #cb4b16
  base0A(a=1)     // sred
    rgba(220,50,47,a)   // #dc322f
  base0B(a=1)     // smagenta
    rgba(211,54,130,a)  // #d33682
  base0C(a=1)     // sviolet
    rgba(108,113,196,a) // #6c71c4
  base0D(a=1)     // sblue
    rgba(38,139,210,a)  // #268bd2
  base0E(a=1)     // scyan
    rgba(42,161,152,a)  // #2aa198
  base0F(a=1)     // sgreen
    rgba(133,153,0,a)   // #859900

  // generic, selector-dependend color selection
  bgcol(a=1)
    if the-bg == "light"
      base07(a)
    else
      base01(a)
  bghcol(a=1)
    if the-bg == "light"
      base06(a)
    else
      base01(a)
  fgcol(a=1)
    if the-bg == "light"
      base03(a)
    else
      base04(a)
  fghcol(a=1)
    if the-bg == "light"
      base02(a)
    else
      base05(a)
  comment(a=1)
    if the-bg == "light"
      base05(a)
    else
      base02(a)

  // solarized equivalenz wrapper
  syellow(a=1)
    base08(a)
  sorange(a=1)
    base09(a)
  sred(a=1)
    base0A(a)
  smagenta(a=1)
    base0B(a)
  sviolet(a=1)
    base0C(a)
  sblue(a=1)
    base0D(a)
  scyan(a=1)
    base0E(a)
  sgreen(a=1)
    base0F(a)

  // Position this where you want
  top 1%
  left 2%

  // Statistics text settings
  color: fgcol()
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px
  width 30%
  //border solid 1px bghcol()

  .container
    margin 0px
    //width 220px
    //border solid 1px bghcol()

  .tlist-head
    padding 4px 6px
    margin-bottom 1ex
    text-transform uppercase
    font-size 1.1em
    font-weight 200
    width 60%
    //border-top solid 1px bghcol(.25)
    //border-bottom solid 1px bghcol(.25)
    //background-color bghcol(.5)
    //border-radius 5px

  ul
    padding 0px
    margin auto 0px 2% 0px

  li
    padding 0.4%
    margin 0px
    list-style none
    //border solid 1px bghcol()

  ul li:before
    content '»'
    margin 0 .6em

  ul.today li:before
    color scyan()

  ul.tomorrow li:before
    color sgreen()

  ul.overdue li:before
    color sred()

  ul.urgent li:before
    color smagenta()

  ul.upcomming li:before
    color sblue()

  ul.outdated li:before
    color syellow()

  ul.someday li:before
    //color syellow()

"""

render: -> """
  <div class="container">
    <div id="tasklists">
    </div>
  </div>
"""

update: (output, domEl) ->
  tasklists = JSON.parse output
  container = $(domEl).find("#tasklists")
  container.empty()
  # for tlist of tasklists
  for tlist in ['today', 'tomorrow', 'overdue', 'urgent', 'upcomming', 'outdated', 'someday']
    if tasklists[tlist].length < 1
      continue
    # console.log("tlist: "+tlist)
    headline = $("<div></div>").appendTo(container)
    headline.addClass("tlist-head")
    headline.append("#{tlist}")
    list = $("<ul></ul>").appendTo(container)
    list.addClass("#{tlist}")
    for task in tasklists[tlist]
      litem = $("<li></li>").appendTo(list)
      litem.append("#{task}")

# vim: ts=2:sts=2:sw=2
