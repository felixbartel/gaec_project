/*=============================================================================
Blobby Volley 2
Copyright (C) 2006 Jonathan Sieber (jonathan_sieber@yahoo.de)
Copyright (C) 2006 Daniel Knobe (daniel-knobe@web.de)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
=============================================================================*/

/* header include */
#include "SoundManager.h"

/* includes */
#include <iostream>
#include <cassert>

#include "Global.h"
#include "FileRead.h"

/* implementation */
SoundManager* SoundManager::mSingleton;

bool SoundManager::playSound(const std::string& filename, float volume)
{
	return true;
}

bool SoundManager::init()
{
	mInitialised = true;
	return true;
}

void SoundManager::deinit()
{
	mInitialised = false;
}

SoundManager* SoundManager::createSoundManager()
{
	return new SoundManager();
}

SoundManager::SoundManager()
{
	mSingleton = this;
	mInitialised = false;
}

SoundManager::~SoundManager()
{
	if (mInitialised)
	{
		deinit();
	}
}

SoundManager& SoundManager::getSingleton()
{
	assert(mSingleton);
	return *mSingleton;
}

void SoundManager::setVolume(float volume)
{
}

void SoundManager::setMute(bool mute)
{
}
