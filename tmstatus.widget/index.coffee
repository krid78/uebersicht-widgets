# vim: ts=2:sts=2:sw=2
###
This widget puts an indicator on the side of the screen that TimeMachine is running and show's is progress
as it runs. It will hide again with TimeMachine is completes. It parses tmutil status data for this information
and runs every 15 seconds - you may wish to change.
- refreshFrequency (15s)
- poitioning (Middle of left edge - transform translate(0,-50%))
- Font-name and size (although you'll need to fiddle with the line sizes etc I expect.)
- Font color and opacities to suit your desktop picture

The .revealer div essentially reduces in size by 1 - %complete to reveal the underlying
.indicator div based on the value of the "Percent =xxx" in the tmutil status output.
###

command: "tmutil status"

# every 15 seconds is probably unnecessary but I'm a bit OCD

refreshFrequency: 15000

render: (output)->"""
  <div class='container'>
    <div class='scale'><p>100% - </p><p>75% - </p><p>50% - </p><p>25% - </p><p>0% - </p></div>
    <div class='indicator-container'>
      <div class='revealer'></div>
      </div>
  </div>
  """

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
  right 10px
  top 50%
  transform translate(0, -50%)

  // Statistics text settings
  color fgcol()
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px

  .scale
    display inline-block
    //color: comment()

  .scale p
    text-align right
    line-height 50px

  .indicator-container
    display inline-block
    height 250px
    width 4px
    background-color sgreen()
    border-radius 2px
    margin-bottom 2px
    overflow hidden

  .revealer
    width 4px
    height 100%
    // background-color bghcol()
    background-color rgba(#000, .25)
    border-radius 2px
"""

update: (output, domEl) ->

  # if TimeMachine is running the show our block, if not hide it.

  if @isRunning(output)
    $(domEl).find('.container').css('display', 'block')
    $(domEl).find('.revealer').css('height', 100 - @percentComplete(output) + '%')
  else
    $(domEl).find('.container').css('display', 'none')

isRunning: (data) ->
  return (if data.match(/Running = \d;/)[0].match(/(\d+)/)[0] is '1' then true else false)

percentComplete: (data) ->
  return Math.round(Number(data.match?(/Percent = \"?([0-9.e-]*)\D/)[1]) * 100)

###
There are a few patterns here to deal with.
 - Percent = 0;
 - Percent = "-1"; (this one returns -100 which sets revealer to 200% which is an error, which works - HACK!!!)
 - Percent = "1";
 - Percent = "0.328473270";
 - Percent = "5.2340984e-34";

 So the regex is as follows.
  - Percent =
  - \"? is optional "
  - [0-9.e-]* gets all the characters in our numbers of various forms
  - \D is the trailing " or ; whichever is present
  - () gives us just the number string
###
# vim: ts=2:sts=2:sw=2
