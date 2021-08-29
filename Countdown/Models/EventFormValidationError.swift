//
//  EventFormValidationError.swift
//  Countdown
//
//  Created by Andre Hochschulte on 29.08.21.
//

import SwiftUI

enum EventFormValidationError: String {
    case eventNameIsEmpty = "add_event_form_event_name_empty_validation_error_text"
    case eventDateTimeIsInThePast = "add_event_form_event_datetime_past_validation_error_text"
}
