/*
 *
 *  Copyright (C) 2000 Silicon Graphics, Inc.  All Rights Reserved. 
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  Further, this software is distributed without any warranty that it is
 *  free of the rightful claim of any third person regarding infringement
 *  or the like.  Any license provided herein, whether implied or
 *  otherwise, applies only to this software file.  Patent licenses, if
 *  any, provided herein do not apply to combinations of this program with
 *  other software, or any other product whatsoever.
 * 
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *  Contact information: Silicon Graphics, Inc., 1600 Amphitheatre Pkwy,
 *  Mountain View, CA  94043, or:
 * 
 *  http://www.sgi.com 
 * 
 *  For further information regarding this notice, see: 
 * 
 *  http://oss.sgi.com/projects/GenInfo/NoticeExplan/
 *
 */

/*------------------------------------------------------------
 *  This is an example from the Inventor Toolmaker,
 *  chapter 8, example 15.
 *
 *  Source file for "RotTransDragger" 
 *----------------------------------------------------------*/

#include <Inventor/nodes/SoRotation.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoSurroundScale.h>
#include <Inventor/nodes/SoAntiSquish.h>
#include <Inventor/sensors/SoFieldSensor.h>

// Include files for child dragger classes.
#include <Inventor/draggers/SoRotateCylindricalDragger.h>
#include "TranslateRadialDragger.h"

// Include file for our new class.
#include "RotTransDragger.h"

// This file contains RotTransDragger::geomBuffer, which 
// describes the default geometry resources for this class.
#include "RotTransDraggerGeom.h"

SO_KIT_SOURCE(RotTransDragger);


//  Initializes the type ID for this dragger node. This
//  should be called once after SoInteraction::init().
void
RotTransDragger::initClass()
{
   SO_KIT_INIT_CLASS(RotTransDragger, SoDragger, "Dragger");	
}

RotTransDragger::RotTransDragger()
{
   SO_KIT_CONSTRUCTOR(RotTransDragger);

   // Don't create "surroundScale" by default. It's only put 
   // to use if this dragger is used within a manipulator.
   SO_KIT_ADD_CATALOG_ENTRY(surroundScale, SoSurroundScale,
      TRUE, topSeparator, geomSeparator,TRUE);
   // Create an anti-squish node by default.
   SO_KIT_ADD_CATALOG_ENTRY(antiSquish, SoAntiSquish,
      FALSE, topSeparator, geomSeparator,TRUE);

   SO_KIT_ADD_CATALOG_ENTRY(translator, TranslateRadialDragger,
      TRUE, topSeparator, geomSeparator,TRUE);

   SO_KIT_ADD_CATALOG_ENTRY(XRotatorSep, SoSeparator,
      FALSE, topSeparator, geomSeparator,FALSE);
   SO_KIT_ADD_CATALOG_ENTRY(XRotatorRot, SoRotation,
      TRUE, XRotatorSep,\x0 ,FALSE);
   SO_KIT_ADD_CATALOG_ENTRY(XRotator, 
      SoRotateCylindricalDragger, TRUE, XRotatorSep,\x0 ,TRUE);

   SO_KIT_ADD_CATALOG_ENTRY(YRotator, 
      SoRotateCylindricalDragger, TRUE, topSeparator, 
      geomSeparator, TRUE);

   SO_KIT_ADD_CATALOG_ENTRY(ZRotatorSep, SoSeparator,
      FALSE, topSeparator, geomSeparator,FALSE);
   SO_KIT_ADD_CATALOG_ENTRY(ZRotatorRot, SoRotation,
      TRUE, ZRotatorSep,\x0 ,FALSE);
   SO_KIT_ADD_CATALOG_ENTRY(ZRotator, 
      SoRotateCylindricalDragger, TRUE, ZRotatorSep,\x0 ,TRUE);

   // Read geometry resources. Only do this the first time we
   // construct one. 'geomBuffer' contains our compiled in
   // defaults. The user can override these by specifying new
   // scene graphs in the file:
   // $(SO_DRAGGER_DIR)/rotTransDragger.iv"
   if (SO_KIT_IS_FIRST_INSTANCE())
      readDefaultParts("rotTransDragger.iv", geomBuffer, 
      sizeof(geomBuffer));

   // Fields that always show current state of the dragger.
   SO_KIT_ADD_FIELD(rotation, (0.0, 0.0, 0.0, 1.0));
   SO_KIT_ADD_FIELD(translation, (0.0, 0.0, 0.0));

   // Creates parts list and default parts for this nodekit.
   SO_KIT_INIT_INSTANCE();

   // Make the anti-squish node surround the biggest dimension
   SoAntiSquish *myAntiSquish 
      = SO_GET_ANY_PART(this, "antiSquish", SoAntiSquish);
   myAntiSquish->sizing = SoAntiSquish::BIGGEST_DIMENSION;

   // Create the simple draggers that comprise this dragger.
   // This dragger has four simple pieces:  
   //    1 TranslateRadialDragger
   //    3 RotateCylindricalDraggers
   // In the constructor, we just call SO_GET_ANY_PART to
   // build each dragger.
   // Within the setUpConnections() method, we will
   // take care of giving these draggers new geometry and 
   // establishing their callbacks.

   // Create the translator dragger.    
   SoDragger *tDragger = SO_GET_ANY_PART(this, "translator", 
      TranslateRadialDragger);

   // Create the XRotator dragger.    
   SoDragger *XDragger = SO_GET_ANY_PART(this, "XRotator", 
      SoRotateCylindricalDragger);

   // Create the YRotator dragger.    
   SoDragger *YDragger = SO_GET_ANY_PART(this, "YRotator", 
      SoRotateCylindricalDragger);

   // Create the ZRotator dragger.    
   SoDragger *ZDragger = SO_GET_ANY_PART(this, "ZRotator", 
      SoRotateCylindricalDragger);

   // Set rotations in "XRotatorRot" and "ZRotatorRot" parts.
   // These parts will orient the draggers from their default 
   // (rotating about Y) to the desired configurations.
   // By calling 'setAnyPartAsDefault' instead of 'setAnyPart'
   // we insure that they will not be written out, unless
   // they are changed later on.
   SoRotation *XRot = new SoRotation;
   XRot->rotation.setValue(
      SbRotation(SbVec3f(0,1,0), SbVec3f(1,0,0)));
   setAnyPartAsDefault("XRotatorRot", XRot);

   SoRotation *ZRot = new SoRotation;
   ZRot->rotation.setValue(
      SbRotation(SbVec3f(0,1,0), SbVec3f(0,0,1)));
   setAnyPartAsDefault("ZRotatorRot", ZRot);

   // Updates the fields when motionMatrix changes 
   addValueChangedCallback(&RotTransDragger::valueChangedCB);

   // Updates motionMatrix when either field changes.
   rotFieldSensor = new SoFieldSensor(
      &RotTransDragger::fieldSensorCB, this);
   rotFieldSensor->setPriority(0);
   translFieldSensor = new SoFieldSensor(
      &RotTransDragger::fieldSensorCB,this);
   translFieldSensor->setPriority(0);

   setUpConnections( TRUE, TRUE );
}

