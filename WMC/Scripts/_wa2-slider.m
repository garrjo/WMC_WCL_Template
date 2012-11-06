/*---------------------------------------------------
-----------------------------------------------------
Filename:	_wa2-slider.m
Version:	1.0

Type:		maki/slider
Date:		25. Oct. 2012 - 23:11 
Author:		Pieter Nieuwoudt (pjn123)
E-Mail:		pjn123@outlook.com
Internet:	www.skinconsortium.com

Note:		Script will change the frame of the animation when you change a slider.
			When the value is outside the minPos & maxPos the animationlayer will hide.
			So you can use this to your advantage.

			Takes 4 parameters:
			param="animatedlayerID;sliderID;minPOS;maxPOS"

Examples:
			<!--
				Winamp 2 style Volume bar
			-->
			<animatedlayer id="volumeani" image="wa2.player.vol.main" x="107" y="57" w="68" h="13" frameheight="15"/>
			<slider id="Volume"	action="VOLUME"	x="108" y="57" w="68" h="13" thumb="wa2.player.vol.slider.normal" downThumb="wa2.player.vol.slider.pressed"/>
			<script file="scripts/_wa2-slider.maki" param="volumeani;Volume;0;255"/> <!-- param="animatedlayerID;sliderID;minPOS;maxPOS" -->

			<!--
				Winamp 2 Balance bar
			-->
			<animatedlayer id="panani1" image="wa2.player.bal.main" x="177" y="57" w="38" h="14" frameheight="15" autoplay="0"/>
			<animatedlayer id="panani2" image="wa2.player.bal.main" x="177" y="57" w="38" h="14" frameheight="15" autoplay="0"/>
			<slider id="Pan" action="PAN" x="177" y="57" w="38" h="13" thumb="wa2.player.bal.slider.normal" downThumb="wa2.player.bal.slider.pressed"/>
			<script file="scripts/_wa2-slider.maki" param="panani1;Pan;126;0"/> <!-- param="animatedlayerID;sliderID;minPOS;maxPOS" -->
			<script file="scripts/_wa2-slider.maki" param="panani2;Pan;127;255"/> <!-- param="animatedlayerID;sliderID;minPOS;maxPOS" -->

			<!--
				Winamp 2 Eq slider bar
				- Remember the eq gfx in wa2 skins have two rows of images.
				- If there was just one row of images you could do the animation similar to the volume bar but changing the min/max values to -127/127
			-->
			<rect x="15" y="30" w="25" h="75"/>
			<animatedlayer id="preamp_ani1" image="eqsliders1" x="21" y="38" w="14" h="64" framewidth="15"/>
			<animatedlayer id="preamp_ani2" image="eqsliders2" x="21" y="38" w="14" h="64" framewidth="15"/>
			<slider id="preamp"	action="EQ_PREAMP" x="22" y="38" w="11" h="62" orientation="vertical" thumb="wa2.player.eq.slider.up" downThumb="wa2.player.eq.slider.down"/>
			<script file="scripts/_wa2-slider.maki" param="preamp_ani1;preamp;-127;-1"/> <!-- param="animatedlayerID;sliderID;minPOS;maxPOS" -->
			<script file="scripts/_wa2-slider.maki" param="preamp_ani2;preamp;0;127"/> <!-- param="animatedlayerID;sliderID;minPOS;maxPOS" -->
-----------------------------------------------------
---------------------------------------------------*/

#include <lib/std.mi>

Global Group myGroup;
Global AnimatedLayer myAnim;
Global Slider mySlider;
Global int i_min, i_max, i_temp;
Global boolean b_invert;

System.onScriptLoaded()
{
	myGroup = getScriptGroup();
	myAnim = myGroup.findObject(getToken(getParam(),";",0));
	mySlider = myGroup.findObject(getToken(getParam(),";",1));
	i_min = stringToInteger(getToken(getParam(),";",2));
	i_max = stringToInteger(getToken(getParam(),";",3));
	
	//Make sure user gives right xml parameters
	myAnim.setAutoReplay(false);
	
	if(i_min>i_max){
		b_invert=true;
	}
	
	mySlider.onSetPosition(mySlider.getPosition());
}

mySlider.onPostedPosition(int newpos)
{
	mySlider.onSetPosition(newpos);
}

mySlider.onSetPosition(int newpos)
{
	if(b_invert){
		if(newpos>i_min || newpos<i_max)
		{
			myAnim.hide();
			return;
		}
		else myAnim.show();
		
		i_temp = (myAnim.getLength()-1)-((newpos-i_max)/(i_min-i_max)*(myAnim.getLength()-1));
		myAnim.gotoFrame(i_temp);
	}
	else{
		if(newpos<i_min || newpos>i_max)
		{
			myAnim.hide();
			return;
		}
		else myAnim.show();
		
		
		i_temp = (newpos-i_min)/(i_max-i_min)*(myAnim.getLength()-1);
		//System.setClipboardText(integerToString(newpos));
		myAnim.gotoFrame(i_temp);
	}
//.getLength()

	//myAnim
}

/*
pre.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  pre_layer.setXMLParam("image", XMLtext);

}

eq1.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq1back.setXMLParam("image", XMLtext);

}
eq2.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq2back.setXMLParam("image", XMLtext);

}
eq3.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq3back.setXMLParam("image", XMLtext);

}
eq4.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq4back.setXMLParam("image", XMLtext);

}
eq5.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq5back.setXMLParam("image", XMLtext);

}
eq6.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq6back.setXMLParam("image", XMLtext);

}
eq7.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq7back.setXMLParam("image", XMLtext);

}
eq8.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq8back.setXMLParam("image", XMLtext);

}
eq9.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq9back.setXMLParam("image", XMLtext);

}
eq10.onSetPosition(int newpos)
{
  XMLtext = "wa2.player.eq.slider"+integerToString(GetSliderValue(newpos));
  eq10back.setXMLParam("image", XMLtext);
}

int GetSliderValue(Int CurrentSlider)
{
  if(CurrentSlider<=-1)
  {
   CurrentSlider = ((CurrentSlider*27)/255)-1;
  }
  else if(CurrentSlider>=0)
  {
    CurrentSlider = ((CurrentSlider*27)/255)+1;
  }
  return CurrentSlider;
}*/