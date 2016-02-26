//
//  MFCTrackingPathScanUpdateAction.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 2/23/16.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

class MFCTrackingPathScanUpdateAction: SequenceAction {

	let mfc: MFCSystem
	let mapper: MFCMapper

	init(mapper: MFCMapper) {
		self.mapper = mapper
		self.mfc = mapper.mfc
	}

}