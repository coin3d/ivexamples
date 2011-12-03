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

// The purpose of the code in this file is to demonstrate how you can
// make your own elements for scene graph traversals.
//
// See the description and source code in lstextures.cpp for an
// explanation on how new, user-defined extensions elements can be put
// to use.
//
// Code by Peder Blekken <pederb@sim.no>, 1999-12-09.

#include "texturefilenameelement.h"


SO_ELEMENT_SOURCE(TextureFilenameElement);


void
TextureFilenameElement::initClass(void)
{
  SO_ELEMENT_INIT_CLASS(TextureFilenameElement, inherited);
}

void
TextureFilenameElement::init(SoState * state)
{
  this->filename = "<none>";
}

TextureFilenameElement::~TextureFilenameElement()
{
}

void
TextureFilenameElement::set(SoState * const state, SoNode * const node,
                            const SbString & filename)
{
  TextureFilenameElement * elem = (TextureFilenameElement *)
    SoReplacedElement::getElement(state, classStackIndex, node);
  elem->setElt(filename);
}

const SbString &
TextureFilenameElement::get(SoState * const state)
{
  return TextureFilenameElement::getInstance(state)->filename;
}

void
TextureFilenameElement::setElt(const SbString & filename)
{
  this->filename = filename;
}

const TextureFilenameElement *
TextureFilenameElement::getInstance(SoState * state)
{
  return (const TextureFilenameElement *)
    SoElement::getConstElement(state, classStackIndex);
}