RotTransDragger::~RotTransDragger()
{
   if (rotFieldSensor)
      delete rotFieldSensor;
   if (translFieldSensor)
      delete translFieldSensor;
}


SbBool
RotTransDragger::setUpConnections( SbBool onOff, 
			    SbBool doItAlways)
{
   if ( !doItAlways && connectionsSetUp == onOff)
      return onOff;

   if (onOff) {
      // We connect AFTER base class.
      SoDragger::setUpConnections(onOff, doItAlways);

      // For each of the simple draggers that compries this:
      // [a]Call setPart after looking up our replacement parts 
      //    in the global dictionary.
      // [b]Add the invalidateSurroundScaleCB as a start and end
      //    callback. When using a surroundScale node, these 
      //    trigger it to recalculate a bounding box at the 
      //    beginning and end of dragging.
      // [c]Register the dragger as a 'childDragger' of this 
      //    one. This has the following effects: 
      //    [1] This dragger's callbacks will be invoked 
      //        following the child manip's callbacks.  
      //    [2] When the child is dragged, the child's motion 
      //        will be transferred into motion of the entire 
      //        dragger.
       SoDragger *tD 
	  = (SoDragger *) getAnyPart("translator", FALSE);
       // [a] Set up the parts in the child dragger...
       tD->setPartAsDefault("translator",
	  "rotTransTranslatorTranslator");
       tD->setPartAsDefault("translatorActive",
	  "rotTransTranslatorTranslatorActive");
       tD->setPartAsDefault("feedback",
	  "rotTransTranslatorFeedback");
       tD->setPartAsDefault("feedbackActive",
	  "rotTransTranslatorFeedbackActive");
       // [b] and [c] Add the callbacks and register the child
       tD->addStartCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       tD->addFinishCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       registerChildDragger(tD);

       SoDragger *XD 
	  = (SoDragger *) getAnyPart("XRotator", FALSE);
       // [a] Set up the parts in the child dragger...
       XD->setPartAsDefault("rotator",
	  "rotTransRotatorRotator");
       XD->setPartAsDefault("rotatorActive",
	  "rotTransRotatorRotatorActive");
       XD->setPartAsDefault("feedback",
	  "rotTransRotatorFeedback");
       XD->setPartAsDefault("feedbackActive",
	  "rotTransRotatorFeedbackActive");
       // [b] and [c] Add the callbacks and register the child
       XD->addStartCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       XD->addFinishCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       registerChildDragger(XD);

       SoDragger *YD 
	  = (SoDragger *) getAnyPart("YRotator", FALSE);
       // [a] Set up the parts in the child dragger...
       YD->setPartAsDefault("rotator",
	  "rotTransRotatorRotator");
       YD->setPartAsDefault("rotatorActive",
	  "rotTransRotatorRotatorActive");
       YD->setPartAsDefault("feedback",
	  "rotTransRotatorFeedback");
       YD->setPartAsDefault("feedbackActive",
	  "rotTransRotatorFeedbackActive");
       // [b] and [c] Add the callbacks and register the child
       YD->addStartCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       YD->addFinishCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       registerChildDragger(YD);

       SoDragger *ZD 
	  = (SoDragger *) getAnyPart("ZRotator", FALSE);
       // [b] Set up the parts in the child dragger...
       ZD->setPartAsDefault("rotator",
	  "rotTransRotatorRotator");
       ZD->setPartAsDefault("rotatorActive",
	  "rotTransRotatorRotatorActive");
       ZD->setPartAsDefault("feedback",
	  "rotTransRotatorFeedback");
       ZD->setPartAsDefault("feedbackActive",
	  "rotTransRotatorFeedbackActive");
       // [c] and [d] Add the callbacks and register the child
       ZD->addStartCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       ZD->addFinishCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       registerChildDragger(ZD);


      // Call the sensor CB to make things up-to-date.
      fieldSensorCB(this, NULL);

      // Connect the field sensors
      if (translFieldSensor->getAttachedField() != &translation)
	 translFieldSensor->attach( &translation );
      if (rotFieldSensor->getAttachedField() != &rotation)
	 rotFieldSensor->attach( &rotation );
   }
   else {
      // We disconnect BEFORE base class.

      // Remove the callbacks from the child draggers,
      // and unregister them as children.
       SoDragger *tD 
	  = (SoDragger *) getAnyPart("translator", FALSE);
       tD->removeStartCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       tD->removeFinishCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       unregisterChildDragger(tD);

       SoDragger *XD 
	  = (SoDragger *) getAnyPart("XRotator", FALSE);
       XD->removeStartCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       XD->removeFinishCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       unregisterChildDragger(XD);

       SoDragger *YD 
	  = (SoDragger *) getAnyPart("YRotator", FALSE);
       YD->removeStartCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       YD->removeFinishCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       unregisterChildDragger(YD);

       SoDragger *ZD 
	  = (SoDragger *) getAnyPart("ZRotator", FALSE);
       ZD->removeStartCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       ZD->removeFinishCallback(
	  &RotTransDragger::invalidateSurroundScaleCB, this);
       unregisterChildDragger(ZD);

      // Disconnect the field sensors.
      if (translFieldSensor->getAttachedField())
	translFieldSensor->detach();
      if (rotFieldSensor->getAttachedField())
	rotFieldSensor->detach();

      SoDragger::setUpConnections(onOff, doItAlways);
   }

   return !(connectionsSetUp = onOff);
}


