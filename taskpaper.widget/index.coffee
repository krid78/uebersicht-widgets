# show taskpaper tasks

command: "python taskpaper.widget/taskpaperdaily.py --json --all"

# refersh every 15 minutes
refreshFrequency: 900000

style: """
  //@import '/solarized.styl'
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

  flavour=light
  //flavour=dark

  // Position this where you want
  top 1%
  left 2%

  // Statistics text settings
  color: base00()
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px
  width 30%
  //border solid 1px slobghl(flavour)

  .container
    margin 0px
    //width 220px
    //border solid 1px base2()

  .tlist-head
    padding 4px 6px
    margin-bottom 1ex
    text-transform uppercase
    font-size 1.1em
    font-weight 200
    border-top solid 1px base2()
    border-bottom solid 1px base2()
    width 60%
    //background-color base2()
    //border-radius 5px

  ul
    padding 0px
    margin auto 0px 2% 0px

  li
    padding 0.4%
    margin 0px
    list-style none
    //border solid 1px base2()

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
  #for tlist of tasklists
  for tlist in ['today', 'tomorrow', 'overdue', 'urgent', 'upcomming', 'outdated', 'someday']
    if tasklists[tlist].length < 1
      continue
    console.log("tlist: "+tlist)
    headline = $("<div></div>").appendTo(container)
    headline.addClass("tlist-head")
    headline.append("#{tlist}")
    list = $("<ul></ul>").appendTo(container)
    list.addClass("#{tlist}")
    for task in tasklists[tlist]
      litem = $("<li></li>").appendTo(list)
      litem.append("#{task}")

# vim: ts=2:sts=2:sw=2
