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

  marbot = 2%

  // position
  top 200px
  left 1%
  //width 30%
  color base0()
  font-family Helvetica Neue
  font-size 12px
  //border solid 1px base02()

  .container
    margin 0px
    //width 220px
    //border solid 1px base02()

  .widget-title
    text-align: center
    padding 1px
    margin-bottom 1ex
    background-color base02()
    border-radius 5px

  .tlist-head
    padding-bottom .2em
    padding-left .2em
    max-width 60%
    margin-bottom 1ex
    font-size 13px
    font-style  normal
    font-variant  small-caps
    font-size  1.3em
    font-weight normal
    background-color base02()
    border-radius 5px
    //border solid 1px base02()

  ul
    padding 0px
    margin auto 0px marbot 0px

  li
    padding 0.4%
    margin 0px
    list-style none
    //font-weight 100
    //border solid 1px base02()

  ul li:before
    content '»'
    margin 0 1em

  ul.someday li:before
    color syellow()

  ul.someday li:before
    color syellow()

  ul.someday li:before
    color syellow()

  ul.someday li:before
    color syellow()

  ul.someday li:before
    color syellow()

"""

render: -> """
  <div class="container">
    <!--<div class="widget-title">TaskPaper Daily</div>-->
    <div id="tasklists">
    </div>
  </div>
"""

update: (output, domEl) ->
  tasklists = JSON.parse output
  container = $(domEl).find("#tasklists")
  console.log("tasklists: "+tasklists)
  for tlist of tasklists
    if tasklists[tlist].length < 1
      continue
    console.log("tlist: "+tlist)
    headline = $("<h2></h2>").appendTo(container)
    headline.addClass("tlist-head")
    headline.append("#{tlist}")
    list = $("<ul></ul>").appendTo(container)
    list.addClass("#{tlist}")
    for task in tasklists[tlist]
      litem = $("<li></li>").appendTo(list)
      litem.append("#{task}")

# vim: ts=2:sts=2:sw=2