// Called when the motionMatrix changes. Sets the "translation"
// and "rotation" fields based on the new motionMatrix
void
RotTransDragger::valueChangedCB(void *, SoDragger *inDragger)
{
   RotTransDragger *myself = (RotTransDragger *) inDragger;

   // Factor the motionMatrix into its parts
   SbMatrix motMat = myself->getMotionMatrix();
   SbVec3f   trans, scale;
   SbRotation rot, scaleOrient;
   motMat.getTransform(trans, rot, scale, scaleOrient);

   // Set the fields. Disconnect the sensors while doing so.
   myself->rotFieldSensor->detach();
   myself->translFieldSensor->detach();
   if (myself->rotation.getValue() != rot)
      myself->rotation = rot;
   if (myself->translation.getValue() != trans)
      myself->translation = trans;
   myself->rotFieldSensor->attach(&(myself->rotation));
   myself->translFieldSensor->attach(&(myself->translation));
}

// If the "translation" or "rotation" field changes, changes
// the motionMatrix accordingly.
void
RotTransDragger::fieldSensorCB(void *inDragger, SoSensor *)
{
   RotTransDragger *myself = (RotTransDragger *) inDragger;

   SbMatrix motMat = myself->getMotionMatrix();
   myself->workFieldsIntoTransform(motMat);

   myself->setMotionMatrix(motMat);
}

// When any child dragger starts or ends a drag, tell the
// "surroundScale" part (if it exists) to invalidate its 
// current bounding box value.
void 
RotTransDragger::invalidateSurroundScaleCB(void *parent, 
   SoDragger *)
{
   RotTransDragger *myParentDragger 
      = (RotTransDragger *) parent;

   // Invalidate the surroundScale, if it exists.
   SoSurroundScale *mySS = SO_CHECK_PART(
      myParentDragger, "surroundScale", SoSurroundScale);
   if (mySS != NULL)
      mySS->invalidate();
}

void
RotTransDragger::setDefaultOnNonWritingFields()
{
    // These nodes pointed to by these part-fields may 
    // change after construction, but we
    // don't want to write them out.
    surroundScale.setDefault(TRUE);
    antiSquish.setDefault(TRUE);

    SoDragger::setDefaultOnNonWritingFields();
}
