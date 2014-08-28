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
		<div class='indicator-container'>
			<div class='revealer'></div>
		</div>
		<div class='scale'><p> - 100%</p><p> - 75%</p><p> - 50%</p><p> - 25%</p><p> - 0%</p></div>
	</div>
  """

style: """
  left: 0px
  top: 50%
  font-family: Helvetica Neue
  font-size: 11px
  color #aaa
  transform translate(0, -50%)
  	
  .scale
  	display inline-block
  	opacity 0.7
  
  .scale p
  	line-height 50px
   	
  .indicator-container
  	display inline-block
  	height 248px
  	width 1px
  	background-color white
  	opacity 0.5
  	margin-bottom 2px
  	overflow hidden
  	
  .revealer
  	width 1px
  	height 100%
  	background-color black
  	opacity 0.5
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
