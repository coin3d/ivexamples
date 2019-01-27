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

const char TranslateRadialDragger::geomBuffer[] = {
'\x23','\x49','\x6e','\x76','\x65','\x6e','\x74','\x6f','\x72','\x20','\x56','\x32','\x2e','\x31','\x20','\x62','\x69','\x6e','\x61','\x72','\x79','\x20','\x20','\xa','\x0','\x0','\x0','\x9','\x53','\x65','\x70','\x61','\x72','\x61','\x74','\x6f','\x72','\x0','\x0','\x0','\x0','\x0','\x0','\x2','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x4','\x0','\x0','\x0','\x3','\x44','\x45','\x46','\x0','\x0','\x0','\x0','\x19','\x74','\x72','\x61','\x6e','\x73','\x6c','\x61','\x74','\x65','\x52','\x61','\x64','\x69','\x61','\x6c','\x54','\x72','\x61','\x6e','\x73','\x6c','\x61','\x74','\x6f','\x72','\x0','\x0','\x0','\x0','\x0','\x0','\x9','\x53','\x65','\x70','\x61','\x72','\x61','\x74','\x6f','\x72','\x0','\x0','\x0','\x0','\x0','\x0','\x2','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x3','\x0','\x0','\x0','\x8','\x4d','\x61','\x74','\x65','\x72','\x69','\x61','\x6c','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x1','\x0','\x0','\x0','\xc','\x64','\x69','\x66','\x66','\x75','\x73','\x65','\x43','\x6f','\x6c','\x6f','\x72','\x0','\x0','\x0','\x1','\x3f','\x19','\x99','\x9a','\x3f','\x19','\x99','\x9a','\x3f','\x19','\x99','\x9a','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x9','\x44','\x72','\x61','\x77','\x53','\x74','\x79','\x6c','\x65','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x1','\x0','\x0','\x0','\x5','\x73','\x74','\x79','\x6c','\x65','\x0','\x0','\x0','\x0','\x0','\x0','\x5','\x4c','\x49','\x4e','\x45','\x53','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x6','\x53','\x70','\x68','\x65','\x72','\x65','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x1','\x0','\x0','\x0','\x6','\x72','\x61','\x64','\x69','\x75','\x73','\x0','\x0','\x3f','\xdd','\xb2','\x2d','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x3','\x44','\x45','\x46','\x0','\x0','\x0','\x0','\x1f','\x74','\x72','\x61','\x6e','\x73','\x6c','\x61','\x74','\x65','\x52','\x61','\x64','\x69','\x61','\x6c','\x54','\x72','\x61','\x6e','\x73','\x6c','\x61','\x74','\x6f','\x72','\x41','\x63','\x74','\x69','\x76','\x65','\x0','\x0','\x0','\x0','\x9','\x53','\x65','\x70','\x61','\x72','\x61','\x74','\x6f','\x72','\x0','\x0','\x0','\x0','\x0','\x0','\x2','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x3','\x0','\x0','\x0','\x8','\x4d','\x61','\x74','\x65','\x72','\x69','\x61','\x6c','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x1','\x0','\x0','\x0','\xc','\x64','\x69','\x66','\x66','\x75','\x73','\x65','\x43','\x6f','\x6c','\x6f','\x72','\x0','\x0','\x0','\x1','\x3f','\x19','\x99','\x9a','\x3f','\x19','\x99','\x9a','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x9','\x44','\x72','\x61','\x77','\x53','\x74','\x79','\x6c','\x65','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x1','\x0','\x0','\x0','\x5','\x73','\x74','\x79','\x6c','\x65','\x0','\x0','\x0','\x0','\x0','\x0','\x5','\x4c','\x49','\x4e','\x45','\x53','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x6','\x53','\x70','\x68','\x65','\x72','\x65','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x1','\x0','\x0','\x0','\x6','\x72','\x61','\x64','\x69','\x75','\x73','\x0','\x0','\x3f','\xdd','\xb2','\x2d','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x3','\x44','\x45','\x46','\x0','\x0','\x0','\x0','\x17','\x74','\x72','\x61','\x6e','\x73','\x6c','\x61','\x74','\x65','\x52','\x61','\x64','\x69','\x61','\x6c','\x46','\x65','\x65','\x64','\x62','\x61','\x63','\x6b','\x0','\x0','\x0','\x0','\x9','\x53','\x65','\x70','\x61','\x72','\x61','\x74','\x6f','\x72','\x0','\x0','\x0','\x0','\x0','\x0','\x2','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x3','\x44','\x45','\x46','\x0','\x0','\x0','\x0','\x1d','\x74','\x72','\x61','\x6e','\x73','\x6c','\x61','\x74','\x65','\x52','\x61','\x64','\x69','\x61','\x6c','\x46','\x65','\x65','\x64','\x62','\x61','\x63','\x6b','\x41','\x63','\x74','\x69','\x76','\x65','\x0','\x0','\x0','\x0','\x0','\x0','\x9','\x53','\x65','\x70','\x61','\x72','\x61','\x74','\x6f','\x72','\x0','\x0','\x0','\x0','\x0','\x0','\x2','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x3','\x0','\x0','\x0','\x8','\x4d','\x61','\x74','\x65','\x72','\x69','\x61','\x6c','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x1','\x0','\x0','\x0','\xc','\x64','\x69','\x66','\x66','\x75','\x73','\x65','\x43','\x6f','\x6c','\x6f','\x72','\x0','\x0','\x0','\x1','\x3f','\x0','\x0','\x0','\x3f','\x66','\x66','\x66','\x3f','\x66','\x66','\x66','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\xb','\x52','\x6f','\x74','\x61','\x74','\x69','\x6f','\x6e','\x58','\x59','\x5a','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x2','\x0','\x0','\x0','\x4','\x61','\x78','\x69','\x73','\x0','\x0','\x0','\x1','\x5a','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x5','\x61','\x6e','\x67','\x6c','\x65','\x0','\x0','\x0','\x3f','\xc9','\xf','\xa6','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x9','\x53','\x65','\x70','\x61','\x72','\x61','\x74','\x6f','\x72','\x0','\x0','\x0','\x0','\x0','\x0','\x2','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x6','\x0','\x0','\x0','\x8','\x43','\x79','\x6c','\x69','\x6e','\x64','\x65','\x72','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x2','\x0','\x0','\x0','\x6','\x72','\x61','\x64','\x69','\x75','\x73','\x0','\x0','\x3d','\x4c','\xcc','\xcd','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x6','\x68','\x65','\x69','\x67','\x68','\x74','\x0','\x0','\x40','\x80','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\xb','\x54','\x72','\x61','\x6e','\x73','\x6c','\x61','\x74','\x69','\x6f','\x6e','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x1','\x0','\x0','\x0','\xb','\x74','\x72','\x61','\x6e','\x73','\x6c','\x61','\x74','\x69','\x6f','\x6e','\x0','\x0','\x0','\x0','\x0','\x40','\xc','\xcc','\xcd','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x4','\x43','\x6f','\x6e','\x65','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x2','\x0','\x0','\x0','\xc','\x62','\x6f','\x74','\x74','\x6f','\x6d','\x52','\x61','\x64','\x69','\x75','\x73','\x3e','\x4c','\xcc','\xcd','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x6','\x68','\x65','\x69','\x67','\x68','\x74','\x0','\x0','\x3e','\xcc','\xcc','\xcd','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\xb','\x54','\x72','\x61','\x6e','\x73','\x6c','\x61','\x74','\x69','\x6f','\x6e','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x1','\x0','\x0','\x0','\xb','\x74','\x72','\x61','\x6e','\x73','\x6c','\x61','\x74','\x69','\x6f','\x6e','\x0','\x0','\x0','\x0','\x0','\xc0','\x8c','\xcc','\xcd','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\xb','\x52','\x6f','\x74','\x61','\x74','\x69','\x6f','\x6e','\x58','\x59','\x5a','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x2','\x0','\x0','\x0','\x4','\x61','\x78','\x69','\x73','\x0','\x0','\x0','\x1','\x5a','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x5','\x61','\x6e','\x67','\x6c','\x65','\x0','\x0','\x0','\x40','\x49','\xf','\xd0','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x4','\x43','\x6f','\x6e','\x65','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x2','\x0','\x0','\x0','\xc','\x62','\x6f','\x74','\x74','\x6f','\x6d','\x52','\x61','\x64','\x69','\x75','\x73','\x3e','\x4c','\xcc','\xcd','\x0','\x0','\x0','\x0','\x0','\x0','\x0','\x6','\x68','\x65','\x69','\x67','\x68','\x74','\x0','\x0','\x3e','\xcc','\xcc','\xcd','\x0','\x0','\x0','\x0'
};
