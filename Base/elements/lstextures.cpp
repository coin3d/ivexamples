/**************************************************************************\
 * Copyright (c) Kongsberg Oil & Gas Technologies AS
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
\**************************************************************************/

// The purpose of this file is to make a small wrapper "tool" around
// the TextureFilenameElement extension element, just for showing
// example code on how to make use of a user-defined custom element.
//
// The code goes like this:
//
// We initialize the element, enable it for the SoCallbackAction, read
// a scene graph file, set callbacks on SoTexture2 and all shape nodes
// and applies the SoCallbackAction. The callbacks will then print out
// the texture filename information from the TextureFilenameElement
// each time an interesting node is hit.
//
//
// Check the code in texturefilenameelement.cpp for further
// information on how to construct your own elements.
//
//
// Code by Peder Blekken <pederb@sim.no>. Cleaned up, integrated in
// Coin distribution and commented by Morten Eriksen <mortene@sim.no>.
// 1999-12-09.

#include <Inventor/SoDB.h>
#include <Inventor/SoInput.h>
#include <Inventor/actions/SoCallbackAction.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoTexture2.h>
#include <Inventor/nodes/SoShape.h>
#include <Inventor/misc/SoState.h>
#include <stdio.h>

#include "texturefilenameelement.h"


SoCallbackAction::Response
pre_tex2_cb(void * data, SoCallbackAction * action, const SoNode * node)
{
  const SbString & filename = ((SoTexture2 *)node)->filename.getValue();
  TextureFilenameElement::set(action->getState(), (SoNode *)node, filename);

  (void)fprintf(stdout, "=> New texture: %s\n",
                filename.getLength() == 0 ?
                "<inlined>" : filename.getString());

  return SoCallbackAction::CONTINUE;
}

SoCallbackAction::Response
pre_shape_cb(void * data, SoCallbackAction * action, const SoNode * node)
{
  const SbString & filename =
    TextureFilenameElement::get(action->getState());

  (void)fprintf(stdout, "   Texturemap on %s: %s\n",
                node->getTypeId().getName().getString(),
                filename.getLength() == 0 ?
                "<inlined>" : filename.getString());

  return SoCallbackAction::CONTINUE;
}

void
usage(const char * appname)
{
  (void)fprintf(stderr, "\n\tUsage: %s <modelfile.iv>\n\n", appname);
  (void)fprintf(stderr,
                "\tLists all texture filenames in the model file,\n"
                "\tand on which shape nodes they are used.\n\n"
                "\tThe purpose of this example utility is simply to\n"
                "\tshow how to create and use an extension element for\n"
                "\tscene graph traversal.\n\n");
}

int
main(int argc, char ** argv)
{
  if (argc != 2) {
    usage(argv[0]);
    exit(1);
  }

  SoDB::init();

  TextureFilenameElement::initClass();
  SO_ENABLE(SoCallbackAction, TextureFilenameElement);

  SoInput input;
  if (!input.openFile(argv[1])) {
    (void)fprintf(stderr, "ERROR: couldn't open file ``%s''.\n", argv[1]);
    exit(1);
  }

  SoSeparator * root = SoDB::readAll(&input);
  if (root) {
    root->ref();
    SoCallbackAction cbaction;
    cbaction.addPreCallback(SoTexture2::getClassTypeId(), pre_tex2_cb, NULL);
    cbaction.addPreCallback(SoShape::getClassTypeId(), pre_shape_cb, NULL);
    cbaction.apply(root);
    root->unref();
    return 0;
  }
  return 1;
}
